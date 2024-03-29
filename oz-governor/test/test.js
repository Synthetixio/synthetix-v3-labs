const assert = require('assert');
const { ethers } = require('hardhat');

describe('Governance', function () {
  let Governance, Token, Timelock;

  let owner, users;

  let proposal;

  let minterRole;

  before('identify signers', async () => {
    users = await ethers.getSigners();

    [owner] = users;
  });

  before('deploy contracts', async () => {
    let factory;

    factory = await ethers.getContractFactory('Token');
    Token = await factory.deploy(users.map(user => user.address)); // Mints 1 token to each user

    factory = await ethers.getContractFactory('TimelockController');
    Timelock = await factory.deploy(3600, [], []); // 1 hour

    factory = await ethers.getContractFactory('Governance');
    Governance = await factory.deploy(Token.address, Timelock.address);
  });

  before('give the timelock the minter role on the token', async () => {
    const tx = await Token.setTimelock(Timelock .address);
    await tx.wait();

    minterRole = await Token.MINTER_ROLE();
  });

  before('set up roles in the timelock controller', async () => {
    let tx;

    tx = await Timelock.connect(owner).grantRole(
      ethers.utils.id('PROPOSER_ROLE'),
      Governance.address,
    );
    await tx.wait();

    tx = await Timelock.connect(owner).grantRole(
      ethers.utils.id('EXECUTOR_ROLE'),
      '0x0000000000000000000000000000000000000000',
    );
    await tx.wait();
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

  it('properly set up minter roles in the token', async () => {
    assert.ok(await Token.hasRole(minterRole, Timelock.address));
  });

  describe('when attempts are made to directly mint new tokens', () => {
    it('reverts, since minting is protected by a governance role', async () => {
      try {
        const tx = await Token.connect(owner).mint(owner.address, ethers.utils.parseEther('100'));
        await tx.wait();
      } catch(err) {
        assert.ok(err.toString().includes(`account ${owner.address.toLowerCase()} is missing role ${minterRole}`));
      }
    });
  });

  describe('when users activate their voting power', () => {
    before('activate voting on all users', async () => {
      for (let user of users) {
        await (await Token.connect(user).delegate(user.address)).wait();
      }
    });

    it('shows that their voting power has been activated', async () => {
      for (let user of users) {
        assert.deepEqual(
          await Token.getVotes(user.address),
          await Token.balanceOf(user.address)
        );
      }
    });

    describe('when a proposal is made to mint tokens', () => {
      let proposalCreatedEvent;
      let proposalId;

      const tokensToMint = ethers.utils.parseEther('100');

      before('make proposal', async () => {
        const proposalCalldata = Token.interface.encodeFunctionData('mint', [owner.address, tokensToMint]);

        proposal = {
          targets: [Token.address],
          values: [0],
          actions: [proposalCalldata],
          description: `Mint ${ethers.utils.formatEther(tokensToMint)} tokens for owner`,
        }

        const tx = await Governance.propose(
          proposal.targets,
          proposal.values,
          proposal.actions,
          proposal.description
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
            for (let user of users) {
              await (await Governance.connect(user).castVote(proposalId, 1)).wait();
            }
          });

          it('shows that the votes were registered', async () => {
            const [againstVotes, forVotes, abstainVotes] = await Governance.proposalVotes(proposalId);

            assert.equal(forVotes.toString(), ethers.utils.parseEther(`${users.length}`));
          });
        });

        describe('when the voting period elapses', () => {
          before('fast forward delay period', async () => {
            const currentBlock = await ethers.provider.getBlockNumber();
            const proposalEndBlock = proposalCreatedEvent.args.endBlock;
            const deltaBlocks = proposalEndBlock.sub(currentBlock);

            for (let i = 0; i < deltaBlocks.toNumber(); i++) {
              await ethers.provider.send('evm_mine', []);
            }
          });

          it('shows that the proposal state is Succeeded', async () => {
            assert.equal(await Governance.state(proposalId), 4); // state 4 = Succeeded
          });

          describe('when the proposal is queued for execution in the timelock controller', () => {
            before('execute', async () => {
              await (await Governance.queue(
                proposal.targets,
                proposal.values,
                proposal.actions,
                ethers.utils.id(proposal.description)
              )).wait();
            });

            it('shows that the proposal is queued for execution', async () => {
              assert.equal(await Governance.state(proposalId), 5); // state 5 = Queued
            });

            describe('before the timelock period elapses', () => {
              describe('when someone attempts to execute the proposal', () => {
                it('reverts', async () => {
                  try {
                    await (await Governance.execute(
                      proposal.targets,
                      proposal.values,
                      proposal.actions,
                      ethers.utils.id(proposal.description)
                    )).wait();
                  } catch(err) {
                    assert.ok(err.toString().includes('TimelockController: operation is not ready'));
                  }
                });
              });
            });

            describe('when the timelock period elapsses', () => {
              before('fast forward timelock queue period', async () => {
                const delay = await Timelock.getMinDelay();

                await ethers.provider.send('evm_increaseTime', [delay.toNumber()]);
                await ethers.provider.send('evm_mine', []);
              });

              describe('when the proposal gets executed', () => {
                before('execute', async () => {
                  await (await Governance.execute(
                    proposal.targets,
                    proposal.values,
                    proposal.actions,
                    ethers.utils.id(proposal.description)
                  )).wait();
                });

                it('shows that the tokens where minted', async () => {
                  const balance = await Token.balanceOf(owner.address);

                  assert.deepEqual(balance, ethers.utils.parseEther('101'));
                });
              });
            });
          });
        });
      });
    });
  });
});
