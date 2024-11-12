// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract ForeverTest {
    uint256 public i = 0;

    // 当发送的所有 gas 被用尽时，会导致你的交易失败。
    // 状态更改将被撤销。
    // 已消耗的 gas 不会退还。
    // Remix测试会报错：
    // transact to ForeverTest.forever errored: Error occurred: out of gas.

    // out of gas
    //  The transaction ran out of gas. Please increase the Gas Limit.
    function forever() public {
        while (true) {
            i += 1;
        }
    }
}
