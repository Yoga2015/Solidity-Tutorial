// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Pair {
    address public factory; // 工厂合约地址
    address public token0; // 交易对中 的 第一个代币的地址
    address public token1; // 交易对中 的 第二个代币的地址

    // 构造函数 constructor 在部署时 将 factory 赋值为 工厂合约地址
    constructor() payable {
        factory = msg.sender;
    }

    // initialize函数 会由 工厂合约 在部署完成后， 手动调用 以 初始化 代币地址，将 token0 和 token1 更新为 币对中 两种代币 的 地址。
    // 在部署时 由 工厂 调用一次
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "UniswapV2: FORBIDDEN"); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }
}

// Pair合约 包含 ：

// 1、两个公开的地址变量 token0 和 token1，分别代表 交易对中 的 第一个代币的地址 和 第二个代币的地址。
//    一个公开的状态变量 factory，用于存储 创建这个Pair合约 的 工厂合约的地址。

// 2、Pair合约的构造函数是payable的，这意味着它可以接收以太币。然而，在这个构造函数中，并没有使用到payable特性。
//    构造函数 的 主要作用 是 将 factory状态变量 设置为 调用它的地址，即：工厂合约的地址。
//    msg.sender 是 Solidity中的一个全局变量，它表示 当前交易的发送者。

// 3、一个 initialize 函数 是 一个外部可见的函数，用于 在Pair合约部署后 初始化 其 状态。
//    initialize 函数 接受 两个参数：_token0 和 _token1，分别代表 交易对中 的 两个代币的地址。
//    initialize 函数内部 使用 require语句 来确保 只有 工厂合约 可以调用 这个函数，如果 调用者 不是 工厂合约，则交易会失败，并返回错误信息"UniswapV2: FORBIDDEN"。

contract PairFactory {
    // 用于 通过 两个代币的地址 来查找 对应的 Pair合约地址。键 是 两个代币的地址（tokenA和tokenB），值 是 Pair合约的地址。
    mapping(address => mapping(address => address)) public getPair;

    address[] public allPairs; // allPairs 是一个地址类型的数组，用于 存储 所有创建的 Pair合约的地址

    // 用于创建新的Pair合约实例。它接受两个参数：tokenA和tokenB，分别代表 要创建 交易对 的 两个代币的地址。函数 返回 新创建的Pair合约的地址。
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pairAddr) {
        // Pair 必须是一个已经定义好的合约，且在当前上下文中可见（例如，它可能是在同一个文件中定义的，或者通过import语句引入的）
        Pair pair = new Pair(); // 使用 new关键字 创建了 Pair合约 的 一个新实例。

        pair.initialize(tokenA, tokenB); // 调用 新合约的 initialize方法

        pairAddr = address(pair); // 将 新创建的Pair合约的地址 赋值给 pairAddr变量

        allPairs.push(pairAddr); // 然后，将 这个地址 添加到 allPairs数组中

        getPair[tokenA][tokenB] = pairAddr; // 更新 getPair映射

        getPair[tokenB][tokenA] = pairAddr; // 更新 getPair映射
    }
}

// PairFactory合约 是一个 在DEX中 用于 动态创建 和 管理 Pair合约实例 的 有用工具。通过 仔细设计 其 状态变量 和 函数逻辑，可以确保 合约的安全性、效率和可维护性。
