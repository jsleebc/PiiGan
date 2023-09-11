{{
  "language": "Solidity",
  "sources": {
    "contracts/BOCI.sol": {
      "content": "\n// SPDX-License-Identifier: MIT\n\n\n\n      \n       \n       // https://t.me/boci_official\n\n        // https://twitter.com/boci_ofc\n\n    \n\n\n\npragma solidity 0.8.17;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n        return msg.data;\n    }\n}\n\ninterface IERC20 {\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\n        unchecked {\n            _approve(sender, _msgSender(), currentAllowance - amount);\n        }\n\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        uint256 senderBalance = _balances[sender];\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[sender] = senderBalance - amount;\n        }\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n    }\n\n    function _createInitialSupply(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n    }\n\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n            // Overflow not possible: amount <= accountBalance <= totalSupply.\n            _totalSupply -= amount;\n        }\n\n        emit Transfer(account, address(0), amount);\n    }\n\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n}\n\ncontract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor () {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() external virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        emit OwnershipTransferred(_owner, newOwner);\n        _owner = newOwner;\n    }\n}\n\ninterface IDexRouter {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n\n    function addLiquidityETH(\n        address token,\n        uint256 amountTokenDesired,\n        uint256 amountTokenMin,\n        uint256 amountETHMin,\n        address to,\n        uint256 deadline\n    )\n        external\n        payable\n        returns (\n            uint256 amountToken,\n            uint256 amountETH,\n            uint256 liquidity\n        );\n}\n\ninterface IDexFactory {\n    function createPair(address tokenA, address tokenB)\n        external\n        returns (address pair);\n}\n\ncontract BOCI is ERC20, Ownable {\n\n    uint256 public maxBuyAmount;\n    uint256 public maxSellAmount;\n    uint256 public maxWalletAmount;\n\n    IDexRouter public dexRouter;\n    address public lpPair;\n\n    bool private swapping;\n    uint256 public swapTokensAtAmount;\n\n    address operationsAddress;\n    address otherAddress;\n\n    uint256 public tradingActiveBlock = 0; // 0 means trading is not active\n    uint256 public blockForPenaltyEnd;\n    mapping (address => bool) public boughtEarly;\n    uint256 public botsCaught;\n\n    bool public limitsInEffect = true;\n    bool public tradingActive = false;\n    bool public swapEnabled = false;\n\n     // Anti-bot and anti-whale mappings and variables\n    mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch\n    bool public transferDelayEnabled = true;\n\n    uint256 public buyTotalFees;\n    uint256 public buyOperationsFee;\n    uint256 public buyLiquidityFee;\n    uint256 public buyotherFee;\n    uint256 public buyBurnFee;\n\n    uint256 public sellTotalFees;\n    uint256 public sellOperationsFee;\n    uint256 public sellLiquidityFee;\n    uint256 public sellotherFee;\n    uint256 public sellBurnFee;\n\n    uint256 public tokensForOperations;\n    uint256 public tokensForLiquidity;\n    uint256 public tokensForother;\n    uint256 public tokensForBurn;\n\n    /******************/\n\n    // exlcude from fees and max transaction amount\n    mapping (address => bool) private _isExcludedFromFees;\n    mapping (address => bool) public _isExcludedMaxTransactionAmount;\n\n    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses\n    // could be subject to a maximum transfer amount\n    mapping (address => bool) public automatedMarketMakerPairs;\n\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\n\n    event EnabledTrading();\n\n    event RemovedLimits();\n\n    event ExcludeFromFees(address indexed account, bool isExcluded);\n\n    event UpdatedMaxBuyAmount(uint256 newAmount);\n\n    event UpdatedMaxSellAmount(uint256 newAmount);\n\n    event UpdatedMaxWalletAmount(uint256 newAmount);\n\n    event UpdatedOperationsAddress(address indexed newWallet);\n\n    event MaxTransactionExclusion(address _address, bool excluded);\n\n    event BuyBackTriggered(uint256 amount);\n\n    event OwnerForcedSwapBack(uint256 timestamp);\n\n    event CaughtEarlyBuyer(address sniper);\n\n    event SwapAndLiquify(\n        uint256 tokensSwapped,\n        uint256 ethReceived,\n        uint256 tokensIntoLiquidity\n    );\n\n    event TransferForeignToken(address token, uint256 amount);\n\n    constructor() ERC20(\"Chinese Bank\", \"BOCI\") {\n\n        address newOwner = msg.sender; // can leave alone if owner is deployer.\n\n        IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        dexRouter = _dexRouter;\n\n        // create pair\n        lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());\n        _excludeFromMaxTransaction(address(lpPair), true);\n        _setAutomatedMarketMakerPair(address(lpPair), true);\n\n        uint256 totalSupply = 1000000000 * 1e18;\n\n        maxBuyAmount = totalSupply * 1 / 100;\n        maxSellAmount = totalSupply * 1 / 100;\n        maxWalletAmount = totalSupply * 1 / 100;\n        swapTokensAtAmount = totalSupply * 1 / 10000;\n\n        buyOperationsFee = 18;\n        buyLiquidityFee = 0;\n        buyotherFee = 0;\n        buyBurnFee = 0;\n        buyTotalFees = buyOperationsFee + buyLiquidityFee + buyotherFee + buyBurnFee;\n\n        sellOperationsFee = 28;\n        sellLiquidityFee = 0;\n        sellotherFee = 0;\n        sellBurnFee = 0;\n        sellTotalFees = sellOperationsFee + sellLiquidityFee + sellotherFee + sellBurnFee;\n\n        _excludeFromMaxTransaction(newOwner, true);\n        _excludeFromMaxTransaction(address(this), true);\n        _excludeFromMaxTransaction(address(0xdead), true);\n\n        excludeFromFees(newOwner, true);\n        excludeFromFees(address(this), true);\n        excludeFromFees(address(0xdead), true);\n\n        operationsAddress = address(newOwner);\n        otherAddress = address(newOwner);\n\n        _createInitialSupply(newOwner, totalSupply);\n        transferOwnership(newOwner);\n    }\n\n    receive() external payable {}\n\n    // only enable if no plan to airdrop\n\n    function enableTrading(uint256 deadBlocks) external onlyOwner {\n        require(!tradingActive, \"Cannot reenable trading\");\n        tradingActive = true;\n        swapEnabled = true;\n        tradingActiveBlock = block.number;\n        blockForPenaltyEnd = tradingActiveBlock + deadBlocks;\n        emit EnabledTrading();\n    }\n\n    // remove limits after token is stable\n    function removeLimits() external onlyOwner {\n        limitsInEffect = false;\n        transferDelayEnabled = false;\n        emit RemovedLimits();\n    }\n\n    function manageBoughtEarly(address wallet, bool flag) external onlyOwner {\n        boughtEarly[wallet] = flag;\n    }\n\n    function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {\n        for(uint256 i = 0; i < wallets.length; i++){\n            boughtEarly[wallets[i]] = flag;\n        }\n    }\n\n    // disable Transfer delay - cannot be reenabled\n    function disableTransferDelay() external onlyOwner {\n        transferDelayEnabled = false;\n    }\n\n    function updateMaxBuyAmount(uint256 newNum) external onlyOwner {\n        require(newNum >= (totalSupply() * 2 / 1000)/1e18, \"Cannot set max buy amount lower than 0.2%\");\n        maxBuyAmount = newNum * (10**18);\n        emit UpdatedMaxBuyAmount(maxBuyAmount);\n    }\n\n    function updateMaxSellAmount(uint256 newNum) external onlyOwner {\n        require(newNum >= (totalSupply() * 2 / 1000)/1e18, \"Cannot set max sell amount lower than 0.2%\");\n        maxSellAmount = newNum * (10**18);\n        emit UpdatedMaxSellAmount(maxSellAmount);\n    }\n\n    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {\n        require(newNum >= (totalSupply() * 3 / 1000)/1e18, \"Cannot set max wallet amount lower than 0.3%\");\n        maxWalletAmount = newNum * (10**18);\n        emit UpdatedMaxWalletAmount(maxWalletAmount);\n    }\n\n    // change the minimum amount of tokens to sell from fees\n    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {\n  \t    require(newAmount >= totalSupply() * 1 / 100000, \"Swap amount cannot be lower than 0.001% total supply.\");\n  \t    require(newAmount <= totalSupply() * 1 / 1000, \"Swap amount cannot be higher than 0.1% total supply.\");\n  \t    swapTokensAtAmount = newAmount;\n  \t}\n\n    function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {\n        _isExcludedMaxTransactionAmount[updAds] = isExcluded;\n        emit MaxTransactionExclusion(updAds, isExcluded);\n    }\n\n    function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {\n        require(wallets.length == amountsInTokens.length, \"arrays must be the same length\");\n        require(wallets.length < 600, \"Can only airdrop 600 wallets per txn due to gas limits\"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.\n        for(uint256 i = 0; i < wallets.length; i++){\n            address wallet = wallets[i];\n            uint256 amount = amountsInTokens[i];\n            super._transfer(msg.sender, wallet, amount);\n        }\n    }\n\n    function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {\n        if(!isEx){\n            require(updAds != lpPair, \"Cannot remove uniswap pair from max txn\");\n        }\n        _isExcludedMaxTransactionAmount[updAds] = isEx;\n    }\n\n    function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {\n        require(pair != lpPair, \"The pair cannot be removed from automatedMarketMakerPairs\");\n\n        _setAutomatedMarketMakerPair(pair, value);\n        emit SetAutomatedMarketMakerPair(pair, value);\n    }\n\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\n        automatedMarketMakerPairs[pair] = value;\n\n        _excludeFromMaxTransaction(pair, value);\n\n        emit SetAutomatedMarketMakerPair(pair, value);\n    }\n\n    function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _otherFee, uint256 _burnFee) external onlyOwner {\n        buyOperationsFee = _operationsFee;\n        buyLiquidityFee = _liquidityFee;\n        buyotherFee = _otherFee;\n        buyBurnFee = _burnFee;\n        buyTotalFees = buyOperationsFee + buyLiquidityFee + buyotherFee + buyBurnFee;\n        require(buyTotalFees <= 15, \"Must keep fees at 15% or less\");\n    }\n\n    function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _otherFee, uint256 _burnFee) external onlyOwner {\n        sellOperationsFee = _operationsFee;\n        sellLiquidityFee = _liquidityFee;\n        sellotherFee = _otherFee;\n        sellBurnFee = _burnFee;\n        sellTotalFees = sellOperationsFee + sellLiquidityFee + sellotherFee + sellBurnFee;\n        require(sellTotalFees <= 30, \"Keep fees at 30% or less\");\n    }\n\n    function returnToNormalTax() external onlyOwner {\n        sellOperationsFee = 0;\n        sellLiquidityFee = 0;\n        sellotherFee = 0;\n        sellBurnFee = 0;\n        sellTotalFees = sellOperationsFee + sellLiquidityFee + sellotherFee + sellBurnFee;\n        require(sellTotalFees <= 30, \"Keep fees at 30% or less\");\n\n        buyOperationsFee = 0;\n        buyLiquidityFee = 0;\n        buyotherFee = 0;\n        buyBurnFee = 0;\n        buyTotalFees = buyOperationsFee + buyLiquidityFee + buyotherFee + buyBurnFee;\n        require(buyTotalFees <= 15, \"Keep fees at 15% or less\");\n    }\n\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\n        _isExcludedFromFees[account] = excluded;\n        emit ExcludeFromFees(account, excluded);\n    }\n\n    function _transfer(address from, address to, uint256 amount) internal override {\n\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        require(amount > 0, \"amount must be greater than 0\");\n\n        if(!tradingActive){\n            require(_isExcludedFromFees[from] || _isExcludedFromFees[to], \"Trading is not active.\");\n        }\n\n        if(blockForPenaltyEnd > 0){\n            require(!boughtEarly[from] || to == owner() || to == address(0xdead), \"Bots cannot transfer tokens in or out except to owner or dead address.\");\n        }\n\n        if(limitsInEffect){\n            if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){\n\n                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.\n                if (transferDelayEnabled){\n                    if (to != address(dexRouter) && to != address(lpPair)){\n                        require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, \"_transfer:: Transfer Delay enabled.  Try again later.\");\n                        _holderLastTransferTimestamp[tx.origin] = block.number;\n                        _holderLastTransferTimestamp[to] = block.number;\n                    }\n                }\n\n                //when buy\n                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {\n                        require(amount <= maxBuyAmount, \"Buy transfer amount exceeds the max buy.\");\n                        require(amount + balanceOf(to) <= maxWalletAmount, \"Cannot Exceed max wallet\");\n                }\n                //when sell\n                else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {\n                        require(amount <= maxSellAmount, \"Sell transfer amount exceeds the max sell.\");\n                }\n                else if (!_isExcludedMaxTransactionAmount[to]){\n                    require(amount + balanceOf(to) <= maxWalletAmount, \"Cannot Exceed max wallet\");\n                }\n            }\n        }\n\n        uint256 contractTokenBalance = balanceOf(address(this));\n\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\n\n        if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {\n            swapping = true;\n\n            swapBack();\n\n            swapping = false;\n        }\n\n        bool takeFee = true;\n        // if any account belongs to _isExcludedFromFee account then remove the fee\n        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\n            takeFee = false;\n        }\n\n        uint256 fees = 0;\n        // only take fees on buys/sells, do not take on wallet transfers\n        if(takeFee){\n            // bot/sniper penalty.\n            if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){\n\n                if(!boughtEarly[to]){\n                    boughtEarly[to] = true;\n                    botsCaught += 1;\n                    emit CaughtEarlyBuyer(to);\n                }\n\n                fees = amount * 99 / 100;\n        \t    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;\n                tokensForOperations += fees * buyOperationsFee / buyTotalFees;\n                tokensForother += fees * buyotherFee / buyTotalFees;\n                tokensForBurn += fees * buyBurnFee / buyTotalFees;\n            }\n\n            // on sell\n            else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){\n                fees = amount * sellTotalFees / 100;\n                tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;\n                tokensForOperations += fees * sellOperationsFee / sellTotalFees;\n                tokensForother += fees * sellotherFee / sellTotalFees;\n                tokensForBurn += fees * sellBurnFee / sellTotalFees;\n            }\n\n            // on buy\n            else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {\n        \t    fees = amount * buyTotalFees / 100;\n        \t    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;\n                tokensForOperations += fees * buyOperationsFee / buyTotalFees;\n                tokensForother += fees * buyotherFee / buyTotalFees;\n                tokensForBurn += fees * buyBurnFee / buyTotalFees;\n            }\n\n            if(fees > 0){\n                super._transfer(from, address(this), fees);\n            }\n\n        \tamount -= fees;\n        }\n\n        super._transfer(from, to, amount);\n    }\n\n    function earlyBuyPenaltyInEffect() public view returns (bool){\n        return block.number < blockForPenaltyEnd;\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private {\n\n        // generate the uniswap pair path of token -> weth\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = dexRouter.WETH();\n\n        _approve(address(this), address(dexRouter), tokenAmount);\n\n        // make the swap\n        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of ETH\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\n        // approve token transfer to cover all possible scenarios\n        _approve(address(this), address(dexRouter), tokenAmount);\n\n        // add the liquidity\n        dexRouter.addLiquidityETH{value: ethAmount}(\n            address(this),\n            tokenAmount,\n            0, // slippage is unavoidable\n            0, // slippage is unavoidable\n            address(operationsAddress),\n            block.timestamp\n        );\n    }\n\n    function swapBack() private {\n\n        if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {\n            _burn(address(this), tokensForBurn);\n        }\n        tokensForBurn = 0;\n\n        uint256 contractBalance = balanceOf(address(this));\n        uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForother;\n\n        if(contractBalance == 0 || totalTokensToSwap == 0) {return;}\n\n        if(contractBalance > swapTokensAtAmount * 20){\n            contractBalance = swapTokensAtAmount * 20;\n        }\n\n        bool success;\n\n        // Halve the amount of liquidity tokens\n        uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;\n\n        swapTokensForEth(contractBalance - liquidityTokens);\n\n        uint256 ethBalance = address(this).balance;\n        uint256 ethForLiquidity = ethBalance;\n\n        uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));\n        uint256 ethForother = ethBalance * tokensForother / (totalTokensToSwap - (tokensForLiquidity/2));\n\n        ethForLiquidity -= ethForOperations + ethForother;\n\n        tokensForLiquidity = 0;\n        tokensForOperations = 0;\n        tokensForother = 0;\n        tokensForBurn = 0;\n\n        if(liquidityTokens > 0 && ethForLiquidity > 0){\n            addLiquidity(liquidityTokens, ethForLiquidity);\n        }\n\n        (success,) = address(otherAddress).call{value: ethForother}(\"\");\n\n        (success,) = address(operationsAddress).call{value: address(this).balance}(\"\");\n    }\n\n    function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {\n        require(_token != address(0), \"_token address cannot be 0\");\n        require(_token != address(this), \"Can't withdraw native tokens\");\n        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));\n        _sent = IERC20(_token).transfer(_to, _contractBalance);\n        emit TransferForeignToken(_token, _contractBalance);\n    }\n\n    // withdraw ETH if stuck or someone sends to the address\n    function withdrawStuckETH() external onlyOwner {\n        bool success;\n        (success,) = address(msg.sender).call{value: address(this).balance}(\"\");\n    }\n\n    function setOperationsAddress(address _operationsAddress) external onlyOwner {\n        require(_operationsAddress != address(0), \"_operationsAddress address cannot be 0\");\n        operationsAddress = payable(_operationsAddress);\n    }\n\n    function setotherAddress(address _otherAddress) external onlyOwner {\n        require(_otherAddress != address(0), \"_otherAddress address cannot be 0\");\n        otherAddress = payable(_otherAddress);\n    }\n\n    // force Swap back if slippage issues.\n    function forceSwapBack() external onlyOwner {\n        require(balanceOf(address(this)) >= swapTokensAtAmount, \"Can only swap when token amount is at or higher than restriction\");\n        swapping = true;\n        swapBack();\n        swapping = false;\n        emit OwnerForcedSwapBack(block.timestamp);\n    }\n\n    // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.\n    function buyBackTokens(uint256 amountInWei) external onlyOwner {\n        require(amountInWei <= 10 ether, \"May not buy more than 10 ETH in a single buy to reduce sandwich attacks\");\n\n        address[] memory path = new address[](2);\n        path[0] = dexRouter.WETH();\n        path[1] = address(this);\n\n        // make the swap\n        dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(\n            0, // accept any amount of Ethereum\n            path,\n            address(0xdead),\n            block.timestamp\n        );\n        emit BuyBackTriggered(amountInWei);\n    }\n}"
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