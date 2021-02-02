//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


library IssuanceStorage {
    bytes32 constant ISSUANCE_STORAGE_POSITION = keccak256("io.synthetix.issuance");

    struct Store {
        string oracleType;
    }

    function store() internal pure returns (Store storage _store) {
        bytes32 position = ISSUANCE_STORAGE_POSITION;

        assembly {
            _store.slot := position
        }
    }
}
