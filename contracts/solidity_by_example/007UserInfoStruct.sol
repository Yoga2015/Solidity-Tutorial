// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 定义一个用户信息管理合约
contract UserContract {

    // 定义 用户信息结构体，包含 三个字段
    struct UserInfo {
        uint age;        // 用户年龄，使用 无符号整数类型 uint
        string name;     // 用户姓名，使用 字符串类型 string
        string email;    // 用户邮箱，使用 字符串类型 string
    }

    // 声明 一个动态数组 来存储 所有用户信息 （可以被外部访问）
    UserInfo[] public users;   

    // 添加 新用户的函数 （可以被外部调用）
    function addUser(uint ageVuale, string memory nameValue, string memory emailValue) public {

        // 创建新的用户信息实例  （memory 关键字表示这个实例临时存储在内存中）
        UserInfo memory newUser = UserInfo(ageVuale, nameValue, emailValue);
   
        users.push(newUser);  // 将 新用户信息 添加到 用户数组 中
    }

    // 查询 用户信息的函数 （只读函数，不修改状态）     returns: 指定返回值类型，这里返回年龄、姓名和邮箱
    function getUser(uint index) public view returns (uint, string memory, string memory) {
         
        UserInfo memory user = users[index];    // 从 数组 中 获取 指定索引的用户信息
   
        return (user.age, user.name, user.email);  // 返回 用户的所有信息
    }
}