//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


// Note: This contract should be dynamically generated
contract Synthetix {
    string public constant versionId = "1";

    bytes4 constant SELECTOR_GET_VALUE = 0x20965255;
    bytes4 constant SELECTOR_SET_VALUE = 0x93a09352;
    bytes4 constant SELECTOR_GET_VALUE_VIA_EXCHANGER = 0x43ce657d;

    address constant MODULE_ISSUER = 0xF80d27Bd332301ee5AbEeEAad419360be816f5fC;
    address constant MODULE_EXCHANGER = 0x48D79c516C2494AcDCfC059615964E207Da81b0d;

    fallback() external {

        address implementation;
        if (msg.sig == SELECTOR_SET_VALUE) implementation = MODULE_EXCHANGER;
        else if (msg.sig == SELECTOR_GET_VALUE) implementation = MODULE_EXCHANGER;
        else if (msg.sig == SELECTOR_GET_VALUE_VIA_EXCHANGER) implementation = MODULE_ISSUER;

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
}
