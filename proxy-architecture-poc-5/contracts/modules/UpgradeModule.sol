//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/ProxyStorage.sol";
import "../mixins/OwnerMixin.sol";


contract UpgradeModule is ProxyStorageNamespace, OwnerMixin {
    /* MUTATIVE FUNCTIONS */

    function setOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");

        _proxyStorage().owner = newOwner;
    }

    function setImplementation(address newImplementation) public onlyOwner {
        require(newImplementation != address(0), "Invalid new implementation");

        ProxyStorage storage store = _proxyStorage();

        store.pastImplementations.push(store.implementation);
        store.implementation = newImplementation;
    }

    function setPastImplementation(uint index) public onlyOwner {
        ProxyStorage storage store = _proxyStorage();
        address pastImplementation = store.pastImplementations[index];

        require(pastImplementation != address(0), "Invalid past implementation");

        store.implementation = pastImplementation;
    }

    /* VIEW FUNCTIONS */

    function getOwner() public view returns (address) {
        return _proxyStorage().owner;
    }

    function getImplementation() public view returns (address) {
        return _proxyStorage().implementation;
    }

    function getPastImplementation(uint index) public view returns (address) {
        return _proxyStorage().pastImplementations[index];
    }

    function getNumPastImplementations() public view returns (uint) {
        return _proxyStorage().pastImplementations.length;
    }
}
