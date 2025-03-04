// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract CalldataVariableDataStorageLocation {
    // 定义一个结构体
    struct Data {
        uint256 value;
        string name;
    }

    // 定义一个 storage 变量
    Data public storageData;

    // 1、Calldata 直接赋值给 Storage: 是 复制 数据 到 存储中，创建一个新的副本。
    function calldataToStorage(Data calldata _calldata1) public {
        storageData = _calldata1; // 将 calldata 数据复制到 storage
    }

    // 2、Calldata 直接赋值给 Calldata ：是 引用 同一个内存位置。
    // 不过 这种赋值操作 没有太多实际意义，因为 calldata 本身 是 不可修改的，且它的主要作用是 作为 函数参数的输入。
    function calldataToCalldata(
        string calldata input
    ) external pure returns (string calldata) {
        string calldata calldataData = input; // 将 calldata 赋值给另一个 calldata 变量

        return calldataData;
    }

    // 3、Calldata 直接赋值给 Memory: 是 复制 数据 到 内存中，创建一个新的副本。 （更常见的做法是 将 calldata 数据  复制到  memory 中进行处理）
    function calldataToMemory(
        string calldata input
    ) external pure returns (string memory) {
        string memory memoryData = input; // 将 calldata 数据复制到 memory

        memoryData = string(abi.encodePacked("Processed: ", memoryData)); // 在 memory 中处理数据

        return memoryData; // 返回 memory 数据
    }

    // calldataToMemory 函数 中：input 是 calldata，因为它是一个外部函数的参数。memoryData 是 memory，因为我们需要在函数内部修改数据。
    // 最终返回的是 memory 数据，因为 calldata 不能作为返回值。

    // 4、由于 calldata 类型 是一个 只读的 和 不可变性 的 类型 ，因此不能修改，修改会报错！
    function fCalldata(
        uint[] calldata _calldata2
    ) public pure returns (uint[] calldata) {
        // _calldata2[0]  = 0;  // 这行代码 会报错 ： Calldata arrays are read-only.

        return _calldata2;
    }
}

// calldata 类型 本质上 是一个 只读的、不可变 的 内存区域，主要用于存储 外部函数调用时 传递的参数 和 返回值。

contract CalldataExample {
    // 定义一个结构体
    struct Data {
        uint256 value;
        string name;
    }

    // 定义一个 storage 变量
    Data public storageData;

    // 定义一个函数，展示 calldata 到 storage 的赋值
    function calldataToStorage(Data calldata _calldata) public {
        // 将 calldata 数据复制到 storage
        storageData = _calldata;
    }

    // 外部函数，使用 calldata 作为参数
    function processCalldata(
        string calldata input
    ) external pure returns (string memory) {
        // 直接读取 calldata 数据
        string memory result = string(abi.encodePacked("Processed: ", input));

        // 返回 memory 数据
        return result;
    }

    // 外部函数，使用 calldata 数组作为参数
    function sumArray(
        uint256[] calldata numbers
    ) external pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        return sum;
    }
}
