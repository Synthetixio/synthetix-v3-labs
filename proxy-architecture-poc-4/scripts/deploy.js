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

  console.log(`Upgrading the system...`);

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

  console.log('');

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

  // ---------------
  // Deploy modules
  // ---------------

  console.log(`Upgrading the modules...`);

  function getModuleBytecode(moduleName) {
    const file = fs.readFileSync(`artifacts/contracts/modules/${moduleName}.sol/${moduleName}.json`);
    const data = JSON.parse(file);

    return data.bytecode;
  }

  function logModuleSelectors(module) {
    console.log('  > Selectors:');
    module.interface.fragments.map(fragment => {
      if (fragment.type === "function") {
        const method = fragment.name;
        const selector = module.interface.getSighash(fragment);

        console.log(`    * ${method}: ${selector}`);
      }
    });
  }

  const modules = Object.keys(deployments.modules);

  for (let i = 0; i < modules.length; i++) {
    const moduleName = modules[i];
    const module = deployments.modules[moduleName];

    const isNewModule = module.implementation === '';

    const bytecode = getModuleBytecode(moduleName);
    const bytecodeHash = ethers.utils.sha256(bytecode);
    const bytecodeChanged = bytecodeHash !== deployments.modules[moduleName].bytecodeHash;

    let Module;

    if (isNewModule || bytecodeChanged) {
      console.log(`Deploying new ${moduleName} instance...`);

      const factory = await ethers.getContractFactory(moduleName);
      Module = await factory.deploy();

      deployments.modules[moduleName].implementation = Module.address;
      deployments.modules[moduleName].bytecodeHash = bytecodeHash;
      saveDeploymentsFile();
    } else {
      Module = await ethers.getContractAt(moduleName, module.implementation);
    }

    console.log(`Identifyed ${moduleName}`);
    logModuleSelectors(Module);
  };

  console.log('');

  // -------------
  // Test modules
  // -------------

  console.log('Testing the modules...');

  async function getModule(moduleName) {
    return await ethers.getContractAt(moduleName, Synthetix.address);
  }

  const SystemModule = await getModule('SystemModule');
  const ExchangerModule = await getModule('ExchangerModule');
  const IssuerModule = await getModule('IssuerModule');

  // SystemModule writing to GlobalStorage.version
  const version = '1';
  if (await SystemModule.getVersion() !== version) {
    console.log(`Setting GlobalStorage.version via SystemModule...`);

    tx = await SystemModule.setVersion(version);
    await tx.wait();
  }
  console.log(`GlobalStorage.version via SystemModule: ${await SystemModule.getVersion()}`);

  // ExchangerModule reading to GlobalStorage.version
  console.log(`GlobalStorage.version via ExchangerModule: ${await ExchangerModule.getSystemVersion()}`);

  // IssuerModule accessing GlobalStorage.version indirectly via ExchangerModule
  console.log(`GlobalStorage.version via IssuerModule: ${await IssuerModule.getVersionViaExchanger()}`);

  // IssuerModule accessing writing IssuanceStorage.oracleType
  const oracleType = 'chainlink';
  if (await IssuerModule.getOracleType() !== oracleType) {
    console.log(`Setting IssuanceStorage.oracleType via IssuerModule...`);

    tx = await IssuerModule.setOracleType(oracleType);
    await tx.wait();
  }
  console.log(`IssuanceStorage.oracleType via IssuerModule: ${await IssuerModule.getOracleType()}`);
}

deploy()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
