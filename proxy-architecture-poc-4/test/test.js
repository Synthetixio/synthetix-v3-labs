const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');

describe("POC4", function() {
  let network;
  let proxyAddress;

  let owner, user;

  let SystemModule, IssuerModule, ExchangerModule;

  const version = '1';
  const oracleType = 'chainlink';

  before('identify network', async () => {
    network = hre.network.name;
  });

  before('retrieve main proxy address', async () => {
    const deployments = getDeploymentsFile({ network });

    proxyAddress = deployments.Synthetix.proxy;
  });

  before('identify signers', async () => {
    const signers = await ethers.getSigners();

    [ owner, user ] = signers;
  });

  before('connect to modules', async () => {
    SystemModule = await ethers.getContractAt('SystemModule', proxyAddress);
    IssuerModule = await ethers.getContractAt('IssuerModule', proxyAddress);
    ExchangerModule = await ethers.getContractAt('ExchangerModule', proxyAddress);
  });

  describe('SystemModule', () => {
    it('can set the owner', async () => {
      const tx = await SystemModule.setOwner(await owner.getAddress());
      await tx.wait();
    });

    it('cant set the owner with a non-owner account', async () => {
      const contract = SystemModule.connect(user);

      await expect(contract.setOwner(await user.getAddress())).to.be.revertedWith("Only owner allowed");
    });

    it('can read the owner', async () => {
      expect(
        await SystemModule.getOwner()
      ).to.be.equal(
        await owner.getAddress()
      );
    });

    it('can set the system version', async () => {
      const tx = await SystemModule.setVersion(version);
      await tx.wait();
    });

    it('cant set the system version with a non-owner account', async () => {
      const contract = SystemModule.connect(user);

      await expect(contract.setVersion('2')).to.be.revertedWith("Only owner allowed");
    });

    it('can read the system version', async () => {
      expect(await SystemModule.getVersion()).to.be.equal(version);
    });
  });

  describe('ExchangerModule', () => {
    it('can retrieve the system version', async () => {
      expect(
        await ExchangerModule.getSystemVersion()
      ).to.be.equal(
        await SystemModule.getVersion()
      )
    });
  });

  describe('IssuerModule', () => {
    it('can retrieve the system version via the ExchangerModule', async () => {
      expect(
        await IssuerModule.getVersionViaExchanger()
      ).to.be.equal(
        await SystemModule.getVersion()
      )
    });

    it('can set the oracleType', async () => {
      const tx = await IssuerModule.setOracleType(oracleType);
      await tx.wait();
    });

    it('cant set the owner with a non-owner account', async () => {
      const contract = IssuerModule.connect(user);

      await expect(contract.setOracleType('uniswap')).to.be.revertedWith("Only owner allowed");
    });

    it('can read the oracleType', async () => {
      expect(await IssuerModule.getOracleType()).to.be.equal(oracleType);
    });
  });
});
