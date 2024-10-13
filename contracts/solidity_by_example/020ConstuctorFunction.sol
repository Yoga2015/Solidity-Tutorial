// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ConsturctorFunction{

     address owner;    // 定义 owner变量

    //  构造函数 ：用来 初始化合约的一些参数，例如：初始化合约 的 owner地址
    constructor(address initialOwner){

        owner = initialOwner;    // 在 部署合约 时，将 owner 设置为 传入的 initialOwner地址

    }


    function OwnerToken(bytes32 addressName) public {  

        owner = msg.sender; // 在部署合约的时候，将owner设置为部署者的地址  

        name = addressName;  
    }

    // owner 被初始化为 部署合约的钱包地址。

}
