// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 构造函数的继承  :  子合约 有两种方法 继承 父合约的构造函数 :

abstract contract AA{

    uint public a;

    constructor(uint _a){
        a = _a;
    }

}

// 合约AA 里面有一个状态变量a，并由 构造函数的参数 来确定，


// 1、子合约B  继承 父合约AA 时 声明 父构造函数 的 参数，例如：contract B is A(1)
contract B is AA(1){}


// 2、子合约C  继承 父合约AA 后，在 子合约 的 构造函数中 声明 构造函数的参数
contract C is AA {

    constructor(uint _c) AA(_c * _c) {}

}




 

