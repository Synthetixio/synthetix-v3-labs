//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


abstract contract IssuanceStorageAccessor {
    bytes32 constant ISSUANCE_STORAGE_POSITION = keccak256("io.synthetix.issuance");

    struct IssuanceData {
        string oracleType;
    }

    function issuanceStorage() internal pure returns (IssuanceData storage data) {
        bytes32 position = ISSUANCE_STORAGE_POSITION;

        assembly {
            data.slot := position
        }
    }
}
