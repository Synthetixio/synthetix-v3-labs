const { expect } = require('chai');
const { runTxAndLogGasUsed } = require('./helpers/Gas.helper');

describe('MinimalProxy', function () {
  let proxy, implementation, contract;

  const getProxyCode = (implementationAddress) =>
    `0x363d3d373d3d3d363d73${implementationAddress
      .slice(2)
      .toLowerCase()}5af43d82803e903d91602b57fd5bf3`;

  before('deploy implementation and proxy', async () => {
    const Implementation = await ethers.getContractFactory('ImplementationV1');
    implementation = await Implementation.deploy();
    await implementation.deployed();

    const Proxy = await ethers.getContractFactory('MinimalProxy');
    proxy = await Proxy.deploy(implementation.address);
    await proxy.deployed();

    contract = await ethers.getContractAt(
      'ImplementationV1',
      proxy.address
    );
  });

  it('deploys a proxy with the correct code', async function () {
    const code = await ethers.provider.getCode(proxy.address);
    expect(code).to.equal(getProxyCode(implementation.address));
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
  });
});
