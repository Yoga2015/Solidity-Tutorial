// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 检查 调用者 地址
contract OwnerCheck {
    address owner; // 定义 address 类型 的 owner地址

    constructor() {
        owner = msg.sender; // 初始化时，将 合约 的 创建者 设为 所有者
    }

    // onlyOwner 修饰符， 用来检查 调用者 是否是 合约的所有者
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is  not the owner"); // 检查 调用者 是否为 owner 地址

        _; // 调用函数体，即： 继续执行 被这个修饰符 修饰的函数 的 剩余部分
    }

    // 只有 所有者 才能调用的 函数
    function updateSomething() public onlyOwner {
        // 函数的实现...
    }
}
