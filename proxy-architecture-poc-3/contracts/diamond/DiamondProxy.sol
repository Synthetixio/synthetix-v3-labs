// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "./DiamondStorage.sol";


contract DiamondProxy is DiamondStorage {
    constructor() public {
        DiamondStorage storage ds = diamondStorage();

        ds.owner = msg.sender;
    }

    fallback() external payable {
        DiamondStorage storage ds = diamondStorage();

        address implementation = ds.implementationForSelector[msg.sig];
        require(implementation != address(0), "DiamondProxy: Unknown selector");

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
