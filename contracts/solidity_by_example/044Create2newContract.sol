// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title 交易对合约
/// @notice 用于管理DEX中的代币交易对
contract Pair {
   
    address public factory;  // 记录创建该交易对的工厂合约地址
    address public token0;   // 交易对中第一个代币的地址
    address public token1;   // 交易对中第二个代币的地址

    /// @notice 构造函数，设置工厂合约地址
    /// @dev payable允许在部署时接收ETH
    constructor() payable {
        factory = msg.sender;  // 将部署者（工厂合约）地址存储
    }

    /// @notice 初始化交易对的代币地址
    /// @param _token0 第一个代币的地址
    /// @param _token1 第二个代币的地址
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "UniswapV2: FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
    }
}

// Pair合约 的 构造函数 是 payable的，这意味着 它可以接收以太币。然而，在这个构造函数中，并没有使用到payable特性。
// 构造函数的主要作用 是 将  factory状态变量 设置为 调用它的地址，即 工厂合约的地址。
// msg.sender 是 Solidity中 的 一个全局变量，它表示 当前交易的发送者。

// initialize() 函数 是一个 外部可见的 函数，用于 在Pair合约部署后 初始化 其状态。
// 它接受两个参数：_token0和_token1，分别代表 交易对中 的 两个代币的地址。
// 函数内部 使用 require语句 来确保 只有 工厂合约 可以调用 这个函数。
// 如果 调用者 不是 工厂合约，则交易会失败，并返回错误信息"UniswapV2: FORBIDDEN"。

/// @title CREATE2交易对工厂合约
/// @notice 使用CREATE2创建可预测地址的交易对
contract PairFactory2 {

    // 双重映射：tokenA地址 => tokenB地址 => pair地址
    mapping(address => mapping(address => address)) public getPair;

    // 所有已创建的交易对地址数组
    address[] public allPairs; // allPairs 地址数组，用于 存储 所有创建的 Pair合约的地址

    /// @notice 使用CREATE2创建新的交易对合约
    /// @param tokenA 第一个代币地址、tokenB 第二个代币地址
    /// @return pairAddr 新创建的交易对地址
    // 用于创建新的Pair合约实例。它接受两个参数：tokenA和tokenB，分别代表 要创建 交易对 的 两个代币的地址。函数 返回 新创建的Pair合约的地址。
    function createPair2(address tokenA,address tokenB) external returns (address pairAddr) {

        require(tokenA != tokenB, "Identical_ADDRESSES"); //  // 验证输入地址不相同

        // 对 代币地址 排序，确保相同的代币对生成相同的salt
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenA, tokenA); // 将tokenA和tokenB按大小排序

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));   // 使用排序后的地址生成salt

        // 使用CREATE2部署新合约
        // Pair 必须是一个已经定义好的合约，且在当前上下文中可见（例如，它可能是在同一个文件中定义的，或者通过import语句引入的）
        Pair pair = new Pair{salt: salt}(); // 用 create2 部署 新合约
        pair.initialize(tokenA, tokenB); // 初始化新合约

        pairAddr = address(pair);  // 记录新合约地址， 将 新创建的Pair合约的地址 赋值给 pairAddr变量

        allPairs.push(pairAddr); // 然后，将 这个地址 添加到 allPairs数组中

        // 记录双向映射关系
        getPair[tokenA][tokenB] = pairAddr; // 更新 getPair映射
        getPair[tokenB][tokenA] = pairAddr; // 更新 getPair映射
    }

    
    /// @notice 预测交易对合约地址
    /// @param tokenA 第一个代币地址，tokenB 第二个代币地址
    /// @return predictedAddress 预计的合约地址
    function calculateAddr(address tokenA,address tokenB) public view returns (address predictedAddress) {

        require(tokenA != tokenB, "IDENTICAL_ADDRESSES"); //避免tokenA和tokenB相同产生的冲突

        // 计算 用tokenA 和 tokenB地址 计算 salt， 对 代币地址 排序
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA); //将tokenA和tokenB按大小排序

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));   // 计算salt

        // 使用 CREATE2地址 计算 公式计算 
        predictedAddress = address(
            uint160(
                uint(
                    keccak256(
                        abi.encodePacked(
                           bytes1(0xff),           // CREATE2前缀
                            address(this),          // 当前合约地址
                            salt,                   // 由代币地址生成的salt
                            keccak256(type(Pair).creationCode)  // 合约字节码hash
                        )
                    )
                )
            )
        );
    }
}

// 工厂合约（PairFactory2） :
//     getPair 是 两个代币地址 到 币对地址的 map，方便根据 代币 找到 币对地址；
//     allPairs 是 币对地址的数组，存储了 所有币对 地址。
//     createPair2函数，使用CREATE2 根据 输入的两个代币地址 tokenA和tokenB 来创建 新的Pair合约。
//         其中 Pair pair = new Pair{salt: salt}(); 就是利用CREATE2创建合约的代码，非常简单，
//         而 salt 为 token1 和 token2 的 hash： bytes32 salt = keccak256(abi.encodePacked(token0, token1));
//     calculateAddr函数 用来 事先计算tokenA和tokenB将会生成的Pair地址。通过它，我们可以验证我们事先计算的地址 和 实际地址 是否相同。
