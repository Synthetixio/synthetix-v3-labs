//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


// Note: This contract should be dynamically generated
contract Synthetix {
    string public constant versionId = "1";

    bytes4 constant SELECTOR_GET_VALUE = 0x20965255;
    bytes4 constant SELECTOR_SET_VALUE = 0x93a09352;

    address constant MODULE_ISSUER = 0x6F7C78decFf421DfAe061D6B318DA0c1f42C272C;
    address constant MODULE_EXCHANGER = 0xF163bE0294331E58cA7fEa4f637A4D771F8C2580;

    fallback() external {

        address implementation;
        if (msg.sig == SELECTOR_SET_VALUE) implementation = MODULE_EXCHANGER;
        else if (msg.sig == SELECTOR_GET_VALUE) implementation = MODULE_EXCHANGER;

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
