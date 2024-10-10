// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ImmutableTest {
    // coding convention
    // 变量 前 加了 immutable 修饰符 说明 它 只能被 constructor 这个构造函数 修改，然后 再也不能被修改了
    address public immutable MY_address; // 仅 声明 了，但在 构造函数中 初始化（赋值）

    uint public immutable numb;

    // constructor 是的指 合约部署 时 跟着 初始化 的 一个函数
    constructor() {
        MY_address = msg.sender; // 在 构造函数中 初始化（赋值）

        numb = 200; // 在 构造函数中 初始化（赋值）
    }

    // TypeError: Immutable variables can only be initialized inline or assigned directly in the constructor.
    // function mod() public {

    //     numb = 333;

    // }
}

// 被 immutable 修饰 的 变量 不仅可以在  声明时 初始化  ，还可以在 构造函数中 初始化，但之后不能改变，因此 比 constant 更加灵活。
