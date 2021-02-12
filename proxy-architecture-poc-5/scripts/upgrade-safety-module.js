const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nUpgrading SafetyModule on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  const factory = await ethers.getContractFactory('SafetyModule');
  const implementationAddress = await upgrades.prepareUpgrade(deployments.SafetyModule.address, factory);

  const needsUpgrade = implementationAddress !== deployments.SafetyModule.implementations.pop();
  if (needsUpgrade) {
    await upgrades.upgradeProxy(deployments.SafetyModule.address, factory);

    deployments.SafetyModule.implementations.push(implementationAddress);
    saveDeploymentsFile({ deployments, network });

    console.log(`  > Upgraded SafetyModule to ${implementationAddress}`);
  } else {
    console.log('  > No need to upgrade SafetyModule');
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
