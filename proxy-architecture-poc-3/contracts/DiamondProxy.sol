// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import "./DiamondLibrary.sol";
import "./facets/OwnerFacet.sol";
import "./facets/UpgradeFacet.sol";


contract DiamondProxy {
    constructor(DiamondLibrary.FacetData[] memory initialFacets) {
        DiamondLibrary.setOwner(msg.sender);

        DiamondLibrary.registerFacets(initialFacets);
    }

    fallback() external payable {
        address implementation = DiamondLibrary.proxyStorage().implementationForSelector[msg.sig];
        require(implementation != address(0), "Selector not registered in any facet");

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
}
