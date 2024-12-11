// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MyContract {
    address public owner;

    // 构造函数
    constructor() {
        owner = msg.sender; // 将合约的创建者设置为所有者
    }
}

// 在这个示例中，构造函数将合约的创建者（msg.sender）的地址赋值给owner变量。这个操作只在合约部署时执行一次。

contract ConsturctorFunction {
    address owner; // 定义 owner变量

    //  构造函数 ：用来 初始化合约的一些参数，例如：初始化合约 的 owner地址
    constructor(address initialOwner) {
        owner = initialOwner; // 在 部署合约 时，将 owner 设置为 传入的 initialOwner地址
    }

    function OwnerToken(bytes32 addressName) public {
        owner = msg.sender; // 在部署合约的时候，将owner设置为部署者的地址

        name = addressName;
    }

    // owner 被初始化为 部署合约的钱包地址。
}
