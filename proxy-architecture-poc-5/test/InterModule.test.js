const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("InterModule", function() {
  let network;
  let proxyAddress;

  let AModule, BModule;

  const VALUE = '42';

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
    AModule = await ethers.getContractAt('AModule', proxyAddress);
    BModule = await ethers.getContractAt('BModule', proxyAddress);
  });

  before('set value first time for gas measurements', async () => {
    const tx = await BModule.setValue(VALUE);
    await tx.wait();
  });

  it('B can get and set the value', async function () {
    await runTxAndLogGasUsed(
      this,
      await BModule.setValue(VALUE)
    );

    expect(
      (await BModule.getValue()).toString()
    ).to.be.equal(
      VALUE
    );
  });

  it('A can set the value via B using casting', async function () {
    await runTxAndLogGasUsed(
      this,
      await AModule.setValueViaBModule_cast(VALUE)
    );

    expect(
      (await BModule.getValue()).toString()
    ).to.be.equal(
      VALUE
    );
  });

  it('A can set the value via B using delegatecall via the router', async function () {
    await runTxAndLogGasUsed(
      this,
      await AModule.setValueViaBModule_router(VALUE)
    );

    expect(
      (await BModule.getValue()).toString()
    ).to.be.equal(
      VALUE
    );
  });
});
