//SPDX-License-Identifier: MIT
/**
 *Submitted for verification at bsc on 2023-04-30
*/

// t.me/PAPA
// papa.com
pragma solidity ^0.8.0;

contract PAPA {
    string public name = "PAPA";
    string public symbol = "PAPA";
    uint8 public decimals = 18;
    uint256 public totalSupply = 100000000 * 10 ** uint256(decimals);
    address public owner;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Burn(address indexed from, uint256 value);

    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance.");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(balanceOf[from] >= value, "Insufficient balance.");
        require(allowance[from][msg.sender] >= value, "Insufficient allowance.");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function burn(uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance.");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
        return true;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address.");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool success) {
        allowance[msg.sender][spender] += addedValue;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool success) {
        require(allowance[msg.sender][spender] >= subtractedValue, "Insufficient allowance.");
        allowance[msg.sender][spender] -= subtractedValue;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }
}