contract OtherContract {
    // 定义一个名为 _x 的 私有变量，类型为uint256，初始化为 0
    uint256 private _x = 0;

    // Log事件 ，记录日志，收到 ETH 后 ，记录 amount 和 gas
    event Log(uint amount, uint gas);

    fallback() external payable {}

    // 返回 当前合约 的地址的余额
    function getBalance() public view returns (uint) {
        // address(this) 获取 当前合约的地址，.balance 是 该地址的 余额属性。
        return address(this).balance;
    }

    // 可以 调整 状态变量 _x 的 函数，并且 可以 往合约 转 ETH (payable)
    function setX(uint256 x) external payable {
        _x = x;

        // 如果 转入 ETH , 则释放Log 事件
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    // 读取 _x
    function getX() external view returns (uint x) {
        x = _x;
    }
}
