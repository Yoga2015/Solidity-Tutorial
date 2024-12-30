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
