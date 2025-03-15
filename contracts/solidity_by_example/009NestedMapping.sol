// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// NestedMapping 合约中 定义了 一个 嵌套的 映射 数据结构，用于存储 地址 与 代币余额 之间 的 关系。
contract NestedMapping {

  // 声明一个 公开 的 嵌套映射，允许 外部访问 和 查询余额信息 。
  // 其中 外层映射 的 键 是 地址类型（address）， 代表 代币 的 所有者 ； 值 是 一个映射 ，是 一个内部映射，
  // 该 内部映射 的 键 是 字符串类型，代表 代币的名称 或 标识符，而 值 是 无符号的256位整数类型，代表 代币的余额 。 
  mapping(address => mapping(string => uint256)) public balances; 

  // 定义 setBalance函数, 允许 外部调用者 设置 或 更新 特定地址 和 代币名称 的 余额。 (通过 嵌套映射的键 直接设置 余额值)
  // setBalance函数 接收 的 参数 一一对应 上面的 嵌套映射 的 结构 
  //      ownerValue（address）：代币的所有者地址。
  //      tokenValue（string memory）：代币的名称或标识符。
  //      amountValue（uint256）：要设置的余额数量。
  function setBalance(address ownerValue, string memory tokenValue, uint256 amountValue) public { 

    balances[ownerValue][tokenValue] = amountValue; 
  } 

  // 定义 getBalance函数  允许 外部调用者 查询（获取） 特定地址 和 代币名称 的 余额
  // getBalance函数 接收 的 参数 ：
  //      ownerValue（address）：代币的所有者地址。
  //      tokenValue（string memory）：代币的名称 或 标识符。
  function getBalance(address ownerValue, string memory tokenValue) public view returns (uint256) { 

    return balances[ownerValue][tokenValue]; 
  } 

  // 定义 构造函数 用于 在合约部署时 初始化 一些示例数据， 实现 通过 setBalance函数 为 两个示例地址 分别设置了 两种代币的余额
  constructor() { 

    // 假设有 两个地址 和 两种代币  
    address owner1 = 0x32E649d3385182b41aebbDD58032B3939BCbA53B; // 示例地址1  
    address owner2 = 0xA5d68CE183B2bdCC48Fa283D55Bb4E1EdbA67F43; // 示例地址2  
    string memory tokenA = "TokenA"; 
    string memory tokenB = "TokenB"; 
    
    // 为两个地址分别设置代币A和代币B的余额  
    setBalance(owner1, tokenA, 100); 
    setBalance(owner1, tokenB, 200);
    setBalance(owner2, tokenA, 50); 
    setBalance(owner2, tokenB, 150); 

  } 

}


contract GameScoreSystem {
    // 定义游戏等级枚举
    enum GameLevel { Bronze, Silver, Gold }

    // 玩家信息结构体
    struct PlayerInfo {
        string name;        // 玩家名称
        GameLevel level;    // 玩家等级
        bool isActive;      // 是否激活
    }

    // 1. 基础映射：记录玩家基本信息
    mapping(address => PlayerInfo) public players;

    // 2. 嵌套映射：记录玩家在不同游戏中的分数
    // 第一层键：玩家地址
    // 第二层键：游戏名称
    // 值：玩家在该游戏中的分数
    mapping(address => mapping(string => uint)) public gameScores;

    // 3. 嵌套映射：记录玩家在不同游戏中的成就
    // 第一层键：玩家地址
    // 第二层键：游戏名称
    // 第三层键：成就名称
    // 值：是否获得该成就
    mapping(address => mapping(string => mapping(string => bool))) public achievements;

    // 事件：记录分数更新
    event ScoreUpdated(address player, string game, uint newScore);
    // 事件：记录成就获得
    event AchievementUnlocked(address player, string game, string achievement);

    // 注册新玩家
    function registerPlayer(string memory _name) public {
        // 确保玩家未注册
        require(!players[msg.sender].isActive, "Player already registered");
        
        // 创建新玩家信息
        players[msg.sender] = PlayerInfo({
            name: _name,
            level: GameLevel.Bronze,  // 初始等级为青铜
            isActive: true
        });
    }

    // 更新游戏分数
    function updateGameScore(string memory _game, uint _score) public {
        // 确保玩家已注册
        require(players[msg.sender].isActive, "Player not registered");
        
        // 更新分数
        gameScores[msg.sender][_game] = _score;
        
        // 触发事件
        emit ScoreUpdated(msg.sender, _game, _score);

        // 根据分数更新玩家等级
        updatePlayerLevel(_score);
    }

    // 解锁游戏成就
    function unlockAchievement(string memory _game, string memory _achievement) public {
        // 确保玩家已注册
        require(players[msg.sender].isActive, "Player not registered");
        
        // 设置成就为已获得
        achievements[msg.sender][_game][_achievement] = true;
        
        // 触发事件
        emit AchievementUnlocked(msg.sender, _game, _achievement);
    }

    // 查询玩家在特定游戏中的分数
    function getGameScore(address _player, string memory _game) public view returns (uint) {
        return gameScores[_player][_game];
    }

    // 查询玩家是否获得特定游戏的特定成就
    function hasAchievement(
        address _player, 
        string memory _game, 
        string memory _achievement
    ) public view returns (bool) {
        return achievements[_player][_game][_achievement];
    }

    // 内部函数：更新玩家等级
    function updatePlayerLevel(uint _score) internal {
        if (_score >= 1000) {
            players[msg.sender].level = GameLevel.Gold;
        } else if (_score >= 500) {
            players[msg.sender].level = GameLevel.Silver;
        }
    }

    // 获取玩家信息
    function getPlayerInfo(address _player) public view returns (
        string memory name,
        GameLevel level,
        bool isActive
    ) {
        PlayerInfo memory player = players[_player];
        return (player.name, player.level, player.isActive);
    }
}