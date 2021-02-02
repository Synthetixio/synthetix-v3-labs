//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


library GlobalStorage {
    bytes32 constant GLOBAL_STORAGE_POSITION = keccak256("io.synthetix.global");

    struct Store {
        address owner;
        string version;
    }

    function store() internal pure returns (Store storage _store) {
        bytes32 position = GLOBAL_STORAGE_POSITION;

        assembly {
            _store.slot := position
        }
    }
}
