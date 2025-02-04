// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IERC20.sol"; // 引入IERC20接口，确保 ERC20合约 实现了该接口定义的所有函数。

// 声明 ERC20合约，并指明它 实现 IERC20接口。
contract ERC20 is IERC20 {
    // 定义 Transfer事件，当 代币 从一个账户 转移到 另一个账户时 触发。
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 定义 Approval事件，当 一个账户 授权 另一个账户 花费 “其”代币时 触发
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // 定义一个映射 balanceOf， 用于存储 每个账户 的 代币余额。
    mapping(address => uint256) public balanceOf; //（ 这行代码 算是 ERC20合约 实现了 IERC20接口 的 balanceOf函数 ）

    // 定义一个嵌套映射 allowance，用于存储 每个账户 授权给 其他账户 的 代币数量。
    mapping(address => mapping(address => uint256)) public allowance; //（ 这行代码 算是 ERC20合约 实现了 IERC20接口 的 allowance函数 ）

    // 定义代币的名称、符号 和 小数位数，这些 都是 全局可访问 的 状态变量
    string public name; // 代币的名称
    string public symbol; // 代币的符号
    uint8 public decimals; // 小数位数       1e18     以太坊 的 decimals 是 V神 定义为18      mina 的 decimals 定义为9

    // 定义 代币的总供应量，这是一个全局可访问的状态变量
    uint256 public totalSupply; //（ 这行代码 算是 ERC20合约 实现了 IERC20接口 的 totalSupply函数 ）

    //  构造函数， 用于 初始化 代币的名称、符号 和 小数位数。
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    // 实现 IERC20中 的 transfer函数 来进行 代币转账逻辑，调用方扣除amount数量代币，接收方增加相应代币。  recipient：接收代币的地址、 amount：要转移的代币数量
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        balanceOf[msg.sender] -= amount; // 从 发送者账户 中 扣除 代币

        balanceOf[recipient] += amount; // 向 接收者账户 中 添加 代币

        emit Transfer(msg.sender, recipient, amount); // 触发 Transfer 事件

        return true; // 返回 操作成功
    }

    // 实现 IERC20中 的  approve 函数 来进行 代币授权逻辑。被授权方spender可以支配授权方的amount数量的代币。
    //               spender：被授权的账户地址、 amout：授权可以花费的代币数量
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount; // 设置 授权 金额

        emit Approval(msg.sender, spender, amount); // 触发 Approval 事件

        return true; // 返回 操作成功
    }

    // 实现 IERC20中的 transferFrom函数 来进行 授权转账逻辑。被授权方将授权方sender的amount数量的代币转账给接收方recipient。
    // 使用 transferFrom 函数，允许 一个被授权的账户 从 另一个账户（授权账户）中 转移代币 到 第三个账户。
    // sender:代币 的 原始持有者账户，也就是授权账户、 recipient:接收代币的第三个账户、 amount：要转移的代币数量
    // 通过 授权机制，从`sender`账户 向 `recipient`账户 转账 `amount`数量代币。转账的部分会从调用者的`allowance`中扣除。
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount; // 从 授权账户 中 扣除 金额

        balanceOf[sender] -= amount; // 从 发送者账户 中 扣除代币

        balanceOf[recipient] += amount; // 向 接收者账户 中 添加代币

        emit Transfer(sender, recipient, amount); // 触发 Transfer事件

        return true; // 返回 操作成功
    }

    // mint 函数 : 铸造代币函数，不属于 IERC20标准 。  任何人 可以铸造 任意数量的代币，实际应用中 会加 权限管理，只有 owner 可以铸造 代币：
    // 铸造代币，从 `0` 地址转账给 调用者地址
    function mint(uint256 amount) internal {
        balanceOf[msg.sender] += amount;

        totalSupply += amount;

        emit Transfer(address(0), msg.sender, amount);
    }

    // burn 函数 : 销毁代币函数，不属于 IERC20标准 。  销毁代币，从 调用者地址 转账给  `0` 地址
    function burn(uint256 amount) internal {
        balanceOf[msg.sender] -= amount;

        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }
}

// 上面 的 ERC20合约  去实现  IERC20 接口 时 ， ERC20合约 并没有完整实现 IERC20 接口 中 的 所有函数，为什么呢？
