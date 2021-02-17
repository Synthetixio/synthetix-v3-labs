const { getDeploymentsFile, saveDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nPerforming migration on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  console.log(`  > Deploying migrator...`);

  const Migrator = await (
    await ethers.getContractFactory(`Migrator`)
  ).deploy();
  console.log(`  > Deployed migrator to ${Migrator.address}`);

  console.log(`  > Nominating migrator as owner...`);

  const OwnerModule = await ethers.getContractAt('OwnerModule', deployments.Synthetix.address);

  console.log(`  > Owner is ${await OwnerModule.getOwner()}`);

  let tx;

  tx = await OwnerModule.nominateOwner(Migrator.address);
  await tx.wait();

  console.log(`  > Starting migration...`);

  tx = await Migrator.migrate();
  await tx.wait();

  console.log(`  > Restoring ownership...`);

  tx = await OwnerModule.acceptOwnership();
  await tx.wait();

  console.log(`  > Owner is ${await OwnerModule.getOwner()}`);

  deployments.Synthetix.implementations.push(await Migrator.newRouter());
  saveDeploymentsFile({ deployments, network });

  console.log(`Migration completed`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
