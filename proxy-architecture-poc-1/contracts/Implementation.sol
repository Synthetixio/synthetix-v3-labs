// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Beacon.sol";


contract Implementation {
    Beacon private _beacon;

    mapping(uint => bool) private _initializations;

    modifier initializer(uint initializationNum) {
        require(_initializations[initializationNum] == false, "Initializer already called");
        _;
        _initializations[initializationNum] = true;
    }

    function initialize(address beacon) public virtual initializer(1) {
        _beacon = Beacon(beacon);
    }

    function _getModule(bytes32 moduleId) internal view returns (address) {
        return _beacon.getProxy(moduleId);
    }

    function _getSetting(bytes32 settingId) internal view returns (uint) {
        return _beacon.getSetting(settingId);
    }
}
