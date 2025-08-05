// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract ForeverTest {
    uint256 public i = 0;

    // 当发送的所有 gas 被用尽时，会导致你的交易失败。状态更改将被撤销。已消耗的 gas 不会退还。
    // Remix测试会报错：
    // transact to ForeverTest.forever errored: Error occurred: out of gas.

    // out of gas
    // The transaction ran out of gas. Please increase the Gas Limit.
    function forever() public {
        while (true) {
            i += 1;
        }
    }
}


// "竞拍倒计时"合约，通过有限循环演示gas耗尽问题
contract AuctionCountdown {
    uint256 public countdown;      // 倒计时秒数
    bool public auctionEnded;     // 竞拍是否结束
    address public highestBidder;  // 最高出价者
    uint256 public highestBid;    // 最高出价金额

    event AuctionStarted(uint256 duration);
    event NewBid(address bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    /**
     * @dev 开始新的竞拍
     * @param _duration 竞拍持续时间(秒)
     */
    function startAuction(uint256 _duration) external {
        require(_duration > 0, "Duration must be positive");
        countdown = _duration;
        auctionEnded = false;
        emit AuctionStarted(_duration);
    }

    /**
     * @dev 提交新的出价
     */
    function bid() external payable {
        require(!auctionEnded, "Auction already ended");
        require(msg.value > highestBid, "Bid must be higher than current bid");
        
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit NewBid(msg.sender, msg.value);
    }

    /**
     * @dev 危险示例：使用无限循环更新倒计时(会导致gas耗尽)
     * @notice 仅供演示gas耗尽问题，实际开发中不应使用
     */
    function unsafeUpdateCountdown() public {
        while(countdown > 0) {
            countdown--;  // 无限递减直到gas耗尽
        }
        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);
    }

    /**
     * @dev 安全示例：使用区块时间戳更新倒计时
     */
    function safeEndAuction() external {
        require(block.timestamp >= countdown, "Auction not ended yet");
        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);
    }

    /**
     * @dev 提取竞拍奖金(仅限竞拍获胜者)
     */
    function withdraw() external {
        require(auctionEnded, "Auction not ended yet");
        require(msg.sender == highestBidder, "Only winner can withdraw");
        
        uint256 amount = highestBid;
        highestBid = 0;
        payable(msg.sender).transfer(amount);
    }
}
