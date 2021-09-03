//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./IMCMixin_v1.sol";
import "./IMCMixin_v2.sol";
import "./IMCMixin_v3.sol";
import "./BModule.sol";

contract AModule is IMCMixinV1, IMCMixinV2, IMCMixinV3 { // gas 415086
    address public theValue;
    function initializer() public { // gas: 177044
        _initializer();
    }
    function setBValue1(uint256 value) public {
        BModule(BModuleAddress).setValue(value);    
    }
    function resetBValue1() public {
        BModule(BModuleAddress).resetValue();    
    }

    function setBValue2(uint256 value) public {
        BModule(getBModuleAddress()).setValue(value);    
    }
    function resetBValu2() public {
        BModule(getBModuleAddress()).resetValue();    
    }

    function setBValue3(uint256 value) public {
        BModule(getModuleAddress("BModule")).setValue(value);    
    }
    function resetBValue3() public {
        BModule(getModuleAddress("BModule")).resetValue();    
    }

}

