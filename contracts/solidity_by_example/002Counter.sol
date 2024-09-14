// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;     // 声明 源文件 所使用 的 Solidity 版本

//  定义了一个名为 Counter 的 智能合约
contract Counter{

    // 声明了 一个 对外公开的 uint类型的 状态变量count。 （uint ：unsigned integer 无符号整数类型）
    uint public count;  

    // 定义了一个公开的 被标记为 view 的 函数 get，它返回一个无符号整数（uint），即当前count的值。 （view 关键字 表示 这个函数 不会修改 合约的状态（即不会改变任何 状态变量的值））
    function get() public view returns (uint){
        return count;
    }

    // 定义了一个 公开的 函数increment，用于将count的值增加1。这个函数没有返回值，因为它直接修改了合约的状态。
    function increment() public {
        count += 1;
    }

    // 定义了一个 公开的 函数decrement，用于将count的值减少1。与increment函数类似，这个函数也直接修改了合约的状态，并且没有返回值。
    function decrement() public {
        count -= 1;
    }

}

// 这个 Counter 智能合约 提供了 三个功能：读取当前计数值（get）、增加计数值（increment）、减少计数值（decrement）。