// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ReferenceTypeArray{

    // 固定长度数组：在声明时 指定 数组的长度。用 T[k] 的 格式 声明，其中 T 是 元素的类型，k 是 长度.
    uint[8] array1;

    bytes1[10] array2;

    address[120] array3;

    // 可变长度数组（动态数组）：在声明时 不指定 数组的长度。用 T[] 的 格式 声明，其中 T 是 元素的类型。
    uint[] array4;

    bytes1[] array5;

    address[] array6;

    bytes array7;

    // memory 动态数组
    // uint[] memory array8 = new uint[](5);
    // bytes memory array9 = new bytes(9);

    // 创建 动态数组 ，需要 一个一个元素的赋值
    // uint[] memory x = new uint[](3);
    // x[0]  = 1;
    // x[1]  = 4;
    // x[2]  = 7;

}

// Solidity 是一种 静态类型 语言，这意味着 ，每个变量 都需要 在编译时 指定 变量类型；

// 引用类型 (Reference Type)：包括 数组（array）和 结构体（struct），这类变量 占空间大，赋值时 直接传递地址（类似指针）。

// 数组（Array）是Solidity常用的一种变量类型，用来存储一组数据（整数，字节，地址等等）。

// 数组分为固定长度数组和可变长度数组两种： 固定长度数组、可变长度数组（动态数组）

