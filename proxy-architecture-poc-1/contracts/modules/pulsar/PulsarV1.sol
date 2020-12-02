// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./PulsarStorage.sol";
import "../../BeaconResolver.sol";


contract PulsarV1 is PulsarStorage, BeaconResolver {
    function whoami() public pure virtual returns (string memory) {
        return "PulsarV1";
    }
}
