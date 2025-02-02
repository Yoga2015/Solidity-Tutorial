// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IERC20.sol";

contract TokenSwap {
    IERC20 public token1;
    address public owner1;
    uint256 public amount1;
    IERC20 public token2;
    address public owner2;
    uint256 public amount2;

    constructor(
        address _token1,
        address _owner1,
        uint256 _amount1,
        address _token2,
        address _owner2,
        uint256 _amount2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        amount1 = _amount1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
        amount2 = _amount2;
    }

    function swap() public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(
            token1.allowance(owner1, address(this)) >= amount1,
            "Token 1 allowance too low"
        );
        require(
            token2.allowance(owner2, address(this)) >= amount2,
            "Token 2 allowance too low"
        );

        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}

// 如何交换代币

// 1. Alice有100个来自AliceCoin的代币，这是一个ERC20代币。

// 2. Bob有100个来自BobCoin的代币，这也是一个ERC20代币。

// 3. Alice和Bob想用10个Alice币换20个Bob币。

// 4. Alice或Bob部署TokenSwap

// 5. Alice批准TokenSwap从AliceCoin中提取10个代币

// 6. Bob批准TokenSwap从BobCoin中提取20个代币

// 7. Alice或Bob调用TokenSwap.swap（）

// 8. Alice和Bob成功地交换了代币。
