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



// ###  1. 状态变量（State Variables）
// - 定义位置 ：在合约内、函数外声明
// - 存储位置 ：永久存储在区块链上（存储在合约的存储空间中）
// - 生命周期 ：与合约生命周期相同，合约部署时创建，合约销毁时消失
// - 访问范围 ：可以被合约内的所有函数访问和修改
// - gas消耗 ：读写状态变量需要消耗较多 gas

// ### 2. 全局变量（Global Variables）
// - 定义位置 ：由 Solidity 预定义，不需要声明
// - 存储位置 ：由区块链运行时环境提供
// - 生命周期 ：交易执行期间可用
// - 访问范围 ：所有合约都可以直接访问
// - gas消耗 ：读取全局变量消耗较少 gas
// - 常用全局变量示例 ：
//   - msg.sender ：当前调用者地址
//   - block.number ：当前区块号
//   - block.timestamp ：当前区块时间戳
//   - msg.value ：交易附带的 ETH 数量
//   - tx.gasprice ：交易的 gas 价格

