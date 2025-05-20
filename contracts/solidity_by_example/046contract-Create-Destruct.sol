// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 导入自毁合约
import "./045Selfdestruct.sol";

/// @title 合约创建与销毁演示
/// @notice 展示合约的完整生命周期管理
contract DeployContract {
    // === 结构体定义 ===
    /// @notice 用于记录合约创建的结果
    struct DemoResult {
        address addr;    // 新创建的合约地址
        uint balance;    // 合约的ETH余额
        uint value;      // 合约的状态变量值
    }

    /// @notice 构造函数，允许部署时接收ETH
    /// @dev 虽然可以接收ETH，但构造函数不执行任何操作
    constructor() payable {}

    /// @notice 查询当前合约的ETH余额
    /// @return balance 合约的ETH余额（单位：wei）
    function getBalance() external view returns (uint balance) {
        balance = address(this).balance;
    }

    /// @notice 演示合约的创建和销毁过程
    /// @dev 创建合约、记录状态、然后销毁它
    /// @return DemoResult 包含新合约的信息
    function demo() public payable returns (DemoResult memory) {
        // 创建新的DeleteContract实例，并转入调用者发送的ETH
        DeleteContract del = new DeleteContract{value: msg.value}();

        // 记录新合约的状态信息
        DemoResult memory res = DemoResult({
            addr: address(del),      // 记录新合约地址
            balance: del.getBalance(), // 获取合约ETH余额
            value: del.value()       // 获取合约状态变量值
        });

        // 调用自毁函数，销毁新创建的合约
        del.deleteContract();

        // 返回记录的状态信息
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
