// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

contract ImplementationV1 {
    uint256 private _value;

    function setValue(uint256 newValue) public {
        _value = newValue;
    }

    function getValue() public view returns (uint256) {
        return _value;
    }
}
