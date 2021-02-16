const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nDeploying new proxy on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  const Synthetix = await (
    await ethers.getContractFactory(`Synthetix`)
  ).deploy();

  console.log(`  > Deployed new Synthetix at ${Synthetix.address}`);

  deployments.Synthetix.address = Synthetix.address;

  saveDeploymentsFile({ deployments, network });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
