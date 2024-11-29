// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract DeleteContract {
    uint public value = 10;

    constructor() payable {}

    receive() external payable {}

    // deleteContract() 用于 自毁合约，并把 ETH 转入给 发起人。
    function deleteContract() external {
        // 调用 selfdestruct 销毁合约，并把 剩余 的 ETH 转给 msg.sender
        selfdestruct(payable(msg.sender));
    }

    // getBalance() 用于获取 合约ETH余额
    function getBalance() external view returns (uint balance) {
        balance = address(this).balance;
    }
}

// 部署好上面的合约后，我们 向DeleteContract合约 转入1 ETH。这时，getBalance()会返回1 ETH，value变量是10。

// 当我们 调用deleteContract()函数，合约 将触发 selfdestruct操作。

// 在坎昆升级前，合约会被自毁。但是在升级后，合约依然存在，只是将合约包含的ETH转移到指定地址，而合约依然能够调用。

// 在坎昆升级后 仅能实现 内部ETH余额的转移。
