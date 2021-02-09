//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/UpgradeStorage.sol";
import "../mixins/OwnerMixin.sol";


contract UpgradeModule is UpgradeModuleStorageAccessor, OwnerMixin {
    function upgradeTo(address newRouter) public onlyOwner {
        // TODO: Check that the newRouter is upgradeable and owned

        routerImplementation() = newRouter;
    }
}
