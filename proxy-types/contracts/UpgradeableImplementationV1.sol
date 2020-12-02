// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Upgradeable.sol";


contract UpgradeableImplementationV1 is Upgradeable {
    uint256 private _value;

    function setValue(uint256 newValue) public {
        _value = newValue;
    }

    function getValue() public view returns (uint256) {
        return _value;
    }
}
