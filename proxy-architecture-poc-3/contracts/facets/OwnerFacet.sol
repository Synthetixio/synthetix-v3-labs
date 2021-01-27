// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "../DiamondLibrary.sol";


contract OwnerFacet {
    function setOwner(address newOwner) public {
        DiamondLibrary.requireOwner();

        DiamondLibrary.setOwner(newOwner);
    }

    function getOwner() public view returns (address) {
        return DiamondLibrary.getOwner();
    }
}
