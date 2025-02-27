// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 在 盲盒合约 中，可以使用 数组 来存储 盲盒中的 奖品信息 或 用户的购买记录。
contract BlindBox {
    // 假设 盲盒奖品 是 一个 结构体，包含 奖品ID 和 数量
    struct Prize {
        uint id;
        uint amount;
    }

    // 使用 动态数组 存储 奖品 信息
    Prize[] public prizes;

    // 记录用户购买盲盒的历史
    mapping(address => uint[]) public userPurchaseHistory;

    // 事件：记录用户购买盲盒
    event BoxPurchased(address indexed user, uint prizeId);

    // 合约所有者
    address public owner;

    // 初始化 奖品 信息
    constructor() {
        owner = msg.sender;

        prizes.push(Prize(1, 99)); // 添加 一个奖品ID 为 1 ， 数量 为 99 的 奖品

        prizes.push(Prize(2, 50)); // 添加 一个奖品ID 为 2 ， 数量 为 50 的 奖品
    }

    // 只有 合约所有者 可以调用 的 修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // 添加奖品
    function addPrize(uint _id, uint _amount) external onlyOwner {
        prizes.push(Prize(_id, _amount));
    }

    // 用户 购买盲盒 的 函数 （简化版）
    function buyBox() external {
        // 假设 逻辑判断 用户 是否 有资格购买，随机选择 奖品 等

        // 随机选择一个奖品索引
        uint prizeIndex = _random() % prizes.length;

        // 确保奖品数量大于0
        require(prizes[prizeIndex].amount > 0, "Prize out of stock");

        // 减少 奖品数量
        prizes[prizeIndex].amount--;

        // 记录用户购买历史
        userPurchaseHistory[msg.sender].push(prizes[prizeIndex].id);

        // 发放奖品给用户（此处省略发放逻辑）
        emit BoxPurchased(msg.sender, prizes[prizeIndex].id);
    }

    // 生成一个简单的随机数（注意：此方法不安全，仅用于演示）
    function _random() private view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.prevrandao,
                        msg.sender
                    )
                )
            ) % prizes.length;
    }

    // 获取用户购买历史
    function getUserPurchaseHistory(
        address _user
    ) external view returns (uint[] memory) {
        return userPurchaseHistory[_user];
    }
}
