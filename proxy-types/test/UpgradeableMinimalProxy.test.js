const { expect } = require('chai');
const { runTxAndLogGasUsed } = require('./helpers/Gas.helper');

describe('UpgradeableMinimalProxy', function () {
  let proxy, implementation, contract;

  const getProxyCode = () =>
    '0x363d3d373d3d3d363d7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc545af43d82803e903d91603857fd5bf3';

  before('deploy implementation and proxy', async () => {
    const Implementation = await ethers.getContractFactory(
      'UpgradeableImplementationV1'
    );
    implementation = await Implementation.deploy();
    await implementation.deployed();

    const Proxy = await ethers.getContractFactory('UpgradeableMinimalProxy');
    proxy = await Proxy.deploy(implementation.address);
    await proxy.deployed();

    contract = await ethers.getContractAt(
      'UpgradeableImplementationV1',
      proxy.address
    );
  });

  it('stored the admin correctly', async () => {
    const readAdmin = await ethers.provider.getStorageAt(
      proxy.address,
      '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
    );

    const admin = (await ethers.getSigners())[0].address;

    expect(
      ethers.utils.hexStripZeros(readAdmin).toLowerCase()
    ).to.equal(
      admin.toLowerCase()
    );
  });

  it('stored the implementation correctly', async () => {
    const readImplementation = await ethers.provider.getStorageAt(
      proxy.address,
      '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
    );

    expect(
      ethers.utils.hexStripZeros(readImplementation).toLowerCase()
    ).to.equal(
      implementation.address.toLowerCase()
    );
  });

  it('deploys a proxy with the correct code', async function () {
    const code = await ethers.provider.getCode(proxy.address);
    expect(code).to.equal(getProxyCode());
  });

  describe('when reading and writing values via the proxy', () => {
    describe('when the value is not set', () => {
      it('reads the correct value', async () => {
        const readValue = await contract.getValue();
        expect(readValue).to.equal(0);
      });
    });

    describe('when the value is set', () => {
      it('sets the value', async function() {
        await runTxAndLogGasUsed(this, await contract.setValue(42));
      });

      it('reads the correct value', async () => {
        const readValue = await contract.getValue();
        expect(readValue).to.equal(42);
      });
    });
  });

  describe('when upgrading the proxy', () => {
    before('update proxy wrapper interface', async () => {
      contract = await ethers.getContractAt(
        'ImplementationV2',
        proxy.address
      );
    });

    describe('before upgrading to V2', () => {
      it('reverts when interacting with an unknown function', async () => {
        expect(contract.getMessage()).to.be.reverted;
      });
    });

    describe('after upgrading to V2', () => {
      before('upgrade to V2', async () => {
        const Implementation = await ethers.getContractFactory(
          'ImplementationV2'
        );
        implementation = await Implementation.deploy();
        await implementation.deployed();

        await proxy.setImplementation(implementation.address);

        contract = await ethers.getContractAt(
          'ImplementationV2',
          proxy.address
        );
      });

      it('reads the correct message', async () => {
        const readMessage = await contract.getMessage();
        expect(readMessage).to.equal('');
      });

      describe('when the message is set', () => {
        before('set message in proxy', async () => {
          await contract.setMessage('forty two');
        });

        it('reads the correct message', async () => {
          const readMessage = await contract.getMessage();
          expect(readMessage).to.equal('forty two');
        });
      });

      describe('when trying to upgrade again', () => {
        before('deploy an implementation', async () => {
          const Implementation = await ethers.getContractFactory(
            'ImplementationV2'
          );
          implementation = await Implementation.deploy();
          await implementation.deployed();
        });

        it('reverts when trying to set the new implementation', async () => {
          expect(proxy.setImplementation(implementation.address)).to.be.revertedWith(
            "function selector was not recognized and there's no fallback function"
          );
        });
      });
    });
  });
});
