const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');

describe("SettingsModule", function() {
  let network;
  let proxyAddress;

  let owner, user;

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
});
