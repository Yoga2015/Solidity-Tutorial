// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 创建一个 外部合约OnlyEven，并使用try-catch来处理异常：
contract OnlyEvenContract {
    // 构造函数有一个参数a，当 a != 0 时，require会抛出异常；当 a != 1 时，assert会抛出异常；其他情况均正常。
    constructor(uint a) {
        require(a != 0, "invalid number"); // require 常用于 合约 执行前 的 条件检查，如: 验证 输入参数 或 外部合约调用 结果
        assert(a != 1); //  assert 用于检查 代码逻辑 中 的 不变量, 当 检查条件 不成立 的时候，就会抛出异常。
    }

    // onlyEven函数 有一个参数 b，当 b 为 奇数 时，require会抛出异常。
    function onlyEven(uint256 b) external pure returns (bool success) {
        require(b % 2 == 0, "Ups! Reverting"); // 输入奇数时 revert
        success = true;
    }
}

// 创建一个 合约TryCatch 来处理 外部函数调用 异常
contract TryCatch {
    event SuccessEvent(); // SuccessEvent 是 调用成功 会释放的事件
    event CatchEvent(string message); // CatchEvent 和 CatchByte 是 抛出异常时 会释放的事件
    event CatchByte(bytes data);

    OnlyEvenContract even; // 声明 OnlyEvenContract 的 合约变量

    constructor() {
        even = new OnlyEvenContract(2);
    }

    // 在 evecute 函数中 使用 try-catch 处理 调用 外部函数 onlyEven 中 的 异常
    function evecute(uint amount) external returns (bool success) {
        try even.onlyEven(amount) returns (bool _success) {
            emit SuccessEvent(); // call成功 的 情况下
            return _success;
        } catch Error(string memory reason) {
            emit CatchEvent(reason); // call不成功 的 情况下
        }
    }

    // 在 创建新合约中 使用 try-catch (合约 创建被视为 external call)
    // executeNew(0)会失败并释放`CatchEvent`, executeNew(1)会失败并释放`CatchByte`,executeNew(2)会成功并释放`SuccessEvent`
    function evecuteNew(uint a) external returns (bool success) {
        try new OnlyEvenContract(a) returns (OnlyEvenContract _even) {
            emit SuccessEvent(); // call成功的情况下
            success = _even.onlyEven(a);
        } catch Error(string memory reason) {
            emit CatchEvent(reason); // catch 失败的 revert() 和 require()
        } catch (bytes memory reason) {
            emit CatchByte(reason); // catch失败 的 assert()
        }
    }
}

// 在 Solidity 中 使用 try-catch 来处理 智能合约运行中 的 异常：

// - try-catch 只能 用于 外部合约函数调用 和 合约创建 。

// - 如果 try 执行成功，返回 变量 必须 声明，并且 与 返回的变量类型 相同。
