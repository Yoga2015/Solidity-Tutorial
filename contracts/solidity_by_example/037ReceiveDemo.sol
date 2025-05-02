// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 安全的ETH接收演示合约
contract ReceiveDemo {
  
    address public owner;                          // 存储合约拥有者地址
    uint256 public maxDeposit;                    // 单个用户最大存款限额
    mapping(address => uint256) public deposits;   // 记录每个地址的存款金额
    bool private locked;                           // 防重入攻击的锁

    // === 事件定义 ===
    // @param func: 触发事件的函数名、sender: 发送者地址（已索引用于事件过滤）、value: 交易金额（单位：wei）、 data: 调用数据
    event Log(string func, address indexed sender, uint256 value, bytes data);
    
    // @param to: 提款接收地址、amount: 提款金额
    event Withdrawal(address indexed to, uint256 amount);
    
    // @param previousOwner: 前任所有者、newOwner: 新任所有者
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;         // 设置合约部署者为所有者
        maxDeposit = 5 ether;       // 设置最大存款额为5 ETH
    }

    modifier nonReentrant() {       // 防重入修饰器
        require(!locked, "ReentrancyGuard: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    modifier onlyOwner() {         // 所有者权限检查
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // === 核心函数 ===
    // 接收 纯ETH转账 的 函数
    receive() external payable {
        require(msg.value > 0, "Must send ETH");
        require(msg.value + deposits[msg.sender] <= maxDeposit, "Exceeds deposit limit");
        deposits[msg.sender] += msg.value;
        emit Log("receive", msg.sender, msg.value, "");
    }

    // 处理 带数据的 ETH转账
    fallback() external payable {
        require(msg.value > 0, "Must send ETH");
        require(msg.value + deposits[msg.sender] <= maxDeposit, "Exceeds deposit limit");
        deposits[msg.sender] += msg.value;
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    // 提取ETH函数
    // @param _amount: 提取金额（单位：wei）
    function withdraw(uint256 _amount) external nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        require(deposits[msg.sender] >= _amount, "Insufficient balance");
        deposits[msg.sender] -= _amount;
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed");
        emit Withdrawal(msg.sender, _amount);
    }

    // === 查询函数 ===
    // 查询合约ETH余额
    // @return: 返回合约的总ETH余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 查询指定地址的存款余额
    // @param _user: 要查询的用户地址
    // @return: 返回指定地址的存款余额
    function getDeposit(address _user) public view returns (uint256) {
        return deposits[_user];
    }

    // === 管理函数 ===
    // 更新最大存款限额
    // @param _maxDeposit: 新的最大存款限额（单位：wei）
    function setMaxDeposit(uint256 _maxDeposit) external onlyOwner {
        require(_maxDeposit > 0, "Invalid max deposit");
        maxDeposit = _maxDeposit;
    }

    // 转移合约所有权
    // @param newOwner: 新的所有者地址
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // 紧急提款函数
    function emergencyWithdraw() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed");
    }
}