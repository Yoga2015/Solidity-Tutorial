// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Pair {
    address public factory; // 工厂合约的地址
    address public token0; // 代表 交易对中 的 第一个代币的地址
    address public token1; // 代表 交易对中 的 第二个代币的地址

    // 构造函数 constructor 在部署时 将 factory  赋值为 工厂合约地址
    constructor() payable {
        factory = msg.sender;
    }

    // initialize函数 会在 Pair合约 创建的时候 被 工厂合约 调用一次，将token0和token1更新为币对中两种代币的地址。
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "UniswapV2: FORBIDDEN"); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }
}

// Pair合约 包含 ：

// Pair合约 的 构造函数 是 payable的，这意味着它可以接收以太币。然而，在这个构造函数中，并没有使用到payable特性。
// 构造函数的主要作用是将factory状态变量设置为调用它的地址，即工厂合约的地址。
// msg.sender是Solidity中的一个全局变量，它表示当前交易的发送者。

// 3、一个 initialize 构造函数 是 一个外部可见的函数，用于在Pair合约部署后初始化其状态。
// 它接受两个参数：_token0和_token1，分别代表交易对中的两个代币的地址。
// 函数内部 使用 require语句 来确保 只有 工厂合约 可以调用 这个函数。
// 如果 调用者 不是 工厂合约，则交易会失败，并返回错误信息"UniswapV2: FORBIDDEN"。

contract PairFactory2 {
    // 用于 通过 两个代币的地址 来查找 对应的 Pair合约地址。键 是 两个代币的地址（tokenA和tokenB），值 是 Pair合约的地址。
    mapping(address => mapping(address => address)) public getPair;

    address[] public allPairs; // allPairs 地址数组，用于 存储 所有创建的 Pair合约的地址

    // 用于创建新的Pair合约实例。它接受两个参数：tokenA和tokenB，分别代表 要创建 交易对 的 两个代币的地址。函数 返回 新创建的Pair合约的地址。
    function createPair2(
        address tokenA,
        address tokenB
    ) external returns (address pairAddr) {
        require(tokenA != tokenB, "Identical_ADDRESSES"); // 避免tokenA 和 tokenB 相同产生的冲突

        // 用 tokenA 和 tokenB 地址计算 salt
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenA, tokenA); // 将tokenA和tokenB按大小排序

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        // Pair 必须是一个已经定义好的合约，且在当前上下文中可见（例如，它可能是在同一个文件中定义的，或者通过import语句引入的）
        Pair pair = new Pair{salt: salt}(); // 用 create2 部署 新合约

        pair.initialize(tokenA, tokenB); // 调用 新合约 的 initialize方法

        // 更新 地址 map
        pairAddr = address(pair); // 将 新创建的Pair合约的地址 赋值给 pairAddr变量

        allPairs.push(pairAddr); // 然后，将 这个地址 添加到 allPairs数组中

        getPair[tokenA][tokenB] = pairAddr; // 更新 getPair映射

        getPair[tokenB][tokenA] = pairAddr; // 更新 getPair映射
    }

    // 提前计算 pair合约地址
    function calculateAddr(
        address tokenA,
        address tokenB
    ) public view returns (address predictedAddress) {
        require(tokenA != tokenB, "IDENTICAL_ADDRESSES"); //避免tokenA和tokenB相同产生的冲突

        // 计算 用tokenA 和 tokenB地址 计算 salt
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA); //将tokenA和tokenB按大小排序

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        // 计算 合约地址方法 hash()
        predictedAddress = address(
            uint160(
                uint(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            salt,
                            keccak256(type(Pair).creationCode)
                        )
                    )
                )
            )
        );
    }
}

// 工厂合约（PairFactory2） :

// getPair 是 两个代币地址 到 币对地址的 map，方便根据 代币 找到 币对地址；

// allPairs 是 币对地址的数组，存储了 所有币对 地址。

// createPair2函数，使用CREATE2 根据 输入的两个代币地址 tokenA和tokenB 来创建 新的Pair合约。
// 其中 Pair pair = new Pair{salt: salt}(); 就是利用CREATE2创建合约的代码，非常简单，
// 而 salt 为 token1 和 token2 的 hash： bytes32 salt = keccak256(abi.encodePacked(token0, token1));

// calculateAddr函数 用来 事先计算tokenA和tokenB将会生成的Pair地址。通过它，我们可以验证我们事先计算的地址 和 实际地址 是否相同。
