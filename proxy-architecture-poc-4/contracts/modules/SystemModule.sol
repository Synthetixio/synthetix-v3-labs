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

    function setDate(string memory newDate) public {
        globalStorage().date = newDate;
    }

    function getDate() public view returns (string memory) {
        return globalStorage().date;
    }

    function getDateAndVersion() public view returns (string memory, string memory) {
        GlobalData storage store = globalStorage();

        return (store.date, store.version);
    }
}
