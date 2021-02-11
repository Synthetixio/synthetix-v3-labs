const { expect } = require("chai");
const { getDeploymentsFile } = require('../scripts/utils/deploymentsFile');

describe("RegistryModule", function() {
  let network;
  let proxyAddress;

  let RegistryModule;

  before('identify network', async function () {
    network = hre.network.name;
  });

  before('retrieve main proxy address', async function () {
    deployments = getDeploymentsFile({ network });

    proxyAddress = deployments.Synthetix.address;
  });

  before('connect to modules', async function () {
    RegistryModule = await ethers.getContractAt('RegistryModule', proxyAddress);
  });

  it('has registered the modules correctly', async function () {
    const modules = Object.keys(deployments.modules);

    for (let i = 0; i < modules.length; i++) {
      const moduleName = modules[i];

      const module = deployments.modules[moduleName];

      const moduleId = ethers.utils.formatBytes32String(moduleName);
      const moduleAddress = module.implementation;

      expect(
        await RegistryModule.getModuleImplementation(moduleId)
      ).to.be.equal(
        moduleAddress
      );
    };
  });
});
