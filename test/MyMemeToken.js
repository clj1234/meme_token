const { expect } = require("chai");
const { ethers } = require("hardhat");
require("dotenv").config();

describe("MyMemeToken", function () {

  it("should have correct name and total supply", async function () {
    // const [owner] = await ethers.getSigners();
    // 
    const provider = new ethers.JsonRpcProvider(process.env.SEPOLIA_RPC_URL);
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
    // 获取合约实例
    myToken = await ethers.getContractAt(
      "MyMemeToken",
      "0x9dFce74DEbC4d9a1456965bb4F81f257c577Bb2d",
      wallet,
    );
    // console.log("Token Name:", await myToken.name());
    // const balance = await myToken.balanceOf(await wallet.getAddress());
    // console.log("acount1balance:", ethers.formatUnits(balance, 18));

    // const result = await myToken.transfer("0x313eF32370E9aEF562e8B7b69Bdb2ddaEF60b0f4", ethers.parseUnits("1.0", 18));
    // console.log("Transfer Result:", result);
    
    console.log("acount2Balance:", ethers.formatUnits(await myToken.balanceOf("0x313eF32370E9aEF562e8B7b69Bdb2ddaEF60b0f4"), 18));
    console.log("acount1Balance:", ethers.formatUnits(await myToken.balanceOf(await wallet.getAddress()), 18));
  });

});