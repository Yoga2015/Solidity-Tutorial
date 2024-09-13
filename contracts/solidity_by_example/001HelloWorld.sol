// SPDX-License-Identifier: MIT    // 这行 是 注释，说明代码所使用的软件许可（license），这里使用的是 MIT 许可。

pragma solidity ^0.8.13;    // 这行代码 表示 源文件将不允许小于 0.8.13 版本 或 大于等于 0.9.0 的编译器编译。  Solidity 语句以分号（;）结尾。

// 创建合约（contract），并声明 合约名 为 HelloWeb3。
contract HelloWeb3{

    // 这行代码 是 合约内容，声明了 一个 对外公开的 string 类型 的 状态变量 geet，并赋值为 "Hello Web3!"。
    string public geet = 'hello Web3!';

}

