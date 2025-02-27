// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ReferenceTypeArray {
    // 固定长度数组：在声明时 指定 数组的长度。使用 T[k] 的 格式 声明，其中 T 是 元素的类型，k 是 长度.

    uint[8] array1; // 声明了 一个 包含 8个无符号整数 的 数组

    bytes1[10] array2; // 声明了 一个 包含 10个无符号整数 的 数组

    address[8] array3; // 声明了 一个 包含 8个 地址 的 数组

    // 可变长度数组（动态数组）：在声明时 不指定 数组的长度。用 T[] 的 格式 声明，其中 T 是 元素的类型。

    uint[] array4; // 声明了 一个 可变长度 的 无符号整数 数组 array4

    bytes1[] array5; // 声明了 一个 可变长度 的 字节数组 array6

    address[] array6; // 声明了 一个 可变长度 的 address类型 数组 array6

    bytes array7; //  声明了 一个 可变长度 的 字节数组 array7

    // 可变长度数组：可以使用 new 操作符 来创 建并 初始化，但必须 在创建时 指定 初始长度（尽管这个长度之后可以改变）。

    // [] 可变长度 的 无符号整数 动态数组

    uint[] array8 = new uint[](5);

    bytes array9 = new bytes(9);

    // 创建 动态数组 ，需要 一个一个元素的赋值
    // uint[] x = new uint[](3);
    // x[0]  = 1;
    // x[1]  = 4;
    // x[2]  = 7;
}

// Solidity 是一种 静态类型 语言，这意味着 ，每个变量 都需要 在编译时 指定 变量类型；

// 引用类型 (Reference Type)：包括 数组（array）和 结构体（struct），这类变量 占空间大，赋值时 直接传递地址（类似指针）。

// 数组（Array）是Solidity常用的一种变量类型，用来存储一组数据（整数，字节，地址等等）。

// 数组分为固定长度数组和可变长度数组两种： 固定长度数组、可变长度数组（动态数组）

contract ArrayMemberFunctionsAndProperties {
    uint[] public numArray;

    function addToArray(uint num) public {
        // 添加元素 到 数组中

        numArray.push(num);
    }

    function getArrayLength() public view returns (uint) {
        // 获取 数组的长度

        return numArray.length;
    }

    function getElement(uint index) public view returns (uint) {
        // 根据索引 获取 数组中的元素

        return numArray[index];
    }

    function removeLastElement() public {
        // 移除 数组的最后一个元素

        numArray.pop();
    }
}
