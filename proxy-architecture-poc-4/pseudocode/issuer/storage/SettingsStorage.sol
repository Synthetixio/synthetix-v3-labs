//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


abstract contract SettingsStorageAccessor {
    bytes32 constant STORAGE_POSITION = keccak256("io.synthetix.settings");

    struct SettingsStorage {
        uint minimumStakeTime;
    }

    function getSettingsStorage() internal pure returns (SettingsStorage storage store) {
        bytes32 position = STORAGE_POSITION;

        assembly {
            store.slot := position
        }
    }
}
