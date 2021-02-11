const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nRegistering modules on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  const modules = Object.keys(deployments.modules);

  const moduleIds = [];
  const moduleAddresses = [];
  for (let i = 0; i < modules.length; i++) {
    const moduleName = modules[i];

    const module = deployments.modules[modules[i]];

    const moduleId = ethers.utils.formatBytes32String(moduleName);

    moduleIds.push(moduleId);
    moduleAddresses.push(module.implementation);
  };

  console.log(`  > Module ids: ${moduleIds}`);
  console.log(`  > Module addresses: ${moduleAddresses}`);

  const RegistryModule = await ethers.getContractAt('RegistryModule', deployments.Synthetix.address);

  const tx = await RegistryModule.registerModules(moduleIds, moduleAddresses);
  await tx.wait();

  console.log(`  > Modules registered`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
