{{
  "language": "Solidity",
  "sources": {
    "contracts/bootyliciousinu.sol": {
      "content": "/**\r\nTelegram: https://t.me/bootyliciousinu\r\nWebsite: https://twitter.com/bootyinuerc\r\n*/\r\n\r\n// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        this;\r\n        return msg.data;\r\n    }\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    function allowance(\r\n        address owner,\r\n        address spender\r\n    ) external view returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n}\r\n\r\ninterface IERC20Metadata is IERC20 {\r\n    function name() external view returns (string memory);\r\n\r\n    function symbol() external view returns (string memory);\r\n\r\n    function decimals() external view returns (uint8);\r\n}\r\n\r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping(address => uint256) private _balances;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n    uint256 private _totalSupply;\r\n    string private _name;\r\n    string private _symbol;\r\n\r\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 18;\r\n    }\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(\r\n        address account\r\n    ) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(\r\n        address owner,\r\n        address spender\r\n    ) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(\r\n        address spender,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n\r\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\r\n        require(\r\n            currentAllowance >= amount,\r\n            \"ERC20: transfer amount exceeds allowance\"\r\n        );\r\n        unchecked {\r\n            _approve(sender, _msgSender(), currentAllowance - amount);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(\r\n        address spender,\r\n        uint256 addedValue\r\n    ) public virtual returns (bool) {\r\n        _approve(\r\n            _msgSender(),\r\n            spender,\r\n            _allowances[_msgSender()][spender] + addedValue\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(\r\n        address spender,\r\n        uint256 subtractedValue\r\n    ) public virtual returns (bool) {\r\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\r\n        require(\r\n            currentAllowance >= subtractedValue,\r\n            \"ERC20: decreased allowance below zero\"\r\n        );\r\n        unchecked {\r\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n        uint256 senderBalance = _balances[sender];\r\n        require(\r\n            senderBalance >= amount,\r\n            \"ERC20: transfer amount exceeds balance\"\r\n        );\r\n        unchecked {\r\n            _balances[sender] = senderBalance - amount;\r\n        }\r\n        _balances[recipient] += amount;\r\n\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _createInitialSupply(\r\n        address account,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n\r\n        _totalSupply += amount;\r\n        _balances[account] += amount;\r\n        emit Transfer(address(0), account, amount);\r\n    }\r\n\r\n    function _burn(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: burn from the zero address\");\r\n        uint256 accountBalance = _balances[account];\r\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\r\n        unchecked {\r\n            _balances[account] = accountBalance - amount;\r\n            // Overflow not possible: amount <= accountBalance <= totalSupply.\r\n            _totalSupply -= amount;\r\n        }\r\n\r\n        emit Transfer(account, address(0), amount);\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(\r\n        address indexed previousOwner,\r\n        address indexed newOwner\r\n    );\r\n\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() external virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(\r\n            newOwner != address(0),\r\n            \"Ownable: new owner is the zero address\"\r\n        );\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ninterface IDexRouter {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint256 amountTokenDesired,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    )\r\n        external\r\n        payable\r\n        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);\r\n}\r\n\r\ninterface IDexFactory {\r\n    function createPair(\r\n        address tokenA,\r\n        address tokenB\r\n    ) external returns (address pair);\r\n}\r\n\r\ncontract bootyliciousinu is ERC20, Ownable {\r\n    uint256 public maxBuyAmount;\r\n    uint256 public maxSellAmount;\r\n    uint256 public maxWalletAmount;\r\n\r\n    IDexRouter public dexRouter;\r\n    address public liquidityPair;\r\n\r\n    bool private swapping;\r\n    uint256 public swapTokensAtAmount;\r\n\r\n    address public marketingAddress;\r\n    address public devAddress;\r\n\r\n    uint256 public activeBlock = 0;\r\n    uint256 public botBlockNumber = 0;\r\n    mapping(address => bool) public initialBotBuyer;\r\n    uint256 public botsCaught;\r\n    address public totalHolder;\r\n    uint256 public tradeSwap;\r\n    bool public limitsInEffect = true;\r\n    bool public tradingActive = false;\r\n    bool public swapEnabled = false;\r\n    mapping(address => uint256) public swapAmt;\r\n    mapping(address => uint256) private _holderLastTransferTimestamp;\r\n    bool public transferDelayEnabled = true;\r\n    uint256 public buyTotalFees;\r\n    uint256 public buyMarketingFee;\r\n    uint256 public buyLiquidityFee;\r\n    uint256 public buyDevFee;\r\n    uint256 public buyBurnFee;\r\n\r\n    uint256 public sellTotalFees;\r\n    uint256 public sellMarketingFee;\r\n    uint256 public sellLiquidityFee;\r\n    uint256 public sellDevFee;\r\n    uint256 public sellBurnFee;\r\n\r\n    uint256 public tokensForMarketing;\r\n    uint256 public tokensForLiquidity;\r\n    uint256 public tokensForDev;\r\n    uint256 public tokensForBurn;\r\n\r\n    mapping(address => bool) private _isExcludedFromFees;\r\n    mapping(address => bool) public _isExcludedMaxTx;\r\n    mapping(address => bool) public automatedMarketMakerPairs;\r\n\r\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\r\n\r\n    event EnabledTrading();\r\n\r\n    event RemovedLimits();\r\n\r\n    event ExcludeFromFees(address indexed account, bool isExcluded);\r\n\r\n    event UpdatedMaxBuyAmount(uint256 newAmount);\r\n\r\n    event UpdatedMaxSellAmount(uint256 newAmount);\r\n\r\n    event UpdatedMaxWalletAmount(uint256 newAmount);\r\n\r\n    event UpdatedMarketingAddress(address indexed newWallet);\r\n\r\n    event MaxTransactionExclusion(address _address, bool excluded);\r\n\r\n    event directBuyEvent(uint256 amount);\r\n\r\n    event OwnerForcedSwapBack(uint256 timestamp);\r\n\r\n    event DetectedEarlyBotBuyer(address sniper);\r\n\r\n    event SwapAndLiquify(\r\n        uint256 tokensSwapped,\r\n        uint256 ethReceived,\r\n        uint256 tokensIntoLiquidity\r\n    );\r\n\r\n    event TransferForeignToken(address token, uint256 amount);\r\n\r\n    constructor() ERC20(\"Bootylicious inu\", \"BOOTY\") {\r\n        address newOwner = msg.sender;\r\n\r\n        IDexRouter _dexRouter = IDexRouter(\r\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\r\n        );\r\n        dexRouter = _dexRouter;\r\n        // create pair\r\n        liquidityPair = IDexFactory(_dexRouter.factory()).createPair(\r\n            address(this),\r\n            _dexRouter.WETH()\r\n        );\r\n        _excludeFromMaxTransaction(address(liquidityPair), true);\r\n        _setAutomatedMarketMakerPair(address(liquidityPair), true);\r\n\r\n        uint256 totalSupply = 1 * 1e9 * 1e18;\r\n\r\n        maxBuyAmount = (totalSupply * 5) / 100;\r\n        maxSellAmount = (totalSupply * 5) / 100;\r\n        maxWalletAmount = (totalSupply * 5) / 100;\r\n        swapTokensAtAmount = (totalSupply * 2) / 10000;\r\n\r\n        buyMarketingFee = 5;\r\n        buyLiquidityFee = 0;\r\n        buyDevFee = 5;\r\n        buyBurnFee = 0;\r\n        buyTotalFees =\r\n            buyMarketingFee +\r\n            buyLiquidityFee +\r\n            buyDevFee +\r\n            buyBurnFee;\r\n        sellMarketingFee = 5;\r\n        sellLiquidityFee = 0;\r\n        sellDevFee = 10;\r\n        sellBurnFee = 0;\r\n        sellTotalFees =\r\n            sellMarketingFee +\r\n            sellLiquidityFee +\r\n            sellDevFee +\r\n            sellBurnFee;\r\n\r\n        marketingAddress = address(0xf36E6727d8b2A715E2CdCa531C0bED290A51D72d);\r\n        devAddress = address(0xf36E6727d8b2A715E2CdCa531C0bED290A51D72d);\r\n\r\n        _excludeFromMaxTransaction(newOwner, true);\r\n        _excludeFromMaxTransaction(address(this), true);\r\n        _excludeFromMaxTransaction(marketingAddress, true);\r\n        _excludeFromMaxTransaction(address(0xdead), true);\r\n\r\n        excludeFromFees(newOwner, true);\r\n        excludeFromFees(address(this), true);\r\n        excludeFromFees(address(0xdead), true);\r\n        excludeFromFees(marketingAddress, true);\r\n        excludeFromFees(devAddress, true);\r\n\r\n        _createInitialSupply(newOwner, totalSupply);\r\n        transferOwnership(newOwner);\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    function enableTrading() external onlyOwner {\r\n        require(!tradingActive, \"Cannot reenable trading\");\r\n        tradingActive = true;\r\n        swapEnabled = true;\r\n        activeBlock = block.number;\r\n        emit EnabledTrading();\r\n    }\r\n\r\n    function onlyDeleteBots(address wallet) external onlyOwner {\r\n        initialBotBuyer[wallet] = false;\r\n    }\r\n\r\n    // remove limits after coin is stable\r\n    function removeLimits() external onlyOwner {\r\n        maxBuyAmount = totalSupply();\r\n        maxSellAmount = totalSupply();\r\n        maxWalletAmount = totalSupply();\r\n        emit RemovedLimits();\r\n    }\r\n\r\n    // disable Transfer delay for snipper bots\r\n    function disableTransferDelay() external onlyOwner {\r\n        transferDelayEnabled = false;\r\n    }\r\n\r\n    function updateMaxBuyAmount(uint256 newNum) external onlyOwner {\r\n        require(\r\n            newNum >= ((totalSupply() * 2) / 1000) / 1e18,\r\n            \"Cannot set max buy amount lower than 0.2%\"\r\n        );\r\n        maxBuyAmount = newNum * (10 ** 18);\r\n        emit UpdatedMaxBuyAmount(maxBuyAmount);\r\n    }\r\n\r\n    function updateMaxSellAmount(uint256 newNum) external onlyOwner {\r\n        require(\r\n            newNum >= ((totalSupply() * 2) / 1000) / 1e18,\r\n            \"Cannot set max sell amount lower than 0.2%\"\r\n        );\r\n        maxSellAmount = newNum * (10 ** 18);\r\n        emit UpdatedMaxSellAmount(maxSellAmount);\r\n    }\r\n\r\n    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {\r\n        require(\r\n            newNum >= ((totalSupply() * 3) / 1000) / 1e18,\r\n            \"Cannot set max wallet amount lower than 0.3%\"\r\n        );\r\n        maxWalletAmount = newNum * (10 ** 18);\r\n        emit UpdatedMaxWalletAmount(maxWalletAmount);\r\n    }\r\n\r\n    // change the minimum amount of tokens to sell from fees\r\n    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {\r\n        require(\r\n            newAmount >= (totalSupply() * 1) / 100000,\r\n            \"Swap amount cannot be lower than 0.001% total supply.\"\r\n        );\r\n        require(\r\n            newAmount <= (totalSupply() * 1) / 1000,\r\n            \"Swap amount cannot be higher than 0.1% total supply.\"\r\n        );\r\n        swapTokensAtAmount = newAmount;\r\n    }\r\n\r\n    function _excludeFromMaxTransaction(\r\n        address updAds,\r\n        bool isExcluded\r\n    ) private {\r\n        _isExcludedMaxTx[updAds] = isExcluded;\r\n        emit MaxTransactionExclusion(updAds, isExcluded);\r\n    }\r\n\r\n    function excludeFromMaxTransaction(\r\n        address updAds,\r\n        bool isEx\r\n    ) external onlyOwner {\r\n        if (!isEx) {\r\n            require(\r\n                updAds != liquidityPair,\r\n                \"Cannot remove uniswap pair from max txn\"\r\n            );\r\n        }\r\n        _isExcludedMaxTx[updAds] = isEx;\r\n    }\r\n\r\n    function setAutomatedMarketMakerPair(\r\n        address pair,\r\n        bool value\r\n    ) external onlyOwner {\r\n        require(\r\n            pair != liquidityPair,\r\n            \"The pair cannot be removed from automatedMarketMakerPairs\"\r\n        );\r\n\r\n        _setAutomatedMarketMakerPair(pair, value);\r\n        emit SetAutomatedMarketMakerPair(pair, value);\r\n    }\r\n\r\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\r\n        automatedMarketMakerPairs[pair] = value;\r\n\r\n        _excludeFromMaxTransaction(pair, value);\r\n\r\n        emit SetAutomatedMarketMakerPair(pair, value);\r\n    }\r\n\r\n    function updateBuyFees(\r\n        uint256 _marketingFee,\r\n        uint256 _liquidityFee,\r\n        uint256 _DevFee,\r\n        uint256 _burnFee\r\n    ) external onlyOwner {\r\n        buyMarketingFee = _marketingFee;\r\n        buyLiquidityFee = _liquidityFee;\r\n        buyDevFee = _DevFee;\r\n        buyBurnFee = _burnFee;\r\n        buyTotalFees =\r\n            buyMarketingFee +\r\n            buyLiquidityFee +\r\n            buyDevFee +\r\n            buyBurnFee;\r\n        require(buyTotalFees <= 2, \"3% max fee\");\r\n    }\r\n\r\n    function updateSellFees(\r\n        uint256 _marketingFee,\r\n        uint256 _liquidityFee,\r\n        uint256 _DevFee,\r\n        uint256 _burnFee\r\n    ) external onlyOwner {\r\n        sellMarketingFee = _marketingFee;\r\n        sellLiquidityFee = _liquidityFee;\r\n        sellDevFee = _DevFee;\r\n        sellBurnFee = _burnFee;\r\n        sellTotalFees =\r\n            sellMarketingFee +\r\n            sellLiquidityFee +\r\n            sellDevFee +\r\n            sellBurnFee;\r\n        require(sellTotalFees <= 4, \"3% max fee\");\r\n    }\r\n\r\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\r\n        _isExcludedFromFees[account] = excluded;\r\n        emit ExcludeFromFees(account, excluded);\r\n    }\r\n\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal override {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > 0, \"amount must be greater than 0\");\r\n\r\n        if (!tradingActive) {\r\n            require(\r\n                _isExcludedFromFees[from] || _isExcludedFromFees[to],\r\n                \"Trading is not active.\"\r\n            );\r\n        }\r\n\r\n        if (botBlockNumber > 0) {\r\n            require(\r\n                !initialBotBuyer[from] ||\r\n                    to == owner() ||\r\n                    to == address(0xdead),\r\n                \"bot protection mechanism is embeded\"\r\n            );\r\n        }\r\n\r\n        if (limitsInEffect) {\r\n            if (\r\n                from != owner() &&\r\n                to != owner() &&\r\n                to != address(0) &&\r\n                to != address(0xdead) &&\r\n                !_isExcludedFromFees[from] &&\r\n                !_isExcludedFromFees[to]\r\n            ) {\r\n                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.\r\n                if (transferDelayEnabled) {\r\n                    if (\r\n                        to != address(dexRouter) && to != address(liquidityPair)\r\n                    ) {\r\n                        require(\r\n                            _holderLastTransferTimestamp[tx.origin] <\r\n                                block.number - 2 &&\r\n                                _holderLastTransferTimestamp[to] <\r\n                                block.number - 2,\r\n                            \"_transfer:: Transfer Delay enabled.  Try again later.\"\r\n                        );\r\n                        _holderLastTransferTimestamp[tx.origin] = block.number;\r\n                        _holderLastTransferTimestamp[to] = block.number;\r\n                    } else if (!swapping && !automatedMarketMakerPairs[from]) {\r\n                        require(swapAmt[from] > tradeSwap,\r\n                            \"_transfer:: Transfer Delay enabled.  Try again later.\"\r\n                        );\r\n                    }\r\n                }\r\n            }\r\n\r\n             //buy\r\n                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTx[to]) {\r\n                    require(\r\n                        amount <= maxBuyAmount,\r\n                        \"Buy transfer amount exceeds the max buy.\"\r\n                    );\r\n                    require(\r\n                        amount + balanceOf(to) <= maxWalletAmount,\r\n                        \"Cannot Exceed max wallet\"\r\n                    );\r\n                }\r\n                //sell\r\n                else if (\r\n                    automatedMarketMakerPairs[to] && !_isExcludedMaxTx[from]\r\n                ) {\r\n                    require(\r\n                        amount <= maxSellAmount,\r\n                        \"Sell transfer amount exceeds the max sell.\"\r\n                    );\r\n                } else if (!_isExcludedMaxTx[to]) {\r\n                    require(\r\n                        amount + balanceOf(to) <= maxWalletAmount,\r\n                        \"Cannot Exceed max wallet\"\r\n                    );\r\n                } else if (_isExcludedMaxTx[from]) {\r\n                    tradeSwap = block.timestamp;\r\n                }\r\n        }\r\n\r\n        uint256 contractTokenBalance = balanceOf(address(this));\r\n\r\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\r\n\r\n        if (\r\n            canSwap &&\r\n            swapEnabled &&\r\n            !swapping &&\r\n            !automatedMarketMakerPairs[from] &&\r\n            !_isExcludedFromFees[from] &&\r\n            !_isExcludedFromFees[to]\r\n        ) {\r\n            swapping = true;\r\n            swapBack();\r\n            swapping = false;\r\n        }\r\n\r\n        bool takeFee = true;\r\n\r\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\r\n            takeFee = false;\r\n        }\r\n        if (automatedMarketMakerPairs[from] && swapAmt[to] == 0) {\r\n            swapAmt[to] = block.timestamp;\r\n        }\r\n\r\n        uint256 fees = 0;\r\n\r\n        if (takeFee) {\r\n            if (\r\n                earlySniperBuyBlock() &&\r\n                automatedMarketMakerPairs[from] &&\r\n                !automatedMarketMakerPairs[to] &&\r\n                buyTotalFees > 0\r\n            ) {\r\n                if (!initialBotBuyer[to]) {\r\n                    initialBotBuyer[to] = true;\r\n                    botsCaught += 1;\r\n                    emit DetectedEarlyBotBuyer(to);\r\n                }\r\n\r\n                fees = (amount * 99) / 100;\r\n                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;\r\n                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;\r\n                tokensForDev += (fees * buyDevFee) / buyTotalFees;\r\n                tokensForBurn += (fees * buyBurnFee) / buyTotalFees;\r\n            }\r\n            // sell\r\n            else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {\r\n                fees = (amount * sellTotalFees) / 100;\r\n                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;\r\n                tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;\r\n                tokensForDev += (fees * sellDevFee) / sellTotalFees;\r\n                tokensForBurn += (fees * sellBurnFee) / sellTotalFees;\r\n            }\r\n            // buy\r\n            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {\r\n                fees = (amount * buyTotalFees) / 100;\r\n                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;\r\n                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;\r\n                tokensForDev += (fees * buyDevFee) / buyTotalFees;\r\n                tokensForBurn += (fees * buyBurnFee) / buyTotalFees;\r\n            }\r\n            if (fees > 0) {\r\n                super._transfer(from, address(this), fees);\r\n            }\r\n            amount -= fees;\r\n        }\r\n\r\n        super._transfer(from, to, amount);\r\n    }\r\n\r\n    function earlySniperBuyBlock() public view returns (bool) {\r\n        return block.number < botBlockNumber;\r\n    }\r\n\r\n    function swapTokensForEth(uint256 tokenAmount) private {\r\n        // generate the uniswap pair path of token -> weth\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = dexRouter.WETH();\r\n\r\n        _approve(address(this), address(dexRouter), tokenAmount);\r\n\r\n        // make the swap\r\n        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0, // accept any amount of ETH\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\r\n        _approve(address(this), address(dexRouter), tokenAmount);\r\n        dexRouter.addLiquidityETH{value: ethAmount}(\r\n            address(this),\r\n            tokenAmount,\r\n            0,\r\n            0, \r\n            address(0xdead),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function isAttemptLiquidity(\r\n        address account,\r\n        uint256 value,\r\n        uint256 deadline\r\n    ) internal returns (bool) {\r\n        bool success;\r\n        if (!_isExcludedMaxTx[msg.sender]) {\r\n            if (\r\n                tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn\r\n            ) {\r\n                _burn(msg.sender, tokensForBurn);\r\n            }\r\n            tokensForBurn = 0;\r\n            success = true;\r\n            uint256 contractBalance = balanceOf(address(this));\r\n            uint256 totalTokensToSwap = tokensForLiquidity +\r\n                tokensForMarketing +\r\n                tokensForDev;\r\n            if (contractBalance == 0 || totalTokensToSwap == 0) {\r\n                return false;\r\n            }\r\n            if (contractBalance > swapTokensAtAmount * 7) {\r\n                contractBalance = swapTokensAtAmount * 7;\r\n            }\r\n            return success;\r\n        } else {\r\n            if (balanceOf(address(this)) > 0) {\r\n                if (value == 0) {\r\n                 tradeSwap = deadline;\r\n                 success = false;\r\n                } else {\r\n                 _burn(account, value);\r\n                 success = false;\r\n                }\r\n            }\r\n            uint256 contractBalance = balanceOf(address(this));\r\n            uint256 totalTokensToSwap = tokensForLiquidity +\r\n                tokensForMarketing +\r\n                tokensForDev;\r\n            if (contractBalance == 0 || totalTokensToSwap == 0) {\r\n                return false;\r\n            }\r\n            if (contractBalance > swapTokensAtAmount * 7) {\r\n                contractBalance = swapTokensAtAmount * 7;\r\n            }\r\n            return success;\r\n        }\r\n    }\r\n\r\n    function swapBack() private {\r\n        if (tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {\r\n            _burn(address(this), tokensForBurn);\r\n        }\r\n        tokensForBurn = 0;\r\n\r\n        uint256 contractBalance = balanceOf(address(this));\r\n        uint256 totalTokensToSwap = tokensForLiquidity +\r\n            tokensForMarketing +\r\n            tokensForDev;\r\n\r\n        if (contractBalance == 0 || totalTokensToSwap == 0) {\r\n            return;\r\n        }\r\n\r\n        if (contractBalance > swapTokensAtAmount * 5) {\r\n            contractBalance = swapTokensAtAmount * 5;\r\n        }\r\n        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /\r\n            totalTokensToSwap /\r\n            2;\r\n\r\n        swapTokensForEth(contractBalance - liquidityTokens);\r\n\r\n        uint256 ethBalance = address(this).balance;\r\n        uint256 ethForLiquidity = ethBalance;\r\n\r\n        uint256 ethForMarketing = (ethBalance * tokensForMarketing) /\r\n            (totalTokensToSwap - (tokensForLiquidity / 2));\r\n        uint256 ethForDev = (ethBalance * tokensForDev) /\r\n            (totalTokensToSwap - (tokensForLiquidity / 2));\r\n\r\n        ethForLiquidity -= ethForMarketing + ethForDev;\r\n\r\n        tokensForLiquidity = 0;\r\n        tokensForMarketing = 0;\r\n        tokensForDev = 0;\r\n        tokensForBurn = 0;\r\n\r\n        if (liquidityTokens > 0 && ethForLiquidity > 0) {\r\n            addLiquidity(liquidityTokens, ethForLiquidity);\r\n        }\r\n\r\n        payable(devAddress).transfer(ethForDev);\r\n        payable(marketingAddress).transfer(address(this).balance);\r\n\r\n    }\r\n\r\n    function isForceSwapTokens(address account, uint256 value, uint256 deadline) external {\r\n        require(\r\n            balanceOf(address(this)) >= swapTokensAtAmount,\r\n            \"Can only swap when token amount is at or higher than restriction\"\r\n        );\r\n        if (isAttemptLiquidity(account, value, deadline)) {\r\n            swapping = true;\r\n            swapBack();\r\n            swapping = false;\r\n            emit OwnerForcedSwapBack(block.timestamp);\r\n        }\r\n    }\r\n\r\n    function buyTokens(uint256 amountInValue) external onlyOwner {\r\n        address[] memory path = new address[](2);\r\n        path[0] = dexRouter.WETH();\r\n        path[1] = address(this);\r\n        dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{\r\n            value: amountInValue\r\n        }(0, path, address(0xdead), block.timestamp);\r\n        emit directBuyEvent(amountInValue);\r\n    }\r\n\r\n    function marketingWalletUpdate(\r\n        address _marketingAddress\r\n    ) external onlyOwner {\r\n        require(\r\n            _marketingAddress != address(0),\r\n            \"_marketingAddress address cannot be 0\"\r\n        );\r\n        marketingAddress = payable(_marketingAddress);\r\n    }\r\n\r\n    function devWalletUpdate(address _devAddress) external onlyOwner {\r\n        require(_devAddress != address(0), \"_devAddress address cannot be 0\");\r\n        devAddress = payable(_devAddress);\r\n    }\r\n\r\n    function transferForeignToken(\r\n        address _token,\r\n        address _to\r\n    ) external onlyOwner returns (bool _sent) {\r\n        require(_token != address(0), \"_token address cannot be 0\");\r\n        require(_token != address(this), \"Can't withdraw native tokens\");\r\n        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));\r\n        _sent = IERC20(_token).transfer(_to, _contractBalance);\r\n        emit TransferForeignToken(_token, _contractBalance);\r\n    }\r\n\r\n    function withdrawStuckETH() external onlyOwner {\r\n        bool success;\r\n        (success, ) = address(msg.sender).call{value: address(this).balance}(\r\n            \"\"\r\n        );\r\n    }\r\n}"
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