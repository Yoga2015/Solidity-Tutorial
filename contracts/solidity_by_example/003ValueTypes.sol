// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// 原始数据类型 / 基本数据类型
contract ValueTypes{

    // 布尔型
    bool public boo = true;  // bool 是 solidity 中 的 布尔型 逻辑符号（true/false）, 初始默认值 是 false

    // 整型
    int public int1 = 0;      // 整数，它包括：正数 、负数 和 零

    int8 public int81 = -128;   // int8 的 取值范围 从 -128 到 127。
    int8 public int82 = 27;  
    int8 public int83 = 127; 

    int16 public int161 = -32768;    // int16 的 取值范围 从 -32768 到 32767。
    int16 public int162 = 0;     
    int16 public int163 = 32767;

    int256 public int2561 = 0;      // int256 的 取值范围 从 -2^255 到 2^255 - 1。
    int256 public int2562 = 256;
 
    uint public num1 = 9999;  
    uint8 public _uint = 0;    // uint8 是 非负整数类型，取值范围 从 0 到 2^8-1，即 0 到 255。
    uint8 public _uint2 = 255; 

    uint16 public num2 = 0;    // uint16 是 非负整数类型， 取值范围 从 0 到 2^16-1，即 0 到 65535
    uint16 public num3 = 65535;  

    uint256 public num4 = 0;   // uint256 是 非负整数类型 ，取值范围 从 0  到 2^256-1 （非常大的数）
    uint256 public _number = 20220330;  // 256位正整数


    
    // 地址类型 :

    // 1、普通地址（address）: 存储一个 20 字节的值（以太坊地址的大小）。

    // 2、payable address   : 比普通地址多了 transfer 和 send 两个成员方法，用于接收转账。

    address public addr1  = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;    // address 是 地址

    address payable public addr2 = payable(addr1); // payable address，可以转账、查余额
    
    uint256 public balance = addr1.balance; // balance of address



    // 字节数组：

    // 固定长度的字节数组

    bytes32 public _byte32 = "MiniSolidity"; // bytes32: 0x4d696e69536f6c69646974790000000000000000000000000000000000000000

    bytes1 public _byte = _byte32[0]; // bytes1: 0x4d



    // 字符串类型 string

    string public str = "this is a string data type";



    // 枚举 enum

    // 用 enum 将 uint 0， 1， 2 表示为 Buy, Hold, Sell
    enum ActionSet { Buy, Hold, Sell }

    // 创建 enum变量 action
    ActionSet action = ActionSet.Buy;

    // enum可以和uint显式的转换
    function enumToUint() external view returns(uint){
        return uint(action);
    }

}