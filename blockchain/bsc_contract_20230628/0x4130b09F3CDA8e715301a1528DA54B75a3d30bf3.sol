//SPDX-License-Identifier: MIT
/**
 *Submitted for verification at Etherscan.io on 2023-05-01
*/

// t.me/jaypeggers
// jaypeggers.com
pragma solidity ^0.8.0;

contract Jaypeggers {
    string public name = "jaypeggers";
    string public symbol = "JAY";
    uint8 public decimals = 18;
    uint256 private _totalSupply = 100000000 * 10 ** uint256(decimals);
    address private _owner;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _blacklist;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Blacklist(address indexed account, bool value);

    constructor() {
        _owner = msg.sender;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(!_blacklist[msg.sender], "Sender is blacklisted.");
        require(!_blacklist[recipient], "Recipient is blacklisted.");
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(!_blacklist[sender], "Sender is blacklisted.");
        require(!_blacklist[recipient], "Recipient is blacklisted.");
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        _transfer(sender, recipient, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
        return true;
    }

    function burn(uint256 amount) public {
        require(!_blacklist[msg.sender], "Sender is blacklisted.");
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) public {
        require(!_blacklist[account], "Account is blacklisted.");
        uint256 decreasedAllowance = _allowances[account][msg.sender] - amount;
        _approve(account, msg.sender, decreasedAllowance);
        _burn(account, amount);
    }

    function renounceOwnership() public {
        require(msg.sender == _owner, "Only the owner can renounce ownership.");
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == _owner, "Only the owner can transfer ownership.");
        require(newOwner != address(0), "New owner cannot be zero address.");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function addToBlacklist(address account) public {
        require(msg.sender == _owner, "Only the owner can add to blacklist.");
        require(!_blacklist[account], "Account is already blacklisted.");
        _blacklist[account] = true;
        emit Blacklist(account, true);
    }

    function removeFromBlacklist(address account) public {
        require(msg.sender == _owner, "Only the owner can remove from blacklist.");
        require(_blacklist[account], "Account is not blacklisted.");
        _blacklist[account] = false;
        emit Blacklist(account, false);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }
}