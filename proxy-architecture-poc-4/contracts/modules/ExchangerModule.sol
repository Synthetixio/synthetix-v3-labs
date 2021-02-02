//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/GlobalStorage.sol";


library ExchangerModule {
    function getSystemVersion() public view returns (string memory) {
        return GlobalStorage.store().version;
    }
}
