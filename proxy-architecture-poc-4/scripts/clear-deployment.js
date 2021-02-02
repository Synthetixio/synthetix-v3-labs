const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function clearDeployment() {
  const network = hre.network.name;
  console.log(`\nClearing deployment for the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  deployments.Synthetix.proxy = '';
  deployments.Synthetix.implementations = [];

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

clearDeployment()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
