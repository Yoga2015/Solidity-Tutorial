// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// 第1种 ：通过 源文件 相对位置 import
import "./Utils.sol";

import "./Yeye.sol";

// 第2种 ：通过 ‘全局符号’ 导入 特定的合约
import {Yeye} from "./Yeye.sol";

// 第3种 ：通过 网址 导入 网上的合约
// import 'https://github.com/Yoga2015/Solidity-Tutorial/blob/main/contracts/solidity_by_example/Yeye.sol';

// 第4种：通过 npm 的目录 导入
// import '@openzeppelin/contracts/access/Ownable.sol';

contract Import {
    // 成功导入 AddressYeye库
    using Utils for address;

    // 声明 yeye变量
    Yeye yeye = new Yeye();

    // 测试 是否 调用 yeye 的 函数
    function test() external {
        yeye.hip();
    }
}

// 利用 import关键字 导入 外部源代码 的 方法。
// 通过 import 关键字，可以引用 我们写的 其他文件中的合约 或者 函数，也可以直接 导入别人写好的代码，非常方便。
