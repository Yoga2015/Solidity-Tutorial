// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title 被调用的目标合约
/// @notice 演示如何通过call被其他合约调用
contract OtherContract {

    // 定义一个名为 _x 的 私有变量，类型为uint256，初始化为 0
    uint256 private _x = 0;

    // Log事件 ，收到 ETH 后 ，记录 amount: 接收到的ETH数量（单位：wei）、gas: 剩余的gas数量
    event Log(uint amount, uint gas);

     // 接收ETH的函数
    receive() external payable {}

     // 处理未知调用的函数
    fallback() external payable {}

    // 查询合约ETH余额
    // @return 返回当前合约的ETH余额
    function getBalance() public view returns (uint) {
        // address(this) 获取 当前合约的地址，.balance 是 该地址的 余额属性。
        return address(this).balance;
    }

    // 设置状态变量并可接收ETH
    // @param x: 要设置的新值
    // @notice 可以同时接收ETH
    function setX(uint256 x) external payable {
        _x = x;

        // 如果 转入 ETH , 则释放Log 事件
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    // 读取状态变量
    // @return x: 返回_x的当前值
    function getX() external view returns (uint x) {
        x = _x;
    }
}

/// @title 调用者合约
/// @notice 演示如何使用低级call调用其他合约
contract CallContract {

    // 调用结果事件
    // @param success: 调用是否成功、data: 调用返回的数据
    event Response(bool success, bytes data);

    // 通过call调用setX并发送ETH
    // @param _addr: 目标合约地址、x: 要设置的值
    // @notice 可以发送ETH到目标合约
    function callSetX(address payable _addr, uint256 x) public payable {

       // 使用call调用目标合约，并发送ETH
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", x) // 使用ABI编码调用setX函数
        );

        emit Response(success, data); // 释放事件
    }

    // 通过call调用getX
    // @param _addr: 目标合约地址
    // @return 返回目标合约的x值
    function callGetX(address _addr) external returns (uint256) {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()") // 结构化编码函数
        );

        emit Response(success, data); // 释放事件

        return abi.decode(data, (uint256));   // 解码返回数据
    }

    // 测试调用不存在的函数
    // @param _addr: 目标合约地址
    // @notice 用于演示调用失败的情况
    function callNonExist(address _addr) external {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(success, data); // 释放事件
    }
}
