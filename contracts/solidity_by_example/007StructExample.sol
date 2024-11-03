// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract StructExample {
    struct Student {
        uint256 id;
        string name;
        uint256 age;
    }

    Student[] public students;

    function addStudent(
        uint256 _id,
        string calldata _name,
        uint256 _age
    ) public {
        // 3种 初始化  Struct 的 方式
        // 1. 像调用函数一样，初始化时形参的顺序需与结构体字段顺序一致
        students.push(Student(_id, _name, _age));

        // // 2. key => value形式
        // students.push(Student({id: _id, name: _name, age: _age}));

        // // 3. 使用临时变量
        // Student memory stu;
        // stu.age = _age;
        // stu.id = _id;
        // stu.name = _name;
        // students.push(stu);
    }

    function getStudent(
        uint256 _index
    ) public view returns (uint256, string memory, uint256) {
        Student memory stu = students[_index];
        return (stu.id, stu.name, stu.age);
    }
}
