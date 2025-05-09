// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title 演示delegatecall和call的区别
/// @notice 展示两种调用方式如何影响状态变量的存储上下文

// 被调用的合约C（逻辑合约）       0xaE7A2AB9883E1A4add3900c910F95eB90D31a323
contract C {

    // 状态变量布局必须与合约B相同
    uint public num;        // 存储插槽0：数值存储
    address public sender;  // 存储插槽1：地址存储

    // 设置状态变量的函数
    // @param _num: 要设置的数值
    // @notice 同时设置num和sender
    function setVars(uint _num) public payable {
        num = _num;            // 设置数值
        sender = msg.sender;   // 设置调用者地址
    }
}

// 调用者合约B（代理合约）   0x0Ffc8eec096f90088Df7f0888e6Da0Dc1b57b392
// 合约B 必须和 目标合约C 的 变量存储布局 必须相同，两个变量，并且顺序为 num 和 sender
contract B {
    
    // 状态变量布局必须与合约C完全一致
    uint public num;        // 存储插槽0：数值存储
    address public sender;  // 存储插槽1：地址存储

    // 使用 call 调用 合约C 的 setVars函数，调用后会改变合约C的状态
    // @param _addr: 目标合约C的地址、_num: 要设置的数值
    function callSetVars(address _addr, uint _num) external payable {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

    // 使用 delegatecall 调用 合约C 的 setVars函数
    // @param _addr: 目标合约C的地址、_num: 要设置的数值
    // @notice 调用后会改变当前合约B的状态
    function delegatecallSetVars(address _addr, uint _num) external payable {

         // delegatecall调用：在当前合约的上下文中执行
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}

// 分别用 call 和 delegatecall 来调用 合约C 的 setVars函数

// Solidity中的另一个低级函数delegatecall。与call类似，
// delegatecall 可以用来 调用 其他合约；不同点在于 运行的上下文，
// B call C，上下文 为 C； 而 B delegatecall C，上下文 为 B。
