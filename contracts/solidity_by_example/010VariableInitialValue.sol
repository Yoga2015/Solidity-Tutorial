// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract variableValue{

    // 值类型初始值 Value Type Initial Value

    bool public boolValue;  // false

    string public stringValue;   // ''

    int public  intValue;  // 0

    uint public uintValue;  // 0

    address public addressValue;   // 0x0000000000000000000000000000000000000000

    enum ActionSet{Buy,Hold,Sell} ActionSet public enumValue;  // 第1个内容 Buy 的 索引 0

    function fi() internal{}  // internal 空白函数

    function fe() external {}  // external 空白函数 


    //  引用类型初始值 Reference Type Initial Value

    uint[16] public staticArray;  // 所有成员 设为 其 默认值 的 静态数组 [0,0,0,0,0,0,0,0]

    uint[] public dynamicArray;  // `[]`


    struct Person{ // 所有成员 设为 其 默认值 的 结构体 0, 0

        uint256 id;

        uint256 score;

    }

    Person public p1 = Person(16,348);


    mapping(uint => address) public myMapping; // 所有元素都为其默认值的mapping


    // delete 操作符 , 例如： delete a ; 会让 状态变量a 的 值 变为 初始值

    bool public boolValue2 = true;

    function del() external {

        delete  boolValue2;    // delete 会让 boolValue2 变为 默认值，false

    }

    function d_address() external{
         delete  addressValue;
    }

    function d_enum() external{
         delete  enumValue;
    }

    function d_Person() external{
         delete  p1;
    }

    function d_staticArray() external {
        delete staticArray;
    }

}