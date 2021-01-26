// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;


contract DiamondStorage {
    bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.standard.diamond.storage");

    struct DiamondStorage {
        mapping(bytes4 => address) implementationForSelector;
        bytes4[] selectors;
        address owner;
    }

    function diamondStorage() internal pure returns (DiamondStorage storage ds) {
        bytes32 position = PROXY_STORAGE_POSITION;

        assembly {
            ds.slot := position
        }
    }
}
