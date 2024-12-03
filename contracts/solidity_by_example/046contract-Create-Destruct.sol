// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 意味着 DeployContract合约 将能够使用 DeleteContract合约中 定义的功能。
import "./045Selfdestruct.sol";

contract DeployContract {
    // 被用于 demo函数 的 返回值
    struct DemoResult {
        address addr;
        uint balance;
        uint value;
    }

    // 构造函数 被标记为 payable，这意味着 在部署合约时 可以向其 发送以太币。然而，构造函数内部并没有执行任何操作。
    constructor() payable {}

    // 被标记为view 意味着 它不会修改 区块链上的任何状态。它返回当前合约的以太币余额。
    function getBalance() external view returns (uint balance) {
        balance = address(this).balance;
    }

    function demo() public payable returns (DemoResult memory) {
        // 使用 msg.value（即调用者发送的以太币数量）部署一个新的DeleteContract实例，并将其地址存储在变量del中。
        DeleteContract del = new DeleteContract{value: msg.value}();

        DemoResult memory res = DemoResult({
            addr: address(del),
            balance: del.getBalance(),
            value: del.value()
        });

        del.deleteContract(); // 调用del.deleteContract() 用于删除或自毁合约

        return res;
    }
}

// demo函数 是 公共可调用的，并且也是payable的。这个函数执行以下操作：
// 1、使用msg.value（即调用者发送的以太币数量）部署一个新的DeleteContract实例，并将其地址存储在变量del中。
// 2、创建一个DemoResult类型的局部变量res，并初始化其字段：
//      addr字段设置为新部署的DeleteContract实例的地址。
//      balance字段通过调用del.getBalance()获取DeleteContract实例的余额（这里假设DeleteContract有一个返回余额的函数getBalance）。
//      value字段通过调用del.value()获取（这里假设DeleteContract有一个返回某种值的函数value，但具体返回什么值取决于DeleteContract的实现）。
// 3、调用del.deleteContract()（这里假设DeleteContract有一个deleteContract函数用于删除或自毁合约）。
// 4、返回res结构体实例。
