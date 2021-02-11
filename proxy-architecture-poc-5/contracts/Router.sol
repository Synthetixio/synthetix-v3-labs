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
                let UpgradeModule := 0x3BFbbf82657577668144921b96aAb72BC170646C
                let DummyModule := 0x930b218f3e63eE452c13561057a8d5E61367d5b7
                let SettingsModule := 0x721d8077771Ebf9B931733986d619aceea412a1C
                let OwnerModule := 0x38c76A767d45Fc390160449948aF80569E2C4217
                let AModule := 0xDC57724Ea354ec925BaFfCA0cCf8A1248a8E5CF1
                let BModule := 0xfc073209b7936A771F77F63D42019a3a93311869
                let RegistryModule := 0xb4e9A5BC64DC07f890367F72941403EEd7faDCbB

                if lt(sig,0x8cb90714) {
                    if lt(sig,0x52fb8013) {
                        if lt(sig,0x20965255) {
                            if lt(sig,0x13af4035) {
                                if lt(sig,0x0b8b3746) {
                                    switch sig
                                    case 0x0604f9ec { result := DummyModule } // DummyModule.test33()
                                    case 0x06fe01a4 { result := DummyModule } // DummyModule.test40()
                                    case 0x0a8e8e01 { result := DummyModule } // DummyModule.test3()
                                    case 0x0ac421ac { result := DummyModule } // DummyModule.test82()
                                    leave
                                }
                                switch sig
                                case 0x0b8b3746 { result := DummyModule } // DummyModule.test50()
                                case 0x0ba07746 { result := DummyModule } // DummyModule.test29()
                                case 0x0c1284a1 { result := DummyModule } // DummyModule.test36()
                                case 0x117753d9 { result := DummyModule } // DummyModule.test35()
                                leave
                            }
                            switch sig
                            case 0x13af4035 { result := OwnerModule } // OwnerModule.setOwner()
                            case 0x13c524e6 { result := DummyModule } // DummyModule.test65()
                            case 0x1713a1c0 { result := DummyModule } // DummyModule.test69()
                            case 0x1990b834 { result := DummyModule } // DummyModule.test51()
                            case 0x1ad7be82 { result := DummyModule } // DummyModule.test5()
                            case 0x1b64c1a7 { result := DummyModule } // DummyModule.test73()
                            case 0x1c7b50ab { result := DummyModule } // DummyModule.test76()
                            leave
                        }
                        if lt(sig,0x43c77d51) {
                            switch sig
                            case 0x20965255 { result := BModule } // BModule.getValue()
                            case 0x3659cfe6 { result := UpgradeModule } // UpgradeModule.upgradeTo()
                            case 0x38536275 { result := SettingsModule } // SettingsModule.setMinCollateralRatio()
                            case 0x3d9673f5 { result := RegistryModule } // RegistryModule.getModuleImplementation()
                            case 0x3db04260 { result := DummyModule } // DummyModule.test60()
                            case 0x41ef3738 { result := DummyModule } // DummyModule.test13()
                            case 0x42289fbe { result := DummyModule } // DummyModule.test63()
                            leave
                        }
                        switch sig
                        case 0x43c77d51 { result := DummyModule } // DummyModule.test67()
                        case 0x4535eecf { result := DummyModule } // DummyModule.test80()
                        case 0x4579ba59 { result := DummyModule } // DummyModule.test74()
                        case 0x47cf780f { result := DummyModule } // DummyModule.test58()
                        case 0x4864ea4a { result := DummyModule } // DummyModule.test94()
                        case 0x49cf5a17 { result := RegistryModule } // RegistryModule.registerModules()
                        case 0x4c8f35ab { result := SettingsModule } // SettingsModule.getMinCollateralRatio()
                        leave
                    }
                    if lt(sig,0x6f0befdc) {
                        if lt(sig,0x60d3cdcb) {
                            switch sig
                            case 0x52fb8013 { result := DummyModule } // DummyModule.test39()
                            case 0x546b486d { result := DummyModule } // DummyModule.test48()
                            case 0x55241077 { result := BModule } // BModule.setValue()
                            case 0x558cb882 { result := DummyModule } // DummyModule.test26()
                            case 0x5e296104 { result := DummyModule } // DummyModule.test75()
                            case 0x5e54e982 { result := DummyModule } // DummyModule.test23()
                            case 0x5f6f7b7a { result := DummyModule } // DummyModule.test79()
                            leave
                        }
                        switch sig
                        case 0x60d3cdcb { result := DummyModule } // DummyModule.test92()
                        case 0x6121490e { result := DummyModule } // DummyModule.test41()
                        case 0x66e0b067 { result := DummyModule } // DummyModule.test32()
                        case 0x66e41cb7 { result := DummyModule } // DummyModule.test2()
                        case 0x66e84d62 { result := DummyModule } // DummyModule.test7()
                        case 0x6b59084d { result := DummyModule } // DummyModule.test1()
                        case 0x6bc20481 { result := DummyModule } // DummyModule.test77()
                        leave
                    }
                    if lt(sig,0x797201ec) {
                        switch sig
                        case 0x6f0befdc { result := DummyModule } // DummyModule.test34()
                        case 0x6f3babc4 { result := DummyModule } // DummyModule.test6()
                        case 0x746831ee { result := DummyModule } // DummyModule.test86()
                        case 0x751d4a8c { result := DummyModule } // DummyModule.test87()
                        case 0x7639747e { result := DummyModule } // DummyModule.test72()
                        case 0x766d9deb { result := DummyModule } // DummyModule.test81()
                        case 0x7839c9a0 { result := DummyModule } // DummyModule.test10()
                        leave
                    }
                    switch sig
                    case 0x797201ec { result := DummyModule } // DummyModule.test68()
                    case 0x7baa594f { result := DummyModule } // DummyModule.test89()
                    case 0x7fb68261 { result := DummyModule } // DummyModule.test57()
                    case 0x80297e0a { result := DummyModule } // DummyModule.test83()
                    case 0x810b2ab5 { result := DummyModule } // DummyModule.test27()
                    case 0x82aaf544 { result := DummyModule } // DummyModule.test30()
                    case 0x893d20e8 { result := OwnerModule } // OwnerModule.getOwner()
                    leave
                }
                if lt(sig,0xc79e3b48) {
                    if lt(sig,0xac47793a) {
                        if lt(sig,0x9ed3371b) {
                            if lt(sig,0x9591aa82) {
                                switch sig
                                case 0x8cb90714 { result := AModule } // AModule.setValueViaBModule_router()
                                case 0x8df2341b { result := DummyModule } // DummyModule.test47()
                                case 0x8f0d282d { result := DummyModule } // DummyModule.test4()
                                case 0x916d83db { result := DummyModule } // DummyModule.test52()
                                leave
                            }
                            switch sig
                            case 0x9591aa82 { result := DummyModule } // DummyModule.test16()
                            case 0x97d78182 { result := DummyModule } // DummyModule.test49()
                            case 0x98f32fd8 { result := DummyModule } // DummyModule.test62()
                            case 0x9df17257 { result := DummyModule } // DummyModule.test95()
                            leave
                        }
                        switch sig
                        case 0x9ed3371b { result := DummyModule } // DummyModule.test90()
                        case 0xa1ca68bd { result := DummyModule } // DummyModule.test22()
                        case 0xa5e124eb { result := DummyModule } // DummyModule.test21()
                        case 0xa6d4481c { result := DummyModule } // DummyModule.test70()
                        case 0xa7deec92 { result := DummyModule } // DummyModule.test9()
                        case 0xaaf10f42 { result := UpgradeModule } // UpgradeModule.getImplementation()
                        case 0xac3fa560 { result := DummyModule } // DummyModule.test88()
                        leave
                    }
                    if lt(sig,0xb702591b) {
                        switch sig
                        case 0xac47793a { result := DummyModule } // DummyModule.test38()
                        case 0xb06335e7 { result := DummyModule } // DummyModule.test44()
                        case 0xb079af8e { result := DummyModule } // DummyModule.test24()
                        case 0xb0c4c0d5 { result := DummyModule } // DummyModule.test31()
                        case 0xb191e898 { result := DummyModule } // DummyModule.test84()
                        case 0xb23d404c { result := DummyModule } // DummyModule.test18()
                        case 0xb3a92044 { result := DummyModule } // DummyModule.test28()
                        leave
                    }
                    switch sig
                    case 0xb702591b { result := DummyModule } // DummyModule.test61()
                    case 0xb99f4204 { result := DummyModule } // DummyModule.test97()
                    case 0xbe08e12b { result := DummyModule } // DummyModule.test43()
                    case 0xbf018554 { result := DummyModule } // DummyModule.test45()
                    case 0xc38f5b3b { result := DummyModule } // DummyModule.test85()
                    case 0xc38f6f0b { result := DummyModule } // DummyModule.test8()
                    case 0xc5f8f031 { result := DummyModule } // DummyModule.test14()
                    leave
                }
                if lt(sig,0xdb24b415) {
                    if lt(sig,0xd2d70754) {
                        switch sig
                        case 0xc79e3b48 { result := DummyModule } // DummyModule.test99()
                        case 0xc7ad392f { result := DummyModule } // DummyModule.test46()
                        case 0xca35b775 { result := DummyModule } // DummyModule.test19()
                        case 0xcc1c4819 { result := DummyModule } // DummyModule.test96()
                        case 0xce32d1c3 { result := DummyModule } // DummyModule.test37()
                        case 0xce6afb8d { result := DummyModule } // DummyModule.test93()
                        case 0xd1db2d54 { result := DummyModule } // DummyModule.test64()
                        leave
                    }
                    switch sig
                    case 0xd2d70754 { result := DummyModule } // DummyModule.test100()
                    case 0xd4a95c13 { result := DummyModule } // DummyModule.test54()
                    case 0xd4bad72a { result := DummyModule } // DummyModule.test12()
                    case 0xd5c34e4b { result := DummyModule } // DummyModule.test59()
                    case 0xd5e733f7 { result := DummyModule } // DummyModule.test25()
                    case 0xd8d20484 { result := AModule } // AModule.setValueViaBModule_cast()
                    case 0xdaa3a163 { result := UpgradeModule } // UpgradeModule.isUpgradeable()
                    leave
                }
                if lt(sig,0xf36b9eb3) {
                    switch sig
                    case 0xdb24b415 { result := DummyModule } // DummyModule.test42()
                    case 0xe30fa944 { result := DummyModule } // DummyModule.test15()
                    case 0xe4f58441 { result := DummyModule } // DummyModule.test98()
                    case 0xee89f07c { result := DummyModule } // DummyModule.test20()
                    case 0xeecbd32a { result := DummyModule } // DummyModule.test53()
                    case 0xf1d48d0a { result := DummyModule } // DummyModule.test78()
                    case 0xf21a9c0d { result := AModule } // AModule.setValueViaBModule_direct()
                    leave
                }
                switch sig
                case 0xf36b9eb3 { result := DummyModule } // DummyModule.test71()
                case 0xf4292b48 { result := DummyModule } // DummyModule.test91()
                case 0xfa8b8ea1 { result := DummyModule } // DummyModule.test11()
                case 0xfacdcda8 { result := DummyModule } // DummyModule.test55()
                case 0xfb85396b { result := DummyModule } // DummyModule.test56()
                case 0xfc9ad801 { result := DummyModule } // DummyModule.test66()
                case 0xfeb53275 { result := DummyModule } // DummyModule.test17()
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
