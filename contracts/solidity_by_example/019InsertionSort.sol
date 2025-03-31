// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract InsertionSort {

    // 声明一个事件，用于记录排序前后的数组
    event SortResult(uint[] beforeSort, uint[] afterSort);
    
    // 简单的插入排序实现
    // memory: 表示数组参数在内存中临时存储 ，pure: 表示函数不读取或修改状态变量
    function simpleSort(uint[] memory arr) public pure returns(uint[] memory) {
        
        // 从第二个元素开始遍历数组（索引1开始）
        for (uint i = 1; i < arr.length; i++) {
            // 保存当前要插入的元素
            uint currentElement = arr[i];
            // 从当前元素的前一个位置开始比较
            uint j = i;
            
            // 当前面的元素大于要插入的元素时，将前面的元素后移
            while (j > 0 && arr[j-1] > currentElement) {
                arr[j] = arr[j-1];    // 将大的元素后移一位
                j--;                   // 继续向前比较
            }
            
            // 找到合适的位置，插入元素
            arr[j] = currentElement;
        }
        
        return arr;
    }
    
    // 带步骤展示的插入排序，帮助理解排序过程
    // 返回每一步排序后的状态
    function sortWithSteps(uint[] memory arr) public pure 
        returns(string[] memory steps, uint[] memory result) {
        
        // 用于存储每一步的描述
        string[] memory steps = new string[](arr.length * 2);
        uint stepCount = 0;
        
        // 记录初始状态
        steps[stepCount++] = "Initial array";
        
        // 开始插入排序
        for (uint i = 1; i < arr.length; i++) {
            uint currentElement = arr[i];
            uint j = i;
            
            // 记录当前要处理的元素
            steps[stepCount++] = string.concat(
                "Processing element: ",
                toString(currentElement)
            );
            
            // 移动元素，为插入腾出位置
            while (j > 0 && arr[j-1] > currentElement) {
                arr[j] = arr[j-1];
                j--;
            }
            
            // 插入元素
            arr[j] = currentElement;
        }
        
        return (steps, arr);
    }
    
    // 检查数组是否已排序的辅助函数
    function isSorted(uint[] memory arr) public pure returns(bool) {

        for (uint i = 1; i < arr.length; i++) {
            if (arr[i] < arr[i-1]) {
                return false;
            }
        }
        return true;
    }
    
    // 辅助函数：将uint转换为string
    function toString(uint value) internal pure returns(string memory) {

        if (value == 0) {
            return "0";
        }
        
        uint temp = value;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint(value % 10)));
            value /= 10;
        }
        
        return string(buffer);
    }
    
    // 测试函数：提供一个简单的测试用例
    function testSort() public pure returns(uint[] memory) {

        // 创建测试数组
        uint[] memory testArray = new uint[](5);
        testArray[0] = 64;
        testArray[1] = 34;
        testArray[2] = 25;
        testArray[3] = 12;
        testArray[4] = 22;
        
        // 返回排序后的数组
        return simpleSort(testArray);
    }
}