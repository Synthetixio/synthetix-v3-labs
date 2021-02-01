const fs = require('fs');

const source = `
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Synthetix {
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // GENERATED CODE - do not edit manually
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------

    fallback() external {
        // Function selector to implementation contract lookup table
        address implementation;@router
        require(implementation != address(0), "Selector not registered in any module");

        // Delegatecall forwarder
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
}
`;

async function generate() {
  const network = 'kovan';

  // -------------------
  // Retrieve data file
  // -------------------

  const deploymentsFilePath = `./deployments/${network}.json`;
	const deployments = JSON.parse(fs.readFileSync(deploymentsFilePath));

  // --------------
  // Sweep modules
  // --------------

  async function getModuleSelectors(moduleName) {
    const contract = await ethers.getContractAt(moduleName, '0x0000000000000000000000000000000000000001');

    return contract.interface.fragments.reduce((selectors, fragment) => {
      if (fragment.type === "function") {
        selectors.push(contract.interface.getSighash(fragment));
      }

      return selectors;
    }, []);
  }

  const modules = Object.keys(deployments.modules);

  let routerCode = '';

  for (let i = 0; i < modules.length; i++) {
    routerCode += '\n        ';
    routerCode += i === 0 ? 'if (' : 'else if (';

    const moduleName = modules[i];
    const selectors = await getModuleSelectors(moduleName);

    routerCode += `
${selectors.map(selector => `          msg.sig == ${selector}`).join(' ||\n')}
    `;

    const address = deployments.modules[moduleName].implementation;
    routerCode += `    ) implementation = ${address};`
  }

  // --------------------
  // Write Synthetix.sol
  // --------------------

  const finalCode = source.replace('@router', routerCode);
  console.log(finalCode);

	fs.writeFileSync(
	  'contracts/Synthetix.sol',
	  finalCode
	);
}

generate()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
