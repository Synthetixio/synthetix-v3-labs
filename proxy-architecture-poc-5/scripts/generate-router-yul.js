const fs = require('fs');

const source = `//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Router {
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // GENERATED CODE - do not edit manually
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------

    fallback() external {
        // Lookup table: Function selector => implementation contract
        bytes4 sig4 = msg.sig;
        address implementation;
        assembly {
            let sig32 := shr(224, sig4)

            function findImplementation(sig) -> result {@router_targets
@router_switch
            }

            implementation := findImplementation(sig32)
        }

        require(implementation != address(0), "Unknown selector");

        // Delegatecall to the implementation contract
        assembly {
            calldatacopy(0, 0, calldatasize())

            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
}
`;

async function main() {
  const network = hre.network.name;
  console.log(`\nGenerating router for the ${network} network...`);

  // -------------------
  // Retrieve data file
  // -------------------

  const deploymentsFilePath = `./deployments/${network}.json`;
	const deployments = JSON.parse(fs.readFileSync(deploymentsFilePath));

  // ----------------------
  // Build @router_targets
  // ----------------------

  const modulesNames = Object.keys(deployments.modules);

  let routerTargets = '';
  for (let i = 0; i < modulesNames.length; i++) {
    const moduleName = modulesNames[i];
    const moduleAddress = deployments.modules[moduleName].implementation;

    routerTargets += `\n              let ${moduleName} := ${moduleAddress}`;
  }

  // ----------------------
  // Prepare selector data
  // ----------------------

  async function getSelectors(moduleName) {
    const contract = await ethers.getContractAt(moduleName, '0x0000000000000000000000000000000000000001');

    return contract.interface.fragments.reduce((selectors, fragment) => {
      if (fragment.type === "function") {
        selectors.push({
          name: fragment.name,
          selector: contract.interface.getSighash(fragment)
        });
      }

      return selectors;
    }, []);
  }

  let selectors = [];
  for (let i = 0; i < modulesNames.length; i++) {
    const moduleName = modulesNames[i];
    const moduleSelectors = await getSelectors(moduleName);

    moduleSelectors.map(moduleSelector => {
      if (selectors.some(s => s.selector === moduleSelector.selector)) {
        throw new Error(`Duplicate selector ${moduleSelector.name}`);
      }

      selectors.push({
        name: moduleSelector.name,
        selector: moduleSelector.selector,
        module: moduleName
      });
    });
  }

  selectors = selectors.sort((a, b) => {
    return parseInt(a.selector, 16) - parseInt(b.selector, 16);
  });

  // ---------------------
  // Build @router_switch
  // ---------------------

  const chunkSize = 5;

  let routerSwitch = '';
  for (let i = 0; i < selectors.length; i += chunkSize) {
    const chunk = selectors.slice(i, i + chunkSize);
    const last = chunk[chunk.length - 1];

    routerSwitch += `\n              if lt(sig,${last.selector}) {`
    routerSwitch += `\n                switch sig`

    for (let j = 0; j < chunk.length; j++) {
      const s= chunk[j];

      routerSwitch += `\n                case ${s.selector} { // ${s.module}.${s.name}()`;
      routerSwitch += `\n                  result := ${s.module}`;
      routerSwitch += `\n                  leave`;
      routerSwitch += `\n                }`;
    }

    routerSwitch += `\n              }`;
  }

  // --------------------
  // Write Synthetix.sol
  // --------------------

  const finalCode = source
    .replace('@router_targets', routerTargets)
    .replace('@router_switch', routerSwitch);
  console.log(finalCode);

	fs.writeFileSync(
	  'contracts/Router.sol',
	  finalCode
	);

  console.log(`  > Router code generated`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
