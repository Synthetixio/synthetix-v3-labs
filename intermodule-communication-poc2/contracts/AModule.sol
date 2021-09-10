//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./IMCMixin_v1.sol";
import "./IMCMixin_v2.sol";
import "./IMCMixin_v3.sol";
import "./BModule.sol";
import "./Router.sol";

contract AModule is IMCMixinV1, IMCMixinV2, IMCMixinV3 { // gas 415086
    address public theValue;
    function initializer() public { // gas: 177044
        _initializer();
    }
    function setBValue1(uint256 value) public {
        BModule(BModuleAddress).setBValue(value);    
    }
    function resetBValue1() public {
        BModule(BModuleAddress).resetBValue();    
    }

    function setBValue2(uint256 value) public {
        BModule(getBModuleAddress()).setBValue(value);    
    }
    function resetBValue2() public {
        BModule(getBModuleAddress()).resetBValue();    
    }

    function setBValue3(uint256 value) public {
        BModule(getModuleAddress("BModule")).setBValue(value);    
    }
    function resetBValue3() public {
        BModule(getModuleAddress("BModule")).resetBValue();    
    }

    function setBValue4(uint256 value) public {
        BModule(address(this)).setBValue(value);    
    }
    function resetBValue4() public {
        BModule(address(this)).resetBValue();    
    }

    bytes32 constant BModuleId = 'BModule';

    function setBValue5(uint256 value) public {
        BModule(Router(address(this)).getModuleAddress(BModuleId)).setBValue(value);    
    }
    
    function resetBValue5() public {
        BModule(Router(address(this)).getModuleAddress(BModuleId)).resetBValue();    
    }
}

