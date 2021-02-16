const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("SettingsModule", function() {
  let network;
  let proxyAddress;

  let owner;

  let SettingsModule, SettingsModuleImplementation, Router;

	const COLLATERAL_RATIO = '42';

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
    SettingsModule = await ethers.getContractAt('SettingsModule', proxyAddress);

    SettingsModuleImplementation = await ethers.getContractAt(
      'SettingsModule',
      deployments.modules['SettingsModule'].implementation
    );

    Router = await ethers.getContractAt(
      'SettingsModule',
      deployments.Synthetix.implementations.pop()
    );
  });

  before('set once for gas measurements', async () => {
    let tx;
    tx = await SettingsModule.setMinCollateralRatio(await owner.getAddress());
    await tx.wait();
    tx = await SettingsModuleImplementation.setMinCollateralRatio(await owner.getAddress());
    await tx.wait();
    tx = await Router.setMinCollateralRatio(await owner.getAddress());
    await tx.wait();
  });

  it('can set the minCollateralRatio', async function () {
    await runTxAndLogGasUsed(
      this,
  	  await SettingsModule.setMinCollateralRatio(COLLATERAL_RATIO)
    );
  });

  it('can set the minCollateralRatio on the implementation (gas test)', async function () {
    await runTxAndLogGasUsed(
      this,
      await SettingsModuleImplementation.setMinCollateralRatio(COLLATERAL_RATIO)
    );
  });

  it('can set the minCollateralRatio on the router (gas test)', async function () {
    await runTxAndLogGasUsed(
      this,
      await Router.setMinCollateralRatio(COLLATERAL_RATIO)
    );
  });

  it('can read the minCollateralRatio', async function () {
    expect(
      (await SettingsModule.getMinCollateralRatio()).toString()
    ).to.be.equal(
      COLLATERAL_RATIO
    );
  });
});
