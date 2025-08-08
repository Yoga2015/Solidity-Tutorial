// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Gas {
    uint256 public i = 0;

    // 由于循环没有终止条件，函数会一直运行，直到耗尽交易的所有Gas。
    function forever() public {
        while (true) {
            i += 1;
        }
    }
}

// 这段代码展示了Solidity中Gas机制的基本原理，以及无限循环导致的Gas耗尽问题。

// Gas是什么
// Gas 是 以太坊网络中 执行操作 的 计算资源单位，执行交易 或 运行智能合约  需要支付Gas费用。
// Gas费用 由 Gas价格（单位：Gwei）和Gas消耗量决定。
// gas 价格  更高的交易  会优先  被打包进  区块。

// 如果交易执行过程中Gas耗尽，交易会失败。所有状态更改会被回滚。已消耗的Gas不会被退还。


// 一个"投票系统"合约，通过有限循环演示gas优化问题
contract VotingSystem {

    // 候选人结构体
    struct Candidate {
        string name;    // 候选人姓名
        uint voteCount; // 得票数
    }

    Candidate[] public candidates; // 候选人数组
    mapping(address => bool) public voters; // 已投票地址映射
    bool public votingEnded;       // 投票是否结束
    uint public endTime;           // 投票结束时间戳

    // 事件
    event VoteCast(address indexed voter, uint candidateId); // 投票事件
    event VotingStarted(uint duration); // 投票开始事件
    event VotingEnded(address[] winners); // 投票结束事件

    /**
     * @dev 初始化投票系统
     * @param _candidateNames 候选人姓名数组
     * @param _duration 投票持续时间(秒)
     */
    constructor(string[] memory _candidateNames, uint _duration) {
        require(_duration > 0, "Duration must be positive");
        
        // 初始化候选人
        for(uint i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate({
                name: _candidateNames[i],
                voteCount: 0
            }));
        }
        
        endTime = block.timestamp + _duration;
        emit VotingStarted(_duration);
    }

    /**
     * @dev 投票函数
     * @param _candidateId 候选人ID
     * 要求: 投票者未投过票且投票未结束
     */
    function vote(uint _candidateId) external {
        require(!votingEnded, "Voting has ended");
        require(!voters[msg.sender], "Already voted");
        require(_candidateId < candidates.length, "Invalid candidate");
        
        candidates[_candidateId].voteCount++;
        voters[msg.sender] = true;
        emit VoteCast(msg.sender, _candidateId);
    }

    /**
     * @dev 安全结束投票(基于时间戳)
     */
    function endVoting() external {
        require(block.timestamp >= endTime, "Voting not ended yet");
        votingEnded = true;
        
        // 找出获胜者
        address[] memory winners = getWinners();
        emit VotingEnded(winners);
    }

    /**
     * @dev 危险示例: 使用循环等待投票结束(会导致gas耗尽)
     * 仅用于演示gas耗尽问题
     */
    function unsafeEndVoting() external {
        // 危险循环 - 会耗尽gas
        while(block.timestamp < endTime) {
            // 空循环等待
        }
        
        votingEnded = true;
        address[] memory winners = getWinners();
        emit VotingEnded(winners);
    }

    /**
     * @dev 获取获胜者列表
     * @return 获胜者地址数组
     */
    function getWinners() public view returns (address[] memory) {
        // 实现省略...
    }
}
