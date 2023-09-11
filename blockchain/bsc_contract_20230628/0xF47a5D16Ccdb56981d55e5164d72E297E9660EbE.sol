//SPDX-License-Identifier: UNLICENSED

// Solidity 0.8.2
pragma solidity ^0.8.2;

// PePeAI name, symbol, totalSupply and decimals defined */
contract Token {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply = 100000000000 * 10 ** 8;
    string public name = "PePeAI";
    string public symbol = "PEPEAI";
    uint public decimals = 8;

//Security Mesures
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    
//PePeAI events (Transfer and Approval)
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval (address indexed PEPEAICommunity, address indexed spender, uint value);

//PePeAI constructor 
    constructor() {
        balances[msg.sender] = totalSupply;
    }

// PePeAI Functions (balanceOf)
    function balanceOf(address PEPEAICommunity) public view returns(uint) {
        return balances[PEPEAICommunity];
    }

// PePeAI Functions (transfer)    
    function transfer(address to, uint value) public noReentrant returns(bool) {
        require(balanceOf(msg.sender) >= value, 'insufficient fund ERROR');
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

//PePeAI Functions (transferFrom)     
    function transferFrom(address from, address to, uint value) public noReentrant returns(bool) {
        require(balanceOf(from) >= value, 'insufficient fund ERROR');
        require(allowance[from][msg.sender] >= value, 'insufficient fund ERROR');
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }

//PePeAI Functions (approve)     
    function approve(address spender, uint value) public returns(bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
}