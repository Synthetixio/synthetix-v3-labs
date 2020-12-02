// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Migration.sol";
import "../Beacon.sol";


contract MigrateToV2 is Migration {
    bytes32 private constant _CRATIO_SETTING_ID = 0x63726174696f0000000000000000000000000000000000000000000000000000; // bytes32("cratio")

    function migrateSettings() public {
        bytes32[] memory settingIds = new bytes32[](1);
        uint[] memory values = new uint[](1);

        settingIds[0] = _CRATIO_SETTING_ID;
        values[0] = 500;

        _beacon.configure(settingIds, values);
    }
}

