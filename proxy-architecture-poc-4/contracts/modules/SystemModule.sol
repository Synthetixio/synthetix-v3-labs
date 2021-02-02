//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/GlobalStorage.sol";
import "../mixins/OwnerMixin.sol";


library SystemModule {
    function setVersion(string memory newVersion) public {
        OwnerMixin.requireOwner();

        GlobalStorage.store().version = newVersion;
    }

    function getVersion() public view returns (string memory) {
        return GlobalStorage.store().version;
    }

    function setOwner(address newOwner) public {
        require(newOwner != address(0), "Invalid newOwner");

        GlobalStorage.Store storage store = GlobalStorage.store();
        if (store.owner == address(0)) {
            store.owner = newOwner;
        } else {
            require(msg.sender == store.owner, "Only owner allowed");
            store.owner = newOwner;
        }
    }

    function getOwner() public view returns (address) {
        return GlobalStorage.store().owner;
    }

    function getOwnerAndVersion() public view returns (address, string memory) {
        GlobalStorage.Store storage store = GlobalStorage.store();

        return (store.owner, store.version);
    }
}
