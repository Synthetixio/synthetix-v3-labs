//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/GlobalStorage.sol";


library OwnerMixin {
    function requireOwner() public view {
        require(msg.sender == GlobalStorage.store().owner, "Only owner allowed");
    }
}
