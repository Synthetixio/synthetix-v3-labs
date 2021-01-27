// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

// import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";

contract AddressResolver {
    string public constant version = '2';

    uint256 public uintValue;
    string public stringValue;

    function initialize(uint256 _uintValue, string calldata _stringValue) public {
        uintValue = _uintValue;
        stringValue = _stringValue;
    }

    // uint256[49] private __gap;
}
