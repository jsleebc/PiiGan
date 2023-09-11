{{
  "language": "Solidity",
  "sources": {
    "1.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n// \r\n/**\r\n\r\nPlease Send Noods - The Best Currency\r\n\r\nTG: https://t.me/+Yy9c9jI4wyJkMDlh\r\nEnglish: Please send noods.\r\nSpanish: Por favor, envía fideos.\r\nFrench: S'il vous plaît, envoyez des nouilles.\r\nGerman: Bitte schicke Nudeln.\r\nItalian: Per favore, invia noodles.\r\nPortuguese: Por favor, envie macarrão.\r\nRussian: Пожалуйста, отправьте лапшу. (Pozhaluysta, otprav'te lapshu.)\r\nChinese (Simplified): 请发送面条。 (Qǐng fāsòng miàntiáo.)\r\nJapanese: ヌードルを送ってください。 (Nūdoru o okutte kudasai.)\r\nKorean: 면을 보내주세요. (Myeon-eul bonaeyo juseyo.)\r\n\r\n*/\r\npragma solidity ^0.8.0;\r\n\r\n\r\ncontract NOODS {\r\n    string public name = \"Please Send NOODS\";\r\n    string public symbol = \"NOODS\";\r\n    uint256 public totalSupply = 10_000_000_000* 10**18; \r\n    uint8 public decimals = 18;\r\n\r\n\r\n    mapping (address => uint256) public balanceOf;\r\n    mapping (address => mapping (address => uint256)) public allowance;\r\n\r\n    address public owner;\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        owner = msg.sender;\r\n        balanceOf[msg.sender] = totalSupply;\r\n    }\r\n\r\n    function transfer(address _to, uint256 _value) public returns (bool success) {\r\n        require(balanceOf[msg.sender] >= _value);\r\n        require(_to != address(0));\r\n        balanceOf[msg.sender] -= _value;\r\n        balanceOf[_to] += _value;\r\n        emit Transfer(msg.sender, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    function approve(address _spender, uint256 _value) public returns (bool success) {\r\n        allowance[msg.sender][_spender] = _value;\r\n        emit Approval(msg.sender, _spender, _value);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\r\n        require(balanceOf[_from] >= _value);\r\n        require(allowance[_from][msg.sender] >= _value);\r\n        require(_to != address(0));\r\n        balanceOf[_from] -= _value;\r\n        balanceOf[_to] += _value;\r\n        allowance[_from][msg.sender] -= _value;\r\n        emit Transfer(_from, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    function renounceOwnership() public onlyOwner {\r\n        emit OwnershipTransferred(owner, address(0));\r\n        owner = address(0);\r\n    }\r\n\r\n\r\n    modifier onlyOwner() {\r\n        require(msg.sender == owner, \"Only the owner can call this function.\");\r\n        _;\r\n    }\r\n}"
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