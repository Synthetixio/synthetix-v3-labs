//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../mixins/OwnerMixin.sol";
import "../storage/ProxyStorage.sol";


contract UpgradeModule is ProxyStorageNamespace, OwnerMixin {
    /* MUTATIVE FUNCTIONS */

    function upgradeTo(address newImplementation) public onlyOwner {
        require(newImplementation != address(0), "Invalid new implementation");
        // TODO: Apply more safety checks.

        _setImplementation(newImplementation);
    }

    /* VIEW FUNCTIONS */

    function getImplementation() public view returns (address) {
        return _getImplementation();
    }
}
