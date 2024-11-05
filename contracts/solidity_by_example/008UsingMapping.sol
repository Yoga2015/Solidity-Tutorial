// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract UsingMapping {
    // 创建了一个名为 balances 的 映射，它 将 地址 映射到 uint值 , 主要用来 存储 每个地址 以及 其 对应的 余额
    mapping(address => uint) public balances;

    // 存款
    function deposit(uint amount) public {
        balances[msg.sender] += amount; // 增加发送者的余额
    }

    // 获取余额
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}
