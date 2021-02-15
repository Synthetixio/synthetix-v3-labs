//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Router_local {
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
                if eq(and(sig, 64), 64) {
                    result := 0x32cd5ecdA7f2B8633C00A0434DE28Db111E60636 // UpgradeModule
                    leave
                }
                if eq(and(sig, 1), 1) {
                    result := 0xbeC6419cD931e29ef41157fe24C6928a0C952f0b // SettingsModule
                    leave
                }
                if eq(and(sig, 32), 32) {
                    result := 0x55027d3dBBcEA0327eF73eFd74ba0Af42A13A966 // OwnerModule
                    leave
                }
                if eq(and(sig, 4), 4) {
                    result := 0x9eb52339B52e71B1EFD5537947e75D23b3a7719B // AModule
                    leave
                }
                if eq(and(sig, 5), 5) {
                    result := 0x92b0d1Cc77b84973B7041CB9275d41F09840eaDd // BModule
                    leave
                }
                if eq(and(sig, 16), 16) {
                    result := 0x996785Fe937d92EDBF420F3Bf70Acc62ecD6f655 // RegistryModule
                    leave
                }
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
