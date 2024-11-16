// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract OtherContract {
    // 定义一个名为 _x 的 私有变量，类型为uint256，初始化为 0
    uint256 private _x = 0;

    // Log事件 ，记录日志，收到 ETH 后 ，记录 amount 和 gas
    event Log(uint amount, uint gas);

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

// OtherContract 合约 包含一个状态变量_x，一个事件Log 在 收到ETH时 触发，三个函数：

// getBalance(): 返回合约ETH余额。
// setX(): external payable函数，可以设置_x的值，并向合约发送ETH。
// getX(): 读取_x的值。

// CallContract合约 去调用 OtherContract合约 的 函数
contract CallContract {
    // 往 callSetX函数 传入 目标合约地址，生成 目标合约的引用，然后 调用 目标函数
    function callSetX(address _Address, uint256 x) external {
        OtherContract(_Address).setX(x);
    }

    // 往 callGetX函数 传入 合约的引用，来 实现 调用 目标合约 的 getX()函数
    function callGetX(OtherContract _Address) external view returns (uint x) {
        x = _Address.getX();
    }

    // 创建 合约变量，然后通过 合约变量 来调用 目标函数
    function callGetX2(address _Address) external view returns (uint x) {
        OtherContract oc = OtherContract(_Address); // 给变量oc存储了OtherContract合约的引用

        x = oc.getX();
    }

    // 调用 它 来给 合约 转账
    function setXTransferETH(
        address otherContract,
        uint256 x
    ) external payable {
        OtherContract(otherContract).setX{value: msg.value}(x);
    }
}
