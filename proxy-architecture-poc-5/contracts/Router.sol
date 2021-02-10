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
            
            let DummyModule := 0x9BcC604D4381C5b0Ad12Ff3Bf32bEdE063416BC7
            let SettingsModule := 0x63fea6E447F120B8Faf85B53cdaD8348e645D80E
            let UpgradeModule := 0xdFdE6B33f13de2CA1A75A6F7169f50541B14f75b

            switch sig32
            case 0x6b59084d /*test1*/ { implementation := DummyModule }
            case 0x7839c9a0 /*test10*/ { implementation := DummyModule }
            case 0xd2d70754 /*test100*/ { implementation := DummyModule }
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
            case 0x6121490e /*test41*/ { implementation := DummyModule }
            case 0xdb24b415 /*test42*/ { implementation := DummyModule }
            case 0xbe08e12b /*test43*/ { implementation := DummyModule }
            case 0xb06335e7 /*test44*/ { implementation := DummyModule }
            case 0xbf018554 /*test45*/ { implementation := DummyModule }
            case 0xc7ad392f /*test46*/ { implementation := DummyModule }
            case 0x8df2341b /*test47*/ { implementation := DummyModule }
            case 0x546b486d /*test48*/ { implementation := DummyModule }
            case 0x97d78182 /*test49*/ { implementation := DummyModule }
            case 0x1ad7be82 /*test5*/ { implementation := DummyModule }
            case 0x0b8b3746 /*test50*/ { implementation := DummyModule }
            case 0x1990b834 /*test51*/ { implementation := DummyModule }
            case 0x916d83db /*test52*/ { implementation := DummyModule }
            case 0xeecbd32a /*test53*/ { implementation := DummyModule }
            case 0xd4a95c13 /*test54*/ { implementation := DummyModule }
            case 0xfacdcda8 /*test55*/ { implementation := DummyModule }
            case 0xfb85396b /*test56*/ { implementation := DummyModule }
            case 0x7fb68261 /*test57*/ { implementation := DummyModule }
            case 0x47cf780f /*test58*/ { implementation := DummyModule }
            case 0xd5c34e4b /*test59*/ { implementation := DummyModule }
            case 0x6f3babc4 /*test6*/ { implementation := DummyModule }
            case 0x3db04260 /*test60*/ { implementation := DummyModule }
            case 0xb702591b /*test61*/ { implementation := DummyModule }
            case 0x98f32fd8 /*test62*/ { implementation := DummyModule }
            case 0x42289fbe /*test63*/ { implementation := DummyModule }
            case 0xd1db2d54 /*test64*/ { implementation := DummyModule }
            case 0x13c524e6 /*test65*/ { implementation := DummyModule }
            case 0xfc9ad801 /*test66*/ { implementation := DummyModule }
            case 0x43c77d51 /*test67*/ { implementation := DummyModule }
            case 0x797201ec /*test68*/ { implementation := DummyModule }
            case 0x1713a1c0 /*test69*/ { implementation := DummyModule }
            case 0x66e84d62 /*test7*/ { implementation := DummyModule }
            case 0xa6d4481c /*test70*/ { implementation := DummyModule }
            case 0xf36b9eb3 /*test71*/ { implementation := DummyModule }
            case 0x7639747e /*test72*/ { implementation := DummyModule }
            case 0x1b64c1a7 /*test73*/ { implementation := DummyModule }
            case 0x4579ba59 /*test74*/ { implementation := DummyModule }
            case 0x5e296104 /*test75*/ { implementation := DummyModule }
            case 0x1c7b50ab /*test76*/ { implementation := DummyModule }
            case 0x6bc20481 /*test77*/ { implementation := DummyModule }
            case 0xf1d48d0a /*test78*/ { implementation := DummyModule }
            case 0x5f6f7b7a /*test79*/ { implementation := DummyModule }
            case 0xc38f6f0b /*test8*/ { implementation := DummyModule }
            case 0x4535eecf /*test80*/ { implementation := DummyModule }
            case 0x766d9deb /*test81*/ { implementation := DummyModule }
            case 0x0ac421ac /*test82*/ { implementation := DummyModule }
            case 0x80297e0a /*test83*/ { implementation := DummyModule }
            case 0xb191e898 /*test84*/ { implementation := DummyModule }
            case 0xc38f5b3b /*test85*/ { implementation := DummyModule }
            case 0x746831ee /*test86*/ { implementation := DummyModule }
            case 0x751d4a8c /*test87*/ { implementation := DummyModule }
            case 0xac3fa560 /*test88*/ { implementation := DummyModule }
            case 0x7baa594f /*test89*/ { implementation := DummyModule }
            case 0xa7deec92 /*test9*/ { implementation := DummyModule }
            case 0x9ed3371b /*test90*/ { implementation := DummyModule }
            case 0xf4292b48 /*test91*/ { implementation := DummyModule }
            case 0x60d3cdcb /*test92*/ { implementation := DummyModule }
            case 0xce6afb8d /*test93*/ { implementation := DummyModule }
            case 0x4864ea4a /*test94*/ { implementation := DummyModule }
            case 0x9df17257 /*test95*/ { implementation := DummyModule }
            case 0xcc1c4819 /*test96*/ { implementation := DummyModule }
            case 0xb99f4204 /*test97*/ { implementation := DummyModule }
            case 0xe4f58441 /*test98*/ { implementation := DummyModule }
            case 0xc79e3b48 /*test99*/ { implementation := DummyModule }
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
