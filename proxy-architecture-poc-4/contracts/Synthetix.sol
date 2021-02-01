//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Synthetix {
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // GENERATED CODE - do not edit manually
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------

    address constant MODULE_SYSTEM = 0xcdA522f72aC0Ab675f9d9b27686229B9EE60F064;
    bytes4 constant SELECTOR_GET_VERSION = 0x0d8e6e2c;
    bytes4 constant SELECTOR_SET_VERSION = 0x788bc78c;
    bytes4 constant SELECTOR_GET_DATE = 0x430fe9c1;
    bytes4 constant SELECTOR_SET_DATE = 0x03c0a389;

    address constant MODULE_ISSUER = 0x26a79B946C58fDa1b23a2E88bFEfA7E2a8F7DAf8;
    bytes4 constant SELECTOR_GET_ORACLE_TYPE = 0xd72e0705;
    bytes4 constant SELECTOR_SET_ORACLE_TYPE = 0xe6dbd15d;
    bytes4 constant SELECTOR_GET_VERSION_VIA_EXCHANGER = 0x10916f3b;

    address constant MODULE_EXCHANGER = 0x1f0A572FF4B2850D747be740728E7CBCE17755e9;
    bytes4 constant SELECTOR_GET_SYSTEM_VERSION = 0xe017bb0d;

    fallback() external {
        address implementation;
        if (
            msg.sig == SELECTOR_GET_VERSION ||
            msg.sig == SELECTOR_SET_VERSION ||
            msg.sig == SELECTOR_GET_DATE ||
            msg.sig == SELECTOR_SET_DATE
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
