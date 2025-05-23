// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 使用 selector 来调用 目标函数
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
        bytes4 selector = bytes4(keccak256("callbackFunction(uint)")); // 计算函数选择器

        // 调用回调函数
        (bool success, bytes memory result) = _callbackContract.staticcall(
            abi.encodePacked(selector, _data)
        );

        require(success, "Callback failed");

        return abi.decode(result, (uint)); // 解析回调结果
    }
}

// 在例子中，CallerContract 通过 函数选择器 找到 CallbackContract合约中 的 callbackFunction函数，并调 用它，这展示了 selector 在智能合约交互中 的 应用。

// 什么是 selector

// 当我们 调用 智能合约的函数 时，本质上是 向 目标合约 发送 一段 字节码 (即 calldata）, 所发送的 字节码 (即 calldata） 的 前4个字节 是 selector（函数选择器）。

// 如： 0x6a6278420000000000000000000000002c44b726adf1963ca47af88b284c06f30380fc78  中 的 6a627842  就是 selector 函数选择器  （4个字节 是 8个字符）

// selector 是由 函数签名 的 Keccak哈希后 的 前4个字节 构成 ，并用于 智能合约之间 的 交互。

// 函数签名 则是 “函数名（逗号分隔的参数类型）”的组合。

// selector的由来

// selector的由来 可以追溯到 智能合约 的 函数调用机制。

// 在 以太坊 等 区块链平台上，智能合约之间的交互 是通过 发送 包含 函数签名 和 参数 的 交易 来实现的。

// 为了确定要调用的函数，区块链节点 会根据 交易数据中的前4个字节（即selector）与 合约中 定义的函数签名 进行 匹配。

// selector的主要作用

// selector的主要作用是 标识 和 定位 智能合约中的函数。

// 通过 selector，区块链节点 可以快速 找到 并 调用 目标函数，而 无需 遍历 合约中的所有函数。
