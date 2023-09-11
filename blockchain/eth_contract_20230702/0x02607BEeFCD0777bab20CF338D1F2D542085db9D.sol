{{
  "language": "Solidity",
  "sources": {
    "12_YinYang.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;\npragma experimental ABIEncoderV2;\n\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\n\ninterface IERC20 {\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\n\ninterface IERC20Metadata is IERC20 {\n\n    function name() external view returns (string memory);\n\n    function symbol() external view returns (string memory);\n\n    function decimals() external view returns (uint8);\n}\n\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n\n\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\n        unchecked {\n            _approve(sender, _msgSender(), currentAllowance - amount);\n        }\n\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[sender] = senderBalance - amount;\n        }\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n\n        _afterTokenTransfer(sender, recipient, amount);\n    }\n\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n        }\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n\n\nlibrary SafeMath {\n\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            uint256 c = a + b;\n            if (c < a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b > a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    function sub(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b <= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    function div(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a / b;\n        }\n    }\n\n\n    function mod(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a % b;\n        }\n    }\n}\n\n\ninterface IUniswapV2Factory {\n    event PairCreated(\n        address indexed token0,\n        address indexed token1,\n        address pair,\n        uint256\n    );\n\n    function feeTo() external view returns (address);\n\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB)\n        external\n        view\n        returns (address pair);\n\n    function allPairs(uint256) external view returns (address pair);\n\n    function allPairsLength() external view returns (uint256);\n\n    function createPair(address tokenA, address tokenB)\n        external\n        returns (address pair);\n\n    function setFeeTo(address) external;\n\n    function setFeeToSetter(address) external;\n}\n\n\ninterface IUniswapV2Pair {\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    function name() external pure returns (string memory);\n\n    function symbol() external pure returns (string memory);\n\n    function decimals() external pure returns (uint8);\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address owner) external view returns (uint256);\n\n    function allowance(address owner, address spender)\n        external\n        view\n        returns (uint256);\n\n    function approve(address spender, uint256 value) external returns (bool);\n\n    function transfer(address to, uint256 value) external returns (bool);\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 value\n    ) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n\n    function nonces(address owner) external view returns (uint256);\n\n    function permit(\n        address owner,\n        address spender,\n        uint256 value,\n        uint256 deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) external;\n\n    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\n    event Burn(\n        address indexed sender,\n        uint256 amount0,\n        uint256 amount1,\n        address indexed to\n    );\n    event Swap(\n        address indexed sender,\n        uint256 amount0In,\n        uint256 amount1In,\n        uint256 amount0Out,\n        uint256 amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint256);\n\n    function factory() external view returns (address);\n\n    function token0() external view returns (address);\n\n    function token1() external view returns (address);\n\n    function getReserves()\n        external\n        view\n        returns (\n            uint112 reserve0,\n            uint112 reserve1,\n            uint32 blockTimestampLast\n        );\n\n    function price0CumulativeLast() external view returns (uint256);\n\n    function price1CumulativeLast() external view returns (uint256);\n\n    function kLast() external view returns (uint256);\n\n    function mint(address to) external returns (uint256 liquidity);\n\n    function burn(address to)\n        external\n        returns (uint256 amount0, uint256 amount1);\n\n    function swap(\n        uint256 amount0Out,\n        uint256 amount1Out,\n        address to,\n        bytes calldata data\n    ) external;\n\n    function skim(address to) external;\n\n    function sync() external;\n\n    function initialize(address, address) external;\n}\n\n\ninterface IUniswapV2Router02 {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint256 amountADesired,\n        uint256 amountBDesired,\n        uint256 amountAMin,\n        uint256 amountBMin,\n        address to,\n        uint256 deadline\n    )\n        external\n        returns (\n            uint256 amountA,\n            uint256 amountB,\n            uint256 liquidity\n        );\n\n    function addLiquidityETH(\n        address token,\n        uint256 amountTokenDesired,\n        uint256 amountTokenMin,\n        uint256 amountETHMin,\n        address to,\n        uint256 deadline\n    )\n        external\n        payable\n        returns (\n            uint256 amountToken,\n            uint256 amountETH,\n            uint256 liquidity\n        );\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external payable;\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n}\n\n\n\ncontract YinYang is ERC20, Ownable {\n    using SafeMath for uint256;\n\n    IUniswapV2Router02 public immutable uniswapV2Router;\n    address public immutable uniswapV2Pair;\n    address public constant deadAddress = address(0xdead);\n\n    bool private swapping;\n\n    address private marketingWallet;\n    address private developmentWallet;\n\n    uint256 public percentForLPBurn = 0; \n    bool public lpBurnEnabled = false;\n    uint256 public lpBurnFrequency = 3600 seconds;\n    uint256 public lastLpBurnTime;\n\n    uint256 public maxTransactionAmount;\n    uint256 public swapTokensAtAmount;\n    uint256 public maxWallet;\n\n    bool public limitsInEffect = true;\n    bool public tradingActive = false;\n    bool public swapEnabled = true;\n\n    uint256 public manualBurnFrequency = 30 minutes;\n    uint256 public lastManualLpBurnTime;\n\n\n\n    mapping(address => uint256) private _holderLastTransferTimestamp; \n    bool public transferDelayEnabled = true;\n\n    uint256 public buyTotalFees;\n    uint256 public buyMarketingFee;\n    uint256 public buyLiquidityFee;\n    uint256 public buyDevelopmentFee;\n\n    uint256 public sellTotalFees;\n    uint256 public sellMarketingFee;\n    uint256 public sellLiquidityFee;\n    uint256 public sellDevelopmentFee;\n\n    uint256 public tokensForMarketing;\n    uint256 public tokensForLiquidity;\n    uint256 public tokensForDev;\n\n    mapping(address => bool) private _isExcludedFromFees;\n    mapping(address => bool) public _isExcludedMaxTransactionAmount;\n\n    mapping(address => bool) public automatedMarketMakerPairs;\n\n    event UpdateUniswapV2Router(\n        address indexed newAddress,\n        address indexed oldAddress\n    );\n\n    event ExcludeFromFees(address indexed account, bool isExcluded);\n\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\n\n    event marketingWalletUpdated(\n        address indexed newWallet,\n        address indexed oldWallet\n    );\n\n    event developmentWalletUpdated(\n        address indexed newWallet,\n        address indexed oldWallet\n    );\n\n    event SwapAndLiquify(\n        uint256 tokensSwapped,\n        uint256 ethReceived,\n        uint256 tokensIntoLiquidity\n    );\n\n    event AutoNukeLP();\n\n    event ManualNukeLP();\n\n    constructor() ERC20(\"Ying Yang\", unicode\"YIYA\") {\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\n        );\n\n        excludeFromMaxTransaction(address(_uniswapV2Router), true);\n        uniswapV2Router = _uniswapV2Router;\n\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\n            .createPair(address(this), _uniswapV2Router.WETH());\n        excludeFromMaxTransaction(address(uniswapV2Pair), true);\n        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);\n\n        uint256 _buyMarketingFee = 20;\n        uint256 _buyLiquidityFee = 0;\n        uint256 _buyDevelopmentFee = 5;\n\n        uint256 _sellMarketingFee = 25;\n        uint256 _sellLiquidityFee = 0;\n        uint256 _sellDevelopmentFee = 25;\n\n        uint256 totalSupply = 100_000_000 * 1e18;\n\n        maxTransactionAmount = 2_000_000 * 1e18;\n        maxWallet = 2_000_000 * 1e18;\n        swapTokensAtAmount = (totalSupply * 10) / 10000;\n\n        buyMarketingFee = _buyMarketingFee;\n        buyLiquidityFee = _buyLiquidityFee;\n        buyDevelopmentFee = _buyDevelopmentFee;\n        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;\n\n        sellMarketingFee = _sellMarketingFee;\n        sellLiquidityFee = _sellLiquidityFee;\n        sellDevelopmentFee = _sellDevelopmentFee;\n        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;\n\n        marketingWallet = address(0xa0E93Da3D327A8c07f90e3bbb094d7D51133c2dc);\n        developmentWallet = address(0xa0E93Da3D327A8c07f90e3bbb094d7D51133c2dc);\n\n        excludeFromFees(owner(), true);\n        excludeFromFees(address(this), true);\n        excludeFromFees(address(0xdead), true);\n\n        excludeFromMaxTransaction(owner(), true);\n        excludeFromMaxTransaction(address(this), true);\n        excludeFromMaxTransaction(address(0xdead), true);\n\n        _mint(msg.sender, totalSupply);\n    }\n\n    receive() external payable {}\n\n    function enableTrade() external onlyOwner {\n        tradingActive = true;\n        swapEnabled = true;\n        lastLpBurnTime = block.timestamp;\n    }\n\n    function removeLimits() external onlyOwner returns (bool) {\n        limitsInEffect = false;\n        return true;\n    }\n\n    function disableTransferDelay() external onlyOwner returns (bool) {\n        transferDelayEnabled = false;\n        return true;\n    }\n\n    function updateSwapTokensAtAmount(uint256 newAmount)\n        external\n        onlyOwner\n        returns (bool)\n    {\n        require(\n            newAmount >= (totalSupply() * 1) / 100000,\n            \"Swap amount cannot be lower than 0.001% total supply.\"\n        );\n        require(\n            newAmount <= (totalSupply() * 5) / 1000,\n            \"Swap amount cannot be higher than 0.5% total supply.\"\n        );\n        swapTokensAtAmount = newAmount;\n        return true;\n    }\n\n    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {\n        require(\n            newNum >= ((totalSupply() * 1) / 1000) / 1e18,\n            \"Cannot set maxTransactionAmount lower than 0.1%\"\n        );\n        maxTransactionAmount = newNum * (10**18);\n    }\n\n    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {\n        require(\n            newNum >= ((totalSupply() * 5) / 1000) / 1e18,\n            \"Cannot set maxWallet lower than 0.5%\"\n        );\n        maxWallet = newNum * (10**18);\n    }\n\n    function excludeFromMaxTransaction(address updAds, bool isEx)\n        public\n        onlyOwner\n    {\n        _isExcludedMaxTransactionAmount[updAds] = isEx;\n    }\n\n    function updateSwapEnabled(bool enabled) external onlyOwner {\n        swapEnabled = enabled;\n    }\n\n    function updateBuyFees(\n        uint256 _marketingFee,\n        uint256 _liquidityFee,\n        uint256 _developmentFee\n    ) external onlyOwner {\n        buyMarketingFee = _marketingFee;\n        buyLiquidityFee = _liquidityFee;\n        buyDevelopmentFee = _developmentFee;\n        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;\n    }\n\n    function updateSellFees(\n        uint256 _marketingFee,\n        uint256 _liquidityFee,\n        uint256 _developmentFee\n    ) external onlyOwner {\n        sellMarketingFee = _marketingFee;\n        sellLiquidityFee = _liquidityFee;\n        sellDevelopmentFee = _developmentFee;\n        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;\n    }\n\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\n        _isExcludedFromFees[account] = excluded;\n        emit ExcludeFromFees(account, excluded);\n    }\n\n    function setAutomatedMarketMakerPair(address pair, bool value)\n        public\n        onlyOwner\n    {\n        require(\n            pair != uniswapV2Pair,\n            \"The pair cannot be removed from automatedMarketMakerPairs\"\n        );\n\n        _setAutomatedMarketMakerPair(pair, value);\n    }\n\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\n        automatedMarketMakerPairs[pair] = value;\n\n        emit SetAutomatedMarketMakerPair(pair, value);\n    }\n\n    function updateMarketingWalletInfo(address newMarketingWallet)\n        external\n        onlyOwner\n    {\n        emit marketingWalletUpdated(newMarketingWallet, marketingWallet);\n        marketingWallet = newMarketingWallet;\n    }\n\n    function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {\n        emit developmentWalletUpdated(newWallet, developmentWallet);\n        developmentWallet = newWallet;\n    }\n\n    function isExcludedFromFees(address account) public view returns (bool) {\n        return _isExcludedFromFees[account];\n    }\n\n    event BoughtEarly(address indexed sniper);\n\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal override {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        if (amount == 0) {\n            super._transfer(from, to, 0);\n            return;\n        }\n\n        if (limitsInEffect) {\n            if (\n                from != owner() &&\n                to != owner() &&\n                to != address(0) &&\n                to != address(0xdead) &&\n                !swapping\n            ) {\n                if (!tradingActive) {\n                    require(\n                        _isExcludedFromFees[from] || _isExcludedFromFees[to],\n                        \"Trading is not active.\"\n                    );\n                }\n\n                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.\n                if (transferDelayEnabled) {\n                    if (\n                        to != owner() &&\n                        to != address(uniswapV2Router) &&\n                        to != address(uniswapV2Pair)\n                    ) {\n                        require(\n                            _holderLastTransferTimestamp[tx.origin] <\n                                block.number,\n                            \"_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.\"\n                        );\n                        _holderLastTransferTimestamp[tx.origin] = block.number;\n                    }\n                }\n\n                //when buy\n                if (\n                    automatedMarketMakerPairs[from] &&\n                    !_isExcludedMaxTransactionAmount[to]\n                ) {\n                    require(\n                        amount <= maxTransactionAmount,\n                        \"Buy transfer amount exceeds the maxTransactionAmount.\"\n                    );\n                    require(\n                        amount + balanceOf(to) <= maxWallet,\n                        \"Max wallet exceeded\"\n                    );\n                }\n                //when sell\n                else if (\n                    automatedMarketMakerPairs[to] &&\n                    !_isExcludedMaxTransactionAmount[from]\n                ) {\n                    require(\n                        amount <= maxTransactionAmount,\n                        \"Sell transfer amount exceeds the maxTransactionAmount.\"\n                    );\n                } else if (!_isExcludedMaxTransactionAmount[to]) {\n                    require(\n                        amount + balanceOf(to) <= maxWallet,\n                        \"Max wallet exceeded\"\n                    );\n                }\n            }\n        }\n\n        uint256 contractTokenBalance = balanceOf(address(this));\n\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\n\n        if (\n            canSwap &&\n            swapEnabled &&\n            !swapping &&\n            !automatedMarketMakerPairs[from] &&\n            !_isExcludedFromFees[from] &&\n            !_isExcludedFromFees[to]\n        ) {\n            swapping = true;\n\n            swapBack();\n\n            swapping = false;\n        }\n\n        if (\n            !swapping &&\n            automatedMarketMakerPairs[to] &&\n            lpBurnEnabled &&\n            block.timestamp >= lastLpBurnTime + lpBurnFrequency &&\n            !_isExcludedFromFees[from]\n        ) {\n            autoBurnLiquidityPairTokens();\n        }\n\n        bool takeFee = !swapping;\n\n        // if any account belongs to _isExcludedFromFee account then remove the fee\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\n            takeFee = false;\n        }\n\n        uint256 fees = 0;\n        // only take fees on buys/sells, do not take on wallet transfers\n        if (takeFee) {\n            // on sell\n            if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {\n                fees = amount.mul(sellTotalFees).div(100);\n                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;\n                tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;\n                tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;\n            }\n            // on buy\n            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {\n                fees = amount.mul(buyTotalFees).div(100);\n                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;\n                tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;\n                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;\n            }\n\n            if (fees > 0) {\n                super._transfer(from, address(this), fees);\n            }\n\n            amount -= fees;\n        }\n\n        super._transfer(from, to, amount);\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private {\n        // generate the uniswap pair path of token -> weth\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // make the swap\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of ETH\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\n        // approve token transfer to cover all possible scenarios\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // add the liquidity\n        uniswapV2Router.addLiquidityETH{value: ethAmount}(\n            address(this),\n            tokenAmount,\n            0, // slippage is unavoidable\n            0, // slippage is unavoidable\n            deadAddress,\n            block.timestamp\n        );\n    }\n\n    function swapBack() private {\n        uint256 contractBalance = balanceOf(address(this));\n        uint256 totalTokensToSwap = tokensForLiquidity +\n            tokensForMarketing +\n            tokensForDev;\n        bool success;\n\n        if (contractBalance == 0 || totalTokensToSwap == 0) {\n            return;\n        }\n\n        if (contractBalance > swapTokensAtAmount * 20) {\n            contractBalance = swapTokensAtAmount * 20;\n        }\n\n        // Halve the amount of liquidity tokens\n        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /\n            totalTokensToSwap /\n            2;\n        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);\n\n        uint256 initialETHBalance = address(this).balance;\n\n        swapTokensForEth(amountToSwapForETH);\n\n        uint256 ethBalance = address(this).balance.sub(initialETHBalance);\n\n        uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(\n            totalTokensToSwap\n        );\n        uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);\n\n        uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;\n\n        tokensForLiquidity = 0;\n        tokensForMarketing = 0;\n        tokensForDev = 0;\n\n        (success, ) = address(developmentWallet).call{value: ethForDev}(\"\");\n\n        if (liquidityTokens > 0 && ethForLiquidity > 0) {\n            addLiquidity(liquidityTokens, ethForLiquidity);\n            emit SwapAndLiquify(\n                amountToSwapForETH,\n                ethForLiquidity,\n                tokensForLiquidity\n            );\n        }\n\n        (success, ) = address(marketingWallet).call{\n            value: address(this).balance\n        }(\"\");\n    }\n\n\n        function manualswap() external {\n        require(\n            _msgSender() == developmentWallet ||\n                _msgSender() == marketingWallet\n        );\n        uint256 contractBalance = balanceOf(address(this));\n        swapTokensForEth(contractBalance);\n    }\n\n    function manualsend() external {\n        require(\n            _msgSender() == developmentWallet ||\n                _msgSender() == marketingWallet\n        );\n        bool success;\n        (success, ) = address(marketingWallet).call{\n            value: address(this).balance\n        }(\"\");\n    }\n\n    function setAutoLPBurnSettings(\n        uint256 _frequencyInSeconds,\n        uint256 _percent,\n        bool _Enabled\n    ) external onlyOwner {\n        require(\n            _frequencyInSeconds >= 600,\n            \"cannot set buyback more often than every 10 minutes\"\n        );\n        require(\n            _percent <= 1000 && _percent >= 0,\n            \"Must set auto LP burn percent between 0% and 10%\"\n        );\n        lpBurnFrequency = _frequencyInSeconds;\n        percentForLPBurn = _percent;\n        lpBurnEnabled = _Enabled;\n    }\n\n    function autoBurnLiquidityPairTokens() internal returns (bool) {\n        lastLpBurnTime = block.timestamp;\n\n        // get balance of liquidity pair\n        uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);\n\n        // calculate amount to burn\n        uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(\n            10000\n        );\n\n        // pull tokens from pancakePair liquidity and move to dead address permanently\n        if (amountToBurn > 0) {\n            super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);\n        }\n\n        //sync price since this is not in a swap transaction!\n        IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);\n        pair.sync();\n        emit AutoNukeLP();\n        return true;\n    }\n\n    function manualBurnLiquidityPairTokens(uint256 percent)\n        external\n        onlyOwner\n        returns (bool)\n    {\n        require(\n            block.timestamp > lastManualLpBurnTime + manualBurnFrequency,\n            \"Must wait for cooldown to finish\"\n        );\n        require(percent <= 1000, \"May not nuke more than 10% of tokens in LP\");\n        lastManualLpBurnTime = block.timestamp;\n\n        // get balance of liquidity pair\n        uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);\n\n        // calculate amount to burn\n        uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);\n\n        // pull tokens from pancakePair liquidity and move to dead address permanently\n        if (amountToBurn > 0) {\n            super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);\n        }\n\n        //sync price since this is not in a swap transaction!\n        IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);\n        pair.sync();\n        emit ManualNukeLP();\n        return true;\n    }\n}"
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