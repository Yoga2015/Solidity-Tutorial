// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Yeye{

    event Log(string msg);

    // 定义3个 function：hip()  , pop() , man()  , log值 为 Yeye
    function hip() public virtual{
        emit Log('Yeye');
    }

    function pop() public virtual{
        emit Log('Yeye');
    }

    function yeye() public virtual {
        emit Log('Yeye');
    }

}

contract Baba is Yeye{

    // 继承 两个 function : hip() 和 pop(), 输出改为 Baba
    function hip() public virtual override {
        emit Log('Baba');
    }

    function pop() public virtual override {
        emit Log('Baba');
    }

    function baba() public virtual{
        emit Log('Baba');
    }
}

// 调用父合约的函数: 子合约 有两种方式 调用 父合约的函数： (1)直接调用、 (2)利用super关键字。

contract Erzi is Yeye,Baba{

    // 继承 两个 function： hip() 和 pop() 
    function hip() public override(Yeye,Baba){
        emit Log('Erzi');
    }

    function pop() public override(Yeye,Baba){
         emit Log('Erzi');
    }

    // 1、直接调用：子合约 可以直接用 父合约名.函数名() 的方式 来调用父合约函数，例如 Yeye.pop()
    function callParent() public{
        Yeye.pop();
    }

    // 2、super关键字：子合约可以利用 super.函数名() 来调用 最近的父合约函数 。
    // Solidity 继承关系 按声明时 从右到左 的顺序是：contract Erzi is Yeye, Baba，那么 Baba 是 最近的父合约，super.pop()将调用 Baba.pop()，而不是Yeye.pop()
    function callParentSuper() public {
        super.pop();
    }

}
