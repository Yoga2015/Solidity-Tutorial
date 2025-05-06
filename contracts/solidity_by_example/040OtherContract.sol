// SPDX-License-Identifier: MIT   
pragma solidity ^0.8.13;          

/// @title 被调用的目标合约
/// @notice 演示如何被其他合约调用的合约示例
contract OtherContract {
    // 状态变量
    uint256 private _x = 0;    // 私有状态变量，只能通过合约内部函数访问

    // 事件定义
    // @param amount: 接收到的ETH数量（单位：wei）、gas: 剩余的gas数量
    event Log(uint amount, uint gas);

    // 查询合约ETH余额
    // @return 返回当前合约的ETH余额（单位：wei）
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // 设置状态变量并接收ETH
    // @param x: 要设置的新值
    // @notice 函数可以接收ETH转账
    function setX(uint256 x) external payable {
        _x = x;  // 更新状态变量

        // 如果收到ETH，触发日志事件
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
/// @notice 演示如何调用其他合约的不同方法
contract CallContract {

    // 调用目标合约的setX函数
    // @param _Address: 目标合约地址、 x: 要设置的值
    function callSetX(address _Address, uint256 x) external {
        // 通过地址创建合约引用并调用函数
        OtherContract(_Address).setX(x);
    }

    // 通过合约类型调用getX
    // @param _Address: 目标合约实例、x: 返回目标合约的x值
    function callGetX(OtherContract _Address) external view returns (uint x) {
        // 直接使用合约类型参数调用
        x = _Address.getX();
    }

    // 通过地址调用getX的另一种方式
    // @param _Address: 目标合约地址、 x: 返回目标合约的x值
    function callGetX2(address _Address) external view returns (uint x) {
        // 创建临时合约引用
        OtherContract oc = OtherContract(_Address);
        // 通过引用调用函数
        x = oc.getX();
    }

    // 调用目标合约并转账ETH
    // @param otherContract: 目标合约地址
    // @param x: 要设置的值
    // @notice 函数可以接收ETH并转发
    function setXTransferETH(
        address otherContract,
        uint256 x
    ) external payable {
        // 调用目标合约的payable函数并转发ETH
        OtherContract(otherContract).setX{value: msg.value}(x);
    }
}
