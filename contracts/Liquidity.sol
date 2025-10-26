// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
contract Liquidity is OwnableUpgradeable {
    // using CurrencyLibrary for Currency;
    address public tokenAddress; 

    IUniswapV2Router02 public uniswapRouter;

    uint256 public liquidityLock;



    /**
     * 初始化函数
     * @param _tokenAddress 代币地址
     * @param _uniswapRouter 流动性池合约实例
     */
    function initialize(address _tokenAddress,address _uniswapRouter) public initializer {
        __Ownable_init(msg.sender);
        liquidityLock = block.timestamp + 1 minutes; // 初始锁定1分钟
        tokenAddress = _tokenAddress;
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
    }

    /**
     * 增加流动性，LPT由当前合约当前合约持有（在lock期满后可由合约拥有者移除）
     * @param tokenAmount 代币金额
     * @param ethAmount eth金额
     */
    function addLiquidityOwner(uint256 tokenAmount, uint256 ethAmount) external onlyOwner payable{
        require(tokenAmount > 0, "Token amount is zero");
        require(ethAmount > 0, "ETH amount is zero");
        // 代币转账至本合约
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), tokenAmount);
        // approve token transfer to cover all possible scenarios
        IERC20(tokenAddress).approve(address(uniswapRouter), tokenAmount);

        // add the liquidity
        uniswapRouter.addLiquidityETH{value: ethAmount}(
            tokenAddress,
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
    }

    // /**
    //  * 用户增加流动性
    //  * @param tokenAmount 代币金额
    //  * @param ethAmount eth金额
    //  */
    // function addLiquidity(uint256 tokenAmount, uint256 ethAmount) external payable{
    //     // approve token transfer to cover all possible scenarios
    //     IERC20(tokenAddress).approve(address(uniswapRouter), tokenAmount);

    //     // add the liquidity
    //     uniswapRouter.addLiquidityETH{value: ethAmount}(
    //         tokenAddress,
    //         tokenAmount,
    //         0, // slippage is unavoidable
    //         0, // slippage is unavoidable
    //         msg.sender,
    //         block.timestamp
    //     );
    // }

    // 移除流动性（当前合约）
    function removeLiquidityOwner(uint256 liquidity) external onlyOwner {
        // approve the transfer of liquidity tokens
        // IERC20 pair = IERC20(uniswapRouter.pairFor(tokenAddress, uniswapRouter.WETH()));
        // pair.approve(address(uniswapRouter), liquidity);
        require(block.timestamp >= liquidityLock, "Liquidity is locked");
        // remove the liquidity
        uniswapRouter.removeLiquidityETH(
            tokenAddress,
            liquidity,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
    }

    // // 用户移除流动性
    // function removeLiquidity(uint256 liquidity) external {
    //     // approve the transfer of liquidity tokens
    //     // remove the liquidity
    //     uniswapRouter.removeLiquidityETH(
    //         tokenAddress,
    //         liquidity,
    //         0, // slippage is unavoidable
    //         0, // slippage is unavoidable
    //         msg.sender,
    //         block.timestamp
    //     );
    // }

    function lockLiquidity(uint256 minutesToLock) public onlyOwner {
        if(liquidityLock < block.timestamp){
        liquidityLock = block.timestamp + minutesToLock * 1 minutes;
        } else {
            liquidityLock += minutesToLock * 1 minutes;
        }
    }
}