// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 声明一个名为 StructExample 的合约，用于演示 Solidity 中结构体的使用
contract StructExample {

    // 定义一个名为 Student 的结构体，用于存储学生信息
    struct Student {
        uint256 id;     // 学生ID，使用无符号整数类型
        string name;    // 学生姓名，使用字符串类型
        uint256 age;    // 学生年龄，使用无符号整数类型
    }

    // 声明一个动态数组，用于存储 Student 结构体
    // public 关键字使得这个数组可以被外部访问
    // 数组名为 students，元素类型为 Student 结构体
    Student[] public students;

    // 添加学生信息的函数
    // public：表示此函数可以被外部调用
    // _id, _name, _age：函数的输入参数
    // calldata：用于字符串参数的数据位置，比 memory 更省 gas
    function addStudent(uint256 _id, string calldata _name, uint256 _age) public {

        // 将新的学生信息添加到 students 数组中
        // Student(_id, _name, _age) 使用第一种初始化方式创建新的结构体实例
        students.push(Student(_id, _name, _age));

        // 第二种初始化方式：使用命名参数
        // students.push(Student({id: _id, name: _name, age: _age}));

        // 第三种初始化方式：创建临时变量并逐个赋值
        // Student memory stu;    // 在内存中创建临时变量
        // stu.age = _age;       // 设置年龄
        // stu.id = _id;         // 设置ID
        // stu.name = _name;     // 设置姓名
        // students.push(stu);    // 将临时变量添加到数组
    }

    // 获取指定索引的学生信息
    // public：表示此函数可以被外部调用
    // view：表示此函数只读取状态但不修改状态
    // returns：指定返回值类型，这里返回三个值：id、name、age
    function getStudent(uint256 _index) public view returns (uint256, string memory, uint256) {

        // 从数组中读取指定索引的学生信息
        // memory：表示将数据临时存储在内存中
        Student memory stu = students[_index];

        // 返回学生的所有信息：id、name、age
        return (stu.id, stu.name, stu.age);
    }
}
