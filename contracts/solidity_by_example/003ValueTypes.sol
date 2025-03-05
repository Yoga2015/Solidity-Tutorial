// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// 原始数据类型 / 基本数据类型
contract ValueTypes {
    // 布尔型
    bool public _bool = true; // bool 是 solidity 中 的 布尔型 逻辑符号（true/false）, 初始默认值 是 false

    // 布尔运算
    bool public _bool1 = !_bool; // 取非   _bool1 是 _bool 的 非，为 false；

    bool public _bool2 = _bool && _bool1; // 与     _bool && _bool1 为  false；

    bool public _bool3 = _bool || _bool1; // 或     _bool || _bool1 为  true；

    bool public _bool4 = _bool == _bool1; // 相等   _bool == _bool1 为  false；

    bool public _bool5 = _bool != _bool1; // 不相等 _bool != _bool1 为  true。

    // int 有符号整数 类型 ：仅表示 正整数、负整数 和 零。       int8、int16、int256

    int public intOne = 0; // 在Solidity 中 声明 int类型 的 变量 时，不指定位数 就 默认为 int256，int256 的取值范围是 -2^255 到 2^255 - 1

    // int8 的 取值范围 从 -128 到 127。
    int8 public int8one = -128;
    int8 public int8two = 27;
    int8 public int8three = 127;
    // int8 public int8Four = -125.4;   // 编译错误： int8 不能为 浮点数 或 小数，因为 只能是 负整数
    // int8 public int8Five = 0.13;     // 编译错误： int8 不能为 浮点数 或 小数，因为 只能是 正整数
    // int8 public int8Six = -129;     // 编译错误：  因为超出了  int8 的 取值范围 ： -128 到 127

    int16 public int16one = -32768; // int16 的 取值范围 从 -32768 到 32767。
    int16 public int16two = 0;
    int16 public int16three = 32767;
    // int16 public int16Four = -32767.3;   // 编译错误： int16 不能为 浮点数 或 小数，因为 只能是 负整数
    // int16 public int16Five = 0.13;       // 编译错误： int16 不能为 浮点数 或 小数，因为 只能是 正整数
    // int16 public int16Six = -32769;     // 编译错误：  因为超出了  int16 的 取值范围 ： -32769 到 32767

    // int256 的 取值范围 从 -2^255 到 2^255 - 1。
    int256 public int256one =
        -57896044618658097711785492504343953926634992332820282019728792003956564819968;
    int256 public int256Two = 0;
    int256 public int256Three =
        57896044618658097711785492504343953926634992332820282019728792003956564819967;

    // int256 public int256Four = -57896044618658097711785492504343953926634992332820282019728792003956564819969;  // 报错：超出了 int256 的 取值范围
    // int256 public int256Five = 0.13;       // 编译错误：  因为只能是 正整数
    // int256 public int256Six = -0.13;       // 编译错误：  因为只能是 负整数
    // int256 public int256Seven = 57896044618658097711785492504343953926634992332820282019728792003956564819968;  // 报错：超出了 int256 的 取值范围

    // uint 无符号整数 类型  ：仅表示 正整数、 零。      uint8、uint16、uint256

    uint public uintOne = 99; // 在Solidity 中 声明 uint类型 的 变量 时，不指定位数 就 默认为 uint256 , uint256 的取值范围是 0 到 2^256 - 1

    // uint8 的 取值范围 从  0 到 255。
    uint8 public uint8One = 0;
    uint8 public uint8Two = 255;

    // uint8 public uint8Three = -8;      // 编译错误： uint8 不能为 负数，因为只能是 正整数
    // uint8 public uint8Four = 0.16;     // 编译错误： uint8 不能为 浮点数 或 小数，因为只能是 正整数
    // uint8 public uint8Five = 256;      // 编译错误： 超出了  uint8 的 取值范围 ： -128 到 127

    // uint16 的 取值范围 从  0 到 65535。
    uint16 public uint16One = 0;
    uint16 public uint16Two = 65535;

    // uint16 public uint16Three = -3;        // 编译错误： uint16 不能为 负数，因为只能是 正整数
    // uint16 public uint16Four = 0.34;       // 编译错误： uint16 不能为 浮点数 或 小数，因为只能是 正整数
    // uint16 public uint16Five = 65536;      // 编译错误： 因为 超出了 uint16 的 取值范围 ： -128 到 127

    // uint256 的取值范围是 0 到 2^256 - 1
    uint256 public uint256One = 0; // uint256 是 非负整数类型 ，取值范围 从 0  到 2^256-1 （非常大的数）
    uint256 public uint256Two =
        115792089237316195423570985008687907853269984665640564039457584007913129639935;

    // uint256 public uint256Three = -78;      // 编译错误： uint256 不能为 负数，因为只能是 正整数
    // uint256 public uint256Four = 0.34;      // 编译错误： uint256 不能为 浮点数 或 小数，因为只能是 正整数
    // uint256 public uint256Five = 115792089237316195423570985008687907853269984665640564039457584007913129639936;  // 报错：超出了 uint256 的 取值范围 ： -128 到 127

    // 地址类型 :

    // 1、普通地址（address）: 存储一个 20 字节的值（以太坊地址的大小）。

    // 2、payable address   : 比普通地址多了 transfer 和 send 两个成员方法，用于接收转账。

    address public addr1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; // address 是 地址

    address payable public addr2 = payable(addr1); // payable address，可以转账、查余额

    uint256 public balance = addr1.balance; // balance of address

    // 字节数组：

    // 固定长度的字节数组

    bytes32 public _byte32 = "MiniSolidity"; // bytes32: 0x4d696e69536f6c69646974790000000000000000000000000000000000000000

    bytes1 public _byte = _byte32[0]; // bytes1: 0x4d

    // 字符串类型 string

    string public str = "this is a string data type";

    // 枚举 enum

    // 用 enum 将 uint 0， 1， 2 表示为 Buy, Hold, Sell
    enum ActionSet {
        Buy,
        Hold,
        Sell
    }

    // 创建 enum变量 action
    ActionSet action = ActionSet.Buy;

    // enum可以和uint显式的转换
    function enumToUint() external view returns (uint) {
        return uint(action);
    }
}
