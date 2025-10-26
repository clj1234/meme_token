const { time } = require("console");

require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("hardhat-deploy");
require("@openzeppelin/hardhat-upgrades");
/** @type import('hardhat/config').HardhatUserConfig */
const { PRIVATE_KEY, SEPOLIA_RPC_URL } = process.env;
console.log("PRIVATE_KEY:", PRIVATE_KEY ? "Loaded" : "Missing");
console.log("RPC_URL:", SEPOLIA_RPC_URL ? "Loaded" : "Missing");

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/ee21fca4bf0c434bb94402e53f4def84",
      accounts: [PRIVATE_KEY],
      timeout: 1000000,
    },
    // localhost: {
    //   url: "127.0.0.1:88545",
    // }
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
};
