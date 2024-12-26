// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract BytesExample {
    bytes public data;

    function setData(bytes newData) public {
        data = newData;
    }

    function appendData(byte newDataByte) public {
        data.push(newDataByte);
    }

    function getDataLength() public view returns (uint) {
        return data.length;
    }
}

// 不定长字节数组 bytes
// 不定长字节数组 是 Solidity中的一种 特殊的 "数组" 数据类型，其元素类型是字节，且数组的长度可以在运行时动态变化。
// 在Solidity中，为了处理不同长度的数据，尤其是二进制数据，引入了不定长字节数组。
// "不定长字节数组 " 这种数据类型允许开发者在不知道数据确切长度的情况下，灵活地存储和处理数据。
// 不定长字节数组能够存储任意长度的二进制数据，如哈希值、加密数据、图像数据等。
// 定长数组 无法适应 数据长度 的 不确定性，而不定长字节数组则解决了这一问题，提供了更高的灵活性和适应性。
