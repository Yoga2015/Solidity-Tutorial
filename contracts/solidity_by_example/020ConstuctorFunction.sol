// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 基础构造函数示例
contract MyContract {

    address public owner;

    // 构造函数 ：用来 初始化合约 的 owner地址
    constructor() {
        owner = msg.sender; // 将 合约的创建者 设置为 所有者
    }
}

// 上面示例中，构造函数 将 合约的创建者（msg.sender）的地址 赋值给 owner变量。这个操作 只在合约部署时 执行一次。


// 带参数的构造函数示例
contract ConsturctorFunction {

    address public owner;
    string public name;
    uint256 public value;
    bool public locked;

    // 构造函数可以接收多个参数
    constructor(string memory _name,uint256 _value,bool _locked) {
        owner = msg.sender;
        name = _name;
        value = _value;
        locked = _locked;
    }

    // 检查调用者是否为所有者
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // 更新合约参数的函数
    function updateSettings(string memory _name,uint256 _value,bool _locked) public onlyOwner {
        name = _name;
        value = _value;
        locked = _locked;
    }

    // 获取合约信息
    function getContractInfo() public view returns (address _owner,string memory _name,uint256 _value,bool _locked) {
        return (owner, name, value, locked);
    }  
}


// 支付构造函数示例
contract PayableConstructor {
    
    address public owner;
    uint256 public balance;

    // payable 构造函数可以在部署时接收 ETH
    constructor() payable {
        owner = msg.sender;
        balance = msg.value;
    }

    // 获取合约余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
 // owner 被初始化为 部署合约的钱包地址。
// 什么是constructor
// Solidity 的 constructor 构造函数，与 许多其他编程语言（如Java、Go、Python等）中的 构造函数 不同，
// Solidity 的 构造函数 不会在 每次实例化对象时 执行。相反，它只在 合约部署 到 区块链上时 执行一次。
// 这是 因为 智能合约 在区块链上 是唯一的，一旦部署，其代码和状态就不可更改（除非通过升级合约等高级操作）。
// Solidity中 的 构造函数代码 只有在 合约创建时 运行一次 ：即 在 部署合约  时 自动运行一次。
// 以后，在 合约的生命周期 内，构造函数 不会再次 运行。

// 每个 智能合约 都可以 定义 一个构造函数，构造函数 没有 返回值，构造函数 不能被 其他合约 继承 或 覆盖。

// 构造函数的用途
// 构造函数 通常用于 设置 合约的初始状态，例如：
// - 初始化 合约的所有者地址  （owner地址）。
// - 设置 合约 的 初始余额 或 资产。
// - 配置 合约的某些参数 或 设置。
