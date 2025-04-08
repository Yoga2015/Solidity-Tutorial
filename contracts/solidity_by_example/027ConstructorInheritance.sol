// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 构造函数的继承  :  子合约 有两种方法 继承 父合约的构造函数 :

abstract contract AA{

    // 声明一个公共状态变量
    uint public a;
    
    // 基础构造函数，接收一个参数来初始化状态变量a
    constructor(uint _a) {
        a = _a;
    }

}

// 合约AA 里面 有一个状态变量a，并由 构造函数的参数 来确定，

// 第一种继承方式：在继承声明时 直接传入 构造函数参数 （子合约B  继承 父合约AA 时 声明 父构造函数 的 参数，例如：contract B is A(1)）
contract B is AA(1) {
    // 合约B直接在继承时传入固定值1作为父构造函数的参数
}

// 第二种继承方式：通过 子合约的构造函数 传递 参数   （子合约C  继承 父合约AA 后，在 子合约C 的 构造函数中 声明 构造函数的参数）
contract C is AA {
    // 合约C的构造函数接收参数并传递给父构约构造函数
    // 这里对传入的参数进行了平方处理
    constructor(uint _c) AA(_c * _c) {}
}





