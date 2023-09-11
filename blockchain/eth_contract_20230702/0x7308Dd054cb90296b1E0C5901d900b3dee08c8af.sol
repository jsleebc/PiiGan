{{
  "language": "Solidity",
  "sources": {
    "contracts/grdn.sol": {
      "content": "\r\n\r\n/*\r\nhttps://www.gardencoin.io/\r\nhttps://twitter.com/gardencoineth\r\nhttps://t.me/gardencoineth\r\n*/\r\n\r\n// SPDX-License-Identifier: Unlicensed\r\n\r\npragma solidity 0.8.11;\r\n \r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n \r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n \r\ninterface IUniswapV2Pair {\r\n    event Approval(address indexed owner, address indexed spender, uint value);\r\n    event Transfer(address indexed from, address indexed to, uint value);\r\n \r\n    function name() external pure returns (string memory);\r\n    function symbol() external pure returns (string memory);\r\n    function decimals() external pure returns (uint8);\r\n    function totalSupply() external view returns (uint);\r\n    function balanceOf(address owner) external view returns (uint);\r\n    function allowance(address owner, address spender) external view returns (uint);\r\n \r\n    function approve(address spender, uint value) external returns (bool);\r\n    function transfer(address to, uint value) external returns (bool);\r\n    function transferFrom(address from, address to, uint value) external returns (bool);\r\n \r\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\r\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\r\n    function nonces(address owner) external view returns (uint);\r\n \r\n    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\r\n \r\n    event Mint(address indexed sender, uint amount0, uint amount1);\r\n    event Swap(\r\n        address indexed sender,\r\n        uint amount0In,\r\n        uint amount1In,\r\n        uint amount0Out,\r\n        uint amount1Out,\r\n        address indexed to\r\n    );\r\n    event Sync(uint112 reserve0, uint112 reserve1);\r\n \r\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\r\n    function factory() external view returns (address);\r\n    function token0() external view returns (address);\r\n    function token1() external view returns (address);\r\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\r\n    function price0CumulativeLast() external view returns (uint);\r\n    function price1CumulativeLast() external view returns (uint);\r\n    function kLast() external view returns (uint);\r\n \r\n    function mint(address to) external returns (uint liquidity);\r\n    function burn(address to) external returns (uint amount0, uint amount1);\r\n    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\r\n    function skim(address to) external;\r\n    function sync() external;\r\n \r\n    function initialize(address, address) external;\r\n}\r\n \r\ninterface IUniswapV2Factory {\r\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\r\n \r\n    function feeTo() external view returns (address);\r\n    function feeToSetter() external view returns (address);\r\n \r\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\r\n    function allPairs(uint) external view returns (address pair);\r\n    function allPairsLength() external view returns (uint);\r\n \r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n \r\n    function setFeeTo(address) external;\r\n    function setFeeToSetter(address) external;\r\n}\r\n \r\ninterface IERC20 {\r\n\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n \r\ninterface IERC20Metadata is IERC20 {\r\n\r\n    function name() external view returns (string memory);\r\n\r\n    function symbol() external view returns (string memory);\r\n\r\n    function decimals() external view returns (uint8);\r\n}\r\n \r\n \r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    using SafeMath for uint256;\r\n \r\n    mapping(address => uint256) private _balances;\r\n \r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n \r\n    uint256 private _totalSupply;\r\n \r\n    string private _name;\r\n    string private _symbol;\r\n\r\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 18;\r\n    }\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, \"ERC20: decreased allowance below zero\"));\r\n        return true;\r\n    }\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n \r\n        _beforeTokenTransfer(sender, recipient, amount);\r\n \r\n        _balances[sender] = _balances[sender].sub(amount, \"ERC20: transfer amount exceeds balance\");\r\n        _balances[recipient] = _balances[recipient].add(amount);\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n \r\n        _beforeTokenTransfer(address(0), account, amount);\r\n \r\n        _totalSupply = _totalSupply.add(amount);\r\n        _balances[account] = _balances[account].add(amount);\r\n        emit Transfer(address(0), account, amount);\r\n    }\r\n\r\n    function _burn(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: burn from the zero address\");\r\n \r\n        _beforeTokenTransfer(account, address(0), amount);\r\n \r\n        _balances[account] = _balances[account].sub(amount, \"ERC20: burn amount exceeds balance\");\r\n        _totalSupply = _totalSupply.sub(amount);\r\n        emit Transfer(account, address(0), amount);\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n \r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _beforeTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n}\r\n \r\nlibrary SafeMath {\r\n\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c >= a, \"SafeMath: addition overflow\");\r\n \r\n        return c;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b <= a, errorMessage);\r\n        uint256 c = a - b;\r\n \r\n        return c;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n \r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n \r\n        return c;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b > 0, errorMessage);\r\n        uint256 c = a / b;\r\n        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\r\n \r\n        return c;\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return mod(a, b, \"SafeMath: modulo by zero\");\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b != 0, errorMessage);\r\n        return a % b;\r\n    }\r\n}\r\n \r\ncontract Ownable is Context {\r\n    address private _owner;\r\n \r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n \r\n \r\n \r\nlibrary SafeMathInt {\r\n    int256 private constant MIN_INT256 = int256(1) << 255;\r\n    int256 private constant MAX_INT256 = ~(int256(1) << 255);\r\n\r\n    function mul(int256 a, int256 b) internal pure returns (int256) {\r\n        int256 c = a * b;\r\n \r\n        // Detect overflow when multiplying MIN_INT256 with -1\r\n        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));\r\n        require((b == 0) || (c / b == a));\r\n        return c;\r\n    }\r\n\r\n    function div(int256 a, int256 b) internal pure returns (int256) {\r\n        // Prevent overflow when dividing MIN_INT256 by -1\r\n        require(b != -1 || a != MIN_INT256);\r\n \r\n        // Solidity already throws when dividing by 0.\r\n        return a / b;\r\n    }\r\n\r\n    function sub(int256 a, int256 b) internal pure returns (int256) {\r\n        int256 c = a - b;\r\n        require((b >= 0 && c <= a) || (b < 0 && c > a));\r\n        return c;\r\n    }\r\n\r\n    function add(int256 a, int256 b) internal pure returns (int256) {\r\n        int256 c = a + b;\r\n        require((b >= 0 && c >= a) || (b < 0 && c < a));\r\n        return c;\r\n    }\r\n\r\n    function abs(int256 a) internal pure returns (int256) {\r\n        require(a != MIN_INT256);\r\n        return a < 0 ? -a : a;\r\n    }\r\n \r\n \r\n    function toUint256Safe(int256 a) internal pure returns (uint256) {\r\n        require(a >= 0);\r\n        return uint256(a);\r\n    }\r\n}\r\n \r\nlibrary SafeMathUint {\r\n  function toInt256Safe(uint256 a) internal pure returns (int256) {\r\n    int256 b = int256(a);\r\n    require(b >= 0);\r\n    return b;\r\n  }\r\n}\r\n \r\n \r\ninterface IUniswapV2Router01 {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n \r\n    function addLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint amountADesired,\r\n        uint amountBDesired,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB, uint liquidity);\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n    function removeLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB);\r\n    function removeLiquidityETH(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountToken, uint amountETH);\r\n    function removeLiquidityWithPermit(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountA, uint amountB);\r\n    function removeLiquidityETHWithPermit(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountToken, uint amountETH);\r\n    function swapExactTokensForTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n    function swapTokensForExactTokens(\r\n        uint amountOut,\r\n        uint amountInMax,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\r\n        external\r\n        payable\r\n        returns (uint[] memory amounts);\r\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\r\n        external\r\n        returns (uint[] memory amounts);\r\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\r\n        external\r\n        returns (uint[] memory amounts);\r\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\r\n        external\r\n        payable\r\n        returns (uint[] memory amounts);\r\n \r\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\r\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\r\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\r\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\r\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\r\n}\r\n \r\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\r\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountETH);\r\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountETH);\r\n \r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n \r\n    contract grdn is ERC20, Ownable {\r\n    using SafeMath for uint256;\r\n \r\n    IUniswapV2Router02 public immutable uniswapV2Router;\r\n    address public immutable uniswapV2Pair;\r\n \r\n    bool private swapping;\r\n \r\n    address private marketingWallet;\r\n    address private devWallet;\r\n \r\n    uint256 public maxTransactionAmount;\r\n    uint256 public swapTokensAtAmount;\r\n    uint256 public maxWallet;\r\n \r\n    bool public limitsInEffect = true;\r\n    bool public tradingActive = false;\r\n    bool public swapEnabled = false;\r\n \r\n     // Anti-bot and anti-whale mappings and variables\r\n    mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch\r\n \r\n    // Seller Map\r\n    mapping (address => uint256) private _holderFirstBuyTimestamp;\r\n \r\n    // Blacklist Map\r\n    mapping (address => bool) private _blacklist;\r\n    bool public transferDelayEnabled = true;\r\n \r\n    uint256 public buyTotalFees;\r\n    uint256 public buyMarketingFee;\r\n    uint256 public buyLiquidityFee;\r\n    uint256 public buyDevFee;\r\n \r\n    uint256 public sellTotalFees;\r\n    uint256 public sellMarketingFee;\r\n    uint256 public sellLiquidityFee;\r\n    uint256 public sellDevFee;\r\n \r\n    uint256 public tokensForMarketing;\r\n    uint256 public tokensForLiquidity;\r\n    uint256 public tokensForDev;\r\n \r\n    // block number of opened trading\r\n    uint256 launchedAt;\r\n \r\n    /******************/\r\n \r\n    // exclude from fees and max transaction amount\r\n    mapping (address => bool) private _isExcludedFromFees;\r\n    mapping (address => bool) public _isExcludedMaxTransactionAmount;\r\n \r\n    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses\r\n    // could be subject to a maximum transfer amount\r\n    mapping (address => bool) public automatedMarketMakerPairs;\r\n \r\n    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);\r\n \r\n    event ExcludeFromFees(address indexed account, bool isExcluded);\r\n \r\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\r\n \r\n    event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);\r\n \r\n    event devWalletUpdated(address indexed newWallet, address indexed oldWallet);\r\n \r\n    event SwapAndLiquify(\r\n        uint256 tokensSwapped,\r\n        uint256 ethReceived,\r\n        uint256 tokensIntoLiquidity\r\n    );\r\n \r\n    event AutoNukeLP();\r\n \r\n    event ManualNukeLP();\r\n \r\n    constructor() ERC20(\"GARDEN\", \"GRDN\") {\r\n \r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n \r\n        excludeFromMaxTransaction(address(_uniswapV2Router), true);\r\n        uniswapV2Router = _uniswapV2Router;\r\n \r\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\r\n        excludeFromMaxTransaction(address(uniswapV2Pair), true);\r\n        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);\r\n \r\n        uint256 _buyMarketingFee = 25;\r\n        uint256 _buyLiquidityFee = 0;\r\n        uint256 _buyDevFee = 0;\r\n \r\n        uint256 _sellMarketingFee = 25;\r\n        uint256 _sellLiquidityFee = 0;\r\n        uint256 _sellDevFee = 0;\r\n \r\n        uint256 totalSupply = 888888888 * 1e18;\r\n \r\n        maxTransactionAmount = totalSupply * 8 / 1000; \r\n        maxWallet = totalSupply * 8 / 1000; \r\n        swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%\r\n \r\n        buyMarketingFee = _buyMarketingFee;\r\n        buyLiquidityFee = _buyLiquidityFee;\r\n        buyDevFee = _buyDevFee;\r\n        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;\r\n \r\n        sellMarketingFee = _sellMarketingFee;\r\n        sellLiquidityFee = _sellLiquidityFee;\r\n        sellDevFee = _sellDevFee;\r\n        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;\r\n \r\n        marketingWallet = address(0x4e4EA78F26710c29cA227E2b761c583D8e79c201);\r\n        devWallet = address(0x4e4EA78F26710c29cA227E2b761c583D8e79c201);\r\n \r\n        // exclude from paying fees or having max transaction amount\r\n        excludeFromFees(owner(), true);\r\n        excludeFromFees(address(this), true);\r\n        excludeFromFees(address(0xdead), true);\r\n \r\n        excludeFromMaxTransaction(owner(), true);\r\n        excludeFromMaxTransaction(address(this), true);\r\n        excludeFromMaxTransaction(address(0xdead), true);\r\n \r\n        /*\r\n            _mint is an internal function in ERC20.sol that is only called here,\r\n            and CANNOT be called ever again\r\n        */\r\n        _mint(msg.sender, totalSupply);\r\n    }\r\n \r\n    receive() external payable {\r\n \r\n    }\r\n \r\n    // once enabled, can never be turned off\r\n    function enableTrading() external onlyOwner {\r\n        tradingActive = true;\r\n        swapEnabled = true;\r\n        launchedAt = block.number;\r\n    }\r\n \r\n    // remove limits after token is stable\r\n    function removeLimits() external onlyOwner returns (bool){\r\n        limitsInEffect = false;\r\n        return true;\r\n    }\r\n \r\n    // disable Transfer delay - cannot be reenabled\r\n    function disableTransferDelay() external onlyOwner returns (bool){\r\n        transferDelayEnabled = false;\r\n        return true;\r\n    }\r\n \r\n     // change the minimum amount of tokens to sell from fees\r\n    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){\r\n        require(newAmount >= totalSupply() * 1 / 100000, \"Swap amount cannot be lower than 0.001% total supply.\");\r\n        require(newAmount <= totalSupply() * 5 / 1000, \"Swap amount cannot be higher than 0.5% total supply.\");\r\n        swapTokensAtAmount = newAmount;\r\n        return true;\r\n    }\r\n \r\n    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {\r\n        require(newNum >= (totalSupply() * 1 / 1000)/1e18, \"Cannot set maxTransactionAmount lower than 0.1%\");\r\n        maxTransactionAmount = newNum * (10**18);\r\n    }\r\n \r\n    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {\r\n        require(newNum >= (totalSupply() * 5 / 1000)/1e18, \"Cannot set maxWallet lower than 0.5%\");\r\n        maxWallet = newNum * (10**18);\r\n    }\r\n \r\n    function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {\r\n        _isExcludedMaxTransactionAmount[updAds] = isEx;\r\n    }\r\n\r\n          function updateBuyFees(\r\n        uint256 _devFee,\r\n        uint256 _liquidityFee,\r\n        uint256 _marketingFee\r\n    ) external onlyOwner {\r\n        buyDevFee = _devFee;\r\n        buyLiquidityFee = _liquidityFee;\r\n        buyMarketingFee = _marketingFee;\r\n        buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;\r\n    }\r\n\r\n    function updateSellFees(\r\n        uint256 _devFee,\r\n        uint256 _liquidityFee,\r\n        uint256 _marketingFee\r\n    ) external onlyOwner {\r\n        sellDevFee = _devFee;\r\n        sellLiquidityFee = _liquidityFee;\r\n        sellMarketingFee = _marketingFee;\r\n        sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;\r\n    }\r\n \r\n    // only use to disable contract sales if absolutely necessary (emergency use only)\r\n    function updateSwapEnabled(bool enabled) external onlyOwner(){\r\n        swapEnabled = enabled;\r\n    }\r\n \r\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\r\n        _isExcludedFromFees[account] = excluded;\r\n        emit ExcludeFromFees(account, excluded);\r\n    }\r\n \r\n    function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {\r\n        _blacklist[account] = isBlacklisted;\r\n    }\r\n \r\n    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {\r\n        require(pair != uniswapV2Pair, \"The pair cannot be removed from automatedMarketMakerPairs\");\r\n \r\n        _setAutomatedMarketMakerPair(pair, value);\r\n    }\r\n \r\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\r\n        automatedMarketMakerPairs[pair] = value;\r\n \r\n        emit SetAutomatedMarketMakerPair(pair, value);\r\n    }\r\n \r\n    function updateMarketingWallet(address newMarketingWallet) external onlyOwner {\r\n        emit marketingWalletUpdated(newMarketingWallet, marketingWallet);\r\n        marketingWallet = newMarketingWallet;\r\n    }\r\n \r\n    function updateDevWallet(address newWallet) external onlyOwner {\r\n        emit devWalletUpdated(newWallet, devWallet);\r\n        devWallet = newWallet;\r\n    }\r\n \r\n \r\n    function isExcludedFromFees(address account) public view returns(bool) {\r\n        return _isExcludedFromFees[account];\r\n    }\r\n \r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal override {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(!_blacklist[to] && !_blacklist[from], \"You have been blacklisted from transfering tokens\");\r\n         if(amount == 0) {\r\n            super._transfer(from, to, 0);\r\n            return;\r\n        }\r\n \r\n        if(limitsInEffect){\r\n            if (\r\n                from != owner() &&\r\n                to != owner() &&\r\n                to != address(0) &&\r\n                to != address(0xdead) &&\r\n                !swapping\r\n            ){\r\n                if(!tradingActive){\r\n                    require(_isExcludedFromFees[from] || _isExcludedFromFees[to], \"Trading is not active.\");\r\n                }\r\n \r\n                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  \r\n                if (transferDelayEnabled){\r\n                    if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){\r\n                        require(_holderLastTransferTimestamp[tx.origin] < block.number, \"_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.\");\r\n                        _holderLastTransferTimestamp[tx.origin] = block.number;\r\n                    }\r\n                }\r\n \r\n                //when buy\r\n                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {\r\n                        require(amount <= maxTransactionAmount, \"Buy transfer amount exceeds the maxTransactionAmount.\");\r\n                        require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded\");\r\n                }\r\n \r\n                //when sell\r\n                else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {\r\n                        require(amount <= maxTransactionAmount, \"Sell transfer amount exceeds the maxTransactionAmount.\");\r\n                }\r\n                else if(!_isExcludedMaxTransactionAmount[to]){\r\n                    require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded\");\r\n                }\r\n            }\r\n        }\r\n \r\n        uint256 contractTokenBalance = balanceOf(address(this));\r\n \r\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\r\n \r\n        if( \r\n            canSwap &&\r\n            swapEnabled &&\r\n            !swapping &&\r\n            !automatedMarketMakerPairs[from] &&\r\n            !_isExcludedFromFees[from] &&\r\n            !_isExcludedFromFees[to]\r\n        ) {\r\n            swapping = true;\r\n \r\n            swapBack();\r\n \r\n            swapping = false;\r\n        }\r\n \r\n        bool takeFee = !swapping;\r\n \r\n        // if any account belongs to _isExcludedFromFee account then remove the fee\r\n        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\r\n            takeFee = false;\r\n        }\r\n \r\n        uint256 fees = 0;\r\n        // only take fees on buys/sells, do not take on wallet transfers\r\n        if(takeFee){\r\n            // on sell\r\n            if (automatedMarketMakerPairs[to] && sellTotalFees > 0){\r\n                fees = amount.mul(sellTotalFees).div(100);\r\n                tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;\r\n                tokensForDev += fees * sellDevFee / sellTotalFees;\r\n                tokensForMarketing += fees * sellMarketingFee / sellTotalFees;\r\n            }\r\n            // on buy\r\n            else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {\r\n                fees = amount.mul(buyTotalFees).div(100);\r\n                tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;\r\n                tokensForDev += fees * buyDevFee / buyTotalFees;\r\n                tokensForMarketing += fees * buyMarketingFee / buyTotalFees;\r\n            }\r\n \r\n            if(fees > 0){    \r\n                super._transfer(from, address(this), fees);\r\n            }\r\n \r\n            amount -= fees;\r\n        }\r\n \r\n        super._transfer(from, to, amount);\r\n    }\r\n \r\n    function swapTokensForEth(uint256 tokenAmount) private {\r\n \r\n        // generate the uniswap pair path of token -> weth\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n \r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n \r\n        // make the swap\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0, // accept any amount of ETH\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n \r\n    }\r\n \r\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\r\n        // approve token transfer to cover all possible scenarios\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n \r\n        // add the liquidity\r\n        uniswapV2Router.addLiquidityETH{value: ethAmount}(\r\n            address(this),\r\n            tokenAmount,\r\n            0, // slippage is unavoidable\r\n            0, // slippage is unavoidable\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n \r\n    function swapBack() private {\r\n        uint256 contractBalance = balanceOf(address(this));\r\n        uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;\r\n        bool success;\r\n \r\n        if(contractBalance == 0 || totalTokensToSwap == 0) {return;}\r\n \r\n        if(contractBalance > swapTokensAtAmount * 20){\r\n          contractBalance = swapTokensAtAmount * 20;\r\n        }\r\n \r\n        // Halve the amount of liquidity tokens\r\n        uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;\r\n        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);\r\n \r\n        uint256 initialETHBalance = address(this).balance;\r\n \r\n        swapTokensForEth(amountToSwapForETH); \r\n \r\n        uint256 ethBalance = address(this).balance.sub(initialETHBalance);\r\n \r\n        uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);\r\n        uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);\r\n        uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;\r\n \r\n \r\n        tokensForLiquidity = 0;\r\n        tokensForMarketing = 0;\r\n        tokensForDev = 0;\r\n \r\n        (success,) = address(devWallet).call{value: ethForDev}(\"\");\r\n \r\n        if(liquidityTokens > 0 && ethForLiquidity > 0){\r\n            addLiquidity(liquidityTokens, ethForLiquidity);\r\n            emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);\r\n        }\r\n \r\n        (success,) = address(marketingWallet).call{value: address(this).balance}(\"\");\r\n    }\r\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
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