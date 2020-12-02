// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Upgradeable.sol";


contract TransparentUpgradeableProxy is Upgradeable {
    constructor(address implementation) {
        setImplementation(implementation);
    }

    fallback () external {
        _fallback();
    }

    function _fallback() public override {
        address implementation = getImplementation();

        // solhint-disable-next-line no-inline-assembly
        assembly {
            calldatacopy(0, 0, calldatasize())

            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            returndatacopy(0, 0, returndatasize())

            switch result
                case 0 { revert(0, returndatasize()) }
                default { return(0, returndatasize()) }
        }
    }
}
