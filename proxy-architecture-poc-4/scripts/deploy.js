const fs = require('fs');

async function deploy() {
  const network = 'kovan';

  // -------------------
  // Retrieve data file
  // -------------------

  const deploymentsFilePath = `./deployments/${network}.json`;
	const deployments = JSON.parse(fs.readFileSync(deploymentsFilePath));

  function saveDeploymentsFile() {
	  fs.writeFileSync(
	    deploymentsFilePath,
	    JSON.stringify(deployments, null, 2)
	  );
  }

  // ------------------------------
  // Deploy or retrieve main proxy
  // ------------------------------

  let Synthetix;

  if (deployments.Synthetix.proxy === '') {
    console.log(`Main Synthetix proxy not found, deploying a new one...`);

    const factory = await ethers.getContractFactory('Synthetix');
    Synthetix = await upgrades.deployProxy(factory);

    const admin = await upgrades.admin.getInstance();
    const implementationAddress = await admin.getProxyImplementation(Synthetix.address);

    deployments.Synthetix.proxy = Synthetix.address;
    deployments.Synthetix.implementations.push(implementationAddress);
    saveDeploymentsFile();
  } else {
    Synthetix = await ethers.getContractAt('Synthetix', deployments.Synthetix.proxy);
  }

  console.log(`Connected to Synthetix proxy at ${Synthetix.address}`);

  // -------------------
  // Upgrade main proxy
  // -------------------

  const factory = await ethers.getContractFactory('Synthetix');
  const implementationAddress = await upgrades.prepareUpgrade(Synthetix.address, factory);

  if (implementationAddress !== deployments.Synthetix.implementations.pop()) {
    console.log(`Upgrading Synthetix proxy implementation to ${implementationAddress}`);

    Synthetix = await upgrades.upgradeProxy(Synthetix.address, factory);

    deployments.Synthetix.implementations.push(implementationAddress);
    saveDeploymentsFile();
  }
}

deploy()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
