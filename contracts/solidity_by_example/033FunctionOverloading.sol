// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 购物车合约：展示函数重载的实际应用
contract ShoppingCart {

    // 定义商品结构体
    struct Item {
        string name;    // 商品名称
        uint256 price;  // 商品价格
        uint256 count;  // 商品数量
    }
    
    // 状态变量
    mapping(address => Item[]) public userCarts;  // 用户购物车映射
    
    // 事件声明
    event ItemAdded(address user, string name, uint256 price, uint256 count);
    
    // 函数重载示例1：添加商品（仅名称和价格）
    // @param _name 商品名称、_price 商品价格
    function addItem(string memory _name, uint256 _price) public {

        Item[] storage cart = userCarts[msg.sender];

        cart.push(Item({
            name: _name,
            price: _price,
            count: 1      // 默认数量为1
        }));
        
        emit ItemAdded(msg.sender, _name, _price, 1);
    }
    
    // 函数重载示例2：添加商品（指定数量）
    // @param _name 商品名称、_price 商品价格、_count 商品数量
    function addItem(string memory _name, uint256 _price, uint256 _count) public {

        require(_count > 0, "Count must be positive");

        Item[] storage cart = userCarts[msg.sender];

        cart.push(Item({
            name: _name,
            price: _price,
            count: _count
        }));

        emit ItemAdded(msg.sender, _name, _price, _count);
    }
    
    // 函数重载示例3：计算购物车总价
    // 不带参数：计算调用者的购物车总价
    function calculateTotal() public view returns (uint256) {
        return calculateTotal(msg.sender);
    }
    
    // 函数重载示例4：计算购物车总价
    // @param _user 指定用户地址
    function calculateTotal(address _user) public view returns (uint256) {
        uint256 total = 0;

        Item[] storage cart = userCarts[_user];

        for (uint i = 0; i < cart.length; i++) {
            total += cart[i].price * cart[i].count;
        }

        return total;
    }
    
    // 函数重载示例5：清空购物车
    // 不带参数：清空自己的购物车
    function clearCart() public {
        delete userCarts[msg.sender];
    }
    
    // 函数重载示例6：清空购物车
    // @param _index 删除指定索引的商品
    function clearCart(uint256 _index) public {

        require(_index < userCarts[msg.sender].length, "Invalid index");

        Item[] storage cart = userCarts[msg.sender];

        // 删除指定位置的商品
        for (uint i = _index; i < cart.length - 1; i++) {
            cart[i] = cart[i + 1];
        }

        cart.pop();
    }
}