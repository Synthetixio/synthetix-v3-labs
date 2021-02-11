//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/ModuleStorage.sol";
import "../storage/ProxyStorage.sol";


contract RegistryMixin is ModuleStorageNamespace, ProxyStorageNamespace {
    /* VIEW FUNCTIONS */

    function getModuleImplementation(bytes32 moduleId) internal view returns (address) {
        return _moduleStorage().implemenntationForModule[moduleId];
    }

    function getRouter() internal view returns (address) {
        return _getImplementation();
    }
}
