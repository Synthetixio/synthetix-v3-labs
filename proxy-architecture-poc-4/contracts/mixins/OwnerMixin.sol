//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/GlobalStorage.sol";


contract OwnerMixin is GlobalStorageAccessor {
    modifier onlyOwner {
        require(msg.sender == globalStorage().owner, "Only owner allowed");
        _;
    }
}
