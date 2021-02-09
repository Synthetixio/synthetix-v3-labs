//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Router {
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // GENERATED CODE - do not edit manually
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------

    fallback() external {
        // Lookup table: Function selector => implementation contract
        address implementation;
        if (
          msg.sig == 0xaaf10f42 /*getImplementation*/ ||
          msg.sig == 0x99def969 /*getNumPastImplementations*/ ||
          msg.sig == 0x893d20e8 /*getOwner*/ ||
          msg.sig == 0xe8b34e42 /*getPastImplementation*/ ||
          msg.sig == 0xd784d426 /*setImplementation*/ ||
          msg.sig == 0x13af4035 /*setOwner*/ ||
          msg.sig == 0xa79905c0 /*setPastImplementation*/
        ) implementation = 0xf5059a5D33d5853360D16C683c16e67980206f36 /*UpgradeModule*/;
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
