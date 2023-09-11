// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LADYS {
    string public name = "LADYS";
    string public symbol = "LADYS";
    uint256 public totalSupply = 888000888000888 * 10 ** 18; // 总量为 888000888000888，小数点精度为 18 位
    uint8 public decimals = 18;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    uint256 public buySellTax = 3; // 买入卖出税收为 3%
    address public creator = 0x80a5aeA21479F68e448f3B370CA43f5d0B20B912; // 创建者地址
    address public marketingWallet = 0x7C998bcB5EF30e91cf7A4dba6D6c4f927A6b6Ce2; // 营销钱包地址
    address public tokenReceiver = 0x0087a81B824D73cC5138bA331C3ABF194592B051; // 代币接收地址

    constructor() {
        balanceOf[creator] = totalSupply;
        emit Transfer(address(0), creator, totalSupply);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_from != address(0), "Transfer from the zero address");
        require(_to != address(0), "Transfer to the zero address");
        require(_value > 0, "Transfer amount must be greater than zero");
        require(balanceOf[_from] >= _value, "Insufficient balance");

        uint256 taxAmount = (_value * buySellTax) / 100; // 计算税收
        uint256 transferAmount = _value - taxAmount; // 计算实际转账数量

        balanceOf[_from] -= _value;
        balanceOf[_to] += transferAmount;
        balanceOf[marketingWallet] += taxAmount;

        emit Transfer(_from, _to, transferAmount);
        emit Transfer(_from, marketingWallet, taxAmount);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender], "Insufficient allowance");
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
}