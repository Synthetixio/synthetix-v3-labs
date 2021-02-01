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
            msg.sig == 0x0d8e6e2c || // getVersion()
            msg.sig == 0x788bc78c || // setVersion(string)
            msg.sig == 0x430fe9c1 || // getDate()
            msg.sig == 0x03c0a389    // setDate()
        ) implementation = 0xcdA522f72aC0Ab675f9d9b27686229B9EE60F064; // SystemModule
        else if (
            msg.sig == 0xd72e0705 || // getOracleType()
            msg.sig == 0xe6dbd15d || // setOracleType()
            msg.sig == 0x10916f3b    // getVersionViaExchanger()
        ) implementation = 0x26a79B946C58fDa1b23a2E88bFEfA7E2a8F7DAf8; // IssuerModule
        else if (
            msg.sig == 0xe017bb0d    // getSystemVersion()
        ) implementation = 0x1f0A572FF4B2850D747be740728E7CBCE17755e9; // ExchangerModule
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
