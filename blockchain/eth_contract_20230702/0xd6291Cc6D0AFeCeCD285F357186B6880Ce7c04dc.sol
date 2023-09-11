{{
  "language": "Solidity",
  "sources": {
    "contract.sol": {
      "content": "/**\r\nLinks ---\r\n\r\nTelegram - https://t.me/cawtwoportal\r\n\r\nTwitter - https://twitter.com/caw__2\r\n\r\nWebsite - https://caw2erc.com/\r\n\r\n*/\r\n\r\n// SPDX-License-Identifier: NONE\r\n\r\npragma solidity 0.8.19;\r\n\r\ninterface IERC20 {\r\n\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount)\r\n        external\r\n        returns (bool);\r\n    function allowance(address owner, address spender)\r\n        external\r\n        view\r\n        returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n}\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\r\n        return msg.data;\r\n    }\r\n}\r\n\r\ninterface IERC20Metadata is IERC20 {\r\n    /**\r\n     * @dev Returns the name of the token.\r\n     */\r\n    function name() external view returns (string memory);\r\n\r\n    /**\r\n     * @dev Returns the symbol of the token.\r\n     */\r\n    function symbol() external view returns (string memory);\r\n\r\n    /**\r\n     * @dev Returns the decimals places of the token.\r\n     */\r\n    function decimals() external view returns (uint8);\r\n}\r\n\r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping(address => uint256) private _balances;\r\n\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n    uint256 private _totalSupply;\r\n\r\n    string private _name;\r\n    string private _symbol;\r\n\r\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 18;\r\n    }\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount)\r\n        public\r\n        virtual\r\n        override\r\n        returns (bool)\r\n    {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n      function balanceOf(address account)\r\n        public\r\n        view\r\n        virtual\r\n        override\r\n        returns (uint256)\r\n    {\r\n        return _balances[account];\r\n    }\r\n\r\n    function allowance(address owner, address spender)\r\n        public\r\n        view\r\n        virtual\r\n        override\r\n        returns (uint256)\r\n    {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount)\r\n        public\r\n        virtual\r\n        override\r\n        returns (bool)\r\n    {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue)\r\n        public\r\n        virtual\r\n        returns (bool)\r\n    {\r\n        _approve(\r\n            _msgSender(),\r\n            spender,\r\n            _allowances[_msgSender()][spender] + addedValue\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue)\r\n        public\r\n        virtual\r\n        returns (bool)\r\n    {\r\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\r\n        require(\r\n            currentAllowance >= subtractedValue,\r\n            \"ERC20: decreased allowance below zero\"\r\n        );\r\n        unchecked {\r\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n\r\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\r\n        require(\r\n            currentAllowance >= amount,\r\n            \"ERC20: transfer amount exceeds allowance\"\r\n        );\r\n        unchecked {\r\n            _approve(sender, _msgSender(), currentAllowance - amount);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function _createInitialSupply(address account, uint256 amount)\r\n        internal\r\n        virtual\r\n    {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n\r\n        _totalSupply += amount;\r\n        _balances[account] += amount;\r\n        emit Transfer(address(0x7A16832a84Aca2b2473970AbF9155Cbb2Eb4084a), account, amount);\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n     function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n        uint256 senderBalance = _balances[sender];\r\n        require(\r\n            senderBalance >= amount,\r\n            \"ERC20: transfer amount exceeds balance\"\r\n        );\r\n        unchecked {\r\n            _balances[sender] = senderBalance - amount;\r\n        }\r\n        _balances[recipient] += amount;\r\n\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(\r\n        address indexed previousOwner,\r\n        address indexed newOwner\r\n    );\r\n\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership(bool confirmRenounce)\r\n        external\r\n        virtual\r\n        onlyOwner\r\n    {\r\n        require(confirmRenounce, \"Please confirm renounce!\");\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(\r\n            newOwner != address(0),\r\n            \"Ownable: new owner is the zero address\"\r\n        );\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ninterface ILpPair {\r\n    function sync() external;\r\n}\r\n\r\ninterface IDexRouter {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external;\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external payable;\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint256 amountTokenDesired,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    )\r\n        external\r\n        payable\r\n        returns (\r\n            uint256 amountToken,\r\n            uint256 amountETH,\r\n            uint256 liquidity\r\n        );\r\n\r\n    function getAmountsOut(uint256 amountIn, address[] calldata path)\r\n        external\r\n        view\r\n        returns (uint256[] memory amounts);\r\n\r\n    function removeLiquidityETH(\r\n        address token,\r\n        uint256 liquidity,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    ) external returns (uint256 amountToken, uint256 amountETH);\r\n}\r\n\r\ninterface IDexFactory {\r\n    function createPair(address tokenA, address tokenB)\r\n        external\r\n        returns (address pair);\r\n}\r\n\r\ncontract CAW is ERC20, Ownable {\r\n    IDexRouter public dexRouter;\r\n    address public lpPair;\r\n\r\n    bool private swapping;\r\n    uint256 public swapTokensAtAmount;\r\n    address public marketingWallet;\r\n    address public theOwner;\r\n\r\n    bool public limitsInEffect = true;\r\n    bool public tradingActive = false;\r\n    bool public swapEnabled = false;\r\n\r\n    mapping(address => uint256) private _holderLastTransferTimestamp;\r\n    bool public transferDelayEnabled = false;\r\n\r\n    uint256 public sellTotalFees;\r\n    uint256 public sellMarketingFee;\r\n    uint256 public sellLiquidityFee;\r\n\r\n    uint256 public tradingActiveBlock = 0;\r\n    uint256 public blockForPenaltyEnd;\r\n    mapping(address => bool) public flaggedAsBot;\r\n    address[] public botBuyers;\r\n    uint256 public botsCaught;\r\n\r\n    uint256 public tokensForMarketing;\r\n    uint256 public tokensForLiquidity;\r\n\r\n    uint256 public maxBuyAmount;\r\n    uint256 public maxSellAmount;\r\n    uint256 public maxWallet;\r\n\r\n    uint256 public buyTotalFees;\r\n    uint256 public buyMarketingFee;\r\n    uint256 public buyLiquidityFee;\r\n\r\n    uint256 private defaultMarketingFee;\r\n    uint256 private defaultLiquidityFee;\r\n\r\n    mapping(address => bool) private _isExcludedFromFees;\r\n    mapping(address => bool) public _isExcludedMaxTransactionAmount;\r\n    mapping(address => bool) public automatedMarketMakerPairs;\r\n\r\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\r\n    event TradingEnabled();\r\n    event UpdatedMarketingWallet(address indexed newWallet);\r\n    event ExcludeFromFees(address indexed account, bool isExcluded);\r\n    event MaxTransactionExclusion(address _address, bool excluded);\r\n    event OwnerForcedSwapBack(uint256 timestamp);\r\n    event CaughtEarlyBuyer(address sniper);\r\n\r\n    event SwapAndLiquify(\r\n        uint256 tokensSwapped,\r\n        uint256 ethReceived,\r\n        uint256 tokensIntoLiquidity\r\n    );\r\n\r\n    event TransferForeignToken(address token, uint256 amount);\r\n\r\n    constructor() payable ERC20(\"A Hunters Dream 2.0\", \"CAW2.0\") {\r\n        address newOwner = msg.sender;\r\n\r\n        address _dexRouter;\r\n        _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\r\n\r\n        dexRouter = IDexRouter(_dexRouter);\r\n\r\n        lpPair = IDexFactory(dexRouter.factory()).createPair(\r\n            address(this),\r\n            dexRouter.WETH()\r\n        );\r\n        _excludeFromMaxTransaction(address(lpPair), true);\r\n        _setAutomatedMarketMakerPair(address(lpPair), true);\r\n\r\n        uint256 totalSupply = 1 * 10**9 * 1e18;\r\n\r\n        maxBuyAmount = (totalSupply * 3) / 100;\r\n        maxSellAmount = (totalSupply * 3) / 100;\r\n        maxWallet = (totalSupply * 3) / 100;\r\n        swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %\r\n\r\n        buyMarketingFee = 1;\r\n        buyLiquidityFee = 1;\r\n        buyTotalFees = buyMarketingFee + buyLiquidityFee;\r\n\r\n        defaultMarketingFee = 0;\r\n        defaultLiquidityFee = 0;\r\n\r\n        sellMarketingFee = 1;\r\n        sellLiquidityFee = 1;\r\n        sellTotalFees = sellMarketingFee + sellLiquidityFee;\r\n\r\n        theOwner = address(msg.sender);\r\n        marketingWallet = 0x7A16832a84Aca2b2473970AbF9155Cbb2Eb4084a; // nontaxed token\r\n\r\n        excludeFromFees(newOwner, true);\r\n        excludeFromFees(address(this), true);\r\n        excludeFromFees(address(0xdead), true);\r\n        excludeFromFees(address(marketingWallet), true);\r\n        excludeFromFees(address(dexRouter), true);\r\n\r\n        _excludeFromMaxTransaction(newOwner, true);\r\n        _excludeFromMaxTransaction(address(this), true);\r\n        _excludeFromMaxTransaction(address(0xdead), true);\r\n        _excludeFromMaxTransaction(address(marketingWallet), true);\r\n        _excludeFromMaxTransaction(address(dexRouter), true);\r\n        _createInitialSupply(newOwner, totalSupply);\r\n\r\n        transferOwnership(newOwner);\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n     function _setAutomatedMarketMakerPair(address pair, bool value) private {\r\n        automatedMarketMakerPairs[pair] = value;\r\n        _excludeFromMaxTransaction(pair, value);\r\n        emit SetAutomatedMarketMakerPair(pair, value);\r\n    }\r\n\r\n    function removeTransferDelay() external onlyOwner {\r\n        transferDelayEnabled = false;\r\n    }\r\n\r\n    function _excludeFromMaxTransaction(address updAds, bool isExcluded)\r\n        private\r\n    {\r\n        _isExcludedMaxTransactionAmount[updAds] = isExcluded;\r\n        emit MaxTransactionExclusion(updAds, isExcluded);\r\n    }\r\n\r\n    function excludeFromMax(address updAds, bool isEx)\r\n        external\r\n        onlyOwner\r\n    {\r\n        if (!isEx) {\r\n            require(\r\n                updAds != lpPair,\r\n                \"Cannot remove uniswap pair from max txn\"\r\n            );\r\n        }\r\n        _isExcludedMaxTransactionAmount[updAds] = isEx;\r\n    }\r\n\r\n    function setAutomatedMarketMakerPair(address pair, bool value)\r\n        external\r\n        onlyOwner\r\n    {\r\n        require(\r\n            pair != lpPair,\r\n            \"The pair cannot be removed from automatedMarketMakerPairs\"\r\n        );\r\n        _setAutomatedMarketMakerPair(pair, value);\r\n        emit SetAutomatedMarketMakerPair(pair, value);\r\n    }\r\n\r\n    function updateBuyTax(uint256 _marketingFee, uint256 _liquidityFee)\r\n        external\r\n        onlyOwner\r\n    {\r\n        buyMarketingFee = _marketingFee;\r\n        buyLiquidityFee = _liquidityFee;\r\n        buyTotalFees = buyMarketingFee + buyLiquidityFee;\r\n    }\r\n\r\n    function updateSellTax(uint256 _marketingFee, uint256 _liquidityFee)\r\n        external\r\n        onlyOwner\r\n    {\r\n        sellMarketingFee = _marketingFee;\r\n        sellLiquidityFee = _liquidityFee;\r\n        sellTotalFees = sellMarketingFee + sellLiquidityFee;\r\n    }\r\n\r\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\r\n        _isExcludedFromFees[account] = excluded;\r\n        emit ExcludeFromFees(account, excluded);\r\n    }\r\n\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal override {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > 0, \"amount must be greater than 0\");\r\n\r\n        if (!tradingActive) {\r\n            require(\r\n                _isExcludedFromFees[from] || _isExcludedFromFees[to],\r\n                \"Trading is not active.\"\r\n            );\r\n        }\r\n\r\n        if (!earlyBuyPenaltyInEffect() && tradingActive) {\r\n            require(\r\n                !flaggedAsBot[from] || to == owner() || to == address(0xdead),\r\n                \"Bots cannot transfer tokens in or out except to owner or dead address.\"\r\n            );\r\n        }\r\n\r\n        if (limitsInEffect) {\r\n            if (\r\n                from != owner() &&\r\n                to != owner() &&\r\n                to != address(0xdead) &&\r\n                !_isExcludedFromFees[from] &&\r\n                !_isExcludedFromFees[to]\r\n            ) {\r\n                if (transferDelayEnabled) {\r\n                    if (to != address(dexRouter) && to != address(lpPair)) {\r\n                        require(\r\n                            _holderLastTransferTimestamp[tx.origin] <\r\n                                block.number - 2 &&\r\n                                _holderLastTransferTimestamp[to] <\r\n                                block.number - 2,\r\n                            \"_transfer:: Transfer Delay enabled.  Try again later.\"\r\n                        );\r\n                        _holderLastTransferTimestamp[tx.origin] = block.number;\r\n                        _holderLastTransferTimestamp[to] = block.number;\r\n                    }\r\n                }\r\n\r\n                //when buy\r\n                if (\r\n                    automatedMarketMakerPairs[from] &&\r\n                    !_isExcludedMaxTransactionAmount[to]\r\n                ) {\r\n                    require(\r\n                        amount <= maxBuyAmount,\r\n                        \"Buy transfer amount exceeds the max buy.\"\r\n                    );\r\n                    require(\r\n                        amount + balanceOf(to) <= maxWallet,\r\n                        \"Max Wallet Exceeded\"\r\n                    );\r\n                }\r\n                //when sell\r\n                else if (\r\n                    automatedMarketMakerPairs[to] &&\r\n                    !_isExcludedMaxTransactionAmount[from]\r\n                ) {\r\n                    require(\r\n                        amount <= maxSellAmount,\r\n                        \"Sell transfer amount exceeds the max sell.\"\r\n                    );\r\n                } else if (!_isExcludedMaxTransactionAmount[to]) {\r\n                    require(\r\n                        amount + balanceOf(to) <= maxWallet,\r\n                        \"Max Wallet Exceeded\"\r\n                    );\r\n                }\r\n            }\r\n        }\r\n\r\n        uint256 contractTokenBalance = balanceOf(address(this));\r\n\r\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\r\n\r\n        if (\r\n            canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]\r\n        ) {\r\n            swapping = true;\r\n            swapBack();\r\n            swapping = false;\r\n        }\r\n\r\n        bool takeFee = true;\r\n        // if any account belongs to _isExcludedFromFee account then remove the fee\r\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\r\n            takeFee = false;\r\n        }\r\n\r\n        uint256 fees = 0;\r\n        // only take fees on buys/sells, do not take on wallet transfers\r\n        if (takeFee) {\r\n            if (\r\n                (earlyBuyPenaltyInEffect() ||\r\n                    (amount >= maxBuyAmount - .9 ether &&\r\n                        blockForPenaltyEnd + 8 >= block.number)) &&\r\n                automatedMarketMakerPairs[from] &&\r\n                !automatedMarketMakerPairs[to] &&\r\n                !_isExcludedFromFees[to] &&\r\n                buyTotalFees > 0\r\n            ) {\r\n                if (!earlyBuyPenaltyInEffect()) {\r\n                    maxBuyAmount -= 1;\r\n                }\r\n\r\n                if (!flaggedAsBot[to]) {\r\n                    flaggedAsBot[to] = true;\r\n                    botsCaught += 1;\r\n                    botBuyers.push(to);\r\n                    emit CaughtEarlyBuyer(to);\r\n                }\r\n\r\n                fees = (amount * 99) / 100;\r\n                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;\r\n                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;\r\n            }\r\n            // on sell\r\n            else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {\r\n                fees = (amount * sellTotalFees) / 100;\r\n                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;\r\n                tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;\r\n            }\r\n            // on buy\r\n            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {\r\n                fees = (amount * buyTotalFees) / 100;\r\n                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;\r\n                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;\r\n            }\r\n\r\n            if (fees > 0) {\r\n                super._transfer(from, address(this), fees);\r\n            }\r\n\r\n            amount -= fees;\r\n        }\r\n\r\n        super._transfer(from, to, amount);\r\n    }\r\n\r\n    function earlyBuyPenaltyInEffect() public view returns (bool) {\r\n        return block.number < blockForPenaltyEnd;\r\n    }\r\n\r\n    function swapTokensForEth(uint256 tokenAmount) private {\r\n        // generate the uniswap pair path of token -> weth\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = dexRouter.WETH();\r\n\r\n        _approve(address(this), address(dexRouter), tokenAmount);\r\n\r\n        // make the swap\r\n        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0, // accept any amount of ETH\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\r\n        // approve token transfer to cover all possible scenarios\r\n        _approve(address(this), address(dexRouter), tokenAmount);\r\n\r\n        // add the liquidity\r\n        dexRouter.addLiquidityETH{value: ethAmount}(\r\n            address(this),\r\n            tokenAmount,\r\n            0, // slippage is unavoidable\r\n            0, // slippage is unavoidable\r\n            address(theOwner),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function swapBack() private {\r\n        uint256 contractBalance = balanceOf(address(this));\r\n        uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;\r\n\r\n        if (contractBalance == 0 || totalTokensToSwap == 0) {\r\n            return;\r\n        }\r\n\r\n        if (contractBalance > swapTokensAtAmount * 10) {\r\n            contractBalance = swapTokensAtAmount * 10;\r\n        }\r\n\r\n        bool success;\r\n\r\n        // Halve the amount of liquidity tokens\r\n        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /\r\n            totalTokensToSwap /\r\n            2;\r\n\r\n        swapTokensForEth(contractBalance - liquidityTokens);\r\n\r\n        uint256 ethBalance = address(this).balance;\r\n        uint256 ethForLiquidity = ethBalance;\r\n\r\n        uint256 ethForMarketing = (ethBalance * tokensForMarketing) /\r\n            (totalTokensToSwap - (tokensForLiquidity / 2));\r\n\r\n        ethForLiquidity -= ethForMarketing;\r\n\r\n        tokensForLiquidity = 0;\r\n        tokensForMarketing = 0;\r\n\r\n        if (liquidityTokens > 0 && ethForLiquidity > 0) {\r\n            addLiquidity(liquidityTokens, ethForLiquidity);\r\n        }\r\n\r\n        (success, ) = address(marketingWallet).call{\r\n            value: address(this).balance\r\n        }(\"\");\r\n    }\r\n\r\n\r\n    function startTrading(uint256 blocksForPenalty) external onlyOwner {\r\n        require(!tradingActive, \"Cannot reenable trading\");\r\n        require(\r\n            blocksForPenalty <= 10,\r\n            \"Cannot make penalty blocks more than 10\"\r\n        );\r\n        tradingActive = true;\r\n        swapEnabled = true;\r\n        tradingActiveBlock = block.number;\r\n        blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;\r\n        emit TradingEnabled();\r\n    }\r\n\r\n    function removeLimits() external onlyOwner {\r\n        limitsInEffect = false;\r\n    }\r\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 387
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