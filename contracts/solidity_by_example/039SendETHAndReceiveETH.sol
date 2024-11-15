// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// 发送 ETH 的 合约
contract SendETH {
    // 构造函数 加上 payable 关键字，可以 使得 部署的时候 可以转 ETH 进入
    constructor() payable {}

    // receive方法，接收 ETH 时 被触发
    receive() external payable {}

    // 1、用 transfer() 方法 发送 ETH
    function transferETH(address payable _to, uint256 amount) external payable {
        _to.transfer(amount); // 接收方地址.transfer ( 发送ETH数额 )；
    }

    // 2、用 send() 方法 发送 ETH     接收方地址.send ( 发送ETH数额 )；
    error SendFailed(); // 发送ETH 失败 error

    function sendETH(address payable _to, uint256 amount) external payable {
        // 处理下 send 的 返回值 ，如果失败，会自动 revert交易 并发送 error
        bool success = _to.send(amount);

        if (!success) {
            revert SendFailed();
        }
    }

    // 3、用 call() 方法 发送 ETH     接收方地址.call{value: 发送ETH数额}("")
    error CallFailed(); // 发送 ETH 失败 error

    function callETH(address payable _to, uint256 amount) external payable {
        // 处理下 call 的 返回值，如果失败，revert 交易 并 发送error
        (bool success, ) = _to.call{value: amount}("");

        if (!success) {
            revert CallFailed();
        }
    }
}

// 接收 ETH 的 合约
contract ReceiveETH {
    // 收到 ETH 事件 ，记录 amount 和 gas
    event Log(uint amount, uint gas);

    // receive 方法，接收ETH 时 被触发
    receive() external payable {
        emit Log(msg.value, gasleft());
    }

    // 返回 合约 ETH余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// 上面部署了 一个 接收ETH 的 合约 ReceiveETH  ，合约 里 有一个事件 Log，记录 收到的ETH数量 和 gas剩余。
// 其中 还有 两个函数：
//          一个是 receive()函数，收到ETH 被触发，并发送 Log事件；
//          另一个是 查询 合约ETH余额 的 getBalance()函数 。

// transfer（）有 固定的 2300gas 限制，无返回值 ，发送失败 会自动 revert 回滚交易，是 次优选择

// send（） 有 固定的 2300gas 限制，返回值 为 布尔值，发送失败 不会自动 revert 回滚交易，几乎 没有人用它

// call（）没有 gas 限制（无限制），返回值 为 布尔值, 数据 ，发送失败  不会自动 revert，需手动处理，推荐使用
