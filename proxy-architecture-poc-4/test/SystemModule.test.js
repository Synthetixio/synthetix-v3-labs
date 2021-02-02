const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');

describe("SystemModule", function() {
  let network;
  let proxyAddress;

  let owner, user;

  let SystemModule;

  const version = '1';

  before('identify network', async () => {
    network = hre.network.name;
  });

  before('retrieve main proxy address', async () => {
    const deployments = getDeploymentsFile({ network });

    proxyAddress = deployments.Synthetix.proxy;
  });

  before('identify signers', async () => {
    const signers = await ethers.getSigners();

    [ owner, user ] = signers;
  });

  before('connect to modules', async () => {
    SystemModule = await ethers.getContractAt('SystemModule', proxyAddress);
  });

  it('can set the owner', async () => {
    const tx = await SystemModule.setOwner(await owner.getAddress());
    await tx.wait();
  });

  it('cant set the owner with a non-owner account', async () => {
    const contract = SystemModule.connect(user);

    await expect(contract.setOwner(await user.getAddress())).to.be.revertedWith("Only owner allowed");
  });

  it('can read the owner', async () => {
    expect(
      await SystemModule.getOwner()
    ).to.be.equal(
      await owner.getAddress()
    );
  });

  it('can set the system version', async () => {
    const tx = await SystemModule.setVersion(version);
    await tx.wait();
  });

  it('cant set the system version with a non-owner account', async () => {
    const contract = SystemModule.connect(user);

    await expect(contract.setVersion('2')).to.be.revertedWith("Only owner allowed");
  });

  it('can read the system version', async () => {
    expect(await SystemModule.getVersion()).to.be.equal(version);
  });
});
