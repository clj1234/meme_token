const {upgrades,network} = require('hardhat');
const fs = require("fs");

// sepoliaAddress : 0x9680BC8B3603b6DF53099902f25e3b82B9535dA3
// Liquidity deployed to: 0x9680BC8B3603b6DF53099902f25e3b82B9535dA3
// Implementation: 0xfFB76C5c9cD48483ef61F952b4DdD22602622bBe
module.exports = async () => {
    console.log("Starting deployment of Liquidity...");
    config = JSON.parse(fs.readFileSync("./config.json"));
    const { deployer } = await getNamedAccounts();
    
    console.log("Deployer address:", deployer);
    const LiquidityFacctory = await ethers.getContractFactory("Liquidity");
    const uniswapAddress = config.uniswap.networks[network.name].uniswapV2Router02;
    const tokenAddress = config.token[network.name].tokenAddress;
    console.log("Uniswap Router Address:", uniswapAddress);
    console.log("Token Address:", tokenAddress);
    const Liquidity = await upgrades.deployProxy(
      LiquidityFacctory,
      [
        tokenAddress, // tokenAddress
        uniswapAddress // uniswapRouter
      ],
      {
        initializer: "initialize",
        // kind: "uups"
      }
    );
    await Liquidity.waitForDeployment();
    console.log("token:",await Liquidity.tokenAddress());
    console.log("uniswapRouter:",await Liquidity.uniswapRouter());

    console.log("Liquidity deployed to:", await Liquidity.getAddress());
    console.log("ℹ️ Implementation:", await upgrades.erc1967.getImplementationAddress(await Liquidity.getAddress()));

}

module.exports.tags = ["Liquidity"];