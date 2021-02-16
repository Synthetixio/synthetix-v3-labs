const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');

describe("OwnerModule", function() {
  let network;
  let proxyAddress;

  let owner, user;

  let OwnerModule;

  before('identify network', async function () {
    network = hre.network.name;
  });

  before('retrieve main proxy address', async function () {
    deployments = getDeploymentsFile({ network });

    proxyAddress = deployments.Synthetix.address;
  });

  before('identify signers', async function () {
    const signers = await ethers.getSigners();

    [ owner, user ] = signers;
  });

  before('connect to modules', async function () {
    OwnerModule = await ethers.getContractAt('OwnerModule', proxyAddress);
  });

  it('can set an owner via nomination', async function () {
    let tx, receipt;

    tx = await OwnerModule.nominateOwner(await owner.getAddress());
    await tx.wait();

    tx = await OwnerModule.acceptOwnership();
    receipt = await tx.wait();

    const event = receipt.events.find(e => e.event === 'OwnerChanged');
    expect(event.args[0]).to.be.equal(await owner.getAddress());
  });

  it('can read the owner', async function () {
    expect(
      await OwnerModule.getOwner()
    ).to.be.equal(
      await owner.getAddress()
    );
  });

  it('cannot nominate an owner with a non-owner account', async function () {
    const contract = OwnerModule.connect(user);

    await expect(contract.nominateOwner(await user.getAddress())).to.be.revertedWith("Only owner allowed");
  });
});
