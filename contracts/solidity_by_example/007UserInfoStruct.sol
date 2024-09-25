// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 定义一个 UserInfo结构体 来存储 用户信息
struct UserInfo{
    uint age;
    string name;
    string email;
}

// 创建 UserContract 合约
contract UserContract{

    // 创建 一个 UserInfo类型 的 数组users 来存储 多个用户信息
    UserInfo[] public users;   // 用户数组

    // addUser函数 可以 添加新用户
    function addUser(uint ageVuale, string memory nameValue,string memory emailValue) public {

        // 在函数内部 实例化 结构体 时，需要明确 指定 存储位置
        UserInfo memory newUser = UserInfo(ageVuale,nameValue,emailValue);

        users.push(newUser);     // 将 新用户 添加到 数组中

    }


    // getUser函数 可以 根据索引 获取 用户信息
    function getUser(uint index) public view  returns (uint,string memory,string memory){

        UserInfo memory user = users[index];

        return (user.age,user.name,user.email);

    }

}