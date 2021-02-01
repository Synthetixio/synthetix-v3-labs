//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/GlobalStorage.sol";


contract ExchangerModule is GlobalStorageAccessor {
    function setValue(string memory newValue) public {
        GlobalData storage store = globalStorage();

        store.someValue = newValue;
    }

    function getValue() public view returns (string memory) {
        GlobalData storage store = globalStorage();

        return store.someValue;
    }
}
