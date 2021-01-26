require('dotenv').config();

require('@nomiclabs/hardhat-ethers');

module.exports = {
  solidity: "0.7.6",
  networks: {
    kovan: {
      url: `https://kovan.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: {
        mnemonic: process.env.MNEMONIC
      }
    }
  }
};

