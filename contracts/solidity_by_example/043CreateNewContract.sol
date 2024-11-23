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

// Pair合约 包含 两个公开的地址变量 token0 和 token1，分别代表 两个代币的地址。

// 此外，它还有一个factory变量，用于存储 工厂合约的地址。

// 在 构造函数 中，它会将 工厂合约的地址 设置为 msg.sender，并在 initialize函数中 设置 token0 和 token1。
