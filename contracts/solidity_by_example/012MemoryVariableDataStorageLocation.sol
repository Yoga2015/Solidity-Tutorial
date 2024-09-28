// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;  
  
contract MemoryVariableDataStorageLocation {  

    // 假设有一个简单的结构体  
    struct MyStruct {  
        uint a;  
        uint b;  
    }  
  
    // myFunction函数，展示 如何 在memory中 使用结构体  
    function myFunction() public pure returns (MyStruct memory) {  

        // 在内存中 创建 一个新的结构体 实例  
        MyStruct memory newStruct = MyStruct(1, 2);  

        // 修改 内存中的数据  
        newStruct.a = 3;  

        // 返回 内存中的结构体实例（注意：这里返回后，newStruct 占用的内存 将在 函数返回后 被释放）  
        return newStruct;  

    }  
}

// 在 Solidity 中， memory 是指  用于 函数内部  临时  数据存储 的 内存位置。

// memory 一般应用于 函数内部 的 局部变量 和 参数，特别是 当 这些变量 是 复杂数据类型（如数组、结构体等）时。

// 上面例子中，newStruct 是一个 在内存中 创建 的 结构体实例，它只在 myFunction函数 执行期间 存在。

// myFunction函数 执行完毕 后，newStruct 占用的内存 就会 被释放。

// 因此，如果需要 保留 newStruct 这些数据 以供 后续使用，应考虑 将 其 存储在 storage中 或 作为 函数的返回值 返回。