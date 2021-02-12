const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nClearing deployment for the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  deployments.Synthetix.address = '';
  deployments.Synthetix.implementations = [];

  deployments.SafetyModule.address = '';
  deployments.SafetyModule.implementations = [];

  const modules = Object.keys(deployments.modules);

  for (let i = 0; i < modules.length; i++) {
    const moduleName = modules[i];

    deployments.modules[moduleName] = {
      bytecodeHash: '',
      implementation: ''
    };
  }

  saveDeploymentsFile({ deployments, network });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
