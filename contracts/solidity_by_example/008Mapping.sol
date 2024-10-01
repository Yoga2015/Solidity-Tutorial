// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract MappingDemo{

    // 创建（声明） 映射 的 格式为 mapping(KeyType => ValueType)，其中 KeyType 和 ValueType 分别是 Key 和 Value 的 变量类型。

    mapping(uint => address) public idToAddress;  // id 映射 到 地址

    mapping(address => address) public swapPair;  // 币对的映射，地址 到 地址


    // 规则1：映射 的 映射键_KeyType 只能选择 Solidity 内置的 值类型，比如 uint，address 等，不能用自定义的结构体。
    // mapping 中 只允许基本类型、用户定义 的 值类型、契约类型 或 枚举 作为 映射键。

    // 下面这个例子会报错，因为 KeyType 使用了 我们 自定义 的 结构体：
    struct Student{
        uint256 id;
        uint256 score;
    }

    // TypeError: Only elementary types, user defined value types, contract types or enums are allowed as mapping keys.
    // mapping(Student => uint) public myMap;



    // 规则4：给 映射 新增 键值对 的 语法为 _Var[_Key] = _Value，其中 _Var 是 映射变量名，_Key 和_Value 对应新增的键值对。

    function writeMap(uint _Key, address _Value) public {

        idToAddress[_Key]  = _Value;

    }

}


// Mapping 映射类型 是 一种 高效且灵活、 类似于 哈希表 的 数据结构，用于 存储 和 检索 键值对（Key-Value pairs）。

// 使用 mapping 来 管理 和 操作 数据集合，但 mapping 不可遍历、不可比较。

// Solidity 中， 存储 键值对 的 数据结构，可以理解为 哈希表。


// 在 智能合约 中 如何 高效地 存储 和 检索 数据？

// 通过 键值对 的方式，mapping 允许 开发者 通过 键（Key）来查询 对应的值（Value），比如：

// 通过 一个人 的 id 来查询 他的钱包地址，这在处理 用户信息、权限管理、资源分配 等场景中 尤为重要。