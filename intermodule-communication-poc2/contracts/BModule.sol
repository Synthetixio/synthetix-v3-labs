//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./GlobalNamespace.sol";

contract BModule is GlobalNamespace { // gas 415086
    function setBValue(uint256 _newVaule) public { // gas: 26426
        _globalStorage().value = _newVaule;
    }
    function resetBValue() public { // gas: 26426
        _globalStorage().value = 42;
    }
    function getBValue() view public returns (uint256) { // gas: 26426
        return _globalStorage().value;
    }
}

