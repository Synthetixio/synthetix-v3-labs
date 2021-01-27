// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "../DiamondLibrary.sol";

contract OwnerFacet {
    function setOwner(address newOwner) external {
        DiamondLibrary.requireOwner();

        DiamondLibrary.setOwner(newOwner);
    }

    function getOwner() external view returns (address) {
        return DiamondLibrary.getOwner();
    }
}
