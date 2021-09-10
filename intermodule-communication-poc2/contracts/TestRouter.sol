//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./BModule.sol";
import "./AModule.sol";

contract TestRouter { // gas 415086
    address private RouterAddress = 0x3328358128832A260C76A4141e19E2A943CD4B6D;
    
    function setValue(uint256 value) public {
        BModule(RouterAddress).setBValue(value);    
    }
    function resetValue() public {
        BModule(RouterAddress).resetBValue();    
    }
    function getValue() view public returns(uint256){
        return BModule(RouterAddress).getBValue();    
    }

    function setAValueRouter(uint256 value) public {
        AModule(RouterAddress).setBValue4(value);    
    }
    function resetAValueRouter() public {
        AModule(RouterAddress).resetBValue4();    
    }

    function setAValueMixin(uint256 value) public {
        AModule(RouterAddress).setBValue1(value);    
    }
    function resetAValueMixin() public {
        AModule(RouterAddress).resetBValue1();    
    }
}

