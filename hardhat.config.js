// const { HardhatUserConfig } = require('hardhat/config');
require('@nomicfoundation/hardhat-toolbox');
const dotenv = require('dotenv');
dotenv.config();
const { ALCHEMY_API_KEY, ETHERSCAN_API_KEY, URL, PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
const HardhatUserConfig = {
  paths: {
    artifacts: 'build/artifacts',
    cache: 'build/cache',
    sources: 'contracts',
  },
  solidity: {
    compilers: [
      {
        version: '0.8.19',
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
      {
        version: '0.6.12',
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
      {
        version: '0.6.0',
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
    ],
  },
  mocha: {
    timeout: 100000000,
  },
  networks: {
    hardhat: {
      forking: {
        url: `${URL}`,
        blockNumber: 28775016,
      },
    },
    'truffle-dashboard': {
      url: 'http://localhost:24012/rpc',
    },
    testnet: {
      url: 'https://dawn-practical-energy.bsc-testnet.discover.quiknode.pro/abffc9cd06b56abd795a37df0eddff66bcd320d2/',
      chainId: 97,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    mainnet: {
      url: 'https://bsc-dataseed.binance.org/',
      chainId: 56,
      // gasPrice: 20000000000,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
};

module.exports = HardhatUserConfig;
