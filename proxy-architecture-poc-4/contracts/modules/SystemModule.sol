//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/GlobalStorage.sol";


contract SystemModule is GlobalStorageAccessor {
    function setVersion(string memory newVersion) public {
        globalStorage().version = newVersion;
    }

    function getVersion() public view returns (string memory) {
        return globalStorage().version;
    }
}
