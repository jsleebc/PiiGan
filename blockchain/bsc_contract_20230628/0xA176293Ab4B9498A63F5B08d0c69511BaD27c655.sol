//SPDX-License-Identifier: UNLICENSED

// Solidity 0.8.2
pragma solidity ^0.8.2;

// PepeMARS name, symbol, totalSupply and decimals defined */
contract Token {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply = 1000000000000 * 10 ** 8;
    string public name = "PepeMARS";
    string public symbol = "PEPEMARS";
    uint public decimals = 8;

//Security Measures
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    
//PepeMARS events (Transfer and Approval)
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval (address indexed PEPEMARSCommunity, address indexed spender, uint value);

//PepeMARS constructor 
    constructor() {
        balances[msg.sender] = totalSupply;
    }

// PepeMARS Functions (balanceOf)
    function balanceOf(address PEPEMARSCommunity) public view returns(uint) {
        return balances[PEPEMARSCommunity];
    }

// PepeMARS Functions (transfer)    
    function transfer(address to, uint value) public noReentrant returns(bool) {
        require(balanceOf(msg.sender) >= value, 'insufficient fund ERROR');
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

//PepeMARS Functions (transferFrom)     
    function transferFrom(address from, address to, uint value) public noReentrant returns(bool) {
        require(balanceOf(from) >= value, 'insufficient fund ERROR');
        require(allowance[from][msg.sender] >= value, 'insufficient fund ERROR');
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }

//PepeMARS Functions (approve)     
    function approve(address spender, uint value) public returns(bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
}