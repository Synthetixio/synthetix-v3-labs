//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


abstract contract EscrowStorageAccessor {
    bytes32 constant STORAGE_POSITION = keccak256("io.synthetix.escrow");

    struct EscrowStorage {
        mapping(address => uint) balanceOf;
    }

    function getEscrowStorage() internal pure returns (EscrowStorage storage store) {
        bytes32 position = STORAGE_POSITION;

        assembly {
            store.slot := position
        }
    }
}
