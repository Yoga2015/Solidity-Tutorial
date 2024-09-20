// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ReferenceTypeStruct{

    // 创建 Student 结构体
    struct Student{
        uint256 id;
        uint256 score;
    }

    // 初始化 一个 stu1 结构体
    Student stu1;

    // 给 结构体 赋值 的 四种方法：

    // 方法1 ： 在 函数中 创建 一个 storage 的 struct 引用
    function initStudent1() external{
        Student storage stu2 = stu1;
        stu2.id = 88;
        stu2.score = 666;
    }

    // 方法2 ：直接引用 状态变量 的 struct
    function initStudent2() external{
        stu1.id = 3;
        stu1.score = 77; 
    }

    // 方法3:构造函数式
    function initStudent3() external{
        stu1 = Student(33,99);
    }

    // 方法4：key value
    function initStudent4() external{
        stu1 =  Student({id:36,score:44});
    }

}