const { getDeploymentsFile } = require('./utils/deploymentsFile');
const { AdminClient } = require('defender-admin-client');

async function main() {
  const network = hre.network.name;
  console.log(`\nUpdating Defender contracts for the ${network} network...`);

  const deployments = getDeploymentsFile({ network });
  const proxyAddress = deployments.Synthetix.address;

  const defender = new AdminClient({
    apiKey: process.env.DEFENDER_KEY,
    apiSecret: process.env.DEFENDER_SECRET,
  });


  const modules = Object.keys(deployments.modules);

  let allAbis = [];
  for (let i = 0; i < modules.length; i++) {
    const moduleName = modules[i];
    console.log(`  > Updating Defender for ${moduleName}`);

    const Module = await ethers.getContractAt(moduleName, proxyAddress);
    const abi = Module.interface.format('json');

    allAbis = allAbis.concat(JSON.parse(abi));
  };

  const abi = JSON.stringify(allAbis, null, 2);
  await defender.addContract({
    network,
    address: proxyAddress,
    name: 'Synthetix',
    abi
  });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
