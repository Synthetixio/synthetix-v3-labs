const fs = require('fs');
const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nChecking system modules on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  function getModuleBytecode(moduleName) {
    const file = fs.readFileSync(`artifacts/contracts/modules/${moduleName}.sol/${moduleName}.json`);
    const data = JSON.parse(file);

    return data.bytecode;
  }

  const modules = Object.keys(deployments.modules);

  for (let i = 0; i < modules.length; i++) {
    const moduleName = modules[i];
    console.log(`  > Processing ${moduleName}`);

    const module = deployments.modules[moduleName];

    const isNewModule = module.implementation === '';
    console.log(`    * Is new module: ${isNewModule}`);

    const bytecode = getModuleBytecode(moduleName);
    const bytecodeHash = ethers.utils.sha256(bytecode);
    const bytecodeChanged = bytecodeHash !== deployments.modules[moduleName].bytecodeHash;
    console.log(`    * Bytecode changed: ${bytecodeChanged}`);

    if (isNewModule || bytecodeChanged) {
      console.log(`    > Deploying new ${moduleName} instance...`);

      const factory = await ethers.getContractFactory(moduleName);
      Module = await factory.deploy();

      deployments.modules[moduleName].implementation = Module.address;
      deployments.modules[moduleName].bytecodeHash = bytecodeHash;
      saveDeploymentsFile({ deployments, network });
    } else {
      console.log(`    > No need to deploy ${moduleName}`);
    }
  };
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
