//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract ProxyStorageNamespace {
    // bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1)
    bytes32 private constant _PROXY_STORAGE_POSITION = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    struct ProxyStorage {
        address owner;
        address implementation;
        address[] pastImplementations;
    }

    function _proxyStorage() internal pure returns (ProxyStorage storage store) {
        assembly {
            store.slot := _PROXY_STORAGE_POSITION
        }
    }
}
