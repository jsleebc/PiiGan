{{
  "language": "Solidity",
  "sources": {
    "Shitcoin.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.13;\n\n// $FUCK COIN\n\n\ninterface IERC20 {\n\n    function totalSupply() external view returns (uint);\n\n    function balanceOf(address) external view returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n\n    function transfer(address, uint) external returns (bool);\n\n    function transferFrom(address, address, uint) external returns (bool);\n\n}\n\n\ncontract HABIBI is IERC20 {\n\n\n    string public constant name = \"HABIBI\";\n    string public constant symbol = \"HABIBI\";\n    uint8 public constant decimals = 18;\n    uint256 public totalSupply = 0;\n\n    mapping(address => uint256) public balanceOf;\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    bool public initialMinted;\n    address public owner;\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n\n    modifier onlyOwner(){\n        require(msg.sender == owner);\n        _;\n    }\n\n    constructor() {\n        owner = msg.sender;\n        _mint(msg.sender, 420_000_000_000 * 1e18);\n    }\n\n    function renounceOwnership() external onlyOwner{\n        owner = address(0x0);\n    }\n\n    function approve(address _spender, uint256 _value) external returns (bool) {\n        allowance[msg.sender][_spender] = _value;\n        emit Approval(msg.sender, _spender, _value);\n        return true;\n    }\n\n    function _mint(address _to, uint256 _amount) internal returns (bool) {\n        totalSupply += _amount;\n        unchecked {\n            balanceOf[_to] += _amount;\n        }\n        emit Transfer(address(0x0), _to, _amount);\n        return true;\n    }\n\n    function _transfer(\n        address _from,\n        address _to,\n        uint256 _value\n    ) internal returns (bool) {\n        balanceOf[_from] -= _value;\n        unchecked {\n            balanceOf[_to] += _value;\n        }\n        emit Transfer(_from, _to, _value);\n        return true;\n    }\n\n    function transfer(address _to, uint256 _value) external returns (bool) {\n        return _transfer(msg.sender, _to, _value);\n    }\n\n    function transferFrom(\n        address _from,\n        address _to,\n        uint256 _value\n    ) external returns (bool) {\n        uint256 allowed_from = allowance[_from][msg.sender];\n        if (allowed_from != type(uint256).max) {\n            allowance[_from][msg.sender] -= _value;\n        }\n        return _transfer(_from, _to, _value);\n    }\n\n    \n}"
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