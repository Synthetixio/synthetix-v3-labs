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
          msg.sig == 0x6b59084d /*test1*/ ||
          msg.sig == 0x7839c9a0 /*test10*/ ||
          msg.sig == 0xd2d70754 /*test100*/ ||
          msg.sig == 0xfa8b8ea1 /*test11*/ ||
          msg.sig == 0xd4bad72a /*test12*/ ||
          msg.sig == 0x41ef3738 /*test13*/ ||
          msg.sig == 0xc5f8f031 /*test14*/ ||
          msg.sig == 0xe30fa944 /*test15*/ ||
          msg.sig == 0x9591aa82 /*test16*/ ||
          msg.sig == 0xfeb53275 /*test17*/ ||
          msg.sig == 0xb23d404c /*test18*/ ||
          msg.sig == 0xca35b775 /*test19*/ ||
          msg.sig == 0x66e41cb7 /*test2*/ ||
          msg.sig == 0xee89f07c /*test20*/ ||
          msg.sig == 0xa5e124eb /*test21*/ ||
          msg.sig == 0xa1ca68bd /*test22*/ ||
          msg.sig == 0x5e54e982 /*test23*/ ||
          msg.sig == 0xb079af8e /*test24*/ ||
          msg.sig == 0xd5e733f7 /*test25*/ ||
          msg.sig == 0x558cb882 /*test26*/ ||
          msg.sig == 0x810b2ab5 /*test27*/ ||
          msg.sig == 0xb3a92044 /*test28*/ ||
          msg.sig == 0x0ba07746 /*test29*/ ||
          msg.sig == 0x0a8e8e01 /*test3*/ ||
          msg.sig == 0x82aaf544 /*test30*/ ||
          msg.sig == 0xb0c4c0d5 /*test31*/ ||
          msg.sig == 0x66e0b067 /*test32*/ ||
          msg.sig == 0x0604f9ec /*test33*/ ||
          msg.sig == 0x6f0befdc /*test34*/ ||
          msg.sig == 0x117753d9 /*test35*/ ||
          msg.sig == 0x0c1284a1 /*test36*/ ||
          msg.sig == 0xce32d1c3 /*test37*/ ||
          msg.sig == 0xac47793a /*test38*/ ||
          msg.sig == 0x52fb8013 /*test39*/ ||
          msg.sig == 0x8f0d282d /*test4*/ ||
          msg.sig == 0x06fe01a4 /*test40*/ ||
          msg.sig == 0x6121490e /*test41*/ ||
          msg.sig == 0xdb24b415 /*test42*/ ||
          msg.sig == 0xbe08e12b /*test43*/ ||
          msg.sig == 0xb06335e7 /*test44*/ ||
          msg.sig == 0xbf018554 /*test45*/ ||
          msg.sig == 0xc7ad392f /*test46*/ ||
          msg.sig == 0x8df2341b /*test47*/ ||
          msg.sig == 0x546b486d /*test48*/ ||
          msg.sig == 0x97d78182 /*test49*/ ||
          msg.sig == 0x1ad7be82 /*test5*/ ||
          msg.sig == 0x0b8b3746 /*test50*/ ||
          msg.sig == 0x1990b834 /*test51*/ ||
          msg.sig == 0x916d83db /*test52*/ ||
          msg.sig == 0xeecbd32a /*test53*/ ||
          msg.sig == 0xd4a95c13 /*test54*/ ||
          msg.sig == 0xfacdcda8 /*test55*/ ||
          msg.sig == 0xfb85396b /*test56*/ ||
          msg.sig == 0x7fb68261 /*test57*/ ||
          msg.sig == 0x47cf780f /*test58*/ ||
          msg.sig == 0xd5c34e4b /*test59*/ ||
          msg.sig == 0x6f3babc4 /*test6*/ ||
          msg.sig == 0x3db04260 /*test60*/ ||
          msg.sig == 0xb702591b /*test61*/ ||
          msg.sig == 0x98f32fd8 /*test62*/ ||
          msg.sig == 0x42289fbe /*test63*/ ||
          msg.sig == 0xd1db2d54 /*test64*/ ||
          msg.sig == 0x13c524e6 /*test65*/ ||
          msg.sig == 0xfc9ad801 /*test66*/ ||
          msg.sig == 0x43c77d51 /*test67*/ ||
          msg.sig == 0x797201ec /*test68*/ ||
          msg.sig == 0x1713a1c0 /*test69*/ ||
          msg.sig == 0x66e84d62 /*test7*/ ||
          msg.sig == 0xa6d4481c /*test70*/ ||
          msg.sig == 0xf36b9eb3 /*test71*/ ||
          msg.sig == 0x7639747e /*test72*/ ||
          msg.sig == 0x1b64c1a7 /*test73*/ ||
          msg.sig == 0x4579ba59 /*test74*/ ||
          msg.sig == 0x5e296104 /*test75*/ ||
          msg.sig == 0x1c7b50ab /*test76*/ ||
          msg.sig == 0x6bc20481 /*test77*/ ||
          msg.sig == 0xf1d48d0a /*test78*/ ||
          msg.sig == 0x5f6f7b7a /*test79*/ ||
          msg.sig == 0xc38f6f0b /*test8*/ ||
          msg.sig == 0x4535eecf /*test80*/ ||
          msg.sig == 0x766d9deb /*test81*/ ||
          msg.sig == 0x0ac421ac /*test82*/ ||
          msg.sig == 0x80297e0a /*test83*/ ||
          msg.sig == 0xb191e898 /*test84*/ ||
          msg.sig == 0xc38f5b3b /*test85*/ ||
          msg.sig == 0x746831ee /*test86*/ ||
          msg.sig == 0x751d4a8c /*test87*/ ||
          msg.sig == 0xac3fa560 /*test88*/ ||
          msg.sig == 0x7baa594f /*test89*/ ||
          msg.sig == 0xa7deec92 /*test9*/ ||
          msg.sig == 0x9ed3371b /*test90*/ ||
          msg.sig == 0xf4292b48 /*test91*/ ||
          msg.sig == 0x60d3cdcb /*test92*/ ||
          msg.sig == 0xce6afb8d /*test93*/ ||
          msg.sig == 0x4864ea4a /*test94*/ ||
          msg.sig == 0x9df17257 /*test95*/ ||
          msg.sig == 0xcc1c4819 /*test96*/ ||
          msg.sig == 0xb99f4204 /*test97*/ ||
          msg.sig == 0xe4f58441 /*test98*/ ||
          msg.sig == 0xc79e3b48 /*test99*/
        ) implementation = 0x9BcC604D4381C5b0Ad12Ff3Bf32bEdE063416BC7 /*DummyModule*/;
        else if (
          msg.sig == 0x4c8f35ab /*getMinCollateralRatio*/ ||
          msg.sig == 0x38536275 /*setMinCollateralRatio*/
        ) implementation = 0x63fea6E447F120B8Faf85B53cdaD8348e645D80E /*SettingsModule*/;
        else if (
          msg.sig == 0xaaf10f42 /*getImplementation*/ ||
          msg.sig == 0x893d20e8 /*getOwner*/ ||
          msg.sig == 0xd784d426 /*setImplementation*/ ||
          msg.sig == 0x13af4035 /*setOwner*/
        ) implementation = 0xdFdE6B33f13de2CA1A75A6F7169f50541B14f75b /*UpgradeModule*/;
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
