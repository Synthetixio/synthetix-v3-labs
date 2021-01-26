const fs = require('fs');

async function deploy() {
  const owner = '0x68BF577920D6607c52114CB5E13696a19c2C9eFa';

  // ---------------------------
  // Facet utils
  // ---------------------------

  function getSelectors(contract) {
    return contract.interface.fragments.reduce((selectors, fragment) => {
      if (fragment.type === 'function') {
        selectors.push(contract.interface.getSighash(fragment));
      }

      return selectors;
    }, []);
  }

  async function deployContract({ name, args = [] }) {
    const factory = await ethers.getContractFactory(name);
    return await factory.deploy(...args);
  }

  async function getContract({ name, address }) {
    return await ethers.getContractAt(name, address);
  }

  // ---------------------------
  // Initial deploy of diamond
  // ---------------------------

  // TODO
}

deploy()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
