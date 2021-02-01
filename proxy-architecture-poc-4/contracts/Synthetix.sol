//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Synthetix {
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // GENERATED CODE - do not edit manually
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------

    address constant MODULE_SYSTEM = 0x81692EB97C341bdFf339c499Aeee5d1A2F1cD555;
    bytes4 constant SELECTOR_GET_VERSION = 0x0d8e6e2c;
    bytes4 constant SELECTOR_SET_VERSION = 0x788bc78c;

    address constant MODULE_ISSUER = 0x29A4e406Ec46B37937587b25Dd045f898AF1E80A;
    bytes4 constant SELECTOR_GET_ORACLE_TYPE = 0xd72e0705;
    bytes4 constant SELECTOR_SET_ORACLE_TYPE = 0xe6dbd15d;
    bytes4 constant SELECTOR_GET_VERSION_VIA_EXCHANGER = 0x10916f3b;

    address constant MODULE_EXCHANGER = 0x06bb5Bb771614067c496c2029eb56b625Ed91234;
    bytes4 constant SELECTOR_GET_SYSTEM_VERSION = 0xe017bb0d;

    fallback() external {
        address implementation;
        if (
            msg.sig == SELECTOR_GET_VERSION ||
            msg.sig == SELECTOR_SET_VERSION
        ) implementation = MODULE_SYSTEM;
        else if (
            msg.sig == SELECTOR_GET_ORACLE_TYPE ||
            msg.sig == SELECTOR_SET_ORACLE_TYPE ||
            msg.sig == SELECTOR_GET_VERSION_VIA_EXCHANGER
        ) implementation = MODULE_ISSUER;
        else if (
            msg.sig == SELECTOR_GET_SYSTEM_VERSION
        ) implementation = MODULE_EXCHANGER;

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
