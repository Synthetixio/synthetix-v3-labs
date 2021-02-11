//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./BModule.sol";
import "../mixins/RegistryMixin.sol";


contract AModule is RegistryMixin {
    /* MUTATIVE FUNCTIONS */

    function setValueViaBModule_cast(uint newValue) public {
        BModule(address(this)).setValue(newValue);
    }

    function setValueViaBModule_router(uint newValue) public {
        getRouter().delegatecall(
            abi.encodeWithSelector(BModule.setValue.selector, newValue)
        );
    }

    function setValueViaBModule_direct(uint newValue) public {
        getModuleImplementation(bytes32("BModule")).delegatecall(
            abi.encodeWithSelector(BModule.setValue.selector, newValue)
        );
    }
}
