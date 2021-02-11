//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract ModuleStorageNamespace {
    struct ModuleStorage {
        // bytes32(moduleName) => moduleAddress
        mapping(bytes32 => address) implemenntationForModule;
    }

    function _moduleStorage() internal pure returns (ModuleStorage storage store) {
        assembly {
            // bytes32(uint(keccak256("io.synthetix.module")) - 1)
            store.slot := 0x870b63c387413bb89eb648c14375aa70e271aa4b04cdee2689d17d3f55124eb4
        }
    }
}

