{{
  "language": "Solidity",
  "sources": {
    "refinance.sol": {
      "content": "\npragma solidity ^0.4.25;\n\ninterface ERC20 {\n  function totalSupply() external view returns (uint256);\n  function balanceOf(address who) external view returns (uint256);\n  function allowance(address owner, address spender) external view returns (uint256);\n  function transfer(address to, uint256 value) external returns (bool);\n  function approve(address spender, uint256 value) external returns (bool);\n  function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);\n  function transferFrom(address from, address to, uint256 value) external returns (bool);\n\n  event Transfer(address indexed from, address indexed to, uint256 value);\n  event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ninterface ApproveAndCallFallBack {\n    function receiveApproval(address from, uint256 tokens, address token, bytes data) external;\n}\n\n\ncontract LIQUID is ERC20 {\n  using SafeMath for uint256;\n\n  mapping (address => uint256) private balances;\n  mapping (address => mapping (address => uint256)) private allowed;\n  string public constant name  = \"LIQUID\";\n  string public constant symbol = \"LQD\";\n  uint8 public constant decimals = 18;\n  \n  address owner = msg.sender;\n\n  uint256 _totalSupply = 1000000000000 * (10 ** 18); // 1 trillion supply\n\n  constructor() public {\n    balances[msg.sender] = _totalSupply;\n    emit Transfer(address(0), msg.sender, _totalSupply);\n  }\n\n  function totalSupply() public view returns (uint256) {\n    return _totalSupply;\n  }\n\n  function balanceOf(address player) public view returns (uint256) {\n    return balances[player];\n  }\n\n  function allowance(address player, address spender) public view returns (uint256) {\n    return allowed[player][spender];\n  }\n\n\n  function transfer(address to, uint256 value) public returns (bool) {\n    require(value <= balances[msg.sender]);\n    require(to != address(0));\n\n    balances[msg.sender] = balances[msg.sender].sub(value);\n    balances[to] = balances[to].add(value);\n\n    emit Transfer(msg.sender, to, value);\n    return true;\n  }\n\n  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {\n    for (uint256 i = 0; i < receivers.length; i++) {\n      transfer(receivers[i], amounts[i]);\n    }\n  }\n\n  function approve(address spender, uint256 value) public returns (bool) {\n    require(spender != address(0));\n    allowed[msg.sender][spender] = value;\n    emit Approval(msg.sender, spender, value);\n    return true;\n  }\n\n  function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {\n        allowed[msg.sender][spender] = tokens;\n        emit Approval(msg.sender, spender, tokens);\n        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n        return true;\n    }\n\n  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n    require(value <= balances[from]);\n    require(value <= allowed[from][msg.sender]);\n    require(to != address(0));\n    \n    balances[from] = balances[from].sub(value);\n    balances[to] = balances[to].add(value);\n    \n    allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n    \n    emit Transfer(from, to, value);\n    return true;\n  }\n\n  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n    require(spender != address(0));\n    allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);\n    emit Approval(msg.sender, spender, allowed[msg.sender][spender]);\n    return true;\n  }\n\n  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n    require(spender != address(0));\n    allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);\n    emit Approval(msg.sender, spender, allowed[msg.sender][spender]);\n    return true;\n  }\n\n  function burn(uint256 amount) external {\n    require(amount != 0);\n    require(amount <= balances[msg.sender]);\n    _totalSupply = _totalSupply.sub(amount);\n    balances[msg.sender] = balances[msg.sender].sub(amount);\n    emit Transfer(msg.sender, address(0), amount);\n  }\n\n}\n\n\n\n\nlibrary SafeMath {\n  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n    if (a == 0) {\n      return 0;\n    }\n    uint256 c = a * b;\n    require(c / a == b);\n    return c;\n  }\n\n  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n    uint256 c = a / b;\n    return c;\n  }\n\n  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n    require(b <= a);\n    return a - b;\n  }\n\n  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n    uint256 c = a + b;\n    require(c >= a);\n    return c;\n  }\n\n  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n    uint256 c = add(a,m);\n    uint256 d = sub(c,1);\n    return mul(div(d,m),m);\n  }\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
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