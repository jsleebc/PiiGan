{{
  "language": "Solidity",
  "sources": {
    "1.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n\r\n/*\r\nhttps://twitter.com/elonmusk/status/1666498723629654035?s=46&t=wz55wp7gzrWExvc35o8LPQ\r\n\r\n\r\n*/\r\n\r\n\r\npragma solidity ^0.8.0;\r\n\r\n\r\ncontract ExtremelyConcerning {\r\n    string public name = \"Extremely Concerning\";\r\n    string public symbol = \"Concern\";\r\n    uint256 public totalSupply = 50_000_000_00* 10**18; \r\n    uint8 public decimals = 18;\r\n\r\n\r\n    mapping (address => uint256) public balanceOf;\r\n    mapping (address => mapping (address => uint256)) public allowance;\r\n\r\n    address public owner;\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        owner = msg.sender;\r\n        balanceOf[msg.sender] = totalSupply;\r\n    }\r\n\r\n    function transfer(address _to, uint256 _value) public returns (bool success) {\r\n        require(balanceOf[msg.sender] >= _value);\r\n        require(_to != address(0));\r\n        balanceOf[msg.sender] -= _value;\r\n        balanceOf[_to] += _value;\r\n        emit Transfer(msg.sender, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    function approve(address _spender, uint256 _value) public returns (bool success) {\r\n        allowance[msg.sender][_spender] = _value;\r\n        emit Approval(msg.sender, _spender, _value);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\r\n        require(balanceOf[_from] >= _value);\r\n        require(allowance[_from][msg.sender] >= _value);\r\n        require(_to != address(0));\r\n        balanceOf[_from] -= _value;\r\n        balanceOf[_to] += _value;\r\n        allowance[_from][msg.sender] -= _value;\r\n        emit Transfer(_from, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    function renounceOwnership() public onlyOwner {\r\n        emit OwnershipTransferred(owner, address(0));\r\n        owner = address(0);\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(msg.sender == owner, \"Only the owner can call this function.\");\r\n        _;\r\n    }\r\n}"
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