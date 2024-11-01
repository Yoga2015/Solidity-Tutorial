// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract ReceiveFunction {
    // 1、定义 Receive 事件
    event Receive(address Sender, uint Value);

    // 2、接收 ETH 时， 触发 Receive事件 来记录 合约接收到的以太币数量、发送者地址 等信息。
    receive() external payable {
        emit Receive(msg.sender, msg.value);

        // 处理没有数据的 ETH 转账
    }
}

// 在 receive() 函数 内部编写 更新合约的状态 的 逻辑，来处理 接收到 的 以太币ETH
contract SimpleReceive {
    // 1、定义 状态变量
    uint256 public totalReceived;

    // 2、接收 ETH 时，将 接收到的以太币数量 累加到 totalReceived变量 中
    receive() external payable {
        totalReceived += msg.value;

        // 处理没有数据的 ETH 转账
    }
}

// receive()函数 是 在合约收到 ETH转账 时 被调用的 函数。

// 定义 receive() 函数 的 合约地址 自动变为 payable，即：可以接受 以太币转账。

// receive()函数 用于处理 接收 以太币（ETH）的 转账。（处理  简单的 以太币转账）

// 可以在 receive() 函数 内部 编写逻辑 来处理 接收到的以太币，比如：更新合约的状态、记录日志 等。
