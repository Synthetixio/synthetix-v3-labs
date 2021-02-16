const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("SettingsModule", function() {
  let network;
  let proxyAddress, routerAddress, implementationAddress;

  let owner;

  let SettingsModule;

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

    routerAddress = deployments.Synthetix.implementations.pop();
    implementationAddress = deployments.modules['SettingsModule'].implementation;
  });

  it('can set the minCollateralRatio', async function () {
  	const tx = await SettingsModule.setMinCollateralRatio(COLLATERAL_RATIO);
  	await tx.wait();
  });

  it('can read the minCollateralRatio', async function () {
    expect(
      (await SettingsModule.getMinCollateralRatio()).toString()
    ).to.be.equal(
      COLLATERAL_RATIO
    );
  });

  it('can set the minCollateralRatio on the implementation (gas test)', async function () {
    const SettingsModuleImplementation = await ethers.getContractAt(
      'SettingsModule',
      implementationAddress
    );

    await runTxAndLogGasUsed(
      this,
      await SettingsModuleImplementation.setMinCollateralRatio(await owner.getAddress())
    );
  });

  it('can set the minCollateralRatio on the router (gas test)', async function () {
    const SettingsModuleImplementation = await ethers.getContractAt(
      'SettingsModule',
      routerAddress
    );

    await runTxAndLogGasUsed(
      this,
      await SettingsModuleImplementation.setMinCollateralRatio(await owner.getAddress())
    );
  });

});
