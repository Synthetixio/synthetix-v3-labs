//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


abstract contract GlobalStorageAccessor {
    bytes32 constant GLOBAL_STORAGE_POSITION = keccak256("io.synthetix.global");

    struct GlobalData {
        string version;
    }

    function globalStorage() internal pure returns (GlobalData storage data) {
        bytes32 position = GLOBAL_STORAGE_POSITION;

        assembly {
            data.slot := position
        }
    }
}
