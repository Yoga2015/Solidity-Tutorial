// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;  
  
contract StorageVariableDataStorageLocation {  

    uint256 public count;    // count 是一个 状态变量，用于存储一个计数器。


    // increment 函数 用于 更新 计数器 的 值  
    function increment() public {  

        count += 1; // 更新状态变量，增加计数器  

    }  
    
    // getCount 函数  用于 返回 计数器 的 当前值
    function getCount() public view returns (uint256) {  

        return count; // 返回状态变量的值  
        
    }  
}