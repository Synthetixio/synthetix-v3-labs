//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


abstract contract IssuanceStorageAccessor {
    bytes32 constant ISSUANCE_STORAGE_POSITION = keccak256("io.synthetix.issuance");

    struct IssuanceStorage {
        string oracleType;
    }

    function issuanceStorage() internal pure returns (IssuanceStorage storage store) {
        bytes32 position = ISSUANCE_STORAGE_POSITION;

        assembly {
            store.slot := position
        }
    }
}
