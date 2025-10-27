# SHIB 风格代币合约

项目结构

```
meme_token/
├─ contracts/           # 所有 Solidity 合约文件 (.sol)
│  ├─ Token.sol
│  ├─ Liquidity.sol
├─ deploy/
├─ test/                # 测试文件（Mocha/Chai）
│  ├─ Token.test.js
│  ├─ Liquidity.test.js
│  └─ SimpleSwap.test.js
├─ .env                 # 环境变量（私钥、RPC 等）
├─ hardhat.config.js    # Hardhat 配置文件
```



### MyMemeToken.sol

##### 1、每日、每次转账上限

##### 2、代币交易税



### Liquidity.sol

##### 1、自动添加流动性

##### 2、流动性时间锁



## 合约部署

### 配置文件

```
./hardhat.config.js
./config.json
```

#### .env  文件结构

```
PRIVATE_KEY=PRIVATE_KEY
SEPOLIA_RPC_URL=SEPOLIA_RPC_URL
```



### 部署指令

```
npx hardhat deploy --tags MyMemeToken --network sepolia
npx hardhat deploy --tags Liquidity --network sepolia
```

### 测试指令

```
npx hardhat test ./test/MyMemeToken.js

npx hardhat test ./test/Liquidity.js   	
```



