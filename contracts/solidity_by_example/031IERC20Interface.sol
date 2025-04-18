// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;           // 指定 Solidity 编译器版本

// ERC20 标准接口定义：定义了 ERC20 代币必须实现的基本功能
interface IERC20 {

    // @return 返回 代币的总发行量
    function totalSupply() external view returns (uint256);

    // @param account 要查询余额的账户地址
    // @return 返回 该账户的代币余额
    function balanceOf(address account) external view returns (uint256);

    // @param recipient 接收代币的目标地址、amount 要转账的代币数量
    // @return 转账是否成功
    function transfer(address recipient, uint256 amount) external returns (bool);

    // @param owner 代币持有者地址、spender 被授权者地址
    // @return 返回spender被授权可使用owner的代币数量
    function allowance(address owner, address spender) external view returns (uint256);

    // @param spender 被授权者地址、amount 授权使用的代币数量
    // @return 授权是否成功
    function approve(address spender, uint256 amount) external returns (bool);

    // @param sender 代币发送者地址、recipient 代币接收者地址、amount 转账的代币数量
    // @return 转账是否成功
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// ERC20代币合约实现：继承自IERC20接口
contract ERC20 is IERC20 {

    // 转账事件：当代币被转移时触发
    // @param from 代币发送者地址（0地址表示铸造新代币）、to 代币接收者地址（0地址表示销毁代币）、value 转移的代币数量
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 授权事件：当授权额度被设置时触发
    // @param owner 代币持有者地址、spender 被授权者地址、value 授权的代币数量
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 状态变量声明
    uint256 public totalSupply;    // 代币的总发行量
    mapping(address => uint256) public balanceOf;    // 记录每个地址的代币余额
    mapping(address => mapping(address => uint256)) public allowance;    // 记录授权信息：owner => spender => amount
    string public name;     // 代币名称，如 "Ethereum"
    string public symbol;   // 代币符号，如 "ETH"
    uint8 public decimals;  // 代币小数位数，通常为 18

    // 构造函数：部署合约时调用，初始化代币基本信息
    // @param _name 代币名称、 _symbol 代币符号、_decimals 代币小数位数
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    // 实现代币转账功能
    // @param recipient 接收代币的地址、amount 转账金额
    function transfer(address recipient, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;    // 扣除发送者余额
        balanceOf[recipient] += amount;      // 增加接收者余额
        emit Transfer(msg.sender, recipient, amount);  // 触发转账事件
        return true;
    }

    // 实现授权功能
    // @param spender 被授权的地址、amount 授权使用的代币数量
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;  // 设置授权额度
        emit Approval(msg.sender, spender, amount);  // 触发授权事件
        return true;
    }

    // 实现授权转账功能
    // @param sender 代币发送者地址、recipient 代币接收者地址、amount 转账金额
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        allowance[sender][msg.sender] -= amount;  // 扣除授权额度
        balanceOf[sender] -= amount;             // 扣除发送者余额
        balanceOf[recipient] += amount;          // 增加接收者余额
        emit Transfer(sender, recipient, amount); // 触发转账事件
        return true;
    }

    // 内部铸币函数：只能被合约内部调用
    // @param to 接收新铸造代币的地址、amount 铸造的代币数量
    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;           // 增加接收者余额
        totalSupply += amount;             // 增加总供应量
        emit Transfer(address(0), to, amount);  // 触发转账事件，从0地址转出表示铸币
    }

    // 内部销毁函数：只能被合约内部调用
    // @param from1 销毁代币的来源地址、amount 销毁的代币数量
    function _burn(address from1, uint256 amount) internal {
        balanceOf[from1] -= amount;        // 减少持有者余额
        totalSupply -= amount;             // 减少总供应量
        emit Transfer(from1, address(0), amount);  // 触发转账事件，转入0地址表示销毁
    }

    // 外部铸币函数
    // @param to1 接收新铸造代币的地址、amount1 铸造的代币数量
    function mint(address to1, uint256 amount1) external {
        _mint(to1, amount1);
    }

    // 外部销毁函数
    // @param from1 销毁代币的来源地址、amount 销毁的代币数量
    function burn(address from1, uint256 amount) external {
        _burn(from1, amount);
    }
}