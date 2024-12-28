// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract intDemo {
    // int 是 integer 的 缩写 ，在Solidity中 代表 有符号整数类型，它可以存储 正整数 和 负整数 。

    // 声明 int类型 的 变量 时，可以指定位数（如int8、int16、int32、int64、int128、int256等），也可以 不指定位数（不指定 就默认为 int256）。

    int8 smallNumber = 10;

    int largeNumber; // 默认为int256类型

    int8 public int8One = -128; // int8 , 8位有符号整数 的 取值范围 从 -128 到 127
    int8 public int8Two = 0;
    int8 public int8Three = 127;

    int16 public int16One = -32768; // int16 , 16位有符号整数 的 取值范围 从 -32768 到 32767。
    int16 public int16Two = 0;
    int16 public int16Three = 32767;

    int32 public int32One = -2147483648; // int32 , 32位有符号整数 的 取值范围 从 -2147483648 到 2147483647
    int32 public int32Two = 0;
    int32 public int32Three = 2147483647;

    int64 public int642One = -9223372036854775808; // int64 , 64位有符号整数 的 取值范围 从 -9223372036854775808 到 9223372036854775807
    int64 public int64Two = 0;
    int64 public int64Three = 9223372036854775807;

    // 注意：Solidity中 并没有 直接定义int128的标准类型，但可以通过其他方式实现类似功能（如使用库）

    int256 public int256One = 0; // int256， 256位有符号整数，取值范围 非常大，适用于大多数智能合约需求 。
    int256 public int256Two = 256;
}

contract IntExample {
    int8 public smallInt;
    int16 public mediumInt;
    int32 public largeInt;
    int64 public biggerInt;
    int256 public maxInt;

    function setInts(
        int8 _smallInt,
        int16 _mediumInt,
        int32 _largeInt,
        int64 _biggerInt,
        int256 _maxInt
    ) public {
        smallInt = _smallInt;
        mediumInt = _mediumInt;
        largeInt = _largeInt;
        biggerInt = _biggerInt;
        maxInt = _maxInt;
    }

    function getInts() public view returns (int8, int16, int32, int64, int256) {
        return (smallInt, mediumInt, largeInt, biggerInt, maxInt);
    }
}
