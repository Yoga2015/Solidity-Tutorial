// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Constants {
    // 1、constant 的 合法使用

    uint256 public constant MAX_VALUE = 100; // 合法：值类型

    address public constant OWNER = 0x1234567890123456789012345678901234567890; // 合法：值类型

    string public constant NAME = "MyContract"; // 合法：字符串

    bytes32 public constant HASH = keccak256("MyContract"); // 合法：固定大小的字节数组

    // 2、constant 的 非法使用

    // uint256[] public constant VALUES = [1, 2, 3];      // 非法：动态大小的数组

    // mapping(address => uint256) public constant BALANCES;      // 非法：映射

    // 非法：结构体
    // struct User {
    //     uint256 id;
    //     string name;
    // }

    // User public constant USER = User(1, "Alice");

    // constant 变量 必须在 声明的时候 初始化，之后再也不能改变。尝试改变的话，编译不通过。
    uint256 constant Num = 10;

    uint public constant My_uint = 456;

    // function mod() public {      // 尝试改变的话，编译不通过。

    //     Num = 22;

    //     My_uint = 789;

    // }
}

// 在 Solidity 中，Constant 是 状态变量 的 修饰符，专用于 定义 状态变量
// constant 通常用于 定义 不会改变的 常量。
// constant 常量 的 命名 是 首字母 需大写的。
// constant 常量 必须 在 声明 时 并 初始化，之后 再也不能改变。
// 即：constant 变量的值 必须在 声明时 确定，且在 合约部署后 不可更改。尝试改变的话，会编译不通过。
