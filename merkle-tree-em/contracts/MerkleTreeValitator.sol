//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import 'hardhat/console.sol';

contract MerkleTreeValidator {
    bytes32 private merkleTreeRoot;
    mapping(address => uint256) private addressSharedDebt;

    // constructor(bytes32 _merkleTreeRoot) {
    //     merkleTreeRoot = _merkleTreeRoot;
    // }

    function setMerkleTreeRoot(bytes32 _merkleTreeRoot) external {
        merkleTreeRoot = _merkleTreeRoot;
    }

    function getMerkleTreeRoot() external view returns (bytes32) {
        return merkleTreeRoot;
    }

    function getDebtShareOf(address _address) external view returns (uint256) {
        return addressSharedDebt[_address];
    }

    function declareDebtShare(
        address _address,
        uint256 _debt,
        bytes32[] calldata merkleProof
    ) external {
        // build leaf
        bytes32 leaf = keccak256(abi.encodePacked(_address, _debt));

        console.log('Input ', _address, _debt);
        console.log('packed');
        console.logBytes(abi.encodePacked(_address, _debt));

        console.log('leaf');
        console.logBytes32(leaf);

        require(
            _verify(merkleProof, merkleTreeRoot, leaf),
            'Invalid MerkleProof'
        );

        addressSharedDebt[_address] = _debt;
    }

    // Based on OpenZeppelin https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
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
                computedHash = _efficientHash(computedHash, proofElement);
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = _efficientHash(proofElement, computedHash);
            }
        }

        // Check if the computed hash (root) is equal to the provided root
        return computedHash == root;
    }

    function _efficientHash(bytes32 a, bytes32 b)
        private
        pure
        returns (bytes32 value)
    {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}
