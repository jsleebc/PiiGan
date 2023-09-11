{{
  "language": "Solidity",
  "sources": {
    "contracts/1_Storage.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.4;\n\ncontract KitaKakitaDAO {\n    \n    string public constant name = \"KitaKakitaDAO\";\n    string public constant symbol = \"INU\";\n    uint8 public constant decimals = 18; \n\n    event Transfer(address indexed from, address indexed to, uint tokens);\n    event approval (address indexed tokenOwner, address indexed spender, uint tokens);\n    \n    uint256 totalSupply_;\n\n    mapping(address => uint256) balances;\n    mapping(address => mapping (address => uint256) ) allowed; \n\n\n    constructor(){\n        totalSupply_ = 1000000000000000000000000000000;\n        balances[msg.sender] = totalSupply_;\n    }\n    function totalSupply() public view returns (uint256){\n        return totalSupply_;\n\n    }\n    function balanceOf(address tokenOwner) public view returns(uint){\n        return balances[tokenOwner];\n\n    }\n    function transfer (address receiver, uint numTokens) public returns (bool){\n        require(numTokens <= balances[msg.sender]);\n        balances[msg.sender] = balances[msg.sender] - numTokens;\n        balances[receiver] = balances[receiver] + numTokens;\n        emit Transfer(msg.sender, receiver, numTokens);\n        return true; \n    }\n    function approve(address delegate, uint numTokens) public returns (bool){\n        allowed[msg.sender][delegate] = numTokens;\n        emit approval(msg.sender,delegate, numTokens);\n        return true;\n\n    }    \n    function allowance (address owner, address delegate) public view returns (uint){\n        return allowed[owner][delegate];\n\n    }\n    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool){\n        require (numTokens<= balances[owner]);\n        require(numTokens <= allowed [owner][msg.sender]);\n        balances[owner]= balances [owner]- numTokens;\n        allowed[owner][msg.sender] = allowed [owner][msg.sender] - numTokens;\n        balances[buyer] = balances[buyer] + numTokens;\n        emit Transfer(owner,buyer,numTokens);\n        return true;\n    }\n\n}\n"
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