// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract StorageMemoryCalldataExample {
    // 定义一个结构体
    struct Data {
        uint256 value;
        string name;
    }

    // 定义一个 storage 变量
    Data public storageData;

    // 定义一个函数，展示 storage 到 memory 的赋值
    function storageToMemory() public view returns (uint256, string memory) {
        // 将 storage 数据复制到 memory
        Data memory memoryData = storageData; // 变量memoryData 在函数执行期间存在，并在函数结束后被销毁。

        // 返回 memory 中的数据
        return (memoryData.value, memoryData.name);
    }

    // 定义一个函数，展示 memory 到 storage 的赋值
    function memoryToStorage(uint256 _value, string memory _name) public {
        // 创建一个 memory 变量
        Data memory memoryData = Data({value: _value, name: _name});

        // 将 memory 数据复制到 storage
        storageData = memoryData;
    }

    // 定义一个函数，展示 calldata 到 memory 的赋值
    function calldataToMemory(
        Data calldata _calldata
    ) public pure returns (uint256, string memory) {
        // 将 calldata 数据复制到 memory
        Data memory memoryData = _calldata;

        // 返回 memory 中的数据
        return (memoryData.value, memoryData.name);
    }

    // 定义一个函数，展示 calldata 到 storage 的赋值
    function calldataToStorage(Data calldata _calldata) public {
        // 将 calldata 数据复制到 storage
        storageData = _calldata;
    }
}
