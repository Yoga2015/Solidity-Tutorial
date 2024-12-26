// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract BytesExample {
    bytes public data; // 使用 bytes 关键字 来创建 一个 不定长字节数组 data，其 长度 在声明之后 可以改变。

    // 设置data的值
    function setData(bytes calldata newData) public {
        data = newData;
    }

    // 向data数组的末尾添加一个字节
    function appendData(bytes calldata newDataByte) public {
        // 在Solidity 0.8.0之后，bytes和string类型的.push()方法已被移除.故使用 abi.encodePacked() 来模拟 添加 字节的效果
        data = abi.encodePacked(data, newDataByte);
    }

    // 获取data数组的长度
    function getDataLength() public view returns (uint256) {
        return data.length;
    }
}

// 什么 是 不定长字节数组 bytes

// 在Solidity中，为了处理 不同长度 的 数据，尤其是 二进制数据，引入了 不定长字节数组。

// 不定长字节数组 是Solidity中的一种 引用类型 数据类型 ，其 元素类型 是 字节，且 数组的长度 可以在运行时动态变化

// 不定长字节数组  允许 开发者 在 不知道 数据 确切长度 的 情况下，灵活地 存储 和 处理 数据。

// 不定长字节数组  主要用来  存储  和  处理  任意长度 的 二进制数据 。
