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
        address implementation;@router
        else {
          revert("Unknown selector");
        }

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

  const routerPath = '../contracts/Router.sol';
  if (fs.existsSync(routerPath)) {
    fs.unlinkSync(routerPath);
  }

  // -------------------
  // Retrieve data file
  // -------------------

  const deploymentsFilePath = `./deployments/${network}.json`;
	const deployments = JSON.parse(fs.readFileSync(deploymentsFilePath));

  // --------------
  // Sweep modules
  // --------------

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

  const modules = Object.keys(deployments.modules);
  console.log(`  > Modules: ${modules.length}`);

  let routerCode = '';

  const uniqueSelectors = [];

  for (let i = 0; i < modules.length; i++) {
    routerCode += '\n        ';
    routerCode += i === 0 ? 'if (' : 'else if (';

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

    routerCode += `
${functionData.map(func => `          msg.sig == ${func.selector} /*${func.name}*/`).join(' ||\n')}
    `;

    const address = deployments.modules[moduleName].implementation;
    routerCode += `    ) implementation = ${address} /*${moduleName}*/;`
  }
  console.log(`  > Selectors: ${uniqueSelectors.length}`);

  // --------------------
  // Write Synthetix.sol
  // --------------------

  const finalCode = source.replace('@router', routerCode);
	// console.log(finalCode);

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
