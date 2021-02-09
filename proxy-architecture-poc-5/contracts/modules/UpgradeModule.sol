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

        _proxyStorage().implementation = newImplementation;
    }

    /* VIEW FUNCTIONS */

    function getOwner() public view returns (address) {
        return _proxyStorage().owner;
    }

    function getImplementation() public view returns (address) {
        return _proxyStorage().implementation;
    }
}
