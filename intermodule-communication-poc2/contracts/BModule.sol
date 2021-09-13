//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./GlobalNamespace.sol";

contract BModule is GlobalNamespace { // gas 
    function setBValue(uint256 _newVaule) public { // gas: 26665
        _globalStorage().value = _newVaule;
    }
    function resetBValue() public { // gas: 26241
        _globalStorage().value = 42;
    }
    function getBValue() view public returns (uint256) { // gas: 
        return _globalStorage().value;
    }
}

