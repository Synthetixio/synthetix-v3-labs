const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nDeploying new proxy on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  const Router = await (
    await ethers.getContractFactory('Router')
  ).deploy();

  const Synthetix = await (
    await ethers.getContractFactory('Synthetix')
  ).deploy(Router.address);

  deployments.Synthetix.address = Synthetix.address;
  deployments.Synthetix.implementations = [Router.address];

  console.log(`  > Deployed new proxy at ${Synthetix.address}`);

  saveDeploymentsFile({ deployments, network });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
