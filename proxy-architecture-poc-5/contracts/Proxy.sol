//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./storage/ProxyStorage.sol";


contract Proxy is ProxyStorageNamespace {
    constructor(address firstImplementation) {
        ProxyStorage storage store = _proxyStorage();

        store.owner = msg.sender;
        store.implementation = firstImplementation;
    }

    fallback() external {
        address implementation = _proxyStorage().implementation;

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }
}
