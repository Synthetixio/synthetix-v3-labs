//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract ProxyStorageNamespace {
    // bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1))
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function _getImplementation() internal view returns (address impl) {
        assembly {
            impl := sload(_IMPLEMENTATION_SLOT)
        }
    }

    function _setImplementation(address newImplementation) internal {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }
}

