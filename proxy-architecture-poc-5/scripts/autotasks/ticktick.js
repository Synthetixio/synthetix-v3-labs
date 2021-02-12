/* VERSION 2 */

const { ethers } = require("ethers");
const { DefenderRelayProvider, DefenderRelaySigner } = require('defender-relay-client/lib/ethers');

const abi = [
  {
    "inputs": [],
    "name": "getValue",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "newValue",
        "type": "uint256"
      }
    ],
    "name": "setValue",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];

exports.handler = async function(credentials) {
  const provider = new DefenderRelayProvider(credentials);

  const signer = new DefenderRelaySigner(credentials, provider, {
    speed: 'fast',
  });

  const Synthetix_kovan = '0x308Ad118BBCAdc835cA99D82F30845Cc93375516';
  const BModule = new ethers.Contract(Synthetix_kovan, abi, signer);

  let currentValue = parseInt((await BModule.getValue()).toString(), 10);
  console.log(`  > Current BModule.value: ${currentValue}`);

  console.log(`  > Sending transaction from ${process.env.DEFENDER_TICKER_RELAYER_ADDRESS}`);

  const tx = await BModule.setValue(`${currentValue + 1}`);
  const receipt = await tx.wait();

  console.log(`  > Tx sent: ${receipt.transactionHash}`);

  currentValue = parseInt((await BModule.getValue()).toString(), 10);
  console.log(`  > New BModule.value: ${currentValue}`);

  return receipt.transactionHash;
}
