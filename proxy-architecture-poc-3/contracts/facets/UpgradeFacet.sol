// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import "../DiamondLibrary.sol";


contract UpgradeFacet {
    function registerFacets(DiamondLibrary.FacetData[] memory facets) public {
        DiamondLibrary.registerFacets(facets);
    }
}
