// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract FallbackFunction {
    // 1、定义 FallbackCalled 事件
    event FallbackCalled(address Sender, uint Value, bytes Data);

    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data);
    }
}

// fallback()函数  用于处理  未匹配的函数调用 或 带有附加数据 的 以太币转账。

// fallback()函数 会在 调用合约 不存在的函数 时 被 触发。
