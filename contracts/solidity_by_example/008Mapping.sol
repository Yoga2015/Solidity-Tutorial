// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract MappingDemo {

    // 创建（声明） 映射 的 语法为 mapping(KeyType => ValueType)，其中 KeyType 和 ValueType 分别是 Key 和 Value 的 变量类型。

    mapping(uint => address) public idToAddress; // 定义一个mapping 来存储  

    mapping(address => address) public swapPair; // 币对的映射，将 address类型  映射到 address类型

    // 规则1：映射 的 映射键_KeyType 只能选择 Solidity 的 基本类型、用户定义 的 值类型、契约类型 或 枚举 作为 映射键，
            //  不能用自定义的结构体 作为 映射键，否则会编译错误

    // 编译错误：下面例子会报错，因为 KeyType 使用了 我们 自定义 的 结构体：
    struct Student {
        uint256 id;
        uint256 score;
    }
    // mapping(Student => uint) public myMap;  // TypeError: Only elementary types, user defined value types, contract types or enums are allowed as mapping keys.


    // 规则2：给 映射 新增 键值对 的 语法为 _Var[_Key] = _Value，其中 _Var 是 映射变量名，_Key 和_Value 对应新增的键值对。
    function writeMap(uint _Key, address _Value) public {

        idToAddress[_Key] = _Value;
    }

}

// mapping 映射类型 是 一种 类似于 哈希表 的 数据结构，用于 存储 和 检索 键值对（Key-Value pairs）。

// 使用 mapping 来 管理 和 操作 数据集合，但 mapping 不可遍历、不可比较。

// 在 智能合约 中 如何 高效地 存储 和 检索 数据？

// 通过 键值对 的方式，mapping 允许 开发者 通过 键（Key）来查询 对应的值（Value）。

// 比如：通过 一个人 的 id 来查询 他的钱包地址，这在处理 用户信息、权限管理、资源分配 等场景中 尤为重要。

// 下面是一个简单的余额追踪器合约，就像一个简单的银行账户系统：
contract BalanceTracker {
    // 定义事件，用于记录重要操作
    event BalanceUpdated(address indexed user, uint256 oldBalance, uint256 newBalance);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // 合约拥有者
    address public owner;
    
    // 定义一个 mapping 来存储 地址 到 余额 的 映射
    mapping(address => uint256) public balances;

    // 构造函数，设置合约部署者为拥有者
    constructor() {
        owner = msg.sender;
    }

    // 修饰器：只有合约拥有者可以调用
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // 修饰器：检查余额是否足够
    modifier hasSufficientBalance(uint256 amount) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        _;
    }

    // 更新余额（只有合约拥有者可以直接设置余额）
    function updateBalance(address user, uint256 newBalance) public onlyOwner {
        uint256 oldBalance = balances[user];
        balances[user] = newBalance;
        emit BalanceUpdated(user, oldBalance, newBalance);
    }

    // 存款功能
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        uint256 oldBalance = balances[msg.sender];
        balances[msg.sender] += msg.value;
        emit BalanceUpdated(msg.sender, oldBalance, balances[msg.sender]);
    }

    // 转账功能
    function transfer(address to, uint256 amount) public hasSufficientBalance(amount) {
        require(to != address(0), "Cannot transfer to zero address");
        require(to != msg.sender, "Cannot transfer to self");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
    }

    // 获取余额
    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    // 获取自己的余额
    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // 重置余额（只有合约拥有者可以重置他人余额）
    function resetBalance(address user) public onlyOwner {
        uint256 oldBalance = balances[user];
        delete balances[user];
        emit BalanceUpdated(user, oldBalance, 0);
    }

    // 允许用户重置自己的余额
    function resetMyBalance() public {
        uint256 oldBalance = balances[msg.sender];
        delete balances[msg.sender];
        emit BalanceUpdated(msg.sender, oldBalance, 0);
    }

    // 获取合约余额
    function getContractBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // 允许合约拥有者提取合约中的以太币
    function withdraw(uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient contract balance");
        payable(owner).transfer(amount);
    }
}


