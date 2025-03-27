// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract VariableValue {

    // 1. 值类型初始值演示
    bool public boolValue;          // 默认值: false
    string public stringValue;      // 默认值: ""
    int public intValue;           // 默认值: 0
    uint public uintValue;         // 默认值: 0
    address public addressValue;    // 默认值: 0x0000000000000000000000000000000000000000
    bytes public bytesValue;       // 默认值: 0x
    
    // 枚举类型
    enum ActionSet { Buy, Hold, Sell }
    ActionSet public enumValue;     // 默认值: 第一个枚举值(Buy, 即0)
    
    // 2. 引用类型初始值演示
    uint[16] public staticArray;    // 固定长度数组，所有元素默认值为0
    uint[] public dynamicArray;     // 动态数组，默认值为空数组
    
    struct Person {
        uint256 id;
        uint256 score;
        string name;
        bool isActive;
    }
    Person public p1 = Person(16, 348, "Alice", true);
    
    // 映射类型
    mapping(uint => address) public myMapping;    // 所有可能的键都映射到类型的默认值
    
    
    // 3. delete 操作符演示
    bool public boolValue2 = true;
    uint[] public dynamicArray2 = [1, 2, 3, 4, 5];
    
    // 值类型删除演示
    function deleteBool() external {
        delete boolValue2;    // 恢复为 false
    }
    
    function deleteAddress() external {
        delete addressValue;  // 恢复为零地址
    }
    
    function deleteEnum() external {
        delete enumValue;     // 恢复为第一个枚举值
    }
    
    // 引用类型删除演示
    function deletePerson() external {
        delete p1;           // 所有字段恢复为默认值
    }
    
    function deleteStaticArray() external {
        delete staticArray;  // 所有元素设为0
    }
    
    function deleteDynamicArray() external {
        delete dynamicArray2;  // 清空数组
    }
    
    // 获取变量当前值的辅助函数
    function getPersonInfo() external view returns (Person memory) {
        return p1;
    }
    
    function getDynamicArrayLength() external view returns (uint) {
        return dynamicArray2.length;
    }
    
    // 重置所有状态变量
    function resetAll() external {
        delete boolValue;
        delete stringValue;
        delete intValue;
        delete uintValue;
        delete addressValue;
        delete bytesValue;
        delete enumValue;
        delete staticArray;
        delete dynamicArray;
        delete p1;
        // mapping 无法整体删除
    }
}