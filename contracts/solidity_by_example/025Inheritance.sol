// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// 写一个爷爷合约Yeye，里面包含1个Log事件和3个function: hip(), pop(), yeye()，输出都是”Yeye”。
contract Yeye {
    event Log(string msg);

    // 定义3个 function：hip()  , pop() , man()  , log值 为 Yeye
    function hip() public virtual {
        emit Log("Yeye");
    }

    function pop() public virtual {
        emit Log("Yeye");
    }

    function yeye() public virtual {
        emit Log("Yeye");
    }
}

//  再定义一个爸爸合约Baba，让他继承Yeye合约，语法就是contract Baba is Yeye
//  在 Baba合约里，我们重写一下hip()和pop()这两个函数，加上override关键字，并将他们的输出改为”Baba”；
//  并且 加一个新的函数baba，输出也是”Baba”。
contract Baba is Yeye {
    // 继承 两个 function : hip() 和 pop(), 输出改为 Baba
    function hip() public virtual override {
        emit Log("Baba");
    }

    function pop() public virtual override {
        emit Log("Baba");
    }

    function baba() public virtual {
        emit Log("Baba");
    }
}

// 父合约中的函数，如果希望子合约重写，需要加上virtual关键字。

// 子合约 重写了 父合约中的函数，需要加上 override 关键字。

// 部署合约，可以看到Baba合约里有4个函数，其中hip()和pop()的输出被成功改写成”Baba”，而继承来的yeye()的输出仍然是”Yeye”。

//  多重继承 ：Solidity 的 合约 可以继承 多个合约。 规则：

// 1、继承时 要按辈分 最高 到 最低的 顺序排。比如：我们写一个 Erzi合约，继承 Yeye合约 和 Baba合约，
//    那么就要写成 contract Erzi is Yeye, Baba，而不能写成 contract Erzi is Baba, Yeye，不然就会报错。

// 2、如果某一个函数在多个继承的合约里都存在，比如例子中的 hip() 和 pop()，在子合约里必须重写，不然会报错。

// 3、重写在多个父合约中都重名的函数时，override关键字后面要加上所有父合约名字，例如override(Yeye, Baba)。

contract walking is Yeye, Baba {
    // 继承 两个 function： hip() 和 pop() ，输出值为 walking.
    function hip() public override(Yeye, Baba) {
        emit Log("walking");
    }

    function pop() public override(Yeye, Baba) {
        emit Log("walking");
    }
}
