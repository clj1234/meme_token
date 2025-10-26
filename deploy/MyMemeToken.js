const {upgrades,ethers} = require('hardhat');

// sepoliaAddress : 0x9dFce74DEbC4d9a1456965bb4F81f257c577Bb2d
module.exports = async ({getNamedAccounts}) => {
    // const {deploy} = deployments;
    console.log("Starting deployment of MyMemeToken...");
    const { deployer } = await getNamedAccounts();
    console.log("Deployer address:", deployer);
    const MyToken = await ethers.getContractFactory("MyMemeToken");
    const token = await upgrades.deployProxy(
    MyToken,
    [
      1, // feePercent
      deployer // owner
    ],
    {
      initializer: "initialize",
      // kind: "uups"
    }
  );
    await token.waitForDeployment();
    memeTokenAddress = await token.getAddress();
    console.log("MyMemeToken deployed to:", memeTokenAddress);
    console.log("ℹ️ Implementation:", await upgrades.erc1967.getImplementationAddress(await token.getAddress()));

}

module.exports.tags = ["MyMemeToken"];