//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/ModuleStorage.sol";


contract RegistryModule is ModuleStorageNamespace {
    /* MUTATIVE FUNCTIONS */

    function registerModules(bytes32[] memory moduleIds, address[] memory moduleAddresses) public {
        require(moduleIds.length == moduleAddresses.length, "Invalid array data");

        for (uint i = 0; i < moduleIds.length; i++) {
            _moduleStorage().implemenntationForModule[moduleIds[i]] = moduleAddresses[i];
        }
    }

    /* VIEW FUNCTIONS */

    function getModuleImplementation(bytes32 moduleId) public view returns (address) {
        return _moduleStorage().implemenntationForModule[moduleId];
    }
}
