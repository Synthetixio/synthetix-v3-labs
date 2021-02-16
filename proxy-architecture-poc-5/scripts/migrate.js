const { getDeploymentsFile } = require('./utils/deploymentsFile');

async function main() {
  const network = hre.network.name;
  console.log(`\nPerforming migration on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  console.log(`  > Deploying migrator...`);

  const Migrator = await (
    await ethers.getContractFactory(`Migrator`)
  ).deploy();

  console.log(`  > Nominating migrator as owner...`);

  const OwnerModule = await ethers.getContractAt('OwnerModule', deployments.Synthetix.address);

  let tx;

  tx = await OwnerModule.nominateOwner(Migrator.address);
  await tx.wait();

  console.log(`  > Starting migration...`);

  tx = await Migrator.migrate();
  const receipt = await tx.wait();
  console.log('  > Events:');
  receipt.events.map(e => {
    console.log(`    * ${e.event} - ${e.args}`);
  });

  console.log(`Migration completed`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
