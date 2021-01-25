// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract AddressResolver {
    string public constant version = '2.3';

    uint256 public uintValue;
    string public stringValue;

    function initialize(uint256 _uintValue, string calldata _stringValue) public {
        uintValue = _uintValue;
        stringValue = _stringValue;
    }
}
