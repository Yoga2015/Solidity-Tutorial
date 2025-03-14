// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MappingExample {
    
    // 1. 基础映射：地址到余额的映射
    mapping(address => uint) public userBalance;
    
    // 2. 嵌套映射：地址到另一个映射的映射（用于记录用户之间的授权额度） 授权关系
    mapping(address => mapping(address => uint)) public allowance;
    
    // 3. 结构体映射（复杂数据存储）
    struct UserInfo {
        string name;
        uint age;
        bool isActive;
    }
    
    // 地址到结构体的映射
    mapping(address => UserInfo) public userInfo;
    
    // 存入以太币，更新用户余额
    function deposit() public payable {
        // msg.value 是发送给合约的以太币数量
        // msg.sender 是调用合约的地址
        userBalance[msg.sender] += msg.value;
    }
    
    // 查询余额
    function getBalance(address _user) public view returns (uint) {
        // 通过地址作为键来获取对应的值
        return userBalance[_user];
    }
    
    // 设置授权额度
    function setAllowance(address _spender, uint _amount) public {
        // 在嵌套映射中设置值
        allowance[msg.sender][_spender] = _amount;
    }
    
    // 添加或更新用户信息
    function setUserInfo(string memory _name, uint _age) public {
        // 使用结构体更新映射
        userInfo[msg.sender] = UserInfo({
            name: _name,
            age: _age,
            isActive: true
        });
    }
    
    // 删除用户信息
    function deleteUserInfo() public {
        // 使用 delete 关键字删除映射中的值
        delete userInfo[msg.sender];
    }
    
    // 检查地址是否存在用户信息
    function hasUserInfo(address _user) public view returns (bool) {
        // 注意：映射中不存在的键会返回默认值
        // 这里我们通过检查 isActive 来确定用户是否存在
        return userInfo[_user].isActive;
    }
}
