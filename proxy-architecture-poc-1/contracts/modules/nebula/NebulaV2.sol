// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Nebulav1.sol";
import "./NebulaStorage.sol";
import "../pulsar/PulsarV1.sol";


contract NebulaV2 is NebulaV1 {
    bytes32 constant PULSAR_MODULE = 0x70756c7361720000000000000000000000000000000000000000000000000000;
    bytes32 constant CRATIO_SETTING = 0x63726174696f0000000000000000000000000000000000000000000000000000;

    function whoispulsar() public view returns (string memory) {
        PulsarV1 pulsar = PulsarV1(_getModule(PULSAR_MODULE));

        return pulsar.whoami();
    }

    function whoami() public pure override returns (string memory) {
        return "NebulaV2";
    }

    function getCRatio() public view returns (uint) {
        return _getSetting(CRATIO_SETTING);
    }
}
