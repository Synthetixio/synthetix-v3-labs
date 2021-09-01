const assert = require('assert');
const { ethers } = require('hardhat');

describe('Governance', function () {
  let Governance, Token, Timelock;

  let owner, user;

  before('identify signers', async () => {
    ([owner, user] = await ethers.getSigners());
  });

  before('deploy contracts', async () => {
    let factory;

    factory = await ethers.getContractFactory('Token');
    Token = await factory.deploy();

    factory = await ethers.getContractFactory('TimelockController');
    Timelock = await factory.deploy(
      1, // minDelay
      [owner.address], // proposers
      [owner.address]  // executors
    );

    factory = await ethers.getContractFactory('Governance');
    Governance = await factory.deploy(
      Token.address,
      Timelock.address
    );
  });

  describe('token', () => {
    it('minted the initial token supply to the owner', async () => {
      assert.deepEqual(
        await Token.balanceOf(owner.address),
        ethers.utils.parseEther('100')
      );
    });
  });

  describe('timelock', () => {
    it('was setup with the appropriate roles', async () => {
      assert.ok(await Timelock.hasRole(await Timelock.TIMELOCK_ADMIN_ROLE(), owner.address));
      assert.ok(await Timelock.hasRole(await Timelock.PROPOSER_ROLE(), owner.address));
      assert.ok(await Timelock.hasRole(await Timelock.EXECUTOR_ROLE(), owner.address));
    });
  });

  describe('governance', () => {
    it('was setup with the appropriate name', async () => {
      assert.equal(await Governance.name(), 'Governance');
    });
  });
});
