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
          msg.sig == 0x893d20e8 /*getOwner*/ ||
          msg.sig == 0xd784d426 /*setImplementation*/ ||
          msg.sig == 0x13af4035 /*setOwner*/
        ) implementation = 0xE6E340D132b5f46d1e472DebcD681B2aBc16e57E /*UpgradeModule*/;
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
