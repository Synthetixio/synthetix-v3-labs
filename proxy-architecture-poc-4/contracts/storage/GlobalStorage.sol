//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


abstract contract GlobalStorageAccessor {
    bytes32 constant GLOBAL_STORAGE_POSITION = keccak256("io.synthetix.global");

    struct GlobalStorage {
        address owner;
        string version;
    }

    function globalStorage() internal pure returns (GlobalStorage storage store) {
        bytes32 position = GLOBAL_STORAGE_POSITION;

        assembly {
            store.slot := position
        }
    }
}
