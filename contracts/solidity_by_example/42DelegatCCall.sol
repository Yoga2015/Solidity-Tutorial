// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 被调用的 合约C       0xaE7A2AB9883E1A4add3900c910F95eB90D31a323
contract C {
    uint public num;
    address public sender;

    // 将 num 设定为 传入的 _num，并且 将 sender 设为 msg.sender。
    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}

// 发起调用的 合约B    0x0Ffc8eec096f90088Df7f0888e6Da0Dc1b57b392
// 合约B 必须和 目标合约C 的 变量存储布局 必须相同，两个变量，并且顺序为 num 和 sender
contract B {
    uint public num;
    address public sender;

    // 1.通过 call 来调用 目标合约C 的 setVars（）函数，将改变 目标合约C里的 状态变量
    // 有两个参数_addr和_num，分别对应 合约C的地址 和 setVars的参数 。
    function callSetVars(address _addr, uint _num) external payable {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

    // 2.通过 delegatecall 来调用 目标合约C 的 setVars()函数，将改变 合约B里的 状态变量
    // 有两个参数_addr和_num，分别对应 合约C的地址 和 setVars的参数 。
    function delegatecallSetVars(address _addr, uint _num) external payable {
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}

// 分别用 call 和 delegatecall 来调用 合约C 的 setVars函数

// Solidity中的另一个低级函数delegatecall。与call类似，
// delegatecall 可以用来 调用 其他合约；不同点在于 运行的上下文，
// B call C，上下文 为 C； 而 B delegatecall C，上下文 为 B。
