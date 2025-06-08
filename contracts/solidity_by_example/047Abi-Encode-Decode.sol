// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract AbiEncodeDecode {

    uint x = 10;                    // 无符号整数示例值
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71; // 地址示例
    string name = "0xAA";           // 字符串示例
    uint[2] array = [5, 6];        // 固定长度数组示例

    /**
     * @dev 使用标准ABI编码规则对合约状态变量进行编码
     * @return result 返回编码后的字节数组
     * 注意：abi.encode会保留所有类型信息，适合合约间调用
     */
    function encode() public view returns (bytes memory result) {
        result = abi.encode(x, addr, name, array);
    }

    /**
     * @dev 使用紧凑编码方式对状态变量进行编码
     * @return result 返回编码后的字节数组
     * 注意：abi.encodePacked会尽可能减少空间使用，但不适合跨合约调用
     */
    function encodePacked() public view returns (bytes memory result) {
        result = abi.encodePacked(x, addr, name, array);
    }

    /**
     * @dev 使用函数签名进行编码
     * @return result 返回编码后的字节数组
     * @notice 第一个参数是函数签名字符串，后面是实际参数
     * 用途：模拟函数调用数据的编码方式
     */
    function encodeWithSignature() public view returns (bytes memory result) {
        result = abi.encodeWithSignature(
            "foo(uint256,address,string,uint256[2])", // 函数签名
            x,       // 第一个参数：uint256类型
            addr,    // 第二个参数：address类型
            name,    // 第三个参数：string类型
            array    // 第四个参数：uint256[2]固定数组类型
        );
    }

    /**
     * @dev 使用函数选择器进行编码
     * @return result 返回编码后的字节数组
     * @notice 第一个参数是函数选择器(函数签名的前4字节哈希)
     * 用途：与encodeWithSignature类似，但使用选择器而非完整签名
     */
    function encodeWithSelector() public view returns (bytes memory result) {
        result = abi.encodeWithSelector(
            bytes4(keccak256("foo(uint256,address,string,uint256[2])")), // 函数选择器
            x,    // uint256参数
            addr, // address参数
            name, // string参数
            array // uint256[2]数组参数
        );
    }

    /**
     * @dev 对编码后的数据进行解码
     * @param data 要解码的字节数组(必须是用abi.encode编码的数据)
     * @return dx 解码后的uint值
     * @return daddr 解码后的address值
     * @return dname 解码后的string值
     * @return darray 解码后的uint[2]数组
     * 注意：解码时的类型顺序必须与编码时完全一致
     */
    function decode(bytes memory data) public pure returns (
            uint dx,
            address daddr,
            string memory dname,
            uint[2] memory darray
        )
    {
        (dx, daddr, dname, darray) = abi.decode(
            data,                       // 要解码的字节数据
            (uint, address, string, uint[2]) // 指定解码后的类型顺序
        );
    }
}

// 在以太坊中，数据 必须编码成 字节码 才能和 智能合约 交互！

// Solidity中 ABI (Application Binary Interface，应用二进制接口 ) 是 与 以太坊智能合约 交互 的 标准。

// 数据 基于 他们的类型编码；并且 由于 编码后 不包含类型信息，解码时 需要注明 它们的类型。

// ABI 编码 有4个函数：abi.encode,  abi.encodePacked,  abi.encodeWithSignature,  abi.encodeWithSelector。

// ABI 解码 有1个函数：abi.decode，用于解码abi.encode的数据。



// 一个"跨合约消息传递系统"，通过ABI编码/解码实现合约间的数据交换。
contract MessageSystem {
    
    // 消息结构体
    struct Message {
        address sender;
        string content;
        uint256 timestamp;
        uint256[2] coordinates; // 示例数组参数
    }

    event MessageSent(address indexed sender, bytes encodedData);
    event MessageDecoded(address indexed sender, string content);

    /**
     * @dev 编码消息
     * @param _content 消息内容
     * @param _coordinates 位置坐标
     * @return encoded 编码后的消息数据
     */
    function encodeMessage(
        string memory _content,
        uint256[2] memory _coordinates
    ) public view returns (bytes memory encoded) {
        Message memory message = Message({
            sender: msg.sender,
            content: _content,
            timestamp: block.timestamp,
            coordinates: _coordinates
        });
        
        // 使用abi.encode编码结构体
        encoded = abi.encode(
            message.sender,
            message.content,
            message.timestamp,
            message.coordinates
        );
        
        emit MessageSent(msg.sender, encoded);
    }

    /**
     * @dev 解码消息
     * @param _data 编码后的消息数据
     * @return decoded 解码后的消息结构体
     */
    function decodeMessage(
        bytes memory _data
    ) public pure returns (Message memory decoded) {
        // 解码时必须保持与编码时相同的类型顺序
        (
            decoded.sender,
            decoded.content,
            decoded.timestamp,
            decoded.coordinates
        ) = abi.decode(_data, (address, string, uint256, uint256[2]));
    }

    /**
     * @dev 模拟跨合约调用编码
     * @param _target 目标合约地址
     * @param _content 消息内容
     * @param _coordinates 位置坐标
     * @return callData 编码后的调用数据
     */
    function prepareCallData(
        address _target,
        string memory _content,
        uint256[2] memory _coordinates
    ) public view returns (bytes memory callData) {
        // 使用encodeWithSignature生成调用数据
        callData = abi.encodeWithSignature(
            "receiveMessage(address,string,uint256,uint256[2])",
            _target,
            _content,
            block.timestamp,
            _coordinates
        );
    }

    /**
     * @dev 处理接收到的消息
     * @param _data 编码后的消息数据
     */
    function processMessage(bytes memory _data) external {
        Message memory message = decodeMessage(_data);
        emit MessageDecoded(message.sender, message.content);
    }
}

contract MessageReceiver {
    event MessageReceived(address sender, string content);

    /**
     * @dev 接收消息的函数
     * @param _sender 发送者地址
     * @param _content 消息内容
     * @param _timestamp 时间戳
     * @param _coordinates 位置坐标
     */
    function receiveMessage(
        address _sender,
        string memory _content,
        uint256 _timestamp,
        uint256[2] memory _coordinates
    ) external {
        emit MessageReceived(_sender, _content);
    }
}
