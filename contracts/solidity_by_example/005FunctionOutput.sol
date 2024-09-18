// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Solidity 函数输出，包括：返回多种变量，命名式返回，以及利用解构式赋值读取全部或部分返回值。
contract FunctionOutput {

   // 返回值： return 和  returns
    // - returns：跟在 函数名 后面，用于 声明 返回的变量类型 及 变量名。
    // - return： 用于 函数主体 中，返回 指定 的 变量。
    function returnMultiple() public pure returns (uint256,bool,uint256[3] memory){

        return (1,true,[uint256(1),6,8]);

    }

    // 命名式返回
    // 可以在 returns 中标明返回变量的名称。Solidity 会初始化这些变量，并且自动返回这些函数的值，无需使用 return。
    function returnNamed() public pure returns (uint256 _number,bool _bool,uint256[3] memory _array){          

        // 命名式返回
        // _number = 2;
        // _bool = false;
        // _array = [uint256(3),7,4];

        // 命名式返回，依然支持return
        return (2,false,[uint256(3),7,4]);

    }

    // 读取返回值，解构式赋值
    function readReturn() public pure {

        // 读取全部返回值
        uint256 _number;
        bool _bool;
        uint256[3] memory _array;
        (_number,_bool,_array) = returnNamed();

        // 读取部分返回值，解构式赋值
        (,_bool,) = returnNamed();

    }
}
