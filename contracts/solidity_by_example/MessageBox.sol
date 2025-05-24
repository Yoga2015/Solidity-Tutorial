// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title 消息盒子：ABI编码解码示例
/// @notice 这个合约展示了如何使用ABI编码和解码来存储和读取消息
contract MessageBox {

    // 当新消息被存储时触发
    event MessageStored(address indexed sender, string messageType, uint256 timestamp);
    // 当消息被读取时触发
    event MessageRead(address indexed reader, uint256 messageId);


    // 定义消息结构
    struct Message {
        address sender;      // 发送者地址
        string content;      // 消息内容
        uint256 timestamp;   // 时间戳
        bool isEncrypted;    // 是否加密
        uint256[2] extraData; // 额外数据（例如：优先级和分类）
    }

    // 存储所有编码后的消息
    mapping(uint256 => bytes) private encodedMessages;
    // 消息计数器
    uint256 public messageCount;
    // 合约拥有者
    address public owner;

    constructor() {
        owner = msg.sender;  // 设置合约部署者为拥有者
        messageCount = 0;    // 初始化消息计数器
    }

    /// @notice 存储新消息（使用abi.encode）
    /// @param content 消息内容 、isEncrypted 是否加密、extraData 额外数据数组
    function storeMessage(
        string memory content,
        bool isEncrypted,
        uint256[2] memory extraData
    ) public returns (uint256) {
        // 创建新的消息结构
        Message memory newMessage = Message({
            sender: msg.sender,
            content: content,
            timestamp: block.timestamp,
            isEncrypted: isEncrypted,
            extraData: extraData
        });

        // 使用abi.encode编码整个消息结构
        bytes memory encodedData = abi.encode(
            newMessage.sender,
            newMessage.content,
            newMessage.timestamp,
            newMessage.isEncrypted,
            newMessage.extraData
        );

        messageCount++;   // 增加消息计数器
        
        encodedMessages[messageCount] = encodedData;  // 存储编码后的消息

        // 触发消息存储事件
        emit MessageStored(msg.sender, "Standard", block.timestamp);

        return messageCount;
    }

    /// @notice 存储紧凑消息（使用abi.encodePacked）
    /// @param content 消息内容
    function storeCompactMessage(string memory content) public returns (uint256) {
        // 使用abi.encodePacked进行更紧凑的编码
        bytes memory encodedData = abi.encodePacked(
            msg.sender,
            content,
            block.timestamp
        );
   
        messageCount++;    // 增加消息计数器
        
        encodedMessages[messageCount] = encodedData;   // 存储编码后的消息

        // 触发消息存储事件
        emit MessageStored(msg.sender, "Compact", block.timestamp);

        return messageCount;
    }

    /// @notice 读取标准消息
    /// @param messageId 消息ID
    function readMessage(uint256 messageId) public returns (Message memory) {
        
        require(messageId > 0 && messageId <= messageCount, "Invalid message ID");  // 检查消息ID是否有效
        
      
        bytes memory encodedData = encodedMessages[messageId];       // 获取编码的消息数据

        // 解码消息数据
        (
            address sender,
            string memory content,
            uint256 timestamp,
            bool isEncrypted,
            uint256[2] memory extraData
        ) = abi.decode(
            encodedData,
            (address, string, uint256, bool, uint256[2])
        );

        // 触发消息读取事件
        emit MessageRead(msg.sender, messageId);

        // 返回解码后的消息结构
        return Message(sender, content, timestamp, isEncrypted, extraData);
    }

    /// @notice 使用函数选择器调用消息处理（演示encodeWithSelector的使用）
    /// @param content 消息内容
    function processMessageWithSelector(string memory content) public returns (bytes memory) {
      
        // 使用encodeWithSelector编码函数调用
        bytes memory result = abi.encodeWithSelector(
            this.storeMessage.selector,
            content,
            false,
            [uint256(0), uint256(0)]
        );
        
        return result;
    }

    /// @notice 使用函数签名调用消息处理（演示encodeWithSignature的使用）
    /// @param content 消息内容
    function processMessageWithSignature(string memory content) public returns (bytes memory) {

        // 使用encodeWithSignature编码函数调用
        bytes memory result = abi.encodeWithSignature(
            "storeMessage(string,bool,uint256[2])",
            content,
            false,
            [uint256(0), uint256(0)]
        );
        
        return result;
    }

    /// @notice 获取消息总数
    function getMessageCount() public view returns (uint256) {
        return messageCount;
    }
}