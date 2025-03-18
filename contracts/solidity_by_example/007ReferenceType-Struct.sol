// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ReferenceTypeStruct{

    // 创建 Student 结构体
    struct Student{

        uint256 id;

        uint256 score;

        // 可以继续添加其他成员变量

    }

    // 实例化 一个 stu1 结构体， 但 未初始化  
    Student stu1; 

    // 操作 结构体 ：

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


contract StructLearning {
    
    // 第一部分：基础结构体
    // 1. 最简单的结构体定义
    struct SimpleUser {
        string name;    // 用户名
        uint age;      // 年龄
    }

    // 创建一个简单的结构体变量
    SimpleUser public user1;

    // 基础结构体赋值方法
    function setSimpleUser() public {
        // 方法1：直接赋值
        user1.name = "Alice";
        user1.age = 20;
    }

    // ===============================================
    // 第二部分：稍复杂的结构体
    // 2. 添加更多数据类型的结构体
    struct Student {
        uint id;                // 学号
        string name;           // 姓名
        uint[] scores;         // 成绩数组
        bool isActive;         // 是否在校
        address walletAddr;    // 钱包地址
    }

    // 使用映射存储多个学生
    mapping(uint => Student) public students;
    uint public studentCount;

    // 注册新学生（展示结构体的创建和初始化）
    function registerStudent(string memory _name) public {
        studentCount++;
        // 方法2：使用命名参数创建结构体
        students[studentCount] = Student({
            id: studentCount,
            name: _name,
            scores: new uint[](0),  // 初始化空数组
            isActive: true,
            walletAddr: msg.sender
        });
    }

    // 添加成绩（展示结构体的修改）
    function addScore(uint _studentId, uint _score) public {
        // 使用storage指针修改结构体
        Student storage student = students[_studentId];
        student.scores.push(_score);
    }

    // ===============================================
    // 第三部分：高级结构体应用
    // 3. 结构体嵌套
    struct Course {
        uint id;
        string name;
        uint credit;
    }

    struct Teacher {
        uint id;
        string name;
        Course[] courses;      // 结构体数组
        mapping(uint => bool) courseAuth;  // 结构体中包含映射
    }

    mapping(address => Teacher) public teachers;

    // 添加教师（展示复杂结构体的处理）
    function addTeacher(uint _id, string memory _name) public {
        // 注意：包含映射的结构体需要特殊处理
        Teacher storage newTeacher = teachers[msg.sender];
        newTeacher.id = _id;
        newTeacher.name = _name;
    }

    // 为教师添加课程（展示结构体嵌套操作）
    function addCourse(uint _courseId, string memory _courseName, uint _credit) public {
        Teacher storage teacher = teachers[msg.sender];
        
        // 创建新课程
        Course memory newCourse = Course({
            id: _courseId,
            name: _courseName,
            credit: _credit
        });
        
        // 添加课程到教师的课程列表
        teacher.courses.push(newCourse);
        // 设置课程权限
        teacher.courseAuth[_courseId] = true;
    }

    // ===============================================
    // 第四部分：结构体的高级用法
    // 4. 返回结构体数据
    function getStudentDetails(uint _studentId) public view returns (
        uint id,
        string memory name,
        uint[] memory scores,
        bool isActive,
        address walletAddr
    ) {
        Student memory student = students[_studentId];
        return (
            student.id,
            student.name,
            student.scores,
            student.isActive,
            student.walletAddr
        );
    }

    // 5. 结构体数组操作
    Course[] public allCourses;

    function addCourseToList(string memory _name, uint _credit) public {
        Course memory newCourse = Course({
            id: allCourses.length + 1,
            name: _name,
            credit: _credit
        });
        allCourses.push(newCourse);
    }

    // 6. 删除结构体
    function deleteStudent(uint _studentId) public {
        delete students[_studentId];
    }
}