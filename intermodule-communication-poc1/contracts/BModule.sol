//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract BModule { // gas 415086
    uint256 public theValue;
    function setValue(uint256 _newVaule) public { // gas: 26426
        theValue = _newVaule;
    }
    function resetValue() public { // gas: 26426
        theValue = 42;
    }
}