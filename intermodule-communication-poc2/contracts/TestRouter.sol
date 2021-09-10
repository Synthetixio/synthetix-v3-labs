//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./BModule.sol";
import "./AModule.sol";

contract TestRouter { // gas 415086
    address private RouterAddress = 0x838F9b8228a5C95a7c431bcDAb58E289f5D2A4DC;
    
    function getValue() view public returns(uint256){ // gas --
        return BModule(RouterAddress).getBValue();    
    }
    function setValue(uint256 value) public { // gas 35089 // w/getAddress 35223
        BModule(RouterAddress).setBValue(value);    
    }
    function resetValue() public { // gas 31468 // w/getAddress 31535
        BModule(RouterAddress).resetBValue();    
    }


    function setAValueMixin(uint256 value) public { // gas 38743 (failed -- wrong storage) // w/getAddress 38843
        AModule(RouterAddress).setBValue1(value);    
    }
    function resetAValueMixin() public { // gas 37471 (failed -- wrong storage) // w/getAddress 34782
        AModule(RouterAddress).resetBValue1();    
    }


    function setAValueRouter(uint256 value) public { // gas 39034 // w/getAddress 39212
        AModule(RouterAddress).setBValue4(value);    
    }
    function resetAValueRouter() public { // gas 37813 // w/getAddress 37991
        AModule(RouterAddress).resetBValue4();    
    }

    
    function setAValueGetAddress(uint256 value) public { // gas --// w/getAddress 37436  (failed -- wrong storage)
        AModule(RouterAddress).setBValue5(value);    
    }
    function resetAValueGetAddress() public { // gas -- // w/getAddress 36251  (failed -- wrong storage)
        AModule(RouterAddress).resetBValue5();    
    }

}

