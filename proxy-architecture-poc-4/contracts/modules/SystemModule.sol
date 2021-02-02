//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/GlobalStorage.sol";
import "../mixins/OwnerMixin.sol";


contract SystemModule is GlobalStorageAccessor, OwnerMixin {
    function setVersion(string memory newVersion) public onlyOwner {
        globalStorage().version = newVersion;
    }

    function getVersion() public view returns (string memory) {
        return globalStorage().version;
    }

    function setOwner(address newOwner) public {
        require(newOwner != address(0), "Invalid newOwner");

        GlobalStorage storage store = globalStorage();
        if (store.owner == address(0)) {
            store.owner = newOwner;
        } else {
            require(msg.sender == store.owner, "Only owner allowed");
            store.owner = newOwner;
        }
    }

    function getOwner() public view returns (address) {
        return globalStorage().owner;
    }

    function getOwnerAndVersion() public view returns (address, string memory) {
        GlobalStorage storage store = globalStorage();

        return (store.owner, store.version);
    }
}
