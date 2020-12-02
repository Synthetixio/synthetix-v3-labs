// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Nebulav1.sol";
import "./NebulaStorageV2.sol";
import "../pulsar/PulsarV1.sol";


contract NebulaV2 is Implementation, NebulaStorageV2 {
    function initializeV2() public initializer(2) {
        _someOtherVal = 33;

        bytes32[] memory modulesToCache = new bytes32[](1);
        modulesToCache[0] = "pulsar";
        _cacheModuleDependencies(modulesToCache);

        bytes32[] memory settingsToCache = new bytes32[](1);
        settingsToCache[0] = "cratio";
        _cacheSettings(settingsToCache);
    }

    function whoispulsar() public view returns (string memory) {
        PulsarV1 pulsar = PulsarV1(_getModule("pulsar"));

        return pulsar.whoami();
    }

    function whoami() public pure returns (string memory) {
        return "NebulaV2";
    }

    function getSomeVal() public view returns (uint) {
        return _someVal;
    }

    function getSomeOtherVal() public view returns (uint) {
        return _someOtherVal;
    }

    function getCRatio() public view returns (uint) {
        return _getSetting("cratio");
    }
}
