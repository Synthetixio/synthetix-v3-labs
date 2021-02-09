const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nDeploying new proxy on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  deployments.Proxy.implementations = [];

  const Proxy = await (
    await ethers.getContractFactory('Proxy')
  ).deploy();

  deployments.Proxy.address = Proxy.address;

  console.log(`  > Deployed new proxy at ${Proxy.address}`);

  saveDeploymentsFile({ deployments, network });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
