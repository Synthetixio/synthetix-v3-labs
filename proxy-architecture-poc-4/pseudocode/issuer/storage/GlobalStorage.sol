//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./interfaces/IERC20.sol";


abstract contract GlobalStorageAccessor {
    bytes32 constant STORAGE_POSITION = keccak256("io.synthetix.global");

    struct GlobalStorage {
        address owner;
        IERC20 snx;
    }

    function getGlobalStorage() internal pure returns (GlobalStorage storage store) {
        bytes32 position = STORAGE_POSITION;

        assembly {
            store.slot := position
        }
    }
}
