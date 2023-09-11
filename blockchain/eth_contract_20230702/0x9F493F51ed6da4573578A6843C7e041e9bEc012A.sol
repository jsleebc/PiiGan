{{
  "language": "Solidity",
  "sources": {
    "contracts/BLOOM.sol": {
      "content": "/**\r\nBLOOMBLOCKDEFI: The First Decentralized News Plaftorm!\r\nOur automation process aggregates content from your\r\nfavorite news sources in one place!\r\n\r\n\r\nTelegram: https://t.me/BloomBlockDefi\r\nTwitter: https://twitter.com/BloomBlockDefi\r\nWebsite: https://bloomblockdefi.com/\r\nUtility: https://bloomblock.news/\r\n\r\n\r\ncontract by @HULKINUPORTAL\r\n*/\r\n\r\n\r\n// SPDX-License-Identifier: MIT                                                                              \r\n                                                   \r\npragma solidity 0.8.11;\r\n\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\r\n        return msg.data;\r\n    }\r\n}\r\n\r\n\r\ninterface IDexPair {\r\n    function sync() external;\r\n}\r\n\r\n\r\ninterface IERC20 {\r\n    /**\r\n     * @dev Returns the amount of tokens in existence.\r\n     */\r\n    function totalSupply() external view returns (uint256);\r\n\r\n\r\n    /**\r\n     * @dev Returns the amount of tokens owned by `account`.\r\n     */\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from the caller's account to `recipient`.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n\r\n    /**\r\n     * @dev Returns the remaining number of tokens that `spender` will be\r\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\r\n     * zero by default.\r\n     *\r\n     * This value changes when {approve} or {transferFrom} are called.\r\n     */\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n\r\n    /**\r\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\r\n     * that someone may use both the old and the new allowance by unfortunate\r\n     * transaction ordering. One possible solution to mitigate this race\r\n     * condition is to first reduce the spender's allowance to 0 and set the\r\n     * desired value afterwards:\r\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\r\n     *\r\n     * Emits an {Approval} event.\r\n     */\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\r\n     * allowance mechanism. `amount` is then deducted from the caller's\r\n     * allowance.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n\r\n    /**\r\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\r\n     * another (`to`).\r\n     *\r\n     * Note that `value` may be zero.\r\n     */\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n\r\n    /**\r\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\r\n     * a call to {approve}. `value` is the new allowance.\r\n     */\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\n\r\ninterface IERC20Metadata is IERC20 {\r\n    /**\r\n     * @dev Returns the name of the token.\r\n     */\r\n    function name() external view returns (string memory);\r\n\r\n\r\n    /**\r\n     * @dev Returns the symbol of the token.\r\n     */\r\n    function symbol() external view returns (string memory);\r\n\r\n\r\n    /**\r\n     * @dev Returns the decimals places of the token.\r\n     */\r\n    function decimals() external view returns (uint8);\r\n}\r\n\r\n\r\n\r\n\r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping(address => uint256) private _balances;\r\n\r\n\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n\r\n    uint256 private _totalSupply;\r\n\r\n\r\n    string public _name;\r\n    string public _symbol;\r\n\r\n\r\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n\r\n\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 18;\r\n    }\r\n\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n\r\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n\r\n\r\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\r\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\r\n        unchecked {\r\n            _approve(sender, _msgSender(), currentAllowance - amount);\r\n        }\r\n\r\n\r\n        return true;\r\n    }\r\n\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\r\n        return true;\r\n    }\r\n\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\r\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\r\n        unchecked {\r\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\r\n        }\r\n\r\n\r\n        return true;\r\n    }\r\n\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n\r\n        uint256 senderBalance = _balances[sender];\r\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\r\n        unchecked {\r\n            _balances[sender] = senderBalance - amount;\r\n        }\r\n        _balances[recipient] += amount;\r\n\r\n\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n\r\n    function _createInitialSupply(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n\r\n\r\n        _totalSupply += amount;\r\n        _balances[account] += amount;\r\n        emit Transfer(address(0), account, amount);\r\n    }\r\n\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n}\r\n\r\n\r\n\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n   \r\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n\r\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n\r\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n\r\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() external virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) external virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\n\r\ninterface IDexRouter {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n   \r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint256 amountTokenDesired,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    )\r\n        external\r\n        payable\r\n        returns (\r\n            uint256 amountToken,\r\n            uint256 amountETH,\r\n            uint256 liquidity\r\n        );\r\n       \r\n}\r\n\r\n\r\ninterface IDexFactory {\r\n    function createPair(address tokenA, address tokenB)\r\n        external\r\n        returns (address pair);\r\n}\r\n\r\n\r\ncontract BLOOMBLOCK is ERC20, Ownable {\r\n\r\n\r\n    IDexRouter public dexRouter;\r\n    address public lpPair;\r\n    address public constant deadAddress = address(0xdead);\r\n\r\n\r\n    bool private swapping;\r\n\r\n\r\n    address public marketingWallet;\r\n    address public cexWallet;\r\n    address public treasuryWallet;\r\n    address public rewardsWallet;\r\n    address public sustainabilityWallet;\r\n    address public devWallet;\r\n   \r\n   \r\n    uint256 private blockPenalty;\r\n\r\n\r\n    uint256 public tradingActiveBlock = 0; // 0 means trading is not active\r\n\r\n\r\n    uint256 public maxTxnAmount;\r\n    uint256 public swapTokensAtAmount;\r\n    uint256 public maxWallet;\r\n\r\n\r\n\r\n\r\n    uint256 public amountForAutoBuyBack = 0.2 ether;\r\n    bool public autoBuyBackEnabled = true;\r\n    uint256 public autoBuyBackFrequency = 3600 seconds;\r\n    uint256 public lastAutoBuyBackTime;\r\n   \r\n    uint256 public percentForLPBurn = 100; // 100 = 1%\r\n    bool public lpBurnEnabled = true;\r\n    uint256 public lpBurnFrequency = 3600 seconds;\r\n    uint256 public lastLpBurnTime;\r\n   \r\n    uint256 public manualBurnFrequency = 1 hours;\r\n    uint256 public lastManualLpBurnTime;\r\n\r\n\r\n    bool public limitsInEffect = true;\r\n    bool public tradingActive = false;\r\n    bool public swapEnabled = false;\r\n   \r\n     // Anti-bot and anti-whale mappings and variables\r\n    mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch\r\n    bool public transferDelayEnabled = true;\r\n\r\n\r\n    uint256 public buyTotalFees;\r\n    uint256 public buyMarketingFee;\r\n    uint256 public buyLiquidityFee;\r\n    uint256 public buyBuyBackFee;\r\n    uint256 public buyDevFee;\r\n   \r\n    uint256 public sellTotalFees;\r\n    uint256 public sellMarketingFee;\r\n    uint256 public sellLiquidityFee;\r\n    uint256 public sellBuyBackFee;\r\n    uint256 public sellDevFee;\r\n   \r\n    uint256 public tokensForMarketing;\r\n    uint256 public tokensForLiquidity;\r\n    uint256 public tokensForBuyBack;\r\n    uint256 public tokensForDev;\r\n   \r\n    /******************/\r\n\r\n\r\n    // exlcude from fees and max transaction amount\r\n    mapping (address => bool) private _isExcludedFromFees;\r\n    mapping (address => bool) public _isExcludedmaxTxnAmount;\r\n\r\n\r\n    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses\r\n    // could be subject to a maximum transfer amount\r\n    mapping (address => bool) public automatedMarketMakerPairs;\r\n\r\n\r\n    event ExcludeFromFees(address indexed account, bool isExcluded);\r\n\r\n\r\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\r\n\r\n\r\n    event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);\r\n\r\n\r\n    event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);\r\n\r\n\r\n    event SwapAndLiquify(\r\n        uint256 tokensSwapped,\r\n        uint256 ethReceived,\r\n        uint256 tokensIntoLiquidity\r\n    );\r\n   \r\n    event AutoNukeLP(uint256 amount);\r\n   \r\n    event ManualNukeLP(uint256 amount);\r\n   \r\n    event BuyBackTriggered(uint256 amount);\r\n\r\n\r\n    event OwnerForcedSwapBack(uint256 timestamp);\r\n\r\n\r\n    constructor() ERC20(\"BLOOMBLOCK\", \"BLOOM\") payable {\r\n               \r\n        uint256 _buyMarketingFee = 4;\r\n        uint256 _buyLiquidityFee = 1;\r\n        uint256 _buyBuyBackFee = 1;\r\n        uint256 _buyDevFee = 1;\r\n\r\n\r\n        uint256 _sellMarketingFee = 4;\r\n        uint256 _sellLiquidityFee = 1;\r\n        uint256 _sellBuyBackFee = 1;\r\n        uint256 _sellDevFee = 1;\r\n       \r\n        uint256 totalSupply = 10 * 1e12 * 1e18;\r\n       \r\n        maxTxnAmount = totalSupply * 5 / 100; // 5% of supply\r\n        maxWallet = totalSupply * 5 / 100; // 5% maxWallet\r\n        swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap amount\r\n\r\n\r\n        buyMarketingFee = _buyMarketingFee;\r\n        buyLiquidityFee = _buyLiquidityFee;\r\n        buyBuyBackFee = _buyBuyBackFee;\r\n        buyDevFee = _buyDevFee;\r\n        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;\r\n       \r\n        sellMarketingFee = _sellMarketingFee;\r\n        sellLiquidityFee = _sellLiquidityFee;\r\n        sellBuyBackFee = _sellBuyBackFee;\r\n        sellDevFee = _sellDevFee;\r\n        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;\r\n       \r\n        marketingWallet = address(0xf5090B95e6948b46215FB3a082F5D74c3ED32A45); // set as marketing wallet\r\n        devWallet = address(msg.sender);\r\n\r\n\r\n        // exclude from paying fees or having max transaction amount\r\n        excludeFromFees(owner(), true);\r\n        excludeFromFees(marketingWallet, true);\r\n        excludeFromFees(address(this), true);\r\n        excludeFromFees(address(0xdead), true);\r\n        excludeFromFees(0x7bB09c20d559bdc9E83535075d2c13719655C430, true); // future owner wallet\r\n       \r\n        excludeFromMaxTransaction(owner(), true);\r\n        excludeFromMaxTransaction(marketingWallet, true);\r\n        excludeFromMaxTransaction(marketingWallet, true);\r\n        excludeFromMaxTransaction(treasuryWallet, true);\r\n        excludeFromMaxTransaction(cexWallet, true);\r\n        excludeFromMaxTransaction(rewardsWallet, true);\r\n        excludeFromMaxTransaction(sustainabilityWallet, true);\r\n\r\n\r\n        excludeFromMaxTransaction(address(this), true);\r\n        excludeFromMaxTransaction(address(0xdead), true);\r\n        excludeFromMaxTransaction(0x7bB09c20d559bdc9E83535075d2c13719655C430, true);\r\n       \r\n        /*\r\n            _createInitialSupply is an internal function that is only called here,\r\n            and CANNOT be called ever again\r\n        */\r\n\r\n\r\n        _createInitialSupply(0x5Fe79B9c094b404231AD944C1C138c12F2e61EDE, totalSupply*10/100);\r\n        _createInitialSupply(0x94A81531687E5E9A2fa5ED8b7922901f9507C561, totalSupply*10/100);\r\n        _createInitialSupply(0xB4497BC41589dEc5bBACfe7d7D5136aA3448fAEd, totalSupply*5/100);\r\n        _createInitialSupply(0x48FdbBf7bfCB64D1aDf4E27179168eE920F1C834, totalSupply*5/100);\r\n        _createInitialSupply(address(this), totalSupply*70/100);\r\n    }\r\n\r\n\r\n    receive() external payable {\r\n\r\n\r\n   \r\n    }\r\n       mapping (address => bool) private _isBlackListedBot;\r\n    address[] private _blackListedBots;\r\n   \r\n   \r\n    // remove limits after token is stable\r\n    function removeLimits() external onlyOwner {\r\n        limitsInEffect = false;\r\n    }\r\n   \r\n    // disable Transfer delay - cannot be reenabled\r\n    function disableTransferDelay() external onlyOwner {\r\n        transferDelayEnabled = false;\r\n    }\r\n   \r\n     // change the minimum amount of tokens to sell from fees\r\n    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){\r\n        require(newAmount >= totalSupply() * 1 / 100000, \"Swap amount cannot be lower than 0.001% total supply.\");\r\n        require(newAmount <= totalSupply() * 5 / 1000, \"Swap amount cannot be higher than 0.5% total supply.\");\r\n        swapTokensAtAmount = newAmount;\r\n        return true;\r\n    }\r\n   \r\n    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {\r\n        require(newNum >= (totalSupply() * 5 / 1000)/1e18, \"Cannot set maxTxnAmount lower than 0.5%\");\r\n        maxTxnAmount = newNum * (10**18);\r\n    }\r\n\r\n\r\n    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {\r\n        require(newNum >= (totalSupply() * 1 / 100)/1e18, \"Cannot set maxWallet lower than 1%\");\r\n        maxWallet = newNum * (10**18);\r\n    }\r\n   \r\n    function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {\r\n        _isExcludedmaxTxnAmount[updAds] = isEx;\r\n    }\r\n   \r\n    // only use to disable contract sales if absolutely necessary (emergency use only)\r\n    function updateSwapEnabled(bool enabled) external onlyOwner(){\r\n        swapEnabled = enabled;\r\n    }\r\n   \r\n    function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {\r\n        buyMarketingFee = _marketingFee;\r\n        buyLiquidityFee = _liquidityFee;\r\n        buyBuyBackFee = _buyBackFee;\r\n        buyDevFee = _devFee;\r\n        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;\r\n        require(buyTotalFees <= 7, \"Must keep fees at 7% or less\");\r\n    }\r\n   \r\n    function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {\r\n        sellMarketingFee = _marketingFee;\r\n        sellLiquidityFee = _liquidityFee;\r\n        sellBuyBackFee = _buyBackFee;\r\n        sellDevFee = _devFee;\r\n        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;\r\n        require(sellTotalFees <= 18, \"Must keep fees at 18% or less\");\r\n    }\r\n\r\n\r\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\r\n        _isExcludedFromFees[account] = excluded;\r\n        emit ExcludeFromFees(account, excluded);\r\n    }\r\n\r\n\r\n    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {\r\n        require(pair != lpPair, \"The pair cannot be removed from automatedMarketMakerPairs\");\r\n\r\n\r\n        _setAutomatedMarketMakerPair(pair, value);\r\n    }\r\n\r\n\r\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\r\n        automatedMarketMakerPairs[pair] = value;\r\n\r\n\r\n        emit SetAutomatedMarketMakerPair(pair, value);\r\n    }\r\n\r\n\r\n    function updateMarketingWallet(address newMarketingWallet) external onlyOwner {\r\n        emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);\r\n        marketingWallet = newMarketingWallet;\r\n    }\r\n\r\n\r\n    function updateDevWallet(address newWallet) external onlyOwner {\r\n        emit DevWalletUpdated(newWallet, devWallet);\r\n        devWallet = newWallet;\r\n    }\r\n\r\n\r\n    function isExcludedFromFees(address account) public view returns(bool) {\r\n        return _isExcludedFromFees[account];\r\n    }\r\n\r\n\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal override {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(!_isBlackListedBot[to], \"You have no power here!\");\r\n      require(!_isBlackListedBot[tx.origin], \"You have no power here!\");\r\n\r\n\r\n         if(amount == 0) {\r\n            super._transfer(from, to, 0);\r\n            return;\r\n        }\r\n\r\n\r\n        if(!tradingActive){\r\n            require(_isExcludedFromFees[from] || _isExcludedFromFees[to], \"Trading is not active.\");\r\n        }\r\n       \r\n        if(limitsInEffect){\r\n            if (\r\n                from != owner() &&\r\n                to != owner() &&\r\n                to != address(0) &&\r\n                to != address(0xdead) &&\r\n                !swapping &&\r\n                !_isExcludedFromFees[to] &&\r\n                !_isExcludedFromFees[from]\r\n            ){\r\n               \r\n                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  \r\n                if (transferDelayEnabled){\r\n                    if (to != address(dexRouter) && to != address(lpPair)){\r\n                        require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, \"_transfer:: Transfer Delay enabled.  Try again later.\");\r\n                        _holderLastTransferBlock[tx.origin] = block.number;\r\n                        _holderLastTransferBlock[to] = block.number;\r\n                    }\r\n                }\r\n                 \r\n                //when buy\r\n                if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {\r\n                        require(amount <= maxTxnAmount, \"Buy transfer amount exceeds the maxTxnAmount.\");\r\n                        require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded\");\r\n                }\r\n               \r\n                //when sell\r\n                else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {\r\n                        require(amount <= maxTxnAmount, \"Sell transfer amount exceeds the maxTxnAmount.\");\r\n                }\r\n                else if (!_isExcludedmaxTxnAmount[to]){\r\n                    require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded\");\r\n                }\r\n            }\r\n        }\r\n       \r\n        uint256 contractTokenBalance = balanceOf(address(this));\r\n       \r\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\r\n\r\n\r\n        if(\r\n            canSwap &&\r\n            swapEnabled &&\r\n            !swapping &&\r\n            !automatedMarketMakerPairs[from] &&\r\n            !_isExcludedFromFees[from] &&\r\n            !_isExcludedFromFees[to]\r\n        ) {\r\n            swapping = true;\r\n           \r\n            swapBack();\r\n\r\n\r\n            swapping = false;\r\n        }\r\n       \r\n        if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){\r\n            autoBurnLiquidityPairTokens();\r\n        }\r\n       \r\n        if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){\r\n            autoBuyBack(amountForAutoBuyBack);\r\n        }\r\n\r\n\r\n        bool takeFee = !swapping;\r\n\r\n\r\n        // if any account belongs to _isExcludedFromFee account then remove the fee\r\n        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\r\n            takeFee = false;\r\n        }\r\n       \r\n        uint256 fees = 0;\r\n        // only take fees on buys/sells, do not take on wallet transfers\r\n        if(takeFee){\r\n            // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.\r\n            if(isPenaltyActive() && automatedMarketMakerPairs[from]){\r\n                fees = amount * 99 / 100;\r\n                tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;\r\n                tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;\r\n                tokensForMarketing += fees * sellMarketingFee / sellTotalFees;\r\n                tokensForDev += fees * sellDevFee / sellTotalFees;\r\n            }\r\n            // on sell\r\n            else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){\r\n                fees = amount * sellTotalFees / 100;\r\n                tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;\r\n                tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;\r\n                tokensForMarketing += fees * sellMarketingFee / sellTotalFees;\r\n                tokensForDev += fees * sellDevFee / sellTotalFees;\r\n            }\r\n            // on buy\r\n            else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {\r\n                fees = amount * buyTotalFees / 100;\r\n                tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;\r\n                tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;\r\n                tokensForMarketing += fees * buyMarketingFee / buyTotalFees;\r\n                tokensForDev += fees * buyDevFee / buyTotalFees;\r\n            }\r\n           \r\n            if(fees > 0){    \r\n                super._transfer(from, address(this), fees);\r\n            }\r\n           \r\n            amount -= fees;\r\n        }\r\n\r\n\r\n        super._transfer(from, to, amount);\r\n    }\r\n\r\n\r\n    function swapTokensForEth(uint256 tokenAmount) private {\r\n\r\n\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = dexRouter.WETH();\r\n\r\n\r\n        _approve(address(this), address(dexRouter), tokenAmount);\r\n\r\n\r\n        // make the swap\r\n        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0, // accept any amount of ETH\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n   \r\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\r\n        // approve token transfer to cover all possible scenarios\r\n        _approve(address(this), address(dexRouter), tokenAmount);\r\n\r\n\r\n        // add the liquidity\r\n        dexRouter.addLiquidityETH{value: ethAmount}(\r\n            address(this),\r\n            tokenAmount,\r\n            0, // slippage is unavoidable\r\n            0, // slippage is unavoidable\r\n            deadAddress,\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n\r\n    function swapBack() private {\r\n        uint256 contractBalance = balanceOf(address(this));\r\n        uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;\r\n        bool success;\r\n       \r\n        if(contractBalance == 0 || totalTokensToSwap == 0) {return;}\r\n\r\n\r\n        if(contractBalance > swapTokensAtAmount * 20){\r\n            contractBalance = swapTokensAtAmount * 20;\r\n        }\r\n       \r\n        // Halve the amount of liquidity tokens\r\n        uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;\r\n        uint256 amountToSwapForETH = contractBalance - liquidityTokens;\r\n       \r\n        uint256 initialETHBalance = address(this).balance;\r\n\r\n\r\n        swapTokensForEth(amountToSwapForETH);\r\n       \r\n        uint256 ethBalance = address(this).balance - initialETHBalance;\r\n       \r\n        uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));\r\n        uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));\r\n        uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));\r\n       \r\n        uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;\r\n       \r\n       \r\n        tokensForLiquidity = 0;\r\n        tokensForMarketing = 0;\r\n        tokensForBuyBack = 0;\r\n        tokensForDev = 0;\r\n\r\n\r\n       \r\n        (success,) = address(devWallet).call{value: ethForDev}(\"\");\r\n        (success,) = address(marketingWallet).call{value: ethForMarketing}(\"\");\r\n       \r\n        if(liquidityTokens > 0 && ethForLiquidity > 0){\r\n            addLiquidity(liquidityTokens, ethForLiquidity);\r\n            emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);\r\n        }\r\n       \r\n        // keep leftover ETH for buyback\r\n       \r\n    }\r\n\r\n\r\n    // force Swap back if slippage issues.\r\n    function forceSwapBack() external onlyOwner {\r\n        require(balanceOf(address(this)) >= swapTokensAtAmount, \"Can only swap when token amount is at or higher than restriction\");\r\n        swapping = true;\r\n        swapBack();\r\n        swapping = false;\r\n        emit OwnerForcedSwapBack(block.timestamp);\r\n    }\r\n   \r\n    // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.\r\n    function buyBackTokens(uint256 amountInWei) external onlyOwner {\r\n        require(amountInWei <= 10 ether, \"May not buy more than 10 ETH in a single buy to reduce sandwich attacks\");\r\n\r\n\r\n        address[] memory path = new address[](2);\r\n        path[0] = dexRouter.WETH();\r\n        path[1] = address(this);\r\n\r\n\r\n        // make the swap\r\n        dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(\r\n            0, // accept any amount of Ethereum\r\n            path,\r\n            address(0xdead),\r\n            block.timestamp\r\n        );\r\n        emit BuyBackTriggered(amountInWei);\r\n    }\r\n\r\n\r\n    function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {\r\n        require(_frequencyInSeconds >= 30, \"cannot set buyback more often than every 30 seconds\");\r\n        require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, \"Must set auto buyback amount between .05 and 2 ETH\");\r\n        autoBuyBackFrequency = _frequencyInSeconds;\r\n        amountForAutoBuyBack = _buyBackAmount;\r\n        autoBuyBackEnabled = _autoBuyBackEnabled;\r\n    }\r\n   \r\n    function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {\r\n        require(_frequencyInSeconds >= 600, \"cannot set buyback more often than every 10 minutes\");\r\n        require(_percent <= 1000 && _percent >= 0, \"Must set auto LP burn percent between 1% and 10%\");\r\n        lpBurnFrequency = _frequencyInSeconds;\r\n        percentForLPBurn = _percent;\r\n        lpBurnEnabled = _Enabled;\r\n    }\r\n   \r\n    // automated buyback\r\n    function autoBuyBack(uint256 amountInWei) internal {\r\n       \r\n        lastAutoBuyBackTime = block.timestamp;\r\n       \r\n        address[] memory path = new address[](2);\r\n        path[0] = dexRouter.WETH();\r\n        path[1] = address(this);\r\n\r\n\r\n        // make the swap\r\n        dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(\r\n            0, // accept any amount of Ethereum\r\n            path,\r\n            address(0xdead),\r\n            block.timestamp\r\n        );\r\n       \r\n        emit BuyBackTriggered(amountInWei);\r\n    }\r\n\r\n\r\n    function isPenaltyActive() public view returns (bool) {\r\n        return tradingActiveBlock >= block.number - blockPenalty;\r\n    }\r\n   \r\n    function autoBurnLiquidityPairTokens() internal{\r\n       \r\n        lastLpBurnTime = block.timestamp;\r\n       \r\n        // get balance of liquidity pair\r\n        uint256 liquidityPairBalance = this.balanceOf(lpPair);\r\n       \r\n        // calculate amount to burn\r\n        uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;\r\n       \r\n        if (amountToBurn > 0){\r\n            super._transfer(lpPair, address(0xdead), amountToBurn);\r\n        }\r\n       \r\n        //sync price since this is not in a swap transaction!\r\n        IDexPair pair = IDexPair(lpPair);\r\n        pair.sync();\r\n        emit AutoNukeLP(amountToBurn);\r\n    }\r\n\r\n\r\n    function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {\r\n        require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , \"Must wait for cooldown to finish\");\r\n        require(percent <= 1000, \"May not nuke more than 10% of tokens in LP\");\r\n        lastManualLpBurnTime = block.timestamp;\r\n       \r\n        // get balance of liquidity pair\r\n        uint256 liquidityPairBalance = this.balanceOf(lpPair);\r\n       \r\n        // calculate amount to burn\r\n        uint256 amountToBurn = liquidityPairBalance * percent / 10000;\r\n       \r\n        if (amountToBurn > 0){\r\n            super._transfer(lpPair, address(0xdead), amountToBurn);\r\n        }\r\n       \r\n        //sync price since this is not in a swap transaction!\r\n        IDexPair pair = IDexPair(lpPair);\r\n        pair.sync();\r\n        emit ManualNukeLP(amountToBurn);\r\n    }\r\n\r\n\r\n    function launch(uint256 _blockPenalty) external onlyOwner {\r\n        require(!tradingActive, \"Trading is already active, cannot relaunch.\");\r\n\r\n\r\n        blockPenalty = _blockPenalty;\r\n\r\n\r\n        //update name/ticker\r\n        _name = \"BLOOMBLOCK\";\r\n        _symbol = \"BLOOM\";\r\n\r\n\r\n        //standard enable trading\r\n        tradingActive = true;\r\n        swapEnabled = true;\r\n        tradingActiveBlock = block.number;\r\n        lastLpBurnTime = block.timestamp;\r\n\r\n\r\n        // initialize router\r\n        IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        dexRouter = _dexRouter;\r\n\r\n\r\n        // create pair\r\n        lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());\r\n        excludeFromMaxTransaction(address(lpPair), true);\r\n        _setAutomatedMarketMakerPair(address(lpPair), true);\r\n   \r\n        // add the liquidity\r\n        require(address(this).balance > 0, \"Must have ETH on contract to launch\");\r\n        require(balanceOf(address(this)) > 0, \"Must have Tokens on contract to launch\");\r\n        _approve(address(this), address(dexRouter), balanceOf(address(this)));\r\n        dexRouter.addLiquidityETH{value: address(this).balance}(\r\n            address(this),\r\n            balanceOf(address(this)),\r\n            0, // slippage is unavoidable\r\n            0, // slippage is unavoidable\r\n            0x7bB09c20d559bdc9E83535075d2c13719655C430,\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n\r\n    // withdraw ETH if stuck before launch\r\n    function withdrawStuckETH() external onlyOwner {\r\n        require(!tradingActive, \"Can only withdraw if trading hasn't started\");\r\n        bool success;\r\n        (success,) = address(msg.sender).call{value: address(this).balance}(\"\");\r\n    }\r\n}"
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