{{
  "language": "Solidity",
  "sources": {
    "contracts/3_Pepepredator.sol": {
      "content": "/*\nPP is the Pepe Predator, it is a community token whose function is to flip the PEPE Market cap.\n*/\n\n// SPDX-License-Identifier: MIT\npragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;\npragma experimental ABIEncoderV2;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\ninterface IERC20 {\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ninterface IERC20Metadata is IERC20 {\n\n    function name() external view returns (string memory);\n\n    function symbol() external view returns (string memory);\n\n    function decimals() external view returns (uint8);\n}\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\n        unchecked {\n            _approve(sender, _msgSender(), currentAllowance - amount);\n        }\n\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[sender] = senderBalance - amount;\n        }\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n\n        _afterTokenTransfer(sender, recipient, amount);\n    }\n\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n        }\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n\nlibrary SafeMath {\n\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            uint256 c = a + b;\n            if (c < a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b > a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    function sub(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b <= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    function div(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a / b;\n        }\n    }\n\n    function mod(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a % b;\n        }\n    }\n}\n\ninterface IUniswapV2Factory {\n    event PairCreated(\n        address indexed token0,\n        address indexed token1,\n        address pair,\n        uint256\n    );\n\n    function feeTo() external view returns (address);\n\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB)\n        external\n        view\n        returns (address pair);\n\n    function allPairs(uint256) external view returns (address pair);\n\n    function allPairsLength() external view returns (uint256);\n\n    function createPair(address tokenA, address tokenB)\n        external\n        returns (address pair);\n\n    function setFeeTo(address) external;\n\n    function setFeeToSetter(address) external;\n}\n\ninterface IUniswapV2Pair {\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    function name() external pure returns (string memory);\n\n    function symbol() external pure returns (string memory);\n\n    function decimals() external pure returns (uint8);\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address owner) external view returns (uint256);\n\n    function allowance(address owner, address spender)\n        external\n        view\n        returns (uint256);\n\n    function approve(address spender, uint256 value) external returns (bool);\n\n    function transfer(address to, uint256 value) external returns (bool);\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 value\n    ) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n\n    function nonces(address owner) external view returns (uint256);\n\n    function permit(\n        address owner,\n        address spender,\n        uint256 value,\n        uint256 deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) external;\n\n    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\n    event Burn(\n        address indexed sender,\n        uint256 amount0,\n        uint256 amount1,\n        address indexed to\n    );\n    event Swap(\n        address indexed sender,\n        uint256 amount0In,\n        uint256 amount1In,\n        uint256 amount0Out,\n        uint256 amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint256);\n\n    function factory() external view returns (address);\n\n    function token0() external view returns (address);\n\n    function token1() external view returns (address);\n\n    function getReserves()\n        external\n        view\n        returns (\n            uint112 reserve0,\n            uint112 reserve1,\n            uint32 blockTimestampLast\n        );\n\n    function price0CumulativeLast() external view returns (uint256);\n\n    function price1CumulativeLast() external view returns (uint256);\n\n    function kLast() external view returns (uint256);\n\n    function mint(address to) external returns (uint256 liquidity);\n\n    function burn(address to)\n        external\n        returns (uint256 amount0, uint256 amount1);\n\n    function swap(\n        uint256 amount0Out,\n        uint256 amount1Out,\n        address to,\n        bytes calldata data\n    ) external;\n\n    function skim(address to) external;\n\n    function sync() external;\n\n    function initialize(address, address) external;\n}\n\ninterface IUniswapV2Router02 {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint256 amountADesired,\n        uint256 amountBDesired,\n        uint256 amountAMin,\n        uint256 amountBMin,\n        address to,\n        uint256 deadline\n    )\n        external\n        returns (\n            uint256 amountA,\n            uint256 amountB,\n            uint256 liquidity\n        );\n\n    function addLiquidityETH(\n        address token,\n        uint256 amountTokenDesired,\n        uint256 amountTokenMin,\n        uint256 amountETHMin,\n        address to,\n        uint256 deadline\n    )\n        external\n        payable\n        returns (\n            uint256 amountToken,\n            uint256 amountETH,\n            uint256 liquidity\n        );\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external payable;\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n}\n\ncontract PepePredator is ERC20, Ownable {\n    using SafeMath for uint256;\n\n    IUniswapV2Router02 public immutable uniswapV2Router;\n    address public immutable uniswapV2Pair;\n    address public constant deadAddress = address(0xdead);\n    address public uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n\n    bool private swapping;\n\n    address public cexWallet;\n    address public devWallet;\n    address public liqWallet;\n    address public opsWallet;\n\n    uint256 public maxTxn;\n    uint256 public swapTokensAtAmount;\n    uint256 public maxWallet;\n\n    bool public limitsInEffect = true;\n    bool public tradingActive = false;\n    bool public swapEnabled = false;\n\n    // Anti-bot and anti-whale mappings and variables\n    mapping(address => uint256) private _holderLastTransferTimestamp;\n    bool public transferDelayEnabled = true;\n    uint256 private launchBlock;\n    mapping(address => bool) public blocked;\n\n    uint256 public buyTotalFees;\n    uint256 public buyCexFee;\n    uint256 public buyLiqFee;\n    uint256 public buyDevFee;\n    uint256 public buyOpsFee;\n\n    uint256 public sellTotalFees;\n    uint256 public sellCexFee;\n    uint256 public sellLiqFee;\n    uint256 public sellDevFee;\n    uint256 public sellOpsFee;\n\n    uint256 public tokensForCex;\n    uint256 public tokensForLiq;\n    uint256 public tokensForDev;\n    uint256 public tokensForOps;\n\n    mapping(address => bool) private _isExcludedFromFees;\n    mapping(address => bool) public _isExcludedmaxTxn;\n\n    mapping(address => bool) public automatedMarketMakerPairs;\n\n    event UpdateUniswapV2Router(\n        address indexed newAddress,\n        address indexed oldAddress\n    );\n\n    event ExcludeFromFees(address indexed account, bool isExcluded);\n\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\n\n    event cexWalletUpdated(\n        address indexed newWallet,\n        address indexed oldWallet\n    );\n\n    event devWalletUpdated(\n        address indexed newWallet,\n        address indexed oldWallet\n    );\n\n    event liqWalletUpdated(\n        address indexed newWallet,\n        address indexed oldWallet\n    );\n\n    event opsWalletUpdated(\n        address indexed newWallet,\n        address indexed oldWallet\n    );\n\n    event SwapAndLiquify(\n        uint256 tokensSwapped,\n        uint256 ethReceived,\n        uint256 tokensIntoLiquidity\n    );\n\n    constructor() ERC20(\"Pepe Predator\", \"PP\") {\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uniswapRouter); \n\n        excludeFrommaxTxn(address(_uniswapV2Router), true);\n        uniswapV2Router = _uniswapV2Router;\n\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\n        excludeFrommaxTxn(address(uniswapV2Pair), true);\n        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);\n\n        // launch buy fees\n        uint256 _buyCexFee = 0;\n        uint256 _buyLiqFee = 0;\n        uint256 _buyDevFee = 15;\n        uint256 _buyOpsFee = 0;\n        \n        // launch sell fees\n        uint256 _sellCexFee = 0;\n        uint256 _sellLiqFee = 0;\n        uint256 _sellDevFee = 15;\n        uint256 _sellOpsFee = 0;\n\n        uint256 totalSupply = 999_999_999 * 1e18;\n\n        maxTxn = 1_500_000 * 1e18; // 1.5% max transaction at launch\n        maxWallet = 1_500_000 * 1e18; // 1.5% max wallet at launch\n        swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet\n\n        buyCexFee = _buyCexFee;\n        buyLiqFee = _buyLiqFee;\n        buyDevFee = _buyDevFee;\n        buyOpsFee = _buyOpsFee;\n        buyTotalFees = buyCexFee + buyLiqFee + buyDevFee + buyOpsFee;\n\n        sellCexFee = _sellCexFee;\n        sellLiqFee = _sellLiqFee;\n        sellDevFee = _sellDevFee;\n        sellOpsFee = _sellOpsFee;\n        sellTotalFees = sellCexFee + sellLiqFee + sellDevFee + sellOpsFee;\n\n        cexWallet = address(0xd96Df575148B70EBcE0AB7cd8DD98CA258400C8a); \n        devWallet = address(0xd96Df575148B70EBcE0AB7cd8DD98CA258400C8a); \n        liqWallet = address(0xd96Df575148B70EBcE0AB7cd8DD98CA258400C8a); \n        opsWallet = address(0xd96Df575148B70EBcE0AB7cd8DD98CA258400C8a);\n\n        // exclude from paying fees or having max transaction amount\n        excludeFromFees(owner(), true);\n        excludeFromFees(address(this), true);\n        excludeFromFees(address(0xdead), true);\n\n        excludeFrommaxTxn(owner(), true);\n        excludeFrommaxTxn(address(this), true);\n        excludeFrommaxTxn(address(0xdead), true);\n\n        _mint(msg.sender, totalSupply);\n    }\n\n    receive() external payable {}\n\n    function enableTrading() external onlyOwner {\n        require(!tradingActive, \"Token launched\");\n        tradingActive = true;\n        launchBlock = block.number;\n        swapEnabled = true;\n    }\n\n    // remove limits after token is stable\n    function removeLimits() external onlyOwner returns (bool) {\n        limitsInEffect = false;\n        return true;\n    }\n\n    // disable Transfer delay - cannot be reenabled\n    function disableTransferDelay() external onlyOwner returns (bool) {\n        transferDelayEnabled = false;\n        return true;\n    }\n\n    // change the minimum amount of tokens to sell from fees\n    function updateSwapTokensAtAmount(uint256 newAmount)\n        external\n        onlyOwner\n        returns (bool)\n    {\n        require(\n            newAmount >= (totalSupply() * 1) / 100000,\n            \"Swap amount cannot be lower than 0.001% total supply.\"\n        );\n        require(\n            newAmount <= (totalSupply() * 5) / 1000,\n            \"Swap amount cannot be higher than 0.5% total supply.\"\n        );\n        swapTokensAtAmount = newAmount;\n        return true;\n    }\n\n    function updatemaxTxn(uint256 newNum) external onlyOwner {\n        require(\n            newNum >= ((totalSupply() * 1) / 1000) / 1e18,\n            \"Cannot set maxTxn lower than 0.1%\"\n        );\n        maxTxn = newNum * (10**18);\n    }\n\n    function updateMaxWallet(uint256 newNum) external onlyOwner {\n        require(\n            newNum >= ((totalSupply() * 5) / 1000) / 1e18,\n            \"Cannot set maxWallet lower than 0.5%\"\n        );\n        maxWallet = newNum * (10**18);\n    }\n\n    function excludeFrommaxTxn(address updAds, bool isEx)\n        public\n        onlyOwner\n    {\n        _isExcludedmaxTxn[updAds] = isEx;\n    }\n\n    // only use to disable contract sales if absolutely necessary (emergency use only)\n    function updateSwapEnabled(bool enabled) external onlyOwner {\n        swapEnabled = enabled;\n    }\n\n    function updateBuyFees(\n        uint256 _cexFee,\n        uint256 _liqFee,\n        uint256 _devFee,\n        uint256 _opsFee\n    ) external onlyOwner {\n        buyCexFee = _cexFee;\n        buyLiqFee = _liqFee;\n        buyDevFee = _devFee;\n        buyOpsFee = _opsFee;\n        buyTotalFees = buyCexFee + buyLiqFee + buyDevFee + buyOpsFee;\n        require(buyTotalFees <= 99);\n    }\n\n    function updateSellFees(\n        uint256 _cexFee,\n        uint256 _liqFee,\n        uint256 _devFee,\n        uint256 _opsFee\n    ) external onlyOwner {\n        sellCexFee = _cexFee;\n        sellLiqFee = _liqFee;\n        sellDevFee = _devFee;\n        sellOpsFee = _opsFee;\n        sellTotalFees = sellCexFee + sellLiqFee + sellDevFee + sellOpsFee;\n        require(sellTotalFees <= 99); \n    }\n\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\n        _isExcludedFromFees[account] = excluded;\n        emit ExcludeFromFees(account, excluded);\n    }\n\n    function setAutomatedMarketMakerPair(address pair, bool value)\n        public\n        onlyOwner\n    {\n        require(\n            pair != uniswapV2Pair,\n            \"The pair cannot be removed from automatedMarketMakerPairs\"\n        );\n\n        _setAutomatedMarketMakerPair(pair, value);\n    }\n\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\n        automatedMarketMakerPairs[pair] = value;\n\n        emit SetAutomatedMarketMakerPair(pair, value);\n    }\n\n    function updatecexWallet(address newcexWallet) external onlyOwner {\n        emit cexWalletUpdated(newcexWallet, cexWallet);\n        cexWallet = newcexWallet;\n    }\n\n    function updatedevWallet(address newWallet) external onlyOwner {\n        emit devWalletUpdated(newWallet, devWallet);\n        devWallet = newWallet;\n    }\n\n    function updateopsWallet(address newWallet) external onlyOwner{\n        emit opsWalletUpdated(newWallet, opsWallet);\n        opsWallet = newWallet;\n    }\n\n    function updateliqWallet(address newliqWallet) external onlyOwner {\n        emit liqWalletUpdated(newliqWallet, liqWallet);\n        liqWallet = newliqWallet;\n    }\n\n    function isExcludedFromFees(address account) public view returns (bool) {\n        return _isExcludedFromFees[account];\n    }\n\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal override {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        require(!blocked[from], \"Blocked\");\n\n        if (amount == 0) {\n            super._transfer(from, to, 0);\n            return;\n        }\n\n        if (limitsInEffect) {\n            if (\n                from != owner() &&\n                to != owner() &&\n                to != address(0) &&\n                to != address(0xdead) &&\n                !swapping\n            ) {\n                if (!tradingActive) {\n                    require(\n                        _isExcludedFromFees[from] || _isExcludedFromFees[to],\n                        \"Trading is not active.\"\n                    );\n                }\n\n                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.\n                if (transferDelayEnabled) {\n                    if (\n                        to != owner() &&\n                        to != address(uniswapV2Router) &&\n                        to != address(uniswapV2Pair)\n                    ) {\n                        require(\n                            _holderLastTransferTimestamp[tx.origin] <\n                                block.number,\n                            \"_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.\"\n                        );\n                        _holderLastTransferTimestamp[tx.origin] = block.number;\n                    }\n                }\n\n                //when buy\n                if (\n                    automatedMarketMakerPairs[from] &&\n                    !_isExcludedmaxTxn[to]\n                ) {\n                    require(\n                        amount <= maxTxn,\n                        \"Buy transfer amount exceeds the maxTxn.\"\n                    );\n                    require(\n                        amount + balanceOf(to) <= maxWallet,\n                        \"Max wallet exceeded\"\n                    );\n                }\n                //when sell\n                else if (\n                    automatedMarketMakerPairs[to] &&\n                    !_isExcludedmaxTxn[from]\n                ) {\n                    require(\n                        amount <= maxTxn,\n                        \"Sell transfer amount exceeds the maxTxn.\"\n                    );\n                } else if (!_isExcludedmaxTxn[to]) {\n                    require(\n                        amount + balanceOf(to) <= maxWallet,\n                        \"Max wallet exceeded\"\n                    );\n                }\n            }\n        }\n\n        uint256 contractTokenBalance = balanceOf(address(this));\n\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\n\n        if (\n            canSwap &&\n            swapEnabled &&\n            !swapping &&\n            !automatedMarketMakerPairs[from] &&\n            !_isExcludedFromFees[from] &&\n            !_isExcludedFromFees[to]\n        ) {\n            swapping = true;\n\n            swapBack();\n\n            swapping = false;\n        }\n\n        bool takeFee = !swapping;\n\n        // if any account belongs to _isExcludedFromFee account then remove the fee\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\n            takeFee = false;\n        }\n\n        uint256 fees = 0;\n        // only take fees on buys/sells, do not take on wallet transfers\n        if (takeFee) {\n            // on sell\n            if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {\n                fees = amount.mul(sellTotalFees).div(100);\n                tokensForLiq += (fees * sellLiqFee) / sellTotalFees;\n                tokensForDev += (fees * sellDevFee) / sellTotalFees;\n                tokensForCex += (fees * sellCexFee) / sellTotalFees;\n                tokensForOps += (fees * sellOpsFee) / sellTotalFees;\n            }\n            // on buy\n            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {\n                fees = amount.mul(buyTotalFees).div(100);\n                tokensForLiq += (fees * buyLiqFee) / buyTotalFees;\n                tokensForDev += (fees * buyDevFee) / buyTotalFees;\n                tokensForCex += (fees * buyCexFee) / buyTotalFees;\n                tokensForOps += (fees * buyOpsFee) / buyTotalFees;\n            }\n\n            if (fees > 0) {\n                super._transfer(from, address(this), fees);\n            }\n\n            amount -= fees;\n        }\n\n        super._transfer(from, to, amount);\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private {\n        // generate the uniswap pair path of token -> weth\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // make the swap\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of ETH\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\n        // approve token transfer to cover all possible scenarios\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // add the liquidity\n        uniswapV2Router.addLiquidityETH{value: ethAmount}(\n            address(this),\n            tokenAmount,\n            0, // slippage is unavoidable\n            0, // slippage is unavoidable\n            liqWallet,\n            block.timestamp\n        );\n    }\n\n    function toggleBlackList(address[] calldata blockees, bool shouldBlock) external onlyOwner {\n        for(uint256 i = 0;i<blockees.length;i++){\n            address blockee = blockees[i];\n            if(blockee != address(this) && \n               blockee != uniswapRouter && \n               blockee != address(uniswapV2Pair))\n                blocked[blockee] = shouldBlock;\n        }\n    }\n\n    function swapBack() private {\n        uint256 contractBalance = balanceOf(address(this));\n        uint256 totalTokensToSwap = tokensForLiq +\n            tokensForCex +\n            tokensForDev +\n            tokensForOps;\n        bool success;\n\n        if (contractBalance == 0 || totalTokensToSwap == 0) {\n            return;\n        }\n\n        if (contractBalance > swapTokensAtAmount * 20) {\n            contractBalance = swapTokensAtAmount * 20;\n        }\n\n        // Halve the amount of liquidity tokens\n        uint256 liquidityTokens = (contractBalance * tokensForLiq) / totalTokensToSwap / 2;\n        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);\n\n        uint256 initialETHBalance = address(this).balance;\n\n        swapTokensForEth(amountToSwapForETH);\n\n        uint256 ethBalance = address(this).balance.sub(initialETHBalance);\n\n        uint256 ethForCex = ethBalance.mul(tokensForCex).div(totalTokensToSwap);\n        uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);\n        uint256 ethForOps = ethBalance.mul(tokensForOps).div(totalTokensToSwap);\n\n        uint256 ethForLiquidity = ethBalance - ethForCex - ethForDev - ethForOps;\n\n        tokensForLiq = 0;\n        tokensForCex = 0;\n        tokensForDev = 0;\n        tokensForOps = 0;\n\n        (success, ) = address(devWallet).call{value: ethForDev}(\"\");\n\n        if (liquidityTokens > 0 && ethForLiquidity > 0) {\n            addLiquidity(liquidityTokens, ethForLiquidity);\n            emit SwapAndLiquify(\n                amountToSwapForETH,\n                ethForLiquidity,\n                tokensForLiq\n            );\n        }\n        (success, ) = address(opsWallet).call{value: ethForOps}(\"\");\n        (success, ) = address(cexWallet).call{value: address(this).balance}(\"\");\n    }\n}"
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