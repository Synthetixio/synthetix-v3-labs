// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "./OwnerFacet.sol";
import "../storage/SystemStorage.sol";

contract AFacet is SystemStorage {
    function testA() public view returns (address) {
        return OwnerFacet(address(this)).getOwner();
    }

    function setSystemVersionA(string memory newVersion) public {
        systemStorage().version = newVersion;
    }

    function getSystemVersionA() public view returns (string memory) {
        return systemStorage().version;
    }
}
