//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./Beacon.sol";


contract Synthetix {
    Beacon constant beacon = Beacon(0x2c8ED11fd7A058096F2e5828799c68BE88744E2F);

    fallback() external {
        address implementation = beacon.getImplementation();

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
