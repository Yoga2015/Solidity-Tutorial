// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract InsertionSort{

    // 插入排序 : 错误写法。Solidity中最常用的变量类型是uint，也就是正整数，取到负值的话，会报underflow错误
    function insertionSortWrong(uint[] memory a) public pure returns(uint[] memory){

        for (uint i = 1; i < a.length; i++){

            uint temp = a[i];
            uint j=i-1;

            while( (j >= 0) && (temp < a[j])){
                a[j+1] = a[j];
                j--;
            }

            a[j+1] = temp;
        }

        return(a);
    }
    

    // 插入排序 : 正确写法
    function insertionSort(uint[] memory a) public pure returns(uint[] memory) {

        // note that uint can not take negative value
        for (uint i = 1; i < a.length; i++){

            uint temp = a[i];
            uint j=i;

            while( (j >= 1) && (temp < a[j-1])){
                a[j] = a[j-1];
                j--;
            }

            a[j] = temp;
        }

        return(a);
    }
}