//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/GlobalStorage.sol";


contract ExchangerModule is GlobalStorageAccessor {
    function setValue(string memory newValue) public {
        globalStorage().someValue = newValue;
    }

    function getValue() public view returns (string memory) {
        return globalStorage().someValue;
    }
}
