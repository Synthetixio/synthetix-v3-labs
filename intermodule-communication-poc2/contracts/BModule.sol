//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract BModule { // gas 415086
    uint256 public theValue;
    function setBValue(uint256 _newVaule) public { // gas: 26426
        theValue = _newVaule;
    }
    function resetBValue() public { // gas: 26426
        theValue = 42;
    }
    function getBValue() view public returns (uint256) { // gas: 26426
        return(theValue);
    }
}

