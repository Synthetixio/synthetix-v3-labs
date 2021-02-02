
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Synthetix {
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // GENERATED CODE - do not edit manually
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------

    fallback() external {
        // Lookup table: Function selector => implementation contract
        address implementation;
        if (
          msg.sig == 0x430fe9c1 /*getDate*/ ||
          msg.sig == 0x85b3391c /*getDateAndVersion*/ ||
          msg.sig == 0x0d8e6e2c /*getVersion*/ ||
          msg.sig == 0x03c0a389 /*setDate*/ ||
          msg.sig == 0x788bc78c /*setVersion*/
        ) implementation = 0xfaDaD0Bff1082d106C0F06023Dac66750172244a /*SystemModule*/;
        else if (
          msg.sig == 0xd72e0705 /*getOracleType*/ ||
          msg.sig == 0x10916f3b /*getVersionViaExchanger*/ ||
          msg.sig == 0xe6dbd15d /*setOracleType*/
        ) implementation = 0x3Bb4145F86b1F6519aCBf4438A808E9Bf6C5cC8A /*IssuerModule*/;
        else if (
          msg.sig == 0xe017bb0d /*getSystemVersion*/
        ) implementation = 0x8B399a32deCa6CC56A21CF6c092D9DF05211CF72 /*ExchangerModule*/;
        else {
          revert("Unknown selector");
        }

        // Delegatecall to the implementation contract
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
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
}
