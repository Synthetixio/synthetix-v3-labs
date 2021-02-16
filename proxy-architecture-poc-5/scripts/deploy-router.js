async function main() {
  const network = hre.network.name;
  console.log(`\nDeploying candidate router on the ${network} network...`);

  const Router = await (
    await ethers.getContractFactory(`Router_${network}`)
  ).deploy();

  console.log(`  > New router deployed: ${Router.address}`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
