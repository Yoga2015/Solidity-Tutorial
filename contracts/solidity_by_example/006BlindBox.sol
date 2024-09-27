// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 在 盲盒合约 中，可以使用 数组 来存储 盲盒中的奖品信息 或 用户的购买记录。
contract BlindBox{

    // 假设 盲盒奖品 是 一个 结构体，包含 奖品ID 和 数量
    struct Prize{
       uint id;
       uint amount;
    }

    // 使用 动态数组 存储 奖品 信息
    Prize[] public prizes;

    // 初始化 奖品 信息
    constructor(){
      prizes.push(Prize(1,99));   // 添加 一个奖品ID 为 1 ， 数量 为 99 的 奖品
      prizes.push(Prize(2,50));   // 添加 一个奖品ID 为 2 ， 数量 为 50 的 奖品
    }

    // 用户购买 盲盒的 函数 （简化版）
    function buyBox()  external {
      
      // 假设 逻辑判断 用户 是否 有资格购买，随机选择 奖品 等
      // ...

      // 假设 用户 获得了 一个奖品
      uint prizeIndex = 0; // 假设 通过 某种逻辑 确定了 奖品索引

      if(prizes[prizeIndex].amount > 0){

        // 减少 奖品数量
        prizes[prizeIndex].amount--;

        // 发放奖品给用户（此处省略发放逻辑）  
        // ... 

      }

    }

}