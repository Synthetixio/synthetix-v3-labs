// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Beacon.sol";


contract BeaconResolver {
    Beacon private _beacon;

    function setBeacon(address beacon) public {
        require(address(_beacon) == address(0), "Beacon already set");
        _beacon = Beacon(beacon);
    }

    function _getModule(bytes32 moduleId) internal view returns (address) {
        return _beacon.getProxy(moduleId);
    }

    function _getSetting(bytes32 settingId) internal view returns (uint) {
        return _beacon.getSetting(settingId);
    }
}
