// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract TransferEvent {
    // 定义 _balances 映射变量，记录 每个地址 的 持币数量
    mapping(address => uint256) public _balances;

    // 创建 Transfer 事件，记录 transfer 交易 的 转账地址，接收地址 和 转账数量
    // Transfer 事件 共记录了 3个变量 ：from 代币的 转账地址 ，to 代币的 接收地址 和 value  代币的 转账数量
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 定义 _transfer 函数，触发事件的函数, 执行 转账逻辑
    function _transfer(address from, address to, uint256 amount) external {
        _balances[from] = 10000; // 给 转账地址  一些 初始代币

        _balances[from] -= amount; // from 地址 减去 转账数量

        _balances[to] += amount; // to 地址 加上 转账数量

        emit Transfer(from, to, amount); // 释放 Transfer事件
    }
}

// 上面例子，每次用 _transfer函数 进行 转账操作的时候，都会释放 Transfer事件，并记录 相应的变量。

// Solidity 中 的 event（事件） 的 主要作用 是 记录 区块链上的活动，类似于 日志记录。
