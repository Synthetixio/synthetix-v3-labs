// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./NebulaStorage.sol";
import "../../BeaconResolver.sol";


contract NebulaV1 is NebulaStorage, BeaconResolver {
    function whoami() public pure virtual returns (string memory) {
        return "NebulaV1";
    }
}
