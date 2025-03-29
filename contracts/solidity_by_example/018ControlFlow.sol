// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ControlFlow {
    address public owner;

    uint256 public sValue;

    // （1）在 构造函数 中 使用 控制流
    constructor(uint256 initialValue) {

        if (initialValue > 0) {
            sValue = initialValue;
        } else {
            sValue = 100; // 默认值
        }

        sValue = initialValue > 100 ? initialValue : 100; // 使用三元运算符
    }

    // （2）在 普通函数 中 使用 控制流
    function checkValue(uint256 value) public pure returns (string memory) {
        if (value > 100) {
            return "Value is large";
        } else {
            return "Value is small";
        }
    }

    // （3）在 修饰器 中 使用 控制流
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");

        _; // 继续执行函数体
    }

    // （4）在 循环 中 使用 控制流
    function sumArray(uint256[] memory array2) public pure returns (uint256) {
        uint256 sum = 0;

        for (uint256 i = 0; i < array2.length; i++) {
            sum += array2[i];
        }

        return sum;
    }

    // while循环
    function whileTest() public pure returns (uint256) {
        uint sum = 0;

        uint i = 0;

        while (i < 10) {
            sum += i;
            i++;
        }

        return (sum);
    }

    // do-while循环
    function doWhileTest() public pure returns (uint256) {
        uint sum = 0;

        uint i = 0;

        do {
            sum += i;
            i++;
        } while (i < 10);

        return (sum);
    }

    // continue 和 break 示例
    function processArray(uint256[] memory arr) public pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            // 跳过0值
            if (arr[i] == 0) continue;
            // 如果遇到100则停止
            if (arr[i] == 100) break;
            sum += arr[i];
        }
        return sum;
    }

    // 三元运算符示例
    function max(uint256 a, uint256 b) public pure returns (uint256) {
        return a > b ? a : b;
    }

    // 复杂控制流示例
    function complexFlow(uint256[] memory arr) public pure returns (uint256) {

        uint256 result = 0;

        for (uint256 i = 0; i < arr.length; i++) {

            if (arr[i] == 0) {
                continue;
            } else if (arr[i] > 100) {
                break;
            } else {
                result += arr[i];
            }

        }

        return result;
    }
}
