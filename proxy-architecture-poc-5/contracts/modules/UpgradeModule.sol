//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../mixins/OwnerMixin.sol";
import "../storage/ProxyStorage.sol";
import "@openzeppelin/contracts/utils/Address.sol";


contract UpgradeModule is ProxyStorageNamespace, OwnerMixin {
    /* MUTATIVE FUNCTIONS */

    function upgradeTo(address newImplementation) public onlyOwner {
        require(newImplementation != address(0), "Invalid new implementation: zero address");
        require(Address.isContract(newImplementation), "Invalid new implementation: not a contract");
        require(UpgradeModule(newImplementation).isUpgradeable(), "Invalid new implementation: not upgradeable");

        _setImplementation(newImplementation);
    }

    /* VIEW FUNCTIONS */

    function isUpgradeable() public pure returns (bool) {
        return true;
    }

    function getImplementation() public view returns (address) {
        return _getImplementation();
    }
}
