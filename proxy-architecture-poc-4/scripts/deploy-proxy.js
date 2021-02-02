const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function deployProxy() {
  const network = hre.network.name;
  console.log(`\nChecking main proxy on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  // ------------------------------
  // Deploy or retrieve main proxy
  // ------------------------------

  const proxyExists = deployments.Synthetix.proxy !== '';
  console.log(`  * Proxy exists: ${proxyExists}`);

  if (!proxyExists) {
    console.log(`  > Deploying main proxy...`);

    const factory = await ethers.getContractFactory('Synthetix');
    Synthetix = await upgrades.deployProxy(factory);

    const admin = await upgrades.admin.getInstance();
    const implementationAddress = await admin.getProxyImplementation(Synthetix.address);

    deployments.Synthetix.proxy = Synthetix.address;
    deployments.Synthetix.implementations.push(implementationAddress);
    saveDeploymentsFile({ deployments, network });
  } else {
    console.log(`  > No need to deploy main proxy`);
  }

  // -------------------
  // Upgrade main proxy
  // -------------------

  Synthetix = await ethers.getContractAt('Synthetix', deployments.Synthetix.proxy);

  const factory = await ethers.getContractFactory('Synthetix');
  const implementationAddress = await upgrades.prepareUpgrade(Synthetix.address, factory);

  const needsUpgrade = implementationAddress !== deployments.Synthetix.implementations.pop();
  console.log(`  * Needs upgrade: ${needsUpgrade}`);

  if (needsUpgrade) {
    console.log(`  > Upgrading main proxy implementation to ${implementationAddress}`);

    Synthetix = await upgrades.upgradeProxy(Synthetix.address, factory);

    deployments.Synthetix.implementations.push(implementationAddress);
    saveDeploymentsFile({ deployments, network });
  } else {
    console.log(`  > No need to upgrade main proxy`);
  }
}

deployProxy()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
