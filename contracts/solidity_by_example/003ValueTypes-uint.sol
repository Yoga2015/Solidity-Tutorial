// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract uintDemo {
    // uint 是  unsigned integer 的 缩写，在Solidity中 代表  无符号整数类型 ， 它可以存储 正整数 和 零  。

    // “无符号” 意味着 这些整数 只能是 正数 或 零，不能是 负数 ！！

    // uint  无符号整数类型  可以表示 正整数 、 零。

    // 声明 uint 类型 的 变量 时，通过 指定位数（如 uint8、uint16、uint32、uint64、uint256 等）
    // 来确定 变量 能够存储 的 数值范围。也可以 不指定位数（不指定 就默认为 uint256）。

    uint8 smallNumber = 10;

    uint largeNumber; // 默认为 uint256 类型

    uint8 public uint8One = 0; // uint8 , 8位无符号整数 的 取值范围 从 0 到  255
    uint8 public uint8Two = 99;
    uint8 public uint8Three = 255;

    uint16 public uint16One = 0; // uint16 , 16位无符号整数 的 取值范围 从 0 到 65535
    uint16 public uint16Two = 199;
    uint16 public uint16Three = 65535;

    uint32 public uint32One = 0; // uint32 , 32位无符号整数 的 取值范围 从 0 到 4294967295
    uint32 public uint32Two = 8888;
    uint32 public uint32Three = 4294967295;

    uint64 public int642One = 0; // uint64 , 64位无符号整数 的 取值范围 从 0 到 18446744073709551615
    uint64 public int64Two = 777777;
    uint64 public int64Three = 18446744073709551615;

    // 声明一个128位无符号整数（注意：Solidity 0.8.x 不直接支持 uint128，但可以通过自定义实现或使用其他库）
    // uint128 veryBigNumber; // 这行在Solidity 0.8.x中会报错，需要自定义或使用库

    uint256 public int256One = 0; // uint256， 256位无符号整数，取值范围 非常大，适用于大多数智能合约需求 。
    uint256 public int256Two = 918446744073709551615;
}

contract UintExample {
    uint8 smallNumber;
    uint16 mediumNumber;
    uint32 largeNumber;
    uint64 biggerNumber;
    uint256 hugeNumber;

    // 构造函数，用于初始化变量
    constructor() {
        smallNumber = 250;
        mediumNumber = 30000;
        largeNumber = 2147483647; // 赋值一个接近32位整数上限的数
        biggerNumber = 9223372036854775807; // 赋值一个接近64位整数上限的数
        hugeNumber = 115792089237316195423570985008687907853269984665640564039457584007913129639935; // 赋值一个大数
    }

    // 一个简单的函数，用于展示 变量的值
    function showNumbers()
        public
        view
        returns (uint8, uint16, uint32, uint64, uint256)
    {
        return (
            smallNumber,
            mediumNumber,
            largeNumber,
            biggerNumber,
            hugeNumber
        );
    }
}
