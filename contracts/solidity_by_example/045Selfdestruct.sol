// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title 合约自毁演示
/// @notice 展示selfdestruct的使用及其在坎昆升级前后的区别
contract DeleteContract {

    uint public value = 10;    // 测试用状态变量，初始值为10

    constructor() payable {}   // payable允许在部署时转入ETH

    /// @notice 接收ETH的回退函数
    receive() external payable {}  // 允许合约接收ETH转账

    /// @notice 执行合约自毁并将剩余ETH转给调用者
    /// @dev 坎昆升级后，此操作只转移ETH，不再销毁合约
    function deleteContract() external {
        // 将合约中所有ETH转给调用者
        // 在坎昆升级前会销毁合约，升级后只转移ETH
        selfdestruct(payable(msg.sender));
    }

    /// @notice 查询合约当前的ETH余额
    /// @return balance 合约的ETH余额（单位：wei）
    function getBalance() external view returns (uint balance) {
        balance = address(this).balance;  // 返回合约地址的ETH余额
    }
}

// 1.部署合约时  并且 向 DeleteContract合约 转入1 ETH。这时，getBalance()会返回1 ETH，value变量 是 10。

// 当我们 调用deleteContract()函数，合约 将触发 selfdestruct操作。

// 在坎昆升级前，合约会被自毁。但是在升级后，合约依然存在，只是将合约包含的ETH转移到指定地址，而合约依然能够调用。

// 在坎昆升级后 仅能实现 内部ETH余额的转移。
