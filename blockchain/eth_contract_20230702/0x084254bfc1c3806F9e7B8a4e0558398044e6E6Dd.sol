pragma solidity ^0.5.12;

// Vortex Token Contract
// Ticker: TEX
// Total Supply: 1000000000000
// Decimals: 18

contract VortexToken {
    string public constant name = "Vortex";
    string public constant symbol = "TEX";
    uint public constant decimals = 18;
    uint256 public totalSupply = 1000000000000 * 10 ** uint256(decimals);
    address public owner;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // constructor
    constructor() public {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
    }

    // Transfer Tokens
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value && _value > 0);
        require(_to != address(0));
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Approve Other Accounts to Spend Tokens
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Transfer Tokens from Another Account
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        require(_to != address(0));
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    // Buy Tax
    function calculatebuyTax(uint256 _value) public returns (bool success) {
        uint256 buyTax = _value * 8 / 100;
        require(balanceOf[msg.sender] >= _value);
        balanceOf[owner] += buyTax;
        balanceOf[msg.sender] -= _value;
        return true;
    }

    // Sell Tax
    function calculatesellTax(uint256 _value) public returns (bool success) {
        uint256 sellTax = _value * 27 / 100;
        require(balanceOf[msg.sender] >= _value);
        balanceOf[owner] += sellTax;
        balanceOf[msg.sender] -= _value;
        return true;
    }
}