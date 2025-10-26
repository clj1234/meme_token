const { expect } = require("chai");
const { ethers } = require("hardhat");
require("dotenv").config();

describe("Liquidity", function () {

  it("test Liquidity", async function () {
    // const [owner] = await ethers.getSigners();
    // 获取部署者账户
    const provider = new ethers.JsonRpcProvider(process.env.SEPOLIA_RPC_URL);
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

    liquidityAddress = "0x9680BC8B3603b6DF53099902f25e3b82B9535dA3";
    // 获取合约实例
    liquidity = await ethers.getContractAt(
      "Liquidity",
      liquidityAddress,
      wallet
    );
    provider.on("debug", (info) => {
      console.log("DEBUG:", info);
    });
    await liquidity.addLiquidityOwner(ethers.parseUnits("1000", 18),ethers.parseUnits("0.005", 18),{value: ethers.parseUnits("0.005", 18),gasLimit: 3_000_000});
    await liquidity.lockLiquidity(60);

  });

});