// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Migration.sol";
import "../Beacon.sol";


contract MigrateToV2 is Migration {
    function migrateSettings() public {
        bytes32[] memory settingIds = new bytes32[](1);
        uint[] memory values = new uint[](1);

        settingIds[0] = "cratio";
        values[0] = 500;

        _beacon.configure(settingIds, values);
    }
}

