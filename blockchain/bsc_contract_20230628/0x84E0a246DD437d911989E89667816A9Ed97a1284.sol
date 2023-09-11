{{
  "language": "Solidity",
  "sources": {
    "contracts/dao/interfaces/IToken.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.8.13;\n\ninterface IToken {\n    function totalSupply() external view returns (uint);\n    function balanceOf(address) external view returns (uint);\n    function approve(address spender, uint value) external returns (bool);\n    function transfer(address, uint) external returns (bool);\n    function transferFrom(address,address,uint) external returns (bool);\n    function mint(address, uint) external returns (bool);\n    function minter() external returns (address);\n}\n"
    },
    "contracts/dao/Token.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0-or-later\r\npragma solidity 0.8.13;\r\n\r\nimport \"./interfaces/IToken.sol\";\r\n\r\ncontract Token is IToken {\r\n\r\n    string public constant name = \"Magic Fox\";\r\n    string public constant symbol = \"FOX\";\r\n    uint8 public constant decimals = 18;\r\n    uint public totalSupply = 0;\r\n\r\n    mapping(address => uint) public balanceOf;\r\n    mapping(address => mapping(address => uint)) public allowance;\r\n\r\n    bool public initialMinted;\r\n    address public minter;\r\n    address public redemptionReceiver;\r\n    address public merkleClaim;\r\n\r\n    event Transfer(address indexed from, address indexed to, uint value);\r\n    event Approval(address indexed owner, address indexed spender, uint value);\r\n\r\n    constructor() {\r\n        minter = msg.sender;\r\n        _mint(msg.sender, 0);\r\n    }\r\n\r\n    // No checks as its meant to be once off to set minting rights to BaseV1 Minter\r\n    function setMinter(address _minter) external {\r\n        require(msg.sender == minter);\r\n        minter = _minter;\r\n    }\r\n\r\n\r\n    // Initial mint: total 3_239_476    \r\n    function initialMint(address _recipient) external {\r\n        require(msg.sender == minter && !initialMinted);\r\n        initialMinted = true;\r\n        _mint(_recipient, 3_239_476 * 1e18);\r\n    }\r\n\r\n    function approve(address _spender, uint _value) external returns (bool) {\r\n        allowance[msg.sender][_spender] = _value;\r\n        emit Approval(msg.sender, _spender, _value);\r\n        return true;\r\n    }\r\n\r\n    function _mint(address _to, uint _amount) internal returns (bool) {\r\n        totalSupply += _amount;\r\n        unchecked {\r\n            balanceOf[_to] += _amount;\r\n        }\r\n        emit Transfer(address(0x0), _to, _amount);\r\n        return true;\r\n    }\r\n\r\n    function _transfer(address _from, address _to, uint _value) internal returns (bool) {\r\n        balanceOf[_from] -= _value;\r\n        unchecked {\r\n            balanceOf[_to] += _value;\r\n        }\r\n        emit Transfer(_from, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    function transfer(address _to, uint _value) external returns (bool) {\r\n        return _transfer(msg.sender, _to, _value);\r\n    }\r\n\r\n    function transferFrom(address _from, address _to, uint _value) external returns (bool) {\r\n        uint allowed_from = allowance[_from][msg.sender];\r\n        if (allowed_from != type(uint).max) {\r\n            allowance[_from][msg.sender] -= _value;\r\n        }\r\n        return _transfer(_from, _to, _value);\r\n    }\r\n\r\n    function mint(address account, uint amount) external returns (bool) {\r\n        require(msg.sender == minter, 'not allowed');\r\n        _mint(account, amount);\r\n        return true;\r\n    }\r\n\r\n}\r\n"
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
    },
    "libraries": {}
  }
}}