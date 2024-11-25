// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Pair {
    address public factory; // 工厂合约地址
    address public token0; // 代币1
    address public token1; // 代币2

    // 构造函数 constructor 在部署时 将 factory 赋值为 工厂合约地址
    constructor() payable {
        factory = msg.sender;
    }

    // initialize函数 会由 工厂合约 在部署完成后 手动调用 以初始化 代币地址，将token0和token1更新为 币对中 两种代币 的 地址。
    // 在部署时 由 工厂 调用一次
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "UniswapV2: FORBIDDEN"); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }
}

// Pair合约 包含 ：

// 1、两个公开的地址变量 token0 和 token1，分别代表 交易对中 的 第一个代币的地址 和 第二个代币的地址。
// 一个公开的状态变量 factory，用于存储 创建这个Pair合约 的 工厂合约的地址。

// 2、Pair合约的构造函数是payable的，这意味着它可以接收以太币。然而，在这个构造函数中，并没有使用到payable特性。
// 构造函数的主要作用是将factory状态变量设置为调用它的地址，即工厂合约的地址。
// msg.sender是Solidity中的一个全局变量，它表示当前交易的发送者。

// 3、一个 initialize 构造函数 是 一个外部可见的函数，用于在Pair合约部署后初始化其状态。
// 它接受两个参数：_token0和_token1，分别代表交易对中的两个代币的地址。
// 函数内部 使用 require语句 来确保 只有 工厂合约 可以调用 这个函数。
// 如果 调用者 不是 工厂合约，则交易会失败，并返回错误信息"UniswapV2: FORBIDDEN"。
