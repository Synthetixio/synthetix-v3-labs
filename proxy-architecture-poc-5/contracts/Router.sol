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
        ) implementation = 0x9d4454B023096f34B160D6B654540c56A1F81688 /*UpgradeModule*/;
        else if (
          msg.sig == 0x4c8f35ab /*getMinCollateralRatio*/ ||
          msg.sig == 0x38536275 /*setMinCollateralRatio*/
        ) implementation = 0x5f3f1dBD7B74C6B46e8c44f98792A1dAf8d69154 /*SettingsModule*/;
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
