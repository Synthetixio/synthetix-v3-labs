// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Beacon.sol";


contract Implementation {
    Beacon private _beacon;

    mapping(uint => bool) private _initializations;

    mapping(bytes32 => address) private _modulesCache;
    mapping(bytes32 => uint) private _settingsCache;

    modifier initializer(uint initializationNum) {
        require(_initializations[initializationNum] == false, "Initializer already called");
        _;
        _initializations[initializationNum] = true;
    }

    function initialize(address beacon) public virtual initializer(1) {
        _beacon = Beacon(beacon);
    }

    function _getModule(bytes32 moduleId) internal view returns (address) {
        return _modulesCache[moduleId];
    }

    function _getSetting(bytes32 settingId) internal view returns (uint) {
        return _settingsCache[settingId];
    }

    function _cacheModuleDependencies(bytes32[] memory moduleIds) internal {
        uint len = moduleIds.length;
        for (uint i; i < len; i++) {
            bytes32 moduleId = moduleIds[i];

            _modulesCache[moduleId] = _beacon.getProxy(moduleId);
        }
    }

    function _cacheSettings(bytes32[] memory settingIds) internal {
        uint len = settingIds.length;
        for (uint i; i < len; i++) {
            bytes32 settingId = settingIds[i];

            _settingsCache[settingId] = _beacon.getSetting(settingId);
        }
    }

}
