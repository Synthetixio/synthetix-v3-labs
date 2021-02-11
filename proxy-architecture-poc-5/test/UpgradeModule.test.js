const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("UpgradeModule", function() {
  let network;
  let proxyAddress, routerAddress, upgradeModuleImplementationAddress;

  let owner, user;

  let UpgradeModule;

  before('identify network', async function () {
    network = hre.network.name;
  });

  before('retrieve main proxy address', async function () {
    deployments = getDeploymentsFile({ network });

    proxyAddress = deployments.Synthetix.address;
    routerAddress = deployments.Synthetix.implementations.pop();
    upgradeModuleImplementationAddress = deployments.modules['UpgradeModule'].implementation;
  });

  before('identify signers', async function () {
    const signers = await ethers.getSigners();

    [ owner, user ] = signers;
  });

  before('connect to modules', async function () {
    UpgradeModule = await ethers.getContractAt('UpgradeModule', proxyAddress);
  });

  it('can read the implementation', async function () {
    expect(
      await UpgradeModule.getImplementation()
    ).to.be.equal(
      routerAddress
    );
  });
});
