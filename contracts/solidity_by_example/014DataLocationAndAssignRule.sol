// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract dataLocationAndAssignRule {
    uint[] public arr; // arr是一个状态变量，存储在storage中。

    constructor() {
        arr = [1, 2, 3]; // 初始化 状态变量arr
    }

    // modifyStorageArray函数 接受 一个storage类型的数组 作为 参数，并对 其 进行修改。
    // 由于 它是 直接引用 传入的 storage数组，所以修改 会影响 原数组。
    function modifyStorageArray(uint[] storage storageArr) internal {
        storageArr[0] = 100; // 修改storage数组，会影响原数组
    }

    // modifyMemoryArray函数中，tempArr 是 arr的一个副本，存储在memory中。对 tempArr 的 修改 不会影响arr。
    function modifyMemoryArray() public view {
        // tempArr 是 显式声明为 存储在 内存中(memory) 的 局部变量。(是一个 在函数调用期间 存储在 内存中 的 局部变量)
        uint[] memory tempArr = arr;

        tempArr[0] = 200; // 修改memory数组，不会影响原数组

        // 调用 内部函数 修改 storage数组
        modifyStorageArray(arr);

        // 此时，arr[0]的值 已经变为 100
    }

    function readCalldata(
        uint256[] calldata data
    ) external pure returns (uint256[] memory) {
        uint256[] memory arr2 = data; // 将 calldata 复制到 memory

        return arr2; // 返回 data 的副本
    }
}

// 在Solidity中，如果状态变量（state variable）没有进行显式声明其存储位置，它们默认会被认为是存储在合约的存储（storage）中的。
