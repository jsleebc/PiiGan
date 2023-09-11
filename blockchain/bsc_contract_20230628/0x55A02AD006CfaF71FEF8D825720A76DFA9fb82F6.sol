//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract BarbiePepe {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;

    string public name = "BarbiePEPE";
    string public symbol = "BPEPE";

    uint256 public numberOfCoins = 1000000000;
    uint256 public decimalls = 9;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    uint256 public totalSupply = numberOfCoins * 10**decimalls;
    uint256 public decimals = decimalls;

    address public contractOwner;

    constructor() {
        contractOwner = 0x7Cb6b6936F6148fc8bAbF4714f87FF7462ffDF29;
        balances[0x7Cb6b6936F6148fc8bAbF4714f87FF7462ffDF29] = totalSupply;
        emit Transfer(
            address(0),
            0x7Cb6b6936F6148fc8bAbF4714f87FF7462ffDF29,
            totalSupply
        );
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf(msg.sender) >= value, "Balance too low");
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(balanceOf(from) >= value, "Balance too low");
        require(allowance[from][msg.sender] >= value, "Allowance too low");
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function destroyTokens(uint256 value) public returns (bool) {
        if (msg.sender == contractOwner) {
            require(balanceOf(msg.sender) >= value, "Balance too low");
            totalSupply -= value;
            balances[msg.sender] -= value;
            return true;
        }
        return false;
    }

    function renounceOwnership() public returns (bool) {
        if (msg.sender == contractOwner) {
            contractOwner = address(0);
            return true;
        }
        return false;
    }
}