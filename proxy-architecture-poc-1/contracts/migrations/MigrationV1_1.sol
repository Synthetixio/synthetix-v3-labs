// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "../Beacon.sol";
import "../modules/nebula/Nebulav1.sol";
import "../modules/pulsar/PulsarV1.sol";


contract MigrationV1_1 {
    Beacon private _beacon;

    bytes32 private constant _NEBULA_MODULE_ID = 0x6e6562756c610000000000000000000000000000000000000000000000000000; // bytes32("nebula")
    bytes32 private constant _PULSAR_MODULE_ID = 0x70756c7361720000000000000000000000000000000000000000000000000000; // bytes32("pulsar")

    bytes32 private constant _CRATIO_SETTING_ID = 0x63726174696f0000000000000000000000000000000000000000000000000000; // bytes32("cratio")

    constructor(address beacon) {
        _beacon = Beacon(beacon);
    }

    function prepareForMigration() public {
        _beacon.suspend();
    }

    function migrateContracts() public {
        bytes32[] memory moduleIds = new bytes32[](2);
        address[] memory implementations = new address[](2);

        moduleIds[0] = _NEBULA_MODULE_ID;
        implementations[0] = address(new NebulaV1());

        moduleIds[1] = _PULSAR_MODULE_ID;
        implementations[1] = address(new PulsarV1());

        _beacon.upgrade(moduleIds, implementations);
    }

    function initializeNewProxies() public {
        NebulaV1 nebula = NebulaV1(_beacon.getProxy(_NEBULA_MODULE_ID));
        nebula.setBeacon(address(_beacon));

        PulsarV1 pulsar = PulsarV1(_beacon.getProxy(_PULSAR_MODULE_ID));
        pulsar.setBeacon(address(_beacon));
    }

    function migrateSettings() public {
        bytes32[] memory settingIds = new bytes32[](1);
        uint[] memory values = new uint[](1);

        settingIds[0] = _CRATIO_SETTING_ID;
        values[0] = 600;

        _beacon.configure(settingIds, values);
    }

    function finalizeMigration() public {
        _beacon.resume();
    }
}
