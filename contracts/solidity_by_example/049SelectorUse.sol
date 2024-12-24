// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CallbackContract {
    function callbackFunction(uint _data) external pure returns (uint) {
        return _data * 2;
    }
}

contract CallerContract {
    function callCallback(
        address _callbackContract,
        uint _data
    ) external view returns (uint) {
        // 计算函数选择器
        bytes4 selector = bytes4(keccak256("callbackFunction(uint)"));

        // 调用回调函数
        (bool success, bytes memory result) = _callbackContract.staticcall(
            abi.encodePacked(selector, _data)
        );

        require(success, "Callback failed");

        // 解析回调结果
        return abi.decode(result, (uint));
    }
}

// 在例子中，CallerContract通过函数选择器找到CallbackContract中的callbackFunction函数，并调用它。这展示了selector在智能合约交互中的应用。

// 什么是 selector

// 当我们 调用 目标合约的函数 时，本质上是 向 目标合约 发送 一段 字节码 (即 calldata）,发送的 calldata 的 前4个字节 是 selector（函数选择器）。

// 如： 0x6a6278420000000000000000000000002c44b726adf1963ca47af88b284c06f30380fc78  中 的 6a627842  就是 selector 函数选择器  （4个字节 是 8个字符）
