// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/* 钻石继承示例：
   God（基类）
   /    \
Adam    Eve（中间层）
   \    /
  people（派生类）
*/

// 基础合约：定义基本事件和虚函数
contract God {

    event Log(string message);   // 定义日志事件，用于记录 函数调用

    // 函数foo：允许子合约重写
    function foo() public virtual {
        emit Log("God.foo called");  // 发出God层级的foo调用日志
    }

    // 函数bar：允许子合约重写
    function bar() public virtual {
        emit Log("God.bar called");  // 发出God层级的bar调用日志
    }
}

// Adam合约：继承自God
contract Adam is God {

    // 重写foo函数，添加Adam层级的日志
    function foo() public virtual override {
        emit Log("Adam.foo called"); // 先记录Adam的调用
        super.foo();                 // 调用父级合约的foo函数
    }

    // 重写bar函数，添加Adam层级的日志
    function bar() public virtual override {
        emit Log("Adam.bar called"); // 先记录Adam的调用
        super.bar();                 // 调用父级合约的bar函数
    }
}

// Eve合约：继承自God
contract Eve is God {
    
    // 重写foo函数，添加Eve层级的日志
    function foo() public virtual override {
        emit Log("Eve.foo called");  // 先记录Eve的调用
        super.foo();                 // 调用父级合约的foo函数
    }

    // 重写bar函数，添加Eve层级的日志
    function bar() public virtual override {
        emit Log("Eve.bar called");  // 先记录Eve的调用
        super.bar();                 // 调用父级合约的bar函数
    }
}

// people合约：同时继承自Adam和Eve，展示钻石继承
contract people is Adam, Eve {

    // 重写foo函数，需要指定所有父合约
    function foo() public override(Adam, Eve) {
        super.foo();  // 调用父级合约链中的foo函数
    }

    // 重写bar函数，需要指定所有父合约
    function bar() public override(Adam, Eve) {
        super.bar();  // 调用父级合约链中的bar函数
    }
}