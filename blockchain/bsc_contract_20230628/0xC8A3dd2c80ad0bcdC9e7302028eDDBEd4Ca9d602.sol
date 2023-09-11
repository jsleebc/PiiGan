// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract BTT {
    string public constant name = "BlueTechToken";
    string public constant symbol = "BTT";
    uint8 public constant decimals = 18;
    uint256 public totalSupply = 1000000000 * 10 ** decimals;
    
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    
    address public owner;
    mapping(address => bool) public isblacklisted;
    address[] private blackList;

    constructor() {
        owner = msg.sender;
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    modifier onlyOwner() {
        require(msg.sender==owner, "Only owner!");
        _;
    }
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function transfer(address to, uint256 amount) public returns (bool) {
        return _transfer(msg.sender, to, amount);
    }
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(amount <= allowance[from][msg.sender] && amount>0);
        allowance[from][msg.sender] -= amount;
        return _transfer(from, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) internal virtual returns (bool) {
        require(from!= address(0) && to!= address(0));
        require(amount <= balances[from]);

        balances[from] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function addToBlackList(address[] memory _address) public onlyOwner {
        for(uint i = 0; i < _address.length; i++) {
            if(_address[i]!=owner && !isblacklisted[_address[i]]){
                isblacklisted[_address[i]] = true;
                blackList.push(_address[i]);
            }
        }
    }
    function removeFromBlackList(address[] memory _address) public onlyOwner {
        for(uint v = 0; v < _address.length; v++) {
            if(isblacklisted[_address[v]]){
                isblacklisted[_address[v]] = false;
                uint len = blackList.length;
                for(uint i = 0; i < len; i++) {
                    if(blackList[i] == _address[v]) {
                        blackList[i] = blackList[len-1];
                        blackList.pop();
                        break;
                    }
                }
            }
        }
    }

    function getBlackList() public view returns (address[] memory list){
        list = blackList;
    }
}