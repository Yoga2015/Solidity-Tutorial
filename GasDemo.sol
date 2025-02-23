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
