const assert = require('assert');
const { ethers } = require('hardhat');

describe('Governance', function () {
  let Governance, Token;

  let owner, users;

  let governanceRole;

  before('identify signers', async () => {
    users = await ethers.getSigners();

    [owner] = users;
  });

  before('deploy contracts', async () => {
    let factory;

    factory = await ethers.getContractFactory('Token');
    Token = await factory.deploy(users.map(user => user.address)); // Mints 1 token to each

    factory = await ethers.getContractFactory('Governance');
    Governance = await factory.deploy(Token.address);
  });

  before('set up governance in the token', async () => {
    const tx = await Token.setGovernance(Governance.address);
    await tx.wait();

    governanceRole = await Token.GOVERNANCE_ROLE();
  });

  it('minted the initial token supply', async () => {
    for (let user of users) {
      assert.deepEqual(
        await Token.balanceOf(user.address),
        ethers.utils.parseEther('1')
      );
    }
  });

  it('was setup with the appropriate name', async () => {
    assert.equal(await Governance.name(), 'Governance');
  });

  it('properly set up governance roles in the token', async () => {
    assert.ok(await Token.hasRole(governanceRole, Governance.address));
  });

  describe('when attempts are made to directly mint new tokens', () => {
    it('reverts, since minting is protected by a governance role', async () => {
      try {
        const tx = await Token.connect(owner).mint(owner.address, ethers.utils.parseEther('100'));
        await tx.wait();
      } catch(err) {
        assert.ok(err.toString().includes(`account ${owner.address.toLowerCase()} is missing role ${governanceRole}`));
      }
    });
  });

  describe('when a proposal is made to mint tokens', () => {
    let proposalCreatedEvent;
    let proposalId;

    const tokensToMint = ethers.utils.parseEther('100');

    before('activate voting on all users', async () => {
      for (let user of users) {
        await (await Token.connect(user).delegate(user.address)).wait();
      }
    });

    before('skip some time so that holders have voting power', async () => {
      await ethers.provider.send('evm_increaseTime', [1000]);
    });

    before('make proposal', async () => {
      const proposalCalldata = Token.interface.encodeFunctionData('mint', [owner.address, tokensToMint]);

      const tx = await Governance.propose(
        [Token.address],    // Targets
        [0],                // Values
        [proposalCalldata], // Actions
        `Mint ${ethers.utils.formatEther(tokensToMint)} tokens for owner`
      );
      const proposalReceipt = await tx.wait();

      proposalCreatedEvent = proposalReceipt.events.find(e => e.event === 'ProposalCreated');
      proposalId = proposalCreatedEvent.args.proposalId.toHexString();
    });

    it('emitted a ProposalCreated event', async () => {
      assert.ok(proposalCreatedEvent.args.targets.includes(Token.address));
    });

    it('shows that the proposal state is Pending', async () => {
      assert.equal(await Governance.state(proposalId), 0); // state 0 = Pending
    });

    describe('when the proposal is active', () => {
      before('skip a block to overcome votingDelay', async () => {
        await ethers.provider.send('evm_mine', []);
      });

      it('shows that the proposal state is Active', async () => {
        assert.equal(await Governance.state(proposalId), 1); // state 1 = Active
      });

      describe('when some votes are cast', () => {
        before('cast votes', async () => {
          await (await Governance.connect(users[0]).castVote(proposalId, 1)).wait();
          await (await Governance.connect(users[1]).castVote(proposalId, 1)).wait();
          await (await Governance.connect(users[2]).castVote(proposalId, 1)).wait();
          await (await Governance.connect(users[3]).castVote(proposalId, 1)).wait();
        });

        it('shows that the votes were registered', async () => {
          const [againstVotes, forVotes, abstainVotes] = await Governance.proposalVotes(proposalId);

          assert.equal(forVotes.toString(), ethers.utils.parseEther('4'));
        });
      });

      // describe('', () => {});
    });
  });
});
