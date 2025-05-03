// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title 安全的Fallback演示合约
/// @notice 演示receive和fallback函数的使用区别和安全实现
contract FallbackFunction {

    address public owner;                          // 合约拥有者
    bool private locked;                           // 重入锁
    uint256 public totalReceived;                 // 总接收ETH数量
    mapping(address => uint256) public deposits;   // 用户存款记录
    
    // === 事件定义 ===
    // @param Sender: 调用者地址、value: 接收到的ETH数量、Data: 调用数据
    event FallbackCalled(address indexed Sender, uint256 Value, bytes Data);
    
    // @param Sender: 调用者地址、Value: 接收到的ETH数量
    event ReceiveCalled(address indexed Sender, uint256 Value);
    
    // @param user: 提款用户、amount: 提款金额
    event Withdrawn(address indexed user, uint256 amount);

    // === 构造函数 ===
    constructor() {
        owner = msg.sender;
    }

    // === 修饰器 ===
    // 防重入锁
    modifier nonReentrant() {
        require(!locked, "ReentrancyGuard: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    // 所有者检查
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // === 核心函数 ===
    // receive函数：处理纯ETH转账
    receive() external payable nonReentrant {
        require(msg.value > 0, "Must send ETH");
        
        // 更新状态
        deposits[msg.sender] += msg.value;
        totalReceived += msg.value;
        
        // 触发事件
        emit ReceiveCalled(msg.sender, msg.value);
    }

    // fallback函数：处理未知函数调用或带数据的ETH转账
    fallback() external payable nonReentrant {

        require(msg.value >= 0, "Invalid value");  // 允许0 ETH，因为可能是纯函数调用
        
        if(msg.value > 0) {
            // 如果发送了ETH，更新状态
            deposits[msg.sender] += msg.value;
            totalReceived += msg.value;
        }
        
        // 触发事件，记录调用数据
        emit FallbackCalled(msg.sender, msg.value, msg.data);
    }

    // === 业务函数 ===
    // 提取ETH
    // @param amount: 提取金额
    function withdraw(uint256 amount) external nonReentrant {
        require(amount > 0, "Invalid amount");
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        
        // 更新状态
        deposits[msg.sender] -= amount;
        
        // 发送ETH
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawn(msg.sender, amount);
    }

    // === 查询函数 ===
    // 查询合约余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // 查询用户存款
    // @param user: 用户地址
    function getDeposit(address user) public view returns (uint256) {
        return deposits[user];
    }

    // === 管理函数 ===
    // 紧急提款（仅所有者）
    function emergencyWithdraw() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed");
    }
}

// receive 和 fallback 对比：

// receive: 仅处理纯ETH转账（msg.data为空）

// fallback: 处理未知函数调用或带数据的ETH转账


// 使用场景
// - receive: 简单ETH接收 ，无法处理数据
// - fallback: 复杂交互和后备处理，可以访问msg.data
