const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nDeploying new proxy on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  const Router = await (
    await ethers.getContractFactory('Router')
  ).deploy();

  const Proxy = await (
    await ethers.getContractFactory('Proxy')
  ).deploy(Router.address);

  deployments.Proxy.address = Proxy.address;
  deployments.Proxy.implementations = [Router.address];

  console.log(`  > Deployed new proxy at ${Proxy.address} with first router implementation ${Router.address}`);

  saveDeploymentsFile({ deployments, network });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
