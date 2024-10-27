// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract errorException{

    address[] _owners;

    // error TransferNotOwner();    // require 抛出异常方法，定义 一个 没有携带参数 的 error 抛出异常方法

    // 1、定义一个 携带参数 的 异常，来提示 尝试转账 的 账户地址
    error TransferNotOwner(address sender); 

    // 在执行当中，error 必须搭配 revert（回退）命令使用。
    function transferOwner1(uint256 tokenId,address newOwner) public {

        if( _owners[tokenId] != msg.sender ) {   // 检查 代币 的 owner 是不是 发起人

            // revert TransferNotOwner();

            revert TransferNotOwner(msg.sender);

        }

        _owners[tokenId] = newOwner;
    }

    // 定义了一个 transferOwner1()函数，它会检查 代币的owner 是不是 发起人. 
    // 如果不是，就会抛出 TransferNotOwner异常 ；如果是的话，就会转账。


    // 2、require 抛出异常方法
    // 定义 一个 transferOwner2() 函数，它会检查 代币的owner 是不是 发起人
    function transferOwner2(uint256 tokenId, address newOwner) public {

        // 定义一个 携带参数 的 require 这种抛出异常方法. 检查 代币的owner 是不是发起人，如果不是，就会抛出异常
        require(_owners[tokenId] != msg.sender,"Transfer not owner");   

        _owners[tokenId] = newOwner;    // 如果是的话，就会转账。
    }


    // 3、定义 一个 transferOwner3() 函数，它会检查 代币的owner 是不是 发起人
    function transferOwner3(uint256 tokenId, address newOwner) public {

        // 定义一个 携带参数 的 assert 这种抛出异常方法. 检查 代币的owner 是不是发起人，如果不是，就会抛出异常
        assert(_owners[tokenId] != msg.sender);   

        _owners[tokenId] = newOwner;    // 如果是的话，就会转账。
    }

}

