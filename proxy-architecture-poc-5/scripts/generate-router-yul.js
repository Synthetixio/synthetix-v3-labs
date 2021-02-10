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
            @router_targets

            switch sig32@router_switch
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

  const modules = Object.keys(deployments.modules);

  let routerTargets = '';
  for (let i = 0; i < modules.length; i++) {
    const moduleName = modules[i];
    const moduleAddress = deployments.modules[moduleName].implementation;

    routerTargets += `\n            let ${moduleName} := ${moduleAddress}`;
  }

  // ---------------------
  // Build @router_switch
  // ---------------------

  async function getModuleFunctionData(moduleName) {
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

  const uniqueSelectors = [];

  let routerSwitch = '';
  for (let i = 0; i < modules.length; i++) {
    const moduleName = modules[i];
    const functionData = await getModuleFunctionData(moduleName);

    // Check for selector collisions
    // TODO: Check entire signature
    functionData.map(func => {
      if (uniqueSelectors.some(selector => selector === func.selector)) {
        throw new Error(`Duplicate selector ${func.name} found in ${moduleName}`);
      } else {
        uniqueSelectors.push(func.selector);
      }
    });

    for (let j = 0; j < functionData.length; j++) {
      const func = functionData[j];

      routerSwitch += `\n            case ${func.selector} /*${func.name}*/ { implementation := ${moduleName} }`;
    }
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
