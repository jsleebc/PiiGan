{{
  "language": "Solidity",
  "sources": {
    "ERC20.sol": {
      "content": "// SPDX-License-Identifier: None\npragma solidity 0.8.20;\n\ncontract ERC20 {\n    // --- ERC20 Data ---\n    string  public constant name     = \"Lost\";\n    string  public constant symbol   = \"LOST\";\n    uint8   public constant decimals = 18;\n    uint256 public totalSupply;\n\n    mapping (address => uint)                      public balanceOf;\n    mapping (address => mapping (address => uint)) public allowance;\n\n    event Approval(address indexed src, address indexed guy, uint wad);\n    event Transfer(address indexed src, address indexed dst, uint wad);\n\n    constructor() {\n        balanceOf[msg.sender]   = 1000000000000000000000000000000;\n        totalSupply             = 1000000000000000000000000000000;\n        emit Transfer(address(0), msg.sender, 1000000000000000000000000000000);\n    }\n\n    function transfer(address dst, uint wad) external returns (bool) {\n        return transferFrom(msg.sender, dst, wad);\n    }\n\n    function transferFrom(address src, address dst, uint wad) public returns (bool) {\n        require(balanceOf[src] >= wad, \"\");\n        if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {\n            require(allowance[src][msg.sender] >= wad, \"\");\n            allowance[src][msg.sender] = allowance[src][msg.sender] - wad;\n        }\n        balanceOf[src] = balanceOf[src] - wad;\n        balanceOf[dst] = balanceOf[dst] + wad;\n        emit Transfer(src, dst, wad);\n        return true;\n    }\n\n    function approve(address usr, uint wad) external returns (bool) {\n        allowance[msg.sender][usr] = wad;\n        emit Approval(msg.sender, usr, wad);\n        return true;\n    }\n}\n"
    }
  },
  "settings": {
    "evmVersion": "istanbul",
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "libraries": {
      "ERC20.sol": {}
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