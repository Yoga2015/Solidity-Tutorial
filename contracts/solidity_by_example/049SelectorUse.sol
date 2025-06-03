// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 下面例子展示了如何使用 selector 来调用 目标合约中 的 函数。
// 回调合约示例
contract CallbackContract {
    /**
     * @dev 回调函数示例，将输入值乘以2返回
     * @param _data 输入的无符号整数
     * @return uint 返回_data乘以2的结果
     */
    function callbackFunction(uint _data) external pure returns (uint) {
        return _data * 2;
    }
}

// 调用者合约示例
contract CallerContract {

    /**
     * @dev 使用selector调用目标合约的函数
     * @param _callbackContract 目标合约地址、 _data 要传递给回调函数的数据
     * @return uint 返回回调函数的执行结果
     */
    function callCallback(address _callbackContract, uint _data) external view returns (uint) {
       
        bytes4 selector = bytes4(keccak256("callbackFunction(uint)"));     // 计算目标函数的selector
        
        // 使用staticcall进行调用（只读操作）
        (bool success, bytes memory result) = _callbackContract.staticcall(
            abi.encodePacked(selector, _data)  // 拼接selector和参数数据
        );

        require(success, "Callback failed");     // 检查调用是否成功
  
        return abi.decode(result, (uint));   // 解码并返回调用结果
    }
}

// 在上面例子中，CallerContract 通过 函数选择器 找到 CallbackContract合约中 的 callbackFunction函数，并调 用它，这展示了 selector 在智能合约交互中 的 应用。


// 什么是 selector

// 当我们 调用 智能合约的函数 时，本质上是 向 目标合约 发送 一段 字节码 (即 calldata）, 所发送的 字节码 (即 calldata） 的 前4个字节 是 selector（函数选择器）。

// 如： 0x6a6278420000000000000000000000002c44b726adf1963ca47af88b284c06f30380fc78  中 的 6a627842  就是 selector 函数选择器  （4个字节 是 8个字符）

// selector 是由 函数签名 的 Keccak哈希后 的 前4个字节 构成 ，并用于 智能合约之间 的 交互。

// 函数签名 则是 “函数名（逗号分隔的参数类型）”的组合。


// selector的由来

// selector的由来 可以追溯到 智能合约 的 函数调用机制。

// 在 以太坊 等 区块链平台上，智能合约之间的交互 是通过发送 包含 函数签名 和 参数 的 交易 来实现的。

// 为了确定要调用的函数，区块链节点 会根据 交易数据中的前4个字节（即selector）与 合约中 定义的函数签名 进行 匹配。

// selector的主要作用

// selector的主要作用 是 标识 和 定位 智能合约中的函数。

// 通过 selector，区块链节点 可以快速 找到 并 调用 目标函数，而 无需 遍历 合约中的所有函数。




// 计算器接口合约
interface ICalculator {
    function add(uint a, uint b) external pure returns (uint);
    function subtract(uint a, uint b) external pure returns (uint);
    function multiply(uint a, uint b) external pure returns (uint);
    function divide(uint a, uint b) external pure returns (uint);
}

// 基础计算器实现
contract BasicCalculator is ICalculator {
    /**
     * @dev 加法运算
     * @param a 第一个加数
     * @param b 第二个加数
     * @return 两数之和
     */
    function add(uint a, uint b) external pure override returns (uint) {
        return a + b;
    }

    /**
     * @dev 减法运算
     * @param a 被减数、 b 减数
     * @return 两数之差
     */
    function subtract(uint a, uint b) external pure override returns (uint) {
        require(a >= b, "Subtraction underflow");
        return a - b;
    }

    /**
     * @dev 乘法运算
     * @param a 第一个乘数、b 第二个乘数
     * @return 两数之积
     */
    function multiply(uint a, uint b) external pure override returns (uint) {
        return a * b;
    }

    /**
     * @dev 除法运算
     * @param a 被除数、b 除数
     * @return 两数之商
     */
    function divide(uint a, uint b) external pure override returns (uint) {
        require(b != 0, "Division by zero");
        return a / b;
    }
}

// 计算器代理合约
contract CalculatorProxy {
    event CalculationResult(address indexed calculator, string operation, uint result);
    event CalculationError(address indexed calculator, string error);

    /**
     * @dev 通过函数选择器调用计算器合约
     * @param calculator 计算器合约地址
     * @param operation 操作名称("add","subtract","multiply","divide")
     * @param a 第一个操作数
     * @param b 第二个操作数
     * @return 计算结果
     */
    function calculate(
        address calculator,
        string memory operation,
        uint a,
        uint b
    ) external returns (uint) {
        // 计算函数选择器
        bytes4 selector = bytes4(keccak256(bytes(string.concat(operation, "(uint256,uint256)"))));
        
        // 调用计算器合约
        (bool success, bytes memory result) = calculator.call(
            abi.encodeWithSelector(selector, a, b)
        );

        // 处理调用结果
        if (success) {
            uint value = abi.decode(result, (uint));
            emit CalculationResult(calculator, operation, value);
            return value;
        } else {
            emit CalculationError(calculator, "Calculation failed");
            revert("Calculation failed");
        }
    }

    /**
     * @dev 批量执行计算操作
     * @param calculators 计算器合约地址数组
     * @param operations 操作名称数组
     * @param a 第一个操作数数组
     * @param b 第二个操作数数组
     * @return 计算结果数组
     */
    function batchCalculate(
        address[] memory calculators,
        string[] memory operations,
        uint[] memory a,
        uint[] memory b
    ) external returns (uint[] memory) {
        require(
            calculators.length == operations.length && 
            operations.length == a.length && 
            a.length == b.length,
            "Input arrays length mismatch"
        );

        uint[] memory results = new uint[](calculators.length);
        
        for (uint i = 0; i < calculators.length; i++) {
            results[i] = this.calculate(calculators[i], operations[i], a[i], b[i]);
        }

        return results;
    }
}
