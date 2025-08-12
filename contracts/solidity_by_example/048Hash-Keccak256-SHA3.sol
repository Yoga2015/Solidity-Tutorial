// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract HashKeccak256SHA3 {

    // 预计算的哈希值，使用keccak256对"OxAA"进行哈希
    bytes32 _msg = keccak256(abi.encodePacked("OxAA"));
    
    bytes32 public _temp;    // 用于临时存储哈希值

    /**
     * @dev 生成数据的唯一哈希标识
     * @param _num 无符号整数输入
     * @param _string 字符串输入 
     * @param _addr 地址输入
     * @return bytes32 返回组合参数的keccak256哈希值
     * 注意：使用abi.encodePacked紧密打包参数
     */
    function hash(
        uint _num,
        string memory _string,
        address _addr
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_num, _string, _addr));
    }

    /**
     * @dev 测试哈希函数的弱抗碰撞性
     * @param string1 待比较的字符串
     * @return bool 返回输入字符串的哈希是否等于预存的_msg哈希
     * 弱抗碰撞性：难以找到不同的输入产生相同的哈希
     */
    function weak(string memory string1) public view returns (bool) {
        return keccak256(abi.encodePacked(string1)) == _msg;
    }

    /**
     * @dev 测试哈希函数的强抗碰撞性
     * @param string1 第一个字符串
     * @param string2 第二个字符串
     * @return bool 返回两个字符串的哈希是否相同
     * 强抗碰撞性：难以找到任意两个不同的输入产生相同的哈希
     */
    function strong(
        string memory string1,
        string memory string2
    ) public pure returns (bool) {
        return
            keccak256(abi.encodePacked(string1)) ==
            keccak256(abi.encodePacked(string2));
    }
}

// 什么是 hash 哈希函数?

// 哈希函数（hash function）是一个密码学概念。

// 哈希函数（hash function）可以 将 任意长度的消息 转换为 一个固定长度的值，这个值 也称作 哈希（hash）。

// 上面介绍了 如何使用 Solidity 最常用的 哈希函数 keccak256()


// 一个基于哈希函数的"文件完整性验证系统"合约
contract FileIntegrityVerifier {

    // 文件哈希记录
    struct FileRecord {
        bytes32 originalHash; // 文件原始哈希值
        uint256 timestamp;    // 记录时间戳
        address uploader;     // 上传者地址
    }
    
    // 文件ID到记录的映射
    mapping(string => FileRecord) public fileRecords;
    
    // 事件
    event FileRegistered(string fileId, bytes32 fileHash, address uploader);
    event IntegrityVerified(string fileId, bool isVerified);

    /**
     * @dev 注册文件哈希
     * @param _fileId 文件唯一标识符
     * @param _fileHash 文件内容哈希值
     * 要求: 文件ID不能已注册过
     */
    function registerFile(string memory _fileId, bytes32 _fileHash) external {
        require(fileRecords[_fileId].timestamp == 0, "File already registered");
        
        fileRecords[_fileId] = FileRecord({
            originalHash: _fileHash,
            timestamp: block.timestamp,
            uploader: msg.sender
        });
        
        emit FileRegistered(_fileId, _fileHash, msg.sender);
    }

    /**
     * @dev 验证文件完整性
     * @param _fileId 文件唯一标识符
     * @param _currentHash 当前文件内容哈希值
     * @return 是否与原始哈希一致
     */
    function verifyIntegrity(
        string memory _fileId, 
        bytes32 _currentHash
    ) external returns (bool) {
        require(fileRecords[_fileId].timestamp != 0, "File not registered");
        
        bool isVerified = fileRecords[_fileId].originalHash == _currentHash;
        emit IntegrityVerified(_fileId, isVerified);
        return isVerified;
    }

    /**
     * @dev 计算文件哈希(实用工具函数)
     * @param _content 文件内容
     * @return 文件内容哈希值
     */
    function calculateHash(string memory _content) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_content));
    }
    
    /**
     * @dev 批量验证文件完整性
     * @param _fileIds 文件ID数组
     * @param _currentHashes 当前哈希数组
     * @return 验证结果数组
     */
    function batchVerify(
        string[] memory _fileIds,
        bytes32[] memory _currentHashes
    ) external view returns (bool[] memory) {
        require(_fileIds.length == _currentHashes.length, "Input length mismatch");
        
        bool[] memory results = new bool[](_fileIds.length);
        for(uint i = 0; i < _fileIds.length; i++) {
            if(fileRecords[_fileIds[i]].timestamp != 0) {
                results[i] = fileRecords[_fileIds[i]].originalHash == _currentHashes[i];
            }
        }
        return results;
    }
}
