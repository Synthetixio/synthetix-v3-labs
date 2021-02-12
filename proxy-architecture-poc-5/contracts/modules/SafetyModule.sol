//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../mixins/OwnerMixin.sol";
import "../storage/ProxyStorage.sol";


contract SafetyModule is ProxyStorageNamespace, OwnerMixin {
    /* MUTATIVE FUNCTIONS */

    function safety_upgradeTo(address newImplementation) public onlyOwner {
        require(newImplementation != address(0), "Invalid new implementation: zero address");

        _setImplementation(newImplementation);
    }

    function safety_setOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");

        _ownerStorage().owner = newOwner;
    }

    /* VIEW FUNCTIONS */

    function safety_getOwner() public view returns (address) {
        return _ownerStorage().owner;
    }

    function safety_isUpgradeable() public pure returns (bool) {
        return true;
    }

    function safety_getImplementation() public view returns (address) {
        return _getImplementation();
    }
}
