// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract NestedMapping {

    // 声明一个嵌套映射，其中 外层映射 的 键 是 地址类型，值 是 另一个映射  
    // 内部映射 的 键 是 字符串类型，值 是 整型  
    mapping(address => mapping(string => uint256)) public balances;  
  
    //  setBalance 函数 来设置 内部映射中 的 值  
    function setBalance(address ownerValue, string memory tokenValue, uint256 _amount) public {  

        balances[ownerValue][tokenValue] = _amount;  

    }  
  
    // getBalance 函数 来获取 内部映射中 的 值  
    function getBalance(address ownerValue, string memory tokenValue) public view returns (uint256) { 

        return balances[ownerValue][tokenValue];  

    }  
  
    // 示例：在构造函数中初始化一些数据  
    constructor() {  

        // 假设有两个地址和两种代币  
        address owner1 = 0x123...; // 示例地址1  
        address owner2 = 0x456...; // 示例地址2  
        string memory tokenA = "TokenA";  
        string memory tokenB = "TokenB";  
  
        // 为两个地址分别设置代币A和代币B的余额  
        setBalance(owner1, tokenA, 100);  
        setBalance(owner1, tokenB, 200);  
        setBalance(owner2, tokenA, 50);  
        setBalance(owner2, tokenB, 150);  

    }  

}
