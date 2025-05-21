// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 导入自毁合约
import "./045Selfdestruct.sol";

/// @title 临时钱包工厂：演示合约的创建与销毁
/// @notice 这是一个教学示例，展示如何创建临时钱包并在使用后销毁它们
contract WalletFactory {

    // 创建钱包时触发的事件
    event WalletCreated(address indexed wallet, uint amount);
    // 销毁钱包时触发的事件
    event WalletDestroyed(address indexed wallet, uint returnedAmount);

    // 记录创建的钱包总数
    uint public totalWalletsCreated;
    // 记录当前活跃的钱包数量
    uint public activeWallets;
    // 记录工厂合约创建者地址
    address public immutable owner;

 
    // 用于记录钱包操作的结果
    struct WalletOperation {
        address walletAddress;    // 钱包合约地址
        uint depositAmount;       // 存入的金额
        uint timestamp;          // 操作时间戳
        bool isDestroyed;        // 是否已销毁
    }


    // 记录所有钱包操作的历史
    mapping(uint => WalletOperation) public walletHistory;

    /// @notice 构造函数，初始化工厂合约
    constructor() {
        // 设置合约部署者为工厂所有者
        owner = msg.sender;
        // 初始化计数器
        totalWalletsCreated = 0;
        activeWallets = 0;
    }

    /// @notice 创建一个新的临时钱包并存入资金
    /// @dev 创建DeleteContract实例作为临时钱包
    /// @return operation 返回钱包操作的详细信息
    function createTemporaryWallet() public payable returns (WalletOperation memory operation) {

        // 要求存入的资金大于0
        require(msg.value > 0, "Must deposit some ETH to create wallet");

        // 创建新的钱包合约（DeleteContract实例）并转入ETH
        DeleteContract wallet = new DeleteContract{value: msg.value}();

        // 更新计数器
        totalWalletsCreated++;
        activeWallets++;

        // 记录本次操作
        operation = WalletOperation({
            walletAddress: address(wallet),
            depositAmount: msg.value,
            timestamp: block.timestamp,
            isDestroyed: false
        });

        // 将操作记录保存到历史记录中
        walletHistory[totalWalletsCreated] = operation;

        // 触发钱包创建事件
        emit WalletCreated(address(wallet), msg.value);
    }

    /// @notice 销毁指定的临时钱包
    /// @param walletId 要销毁的钱包ID（创建时的序号）
    /// @return success 操作是否成功
    function destroyWallet(uint walletId) public returns (bool success) {
        // 检查钱包ID是否有效
        require(walletId > 0 && walletId <= totalWalletsCreated, "Invalid wallet ID");
        
        // 获取钱包操作记录
        WalletOperation storage operation = walletHistory[walletId];
        
        // 检查钱包是否已被销毁
        require(!operation.isDestroyed, "Wallet already destroyed");

        // 获取钱包合约实例
        DeleteContract wallet = DeleteContract(payable(operation.walletAddress));
        
        // 获取销毁前的余额
        uint balanceBeforeDestroy = wallet.getBalance();

        // 销毁钱包合约
        wallet.deleteContract();
        
        // 更新状态
        operation.isDestroyed = true;
        activeWallets--;

        // 触发销毁事件
        emit WalletDestroyed(operation.walletAddress, balanceBeforeDestroy);

        return true;
    }

    /// @notice 获取钱包的当前状态
    /// @param walletId 钱包ID
    /// @return operation 钱包操作记录
    function getWalletInfo(uint walletId) public view returns (WalletOperation memory) {
        // 检查钱包ID是否有效
        require(walletId > 0 && walletId <= totalWalletsCreated, "Invalid wallet ID");
        return walletHistory[walletId];
    }

    /// @notice 获取工厂合约的ETH余额
    /// @return 合约的ETH余额（单位：wei）
    function getFactoryBalance() public view returns (uint) {
        return address(this).balance;
    }

    /// @notice 获取合约的基本统计信息
    /// @return total 创建的总钱包数
    /// @return active 当前活跃的钱包数
    function getStats() public view returns (uint total, uint active) {
        return (totalWalletsCreated, activeWallets);
    }
}