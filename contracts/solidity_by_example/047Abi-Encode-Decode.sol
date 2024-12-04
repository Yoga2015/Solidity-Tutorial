// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract AbiEncodeDecode {
    // 1、ABI解码
    // 将 编码 4个变量，他们的类型 分别是 uint256（别名 uint）, address, string, uint256[2]
    uint x = 10;
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    string name = "0xAA";
    uint[2] array = [5, 6];

    // abi.encode ：将 给定参数 利用 ABI规则 编码。
    function encode() public view returns (bytes memory result) {
        result = abi.encode(x, addr, name, array);
    }

    // abi。encodePacked : 将 给定参数 根据 其 所需 最低空间编码。
    function encodePacked() public view returns (bytes memory result) {
        result = abi.encodePacked(x, addr, name, array);
    }

    // abi.encodeWithSignature: 与 abi.encode功能类似，只不过 第一个参数 为 函数签名
    function encodeWithSignature() public view returns (bytes memory result) {
        result = abi.encodeWithSignature(
            "foo(uint256,address,string,uint256[2])",
            x,
            addr,
            name,
            array
        );
    }

    // abi.encodeWithSelector: 与abi.encodeWithSignature功能类似，只不过 第一个参数 为 函数选择器，为 函数签名Keccak哈希 的 前4个字节。
    function encodeWithSelector() public view returns (bytes memory result) {
        result = abi.encodeWithSelector(
            bytes4(keccak256("foo(uint256,address,string,uint256[2])")),
            x,
            addr,
            name,
            array
        );
    }

    // 2、ABI解码
    // abi.decode : 用于 解码 abi.encode 生成的 二进制编码，将 它 还原成 原本的参数。
    function decode(
        bytes memory data
    )
        public
        pure
        returns (
            uint dx,
            address daddr,
            string memory dname,
            uint[2] memory darray
        )
    {
        (dx, daddr, dname, darray) = abi.decode(
            data,
            (uint, address, string, uint[2])
        );
    }
}

// 在以太坊中，数据 必须编码成 字节码 才能和 智能合约 交互。

// Solidity中 ABI (Application Binary Interface，应用二进制接口 ) 是 与 以太坊智能合约 交互 的 标准。

// 数据 基于 他们的类型编码；并且 由于 编码后 不包含类型信息，解码时 需要注明 它们的类型。

// ABI 编码 有4个函数：abi.encode,  abi.encodePacked,  abi.encodeWithSignature,  abi.encodeWithSelector。

// ABI 解码 有1个函数：abi.decode，用于解码abi.encode的数据。
