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
            
            let DummyModule := 0x821f3361D454cc98b7555221A06Be563a7E2E0A6
            let SettingsModule := 0x1780bCf4103D3F501463AD3414c7f4b654bb7aFd
            let UpgradeModule := 0x5133BBdfCCa3Eb4F739D599ee4eC45cBCD0E16c5

            switch sig32
            case 0x6b59084d /*test1*/ { implementation := DummyModule }
            case 0x7839c9a0 /*test10*/ { implementation := DummyModule }
            case 0xfa8b8ea1 /*test11*/ { implementation := DummyModule }
            case 0xd4bad72a /*test12*/ { implementation := DummyModule }
            case 0x41ef3738 /*test13*/ { implementation := DummyModule }
            case 0xc5f8f031 /*test14*/ { implementation := DummyModule }
            case 0xe30fa944 /*test15*/ { implementation := DummyModule }
            case 0x9591aa82 /*test16*/ { implementation := DummyModule }
            case 0xfeb53275 /*test17*/ { implementation := DummyModule }
            case 0xb23d404c /*test18*/ { implementation := DummyModule }
            case 0xca35b775 /*test19*/ { implementation := DummyModule }
            case 0x66e41cb7 /*test2*/ { implementation := DummyModule }
            case 0xee89f07c /*test20*/ { implementation := DummyModule }
            case 0xa5e124eb /*test21*/ { implementation := DummyModule }
            case 0xa1ca68bd /*test22*/ { implementation := DummyModule }
            case 0x5e54e982 /*test23*/ { implementation := DummyModule }
            case 0xb079af8e /*test24*/ { implementation := DummyModule }
            case 0xd5e733f7 /*test25*/ { implementation := DummyModule }
            case 0x558cb882 /*test26*/ { implementation := DummyModule }
            case 0x810b2ab5 /*test27*/ { implementation := DummyModule }
            case 0xb3a92044 /*test28*/ { implementation := DummyModule }
            case 0x0ba07746 /*test29*/ { implementation := DummyModule }
            case 0x0a8e8e01 /*test3*/ { implementation := DummyModule }
            case 0x82aaf544 /*test30*/ { implementation := DummyModule }
            case 0xb0c4c0d5 /*test31*/ { implementation := DummyModule }
            case 0x66e0b067 /*test32*/ { implementation := DummyModule }
            case 0x0604f9ec /*test33*/ { implementation := DummyModule }
            case 0x6f0befdc /*test34*/ { implementation := DummyModule }
            case 0x117753d9 /*test35*/ { implementation := DummyModule }
            case 0x0c1284a1 /*test36*/ { implementation := DummyModule }
            case 0xce32d1c3 /*test37*/ { implementation := DummyModule }
            case 0xac47793a /*test38*/ { implementation := DummyModule }
            case 0x52fb8013 /*test39*/ { implementation := DummyModule }
            case 0x8f0d282d /*test4*/ { implementation := DummyModule }
            case 0x06fe01a4 /*test40*/ { implementation := DummyModule }
            case 0x1ad7be82 /*test5*/ { implementation := DummyModule }
            case 0x6f3babc4 /*test6*/ { implementation := DummyModule }
            case 0x66e84d62 /*test7*/ { implementation := DummyModule }
            case 0xc38f6f0b /*test8*/ { implementation := DummyModule }
            case 0xa7deec92 /*test9*/ { implementation := DummyModule }
            case 0x4c8f35ab /*getMinCollateralRatio*/ { implementation := SettingsModule }
            case 0x38536275 /*setMinCollateralRatio*/ { implementation := SettingsModule }
            case 0xaaf10f42 /*getImplementation*/ { implementation := UpgradeModule }
            case 0x893d20e8 /*getOwner*/ { implementation := UpgradeModule }
            case 0xd784d426 /*setImplementation*/ { implementation := UpgradeModule }
            case 0x13af4035 /*setOwner*/ { implementation := UpgradeModule }
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
