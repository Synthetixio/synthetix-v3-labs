const { expect } = require('chai');
const { runTxAndLogGasUsed } = require('./helpers/Gas.helper');

describe('TransparentUpgradeableProxy', function () {
  let proxy, implementation, contract;

  before('deploy implementation and proxy', async () => {
    const Implementation = await ethers.getContractFactory('ImplementationV1');
    implementation = await Implementation.deploy();
    await implementation.deployed();

    const Proxy = await ethers.getContractFactory('TransparentUpgradeableProxy');
    proxy = await Proxy.deploy(implementation.address);
    await proxy.deployed();

    contract = await ethers.getContractAt(
      'ImplementationV1',
      proxy.address
    );
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
    });
  });
});
