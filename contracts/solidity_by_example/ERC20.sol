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

    // 使用 transfer 函数，可将 代币 从 一个账户 转移到 另一个账户。   recipient：接收代币的地址、 amount：要转移的代币数量
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        balanceOf[msg.sender] -= amount; // 从 发送者账户 中 扣除 代币

        balanceOf[recipient] += amount; // 向 接收者账户 中 添加 代币

        emit Transfer(msg.sender, recipient, amount); // 触发 Transfer 事件

        return true; // 返回 操作成功
    }

    // 使用 approve 函数，允许 一个账户 授权 另一个账户 花费 其 一定数量的代币。   spender：被授权的账户地址、 amout：授权可以花费的代币数量
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount; // 设置 授权 金额

        emit Approval(msg.sender, spender, amount); // 触发 Approval 事件

        return true; // 返回 操作成功
    }

    // 使用 transferFrom 函数，允许 一个被授权的账户 从 另一个账户（授权账户）中 转移代币 到 第三个账户。
    // sender:代币 的 原始持有者账户，也就是授权账户、 recipient:接收代币的第三个账户、 amount：要转移的代币数量
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

    // _mint 函数 （内部函数），用于 创建 新的代币 并 发送到 指定账户。    to:指定账户、 amount:要转移的代币数量
    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount; // 向 指定账户 添加 代币

        totalSupply += amount; // 增加总供应量

        emit Transfer(address(0), to, amount); // 触发 Transfer事件，表示 从 “无”（address(0)）创建并发送到指定账户。
    }

    // _burn 函数 （内部函数），用于 从 指定账户 中 销毁 一定数量的代币
    function _burn(address from, uint256 amount) internal {
        balanceOf[from] -= amount; // 从 指定账户 中 扣除代币

        totalSupply -= amount; // 减少总供应量

        emit Transfer(from, address(0), amount); // 触发 Transfer事件，表示 将 代币 销毁到 “无” (address(0))
    }

    // mint 函数，允许 外部调用者 创建 新的代币 并 发送到 指定账户。 注意：这通常是一个危险操作，因为它 可以无限制地 增加 代币的供应量
    function mint(address to, uint256 amount) external {
        _mint(to, amount); // 调用 内部 _mint 函数 执行 代币创建
    }

    // burn 函数，允许 外部调用者 从 指定账户 中 销毁 一定数量的代币。注意：这通常是一个危险操作，因为它 可以无限制地 减少代币的供应量
    function burn(address from, uint256 amount) external {
        _burn(from, amount); // 调用 内部 _burn 函数 执行 代币销毁
    }
}

// 上面 的 ERC20合约  去实现  IERC20 接口 时 ，发现 ERC20合约 并没有完整实现 IERC20 接口 中 的 所有函数，
