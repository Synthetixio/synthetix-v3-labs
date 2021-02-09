const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function deployProxy() {
  const network = hre.network.name;
  console.log(`\nChecking main proxy on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  let factory;

  // ------------------------------------
  // Deploy latest router implementation
  // ------------------------------------

  let Router;

  factory = await ethers.getContractFactory('Router');
  Router = await factory.deploy();

  console.log(`  > Deployed router to ${Router.address}`);

  // ------------------------------
  // Deploy or retrieve main proxy
  // ------------------------------

  const proxyExists = deployments.Proxy.proxy !== '';
  console.log(`  * Proxy exists: ${proxyExists}`);

  let Proxy;

  if (!proxyExists) {
    console.log(`  > Deploying main proxy...`);

    factory = await ethers.getContractFactory('Proxy');
    Proxy = await factory.deploy(Router.address);

    const implementationAddress = await Proxy.implementation();

    deployments.Proxy.address = Proxy.address;
    deployments.Proxy.implementations.push(implementationAddress);
    saveDeploymentsFile({ deployments, network });
  } else {
    console.log(`  > No need to deploy main proxy`);
    console.log(`  > Upgrading main proxy implementation to ${Router.address}`);

    const UpgradeModule = await ethers.getContractAt('UpgradeModule', deployments.Proxy.address);
    await UpgradeModule.upgradeTo(Router.address);
  }
}

deployProxy()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
