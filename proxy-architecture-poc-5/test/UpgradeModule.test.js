const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("UpgradeModule", function() {
  let network;
  let proxyAddress, routerAddress, upgradeModuleImplementationAddress;

  let owner, user;

  let UpgradeModule;

  const version = '1';

  before('identify network', async function () {
    network = hre.network.name;
  });

  before('retrieve main proxy address', async function () {
    deployments = getDeploymentsFile({ network });

    proxyAddress = deployments.Proxy.address;
    routerAddress = deployments.Proxy.implementations.pop();
    upgradeModuleImplementationAddress = deployments.modules['UpgradeModule'].implementation;
  });

  before('identify signers', async function () {
    const signers = await ethers.getSigners();

    [ owner, user ] = signers;
  });

  before('connect to modules', async function () {
    UpgradeModule = await ethers.getContractAt('UpgradeModule', proxyAddress);
  });

  it('can read the owner', async function () {
    expect(
      await UpgradeModule.getOwner()
    ).to.be.equal(
      await owner.getAddress()
    );
  });

  it('can read the implementation', async function () {
    expect(
      await UpgradeModule.getImplementation()
    ).to.be.equal(
      upgradeModuleImplementationAddress
    );
  });

  // it('can set the owner', async function () {
  //   await runTxAndLogGasUsed(
  //     this,
  //     await UpgradeModule.setOwner(await owner.getAddress())
  //   );
  // });

  // it('can set the owner on the implementation (gas test)', async function () {
  //   const UpgradeModuleImplementation = await ethers.getContractAt(
  //     'UpgradeModule',
  //     upgradeModuleImplementationAddress
  //   );

  //   await runTxAndLogGasUsed(
  //     this,
  //     await UpgradeModuleImplementation.setOwner(await owner.getAddress())
  //   );
  // });

  // it('can set the owner on the router (gas test)', async function () {
  //   const UpgradeModuleImplementation = await ethers.getContractAt(
  //     'UpgradeModule',
  //     routerAddress
  //   );

  //   await runTxAndLogGasUsed(
  //     this,
  //     await UpgradeModuleImplementation.setOwner(await owner.getAddress())
  //   );
  // });

  // it('cant set the owner with a non-owner account', async function () {
  //   const contract = UpgradeModule.connect(user);

  //   await expect(contract.setOwner(await user.getAddress())).to.be.revertedWith("Only owner allowed");
  // });

});
