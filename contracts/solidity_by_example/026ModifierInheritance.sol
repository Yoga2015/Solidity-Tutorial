// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 基础访问控制合约
contract AccessControl {
  
    address public owner;    // 合约所有者地址
    
    mapping(address => bool) public admins;   // 管理员映射
   
    bool public paused;    // 合约状态
    
    // 事件声明
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event ContractPaused(address indexed pauser);
    event ContractUnpaused(address indexed unpauser);

    // 构造函数：设置合约部署者为所有者
    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;  // 所有者默认也是管理员
    }

    // 所有者权限检查 修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // 管理员权限检查 修饰器
    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admin can call this function");
        _;
    }

    // 合约未暂停检查 修饰器
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    // 合约已暂停检查 修饰器
    modifier whenPaused() {
        require(paused, "Contract is not paused");
        _;
    }
}

// 继承访问控制的功能合约
contract TokenManager is AccessControl {
    
    mapping(address => uint256) public balances;    // 代币余额映射
  
    uint256 public transferLimit;       // 最大转账限额
    
    // 事件声明
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event TransferLimitUpdated(uint256 oldLimit, uint256 newLimit);

    // 构造函数：设置初始转账限额
    constructor(uint256 _transferLimit) {
        transferLimit = _transferLimit;
    }

    // 转账金额检查 修饰器
    modifier checkTransferAmount(uint256 amount) {
        require(amount <= transferLimit, "Transfer amount exceeds limit");
        require(amount > 0, "Transfer amount must be positive");
        _;
    }

    // 余额检查 修饰器
    modifier hasSufficientBalance(address from, uint256 amount) {
        require(balances[from] >= amount, "Insufficient balance");
        _;
    }

    // 转账函数：组合使用多个修饰器
    function transfer(address to, uint256 amount) public 
        whenNotPaused 
        checkTransferAmount(amount)
        hasSufficientBalance(msg.sender, amount)
    {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    // 更新转账限额：仅管理员可调用
    function updateTransferLimit(uint256 newLimit) public 
        onlyAdmin 
        whenNotPaused 
    {
        emit TransferLimitUpdated(transferLimit, newLimit);
        transferLimit = newLimit;
    }

    // 暂停合约：仅所有者可调用
    function pause() public onlyOwner whenNotPaused {
        paused = true;
        emit ContractPaused(msg.sender);
    }

    // 恢复合约：仅所有者可调用
    function unpause() public onlyOwner whenPaused {
        paused = false;
        emit ContractUnpaused(msg.sender);
    }
}
