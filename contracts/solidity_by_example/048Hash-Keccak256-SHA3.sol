// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract HashKeccak256SHA3 {
    bytes32 _msg = keccak256(abi.encodePacked("OxAA"));

    bytes32 public _temp;

    // 生成数据唯一标识
    function hash(
        uint _num,
        string memory _string,
        address _addr
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_num, _string, _addr));
    }

    // 弱抗碰撞性
    function weak(string memory string1) public view returns (bool) {
        return keccak256(abi.encodePacked(string1)) == _msg;
    }

    // 强抗碰撞性
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
