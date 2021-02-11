const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');
const { runTxAndLogGasUsed } = require('./helpers/GasHelper');

describe("InterModule", function() {
  let network;
  let proxyAddress;

  let owner, user;

  let AModule, BModule;

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
    const tx = await BModule.setValue('1');
    await tx.wait();
  });

  it('B can get and set the value', async function () {
  	const value = '42';

    await runTxAndLogGasUsed(
      this,
      await BModule.setValue(value)
    );

    expect(
      (await BModule.getValue()).toString()
    ).to.be.equal(
      value
    );
  });

  it('A can get and set the value via B using casting', async function () {
  	const value = '1337';

    await runTxAndLogGasUsed(
      this,
      await AModule.setValueViaBModule_cast(value)
    );

    expect(
      (await BModule.getValue()).toString()
    ).to.be.equal(
      value
    );
  });
});
