{{
  "language": "Solidity",
  "sources": {
    "1.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n/**\r\n    8 8                                                                            \r\n ad88888ba   88888888ba,    88  88888888888  ad88888ba   88888888888  88           \r\nd8\" 8 8 \"8b  88      `\"8b   88  88          d8\"     \"8b  88           88           \r\nY8, 8 8      88        `8b  88  88          Y8,          88           88           \r\n`Y8a8a8a,    88         88  88  88aaaaa     `Y8aaaaa,    88aaaaa      88           \r\n  `\"8\"8\"8b,  88         88  88  88\"\"\"\"\"       `\"\"\"\"\"8b,  88\"\"\"\"\"      88           \r\n    8 8 `8b  88         8P  88  88                  `8b  88           88           \r\nY8a 8 8 a8P  88      .a8P   88  88          Y8a     a8P  88           88           \r\n \"Y88888P\"   88888888Y\"'    88  88888888888  \"Y88888P\"   88888888888  88888888888  \r\n    8 8                                                                            \r\n                                                                                       \r\n   web:https://vindis.pro/\r\n   tg: https://t.me/Diesel_ETH_Tok\r\n   Living a quarter mile at a time..                                                                                \r\n                                                                                   */\r\n\r\npragma solidity ^0.8.0;\r\n\r\n\r\ncontract DIESEL {\r\n    string public name = \"DIESEL\";\r\n    string public symbol = \"DIESEL\";\r\n    uint256 public totalSupply = 5_000_000* 10**18; \r\n    uint8 public decimals = 18;\r\n\r\n\r\n    mapping (address => uint256) public balanceOf;\r\n    mapping (address => mapping (address => uint256)) public allowance;\r\n\r\n    address public owner;\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        owner = msg.sender;\r\n        balanceOf[msg.sender] = totalSupply;\r\n    }\r\n\r\n    function transfer(address _to, uint256 _value) public returns (bool success) {\r\n        require(balanceOf[msg.sender] >= _value);\r\n        require(_to != address(0));\r\n        balanceOf[msg.sender] -= _value;\r\n        balanceOf[_to] += _value;\r\n        emit Transfer(msg.sender, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    function approve(address _spender, uint256 _value) public returns (bool success) {\r\n        allowance[msg.sender][_spender] = _value;\r\n        emit Approval(msg.sender, _spender, _value);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\r\n        require(balanceOf[_from] >= _value);\r\n        require(allowance[_from][msg.sender] >= _value);\r\n        require(_to != address(0));\r\n        balanceOf[_from] -= _value;\r\n        balanceOf[_to] += _value;\r\n        allowance[_from][msg.sender] -= _value;\r\n        emit Transfer(_from, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    function renounce() public onlyOwner {\r\n        emit OwnershipTransferred(owner, address(0));\r\n        owner = address(0);\r\n    }\r\n\r\n\r\n    modifier onlyOwner() {\r\n        require(msg.sender == owner, \"Only the owner can call this function.\");\r\n        _;\r\n    }\r\n}"
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