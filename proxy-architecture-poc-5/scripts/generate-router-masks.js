const fs = require('fs');

const source = `//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Router_@router_network {
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

            function findImplementation(sig) -> result {@router_masks
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

async function _getSelectorsForModule(moduleName) {
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

async function main() {
  const network = hre.network.name;
  console.log(`\nGenerating router for the ${network} network...`);

  // -------------------
  // Retrieve data file
  // -------------------

  const deploymentsFilePath = `./deployments/${network}.json`;
	const deployments = JSON.parse(fs.readFileSync(deploymentsFilePath));

  // ---------------------
  // Build data structure
  // ---------------------

  // For each module, find a mask that for all selectors:
  // selector & mask = constant
  // Making sure that all masks and all constants are unique.
  const masks = [];
  const results = [];

  const modulesNames = Object.keys(deployments.modules);
  for (let i = 0; i < modulesNames.length; i++) {
    const moduleName = modulesNames[i];
    const selectors = (await _getSelectorsForModule(moduleName)).map(s => parseInt(s.selector, 16));
    console.log(`${moduleName}: ${selectors.length} selectors`);

    const maxMask = parseInt('0xffffffff', 16);
    for (let mask = 1; mask < maxMask; mask++) {
      console.log((mask / maxMask).toFixed(8));

      if (masks.indexOf(mask) >= 0) {
        continue;
      }

      let lastResult;
      let matchingResults = 0;
      for (let j = 0; j < selectors.length; j++) {
        const selector = selectors[j];
        const result = selector & mask;
        if (result === 0 || results.indexOf(result) >= 0) {
          continue;
        }

        if (j !== 0) {
          if (result !== lastResult) {
            break;
          } else {
            matchingResults++;
          }
        }

        lastResult = result;
      }

      if (matchingResults === selectors.length - 1) {
        let collides = false;
        if (masks.length > 0) {
          for (let k = 0; k < masks.length; k++) {
            const otherMask = masks[k];
            const otherResult = results[k];
            if (selectors[0] & otherMask === otherResult) {
              collides = true;
            }
          }
        }

        if (!collides) {
          masks.push(mask);
          results.push(selectors[0] & mask);
          console.log(masks);

          break;
        }
      }
    }
  }

  // --------------
  // Render source
  // --------------

  const tab = '    ';

  let routerMasks = '';
  for (let i = 0; i < modulesNames.length; i++) {
    const moduleName = modulesNames[i];
    const mask = masks[i];
    const result = results[i];
    const address = deployments.modules[moduleName].implementation;

    routerMasks += `\n${tab.repeat(4)}if eq(and(sig, ${mask}), ${result}) {`;
    routerMasks += `\n${tab.repeat(5)}result := ${address} // ${ moduleName }`;
    routerMasks += `\n${tab.repeat(5)}leave`;
    routerMasks += `\n${tab.repeat(4)}}`;
  }

  // --------------------
  // Write Synthetix.sol
  // --------------------

  const finalCode = source
    .replace('@router_network', network)
    .replace('@router_masks', routerMasks)
  console.log(finalCode);

	fs.writeFileSync(
	  `contracts/Router_${network}.sol`,
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
