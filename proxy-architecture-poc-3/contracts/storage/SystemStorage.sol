// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;


contract SystemStorage {
    bytes32 constant SYSTEM_STORAGE_POSITION = keccak256("io.synthetix.system");

    struct SystemData {
        string version;
    }

    function systemStorage() internal pure returns (SystemData storage store) {
        bytes32 position = SYSTEM_STORAGE_POSITION;

        assembly {
            store.slot := position
        }
    }
}
