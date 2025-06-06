// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 外部合约示例，用于演示try-catch功能
contract OnlyEvenContract {
    /**
     * @dev 构造函数包含条件检查
     * @param a 输入参数
     * - a=0时触发require异常
     * - a=1时触发assert异常
     * - 其他值正常执行
     */
    constructor(uint a) {
        require(a != 0, "invalid number"); // 输入验证：a不能为0
        assert(a != 1); // 内部一致性检查：a不能为1
    }

    /**
     * @dev 仅接受偶数输入的函数
     * @param b 输入参数
     * @return success 操作是否成功
     * - 输入偶数时返回true
     * - 输入奇数时revert
     */
    function onlyEven(uint256 b) external pure returns (bool success) {
        require(b % 2 == 0, "Ups! Reverting"); // 检查输入是否为偶数
        success = true;
    }
}

// 主合约，演示try-catch异常处理
contract TryCatch {
    // 事件定义
    event SuccessEvent(); // 成功时触发
    event CatchEvent(string message); // 捕获字符串类型异常时触发
    event CatchByte(bytes data); // 捕获字节类型异常时触发

    // 状态变量
    OnlyEvenContract even; // 外部合约实例

    // 构造函数初始化外部合约
    constructor() {
        even = new OnlyEvenContract(2); // 使用有效参数初始化
    }

    /**
     * @dev 调用外部合约函数并处理异常
     * @param amount 输入参数
     * @return success 操作是否成功
     */
    function evecute(uint amount) external returns (bool success) {

        try even.onlyEven(amount) returns (bool _success) {
            emit SuccessEvent(); // 成功时触发事件
            return _success;
            
        } catch Error(string memory reason) {
            emit CatchEvent(reason); // 捕获require/revert异常
        }
    }

    /**
     * @dev 创建新合约并处理可能出现的异常
     * @param a 构造函数参数
     * @return success 操作是否成功
     */
    function evecuteNew(uint a) external returns (bool success) {

        try new OnlyEvenContract(a) returns (OnlyEvenContract _even) {
            emit SuccessEvent(); // 创建成功时触发事件
            success = _even.onlyEven(a); // 调用新合约的函数

        } catch Error(string memory reason) {
            emit CatchEvent(reason); // 捕获require/revert异常

        } catch (bytes memory reason) {
            emit CatchByte(reason); // 捕获assert异常
        }
    }
}

// 在 Solidity 中 使用 try-catch 来处理 智能合约运行中 的 异常：

// - try-catch 只能 用于 外部合约函数调用 和 合约创建 。

// - 如果 try 执行成功，返回 变量 必须 声明，并且 与 返回的变量类型 相同。



// 实际应用场景：一个"银行账户管理系统"，通过try-catch处理各种异常情况 :

// 银行账户合约
contract BankAccount {
    mapping(address => uint256) private balances;
    bool private paused;

    event Deposit(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /**
     * @dev 存款功能
     * @param amount 存款金额
     * 要求：合约未暂停、金额大于0
     */
    function deposit(uint256 amount) external {
        require(!paused, "Contract is paused");
        require(amount > 0, "Amount must be greater than 0");
        
        balances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    /**
     * @dev 取款功能
     * @param amount 取款金额
     * 要求：合约未暂停、余额充足
     */
    function withdraw(uint256 amount) external {
        require(!paused, "Contract is paused");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        emit Withdraw(msg.sender, amount);
    }

    /**
     * @dev 暂停合约功能（管理员专用）
     */
    function pause() external {
        // 简单权限检查（实际项目应使用更完善的权限控制）
        require(msg.sender == address(0x123...), "Unauthorized");
        paused = true;
    }
}

// 银行管理系统合约
contract BankManager {
    event AccountCreated(address indexed account);
    event OperationSuccess(string operation);
    event OperationFailed(string reason);

    /**
     * @dev 创建银行账户并存款
     * @param initialDeposit 初始存款金额
     * @return newAccount 新创建的账户地址
     */
    function createAccountWithDeposit(uint256 initialDeposit) external returns (address) {
        try new BankAccount() returns (BankAccount newAccount) {
            // 尝试初始存款
            try newAccount.deposit(initialDeposit) {
                emit AccountCreated(address(newAccount));
                emit OperationSuccess("Account created with deposit");
                return address(newAccount);
            } catch Error(string memory reason) {
                emit OperationFailed(reason);
                revert(string(abi.encodePacked("Deposit failed: ", reason)));
            }
        } catch {
            emit OperationFailed("Account creation failed");
            revert("Account creation failed");
        }
    }

    /**
     * @dev 批量转账功能
     * @param from 转出账户
     * @param to 转入账户数组
     * @param amounts 转账金额数组
     */
    function batchTransfer(
        BankAccount from,
        address[] memory to,
        uint256[] memory amounts
    ) external {
        require(to.length == amounts.length, "Array length mismatch");

        for (uint256 i = 0; i < to.length; i++) {
            try from.withdraw(amounts[i]) {
                try BankAccount(to[i]).deposit(amounts[i]) {
                    emit OperationSuccess("Transfer completed");
                } catch Error(string memory reason) {
                    // 存款失败，退还金额
                    from.deposit(amounts[i]);
                    emit OperationFailed(string(abi.encodePacked("Deposit failed: ", reason)));
                }
            } catch Error(string memory reason) {
                emit OperationFailed(string(abi.encodePacked("Withdraw failed: ", reason)));
            }
        }
    }

    /**
     * @dev 安全暂停账户功能
     * @param account 要暂停的银行账户
     */
    function safePauseAccount(BankAccount account) external {
        try account.pause() {
            emit OperationSuccess("Account paused successfully");
        } catch Error(string memory reason) {
            emit OperationFailed(reason);
        } catch (bytes memory) {
            emit OperationFailed("Unknown error occurred");
        }
    }
}