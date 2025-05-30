// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract HashKeccak256SHA3 {

    // 预计算的哈希值，使用keccak256对"OxAA"进行哈希
    bytes32 _msg = keccak256(abi.encodePacked("OxAA"));
    
    bytes32 public _temp;    // 用于临时存储哈希值

    /**
     * @dev 生成数据的唯一哈希标识
     * @param _num 无符号整数输入
     * @param _string 字符串输入 
     * @param _addr 地址输入
     * @return bytes32 返回组合参数的keccak256哈希值
     * 注意：使用abi.encodePacked紧密打包参数
     */
    function hash(
        uint _num,
        string memory _string,
        address _addr
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_num, _string, _addr));
    }

    /**
     * @dev 测试哈希函数的弱抗碰撞性
     * @param string1 待比较的字符串
     * @return bool 返回输入字符串的哈希是否等于预存的_msg哈希
     * 弱抗碰撞性：难以找到不同的输入产生相同的哈希
     */
    function weak(string memory string1) public view returns (bool) {
        return keccak256(abi.encodePacked(string1)) == _msg;
    }

    /**
     * @dev 测试哈希函数的强抗碰撞性
     * @param string1 第一个字符串
     * @param string2 第二个字符串
     * @return bool 返回两个字符串的哈希是否相同
     * 强抗碰撞性：难以找到任意两个不同的输入产生相同的哈希
     */
    function strong(
        string memory string1,
        string memory string2
    ) public pure returns (bool) {
        return
            keccak256(abi.encodePacked(string1)) ==
            keccak256(abi.encodePacked(string2));
    }
}

// 什么是 hash 哈希函数?

// 哈希函数（hash function）是一个密码学概念。

// 哈希函数（hash function）可以 将 任意长度的消息 转换为 一个固定长度的值，这个值 也称作 哈希（hash）。

// 上面介绍了 如何使用 Solidity 最常用的 哈希函数 keccak256()
