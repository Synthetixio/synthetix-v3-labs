//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/ProxyStorage.sol";


contract OwnerMixin is ProxyStorageNamespace {
    modifier onlyOwner {
        address owner = _proxyStorage().owner;
        if (owner != address(0)) {
            require(msg.sender == _proxyStorage().owner, "Only owner allowed");
        }
        _;
    }
}
