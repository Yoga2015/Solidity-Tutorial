// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract FatherModifier {
    address public owner;
    constructor() {
        owner = msg.sender; // 初始化时， 将 交易发送方 设置为 合约 的 所有者
    }

    // 修饰器：只有 所有者 才能执行 被修饰的函数
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner"); // 检查调用者是否为owner地址
        _; // 如果是的话，继续执行 回changeOwner函数 主体；否则报错 并 revert交易
    }

    function changeOwner(address newOwner) public virtual onlyOwner {
        // 一个被onlyOwner修饰器 修饰的 函数
        owner = newOwner;
    }
}

contract ChildModifier is FatherModifier {
    function someFunction() public onlyOwner {
        // 我们可以直接使用父合约中的onlyOwner修饰器
        // 只有所有者才能执行这里的代码
    }

    modifier limitValue(uint256 _value) {
        // 定义一个新的修饰器：限制输入值在0到10之间

        require(_value > 0 && _value < 10, "Value must be between 0 and 10");

        _;
    }

    function doSomethingWithValue(uint256 value) public limitValue(value) {
        // 一个被新定义的limitValue修饰器修饰的函数
        // 执行一些操作，但输入值必须在0到10之间
    }

    // 重写 父合约中的 changeOwner函数。注意：由于 changeOwner函数 在父合约中 已经被 onlyOwner修饰器 修饰，所以这里 不需要 再次修饰
    function changeOwner(address newOwner) public override {
        // 直接调用父合约的changeOwner函数
        // 但由于我们已经在子合约的上下文中，且changeOwner已经被onlyOwner修饰，所以这里的调用也会受到onlyOwner的限制
        FatherModifier.changeOwner(newOwner);
    }
}
