// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 安全的ETH接收演示合约
contract ReceiveDemo {
    
    // 状态变量
    address public owner;                          // 合约拥有者
    uint256 public maxDeposit;                    // 最大存款限额
    mapping(address => uint256) public deposits;   // 用户存款记录
    bool private locked;                           // 重入锁

    // 事件声明
    event Log(string func, address indexed sender, uint256 value, bytes data);
    event Withdrawal(address indexed to, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // 构造函数
    constructor() {
        owner = msg.sender;
        maxDeposit = 5 ether;  // 设置最大存款限额为5 ETH
    }

    // 防重入修饰器
    modifier nonReentrant() {
        require(!locked, "ReentrancyGuard: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    // 仅所有者修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // 接收ETH的函数
    receive() external payable {
        // 安全检查
        require(msg.value > 0, "Must send ETH");
        require(msg.value + deposits[msg.sender] <= maxDeposit, "Exceeds deposit limit");
        
        // 更新存款记录
        deposits[msg.sender] += msg.value;
        
        // 记录日志
        emit Log("receive", msg.sender, msg.value, "");
    }

    // 后备函数
    fallback() external payable {
        // 安全检查
        require(msg.value > 0, "Must send ETH");
        require(msg.value + deposits[msg.sender] <= maxDeposit, "Exceeds deposit limit");
        
        // 更新存款记录
        deposits[msg.sender] += msg.value;
        
        // 记录日志
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    // 提取ETH
    function withdraw(uint256 _amount) external nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        require(deposits[msg.sender] >= _amount, "Insufficient balance");

        // 更新状态
        deposits[msg.sender] -= _amount;

        // 发送ETH
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed");

        emit Withdrawal(msg.sender, _amount);
    }

    // 查询合约余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 查询用户存款
    function getDeposit(address _user) public view returns (uint256) {
        return deposits[_user];
    }

    // 更新最大存款限额（仅所有者）
    function setMaxDeposit(uint256 _maxDeposit) external onlyOwner {
        require(_maxDeposit > 0, "Invalid max deposit");
        maxDeposit = _maxDeposit;
    }

    // 转移所有权（仅所有者）
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // 紧急提款（仅所有者）
    function emergencyWithdraw() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed");
    }
}