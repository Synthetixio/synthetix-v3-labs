
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Synthetix {
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // GENERATED CODE - do not edit manually
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------

    fallback() external {
        // Function selector to implementation contract lookup table
        address implementation;
        if (
          msg.sig == 0x430fe9c1 ||
          msg.sig == 0x0d8e6e2c ||
          msg.sig == 0x03c0a389 ||
          msg.sig == 0x788bc78c
        ) implementation = 0xD2c7D79ED97DfBE878a164F261549ddEeA4aD8a6;
        else if (
          msg.sig == 0xd72e0705 ||
          msg.sig == 0x10916f3b ||
          msg.sig == 0xe6dbd15d
        ) implementation = 0x3Bb4145F86b1F6519aCBf4438A808E9Bf6C5cC8A;
        else if (
          msg.sig == 0xe017bb0d
        ) implementation = 0x8B399a32deCa6CC56A21CF6c092D9DF05211CF72;
        require(implementation != address(0), "Selector not registered in any module");

        // Delegatecall forwarder
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
}
