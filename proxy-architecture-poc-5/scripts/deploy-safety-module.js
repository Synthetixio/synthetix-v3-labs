const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nDeploying safety module on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  const factory = await ethers.getContractFactory('SafetyModule');
  SafetyModule = await upgrades.deployProxy(factory);

  const admin = await upgrades.admin.getInstance();
  const implementationAddress = await admin.getProxyImplementation(SafetyModule.address);

  deployments.SafetyModule.address = SafetyModule.address;
  deployments.SafetyModule.implementations.push(implementationAddress);

  saveDeploymentsFile({ deployments, network });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
