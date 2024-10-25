// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 如果一个智能合约里至少有一个未实现的函数，即某个函数缺少主体{}中的内容，则必须将 该 合约 标为 abstract，不然编译会报错
abstract contract InsertionSort{
    
     // 还没想好具体 怎么实现 插入排序 函数, 那么可以把 合约 标为 abstract，之后让别人补写上
     // 另外，未实现的函数 需要加 virtual，以便 子合约 重写。
    function insertionSort(uint[] memory a) public pure virtual returns(uint[] memory);
    
    // 这个 插入排序 函数  已想好 编写了 具体实现
    function insertionSort2(uint[] memory a) public pure returns(uint[] memory) {

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