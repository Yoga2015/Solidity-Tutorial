// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;  
  
contract StorageVariableDataStorageLocation {  

    // storage类型 状态变量  应该 在合约的顶部 声明，以确保 在整个合约范围内 都是 可访问的。
    
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

// 在Solidity中，storage类型 是一种 用于在区块链上 永久存储数据的机制，也指  永久存储在 区块链上 的 数据存储方式。

// 当 一个变量 被声明为 Storage类型 时，它的值 将被 存储在 合约的存储空间中 （链上） 。

// storage类型  主要用于 存储 合约的状态变量，用于 声明 永久存储在 区块链上 的 数据（ 合约的状态变量 ) 。

// 这些 storage类型 的 状态变量 在合约的 整个生命周期内 都是 可访问的，并且 其状态的更改 会永久记录在  区块链 上。

// 注意：将 storage（合约的状态变量）赋值 给 本地storage（函数里的）变量 时 ，会创建引用，改变 新变量 会影响 原变量