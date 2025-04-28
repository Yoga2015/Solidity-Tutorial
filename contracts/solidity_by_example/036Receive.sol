// SPDX-License-Identifier: MIT    
pragma solidity ^0.8.13; 

// 智能钱包合约：用于ETH的存储和管理
contract SmartWallet {

    // @param sender: 发送ETH的地址（已索引，可用于事件过滤）、amount: 发送的ETH数量（单位：wei）、message: 事件描述信息
    event Received(address indexed sender, uint256 amount, string message);
    // @param to: 接收ETH的地址（已索引，可用于事件过滤）、amount: 接收的ETH数量（单位：wei）、message: 事件描述信息
    event Withdrew(address indexed to, uint256 amount, string message);
    
    address public owner;  // 状态变量：合约拥有者地址
    
    // 状态变量：用户余额映射
    // @key: 用户地址、@value: 该地址存储的ETH数量（单位：wei）
    mapping(address => uint256) public balances;
    
    // 构造函数：部署合约时调用
    // @effect: 将合约部署者设置为合约拥有者
    constructor() {
        owner = msg.sender;  // msg.sender 为合约部署者地址
    }
    
    // 修饰器：限制函数只能由合约拥有者调用
    // @effect: 检查调用者是否为合约拥有者
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");  // 如果不是合约拥有者，抛出异常
        _;  // 继续执行被修饰的函数
    }
    
    // receive函数：处理直接ETH转账  （当合约接收纯ETH转账时自动调用）
    receive() external payable {

        balances[msg.sender] += msg.value;  // msg.value 为接收到的 ETH数量
        
        // 记录转账信息
        emit Received(
            msg.sender,      // 发送者地址
            msg.value,       // 接收到的ETH数量
            "ETH received via receive()"  // 接收方式说明
        );
    }
    
    // fallback函数：处理带有数据的ETH转账   （当调用不存在的函数或发送数据时触发）
    fallback() external payable {

        // 更新合约状态
        balances[msg.sender] += msg.value;  // msg.value 为接收到的 ETH数量
        
        emit Received(
            msg.sender,
            msg.value,
            "ETH received via fallback()"
        );
    }
    
    // 查询合约总ETH余额
    // @return: 返回合约当前的ETH总余额（单位：wei）
    function getBalance() public view returns (uint256) {
        return address(this).balance;  // this 表示当前合约
    }
    
    // 查询 指定地址 的 存款余额
    // @param _address: 要查询的用户地址
    // @return: 返回指定地址的ETH余额（单位：wei）
    function getAddressBalance(address _address) public view returns (uint256) {
        return balances[_address];
    }
    
    // 提取 ETH函数 （任何用户都可以提取自己的存款）
    // @param _amount: 要提取的ETH数量（单位：wei）
    function withdraw(uint256 _amount) public {

        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        balances[msg.sender] -= _amount;  // 先 更新状态 防止 重入攻击
        
        // 使用 call方法 发送ETH ， 将 当前调用者的地址 （普通地址） 转换为 可接收 ETH 的地址类型
        (bool success, ) = payable(msg.sender).call{value: _amount}("");    // "" 代表 空字符串表示不附带任何调用数据，纯转账操作
        require(success, "Withdrawal failed");
        
        emit Withdrew(msg.sender, _amount, "ETH withdrawn");  
    }
    
    // 紧急提款函数 ，这个函数 只有合约拥有者 可以调用
    // @effect: 提取 合约中的所有ETH
    function emergencyWithdraw() public onlyOwner {

        uint256 balance = address(this).balance;  // 获取 合约当前的 ETH总余额
        require(balance > 0, "No ETH to withdraw");  // 如果没有ETH，抛出异常
        
        (bool success, ) = payable(owner).call{value: balance}("");  // 发送ETH 到 合约拥有者地址
        require(success, "Emergency withdrawal failed");
        
        emit Withdrew(owner, balance, "Emergency withdrawal");
    }
}

// 测试合约：用于测试 ETH转账功能
contract TestWallet {

    // 发送ETH到指定合约
    // @param _wallet: 接收ETH的合约地址
    function sendEth(address payable _wallet) public payable {

        (bool success, ) = _wallet.call{value: msg.value}("");  // msg.value 为发送的ETH数量

        require(success, "Failed to send ETH");    // 如果发送失败，抛出异常
    }
    
    // 测试用receive函数
    receive() external payable {}
}


// receive 函数 是 Solidity 智能合约 接收 ETH 的 标准入口，通过 它 可以安全地处理转账、更新合约的状态 和 触发事件记录日志，是 构建去中心化金融应用 的 重要组成部分。

// 当 合约 接收到 纯 ETH 转账 且 无附加数据 时， 就会 触发 receive() 函数。

// 当 一个合约 中 定义了 receive() 函数，那 该合约 的 合约地址 自动变为  payable，即：可接受 以太币转账。

// receive()函数 用于处理 接收 以太币（ETH）的 转账。（处理  简单的 以太币转账）

// 可以在 receive() 函数 内部 编写逻辑 来处理 接收到的以太币，比如：更新合约的状态、记录日志 等。


