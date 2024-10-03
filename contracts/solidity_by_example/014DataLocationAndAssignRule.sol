// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract dataLocationAndAssignRule{

    uint[] public arr; // arr状态变量，存储在storage中  
  
    constructor() {  
        arr = [1, 2, 3]; // 初始化状态变量  
    }  
    
    // 在modifyMemoryArray函数中，tempArr是arr的一个副本，存储在memory中。对tempArr的修改不会影响arr。
    function modifyStorageArray(uint[] storage _arr) internal {  

        _arr[0] = 100; // 修改storage数组，会影响原数组  

    }  
    
    // modifyStorageArray函数 接受 一个storage类型的数组 作为 参数，并对 其 进行修改。
    // 由于 它是 直接引用 传入的 storage数组，所以修改 会影响 原数组。
    function modifyMemoryArray() public view {  

        uint[] memory tempArr = arr; // 创建arr的副本，存储在memory中  
        tempArr[0] = 200; // 修改memory数组，不会影响原数组  
  
        // 调用 内部函数 修改 storage数组  
        modifyStorageArray(arr);  
  
        // 此时，arr[0]的值 已经变为 100  
    }  
    

    uint[] x = [1,2,3];    // x状态变量，存储在storage中 

    function fStorage() public {

        // 声明一个 storage的变量 xStorage ，指向 x， 修改 xStorage 也会影响 x
        uint[] storage xStorage = x;

        xStorage[0] = 200;
        
    }
}