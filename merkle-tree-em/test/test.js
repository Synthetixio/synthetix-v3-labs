const assert = require('assert')
const { ethers } = require('hardhat')

async function reverts(trans, msg) {
  try {
    const tx = await trans
    await tx.wait()
    assert.ok(false, 'doesnt revert')
  } catch (e) {
    assert.ok(e.message.includes(msg))
  }
}
describe('Merkle Tree', function () {
  let MerkleTreeValidator

  let owner, users

  const merkleTreeRoot =
    '0xca9cb6e1ace68d6a3caf790958b3ce7077c11a5a282a3bd0b000eacfd3b232bc'

  before('identify signers', async () => {
    users = await ethers.getSigners()
    owner = users[0]
  })

  before('deploy contracts', async () => {
    let factory

    factory = await ethers.getContractFactory('MerkleTreeValidator')
    MerkleTreeValidator = await factory.deploy()
  })

  before('set merkle root', async () => {
    const tx = await MerkleTreeValidator.setMerkleTreeRoot(merkleTreeRoot)
    await tx.wait()
  })

  it('is initialized', async () => {
    const root = await MerkleTreeValidator.getMerkleTreeRoot()
    assert.equal(root, merkleTreeRoot)
  })

  it('log data', async () => {
    const tx = await reverts(
      MerkleTreeValidator.declareDebtShare(owner.address, 1234, [
        '0xca9cb6e1ace68d6a3caf790958b3ce7077c11a5a282a3bd0b000eacfd3b232bc',
        '0xca9cb6e1ace68d6a3caf790958b3ce7077c11a5a282a3bd0b000eacfd3b232bc',
      ]),
      'Invalid MerkleProof'
    )
  })
  describe('reverts on wrong proof', () => {})
  describe('retrieves the amount of a valid address', () => {})
  describe('retrieves zero for an invalid address', () => {})
})
