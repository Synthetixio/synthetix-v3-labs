//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


contract Proxy {
    bytes32 constant PROXY_STORAGE_POSITION = keccak256("eip1967.proxy.implementation");

    constructor(address firstImplementation) {
        implementation() = firstImplementation;
    }

    // TODO: This could be internal, and external viewers could
    // manually look into that storage position.
    // This would save gas in the function selector.
    function implementation() public view returns (address implementation) {
        bytes32 position = STORAGE_POSITION;

        assembly {
            implementation.slot := position
        }
    }

    fallback() external {
        address implementationAddress = implementation();

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), implementationAddress, 0, calldatasize(), 0, 0)
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
