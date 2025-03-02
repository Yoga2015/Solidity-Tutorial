// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract MemoryVariableDataStorageLocation {
    // 假设有一个简单的结构体
    struct MyStruct {
        uint a;
        uint b;
    }

    // myFunction函数，展示 如何 在memory中 使用结构体
    function myFunction() public pure returns (MyStruct memory) {
        // 在内存中 创建 一个新的结构体 实例
        MyStruct memory newStruct = MyStruct(1, 2);

        // 修改 内存中的数据
        newStruct.a = 3;

        // 返回 内存中的结构体实例（注意：这里返回后，newStruct 占用的内存 将在 函数返回后 被释放）
        return newStruct;
    }
}

contract MemoryExample {
    // storage 变量
    string public storageData;

    // 将 calldata 数据复制到 memory 并处理
    function processCalldata(
        string calldata input
    ) external pure returns (string memory) {
        // 将 calldata 数据复制到 memory
        string memory memoryData = input;

        // 在 memory 中处理数据
        memoryData = string(abi.encodePacked("Processed: ", memoryData));

        // 返回 memory 数据
        return memoryData;
    }

    // 将 storage 数据复制到 memory 并返回
    function getStorageData() external view returns (string memory) {
        // 将 storage 数据复制到 memory
        string memory memoryData = storageData;

        // 返回 memory 数据
        return memoryData;
    }

    // 在 memory 中创建临时变量并返回
    function createMemoryVariable() external pure returns (uint256[] memory) {
        // 在 memory 中创建一个动态数组
        uint256[] memory memoryArray = new uint256[](3);
        memoryArray[0] = 1;
        memoryArray[1] = 2;
        memoryArray[2] = 3;

        // 返回 memory 数组
        return memoryArray;
    }
}
