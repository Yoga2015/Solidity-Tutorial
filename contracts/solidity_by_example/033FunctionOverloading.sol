// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract functionOverLoading{

    function saySomething() public pure returns(string memory){

        return ('Nothing');
    }

    function saySomething(string memory something)  public pure returns(string memory){

        return (something);
    }

    // 上面定义 两个 都叫 saySomething() 的 函数：一个 没有任何参数，输出 "Nothing"，另一个 接收一个 string参数，输出 这个 string
    // 最终 重载 函数 在经过编译器 编译后，由于 不同的 参数类型，都变成了 不同的 函数选择器（selector）



    // 在调用重载函数时，会把输入的实际参数和函数参数的变量类型做匹配。 如果出现多个匹配的重载函数，则会报错。

    // 下面这个例子 有两个 叫 f() 的函数，一个参数 为 uint8，另一个 为 uint256：

    function f(uint8 _in) public pure returns (uint8 out){

        out = _in;
    }

    
    function f(uint256 _in) public pure returns (uint256 out){

        out = _in;
    }

    // 我们调用f(50)，因为 50 既可以被转换为 uint8，也可以被转换为 uint256，因此会报错。

}

// Solidity中函数重载的基本用法：名字相同但输入参数类型不同的函数可以同时存在，他们被视为不同的函数。



