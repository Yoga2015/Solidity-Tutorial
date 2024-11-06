// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// NestedMapping 合约中 定义了 一个 嵌套的 映射 数据结构，用于存储 地址 与 代币余额 之间 的 关系。
contract NestedMapping {

  // 声明一个 公开 的 嵌套映射，允许 外部访问 和 查询余额信息 。
  // 其中 外层映射 的 键 是 地址类型（address）， 代表 代币 的 所有者 ； 值 是 一个映射 ，是 一个内部映射，
  // 该 内部映射 的 键 是 字符串类型，代表 代币的名称 或 标识符，而 值 是 无符号的256位整数类型，代表 代币的余额 。 
  mapping(address => mapping(string => uint256)) public balances; 

  // 定义 setBalance函数, 允许 外部调用者 设置 或 更新 特定地址 和 代币名称 的 余额。 (通过 嵌套映射的键 直接设置 余额值)
  // setBalance函数 接收 的 参数 一一对应 上面的 嵌套映射 的 结构 
  //      ownerValue（address）：代币的所有者地址。
  //      tokenValue（string memory）：代币的名称或标识符。
  //      amountValue（uint256）：要设置的余额数量。
  function setBalance(address ownerValue, string memory tokenValue, uint256 amountValue) public { 

    balances[ownerValue][tokenValue] = amountValue; 
  } 

  // 定义 getBalance函数  允许 外部调用者 查询（获取） 特定地址 和 代币名称 的 余额
  // getBalance函数 接收 的 参数 ：
  //      ownerValue（address）：代币的所有者地址。
  //      tokenValue（string memory）：代币的名称 或 标识符。
  function getBalance(address ownerValue, string memory tokenValue) public view returns (uint256) { 

    return balances[ownerValue][tokenValue]; 
  } 

  // 定义 构造函数 用于 在合约部署时 初始化 一些示例数据， 实现 通过 setBalance函数 为 两个示例地址 分别设置了 两种代币的余额
  constructor() { 

    // 假设有 两个地址 和 两种代币  
    address owner1 = 0x32E649d3385182b41aebbDD58032B3939BCbA53B; // 示例地址1  
    address owner2 = 0xA5d68CE183B2bdCC48Fa283D55Bb4E1EdbA67F43; // 示例地址2  
    string memory tokenA = "TokenA"; 
    string memory tokenB = "TokenB"; 
    
    // 为两个地址分别设置代币A和代币B的余额  
    setBalance(owner1, tokenA, 100); 
    setBalance(owner1, tokenB, 200);
    setBalance(owner2, tokenA, 50); 
    setBalance(owner2, tokenB, 150); 

  } 

}