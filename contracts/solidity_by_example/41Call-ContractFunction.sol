// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract OtherContract {
    // 定义一个名为 _x 的 私有变量，类型为uint256，初始化为 0
    uint256 private _x = 0;

    // Log事件 ，收到 ETH 后 ，记录 amount 和 gas
    event Log(uint amount, uint gas);

    receive() external payable {}

    fallback() external payable {}

    // 返回 当前合约 的地址的余额
    function getBalance() public view returns (uint) {
        // address(this) 获取 当前合约的地址，.balance 是 该地址的 余额属性。
        return address(this).balance;
    }

    // 可以 调整 状态变量 _x 的 函数，并且 可以 往合约 转 ETH (payable)
    function setX(uint256 x) external payable {
        _x = x;

        // 如果 转入 ETH , 则释放Log 事件
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    // 读取 _x
    function getX() external view returns (uint x) {
        x = _x;
    }
}

// 利用 call 调用 目标合约
contract CallContract {
    // 1、定义 Response 事件，输出 call 返回的 结果success 和 data,方便我们观察返回值。
    event Response(bool success, bytes data);

    // 2、定义 callSetX函数 来调用 目标合约的setX()，
    //    转入 msg.value数额 的 ETH，并释放Response事件输出success和data
    function callSetX(address payable _addr, uint256 x) public payable {
        // 调用 目标合约 的 setX(). 同时可以 发送ETH
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", x) // 结构化编码函数
        );

        emit Response(success, data); // 释放事件
    }

    // 3、调用 目标合约的 getX函数
    function callGetX(address _addr) external returns (uint256) {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()") // 结构化编码函数
        );

        emit Response(success, data); // 释放事件

        return abi.decode(data, (uint256));
    }

    // 4、调用 目标合约中 不存在的函数
    function callNonExist(address _addr) external {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(success, data); // 释放事件
    }
}
