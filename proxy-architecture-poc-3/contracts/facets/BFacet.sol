// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "./AFacet.sol";

contract BFacet {
    function testB() public view returns (address) {
        return AFacet(address(this)).testA();
    }

    function getSystemVersionB() public view returns (string memory) {
        return AFacet(address(this)).getSystemVersionA();
    }
}
