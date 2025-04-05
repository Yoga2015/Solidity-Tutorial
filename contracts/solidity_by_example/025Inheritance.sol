// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// 写一个爷爷合约Yeye，包含1个Log事件和3个function: hip(), pop(), yeye()，输出都是”Yeye”。
contract Yeye {

    event Log(string msg);

    // 定义3个 function：hip()  , pop() , man()  , log值 为 Yeye

     // virtual 关键字 允许 子合约 重写此函数
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

// 继承：

// 父合约中的函数，如果希望子合约重写，需要加上virtual关键字。

// 子合约 重写了 父合约中的函数，需要加上 override 关键字。

// 部署合约，可以看到Baba合约里有4个函数，其中hip()和pop()的输出被成功改写成”Baba”，而继承来的yeye()的输出仍然是”Yeye”。

contract walking is Yeye, Baba {

    // 继承 两个 function： hip() 和 pop() ，输出值为 walking.
    function hip() public override(Yeye, Baba) {
        emit Log("walking");
    }

    function pop() public override(Yeye, Baba) {
        emit Log("walking");
    }
}


//  多重继承 ：Solidity 的 合约 可以继承 多个合约。 规则：

// 1、继承时 要按辈分 最高 到 最低的 顺序排。比如：我们写一个 Erzi合约，继承 Yeye合约 和 Baba合约，
//    那么就要写成 contract Erzi is Yeye, Baba，而不能写成 contract Erzi is Baba, Yeye，不然就会报错。

// 2、如果某一个函数在多个继承的合约里都存在，比如例子中的 hip() 和 pop()，在子合约里必须重写，不然会报错。

// 3、重写在多个父合约中都重名的函数时，override关键字后面要加上所有父合约名字，例如override(Yeye, Baba)。




// 基础合约：定义动物的基本特征
contract Animal {

    // 事件：记录动物的行为
    event AnimalAction(string action, string animal);
    
    // 动物的基本属性
    string public species;    // 物种
    uint public age;         // 年龄
    bool public isAlive;     // 是否存活
    
    // 构造函数：初始化动物属性
    constructor(string memory _species, uint _age) {
        species = _species;
        age = _age;
        isAlive = true;
    }
    
    // virtual 关键字允许子合约重写此函数
    function makeSound() public virtual {
        emit AnimalAction("makes sound", species);
    }
    
    // 基础移动函数
    function move() public virtual {
        emit AnimalAction("moves", species);
    }
}

// 中间合约：继承Animal，添加哺乳动物特征
contract Mammal is Animal {
    
    // 哺乳动物特有属性
    uint public bodyTemperature;    // 体温
    bool public hasFur;            // 是否有毛发
    
    // 构造函数：调用父合约构造函数并初始化新属性
    constructor(
        string memory _species,
        uint _age,
        uint _bodyTemp,
        bool _hasFur
    ) Animal(_species, _age) {
        bodyTemperature = _bodyTemp;
        hasFur = _hasFur;
    }
    
    // 重写父合约函数，使用 override 关键字
    function makeSound() public virtual override {
        emit AnimalAction("mammal sound", species);
    }
}

// 最终合约：多重继承示例
contract Dog is Mammal {
    // 狗的特有属性
    string public breed;    // 品种
    address public owner;   // 主人地址
    
    // 狗的行为事件
    event DogAction(string action, string breed);
    
    // 构造函数：设置所有属性
    constructor(
        string memory _breed,
        uint _age,
        uint _bodyTemp
    ) Mammal("Dog", _age, _bodyTemp, true) {
        breed = _breed;
        owner = msg.sender;
    }
    
    // 重写父合约函数
    function makeSound() public override {
        emit AnimalAction("barks", species);
        emit DogAction("woof woof", breed);
    }
    
    // 狗的特有功能
    function fetch() public {
        require(msg.sender == owner, "Only owner can play fetch");
        emit DogAction("fetches ball", breed);
    }
    
    // 展示继承链上的所有属性
    function getDogInfo() public view returns (
        string memory _species,
        string memory _breed,
        uint _age,
        uint _bodyTemp,
        bool _hasFur,
        address _owner
    ) {
        return (species, breed, age, bodyTemperature, hasFur, owner);
    }
}