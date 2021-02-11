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
        bytes4 sig4 = msg.sig;
        address implementation;
        assembly {
            let sig32 := shr(224, sig4)

            function findImplementation(sig) -> result {
                let SettingsModule := 0x1D8D70AD07C8E7E442AD78E4AC0A16f958Eba7F0
                let UpgradeModule := 0xA9e6Bfa2BF53dE88FEb19761D9b2eE2e821bF1Bf
                let OwnerModule := 0x1E3b98102e19D3a164d239BdD190913C2F02E756

                switch sig
                case 0x13af4035 { result := OwnerModule } // OwnerModule.setOwner()
                case 0x3659cfe6 { result := UpgradeModule } // UpgradeModule.upgradeTo()
                case 0x38536275 { result := SettingsModule } // SettingsModule.setMinCollateralRatio()
                case 0x4c8f35ab { result := SettingsModule } // SettingsModule.getMinCollateralRatio()
                case 0x893d20e8 { result := OwnerModule } // OwnerModule.getOwner()
                case 0xaaf10f42 { result := UpgradeModule } // UpgradeModule.getImplementation()
                leave
            }

            implementation := findImplementation(sig32)
        }

        require(implementation != address(0), "Unknown selector");

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
