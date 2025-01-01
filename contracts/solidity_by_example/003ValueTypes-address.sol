// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Payment {
    address payable public recipient; // 收款人地址

    // 接受一个 payable类型的地址 作为 构造函数参数，并将 其 设置为 收款人;
    constructor(address payable _userAddress) {
        recipient = _userAddress;
    }

    // 设置 只有收款人 才能调用 它 来提取资金
    function withdraw() external payable {
        require(
            msg.sender == recipient,
            "Only the recipient can withdraw funds."
        ); // 检查调用者是否为收款人

        recipient.transfer(msg.value);
    }

    // 查看合约余额，监控合约的财务状况
    function getBalance() public view returns (uint256) {
        return address(this).balance; // 返回合约当前的以太币余额
    }
}

// 在这个例子中，我们创建了一个名为Payment的合约，
// 它 接受一个 payable address地址 作为 构造函数参数，并将 其 设置为 收款人。
// 然后，我们提供了一个withdraw函数，只有收款人 才能 调用它 来提取 资金。

contract Payment2 {
    address payable public payee; // 收款人地址

    // 构造函数，接受一个payable地址作为收款人
    constructor(address payable _payee) {
        payee = _payee;
    }

    // withdraw函数，只能由收款人调用
    function withdraw(uint256 amount) public {
        require(msg.sender == payee, "Only the payee can withdraw funds."); // 检查调用者是否为收款人
        payee.transfer(amount); // 将资金转移到收款人地址
    }

    // 可选：查看合约余额的函数
    function getBalance() public view returns (uint256) {
        return address(this).balance; // 返回合约当前的以太币余额
    }
}
