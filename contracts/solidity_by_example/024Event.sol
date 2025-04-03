// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract TransferEvent {

    // 定义 _balances 映射变量，记录 每个地址 的 持币数量
    mapping(address => uint256) public _balances;

    // 转账事件 ，创建 Transfer 事件，记录 transfer 交易 的 转账地址，接收地址 和 转账数量
    // Transfer 事件 共记录了 3个变量 ：from 代币的 转账地址 ，to 代币的 接收地址 和 value  代币的 转账数量
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 余额更新事件
    event BalanceUpdated(address indexed account, uint256 newBalance);

    // 定义 _transfer 函数，触发事件的函数, 执行 转账逻辑
    function _transfer(address from, address to, uint256 amount) external {

        require(from != address(0), "Invalid sender"); // 检查 转账地址 是否为空
        require(to != address(0), "Invalid recipient"); // 检查 接收地址 是否为空
        require(amount > 0, "Invalid amount");     // 检查 转账数量 是否为 0

        _balances[from] = 10000;  // 给 from 地址 一些 初始代币
        require(_balances[from] >= amount, "Insufficient balance"); // 检查 转账地址 余额是否足够

        _balances[from] -= amount; // from 地址 减去 转账数量 

        _balances[to] += amount; // to 地址 加上 转账数量

        emit Transfer(from, to, amount); // 释放 Transfer事件
        emit BalanceUpdated(from, _balances[from]); // 释放 BalanceUpdated事件
        emit BalanceUpdated(to, _balances[to]);  // 释放 BalanceUpdated事件
    }
}

// 上面例子，每次用 _transfer函数 进行 转账操作的时候，都会释放 Transfer事件，并记录 相应的变量。

// Solidity 中 的 event（事件） 的 主要作用 是 记录 区块链上的活动，类似于 日志记录。

// 复杂事件示例
contract MyEvent {
    
    struct MyStruct {
        uint id;
        string name;
        uint timestamp;
    }
    
    // 基础事件
    event SimpleEvent(string message);
    
    // 带索引的事件
    event IndexedEvent(
        uint indexed id,
        address indexed user,
        string message
    );
    
    // 复杂数据结构事件
    event ComplexEvent(
        uint indexed id,
        bool flag,
        address indexed user,
        bytes32 data,
        uint[] array,
        MyStruct myStruct
    );
    
    // 触发简单事件
    function emitSimpleEvent(string memory message) public {
        emit SimpleEvent(message);
    }
    
    // 触发带索引的事件
    function emitIndexedEvent(uint id, string memory message) public {
        emit IndexedEvent(id, msg.sender, message);
    }
    
    // 触发复杂事件
    function emitComplexEvent(uint id,bool flag,bytes32 data,uint[] memory array) public {

        MyStruct memory myStruct = MyStruct({
            id: id,
            name: "Example",
            timestamp: block.timestamp
        });
        
        emit ComplexEvent(
            id,
            flag,
            msg.sender,
            data,
            array,
            myStruct
        );

    }
}

// MyEvent 事件 接受了 六个参数：
// 一个 uint 类型的 id ，一个 bool 类型的 flag ，一个 address 类型的 user ，
// 一个 bytes32 类型的 data ，一个 uint 数组 array ，以及一个 MyStruct 类型的 myStruct 。
// id 参数被标记为 indexed ，这意味着我们可以通过 id 来过滤 MyEvent 事件的日志。
