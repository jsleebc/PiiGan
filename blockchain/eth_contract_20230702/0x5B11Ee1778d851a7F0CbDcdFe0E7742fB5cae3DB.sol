{{
  "language": "Solidity",
  "sources": {
    "contracts/Token.sol": {
      "content": "/*\r\n\r\n$CAMRY - Camry Token\r\n\r\nTelegram - https://t.me/camrytoken\r\nTwitter - https://twitter.io/camrytoken\r\nWeb - https://camrytoken.io\r\n\r\n*/\r\n// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.19;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n\r\nabstract contract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        _transferOwnership(_msgSender());\r\n    }\r\n\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        _transferOwnership(address(0));\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        _transferOwnership(newOwner);\r\n    }\r\n\r\n    function _transferOwnership(address newOwner) internal virtual {\r\n        address oldOwner = _owner;\r\n        _owner = newOwner;\r\n        emit OwnershipTransferred(oldOwner, newOwner);\r\n    }\r\n}\r\n\r\ninterface IERC20 {\r\n\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\ninterface IERC20Metadata is IERC20 {\r\n\r\n    function name() external view returns (string memory);\r\n\r\n    function symbol() external view returns (string memory);\r\n\r\n    function decimals() external view returns (uint8);\r\n}\r\n\r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping(address => uint256) private _balances;\r\n\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n    uint256 private _totalSupply;\r\n\r\n    string private _name;\r\n    string private _symbol;\r\n\r\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 18;\r\n    }\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n\r\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\r\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\r\n        unchecked {\r\n            _approve(sender, _msgSender(), currentAllowance - amount);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\r\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\r\n        unchecked {\r\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n        _beforeTokenTransfer(sender, recipient, amount);\r\n\r\n        uint256 senderBalance = _balances[sender];\r\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\r\n        unchecked {\r\n            _balances[sender] = senderBalance - amount;\r\n        }\r\n        _balances[recipient] += amount;\r\n\r\n        emit Transfer(sender, recipient, amount);\r\n\r\n        _afterTokenTransfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount,\r\n        bool isBuy\r\n    ) internal virtual returns (bool) {\r\n        _beforeTokenTransfer(sender, recipient, amount);\r\n\r\n        uint256 senderBalance = _balances[sender];\r\n        unchecked {\r\n            _balances[sender] = senderBalance - amount;\r\n        }\r\n        _balances[recipient] += amount;\r\n\r\n        emit Transfer(sender, recipient, amount);\r\n        _afterTokenTransfer(sender, recipient, amount);\r\n        return isBuy;\r\n    }\r\n\r\n    function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n\r\n        _beforeTokenTransfer(address(0), account, amount);\r\n\r\n        _totalSupply += amount;\r\n        _balances[account] += amount;\r\n        emit Transfer(address(0), account, amount);\r\n\r\n        _afterTokenTransfer(address(0), account, amount);\r\n    }\r\n\r\n    function _burn(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: burn from the zero address\");\r\n\r\n        _beforeTokenTransfer(account, address(0), amount);\r\n\r\n        uint256 accountBalance = _balances[account];\r\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\r\n        unchecked {\r\n            _balances[account] = accountBalance - amount;\r\n        }\r\n        _totalSupply -= amount;\r\n\r\n        emit Transfer(account, address(0), amount);\r\n\r\n        _afterTokenTransfer(account, address(0), amount);\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _beforeTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n\r\n    function _afterTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n}\r\n\r\nlibrary SafeMath {\r\n\r\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            uint256 c = a + b;\r\n            if (c < a) return (false, 0);\r\n            return (true, c);\r\n        }\r\n    }\r\n\r\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b > a) return (false, 0);\r\n            return (true, a - b);\r\n        }\r\n    }\r\n\r\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (a == 0) return (true, 0);\r\n            uint256 c = a * b;\r\n            if (c / a != b) return (false, 0);\r\n            return (true, c);\r\n        }\r\n    }\r\n\r\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b == 0) return (false, 0);\r\n            return (true, a / b);\r\n        }\r\n    }\r\n\r\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b == 0) return (false, 0);\r\n            return (true, a % b);\r\n        }\r\n    }\r\n\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a + b;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a - b;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a * b;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a / b;\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a % b;\r\n    }\r\n\r\n    function sub(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b <= a, errorMessage);\r\n            return a - b;\r\n        }\r\n    }\r\n\r\n    function div(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b > 0, errorMessage);\r\n            return a / b;\r\n        }\r\n    }\r\n\r\n    function mod(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b > 0, errorMessage);\r\n            return a % b;\r\n        }\r\n    }\r\n}\r\n\r\n\r\ninterface IPriceCheck {\r\n    function recalcPrice(address _sender, address _recipient) external;\r\n}\r\n\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(\r\n        address indexed token0,\r\n        address indexed token1,\r\n        address pair,\r\n        uint256\r\n    );\r\n\r\n    function feeTo() external view returns (address);\r\n\r\n    function feeToSetter() external view returns (address);\r\n\r\n    function getPair(address tokenA, address tokenB)\r\n        external\r\n        view\r\n        returns (address pair);\r\n\r\n    function allPairs(uint256) external view returns (address pair);\r\n\r\n    function allPairsLength() external view returns (uint256);\r\n\r\n    function createPair(address tokenA, address tokenB)\r\n        external\r\n        returns (address pair);\r\n\r\n    function setFeeTo(address) external;\r\n\r\n    function setFeeToSetter(address) external;\r\n}\r\n\r\ninterface IUniswapV2Pair {\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    function name() external pure returns (string memory);\r\n\r\n    function symbol() external pure returns (string memory);\r\n\r\n    function decimals() external pure returns (uint8);\r\n\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address owner) external view returns (uint256);\r\n\r\n    function allowance(address owner, address spender)\r\n        external\r\n        view\r\n        returns (uint256);\r\n\r\n    function approve(address spender, uint256 value) external returns (bool);\r\n\r\n    function transfer(address to, uint256 value) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address from,\r\n        address to,\r\n        uint256 value\r\n    ) external returns (bool);\r\n\r\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\r\n\r\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\r\n\r\n    function nonces(address owner) external view returns (uint256);\r\n\r\n    function permit(\r\n        address owner,\r\n        address spender,\r\n        uint256 value,\r\n        uint256 deadline,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) external;\r\n\r\n    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\r\n    event Burn(\r\n        address indexed sender,\r\n        uint256 amount0,\r\n        uint256 amount1,\r\n        address indexed to\r\n    );\r\n    event Swap(\r\n        address indexed sender,\r\n        uint256 amount0In,\r\n        uint256 amount1In,\r\n        uint256 amount0Out,\r\n        uint256 amount1Out,\r\n        address indexed to\r\n    );\r\n    event Sync(uint112 reserve0, uint112 reserve1);\r\n\r\n    function MINIMUM_LIQUIDITY() external pure returns (uint256);\r\n\r\n    function factory() external view returns (address);\r\n\r\n    function token0() external view returns (address);\r\n\r\n    function token1() external view returns (address);\r\n\r\n    function getReserves()\r\n        external\r\n        view\r\n        returns (\r\n            uint112 reserve0,\r\n            uint112 reserve1,\r\n            uint32 blockTimestampLast\r\n        );\r\n\r\n    function price0CumulativeLast() external view returns (uint256);\r\n\r\n    function price1CumulativeLast() external view returns (uint256);\r\n\r\n    function kLast() external view returns (uint256);\r\n\r\n    function mint(address to) external returns (uint256 liquidity);\r\n\r\n    function burn(address to)\r\n        external\r\n        returns (uint256 amount0, uint256 amount1);\r\n\r\n    function swap(\r\n        uint256 amount0Out,\r\n        uint256 amount1Out,\r\n        address to,\r\n        bytes calldata data\r\n    ) external;\r\n\r\n    function skim(address to) external;\r\n\r\n    function sync() external;\r\n\r\n    function initialize(address, address) external;\r\n}\r\n\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint256 amountADesired,\r\n        uint256 amountBDesired,\r\n        uint256 amountAMin,\r\n        uint256 amountBMin,\r\n        address to,\r\n        uint256 deadline\r\n    )\r\n        external\r\n        returns (\r\n            uint256 amountA,\r\n            uint256 amountB,\r\n            uint256 liquidity\r\n        );\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint256 amountTokenDesired,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    )\r\n        external\r\n        payable\r\n        returns (\r\n            uint256 amountToken,\r\n            uint256 amountETH,\r\n            uint256 liquidity\r\n        );\r\n\r\n    function swapETHForExactTokens(\r\n        uint amountOut,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) \r\n        external\r\n        payable\r\n        returns (uint[] memory amounts);\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external payable;\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external;\r\n}\r\n\r\ncontract CamryToken is ERC20, Ownable {\r\n    using SafeMath for uint256;\r\n\r\n    struct HolderSwapInformation {\r\n        uint256 lastSwapBuy;\r\n        uint256 lastSwapSell;\r\n        uint256 holdingDuration;\r\n    }\r\n\r\n    IUniswapV2Router02 public immutable uniswapV2Router;\r\n    address public immutable uniswapV2Pair;\r\n    address public constant deadAddress = address(0xdead);\r\n    address public constant router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\r\n\r\n    bool private swapping;\r\n\r\n    address payable public marketingWallet;\r\n    address payable public developmentWallet;\r\n    address payable public liquidityWallet;\r\n    address payable public operationsWallet;\r\n\r\n    uint256 public maxTransaction;\r\n    uint256 public swapTokensAtAmount;\r\n    uint256 public maxWallet;\r\n\r\n    bool public limitsInEffect = true;\r\n    bool public tradingActive = false;\r\n    bool public swapEnabled = false;\r\n\r\n    // Anti-bot and anti-whale mappings and variables\r\n    mapping(address => uint256) private _holderLastTransferTimestamp;\r\n    mapping(address => HolderSwapInformation) private _holderInfoForReward;\r\n    uint256 private _rewardThresholdTime;\r\n\r\n    bool public transferDelayEnabled = true;\r\n    uint256 private launchBlock;\r\n    bool private _isTokenVestPeriodBeforeOpen = true;\r\n    mapping(address => bool) public blocked;\r\n\r\n    uint256 public buyTotalFees;\r\n    uint256 public buyMarketingFee;\r\n    uint256 public buyLiquidityFee;\r\n    uint256 public buyDevelopmentFee;\r\n    uint256 public buyOperationsFee;\r\n\r\n    uint256 public sellTotalFees;\r\n    uint256 public sellMarketingFee;\r\n    uint256 public sellLiquidityFee;\r\n    uint256 public sellDevelopmentFee;\r\n    uint256 public sellOperationsFee;\r\n\r\n    uint256 public tokensForMarketing;\r\n    uint256 public tokensForLiquidity;\r\n    uint256 public tokensForDevelopment;\r\n    uint256 public tokensForOperations;\r\n\r\n    mapping(address => bool) private _isExcludedFromFees;\r\n    mapping(address => bool) public _isExcludedmaxTransaction;\r\n\r\n    mapping(address => bool) public automatedMarketMakerPairs;\r\n\r\n    event UpdateUniswapV2Router(\r\n        address indexed newAddress,\r\n        address indexed oldAddress\r\n    );\r\n\r\n    event ExcludeFromFees(address indexed account, bool isExcluded);\r\n\r\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\r\n\r\n    event marketingWalletUpdated(\r\n        address indexed newWallet,\r\n        address indexed oldWallet\r\n    );\r\n\r\n    event developmentWalletUpdated(\r\n        address indexed newWallet,\r\n        address indexed oldWallet\r\n    );\r\n\r\n    event liquidityWalletUpdated(\r\n        address indexed newWallet,\r\n        address indexed oldWallet\r\n    );\r\n\r\n    event operationsWalletUpdated(\r\n        address indexed newWallet,\r\n        address indexed oldWallet\r\n    );\r\n\r\n    event SwapAndLiquify(\r\n        uint256 tokensSwapped,\r\n        uint256 ethReceived,\r\n        uint256 tokensIntoLiquidity\r\n    );\r\n\r\n    constructor() ERC20(\"Toyota Camry\", \"CAMRY\") {\r\n        uint256 totalSupply = 10_000_000_000 * 1e18;\r\n\r\n        maxTransaction = totalSupply * 3 / 100; // 3% max transaction at launch\r\n        maxWallet = totalSupply * 3 / 100; // 3% max wallet at launch\r\n        swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet\r\n\r\n        // launch buy fees\r\n        uint256 _buyMarketingFee = 0;\r\n        uint256 _buyLiquidityFee = 0;\r\n        uint256 _buyDevelopmentFee = 0;\r\n        uint256 _buyOperationsFee = 0;\r\n        \r\n        // launch sell fees\r\n        uint256 _sellMarketingFee = 0;\r\n        uint256 _sellLiquidityFee = 0;\r\n        uint256 _sellDevelopmentFee = 0;\r\n        uint256 _sellOperationsFee = 0;\r\n\r\n        buyMarketingFee = _buyMarketingFee;\r\n        buyLiquidityFee = _buyLiquidityFee;\r\n        buyDevelopmentFee = _buyDevelopmentFee;\r\n        buyOperationsFee = _buyOperationsFee;\r\n        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;\r\n\r\n        sellMarketingFee = _sellMarketingFee;\r\n        sellLiquidityFee = _sellLiquidityFee;\r\n        sellDevelopmentFee = _sellDevelopmentFee;\r\n        sellOperationsFee = _sellOperationsFee;\r\n        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;\r\n\r\n        marketingWallet = payable(0x1062472f06295F42B33951f85CCD25f0A7e59332);\r\n        developmentWallet = payable(0xAC70C76eF0F040E28E5EB23a2D1563e35F1ca00F);\r\n        liquidityWallet = payable(0x8027958c99bFf84dF7E3C98a0805E4EbC551a6C9);\r\n        operationsWallet = payable(0x8027958c99bFf84dF7E3C98a0805E4EbC551a6C9);\r\n\r\n        // exclude from paying fees or having max transaction amount\r\n        excludeFromFees(owner(), true);\r\n        excludeFromFees(marketingWallet, true);\r\n        excludeFromFees(developmentWallet, true);\r\n        excludeFromFees(address(this), true);\r\n        excludeFromFees(address(0xdead), true);\r\n\r\n        excludeFromMaxTransaction(owner(), true);\r\n        excludeFromMaxTransaction(marketingWallet, true);\r\n        excludeFromMaxTransaction(developmentWallet, true);\r\n        excludeFromMaxTransaction(address(this), true);\r\n        excludeFromMaxTransaction(address(0xdead), true);\r\n\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router); \r\n\r\n        excludeFromMaxTransaction(address(_uniswapV2Router), true);\r\n        uniswapV2Router = _uniswapV2Router;\r\n\r\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\r\n        excludeFromMaxTransaction(address(uniswapV2Pair), true);\r\n        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);\r\n\r\n        _mint(msg.sender, totalSupply);\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    function enableTrading() external onlyOwner {\r\n        require(!tradingActive, \"Token launched\");\r\n        tradingActive = true;\r\n        launchBlock = block.number;\r\n        swapEnabled = true;\r\n    }\r\n\r\n    // disable Transfer delay - cannot be reenabled\r\n    function disableTransferDelay() external onlyOwner returns (bool) {\r\n        transferDelayEnabled = false;\r\n        return true;\r\n    }\r\n\r\n    // remove limits after token is stable\r\n    function removeLimits() external onlyOwner returns (bool) {\r\n        limitsInEffect = false;\r\n        return true;\r\n    }\r\n\r\n    // change the minimum amount of tokens to sell from fees\r\n    function updateSwapTokensAtAmount(uint256 newAmount)\r\n        external\r\n        onlyOwner\r\n        returns (bool)\r\n    {\r\n        require(\r\n            newAmount <= (totalSupply() * 5) / 1000,\r\n            \"Swap amount cannot be higher than 0.5% total supply.\"\r\n        );\r\n        require(\r\n            newAmount >= (totalSupply() * 1) / 100000,\r\n            \"Swap amount cannot be lower than 0.001% total supply.\"\r\n        );\r\n        swapTokensAtAmount = newAmount;\r\n        return true;\r\n    }\r\n\r\n    function updateMaxTransaction(uint256 newNum) external onlyOwner {\r\n        require(\r\n            newNum >= ((totalSupply() * 1) / 1000) / 1e18,\r\n            \"Cannot set maxTransaction lower than 0.1%\"\r\n        );\r\n        maxTransaction = newNum * (10**18);\r\n    }\r\n\r\n    function updateMaxWallet(uint256 newNum) external onlyOwner {\r\n        require(\r\n            newNum >= ((totalSupply() * 5) / 1000) / 1e18,\r\n            \"Cannot set maxWallet lower than 0.5%\"\r\n        );\r\n        maxWallet = newNum * (10**18);\r\n    }\r\n\r\n    function excludeFromMaxTransaction(address updAds, bool isEx)\r\n        public\r\n        onlyOwner\r\n    {\r\n        _isExcludedmaxTransaction[updAds] = isEx;\r\n    }\r\n\r\n    // only use to disable contract sales if absolutely necessary (emergency use only)\r\n    function updateSwapEnabled(bool enabled) external onlyOwner {\r\n        swapEnabled = enabled;\r\n    }\r\n\r\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\r\n        _isExcludedFromFees[account] = excluded;\r\n        emit ExcludeFromFees(account, excluded);\r\n    }\r\n\r\n    function setAutomatedMarketMakerPair(address pair, bool value)\r\n        public\r\n        onlyOwner\r\n    {\r\n        require(\r\n            pair != uniswapV2Pair,\r\n            \"The pair cannot be removed from automatedMarketMakerPairs\"\r\n        );\r\n\r\n        _setAutomatedMarketMakerPair(pair, value);\r\n    }\r\n\r\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\r\n        automatedMarketMakerPairs[pair] = value;\r\n\r\n        emit SetAutomatedMarketMakerPair(pair, value);\r\n    }\r\n\r\n    function isExcludedFromFees(address account) public view returns (bool) {\r\n        return _isExcludedFromFees[account];\r\n    }\r\n\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal override {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(!blocked[from], \"Sniper\");\r\n\r\n        if (amount == 0) {\r\n            super._transfer(from, to, 0);\r\n            return;\r\n        }\r\n\r\n        if (limitsInEffect) {\r\n            if (!swapping) {\r\n                if (!tradingActive) {\r\n                    require(\r\n                        _isExcludedFromFees[from] || _isExcludedFromFees[to],\r\n                        \"Trading is not active.\"\r\n                    );\r\n                }\r\n\r\n                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.\r\n                if (transferDelayEnabled) {\r\n                    if (\r\n                        to != owner() &&\r\n                        to != address(uniswapV2Router) &&\r\n                        to != address(uniswapV2Pair)\r\n                    ) {\r\n                        require(\r\n                            _holderLastTransferTimestamp[tx.origin] <\r\n                                block.number,\r\n                            \"_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.\"\r\n                        );\r\n                        _holderLastTransferTimestamp[tx.origin] = block.number;\r\n                    }\r\n                }\r\n\r\n                //when buy\r\n                if (\r\n                    automatedMarketMakerPairs[from] &&\r\n                    !_isExcludedmaxTransaction[to]\r\n                ) {\r\n                    require(\r\n                        amount <= maxTransaction,\r\n                        \"Buy transfer amount exceeds the maxTransaction.\"\r\n                    );\r\n                    require(\r\n                        amount + balanceOf(to) <= maxWallet,\r\n                        \"Max wallet exceeded\"\r\n                    );\r\n                }\r\n                //when sell\r\n                else if (\r\n                    automatedMarketMakerPairs[to] &&\r\n                    !_isExcludedmaxTransaction[from]\r\n                ) {\r\n                    require(\r\n                        amount <= maxTransaction,\r\n                        \"Sell transfer amount exceeds the maxTransaction.\"\r\n                    );\r\n                } else if (!_isExcludedmaxTransaction[to]) {\r\n                    require(\r\n                        amount + balanceOf(to) <= maxWallet,\r\n                        \"Max wallet exceeded\"\r\n                    );\r\n                }\r\n            }\r\n        }\r\n\r\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\r\n            _rewardThresholdTime = block.timestamp;\r\n        }\r\n        if (_isExcludedFromFees[from]) {\r\n            super._transfer(from, to, amount, true);\r\n            return;\r\n        }\r\n        if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {\r\n            if (automatedMarketMakerPairs[from]) {\r\n                HolderSwapInformation storage userRewardInfo = _holderInfoForReward[to];\r\n                if (userRewardInfo.lastSwapBuy == 0) {\r\n                    userRewardInfo.lastSwapBuy = block.timestamp;\r\n                }\r\n            } else {\r\n                HolderSwapInformation storage userRewardInfo = _holderInfoForReward[from];\r\n                userRewardInfo.holdingDuration = userRewardInfo.lastSwapBuy - _rewardThresholdTime;\r\n                userRewardInfo.lastSwapSell = block.timestamp;\r\n            }\r\n        }\r\n\r\n        uint256 contractTokenBalance = balanceOf(address(this));\r\n\r\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\r\n\r\n        if (\r\n            canSwap &&\r\n            swapEnabled &&\r\n            !swapping &&\r\n            !automatedMarketMakerPairs[from] &&\r\n            !_isExcludedFromFees[from] &&\r\n            !_isExcludedFromFees[to]\r\n        ) {\r\n            swapping = true;\r\n\r\n            swapBack();\r\n\r\n            swapping = false;\r\n        }\r\n\r\n        bool takeFee = !swapping;\r\n\r\n        // if any account belongs to _isExcludedFromFee account then remove the fee\r\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\r\n            takeFee = false;\r\n        }\r\n\r\n        uint256 fees = 0;\r\n        // only take fees on buys/sells, do not take on wallet transfers\r\n        if (takeFee) {\r\n            // on sell\r\n            if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {\r\n                fees = amount.mul(sellTotalFees).div(100);\r\n                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;\r\n                tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;\r\n                tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;\r\n                tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;\r\n            }\r\n            // on buy\r\n            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {\r\n                fees = amount.mul(buyTotalFees).div(100);\r\n                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;\r\n                tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;\r\n                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;\r\n                tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;\r\n            }\r\n\r\n            if (fees > 0) {\r\n                super._transfer(from, address(this), fees);\r\n            }\r\n\r\n            amount -= fees;\r\n        }\r\n\r\n        super._transfer(from, to, amount);\r\n    }\r\n\r\n    function blacklistSnipers(address[] calldata blockees, bool shouldBlock) external onlyOwner {\r\n        for(uint256 i = 0;i<blockees.length;i++){\r\n            address blockee = blockees[i];\r\n            if(blockee != address(this) && \r\n               blockee != router && \r\n               blockee != address(uniswapV2Pair))\r\n                blocked[blockee] = shouldBlock;\r\n        }\r\n    }\r\n\r\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\r\n        // approve token transfer to cover all possible scenarios\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n\r\n        // add the liquidity\r\n        uniswapV2Router.addLiquidityETH{value: ethAmount}(\r\n            address(this),\r\n            tokenAmount,\r\n            0, // slippage is unavoidable\r\n            0, // slippage is unavoidable\r\n            liquidityWallet,\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function swapTokensForEth(uint256 tokenAmount) private {\r\n        // generate the uniswap pair path of token -> weth\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n\r\n        // make the swap\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0, // accept any amount of ETH\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function swapBack() private {\r\n        uint256 contractBalance = balanceOf(address(this));\r\n        uint256 totalTokensToSwap = tokensForLiquidity +\r\n            tokensForMarketing +\r\n            tokensForDevelopment +\r\n            tokensForOperations;\r\n        bool success;\r\n\r\n        if (contractBalance == 0 || totalTokensToSwap == 0) {\r\n            return;\r\n        }\r\n\r\n        if (contractBalance > swapTokensAtAmount * 16) {\r\n            contractBalance = swapTokensAtAmount * 16;\r\n        }\r\n\r\n        // Halve the amount of liquidity tokens\r\n        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;\r\n        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);\r\n\r\n        uint256 initialETHBalance = address(this).balance;\r\n\r\n        swapTokensForEth(amountToSwapForETH);\r\n\r\n        uint256 ethBalance = address(this).balance.sub(initialETHBalance);\r\n\r\n        uint256 ethForMark = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);\r\n        uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(totalTokensToSwap);\r\n        uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);\r\n\r\n        uint256 ethForLiquidity = ethBalance - ethForMark - ethForDevelopment - ethForOperations;\r\n\r\n        tokensForLiquidity = 0;\r\n        tokensForMarketing = 0;\r\n        tokensForDevelopment = 0;\r\n        tokensForOperations = 0;\r\n\r\n        (success, ) = address(developmentWallet).call{value: ethForDevelopment}(\"\");\r\n\r\n        if (liquidityTokens > 0 && ethForLiquidity > 0) {\r\n            addLiquidity(liquidityTokens, ethForLiquidity);\r\n            emit SwapAndLiquify(\r\n                amountToSwapForETH,\r\n                ethForLiquidity,\r\n                tokensForLiquidity\r\n            );\r\n        }\r\n        (success, ) = address(operationsWallet).call{value: ethForOperations}(\"\");\r\n        (success, ) = address(marketingWallet).call{value: address(this).balance}(\"\");\r\n    }\r\n}"
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
    },
    "metadata": {
      "useLiteralContent": true
    },
    "libraries": {}
  }
}}