const { getDeploymentsFile } = require('./utils/deploymentsFile');
const { DefenderRelayProvider, DefenderRelaySigner } = require('defender-relay-client/lib/ethers');

async function main() {
  const network = hre.network.name;
  console.log(`\nUsing the Ticker relayer to increment BModule.value on the ${network} network...`);

  const deployments = getDeploymentsFile({ network });

  const credentials = {
    apiKey: process.env.DEFENDER_TICKER_RELAYER_KEY,
    apiSecret: process.env.DEFENDER_TICKER_RELAYER_SECRET
  };
  const provider = new DefenderRelayProvider(credentials);

  const signer = new DefenderRelaySigner(credentials, provider, {
    speed: 'fast',
  });

  let BModule = await ethers.getContractAt('BModule', deployments.Synthetix.address);
  BModule = BModule.connect(signer);

  let currentValue = parseInt((await BModule.getValue()).toString(), 10);
  console.log(`  > Current BModule.value: ${currentValue}`);

  console.log(`  > Sending transaction from ${process.env.DEFENDER_TICKER_RELAYER_ADDRESS}`);

  const tx = await BModule.setValue(`${currentValue + 1}`);
  const receipt = await tx.wait();

  console.log(`  > Tx sent: ${receipt.transactionHash}`);

  currentValue = parseInt((await BModule.getValue()).toString(), 10);
  console.log(`  > New BModule.value: ${currentValue}`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
