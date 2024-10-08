// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract variableScope {
    // 状态变量  state variable
    // 状态变量 在合约内、函数外声明, 可以 在函数里 更改 状态变量的值
    uint public x = 1;
    uint public y;
    string public z;

    function foo() external {
        // 可以在函数里改变状态变量的值
        x = 3;
        y = 8;
        z = "0xAA";
    }

    // 局部变量  local variable
    // 局部变量 在 函数内 声明，局部变量 是仅在 函数执行过程中 有效的变量，函数退出后，变量无效。
    function bar() external pure returns (uint) {
        uint xx = 1;
        uint yy = 3;
        uint zz = xx + yy;

        return (zz);
    }

    // 全局变量  global variable
    // 全局变量 是 全局范围工作 的 变量，都是 solidity预留关键字。全局变量 可以 在函数内 不声明 , 直接使用
    function global() external view returns (address, uint, bytes memory) {
        address sender = msg.sender; // msg.sender 代表 请求发起地址

        uint blockNum = block.number; // block.number 代表 当前区块高度

        bytes memory data = msg.data; // msg.data  代表  请求数据

        return (sender, blockNum, data);
    }

    // 在上面 只使用了 3个 常用的全局变量：msg.sender，block.number 和 msg.data。 其实 还有很多的 全面变量
}
