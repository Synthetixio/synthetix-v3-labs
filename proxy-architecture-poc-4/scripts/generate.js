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
        address implementation;
        @router
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

  const modules = Object.keys(deployments.modules);

  for (let i = 0; i < modules.length; i++) {
    const moduleName = modules[i];
    const module = deployments.modules[moduleName];

    const factory = await ethers.getContractFactory(moduleName);
  };
}

generate()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
