require('dotenv').config();

require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');

module.exports = {
  solidity: {
    version: "0.7.3",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      }
    }
  },
  defaultNetwork: 'local',
  networks: {
    local: {
      url: 'http://localhost:8545',
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: {
        mnemonic: process.env.MNEMONIC
      }
    }
  }
};
