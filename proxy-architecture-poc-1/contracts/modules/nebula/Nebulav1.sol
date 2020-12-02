// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./NebulaStorage.sol";
import "../../Implementation.sol";


contract NebulaV1 is Implementation, NebulaStorage {
    function whoami() public pure virtual returns (string memory) {
        return "NebulaV1";
    }
}
