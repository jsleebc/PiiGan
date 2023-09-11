{{
  "language": "Solidity",
  "sources": {
    "acubees.sol": {
      "content": "/*  We are Acubees. we are AI creatures that live on the ethereum blockchain.\r\n    we believe code is law so we keep it clean and short, easy to review.\r\n    feel free to join the movement for decentralization.\r\n    twitter: https://twitter.com/acubees\r\n    ENS name: aucbees.eth \r\n*/\r\n// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\ncontract Acubees {\r\n    string public name;\r\n    string public symbol;\r\n    uint8 public decimals;\r\n    uint256 public totalSupply;\r\n    address public owner;\r\n    mapping(address => uint256) public balanceOf;\r\n    mapping(address => mapping(address => uint256)) public allowance;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    constructor() {\r\n        name = \"Acubees\";\r\n        symbol = \"Acubee\";\r\n        decimals = 3;\r\n        totalSupply = 1032 * 10 ** uint256(decimals);\r\n        owner = msg.sender;\r\n        balanceOf[msg.sender] = totalSupply;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(msg.sender == owner, \"Acubees: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public onlyOwner {\r\n        emit OwnershipTransferred(owner, address(0));\r\n        owner = address(0);\r\n    }\r\n\r\n    function transfer(address to, uint256 value) public returns (bool) {\r\n        require(to != address(0), \"Acubees: transfer to the zero address\");\r\n        require(value <= balanceOf[msg.sender], \"Acubees: insufficient balance\");\r\n\r\n        balanceOf[msg.sender] -= value;\r\n        balanceOf[to] += value;\r\n        emit Transfer(msg.sender, to, value);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address from, address to, uint256 value) public returns (bool) {\r\n        require(to != address(0), \"Acubees: transfer to the zero address\");\r\n        require(value <= balanceOf[from], \"Acubees: insufficient balance\");\r\n        require(value <= allowance[from][msg.sender], \"Acubees: insufficient allowance\");\r\n\r\n        balanceOf[from] -= value;\r\n        balanceOf[to] += value;\r\n        allowance[from][msg.sender] -= value;\r\n        emit Transfer(from, to, value);\r\n        return true;\r\n    }\r\n\r\n    function approve(address spender, uint256 value) public returns (bool) {\r\n        allowance[msg.sender][spender] = value;\r\n        emit Approval(msg.sender, spender, value);\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\r\n        allowance[msg.sender][spender] += addedValue;\r\n        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\r\n        uint256 currentAllowance = allowance[msg.sender][spender];\r\n        require(currentAllowance >= subtractedValue, \"Acubees: allowance cannot be negative\");\r\n\r\n        allowance[msg.sender][spender] = currentAllowance - subtractedValue;\r\n        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);\r\n        return true;\r\n    }\r\n}\r\n"
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