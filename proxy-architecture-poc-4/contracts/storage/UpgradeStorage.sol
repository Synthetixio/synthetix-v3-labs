//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


abstract contract UpgradeStorageAccessor {
    bytes32 constant PROXY_STORAGE_POSITION = keccak256("eip1967.proxy.implementation");

    function routerImplementation() internal pure returns (address implementation) {
        bytes32 position = STORAGE_POSITION;

        assembly {
            implementation.slot := position
        }
    }
}
