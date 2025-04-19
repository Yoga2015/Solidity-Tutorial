// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 银行账户合约：展示不同的异常处理方式
contract BankAccount {
    
    // 定义账户结构体
    struct Account {
        address owner;      // 账户所有者地址
        uint256 balance;    // 账户余额
        bool isActive;      // 账户是否激活
    }
    
    // 状态变量
    mapping(address => Account) public accounts;  // 地址到账户的映射
    uint256 public minimumBalance;               // 最小余额要求
    address public bankOwner;                    // 银行所有者
    
    // 自定义错误
    error InsufficientBalance(uint256 available, uint256 required);  // 余额不足错误
    error AccountNotActive(address account);                         // 账户未激活错误
    error Unauthorized(address caller);                              // 未授权错误

    // 构造函数：设置银行所有者和最小余额
    constructor(uint256 _minimumBalance) {
        bankOwner = msg.sender;
        minimumBalance = _minimumBalance;
    }

    // 修饰器：仅银行所有者可调用
    modifier onlyBankOwner() {
        if (msg.sender != bankOwner) {
            revert Unauthorized(msg.sender);
        }
        _;
    }

    // 创建账户函数
    // @param initialDeposit 初始存款金额
    function createAccount(uint256 initialDeposit) public {
        // 使用require检查初始存款是否满足最小余额要求
        require(
            initialDeposit >= minimumBalance,
            "Initial deposit must meet minimum balance requirement"
        );

        // 检查账户是否已存在
        require(
            !accounts[msg.sender].isActive,
            "Account already exists"
        );

        // 创建新账户
        accounts[msg.sender] = Account({
            owner: msg.sender,
            balance: initialDeposit,
            isActive: true
        });
    }

    // 存款函数
    // @param amount 存款金额
    function deposit(uint256 amount) public {
        // 使用自定义错误检查账户是否激活
        if (!accounts[msg.sender].isActive) {
            revert AccountNotActive(msg.sender);
        }

        // 更新余额
        accounts[msg.sender].balance += amount;
    }

    // 取款函数
    // @param amount 取款金额
    function withdraw(uint256 amount) public {
        Account storage account = accounts[msg.sender];
        
        // 检查账户是否激活
        if (!account.isActive) {
            revert AccountNotActive(msg.sender);
        }

        // 检查余额是否充足
        uint256 newBalance = account.balance - amount;
        if (newBalance < minimumBalance) {
            revert InsufficientBalance(account.balance, amount);
        }

        // 更新余额
        account.balance = newBalance;
    }

    // 关闭账户函数
    function closeAccount() public {
        Account storage account = accounts[msg.sender];
        
        // 使用assert确保账户存在且属于调用者
        assert(account.isActive && account.owner == msg.sender);
        
        // 转出所有余额
        uint256 remainingBalance = account.balance;
        account.balance = 0;
        account.isActive = false;
        
        // 转账剩余金额（这里简化处理，实际应该使用transfer函数）
        payable(msg.sender).transfer(remainingBalance);
    }
}