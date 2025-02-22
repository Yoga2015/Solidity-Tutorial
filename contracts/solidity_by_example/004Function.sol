// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Function {
    // 定义 一个 状态变量 number，初始化 为 6。
    uint256 public num = 6;

    // 定义一个 add() 函数，每次调用会让 number 增加 1。 只能由 合约外部 调用（访问）
    function add() external {
        num = num + 1;
    }

    // 包含 pure 关键字 的 函数 既不能读取 也不能改写 状态变量，主要用于  在不实际执行交易的情况下 使用。
    // 因为 pure函数 不会改变 状态，所以它们 可以在 不实际执行交易的情况下 被多次 调用，从而节省gas费用。
    // 如果 addPure() 函数 被标记 为 pure，就会报错。因为 pure 是不配 读取 合约里的状态变量的，更不配 改写。
    function addPure(uint256 pureNum) external pure returns (uint256 newNum) {
        newNum = pureNum + 1;
    }

    // 包含 view 关键字 的 函数 可以读取 状态变量，但 不能改写 状态变量
    // 如果 addView() 函数  被标记为 view，比如 function add() external view，也会报错。因为 view 只能读取，但 不能够改写 状态变量。
    function addView() external view returns (uint256 viewNum) {
        viewNum = num + 1;
    }

    // internal: 只能 从合约内部 访问，继承的合约 可以用。
    // 定义一个 internal 的 subtract() 函数，每次 调用 ，使得 num 变量减少 1，更改了 状态变量num.
    // 由于  被标记为 internal 的 函数 只能由 合约内部 调用，因此，我们必须 再定义一个 external 的 subtractCall() 函数，通过 它 间接调用 内部 的 subtract() 函数
    function subtract() internal {
        num = num - 1;
    }

    // external：只能 从合约外部 访问（但内部可以通过 this.f() 来调用，f是函数名）。
    function subtractCall() external {
        subtract(); // 合约内的函数 可以 调用 内部函数
    }

    // payable（可支付的）很好理解，带着它的函数，运行的时候可以给合约转入 ETH。
    // 定义 一个 external payable 的 substractPayable() 函数，间接 的 调用 subtract() ,
    // 并且 返回 合约里 的 ETH余额（this 关键字可以 让 我们 引用 合约地址）。 可以尝试在调用 minusPayable() 时往合约里转入1个 ETH。
    function substractPayable() external payable returns (uint256 balance) {
        subtract();

        balance = address(this).balance;
    }
}

// function <function name> (<parameter types>) {internal|external|public|private} [pure|view|payable] [returns (<return types>)]
