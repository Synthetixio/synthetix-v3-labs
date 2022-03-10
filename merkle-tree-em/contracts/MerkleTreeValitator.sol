//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract MerkleTreeValidator {
    bytes32 merkleTreeRoot;
    mapping(address => uint256) private addressSharedDebt;

    constructor(bytes32 _merkleTreeRoot) {
        merkleTreeRoot = _merkleTreeRoot;
    }

    function getDebtShareOf(address _address) external view returns (uint256) {
        return addressSharedDebt[_address];
    }

    function pushDebtShare(
        address _address,
        uint256 _debt,
        bytes32[] calldata merkleProof
    ) external {
        // build leaf
        bytes32 leaf = keccak256(abi.encodePacked(_address, _debt));

        require(
            _verify(merkleProof, merkleTreeRoot, leaf),
            "Invalid MerkleProof"
        );

        addressSharedDebt[_address] = _debt;
    }

    function _verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash <= proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = keccak256(
                    abi.encodePacked(computedHash, proofElement)
                );
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = keccak256(
                    abi.encodePacked(proofElement, computedHash)
                );
            }
        }

        // Check if the computed hash (root) is equal to the provided root
        return computedHash == root;
    }
}
