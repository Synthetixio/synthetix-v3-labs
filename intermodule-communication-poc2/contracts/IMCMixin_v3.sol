//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract IMCMixinV3 {
    address constant internal _AModule = 0xE6deF028B0D79497dC2E421526CF22673c563004;
    address constant internal _BModule = 0x1c91347f2A44538ce62453BEBd9Aa907C662b4bD;

    mapping(bytes32 => address) addresses;
    bool initialized;

    function _initializer() internal {
        if (!initialized) {
            addresses["AModule"] = _AModule;
            addresses["BModule"] = _BModule;
            initialized = true;
        }
    }

    /* VIEW FUNCTIONS */

    function getModuleAddress(bytes32 moduleId) internal view returns (address) {
        return addresses[moduleId];
    }

}