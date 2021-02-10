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
              let DummyModule := 0xE8addD62feD354203d079926a8e563BC1A7FE81e
              let SettingsModule := 0xe039608E695D21aB11675EBBA00261A0e750526c
              let UpgradeModule := 0x071586BA1b380B00B793Cc336fe01106B0BFbE6D

              if lt(sig,0x0b8b3746) {
                switch sig
                case 0x0604f9ec { // DummyModule.test33()
                  result := DummyModule
                  leave
                }
                case 0x06fe01a4 { // DummyModule.test40()
                  result := DummyModule
                  leave
                }
                case 0x0a8e8e01 { // DummyModule.test3()
                  result := DummyModule
                  leave
                }
                case 0x0ac421ac { // DummyModule.test82()
                  result := DummyModule
                  leave
                }
                case 0x0b8b3746 { // DummyModule.test50()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x13c524e6) {
                switch sig
                case 0x0ba07746 { // DummyModule.test29()
                  result := DummyModule
                  leave
                }
                case 0x0c1284a1 { // DummyModule.test36()
                  result := DummyModule
                  leave
                }
                case 0x117753d9 { // DummyModule.test35()
                  result := DummyModule
                  leave
                }
                case 0x13af4035 { // UpgradeModule.setOwner()
                  result := UpgradeModule
                  leave
                }
                case 0x13c524e6 { // DummyModule.test65()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x1c7b50ab) {
                switch sig
                case 0x1713a1c0 { // DummyModule.test69()
                  result := DummyModule
                  leave
                }
                case 0x1990b834 { // DummyModule.test51()
                  result := DummyModule
                  leave
                }
                case 0x1ad7be82 { // DummyModule.test5()
                  result := DummyModule
                  leave
                }
                case 0x1b64c1a7 { // DummyModule.test73()
                  result := DummyModule
                  leave
                }
                case 0x1c7b50ab { // DummyModule.test76()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x43c77d51) {
                switch sig
                case 0x38536275 { // SettingsModule.setMinCollateralRatio()
                  result := SettingsModule
                  leave
                }
                case 0x3db04260 { // DummyModule.test60()
                  result := DummyModule
                  leave
                }
                case 0x41ef3738 { // DummyModule.test13()
                  result := DummyModule
                  leave
                }
                case 0x42289fbe { // DummyModule.test63()
                  result := DummyModule
                  leave
                }
                case 0x43c77d51 { // DummyModule.test67()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x4c8f35ab) {
                switch sig
                case 0x4535eecf { // DummyModule.test80()
                  result := DummyModule
                  leave
                }
                case 0x4579ba59 { // DummyModule.test74()
                  result := DummyModule
                  leave
                }
                case 0x47cf780f { // DummyModule.test58()
                  result := DummyModule
                  leave
                }
                case 0x4864ea4a { // DummyModule.test94()
                  result := DummyModule
                  leave
                }
                case 0x4c8f35ab { // SettingsModule.getMinCollateralRatio()
                  result := SettingsModule
                  leave
                }
              }
              if lt(sig,0x5e54e982) {
                switch sig
                case 0x52fb8013 { // DummyModule.test39()
                  result := DummyModule
                  leave
                }
                case 0x546b486d { // DummyModule.test48()
                  result := DummyModule
                  leave
                }
                case 0x558cb882 { // DummyModule.test26()
                  result := DummyModule
                  leave
                }
                case 0x5e296104 { // DummyModule.test75()
                  result := DummyModule
                  leave
                }
                case 0x5e54e982 { // DummyModule.test23()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x66e41cb7) {
                switch sig
                case 0x5f6f7b7a { // DummyModule.test79()
                  result := DummyModule
                  leave
                }
                case 0x60d3cdcb { // DummyModule.test92()
                  result := DummyModule
                  leave
                }
                case 0x6121490e { // DummyModule.test41()
                  result := DummyModule
                  leave
                }
                case 0x66e0b067 { // DummyModule.test32()
                  result := DummyModule
                  leave
                }
                case 0x66e41cb7 { // DummyModule.test2()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x6f3babc4) {
                switch sig
                case 0x66e84d62 { // DummyModule.test7()
                  result := DummyModule
                  leave
                }
                case 0x6b59084d { // DummyModule.test1()
                  result := DummyModule
                  leave
                }
                case 0x6bc20481 { // DummyModule.test77()
                  result := DummyModule
                  leave
                }
                case 0x6f0befdc { // DummyModule.test34()
                  result := DummyModule
                  leave
                }
                case 0x6f3babc4 { // DummyModule.test6()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x7839c9a0) {
                switch sig
                case 0x746831ee { // DummyModule.test86()
                  result := DummyModule
                  leave
                }
                case 0x751d4a8c { // DummyModule.test87()
                  result := DummyModule
                  leave
                }
                case 0x7639747e { // DummyModule.test72()
                  result := DummyModule
                  leave
                }
                case 0x766d9deb { // DummyModule.test81()
                  result := DummyModule
                  leave
                }
                case 0x7839c9a0 { // DummyModule.test10()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x810b2ab5) {
                switch sig
                case 0x797201ec { // DummyModule.test68()
                  result := DummyModule
                  leave
                }
                case 0x7baa594f { // DummyModule.test89()
                  result := DummyModule
                  leave
                }
                case 0x7fb68261 { // DummyModule.test57()
                  result := DummyModule
                  leave
                }
                case 0x80297e0a { // DummyModule.test83()
                  result := DummyModule
                  leave
                }
                case 0x810b2ab5 { // DummyModule.test27()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x916d83db) {
                switch sig
                case 0x82aaf544 { // DummyModule.test30()
                  result := DummyModule
                  leave
                }
                case 0x893d20e8 { // UpgradeModule.getOwner()
                  result := UpgradeModule
                  leave
                }
                case 0x8df2341b { // DummyModule.test47()
                  result := DummyModule
                  leave
                }
                case 0x8f0d282d { // DummyModule.test4()
                  result := DummyModule
                  leave
                }
                case 0x916d83db { // DummyModule.test52()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0x9ed3371b) {
                switch sig
                case 0x9591aa82 { // DummyModule.test16()
                  result := DummyModule
                  leave
                }
                case 0x97d78182 { // DummyModule.test49()
                  result := DummyModule
                  leave
                }
                case 0x98f32fd8 { // DummyModule.test62()
                  result := DummyModule
                  leave
                }
                case 0x9df17257 { // DummyModule.test95()
                  result := DummyModule
                  leave
                }
                case 0x9ed3371b { // DummyModule.test90()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0xaaf10f42) {
                switch sig
                case 0xa1ca68bd { // DummyModule.test22()
                  result := DummyModule
                  leave
                }
                case 0xa5e124eb { // DummyModule.test21()
                  result := DummyModule
                  leave
                }
                case 0xa6d4481c { // DummyModule.test70()
                  result := DummyModule
                  leave
                }
                case 0xa7deec92 { // DummyModule.test9()
                  result := DummyModule
                  leave
                }
                case 0xaaf10f42 { // UpgradeModule.getImplementation()
                  result := UpgradeModule
                  leave
                }
              }
              if lt(sig,0xb0c4c0d5) {
                switch sig
                case 0xac3fa560 { // DummyModule.test88()
                  result := DummyModule
                  leave
                }
                case 0xac47793a { // DummyModule.test38()
                  result := DummyModule
                  leave
                }
                case 0xb06335e7 { // DummyModule.test44()
                  result := DummyModule
                  leave
                }
                case 0xb079af8e { // DummyModule.test24()
                  result := DummyModule
                  leave
                }
                case 0xb0c4c0d5 { // DummyModule.test31()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0xb99f4204) {
                switch sig
                case 0xb191e898 { // DummyModule.test84()
                  result := DummyModule
                  leave
                }
                case 0xb23d404c { // DummyModule.test18()
                  result := DummyModule
                  leave
                }
                case 0xb3a92044 { // DummyModule.test28()
                  result := DummyModule
                  leave
                }
                case 0xb702591b { // DummyModule.test61()
                  result := DummyModule
                  leave
                }
                case 0xb99f4204 { // DummyModule.test97()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0xc5f8f031) {
                switch sig
                case 0xbe08e12b { // DummyModule.test43()
                  result := DummyModule
                  leave
                }
                case 0xbf018554 { // DummyModule.test45()
                  result := DummyModule
                  leave
                }
                case 0xc38f5b3b { // DummyModule.test85()
                  result := DummyModule
                  leave
                }
                case 0xc38f6f0b { // DummyModule.test8()
                  result := DummyModule
                  leave
                }
                case 0xc5f8f031 { // DummyModule.test14()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0xce32d1c3) {
                switch sig
                case 0xc79e3b48 { // DummyModule.test99()
                  result := DummyModule
                  leave
                }
                case 0xc7ad392f { // DummyModule.test46()
                  result := DummyModule
                  leave
                }
                case 0xca35b775 { // DummyModule.test19()
                  result := DummyModule
                  leave
                }
                case 0xcc1c4819 { // DummyModule.test96()
                  result := DummyModule
                  leave
                }
                case 0xce32d1c3 { // DummyModule.test37()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0xd4bad72a) {
                switch sig
                case 0xce6afb8d { // DummyModule.test93()
                  result := DummyModule
                  leave
                }
                case 0xd1db2d54 { // DummyModule.test64()
                  result := DummyModule
                  leave
                }
                case 0xd2d70754 { // DummyModule.test100()
                  result := DummyModule
                  leave
                }
                case 0xd4a95c13 { // DummyModule.test54()
                  result := DummyModule
                  leave
                }
                case 0xd4bad72a { // DummyModule.test12()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0xe30fa944) {
                switch sig
                case 0xd5c34e4b { // DummyModule.test59()
                  result := DummyModule
                  leave
                }
                case 0xd5e733f7 { // DummyModule.test25()
                  result := DummyModule
                  leave
                }
                case 0xd784d426 { // UpgradeModule.setImplementation()
                  result := UpgradeModule
                  leave
                }
                case 0xdb24b415 { // DummyModule.test42()
                  result := DummyModule
                  leave
                }
                case 0xe30fa944 { // DummyModule.test15()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0xf36b9eb3) {
                switch sig
                case 0xe4f58441 { // DummyModule.test98()
                  result := DummyModule
                  leave
                }
                case 0xee89f07c { // DummyModule.test20()
                  result := DummyModule
                  leave
                }
                case 0xeecbd32a { // DummyModule.test53()
                  result := DummyModule
                  leave
                }
                case 0xf1d48d0a { // DummyModule.test78()
                  result := DummyModule
                  leave
                }
                case 0xf36b9eb3 { // DummyModule.test71()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0xfc9ad801) {
                switch sig
                case 0xf4292b48 { // DummyModule.test91()
                  result := DummyModule
                  leave
                }
                case 0xfa8b8ea1 { // DummyModule.test11()
                  result := DummyModule
                  leave
                }
                case 0xfacdcda8 { // DummyModule.test55()
                  result := DummyModule
                  leave
                }
                case 0xfb85396b { // DummyModule.test56()
                  result := DummyModule
                  leave
                }
                case 0xfc9ad801 { // DummyModule.test66()
                  result := DummyModule
                  leave
                }
              }
              if lt(sig,0xfeb53275) {
                switch sig
                case 0xfeb53275 { // DummyModule.test17()
                  result := DummyModule
                  leave
                }
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
