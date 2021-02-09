//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract ProxyStorageNamespace {
    struct ProxyStorage {
        address owner;
        address implementation;
    }

    function _proxyStorage() internal pure returns (ProxyStorage storage store) {
        assembly {
            // bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1)
            store.slot := 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
        }
    }
}
