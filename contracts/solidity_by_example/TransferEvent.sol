// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13; 

contract TransferEvent {
    
     // 声明一个公开的 余额映射，用于 存储 每个地址的余额 。address是键（账户地址），uint256是值（账户余额）
    mapping(address => uint256) public _balances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    // 声明一个Transfer事件，用于 记录 转账信息
    // indexed 关键字 允许我们之后通过 from 和 to地址 来过滤 事件
    // 事件参数：from（转出地址），to（转入地址），value（转账金额）

    // 构造函数：初始化合约
    constructor() {
        // 部署合约时不做任何初始化
    }

    // 存款函数：允许用户向合约存入ETH （允许用户存入资金）。  没有参数：用户发送交易时直接附带ETH即可
    function deposit() external payable {

         // 更新用户余额 ： msg.sender：交易发送者的地址 、msg.value：交易附带的ETH数量（单位：wei）
        _balances[msg.sender] += msg.value;   // 将用户发送的ETH金额添加到其余额中

        // 触发转账事件，记录存款操作 
        // address(0)：零地址，表示从"无"转入，通常用于表示存款操作 、msg.sender：接收地址，即存款用户的地址 、msg.value：存款金额
        emit Transfer(address(0), msg.sender, msg.value);  
       
    }

    // 转账函数：在账户间转移资金，其接收三个参数：from：转出地址 ，to：转入地址，amount：转账金额
    function executeTransfer(address from, address to, uint256 amount) external {

        // 检查参数有效性
        require(from != address(0), "Invalid from address");
        require(to != address(0), "Invalid to address");
        require(amount > 0, "Amount must be positive");
        
        require(_balances[from] >= amount, "Insufficient balance");      // 检查余额充足
               
        _balances[from] -= amount;     // 更新余额
        _balances[to] += amount;
             
        emit Transfer(from, to, amount);    // 触发转账事件
    }
    
    // 查询余额函数
    function getBalance(address account) external view returns (uint256) {
        return _balances[account];
    }
    
    // 提款函数：允许用户提取资金
    function withdraw(uint256 amount) external {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        
        _balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        
        emit Transfer(msg.sender, address(0), amount);    // 触发转账事件
    }
}
