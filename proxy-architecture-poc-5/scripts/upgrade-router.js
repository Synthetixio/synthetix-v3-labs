const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nUpgrading router on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  /* Deploy implementation */

  const Router = await (
    await ethers.getContractFactory('Router')
  ).deploy();

  /* Set implementation */

  const UpgradeModule = await ethers.getContractAt('UpgradeModule', deployments.Proxy.address);

  const tx = await UpgradeModule.setImplementation(Router.address);
  await tx.wait();

  console.log(`  > New router implementation set: ${Router.address}`);

  deployments.Proxy.implementations.push(Router.address);

  saveDeploymentsFile({ deployments, network });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
