const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("IssuerModule", function() {
  let network;
  let proxyAddress;

  let user;

  let IssuerModule, SystemModule;

  const oracleType = 'chainlink';

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
    IssuerModule = await ethers.getContractAt('IssuerModule', proxyAddress);
    SystemModule = await ethers.getContractAt('SystemModule', proxyAddress);
  });

  it('can retrieve the system version via the ExchangerModule', async function () {
    expect(
      await IssuerModule.getVersionViaExchanger()
    ).to.be.equal(
      await SystemModule.getVersion()
    )
  });

  it('can set the oracleType', async function () {
    await runTxAndLogGasUsed(
      this,
      await IssuerModule.setOracleType(oracleType)
    );
  });

  it('cant set the owner with a non-owner account', async function () {
    const contract = IssuerModule.connect(user);

    await expect(contract.setOracleType('uniswap')).to.be.revertedWith("Only owner allowed");
  });

  it('can read the oracleType', async function () {
    expect(await IssuerModule.getOracleType()).to.be.equal(oracleType);
  });
});
