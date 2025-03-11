// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Solidity 函数输出，包括：返回多种变量，命名式返回，以及利用解构式赋值读取全部或部分返回值。
contract FunctionOutput {


   // 1. 基础返回值示例 ： 使用 return 关键字返回值
    function returnSingle() public pure returns (uint) {
        uint number = 5;
        return number; // 最基本的返回单个值
    }

    // 2. 返回多个值示例 ： 返回多个值需要用括号 （）包裹
    function returnMultiple() public pure returns (uint, bool, string memory) {
        uint num = 100;
        bool flag = true;
        string memory text = "Hello";
        return (num, flag, text); // 返回多个值需要用括号 （）包裹
    }

    // 3、命名式返回：在函数声明时就指定返回变量的名称，可以不使用 return 语句，函数会自动返回这些命名变量
    function returnNamed() public pure returns (uint256 _number,bool _bool,uint256[3] memory _array){          

        // 方式一：命名式返回
        // _number = 2;
        // _bool = false;
        // _array = [uint256(3),7,4];

        // 方式二：命名式返回，依然支持return
        return (2,false,[uint256(3),7,4]);
    }


    function returnNamed2() public pure returns (uint sum,bool isSuccess,string memory message) {

        sum = 200;         // 直接给返回变量赋值
        isSuccess = true;  // 直接给返回变量赋值
        message = "Done";  // 直接给返回变量赋值
        // 命名返回可以不使用 return 语句，函数会自动返回命名的变量
    }

     // 4. 解构式赋值示例
    function destructuringAssignments() public pure {
        // 4.1 接收全部返回值
        uint a;
        bool b;
        string memory c;
        (a, b, c) = returnMultiple();

        // 4.2 只接收部分返回值（忽略不需要的返回值）
        uint x;
        (x, , ) = returnMultiple(); // 只获取第一个返回值，忽略后两个

        // 4.3 交换两个变量的值
        uint first = 1;
        uint second = 2;
        (first, second) = (second, first);
    }

    // 5. 返回数组示例
    function returnArray() public pure returns (uint[] memory) {
        
        uint[] memory arr = new uint[](3);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        return arr;
    }

    // 6. 实际应用示例：计算数组的多个统计值并返回
    function calculateStats(uint[] memory numbers) public pure returns (uint sum,uint average,uint largest) {

        require(numbers.length > 0, "Array must not be empty");
        
        largest = numbers[0];

        for(uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
            if(numbers[i] > largest) {
                largest = numbers[i];
            }
        }

        average = sum / numbers.length;  
        
    }
}

    // 返回值： return 和  returns
    // - returns：跟在 函数名 后面，用于 声明 返回的变量类型 及 变量名。
    // - return： 用于 函数主体 中，返回 指定 的 变量。

    // 1. 当返回值较多时，建议使用命名返回值，提高代码可读性
    // 2. 使用解构式赋值时，可以用逗号跳过不需要的返回值
    // 3. 返回数组时要注意内存（memory）的使用
    // 您可以在 Remix 中部署这个合约，尝试调用不同的函数来理解各种返回值的使用方式。
