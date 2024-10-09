// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Constants{

    // coding convention to uppercase constant variables

    // constant 变量必须在声明的时候初始化，之后再也不能改变。尝试改变的话，编译不通过。
    uint256 constant Num = 10;

    address public constant Constant_address = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    string constant Constant_string = '0xBB';

    bytes constant Constant_bytes = 'walking';

    uint public constant My_uint = 456;


    // function mod() public {

    //     Num = 22;

    //     My_uint = 789;   

    // }
}