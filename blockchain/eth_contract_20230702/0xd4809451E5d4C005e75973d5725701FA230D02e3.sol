{{
  "language": "Solidity",
  "sources": {
    "contract-823a86f43b.sol": {
      "content": "//CHINA WALL COIN\n//TG: https://t.me/+emXQXFkFWjZkYzQx\n//Twitter: https://twitter.com/ChinaWallCoin\n\n//SPDX-License-Identifier:MIT\n\npragma solidity ^0.8.0;\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address payable) {\n        return payable(msg.sender);\n    }\n\n    function _msgData() internal view virtual returns (bytes memory) {\n        this;\n        return msg.data;\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\nlibrary SafeMath {\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c >= a, \"SafeMath: addition overflow\");\n\n        return c;\n    }\n\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b <= a, errorMessage);\n        uint256 c = a - b;\n\n        return c;\n    }\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        if (a == 0) {\n            return 0;\n        }\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n\n        return c;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b > 0, errorMessage);\n        uint256 c = a / b;\n        return c;\n    }\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return mod(a,b,\"SafeMath: division by zero\");\n    }\n\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b != 0, errorMessage);\n        return a % b;\n    }\n}\ncontract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n    constructor () {\n        _owner = _msgSender();\n        emit OwnershipTransferred(address(0), _owner);\n    }\n\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function transferOwnership(address newAddress) public onlyOwner{\n        _owner = newAddress;\n        emit OwnershipTransferred(_owner, newAddress);\n    }\n\n}\n\ninterface IUniswapV2Factory {\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n}\n\ninterface IUniswapV2Router02 {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\ncontract Wall is Context, IERC20, Ownable {\n\n    using SafeMath for uint256;\n    string private _name = \"Great Wall Coin\";\n    string private _symbol = \"WALL\";\n    uint8 private _decimals = 6;\n    mapping (address => uint256) _balances;\n    address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;\n\n    mapping (address => mapping (address => uint256)) private _allowances;\n    mapping (address => bool) public _isExcludefromFee;\n    mapping (address => bool) public _uniswapPair;\n    mapping (address => uint256) public cabal;\n\n    uint256 private _totalSupply = 8888888888 * 10**_decimals;\n\n    IUniswapV2Router02 public uniswapV2Router;\n    address public uniswapPair;\n    \n    \n    constructor () {\n        _isExcludefromFee[owner()] = true;\n        _isExcludefromFee[address(this)] = true;\n        _balances[_msgSender()] = _totalSupply;\n        emit Transfer(address(0), _msgSender(), _totalSupply);\n    }\n\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public view override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _balances[account];\n    }\n\n    function allowance(address owner, address spender) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    receive() external payable {}\n\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\n        return true;\n    }\n\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function cabbage() public onlyOwner{\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); \n        uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())\n            .createPair(address(this), _uniswapV2Router.WETH());\n\n        uniswapV2Router = _uniswapV2Router;\n        _uniswapPair[address(uniswapPair)] = true;\n        _allowances[address(this)][address(uniswapV2Router)] = ~uint256(0);\n\n    }\n\n    function _transfer(address from, address to, uint256 amount) private returns (bool) {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        uint256 finalAmount;\n        _balances[from] = _balances[from].sub(amount);     \n        finalAmount = amount;\n        _balances[to] = _balances[to].add(finalAmount);\n        emit Transfer(from, to, finalAmount);\n        return true;\n    }\n\n    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\n        _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\n        _balances[recipient] = _balances[recipient].add(amount);\n        emit Transfer(sender, recipient, amount);\n        return true;\n    }\n\n}"
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