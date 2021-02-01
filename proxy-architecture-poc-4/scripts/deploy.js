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

  // ---------------
  // Deploy modules
  // ---------------

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

  // -------------
  // Test modules
  // -------------

  let tx;
  let readValue;
  let newValue;

  async function getModule(moduleName) {
    return await ethers.getContractAt(moduleName, Synthetix.address);
  }

  const ExchangerModule = await getModule('ExchangerModule');
  const IssuerModule = await getModule('IssuerModule');

  // ExchangerModule writing to GlobalStorage.someValue
  newValue = '42';
  readValue = await ExchangerModule.getValue();
  if (newValue !== readValue) {
    console.log(`Setting GlobalStorage.someValue via ExchangerModule...`);

    tx = await ExchangerModule.setValue(newValue);
    await tx.wait();
  }
  readValue = await ExchangerModule.getValue();
  console.log(`GlobalStorage.someValue via ExchangerModule: ${readValue}`);

  // IssuerModule accessing GlobalStorage.someValue indirectly via ExchangerModule
  readValue = (await IssuerModule.getValueViaExchanger()).toString();
  console.log(`GlobalStorage.someValue via IssuerModule: ${readValue}`);

  // IssuerModule accessing writing IssuanceStorage.oracleType
  newValue = 'chainlink';
  readValue = await IssuerModule.getOracleType();
  if (newValue !== readValue) {
    console.log(`Setting IssuanceStorage.oracleType via IssuerModule...`);

    tx = await IssuerModule.setOracleType(newValue);
    await tx.wait();
  }
  readValue = await IssuerModule.getOracleType();
  console.log(`IssuanceStorage.oracleType via IssuerModule: ${readValue}`);
}

deploy()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
