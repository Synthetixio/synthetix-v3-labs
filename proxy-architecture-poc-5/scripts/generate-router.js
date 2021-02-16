const fs = require('fs');
const { getSelectorsForModule } = require('./utils/moduleSelectors');

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

  // ---------------------
  // Build data structure
  // ---------------------

  // Collect all modules into an array of
  // {
  //   name: 'SomeModule',
  //   address: '0xdeadbeaf...'
  // }
  const modulesNames = Object.keys(deployments.modules);
  const modules = modulesNames.map(name => {
    return {
      name,
      address: deployments.modules[name].implementation,
    }
  });
  console.log(`  > Modules: ${modules.length}`);

  // Collect selectors into a single array of
  // {
  //   name: 'myFunction()',
  //   selector: '0xdeadbeaf',
  //   module: 'SomeModule'
  // }
  let selectors = [];
  for (let i = 0; i < modules.length; i++) {
    const module = modules[i];
    const moduleSelectors = await getSelectorsForModule(module.name);

    moduleSelectors.map(moduleSelector => {
      if (selectors.some(s => s.selector === moduleSelector.selector)) {
        throw new Error(`Duplicate selector ${moduleSelector.name}`);
      }

      selectors.push({
        name: moduleSelector.name,
        selector: moduleSelector.selector,
        module: module.name
      });
    });
  }
  console.log(`  > Selectors: ${selectors.length}`);

  // Sort selectors from lowest numeric value to highest
  selectors = selectors.sort((a, b) => {
    return parseInt(a.selector, 16) - parseInt(b.selector, 16);
  });

  // Put selectors into a binary data structure
  const binaryChunkSize = 9;

  function binarySplit(node) {
    if (node.selectors.length > binaryChunkSize) {
      const midIdx = Math.ceil(node.selectors.length / 2);

      const childA = binarySplit({
        selectors: node.selectors.splice(0, midIdx),
        children: [],
      });

      const childB = binarySplit({
        selectors: node.selectors.splice(-midIdx),
        children: [],
      });

      node.children.push(childA);
      node.children.push(childB);

      node.selectors = [];
    }

    return node;
  }

  let binaryData = {
    selectors,
    children: []
  }

  binaryData = binarySplit(binaryData);
  // console.log(JSON.stringify(binaryData, null, 2));

  // -----------------------
  // Render @router_targets
  // -----------------------

  const tab = '    ';

  let routerTargets = '';
  for (let i = 0; i < modules.length; i++) {
    const module = modules[i];

    routerTargets += `\n${tab.repeat(4)}let ${module.name} := ${module.address}`;
  }

  // ----------------------
  // Render @router_switch
  // ----------------------

  let routerSwitch = '';

  function renderNode(node, indent) {
    if (node.children.length > 0) {
      const childA = node.children[0];
      const childB = node.children[1];
      // console.log('A:', JSON.stringify(childA, null, 2));
      // console.log('B:', JSON.stringify(childB, null, 2));

      function findMidSelector(node) {
        if (node.selectors.length > 0) {
          return node.selectors[0];
        } else {
          return findMidSelector(node.children[0]);
        }
      }
      const midSelector = findMidSelector(childB);

      routerSwitch += `\n${tab.repeat(4 + indent)}if lt(sig,${midSelector.selector}) {`;
      renderNode(childA, indent + 1);
      routerSwitch += `\n${tab.repeat(4 + indent)}}`;

      renderNode(childB, indent);
    } else {
      routerSwitch += `\n${tab.repeat(4 + indent)}switch sig`;
      for (const s of node.selectors) {
        routerSwitch += `\n${tab.repeat(4 + indent)}case ${s.selector} { result := ${s.module} } // ${s.module}.${s.name}()`;
      }
      routerSwitch += `\n${tab.repeat(4 + indent)}leave`;
    }
  }

  renderNode(binaryData, 0);

  // ------------------------------
  // Concatenate and validate code
  // ------------------------------

  const finalCode = source
    .replace('@router_network', network)
    .replace('@router_targets', routerTargets)
    .replace('@router_switch', routerSwitch);
  // console.log(finalCode);

  // Verify that all selectors are in the code,
  // associated to the correct module
  console.log('Checking selectors on source...');
  for (let i = 0; i < modules.length; i++) {
    const module = modules[i];
    const moduleSelectors = await getSelectorsForModule(module.name);

    moduleSelectors.map(moduleSelector => {
      const regex = `^.*case ${moduleSelector.selector}.*$`;
      const matches = finalCode.match(new RegExp(regex, 'gm'));
      if (matches.length !== 1) {
        throw new Error(`Selector case found ${matches.length} times instead of the expected single time. Regex: ${regex}. Matches: ${matches}`);
      }
      const match = matches[0];
      if (!match.includes(module.name)) {
        throw new Error(`Expected to find ${module.name} in the selector case: ${match}`);
      }
      console.log(`  > ${module.name}.${moduleSelector.name} ✓`);
    });
  }

  // --------------------
  // Write Synthetix.sol
  // --------------------

	fs.writeFileSync(
	  `contracts/Router_${network}.sol`,
	  finalCode
	);

  console.log(`Router code generated`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
