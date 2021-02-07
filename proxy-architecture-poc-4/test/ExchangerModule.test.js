const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("ExchangerModule", function() {
  let network;
  let proxyAddress;

  let SystemModule, ExchangerModule;

  before('identify network', async function () {
    network = hre.network.name;
  });

  before('retrieve main proxy address', async function () {
    const deployments = getDeploymentsFile({ network });

    proxyAddress = deployments.Synthetix.proxy;
  });

  before('identify signers', async function () {
    const signers = await ethers.getSigners();

    [ owner, user ] = signers;
  });

  before('connect to modules', async function () {
    SystemModule = await ethers.getContractAt('SystemModule', proxyAddress);
    ExchangerModule = await ethers.getContractAt('ExchangerModule', proxyAddress);
  });

  it('can retrieve the system version', async function () {
    expect(
      await ExchangerModule.getSystemVersion()
    ).to.be.equal(
      await SystemModule.getVersion()
    )
  });
});
