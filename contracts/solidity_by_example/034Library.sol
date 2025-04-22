// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) public pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) public pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) public pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

// 如何使用 库合约

contract UseLibrary{

    // 1、利用 using for 指令  来使用 库合约  
    using Strings for uint256;

    function getString1(uint256 _number) public pure returns (string memory){

        // 库合约中的函数 会自动添加为 uint256类型变量 的 成员
        return _number.toHexString();
    }

    // 2、通过 库合约名称 调用函数  来使用 库合约
    function getString2(uint256 _number) public pure returns (string memory){

        return Strings.toHexString(_number);
    }

}

// 部署 UseLibrary合约 并输入 170 测试一下，两种方法 均能返回 正确的 16进制string “0xaa”。证明我们调用库合约成功！



// 数学计算库：提供常用的数学运算功能
library MathLibrary {
    // 安全加法：防止溢出
    function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "MathLibrary: addition overflow");
        return c;
    }
    
    // 安全减法：防止下溢
    function safeSub(uint256 a, uint256 b) public pure returns (uint256) {
        require(b <= a, "MathLibrary: subtraction underflow");
        return a - b;
    }
    
    // 计算百分比：返回数值的百分比
    // @param value 原始数值
    // @param percentage 百分比（0-100）
    function calculatePercentage(uint256 value, uint8 percentage) public pure returns (uint256) {
        require(percentage <= 100, "Percentage must be between 0 and 100");
        return (value * percentage) / 100;
    }
    
    // 判断是否为偶数
    function isEven(uint256 number) public pure returns (bool) {
        return number % 2 == 0;
    }
}

// 数组操作库：提供数组相关的操作
library ArrayLibrary {
    // 查找数组中的最大值
    function findMax(uint256[] memory arr) public pure returns (uint256) {
        require(arr.length > 0, "Array must not be empty");
        uint256 maxValue = arr[0];
        for (uint256 i = 1; i < arr.length; i++) {
            if (arr[i] > maxValue) {
                maxValue = arr[i];
            }
        }
        return maxValue;
    }
    
    // 计算数组平均值
    function average(uint256[] memory arr) public pure returns (uint256) {
        require(arr.length > 0, "Array must not be empty");
        uint256 sum = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            sum = MathLibrary.safeAdd(sum, arr[i]);  // 使用安全加法
        }
        return sum / arr.length;
    }
}

// 示例合约：展示如何使用库合约
contract MathOperations {
    // 使用using for语法，将库函数附加到uint256类型
    using MathLibrary for uint256;
    // 将库函数附加到uint256[]类型
    using ArrayLibrary for uint256[];
    
    // 存储一些数值的数组
    uint256[] private numbers;
    
    // 添加数字到数组
    function addNumber(uint256 number) public {
        numbers.push(number);
    }
    
    // 方式1：通过类型直接调用库函数
    function calculateSum(uint256 a, uint256 b) public pure returns (uint256) {
        return a.safeAdd(b);  // 使用MathLibrary的safeAdd函数
    }
    
    // 方式2：通过库名调用函数
    function calculateDifference(uint256 a, uint256 b) public pure returns (uint256) {
        return MathLibrary.safeSub(a, b);  // 直接使用库名调用
    }
    
    // 获取数组最大值
    function getMaxNumber() public view returns (uint256) {
        return numbers.findMax();  // 使用ArrayLibrary的findMax函数
    }
    
    // 获取数组平均值
    function getAverage() public view returns (uint256) {
        return ArrayLibrary.average(numbers);  // 直接使用库名调用
    }
    
    // 计算某个数的百分比
    function getPercentage(uint256 value, uint8 percentage) public pure returns (uint256) {
        return MathLibrary.calculatePercentage(value, percentage);
    }
}