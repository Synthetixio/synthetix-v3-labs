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

async function generateProxy() {
  const network = hre.network.name;
  console.log(`\nGenerating main proxy for the ${network} network...`);

  // -------------------
  // Retrieve data file
  // -------------------

  const deploymentsFilePath = `./deployments/${network}.json`;
	const deployments = JSON.parse(fs.readFileSync(deploymentsFilePath));

  // -----------------
  // Simulate modules
  // -----------------

  let routerCode = '';

  const numModules = 20;
  const numSelectorsPerModule = 40;

  for (let i = 0; i < numModules; i++) {
    routerCode += '\n        ';
    routerCode += i === 0 ? 'if (' : 'else if (';

    const moduleName = `Module${i}`;

    const functionData = [];
    for (let j = 0; j < numSelectorsPerModule; j++) {
      const name = `func${j}`;
      const selector = '0xDeaDBeef';

      functionData.push({
        name,
        selector
      });
    }

    routerCode += `
${functionData.map(func => `          msg.sig == ${func.selector} /*${func.name}*/`).join(' ||\n')}
    `;

    const address = '0x00000000000000000000000000000000DeaDBeef';
    routerCode += `    ) implementation = ${address} /*${moduleName}*/;`
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

generateProxy()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
