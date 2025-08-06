// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

// 无限循环测试合约，用于演示gas耗尽问题
contract ForeverTest {
    uint256 public i = 0; // 记录循环次数

    /**
     * @dev 无限循环函数，会导致gas耗尽
     * @notice 此函数会无限执行循环直到交易gas耗尽
     * @warning 实际开发中禁止使用无限循环
     * 函数没有参数和返回值
     */
    function forever() public {
        // 无限循环开始
        while (true) {
            i += 1; // 每次循环计数器加1
            // 注意：这个循环永远不会停止
            // 会导致交易gas耗尽并回滚
        }
    }
}

// 竞拍倒计时合约，演示正确处理循环的方式
contract AuctionCountdown {
    uint256 public countdown;      // 倒计时结束时间戳(秒)
    bool public auctionEnded;     // 竞拍状态标志
    address public highestBidder;  // 当前最高出价者地址
    uint256 public highestBid;     // 当前最高出价金额(wei)

    // 事件定义
    event AuctionStarted(uint256 duration); // 竞拍开始事件
    event NewBid(address indexed bidder, uint256 amount); // 新出价事件
    event AuctionEnded(address indexed winner, uint256 amount); // 竞拍结束事件

    /**
     * @dev 开始新的竞拍
     * @param _duration 竞拍持续时间(秒)
     * 要求: 持续时间必须大于0
     */
    function startAuction(uint256 _duration) external {
        require(_duration > 0, "Duration must be positive");
        countdown = block.timestamp + _duration; // 计算结束时间戳
        auctionEnded = false; // 重置竞拍状态
        highestBid = 0;      // 重置最高出价
        emit AuctionStarted(_duration); // 触发事件
    }

    /**
     * @dev 提交新的出价
     * @notice 需要附带ETH作为出价金额
     * 要求: 竞拍未结束且出价高于当前最高价
     */
    function bid() external payable {
        require(!auctionEnded, "Auction already ended");
        require(msg.value > highestBid, "Bid too low");
        
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit NewBid(msg.sender, msg.value);
    }

    /**
     * @dev 安全结束竞拍
     * @notice 根据时间戳判断竞拍是否结束
     * 要求: 当前时间必须超过倒计时时间
     */
    function safeEndAuction() external {
        require(block.timestamp >= countdown, "Auction not ended");
        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);
    }

    /**
     * @dev 危险示例: 使用循环结束竞拍
     * @warning 会导致gas耗尽，仅用于演示
     */
    function unsafeEndAuction() external {
        // 危险循环示例
        while(block.timestamp < countdown) {
            // 空循环等待时间到达
            // 实际会导致gas耗尽
        }
        auctionEnded = true;

        emit AuctionEnded(highestBidder, highestBid);
    }
}

