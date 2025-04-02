// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract FunctionModifier {

    address public owner; // 用于 存储 合约所有者 的 地址。

    bool public paused;

    event Log(string message);

    event OwenrChanged(address indexed _oldOwner, address indexed _newOwner);

    // 在合约部署时 初始化 owner 变量。 [msg.sender 是 部署合约的地址（即合约的创建者）]
    constructor() {
        owner = msg.sender; // 将 msg.sender 赋值给 owner，表示 合约的初始所有者 是 部署者
    }

    // 1、使用 关键字 modifier  定义 一个修饰器

    // 1.1 权限控制 修饰器 ：限制 某些函数 只能由 特定地址（如 合约所有者 或 管理员）调用 (执行 某些敏感操作)。
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner"); // 检查 调用者 权限，防止未授权的操作，如果权限检查失败，交易会被回滚
        _; // 如果是，继续执行被修饰函数的主体（ _ 表示 被修饰函数 的 执行位置）。
        // 如果不是，抛出错误信息 "Not owner" 并 回滚交易（revert）。
    }

    // 1.2、输入验证 修饰器 ： 验证函数输入的合法性，例如检查地址是否有效、数值是否在合理范围内等。
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Invalid address"); // 检查 _newOwner 是否为 有效地址（非零地址）
        _;
    }

    // 1.3 状态检查 修饰器 ：检查 合约 的 当前状态 是否符合 某些条件，例如 合约是否已启用、是否已暂停等。
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    // 1.4 日志记录 修饰器 : 用于 在函数执行前/后 记录日志，方便调试和监控。
    modifier logExecution(string memory _message) {

        emit Log(_message);

        _;

        emit Log("Execution completed");
    }

    // 1.5  自定义错误处理 修饰器 : 用于统一处理错误，避免在每个函数中重复编写错误检查逻辑。
    modifier checkBalance(uint256 _amount) {

        require(
            address(this).balance >= _amount,
            "Insufficient contract balance"
        ); // 确保合约余额足够时才执行支付逻辑。

        _;
    }

    // 2、使用 修饰器 （修饰器 也可以 组合使用）
    // 2.1 使用 onlyOwner 修饰器，确保只有 当前owner 才能调用 该函数，如果调用者是 owner,，则将 owner 更新为 _newOwner
    // 2.2 使用 logExecution 修饰器 在函数执行前/后 记录日志
    function changeOwner(address _newOwner) external onlyOwner logExecution("doSomething called") {

        require(_newOwner != address(0), "Invalid address");

        emit OwenrChanged(owner, _newOwner); //  记录 所有者 变更

        owner = _newOwner;
    }
}

// 这个合约展示了 Solidity 中修饰器（modifier）的各种常见使用场景，包括 权限控制、输入验证、状态检查、日志记录、错误处理，修饰器的组合使用。 


// 什么是 modifier
// Solidity 中 的 modifier（修饰器）类似于 面向对象编程中 的 装饰器（decorator），
        // 装饰器（Decorator）是一种设计模式，主要用于 动态地 扩展 或 修改 函数、方法 或 类的行为，而无需直接修改其原始代码。
        // 装饰器 可以在 不修改 原始函数 或 类 的情况下，为 其 添加 额外的功能。
// 修饰器（modifier）是 Solidity 中 用于 扩展 或 修改 函数行为的 特殊关键字。

// modifier 的 作用
// Solidity  中 的 modifier 主要用来 修饰 函数 的。   (扩展 函数功能 )
// modifier 的 主要应用于  在 函数 执行前 或 执行后 添加 额外的逻辑 。
// 使用 modifier 可以 在函数 调用前  或  调用后  执行特定的代码，如：扩展功能、权限控制、条件检查、代码重用 等 场景
// 1.扩展功能：为 函数 或 类 添加 额外行为。
// 2.权限控制：通过 修饰器 可以确保 只有满足特定条件的账户（如合约所有者或特定角色）才能 调用 某些函数 。
// 3.条件检查：在函数执行前，修饰器 可以执行 一系列的条件检查，如 检查账户余额、验证发送者地址、验证输入 等，以确保 函数 在正确的条件下执行。
// 4.代码复用：修饰器 允许 在多个函数中 重用相同 的 检查逻辑，从而 减少 代码冗余 并 提高 代码的可维护性。
// modifier  可以组合使用，以实现更复杂的逻辑。例如，一个函数可能需要同时满足权限控制和状态检查。
// 合理使用  modifier 可以帮助减少代码重复，从而降低合约的部署和运行成本（Gas 费用）
// 注意：Solidity 不允许 修饰器（modifier）重载。

// 在Solidity修饰符中，_（下划线）代表 被修饰函数 的 原始（主体）代码块。

// 当 你 在 包含有 modifier 修饰符 的 函数 中 使用  _; 时，你实际上 是在告诉 Solidity编译器：

// “现在，执行 被这个修饰符 修饰的 函数 的 剩余部分”。

// 换句话说， _  是一个 占位符，用于 调用 修饰符 所附加 的 函数 的 主体。
