// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Migration.sol";
import "../Beacon.sol";
import "../modules/nebula/NebulaV2.sol";


contract MigrateToV3 is Migration {
    bytes32 private constant _NEBULA_MODULE_ID = 0x6e6562756c610000000000000000000000000000000000000000000000000000; // bytes32("nebula")

    function migrateContracts() public {
        bytes32[] memory moduleIds = new bytes32[](1);
        address[] memory implementations = new address[](1);

        moduleIds[0] = _NEBULA_MODULE_ID;
        implementations[0] = address(new NebulaV2());

        _beacon.upgrade(moduleIds, implementations);
    }

    function initializeProxies() public {
        NebulaV2 nebula = NebulaV2(_beacon.getProxy(_NEBULA_MODULE_ID));
        nebula.initializeV2();
    }
}

