
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
        ) implementation = 0x5FbDB2315678afecb367f032d93F642f64180aa3 /*SystemModule*/;
        else if (
          msg.sig == 0xd72e0705 /*getOracleType*/ ||
          msg.sig == 0x10916f3b /*getVersionViaExchanger*/ ||
          msg.sig == 0xe6dbd15d /*setOracleType*/
        ) implementation = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 /*IssuerModule*/;
        else if (
          msg.sig == 0xe017bb0d /*getSystemVersion*/
        ) implementation = 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 /*ExchangerModule*/;
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
