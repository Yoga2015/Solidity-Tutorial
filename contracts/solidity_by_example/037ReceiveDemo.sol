// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract ReceiveDemo {
    event Log(string func, address sender, uint256 value, bytes data);

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }
}

// 定义了一个ReceiveExample合约，其中包含了receive函数和fallback函数。

// 当 ReceiveExample合约 接收到 未附加数据的以太币转账 时，receive函数 会被触发，并记录 发送者、转账金额 和 空数据（因为未附加数据）。

// 而当 合约 接收到 未匹配的函数调用 或 带有附加数据的以太币转账 时，fallback函数 会被触发，并记录相关信息。
