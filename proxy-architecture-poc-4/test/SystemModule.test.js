const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("SystemModule", function() {
  let network;
  let proxyAddress, routerAddress, systemModuleImplementationAddress;

  let owner, user;

  let SystemModule;

  const version = '1';

  before('identify network', async function () {
    network = hre.network.name;
  });

  before('retrieve main proxy address', async function () {
    deployments = getDeploymentsFile({ network });

    proxyAddress = deployments.Synthetix.proxy;
    routerAddress = deployments.Synthetix.implementations.pop();
    systemModuleImplementationAddress = deployments.modules['SystemModule'].implementation;
  });

  before('identify signers', async function () {
    const signers = await ethers.getSigners();

    [ owner, user ] = signers;
  });

  before('connect to modules', async function () {
    SystemModule = await ethers.getContractAt('SystemModule', proxyAddress);
  });

  it('can set the owner', async function () {
    await runTxAndLogGasUsed(
      this,
      await SystemModule.setOwner(await owner.getAddress())
    );
  });

  it('can set the owner on the implementation (gas test)', async function () {
    const SystemModuleImplementation = await ethers.getContractAt(
      'SystemModule',
      systemModuleImplementationAddress
    );

    await runTxAndLogGasUsed(
      this,
      await SystemModuleImplementation.setOwner(await owner.getAddress())
    );
  });

  it('can set the owner on the router (gas test)', async function () {
    const SystemModuleImplementation = await ethers.getContractAt(
      'SystemModule',
      routerAddress
    );

    await runTxAndLogGasUsed(
      this,
      await SystemModuleImplementation.setOwner(await owner.getAddress())
    );
  });

  it('cant set the owner with a non-owner account', async function () {
    const contract = SystemModule.connect(user);

    await expect(contract.setOwner(await user.getAddress())).to.be.revertedWith("Only owner allowed");
  });

  it('can read the owner', async function () {
    expect(
      await SystemModule.getOwner()
    ).to.be.equal(
      await owner.getAddress()
    );
  });

  it('can set the system version', async function () {
    await runTxAndLogGasUsed(
      this,
      await SystemModule.setVersion(version)
    );
  });

  it('cant set the system version with a non-owner account', async function () {
    const contract = SystemModule.connect(user);

    await expect(contract.setVersion('2')).to.be.revertedWith("Only owner allowed");
  });

  it('can read the system version', async function () {
    expect(await SystemModule.getVersion()).to.be.equal(version);
  });
});
