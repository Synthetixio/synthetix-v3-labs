// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "../Beacon.sol";


contract Migration {
    Beacon internal _beacon;

    function prepareForMigration(address beacon) public {
        _beacon = Beacon(beacon);

        _beacon.prepareForMigration();
    }

    function finalizeMigration() public {
        _beacon.finalizeMigration();
    }
}
