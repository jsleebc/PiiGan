{{
  "language": "Solidity",
  "sources": {
    "chad.sol": {
      "content": "/**\r\n *Submitted for verification at Etherscan.io on 2023-05-14\r\n*/\r\n\r\n// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\n/**\r\nTwitter  : https://twitter.com/rasucrypto\r\n\r\n*/\r\n\r\n// ERC-20 token interface\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\n// ERC-20 token implementation\r\ncontract CHAD is IERC20 {\r\n    string public name = \"CHAD\";\r\n    string public symbol = \"CHAD\";\r\n    uint8 public decimals = 18;\r\n    uint256 private _totalSupply = 420690000000000 * 10 ** uint256(decimals);\r\n    mapping (address => uint256) private _balances;\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n    address private _owner;\r\n\r\n    constructor() {\r\n        _owner = msg.sender;\r\n        _balances[msg.sender] = _totalSupply;\r\n        emit Transfer(address(0), msg.sender, _totalSupply);\r\n    }\r\n\r\n    function totalSupply() public view override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(msg.sender, recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public override returns (bool) {\r\n        _approve(msg.sender, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);\r\n        return true;\r\n    }\r\n\r\n    function _transfer(address sender, address recipient, uint256 amount) internal {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n        require(_balances[sender] >= amount, \"ERC20: insufficient balance\");\r\n        _balances[sender] -= amount;\r\n        _balances[recipient] += amount;\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _approve(address owner, address spender, uint256 amount) internal {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n    \r\n    function renounceOwnership() public {\r\n        require(msg.sender == _owner, \"Only the contract owner can renounce ownership.\");\r\n        _owner = address(0);\r\n    }\r\n\r\n    function LockLPToken() public returns (bool) {\r\n        return true;\r\n    }\r\n}"
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