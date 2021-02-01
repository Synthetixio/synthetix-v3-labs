//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/GlobalStorage.sol";


contract ExchangerModule is GlobalStorageAccessor {
    function getSystemVersion() public view returns (string memory) {
        return globalStorage().version;
    }
}
