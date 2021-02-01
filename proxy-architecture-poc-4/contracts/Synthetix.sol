//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Synthetix {
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // GENERATED CODE - do not edit manually
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    bytes4 constant SELECTOR_GET_ORACLE_TYPE = 0xd72e0705;
    bytes4 constant SELECTOR_SET_ORACLE_TYPE = 0xe6dbd15d;
    bytes4 constant SELECTOR_GET_VALUE = 0x20965255;
    bytes4 constant SELECTOR_SET_VALUE = 0x93a09352;
    bytes4 constant SELECTOR_GET_VALUE_VIA_EXCHANGER = 0x43ce657d;

    address constant MODULE_ISSUER = 0x61dCB2172fD6a53380c3Bf5f6B031a242e9BE1F6;
    address constant MODULE_EXCHANGER = 0x48D79c516C2494AcDCfC059615964E207Da81b0d;

    fallback() external {
        address implementation;
        if (msg.sig == SELECTOR_SET_VALUE) implementation = MODULE_EXCHANGER;
        else if (msg.sig == SELECTOR_GET_VALUE) implementation = MODULE_EXCHANGER;
        else if (msg.sig == SELECTOR_GET_VALUE_VIA_EXCHANGER) implementation = MODULE_ISSUER;
        else if (msg.sig == SELECTOR_GET_ORACLE_TYPE) implementation = MODULE_ISSUER;
        else if (msg.sig == SELECTOR_SET_ORACLE_TYPE) implementation = MODULE_ISSUER;

        require(implementation != address(0), "Selector not registered in any module");

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
}
