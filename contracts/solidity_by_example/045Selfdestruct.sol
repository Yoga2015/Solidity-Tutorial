// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title 合约自毁演示
/// @notice 展示selfdestruct的使用及其在坎昆升级前后的区别
contract DeleteContract {

    uint public value = 10;    // 测试用状态变量，初始值为10

    constructor() payable {}   // payable允许在部署时转入ETH

    /// @notice 接收ETH的回退函数
    receive() external payable {}  // 允许合约接收ETH转账

    /// @notice 执行合约自毁并将剩余ETH转给调用者
    /// @dev 坎昆升级后，此操作只转移ETH，不再销毁合约
    function deleteContract() external {
        // 将合约中所有ETH转给调用者
        // 在坎昆升级前会销毁合约，升级后只转移ETH
        selfdestruct(payable(msg.sender));
    }

    /// @notice 查询合约当前的ETH余额
    /// @return balance 合约的ETH余额（单位：wei）
    function getBalance() external view returns (uint balance) {
        balance = address(this).balance;  // 返回合约地址的ETH余额
    }
}

// 1.部署合约时  并且 向 DeleteContract合约 转入1 ETH。这时，getBalance()会返回1 ETH，value变量 是 10。

// 当我们 调用deleteContract()函数，合约 将触发 selfdestruct操作。

// 在坎昆升级前，合约会被自毁。但是在升级后，合约依然存在，只是将合约包含的ETH转移到指定地址，而合约依然能够调用。

// 在坎昆升级后 仅能实现 内部ETH余额的转移。




/// @title 一个"临时资金托管合约"，通过selfdestruct实现资金的安全回收机制。
/// @notice 展示selfdestruct在实际场景中的应用
contract EscrowContract {
    address public owner;          // 合约所有者
    address public beneficiary;    // 资金受益人
    uint256 public releaseTime;    // 资金释放时间戳
    bool public fundsReleased;     // 资金是否已释放

    event Deposited(address indexed from, uint256 amount);
    event Released(address indexed to, uint256 amount);
    event EmergencyWithdraw(address indexed to, uint256 amount);

    /**
     * @dev 构造函数初始化托管合约
     * @param _beneficiary 资金受益人地址
     * @param _releaseTime 资金释放时间戳(秒)
     */
    constructor(address _beneficiary, uint256 _releaseTime) payable {
        require(_beneficiary != address(0), "Invalid beneficiary address");
        require(_releaseTime > block.timestamp, "Release time must be in future");
        
        owner = msg.sender;
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
        
        if(msg.value > 0) {
            emit Deposited(msg.sender, msg.value);
        }
    }

    /**
     * @dev 接收ETH的fallback函数
     */
    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @dev 释放资金给受益人
     */
    function release() external {
        require(msg.sender == owner || msg.sender == beneficiary, "Not authorized");
        require(block.timestamp >= releaseTime, "Too early to release");
        require(!fundsReleased, "Funds already released");
        require(address(this).balance > 0, "No funds to release");

        uint256 amount = address(this).balance;
        fundsReleased = true;
        
        payable(beneficiary).transfer(amount);
        emit Released(beneficiary, amount);
    }

    /**
     * @dev 紧急情况下销毁合约并退回资金
     * @notice 仅合约所有者可调用，资金退回给原始发送者
     */
    function emergencyWithdraw() external {
        require(msg.sender == owner, "Only owner can emergency withdraw");
        
        uint256 amount = address(this).balance;
        emit EmergencyWithdraw(owner, amount);
        
        // 销毁合约并将剩余ETH退回给所有者
        selfdestruct(payable(owner));
    }

    /**
     * @dev 查询合约余额
     * @return 合约当前ETH余额(wei)
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
