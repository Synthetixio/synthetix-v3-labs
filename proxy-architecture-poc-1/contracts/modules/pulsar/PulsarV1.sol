// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./PulsarStorageV1.sol";
import "../../Implementation.sol";


contract PulsarV1 is Implementation, PulsarStorageV1 {
    function whoami() public pure virtual returns (string memory) {
        return "PulsarV1";
    }
}
