//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./BModule.sol";
import "./AModule.sol";

contract TestRouter { 
    address private RouterAddress = 0x62FF318Bee4D6d605D163Ed3325077E32803599B;
    
    function getValue() view public returns(uint256){ // gas --
        return BModule(RouterAddress).getBValue();    
    }
    function setValue(uint256 value) public { // gas .. // w/getAddress 35223
        BModule(RouterAddress).setBValue(value);    
    }
    function resetValue() public { // gas .. // w/getAddress 31535
        BModule(RouterAddress).resetBValue();    
    }


    function setAValueMixin(uint256 value) public { // gas 38743 (failed -- wrong storage) // w/getAddress (DC) 39295
        AModule(RouterAddress).setBValue1(value);    
    }
    function resetAValueMixin() public { // gas 37471 (failed -- wrong storage) // w/getAddress (DC) 37956 
        AModule(RouterAddress).resetBValue1();    
    }


    function setAValueRouter(uint256 value) public { // gas 39034 // w/getAddress 39168
        AModule(RouterAddress).setBValue4(value);    
    }
    function resetAValueRouter() public { // gas 37813 // w/getAddress 37947
        AModule(RouterAddress).resetBValue4();    
    }

    
    function setAValueGetAddress(uint256 value) public { // gas --// w/getAddress (DC) 40732 //
        AModule(RouterAddress).setBValue5(value);    
    }
    function resetAValueGetAddress() public { // gas -- // w/getAddress (DC) 39425 // 
        AModule(RouterAddress).resetBValue5();    
    }

}

