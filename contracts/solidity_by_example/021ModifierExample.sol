// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract FunctionModifier {
    // 声明了一个公共状态变量 owner，将用于 存储 合约所有者 的 地址。
    address public owner;

    event OwenrChanged(address indexed _oldOwner, address indexed _newOwner);

    // 在合约部署时 初始化 owner 变量。 [msg.sender 是 部署合约的地址（即合约的创建者）]
    constructor() {
        owner = msg.sender; // 将 msg.sender 赋值给 owner，表示 合约的初始所有者 是 部署者
    }

    // 1、使用 关键字 modifier  定义 一个修饰器 onlyOwner，它用于 权限控制，确保 只有合约所有者 可以执行 某些敏感操作。
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner"); // 检查 调用者 权限，防止未授权的操作，如果权限检查失败，交易会被回滚

        _; // 如果是，继续执行被修饰函数的主体（ _ 表示 被修饰函数 的 执行位置）。
        // 如果不是，抛出错误信息 "Not owner" 并 回滚交易（revert）。
    }

    // 2、使用 onlyOwner 修饰器，确保只有 当前owner 才能调用 该函数，如果调用者是 owner,，则将 owner 更新为 _newOwner
    function changeOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address"); // 检查 _newOwner 是否为 有效地址（非零地址）

        emit OwenrChanged(owner, _newOwner); //  记录 所有者 变更

        owner = _newOwner;
    }
}

// 上面例子中，定义一个叫做 onlyOwner 的 modifier，然后 定义了 一个 changeOwner 函数 并添加 onlyOwner 修饰器, 通过 onlyOwner 修饰器 实现了 权限限制

// 通过 修饰器 onlyOwner 确保 只有当前所有者 可以调用 changeOwner 函数,调用 changeOwner 函数 可以改变 合约 的 owner

// Solidity  中 的 modifier 主要用来 修饰 函数 的。     （有点像 vue.js 的 路由守卫 ）

// 使用 modifier 可以 在函数 调用前  或  调用后  执行特定的代码，如：扩展功能、权限控制、条件检查、代码重用 等 场景

// 注意：Solidity 不允 许修饰器（modifier）重载。

// 在Solidity修饰符中，_（下划线）代表 被修饰函数 的 原始（主体）代码块。

// 当 你 在 包含有 modifier 修饰符 的 函数 中 使用  _; 时，你实际上 是在告诉 Solidity编译器：

// “现在，执行 被这个修饰符 修饰的 函数 的 剩余部分”。

// 换句话说， _  是一个 占位符，用于 调用 修饰符 所附加 的 函数 的 主体。
