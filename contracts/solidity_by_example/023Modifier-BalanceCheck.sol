// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface  IERC20 {

    function balanceOf(address account) external view returns (uint256);

     // ... 其他ERC20函数  

}

// 检查 账户余额
contract BalanceCheck{

    IERC20 public token;

    constructor(address tokenAddress){

        token = IERC20(tokenAddress);

    }

    // hasEnoughBalance 修饰符，用于 检查 调用者 是否有足够的代币余额
    modifier hasEnoughBalance(uint required){

        require(token.balanceOf(msg.sender) >= required,'Not enough balance');

        _;    // 调用函数体，即： 继续执行 被这个修饰符 修饰的函数 的 剩余部分

    }

    // 需要检查 账户余额 的 函数
    function withDrawTokens(uint amount) public hasEnoughBalance(amount){

        // 函数的实现，减少调用者的代币余额...  

    }   

}