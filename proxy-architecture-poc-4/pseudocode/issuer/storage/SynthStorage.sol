//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


abstract contract SynthStorageAccessor {
    bytes32 constant STORAGE_POSITION = keccak256("io.synthetix.synth");

    struct SynthStorage {
        // Available Synths which can be used with the system
        ISynth[] public availableSynths;
        mapping(bytes32 => ISynth) public synths;
        mapping(address => bytes32) public synthsByAddress;
    }

    function getSynthStorage() internal pure returns (SynthStorage storage store) {
        bytes32 position = STORAGE_POSITION;

        assembly {
            store.slot := position
        }
    }
}
