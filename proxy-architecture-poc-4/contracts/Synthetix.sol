
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
          msg.sig == 0x893d20e8 /*getOwner*/ ||
          msg.sig == 0x937f4d5f /*getOwnerAndVersion*/ ||
          msg.sig == 0x0d8e6e2c /*getVersion*/ ||
          msg.sig == 0x13af4035 /*setOwner*/ ||
          msg.sig == 0x788bc78c /*setVersion*/
        ) implementation = 0x8198f5d8F8CfFE8f9C413d98a0A55aEB8ab9FbB7 /*SystemModule*/;
        else if (
          msg.sig == 0xd72e0705 /*getOracleType*/ ||
          msg.sig == 0x10916f3b /*getVersionViaExchanger*/ ||
          msg.sig == 0xe6dbd15d /*setOracleType*/
        ) implementation = 0x0355B7B8cb128fA5692729Ab3AAa199C1753f726 /*IssuerModule*/;
        else if (
          msg.sig == 0xe017bb0d /*getSystemVersion*/
        ) implementation = 0x202CCe504e04bEd6fC0521238dDf04Bc9E8E15aB /*ExchangerModule*/;
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
