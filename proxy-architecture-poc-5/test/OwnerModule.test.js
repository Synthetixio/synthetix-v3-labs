const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("OwnerModule", function() {
  let network;
  let proxyAddress, routerAddress, ownerModuleImplementationAddress;

  let owner, user;

  let OwnerModule;

  before('identify network', async function () {
    network = hre.network.name;
  });

  before('retrieve main proxy address', async function () {
    deployments = getDeploymentsFile({ network });

    proxyAddress = deployments.Synthetix.address;
    routerAddress = deployments.Synthetix.implementations.pop();
    ownerModuleImplementationAddress = deployments.modules['OwnerModule'].implementation;
  });

  before('identify signers', async function () {
    const signers = await ethers.getSigners();

    [ owner, user ] = signers;
  });

  before('connect to modules', async function () {
    OwnerModule = await ethers.getContractAt('OwnerModule', proxyAddress);
  });

  it('can set the owner', async function () {
    await runTxAndLogGasUsed(
      this,
      await OwnerModule.setOwner(await owner.getAddress())
    );
  });

  it('can read the owner', async function () {
    expect(
      await OwnerModule.getOwner()
    ).to.be.equal(
      await owner.getAddress()
    );
  });

  it('can set the owner on the implementation (gas test)', async function () {
    const OwnerModuleImplementation = await ethers.getContractAt(
      'OwnerModule',
      ownerModuleImplementationAddress
    );

    await runTxAndLogGasUsed(
      this,
      await OwnerModuleImplementation.setOwner(await owner.getAddress())
    );
  });

  it('can set the owner on the router (gas test)', async function () {
    const OwnerModuleImplementation = await ethers.getContractAt(
      'OwnerModule',
      routerAddress
    );

    await runTxAndLogGasUsed(
      this,
      await OwnerModuleImplementation.setOwner(await owner.getAddress())
    );
  });

  it('cant set the owner with a non-owner account', async function () {
    const contract = OwnerModule.connect(user);

    await expect(contract.setOwner(await user.getAddress())).to.be.revertedWith("Only owner allowed");
  });
});
