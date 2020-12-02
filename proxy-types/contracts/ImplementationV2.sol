// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

contract ImplementationV2 {
    uint256 private _value;
    string private _message;

    function setValue(uint256 newValue) public {
        _value = newValue;
    }

    function getValue() public view returns (uint256) {
        return _value;
    }

    function setMessage(string calldata message) public {
        _message = message;
    }

    function getMessage() public view returns (string memory) {
        return _message;
    }
}
