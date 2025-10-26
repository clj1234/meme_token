// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyMemeToken is ERC20Upgradeable, OwnableUpgradeable {

    uint256 private feePercent; // 千分比 (e.g., 1 for 0.1%)
    address public taxAddress;  // 收税地址
    uint96 constant dailyTransferLimit = 10000 * 10 ** 18; // 每日转账上限
    uint96 constant everyTimeLimit = 500 * 10 ** 18; // 每次转账上限
    bool public mintFinished; // 铸币是否结束
    mapping (address=>TransferRecord) transferRecordMap;


    /**
     * 交易记录结构体
     * amount: 当日已转账总额
     * lastReset: 上次重置时间
     */
    struct TransferRecord {
        uint256 amount;
        uint256 lastReset;
    }

    /**
     * 初始化函数
     */
    function initialize(uint256 _feePercent,address _taxAddress) public initializer {
        __ERC20_init("MyMemeToken", "MEME");
        __Ownable_init(msg.sender);
        _mint(msg.sender, 100000 * 10 ** decimals());
        feePercent = _feePercent;
        taxAddress = _taxAddress;
    }

    function setTaxAddress(address _taxAddress) public onlyOwner {
        taxAddress = _taxAddress;
    }

    function mint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
        mintFinished = true;
    }
    /**
     * 重写转账函数，增加手续费和转账限制
     * @param to 目标地址
     * @param amount 金额
     */
    function transfer(address to, uint amount) public override returns (bool) {
        require(amount <= everyTimeLimit, "Transfer amount exceeds single transfer limit");
        uint fee = (amount * feePercent) / 1000;
        uint amountAfterFee = amount - fee;
        TransferRecord storage record = transferRecordMap[msg.sender];
        if (block.timestamp >= record.lastReset + 1 days) {
            record.amount = 0;
            record.lastReset = block.timestamp;
        }
        require(record.amount + amount <= dailyTransferLimit, "Transfer amount exceeds daily limit");
        record.amount += amount;
        if (fee > 0) {
            bool success = super.transfer(taxAddress, fee);
            require(success, "Fee transfer failed");
        }
        bool result = super.transfer(to, amountAfterFee);
        return result;
    }
}
    

