//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// --------------------------------------------------------------------------------
// --------------------------------------------------------------------------------
// GENERATED CODE - do not edit manually
// --------------------------------------------------------------------------------
// --------------------------------------------------------------------------------

contract Router {
    address constant AModule = 0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47;
    address constant BModule = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    fallback() external {
        // Lookup table: Function selector => implementation contract
        bytes4 sig4 = msg.sig;
        address implementation;
        assembly {
            let sig32 := shr(224, sig4)

            function findImplementation(sig) -> result {
                switch sig
                    case 0x5e1a7740 { result := BModule } // BModule.setBValue()    0x5e1a7740 0000000000000000000000000000000000000000000000000000000000000001
                    case 0x3841e2c5 { result := BModule } // BModule.resetBValue()  0x3841e2c5
                    case 0x7a63a91d { result := BModule } // BModule.getValue()     0x7a63a91d

                    case 0xfa6c95b3 { result := AModule } // AModule.resetBValue4() 0xfa6c95b3 
                    case 0x7197066d { result := AModule } // AModule.getBValue4()   0x7197066d 0000000000000000000000000000000000000000000000000000000000000001

                    case 0x7a066c4a { result := AModule } // AModule.resetBValue1() 0x7a066c4a 
                    case 0xfdf148d5 { result := AModule } // AModule.getBValue1()   0xfdf148d5 0000000000000000000000000000000000000000000000000000000000000001
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
}