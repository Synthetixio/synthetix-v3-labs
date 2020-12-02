// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./NebulaStorageV1.sol";
import "../../Implementation.sol";


contract NebulaV1 is Implementation, NebulaStorageV1 {
    function initialize(address beacon) public override initializer(1) {
        super.initialize(beacon);

        _someVal = 42;
    }

    function whoami() public pure virtual returns (string memory) {
        return "NebulaV1";
    }

    function getSomeVal() public view returns (uint) {
        return _someVal;
    }
}
