// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "./diamond/DiamondStorage.sol";


contract OwnerFacet is DiamondStorage {
    function owner() public view returns (address) {
        DiamondStorage storage ds = diamondStorage();

        return ds.owner;
    }
}
