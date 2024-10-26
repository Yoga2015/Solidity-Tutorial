// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IERC20 {

    function totalSupply() external view returns (uint256);    // 返回  代币的总供应量

    function balanceOf(address account) external view returns (uint256);   // 查询 特定地址 持有的 代币余额

    function transfer(address recipient, uint256 amount) external returns (bool);   // 将 代币 从 一个账户 (调用者地址) 转移到 另一个账户

    function allowance(address owner, address spender) external view returns (uint256);  // 查询 一个账户 允许 另一个账户（即“spender”）, 从 其账户 中 转出的 最大代币数量。

    function approve(address spender, uint256 amount) external returns (bool);  // 批准 一个账户  可以从  你的账户中  转出   指定数量的代币 
    
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);  // 批准 一个账户  可以从  你的账户中  转出   指定数量的代币

}


contract ERC20 is IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval( address indexed owner, address indexed spender, uint256 value);

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function transfer(address recipient, uint256 amount) external returns (bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from1, uint256 amount) internal {
        balanceOf[from1] -= amount;
        totalSupply -= amount;
        emit Transfer(from1, address(0), amount);
    }

    function mint(address to1, uint256 amount1) external {
        _mint(to1, amount1);
    }

    function burn(address from1, uint256 amount) external {
        _burn(from1, amount);
    }
}


// contract interactBAYC {

//     // 利用 BAYC地址 创建 接口合约 变量（ETH主网）
//     IERC721 BAYC = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);

//     // 通过 接口调用 BAYC 的 balanceOf() 查询 持仓量
//     function balanceOfBAYC(address owner) external view returns (uint256 balance){
//         return BAYC.balanceOf(owner);
//     }

//     // 通过 接口调用 BAYC 的 safeTransferFrom() 安全转账
//     function safeTransferFromBAYC(address from, address to, uint256 tokenId) external{
//         BAYC.safeTransferFrom(from, to, tokenId);
//     }
// }




