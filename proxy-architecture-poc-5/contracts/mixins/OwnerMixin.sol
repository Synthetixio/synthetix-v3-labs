//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/OwnerStorage.sol";


contract OwnerMixin is OwnerStorageNamespace {
    /* MODIFIERS */

    modifier onlyOwner {
        address owner = _ownerStorage().owner;
        if (owner != address(0)) {
            require(msg.sender == _ownerStorage().owner, "Only owner allowed");
        }
        _;
    }
}
