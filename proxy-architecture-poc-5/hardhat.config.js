require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-waffle');

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
  }
};

