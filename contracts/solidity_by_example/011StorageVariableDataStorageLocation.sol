// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract StorageVariableDataStorageLocation {
    uint256 public count; // 状态变量count ，存储在storage中 ，它 将用于 存储一个计数器。

    // 用于 更新 计数器 的 值
    function increment() public {
        count += 1; // 更新 状态变量，增加 计数器
    }

    // 用于 返回 计数器 的 当前值
    function getCount() public view returns (uint256) {
        return count; // 返回 状态变量的值
    }
}

// 由于 状态变量 默认存储在 storage 中，因此 不需要显式地 使用 storage 关键字 来声明  状态变量，即： 可以 不显式 写上  storage关键字

// 状态变量 通常在 合约内的顶部 声明，以确保 在整个合约范围内 都是 可访问的 ，且只能在 合约内、函数外 声明

// 如果 状态变量（全局的） 没有进行 显式声明 其 存储位置 ，会被默认为 是 存储在 合约的存储（storage）中 的 ，即：属于 storage 类型 的。

contract storageBestPractice {
    uint256 public storageSum;

    // （1）尽量减少 storage 的写入操作
    // storage 的写入操作会消耗大量 Gas，因此应尽量减少对 storage 的写入次数。
    // 例如，可以在 memory 中处理数据，最后再将结果一次性写入 storage。
    function updateValue(uint256 newValue) public {
        uint256 processedValue = newValue * 12; // 在menory中处理数据，最后再将结果一次性写入 storage。

        storageSum = processedValue;
    }

    // （2）避免在循环中频繁写入 storage
    // 在循环中频繁写入 storage 会导致极高的 Gas 消耗。如果可能，尽量在循环外部进行 storage 写入操作。
    function updateValues(uint256[] memory values) public {
        uint256 sum = 0;

        // 在 memory 中计算总和
        for (uint256 i = 0; i < values.length; i++) {
            sum += values[i];
        }

        storageSum = sum; // 最后将结果写入 storage
    }

    // （3）使用局部变量优化 storage 读取
    // 如果某个 storage 变量在函数中被多次读取，可以将其复制到 memory 中，以减少 Gas 消耗。
    function calculateTotal() public view returns (uint256) {
        uint256 sValue = storageSum; // 将 storage 变量复制到 memory

        return sValue * 10; // 在 memory 中进行计算
    }

    // （4）合理使用 mapping 和 array
    // mapping 和 array 是 storage 中常用的数据结构，但它们的使用会消耗较多的 Gas。
    // 对于 mapping，尽量避免存储大量数据；对于 array，尽量控制其长度。
    mapping(address => uint256) public balances;

    function addBalance(address user, uint256 amount) public {
        balances[user] += amount; // 直接更新 mapping
    }

    // （5）使用 struct 组织复杂数据: 对于 复杂的 数据结构，可以使用 struct 来组织数据，并将其存储在 storage 中
    struct User {
        uint256 id;
        string name;
        uint256 balance;
    }

    mapping(address => User) public users;

    function createUser(
        address userAddress,
        uint256 id,
        string memory name
    ) public {
        users[userAddress] = User({id: id, name: name, balance: 0}); // 使用 struct 组织数据
    }
}
