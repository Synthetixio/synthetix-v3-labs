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
        ) implementation = 0x610178dA211FEF7D417bC0e6FeD39F05609AD788 /*SystemModule*/;
        else if (
          msg.sig == 0xd72e0705 /*getOracleType*/ ||
          msg.sig == 0x10916f3b /*getVersionViaExchanger*/ ||
          msg.sig == 0xe6dbd15d /*setOracleType*/
        ) implementation = 0xB7f8BC63BbcaD18155201308C8f3540b07f84F5e /*IssuerModule*/;
        else if (
          msg.sig == 0xe017bb0d /*getSystemVersion*/
        ) implementation = 0xA51c1fc2f0D1a1b8494Ed1FE312d7C3a78Ed91C0 /*ExchangerModule*/;
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
