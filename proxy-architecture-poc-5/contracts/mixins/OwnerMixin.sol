//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/ProxyStorage.sol";


contract OwnerMixin is ProxyStorageNamespace {
    modifier onlyOwner {
        require(msg.sender == _proxyStorage().owner, "Only owner allowed");
        _;
    }
}
