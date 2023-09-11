{{
  "language": "Solidity",
  "sources": {
    "src/Lambo.sol": {
      "content": "// Website: lamboeth.finance\r\n\r\n// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.17;\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c >= a, \"SafeMath: addition overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    function sub(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        require(b <= a, errorMessage);\r\n        uint256 c = a - b;\r\n\r\n        return c;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    function div(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        require(b > 0, errorMessage);\r\n        uint256 c = a / b;\r\n        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\r\n\r\n        return c;\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return mod(a, b, \"SafeMath: modulo by zero\");\r\n    }\r\n\r\n    function mod(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        require(b != 0, errorMessage);\r\n        return a % b;\r\n    }\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    function allowance(\r\n        address owner,\r\n        address spender\r\n    ) external view returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n}\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes memory) {\r\n        this;\r\n        return msg.data;\r\n    }\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(\r\n        address indexed token0,\r\n        address indexed token1,\r\n        address pair,\r\n        uint\r\n    );\r\n\r\n    function createPair(\r\n        address tokenA,\r\n        address tokenB\r\n    ) external returns (address pair);\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    )\r\n        external\r\n        payable\r\n        returns (uint amountToken, uint amountETH, uint liquidity);\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n}\r\n\r\ninterface IUniswapV2Pair {\r\n    function sync() external;\r\n}\r\n\r\ncontract Lambo is Context, IERC20 {\r\n    using SafeMath for uint256;\r\n\r\n    string private constant _name = unicode\"lamboeth.finance\";\r\n    string private constant _symbol = unicode\"LAMBO\";\r\n    uint8 private constant _decimals = 18;\r\n    uint256 private _tTotal = 1000000000 * 10 ** _decimals;\r\n\r\n    IUniswapV2Router02 public uniswapV2Router;\r\n    address public uniswapV2Pair;\r\n\r\n    mapping(address => uint256) private balances;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n    constructor() {\r\n        balances[_msgSender()] = _tTotal;\r\n        emit Transfer(address(0), _msgSender(), _tTotal);\r\n\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(\r\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\r\n        );\r\n        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\r\n            .createPair(address(this), _uniswapV2Router.WETH());\r\n\r\n        uniswapV2Router = _uniswapV2Router;\r\n        uniswapV2Pair = _uniswapV2Pair;\r\n    }\r\n\r\n    function totalSupply() public view override returns (uint256) {\r\n        return _tTotal;\r\n    }\r\n\r\n    function name() public pure returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public pure returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public pure returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function decimalsFnctn() public pure returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return balances[account];\r\n    }\r\n\r\n    function transfer(\r\n        address recipient,\r\n        uint256 amount\r\n    ) public override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(\r\n        address owner,\r\n        address spender\r\n    ) public view override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(\r\n        address spender,\r\n        uint256 amount\r\n    ) public override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(\r\n            sender,\r\n            _msgSender(),\r\n            _allowances[sender][_msgSender()] - amount\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(\r\n        address spender,\r\n        uint256 addedValue\r\n    ) public virtual returns (bool) {\r\n        _approve(\r\n            _msgSender(),\r\n            spender,\r\n            _allowances[_msgSender()][spender] + addedValue\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(\r\n        address spender,\r\n        uint256 subtractedValue\r\n    ) public virtual returns (bool) {\r\n        _approve(\r\n            _msgSender(),\r\n            spender,\r\n            _allowances[_msgSender()][spender] - subtractedValue\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function _approve(address owner, address spender, uint256 amount) private {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _burnTokens(address from, uint256 value) internal {\r\n        require(from != address(0), \"ERC20: burn from the zero address\");\r\n        balances[from] = balances[from].sub(\r\n            value,\r\n            \"ERC20: burn amount exceeds balance\"\r\n        );\r\n        _tTotal = _tTotal.sub(value);\r\n        emit Transfer(from, address(0), value);\r\n    }\r\n\r\n    function burn(uint256 amount) external {\r\n        _burnTokens(_msgSender(), amount);\r\n    }\r\n\r\n    function _transfer(address from, address to, uint256 amount) private {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > 0, \"Transfer amount must be greater than zero\");\r\n\r\n        balances[from] -= amount;\r\n        balances[to] += amount;\r\n        emit Transfer(from, to, amount);\r\n    }\r\n}\r\n"
    }
  },
  "settings": {
    "remappings": [
      "@balancer-labs/=lib/balancer-v2-monorepo/../../node_modules/@balancer-labs/",
      "balancer-v2-monorepo/=lib/balancer-v2-monorepo/",
      "balancer-v2-vault-interfaces/=lib/balancer-v2-monorepo/pkg/interfaces/contracts/vault/",
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/",
      "openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/",
      "solady/=lib/solady/src/",
      "solmate/=lib/solmate/src/",
      "uniswap-v2-interfaces/=lib/v2-periphery/contracts/interfaces/",
      "v2-periphery/=lib/v2-periphery/contracts/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 1000000
    },
    "metadata": {
      "bytecodeHash": "none",
      "appendCBOR": true
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
    "evmVersion": "london",
    "libraries": {}
  }
}}