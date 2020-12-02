const { expect } = require('chai');
const { runTxAndLogGasUsed } = require('./helpers/Gas.helper');

describe('MetamorphicMinimalProxy', function () {
  let factory, proxy, implementation, contract;

  const getProxyCode = (implementationAddress) =>
    `0x363d3d373d3d3d363d73${implementationAddress
      .slice(2)
      .toLowerCase()}5af43d82803e903d91602b57fd5bf3`;

  before('deploy implementation and proxy', async () => {
    const Implementation = await ethers.getContractFactory('UpgradeableImplementationV1');
    implementation = await Implementation.deploy();
    await implementation.deployed();

		const ProxyFactory = await ethers.getContractFactory('MetamorphicProxyFactory');
		factory = await ProxyFactory.deploy();
		await factory.deployed();

		const tx = await factory.createProxy(implementation.address, 0);
		const receipt = await tx.wait();

    const event = receipt.events.find(e => e.event === 'ProxyCreated');
    const proxyAddress = event.args[0];
    proxy = await ethers.getContractAt(
      'UpgradeableMinimalProxy',
      proxyAddress
    );

    contract = await ethers.getContractAt(
      'UpgradeableImplementationV1',
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

    describe('after upgrading to V2', () => {
      before('upgrade to V2', async () => {
        const Implementation = await ethers.getContractFactory(
          'ImplementationV2'
        );
        implementation = await Implementation.deploy();
        await implementation.deployed();

        await proxy.destroy();

		    const tx = await factory.createProxy(implementation.address, 0);
		    const receipt = await tx.wait();

        const event = receipt.events.find(e => e.event === 'ProxyCreated');
        const proxyAddress = event.args[0];
        proxy = await ethers.getContractAt(
          'UpgradeableMinimalProxy',
          proxyAddress
        );

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
