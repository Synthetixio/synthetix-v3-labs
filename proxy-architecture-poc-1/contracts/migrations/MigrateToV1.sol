// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Migration.sol";
import "../Beacon.sol";
import "../modules/nebula/Nebulav1.sol";
import "../modules/pulsar/PulsarV1.sol";


contract MigrateToV1 is Migration {
    function migrateContracts() public {
        bytes32[] memory moduleIds = new bytes32[](2);
        address[] memory implementations = new address[](2);

        moduleIds[0] = "nebula";
        implementations[0] = address(new NebulaV1());

        moduleIds[1] = "pulsar";
        implementations[1] = address(new PulsarV1());

        _beacon.upgrade(moduleIds, implementations);
    }

    function initializeProxies() public {
        NebulaV1 nebula = NebulaV1(_beacon.getProxy("nebula"));
        nebula.initialize(address(_beacon));

        PulsarV1 pulsar = PulsarV1(_beacon.getProxy("pulsar"));
        pulsar.initialize(address(_beacon));
    }

    function migrateSettings() public {
        bytes32[] memory settingIds = new bytes32[](1);
        uint[] memory values = new uint[](1);

        settingIds[0] = "cratio";
        values[0] = 600;

        _beacon.configure(settingIds, values);
    }
}
