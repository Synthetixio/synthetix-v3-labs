const { expect } = require('chai');
const { runTxAndLogGasUsed } = require('./helpers/Gas.helper');

describe('NoProxy', function () {
  let contract;

  before('deploy contract', async () => {
    const Implementation = await ethers.getContractFactory('ImplementationV2');
    contract = await Implementation.deploy();
    await contract.deployed();
  });

  it('deployed the contract', async () => {
    expect(contract.address).to.be.properAddress;
  });

  describe('when reading and writing values', () => {
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
});
