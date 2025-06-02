// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 外部合约示例，用于演示try-catch功能
contract OnlyEvenContract {
    /**
     * @dev 构造函数包含条件检查
     * @param a 输入参数
     * - a=0时触发require异常
     * - a=1时触发assert异常
     * - 其他值正常执行
     */
    constructor(uint a) {
        require(a != 0, "invalid number"); // 输入验证：a不能为0
        assert(a != 1); // 内部一致性检查：a不能为1
    }

    /**
     * @dev 仅接受偶数输入的函数
     * @param b 输入参数
     * @return success 操作是否成功
     * - 输入偶数时返回true
     * - 输入奇数时revert
     */
    function onlyEven(uint256 b) external pure returns (bool success) {
        require(b % 2 == 0, "Ups! Reverting"); // 检查输入是否为偶数
        success = true;
    }
}

// 主合约，演示try-catch异常处理
contract TryCatch {
    // 事件定义
    event SuccessEvent(); // 成功时触发
    event CatchEvent(string message); // 捕获字符串类型异常时触发
    event CatchByte(bytes data); // 捕获字节类型异常时触发

    // 状态变量
    OnlyEvenContract even; // 外部合约实例

    // 构造函数初始化外部合约
    constructor() {
        even = new OnlyEvenContract(2); // 使用有效参数初始化
    }

    /**
     * @dev 调用外部合约函数并处理异常
     * @param amount 输入参数
     * @return success 操作是否成功
     */
    function evecute(uint amount) external returns (bool success) {

        try even.onlyEven(amount) returns (bool _success) {
            emit SuccessEvent(); // 成功时触发事件
            return _success;
            
        } catch Error(string memory reason) {
            emit CatchEvent(reason); // 捕获require/revert异常
        }
    }

    /**
     * @dev 创建新合约并处理可能出现的异常
     * @param a 构造函数参数
     * @return success 操作是否成功
     */
    function evecuteNew(uint a) external returns (bool success) {

        try new OnlyEvenContract(a) returns (OnlyEvenContract _even) {
            emit SuccessEvent(); // 创建成功时触发事件
            success = _even.onlyEven(a); // 调用新合约的函数

        } catch Error(string memory reason) {
            emit CatchEvent(reason); // 捕获require/revert异常

        } catch (bytes memory reason) {
            emit CatchByte(reason); // 捕获assert异常
        }
    }
}

// 在 Solidity 中 使用 try-catch 来处理 智能合约运行中 的 异常：

// - try-catch 只能 用于 外部合约函数调用 和 合约创建 。

// - 如果 try 执行成功，返回 变量 必须 声明，并且 与 返回的变量类型 相同。
