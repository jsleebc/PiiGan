{{
  "language": "Solidity",
  "sources": {
    "mverse.sol": {
      "content": "/*\nmemeverse.biz/\nt.me/MemeverseVerify\n*/\n\npragma solidity 0.5.8;\n\ninterface ERC20 {\n  function totalSupply() external view returns (uint256);\n  function balanceOf(address who) external view returns (uint256);\n  function allowance(address owner, address spender) external view returns (uint256);\n  function transfer(address to, uint256 value) external returns (bool);\n  function approve(address spender, uint256 value) external returns (bool);\n  function transferFrom(address from, address to, uint256 value) external returns (bool);\n\n  event Transfer(address indexed from, address indexed to, uint256 value);\n  event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ncontract Memeverse is ERC20 {\n    using SafeMath for uint256;\n\n    mapping (address => uint256) private balances;\n    mapping (address => mapping (address => uint256)) private allowed;\n\n    string public constant name  = \"MEMEVERSE\";\n    string public constant symbol = \"MVERSE\";\n    uint8 public constant decimals = 18;\n    uint256 constant MAX_SUPPLY = 500000 * (10 ** 18);\n\n    constructor() public {\n        balances[msg.sender] = MAX_SUPPLY;\n        emit Transfer(address(0), msg.sender, MAX_SUPPLY);\n    }\n\n    function totalSupply() public view returns (uint256) {\n        return MAX_SUPPLY;\n    }\n\n    function balanceOf(address player) public view returns (uint256) {\n        return balances[player];\n    }\n\n    function allowance(address player, address spender) public view returns (uint256) {\n        return allowed[player][spender];\n    }\n\n    function transfer(address to, uint256 amount) public returns (bool) {\n        require(to != address(0));\n        transferInternal(msg.sender, to, amount);\n        return true;\n    }\n\n    function transferFrom(address from, address to, uint256 amount) public returns (bool) {\n        require(to != address(0));\n        allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);\n        transferInternal(from, to, amount);\n        return true;\n    }\n\n    function transferInternal(address from, address to, uint256 amount) internal {\n        balances[from] = balances[from].sub(amount);\n        balances[to] = balances[to].add(amount);\n        emit Transfer(from, to, amount);\n    }\n\n    function approve(address spender, uint256 value) public returns (bool) {\n        require(spender != address(0));\n        allowed[msg.sender][spender] = value;\n        emit Approval(msg.sender, spender, value);\n        return true;\n    }\n\n}\n\n\nlibrary SafeMath {\n  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n    if (a == 0) {\n      return 0;\n    }\n    uint256 c = a * b;\n    require(c / a == b);\n    return c;\n  }\n\n  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n    uint256 c = a / b;\n    return c;\n  }\n\n  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n    require(b <= a);\n    return a - b;\n  }\n\n  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n    uint256 c = a + b;\n    require(c >= a);\n    return c;\n  }\n\n  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n    uint256 c = add(a,m);\n    uint256 d = sub(c,1);\n    return mul(div(d,m),m);\n  }\n}"
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