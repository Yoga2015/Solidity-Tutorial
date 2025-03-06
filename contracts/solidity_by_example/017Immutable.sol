// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ImmutableTest {
    // 1、immutable 的 合法使用

    uint256 public immutable minValue = 18; // 合法：值类型

    uint256 public immutable maxValue; // 合法：值类型

    address public immutable owner; // 合法：值类型

    constructor(uint256 _maxValue, uint256 _minValue) {
        minValue = _minValue;

        maxValue = _maxValue;

        owner = msg.sender;
    }

    // 被  immutable 修饰的 变量  只能在 声明时初始化 或  在构造函数（constructor）中赋值，之后无法更改 ，不能在普通函数中赋值
    // function changeOwner(address newOwner) public {

    //      owner = newOwner;   // 编译报错：被immutable修饰的变量的值 ，仅可以 在构造函数中 赋值，之后不可更改。

    // }

    // function changeMaxValue(uint256 _maxValue2) public {

    //     maxValue = _maxValue2;  // 编译报错：被immutable修饰的变量的值 ，仅可以 在构造函数中 赋值，之后不可更改。

    // }

    // 2、immutable 的 非法使用

    // string public immutable name; // 非法：字符串

    // bytes public immutable data; // 非法：字节数组

    // uint256[] public immutable values; // 非法：动态大小的数组

    // mapping(address => uint256) public immutable balances; // 非法：映射

    //  // 非法：结构体
    // struct User {
    //     uint256 id;
    //     string name;
    // }

    // User public immutable user;

    // 被 immutable 修饰 的 变量 numb 只能在 构造函数中 修改，不能在 普通函数中 赋值
    // uint256 public immutable numb;

    // function mod() public {

    //     numb = 333;

    // }
}

// immutable 修饰符 在 Solidity 中 被用于 声明只读状态变量，

// 被immutable修饰 的 变量 只能在 声明时初始化 或  在构造函数（constructor）中赋值，之后无法更改。

//  immutable 的 应用场景 ：
// 1、需要 在 部署 时 动态赋值，但 合约生命周期内 不会改变 的 值（如 owner、router 地址）。
// 2、需要 减少 gas，但又不能使用 constant（因为 constant 变量必须在编译时确定）。

interface IRouter {
    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract SwapContract {
    address public immutable ROUTER;

    constructor(address _router) {
        ROUTER = _router; // 记录 Router 地址
    }

    function getRouter() public view returns (address) {
        return ROUTER;
    }
}
