// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Constants {

    // 一、constant 的 合法使用
    // 1. 基础值类型常量
    uint256 public constant MAX_UINT = type(uint256).max;    // uint256最大值
    uint256 public constant MIN_UINT = type(uint256).min;    // uint256最小值
    uint256 public constant MAX_VALUE = 100;                 // 自定义上限值
    
    // 2. 地址类型常量
    address public constant DEAD_ADDRESS = address(0);                             // 零地址
    address public constant OWNER = 0x1234567890123456789012345678901234567890;   // 固定地址
    
    // 3. 字符串和字节常量
    string public constant NAME = "MyContract";                    // 合约名称
    string public constant VERSION = "1.0.0";                     // 版本号
    bytes32 public constant HASH = keccak256("MyContract");       // 哈希值
    bytes32 public constant DOMAIN_SEPARATOR = keccak256(abi.encodePacked(NAME, VERSION));  // 域分隔符
    
    // 4. 数值常量
    uint256 public constant DECIMALS = 18;           // 精度
    uint256 public constant INITIAL_SUPPLY = 1000;   // 初始供应量
    uint256 public constant FEE_RATE = 100;         // 费率（基点）
    
    // 5. 时间常量
    uint256 public constant SECONDS_PER_DAY = 24 * 60 * 60;         // 一天的秒数
    uint256 public constant SECONDS_PER_WEEK = 7 * SECONDS_PER_DAY;  // 一周的秒数
    
    // 6. 固定大小数组常量（合法）
    bytes4 public constant TRANSFER_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
    

    // 7. 常量使用示例
    function getMaxValue() public pure returns (uint256) {
        return MAX_VALUE;
    }
    
    function isDeadAddress(address _addr) public pure returns (bool) {
        return _addr == DEAD_ADDRESS;
    }
    
    function getDomainSeparator() public pure returns (bytes32) {
        return DOMAIN_SEPARATOR;
    }
    
    
    // 二、constant 的 非法使用

    // uint256[] public constant VALUES = [1, 2, 3];      // 非法：动态大小的数组

    // mapping(address => uint256) public constant BALANCES;      // 非法：映射

    // 非法：结构体
    // struct User {
    //     uint256 id;
    //     string name;
    // }

    // User public constant USER = User(1, "Alice");

    // constant 变量 必须在 声明的时候 初始化，之后再也不能改变。尝试改变的话，编译不通过。
    uint256 constant Num = 10;

    uint public constant My_uint = 456;

    // function mod() public {      // 尝试改变的话，编译不通过。

    //     Num = 22;

    //     My_uint = 789;

    // }
}

// 在 Solidity 中，Constant 是 状态变量 的 修饰符，专用于 定义 状态变量
// constant 通常用于 定义 不会改变的 常量。
// constant 常量 的 命名 是 首字母 需大写的。
// constant 常量 必须 在 声明 时 并 初始化，之后 再也不能改变。
// 即：constant 变量的值 必须在 声明时 确定，且在 合约部署后 不可更改。尝试改变的话，会编译不通过。
