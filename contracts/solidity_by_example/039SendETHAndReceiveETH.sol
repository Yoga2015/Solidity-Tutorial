// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// 发送 ETH 的 合约
contract SendETH {
    
    // 构造函数 加上 payable 关键字，可以 使得 部署的时候 可以转 ETH 进入
    constructor() payable {}

    // receive方法，接收 ETH 时 被触发
    receive() external payable {}

    // 1、用 transfer() 方法 发送 ETH
    function transferETH(address payable _to, uint256 amount) external payable {
        _to.transfer(amount); // 接收方地址.transfer ( 发送ETH数额 )；
    }

    // 2、用 send() 方法 发送 ETH     接收方地址.send ( 发送ETH数额 )；
    error SendFailed(); // 发送ETH 失败 error

    function sendETH(address payable _to, uint256 amount) external payable {
        // 处理下 send 的 返回值 ，如果失败，会自动 revert交易 并发送 error
        bool success = _to.send(amount);

        if (!success) {
            revert SendFailed();
        }
    }

    // 3、用 call() 方法 发送 ETH     接收方地址.call{value: 发送ETH数额}("")
    error CallFailed(); // 发送 ETH 失败 error

    function callETH(address payable _to, uint256 amount) external payable {
        // 处理下 call 的 返回值，如果失败，revert 交易 并 发送error
        (bool success, ) = _to.call{value: amount}("");

        if (!success) {
            revert CallFailed();
        }
    }
}

// 接收 ETH 的 合约
contract ReceiveETH {
    // 收到 ETH 事件 ，记录 amount 和 gas
    event Log(uint amount, uint gas);

    // receive 方法，接收ETH 时 被触发
    receive() external payable {
        emit Log(msg.value, gasleft());
    }

    // 返回 合约 ETH余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// 上面部署了 一个 接收ETH 的 合约 ReceiveETH  ，合约 里 有一个事件 Log，记录 收到的ETH数量 和 gas剩余。
// 其中 还有 两个函数：
//          一个是 receive()函数，收到ETH 被触发，并发送 Log事件；
//          另一个是 查询 合约ETH余额 的 getBalance()函数 。

// transfer（）有 固定的 2300gas 限制，无返回值 ，发送失败 会自动 revert 回滚交易，是 次优选择

// send（） 有 固定的 2300gas 限制，返回值 为 布尔值，发送失败 不会自动 revert 回滚交易，几乎 没有人用它

// call（）没有 gas 限制（无限制），返回值 为 布尔值, 数据 ，发送失败  不会自动 revert，需手动处理，推荐使用




// 多签钱包合约 ：通过不同方式实现 ETH转账功能
contract MultiSigWallet {
    address[] public owners;  // 钱包所有者列表
    uint public required;     // 执行交易所需的最小签名数
    
    struct Transaction {
        address payable to;   // 收款地址
        uint amount;          // 转账金额(wei)
        bool executed;        // 是否已执行
        bytes data;           // 调用数据
    }
    
    Transaction[] public transactions;  // 交易列表
    mapping(uint => mapping(address => bool)) public confirmations; // 交易确认记录

    event Deposit(address indexed sender, uint amount);  // 存款事件
    event Submission(uint indexed txId);                // 交易提交事件
    event Confirmation(address indexed owner, uint indexed txId); // 确认事件
    event Execution(uint indexed txId);                  // 执行事件

    /**
     * @dev 构造函数初始化多签钱包
     * @param _owners 所有者地址数组
     * @param _required 执行交易所需的最小签名数
     */
    constructor(address[] memory _owners, uint _required) payable {
        require(_owners.length > 0, "At least one owner required");
        require(_required > 0 && _required <= _owners.length, "Invalid required number");
        
        owners = _owners;
        required = _required;
        
        if(msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    // 接收ETH的回退函数
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @dev 提交新的转账交易
     * @param _to 收款地址
     * @param _amount 转账金额(wei)
     * @param _data 调用数据
     * @return txId 返回交易ID
     */
    function submitTransaction(
        address payable _to, 
        uint _amount, 
        bytes memory _data
    ) external returns (uint txId) {
        require(_to != address(0), "Invalid recipient address");
        require(_amount <= address(this).balance, "Insufficient balance");
        
        txId = transactions.length;
        transactions.push(Transaction({
            to: _to,
            amount: _amount,
            executed: false,
            data: _data
        }));
        
        emit Submission(txId);
        confirmTransaction(txId); // 提交者自动确认
    }

    /**
     * @dev 确认交易
     * @param _txId 交易ID
     */
    function confirmTransaction(uint _txId) public {
        require(isOwner(msg.sender), "Not an owner");
        require(_txId < transactions.length, "Invalid transaction ID");
        require(!transactions[_txId].executed, "Transaction already executed");
        require(!confirmations[_txId][msg.sender], "Transaction already confirmed");
        
        confirmations[_txId][msg.sender] = true;
        emit Confirmation(msg.sender, _txId);
        
        // 如果达到最小确认数，执行交易
        if(getConfirmationCount(_txId) >= required) {
            executeTransaction(_txId);
        }
    }

    /**
     * @dev 执行交易(使用call方法)
     * @param _txId 交易ID
     */
    function executeTransaction(uint _txId) internal {
        Transaction storage txn = transactions[_txId];
        require(!txn.executed, "Transaction already executed");
        
        // 使用call方法执行转账
        (bool success, ) = txn.to.call{value: txn.amount}(txn.data);
        require(success, "Transaction execution failed");
        
        txn.executed = true;
        emit Execution(_txId);
    }

    /**
     * @dev 紧急转账(使用transfer方法，仅限单个所有者确认)
     * @param _to 收款地址
     * @param _amount 转账金额(wei)
     */
    function emergencyTransfer(address payable _to, uint _amount) external {
        require(isOwner(msg.sender), "Not an owner");
        require(_amount <= address(this).balance, "Insufficient balance");
        
        // 使用transfer方法执行紧急转账
        _to.transfer(_amount);
    }

    // 辅助函数
    function isOwner(address _addr) internal view returns (bool) {
        for(uint i = 0; i < owners.length; i++) {
            if(owners[i] == _addr) {
                return true;
            }
        }
        return false;
    }
    
    function getConfirmationCount(uint _txId) public view returns (uint count) {
        for(uint i = 0; i < owners.length; i++) {
            if(confirmations[_txId][owners[i]]) {
                count++;
            }
        }
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}