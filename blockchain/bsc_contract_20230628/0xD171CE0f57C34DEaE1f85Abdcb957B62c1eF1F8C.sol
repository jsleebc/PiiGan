pragma solidity 0.8.4;
 
contract ElonPonzi {
    string public name = "ElonPonzi";
    string public symbol = "EPonzi";
    uint256 public totalSupply = 6900000000000000000000; 
    uint8 public decimals = 18;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }
    
    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(balanceOf[msg.sender] >= 1); // Ensure the sender has at least 1 token
        balanceOf[msg.sender] -= 1;
        balanceOf[_to] += 1;
        emit Transfer(msg.sender, _to, 1);
        return true;
    }
    
    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= 1;
        balanceOf[_to] += 1;
        allowance[_from][msg.sender] -= 1;
        emit Transfer(_from, _to, 1);
        return true;
    }
}