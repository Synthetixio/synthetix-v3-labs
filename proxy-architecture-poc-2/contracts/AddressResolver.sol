// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";


contract AddressResolver is Initializable {
    // uint256[49] private __gap;

    string public constant version = '1';

    uint public uintValue1;
    uint public uintValue2;

    function initialize(uint _uintValue1, uint _uintValue2) public initializer {
        uintValue1 = _uintValue1;
        uintValue2 = _uintValue2;
    }
}
