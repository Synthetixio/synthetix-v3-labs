//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./IMCMixin_v1.sol";
import "./BModule.sol";
import "./Router.sol";

contract AModule is IMCMixinV1 { // gas 415086
    address public theValue;
    // Mixin
    function setBValue1(uint256 value) public {
        (bool success,) = BModuleAddress.delegatecall(
            abi.encodeWithSelector(BModule.setBValue.selector, value)
        );

        require(success, "Delegatecall failed");
    }
    function resetBValue1() public {
        (bool success,) = BModuleAddress.delegatecall(
            abi.encodeWithSelector(BModule.resetBValue.selector)
        );

        require(success, "Delegatecall failed");
    }

    // Router
    function setBValue4(uint256 value) public {
        BModule(address(this)).setBValue(value);    
    }
    function resetBValue4() public {
        BModule(address(this)).resetBValue();    
    }

    // GetAddress
    uint256 constant BModuleId = 1;
    function setBValue5(uint256 value) public {
        (bool success,) = Router(address(this)).getModuleAddress(BModuleId).delegatecall(
            abi.encodeWithSelector(BModule.setBValue.selector, value)
        );

        require(success, "Delegatecall failed");
    }
    
    function resetBValue5() public {
        (bool success,) = Router(address(this)).getModuleAddress(BModuleId).delegatecall(
            abi.encodeWithSelector(BModule.resetBValue.selector)
        );

        require(success, "Delegatecall failed");
    }
}

