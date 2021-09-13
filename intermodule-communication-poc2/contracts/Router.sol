//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// --------------------------------------------------------------------------------
// --------------------------------------------------------------------------------
// GENERATED CODE - do not edit manually
// --------------------------------------------------------------------------------
// --------------------------------------------------------------------------------

contract Router {
    address constant AModule = 0x3b014c0307Ad9dc4262F1696BC463Fd3c6dC4679;
    address constant BModule = 0xBE46bA58D315f0d6cD37bd7F313ccBfdC760e891;
    bytes32 constant AModuleId = 'AModule';
    bytes32 constant BModuleId = 'BModule';
    
    function getModuleAddress(uint256 id) public pure returns (address) {
        if (id == 2) return AModule;
        if (id == 1) return BModule;
        revert('Unknown ID');
    }
    
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
                    
                    case 0xd04c3e25 { result := AModule } // AModule.resetBValue5() 0xd04c3e25 
                    case 0x5dc12cbc { result := AModule } // AModule.getBValue5()   0x5dc12cbc 0000000000000000000000000000000000000000000000000000000000000001
                    
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