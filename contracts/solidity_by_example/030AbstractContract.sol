// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 定义一个 动物 抽象合约
abstract contract Animal {

    // 基础属性
    string public name;        // 动物名称
    uint public age;          // 动物年龄
    bool public isAlive;      // 是否存活

    // 构造函数：初始化 基础属性
    constructor(string memory _name, uint _age) {
        name = _name;
        age = _age;
        isAlive = true;
    }

    // 抽象函数：发出声音
    // 因为每种动物的叫声不同，所以这里只声明不实现
    function makeSound() public virtual returns (string memory);

    // 具体函数：动物年龄增长
    function grow() public {
        age += 1;
    }
}

// 定义一个猫咪合约，继承自 动物合约
contract Cat is Animal {

    // 猫咪特有属性
    bool public isLazy;       // 是否懒惰
    uint public lives;        // 剩余生命数量

    // 构造函数
    constructor(
        string memory _name,
        uint _age,
        bool _isLazy
    ) Animal(_name, _age) {
        isLazy = _isLazy;
        lives = 9;            // 猫有九条命
    }

    // 实现抽象函数makeSound
    function makeSound() public pure override returns (string memory) {
        return "Meow!";       // 猫叫声
    }

    // 重写grow函数
    function grow() public override {

        super.grow();         // 调用父合约的grow

        if (isLazy) {
            lives -= 1;       // 如果是懒猫，每长大一岁减少一条命
        }

    }
}

// 定义一个狗狗合约，也继承自动物合约
contract Dog is Animal {
    
    // 狗狗特有属性
    bool public isLoyal;      // 是否忠诚
    uint public tricks;       // 会的把戏数量

    // 构造函数
    constructor(
        string memory _name,
        uint _age,
        bool _isLoyal
    ) Animal(_name, _age) {
        isLoyal = _isLoyal;
        tricks = 0;
    }

    // 实现抽象函数makeSound
    function makeSound() public pure override returns (string memory) {
        return "Woof!";       // 狗叫声
    }

    // 学习新把戏
    function learnTrick() public {
        tricks += 1;
    }
}