// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// IERC20定义了6个函数，提供了转移代币的基本功能，并允许代币获得批准，以便其他链上第三方使用。
interface IERC20 {
    // 查询 代币总供应量  （totalSupply函数 是一个只读函数、只能 从合约外部 调用，会返回 代币总供应量）
    function totalSupply() external view returns (uint256);

    // 查询  账户余额 （balanceOf函数 是一个只读函数、只能 从合约外部 调用，会返回 指定账户的代币余额）
    function balanceOf(address account) external view returns (uint256);

    // 转账  （transfer函数 只能 从合约外部 调用，用于 将 代币 从 一个账户 转移到 另一个账户，会返回一个布尔值，成功转移 返回 true，否则 返回 false）
    function transfer(
        address recipient, //  recipient：接收代币的地址
        uint256 amount //  amount：要转移的代币数量
    ) external returns (bool);

    // 查询  授权转账额度  （allowance函数 是一个只读函数、只能 从合约外部 调用，会返回 某个账户 授权给 另一个账户 可以花费 的 代币数量）
    // 当 {approve} 或 {transferFrom} 被调用时，`allowance`会改变.
    function allowance(
        address owner, //  spender：被授权的账户地址
        address spender //  amout：授权可以花费的代币数量
    ) external view returns (uint256);

    // 授权  （approve函数 只能 从合约外部 调用，用于授权 一个账户 能从 你的账户中 可以花费 指定数量的代币，授权成功 返回 true，否则 返回 false）
    function approve(address spender, uint256 amount) external returns (bool);

    // 授权转账 （transferFrom函数 只能从合约外部调用，用于 从 一个账户 转移代币 到 另一个账户，但 这次转移操作 是由 被授权的第三方 发起的,转移成功返回 true，否则返回 false）
    function transferFrom(
        address sender, // sender:代币的原始持有者账户，也就是授权账户
        address recipient, //  recipient:接收代币的第三个账户
        uint256 amount // amount：要转移的代币数量
    ) external returns (bool);
}

// 代币信息（可选）：名称(name())，代号(symbol())，小数位数(decimals())
