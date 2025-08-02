// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13; 

contract ETHVaultManager {

    address public owner;                // 设置合约所有者（owner）
    bool public paused;                  // 可暂停机制（paused）
    uint256 public minDeposit;           // 最小存款金额
    uint256 public maxWithdrawal;        // 最大提款金额
 
     // 声明一个公开的 余额映射，用于 存储 每个地址的余额 。address是键（账户地址），uint256是值（账户余额）
    mapping(address => uint256) public _balances;

    // 声明一个Transfer事件，用于 记录 转账信息 ，事件参数：from（转出地址），to（转入地址），value（转账金额）
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 使用indexed关键字优化事件过滤 （indexed 关键字 允许我们之后 通过 from 和 to地址 来过滤 事件 ）

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);    // 记录所有权转移  
    event ContractPaused(bool status);                                                      // 记录合约状态变更  
    event LimitsUpdated(uint256 newMinDeposit, uint256 newMaxWithdrawal);                   // 记录限额更新

    // 访问控制 ：修饰符 onlyOwner：用于 检查 函数调用者 是否满足某些条件 。 只有合约所有者 才能调用 某些函数
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");  // 检查 调用者 是否是 合约所有者
        _;
    }

    // 暂停机制： 修饰符 whenNotPaused ：用于 检查 合约是否处于暂停状态 。 只有在合约未暂停时 才能调用 某些函数
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");  // 检查合约是否处于暂停状态
        _;
    }


    // payable 允许在部署时向合约发送ETH，这对于需要初始资金池的合约很有用
    constructor() payable{
        
        // 可以选择性添加： 1. 设置合约拥有者、 2. 初始化一些状态变量 3、进行一些初始检查
        owner = msg.sender;                    // 设置合约所有者为部署合约的账户
        minDeposit = 0.01 ether;               // 设置最小存款金额为0.01 ETH
        maxWithdrawal = 10 ether;              // 设置最大提款金额为10 ETH
        paused = false;                        // 初始化合约暂停状态为false
    }


    // 内部存款函数：用于处理存款逻辑
    function _deposit(address sender, uint256 amount) private {

        require(msg.value >= minDeposit, "Deposit amount too small");   // 检查存款金额是否满足最小存款要求

         // 更新用户余额 ： msg.sender：交易发送者的地址 、msg.value：交易附带的ETH数量（单位：wei）
        _balances[msg.sender] += msg.value;   // 将用户发送的ETH金额添加到其余额中

        // 触发转账事件，记录存款操作 
        // address(0)：零地址，表示从"无"转入，通常用于表示存款操作 。sender：接收地址，即存款用户的地址 。 amount：存款金额
        emit Transfer(address(0), sender, amount);  
    }

    // 存款函数：允许用户向合约存入ETH （允许用户存入资金）。  没有参数：用户发送交易时直接附带ETH即可
    function deposit() external payable whenNotPaused {
  
       _deposit(msg.sender, msg.value);     // 调用 内部存款函数 处理存款逻辑   
    }

    // 转账函数：在账户间转移资金，其接收三个参数：from：转出地址 ，to：转入地址，amount：转账金额
    function executeTransfer(address from, address to, uint256 amount) external whenNotPaused {

        // 检查参数有效性 
        require(from != address(0) && to != address(0), "Invalid from address");   // 确保 转出地址、转入地址 不是 零地址
        require(amount > 0, "Amount must be positive");    // 确保转账金额大于0
        
        require(_balances[from] >= amount, "Insufficient balance");  // 检查 转出账户 是否有足够余额 进行 转账
               
        // 执行转账操作 
        _balances[from] -= amount;     // 从 转出账户 减少 余额
        _balances[to] += amount;       // 向 转入账户 增加 余额
             
        emit Transfer(from, to, amount);     // 发出转账事件，记录这笔交易
    }
    
    // 提款函数：允许用户提取资金 ，其接收一个参数amount（提款金额） ，用户想要提取的ETH数量（单位：wei）
    function withdraw(uint256 amount) external whenNotPaused {

        require(amount <= maxWithdrawal, "Exceeds maximum withdrawal limit"); // 检查提款金额是否超过最大提款限制

        // 检查余额充足性，如果余额不足，交易会被回滚。 msg.sender：交易发送者的地址（即要提款的用户）
        require(_balances[msg.sender] >= amount, "Insufficient balance");  
        
        // 执行提款操作 ：从用户的余额中扣除提款金额，这一步必须在实际转账之前执行，遵循"检查-生效-交互"模式
        _balances[msg.sender] -= amount;            // 减少用户在合约中的余额

        // 执行实际的ETH转账操作。 payable(msg.sender)：将用户地址转换为可接收ETH的地址。 transfer()：将ETH发送到指定地址
        (bool success, ) = payable(msg.sender).call{value: amount}("");     // 使用 call 替代 transfer 进行 ETH 转账 （更安全的转账方式）
        require(success, "Transfer failed");   // 如果转账失败，整个交易会被回滚
        
        // 触发转账事件，记录提款操作 （msg.sender：提款人地址、address(0)：表示转出到外部（提款）、amount：提款金额）
        emit Transfer(msg.sender, address(0), amount);    
    }

    // 所有权转移：只有 合约所有者 可以调用此函数 ，允许 合约所有者 进行一些管理操作，如更改合约状态、设置限制等 
    function transferOwnership(address newOwner) external onlyOwner {  

        require(newOwner != address(0), "New owner is the zero address");  // 检查 新的所有者 是否是 零地址
        emit OwnershipTransferred(owner, newOwner);  // 触发 所有权转移 事件
        owner = newOwner;    // 更新合约所有者
    }

    // 合约暂停/恢复 （只有合约所有者可以调用此函数）
    function setPaused(bool _paused) external onlyOwner {     
        
        paused = _paused;  // 更新 合约暂停状态
        emit ContractPaused(_paused);  // 触发 合约暂停事件
    }

    // 存取款限额 ：设置 新的最小存款金额 和 最大提款金额 （只有合约所有者可以调用此函数）
    function setLimits(uint256 _minDeposit, uint256 _maxWithdrawal) external onlyOwner {     

        require(_minDeposit > 0 && _maxWithdrawal > _minDeposit, "Invalid limits");     // 检查 新的限制 是否有效

        minDeposit = _minDeposit;     // 更新最小存款金额
        maxWithdrawal = _maxWithdrawal;   // 更新最大提款金额

        emit LimitsUpdated(_minDeposit, _maxWithdrawal);  // 触发 限制更新事件
    }

    // 紧急提款 （只有合约所有者可以调用此函数）
    function emergencyWithdraw() external onlyOwner {

        uint256 balance = address(this).balance;   // 获取合约的余额
        require(balance > 0, "No balance to withdraw");    // 检查 合约 是否有足够的余额 进行提款
        
        (bool success, ) = payable(owner).call{value: balance}("");  // 执行实际的ETH转账操作
        require(success, "Transfer failed");   // 如果转账失败，整个交易会被回滚
        
        emit Transfer(address(this), owner, balance);    // 触发 转账事件，记录紧急提款操作
    }

    // 查看 指定地址的余额
    function getBalance(address account) external view returns (uint256) {
        return _balances[account];   // 返回指定地址的余额
    }

    // 查看合约的余额
    function getContractBalance() external view returns (uint256) {  
        return address(this).balance;       // 返回合约的余额
    }

    // 处理直接转账
    receive() external payable {

        // 如果 收到的ETH金额 大于等于 最小存款金额，则调用deposit函数
        if (msg.value >= minDeposit) {   
            _deposit(msg.sender, msg.value);     // 调用 内部存款函数 处理存款逻辑
        } else {
            // 如果金额太小，退回ETH
            (bool success, ) = payable(msg.sender).call{value: msg.value}("");   // 执行实际的ETH转账操作
            require(success, "ETH return failed");   // 如果转账失败，整个交易会被回滚
            revert("Amount less than minimum deposit");    // 回滚交易，以防止无效状态   
        }

    }

    // 处理未知调用
    fallback() external payable {
        revert("Invalid operation");   // 回滚交易，以防止无效操作
    }
}
