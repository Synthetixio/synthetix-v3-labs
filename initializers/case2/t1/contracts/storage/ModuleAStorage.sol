//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract ModuleAStorageNamespace {
    struct ModuleAStorage {
        address daiAddress;
        uint someValue;
    }

    function _moduleAStorage() internal pure returns (ModuleAStorage storage store) {
        assembly {
            // bytes32(uint(keccak256("io.synthetix.moduleA")) - 1)
            store.slot := 0x64b748fbda347b7e22c5029a23b4e647df311daee8f2a42947ab7ccf00000001
        }
    }
}
