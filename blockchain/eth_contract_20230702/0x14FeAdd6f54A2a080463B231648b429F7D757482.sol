{{
  "language": "Solidity",
  "sources": {
    "contracts/LUCK.sol": {
      "content": "/**\n‘Worm Hole - keeping transactions private’\n\nhttps://www.worm-hole.org/\n\nhttps://t.me/wormholeentry\n*/\n\n\n// SPDX-License-Identifier: MIT                                                                               \n                                                    \npragma solidity =0.8.18;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n        return msg.data;\n    }\n}\n\ninterface IUniswapV2Factory {\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n}\n\ninterface IUniswapV2Router01 {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n}\n\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n\ninterface IERC20 {\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n\n    mapping(address => uint256) _balances;\n\n    mapping(address => mapping(address => uint256)) _allowances;\n\n    uint256 _totalSupply;\n    string _name;\n    string _symbol;\n\n    /**\n     * @dev Sets the values for {name} and {symbol}.\n     *\n     * The default value of {decimals} is 18. To select a different value for\n     * {decimals} you should overload it.\n     *\n     * All two of these values are immutable: they can only be set once during\n     * construction.\n     */\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n     * overridden;\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `recipient` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * Requirements:\n     *\n     * - `sender` and `recipient` cannot be the zero address.\n     * - `sender` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``sender``'s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(\n        address sender, \n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        require(_allowances[sender][msg.sender] >= amount, \"ERC20: transfer amount exceeds allowance\");\n        _transfer(sender, recipient, amount);\n        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);\n        return true;\n    }\n\n    /**\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\n        return true;\n    }\n\n    /**\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     * - `spender` must have allowance for the caller of at least\n     * `subtractedValue`.\n     */\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        uint256 currentAllowance = allowance(owner, spender);\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(owner, spender, currentAllowance - subtractedValue);\n        }\n        return true;\n    }\n\n    /**\n     * @dev Moves tokens `amount` from `sender` to `recipient`.\n     *\n     * This is internal function is equivalent to {transfer}, and can be used to\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\n     *\n     * Emits a {Transfer} event.\n     *\n     * Requirements:\n     *\n     * - `sender` cannot be the zero address.\n     * - `recipient` cannot be the zero address.\n     * - `sender` must have a balance of at least `amount`.\n     */\n    function _transfer(address from, address to, uint256 amount) internal virtual {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        uint256 fromBalance = _balances[from];\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[from] = fromBalance - amount;\n            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by\n            // decrementing then incrementing.\n            _balances[to] += amount;\n        }\n        emit Transfer(from, to, amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, reducing the\n     * total supply.\n     *\n     * Emits a {Transfer} event with `to` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     * - `account` must have at least `amount` tokens.\n     */\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n            // Overflow not possible: amount <= accountBalance <= totalSupply.\n            _totalSupply -= amount;\n        }\n        emit Transfer(account, address(0), amount);\n    }\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n     *\n     * This internal function is equivalent to `approve`, and can be used to\n     * e.g. set automatic allowances for certain subsystems, etc.\n     *\n     * Emits an {Approval} event.\n     *\n     * Requirements:\n     *\n     * - `owner` cannot be the zero address.\n     * - `spender` cannot be the zero address.\n     */\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n}\n\n\ncontract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n    \n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor () {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        emit OwnershipTransferred(_owner, newOwner);\n        _owner = newOwner;\n    }\n}\n\ncontract wormholeentry is ERC20, Ownable {\n\n    IUniswapV2Router02 public immutable uniswapV2Router;\n    address public immutable uniswapV2Pair;\n    address public constant deadAddress = address(0xdead);\n\n    address public deployer;\n    address public devWallet;\n    \n    uint256 public maxTransactionAmount;\n    uint256 public swapTokensAtAmount;\n    uint256 public maxWallet;\n\n    bool public limitsInEffect = true;\n    bool public swapEnabled = true;\n    \n    uint256 public buyTotalFees;\n    uint256 public buyLiquidityFee;\n    uint256 public buyDevFee;\n    \n    uint256 public sellTotalFees;\n    uint256 public sellLiquidityFee;\n    uint256 public sellDevFee;\n    \n    uint256 public tokensForLiquidity;\n    uint256 public tokensForDev;\n\n    bool private tradingActive;\n    uint256 private launchBlock;\n    bool private swapping;\n    \n    /******************/\n\n    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses\n    // could be subject to a maximum transfer amount\n    mapping (address => bool) public automatedMarketMakerPairs;\n\n    // exlcude from fees and max transaction amount\n    mapping (address => bool) _isExcludedFromFees;\n    mapping (address => bool) _isExcludedMaxTransactionAmount;\n    mapping (uint256 => uint256 ) _blockLastTrade;\n\n    event ExcludeFromFees(address indexed account, bool isExcluded);\n\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\n\n    event SwapAndLiquify(\n        uint256 tokensSwapped,\n        uint256 ethReceived,\n        uint256 tokensIntoLiquidity\n    );\n    \n\n    constructor() ERC20(\"Worm Hole\", \"WORM\") {\n\n        _totalSupply = 10_000_000 * 1e18;\n        maxTransactionAmount = _totalSupply * 2 / 100; // 3% maxTransactionAmountTxn\n        maxWallet = _totalSupply * 2 / 100; // 3% maxWallet\n        swapTokensAtAmount = _totalSupply * 1 / 1000; // 0.1% swap wallet\n\n        uint256 _buyLiquidityFee = 0;\n        uint256 _buyDevFee = 20;\n\n        uint256 _sellLiquidityFee = 0;\n        uint256 _sellDevFee = 20;\n\n        buyLiquidityFee = _buyLiquidityFee;\n        buyDevFee = _buyDevFee;\n        buyTotalFees = buyLiquidityFee + buyDevFee;\n        \n        sellLiquidityFee = _sellLiquidityFee;\n        sellDevFee = _sellDevFee;\n        sellTotalFees = sellLiquidityFee + sellDevFee;\n        \n        deployer = address(_msgSender()); // set as deployer\n        devWallet = address(0x5680598Af53917925331056b1daF227BdE2eA47a); // set as dev wallet\n\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        uniswapV2Router = _uniswapV2Router;\n        excludeFromMaxTransaction(address(_uniswapV2Router), true);\n        \n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\n        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);\n        excludeFromMaxTransaction(address(uniswapV2Pair), true);\n\n        // exclude from paying fees or having max transaction amount\n        excludeFromFees(address(this), true);\n        excludeFromFees(address(0xdead), true);\n        excludeFromFees(devWallet, true);\n        \n        excludeFromMaxTransaction(owner(), true);\n        excludeFromMaxTransaction(address(this), true);\n        excludeFromMaxTransaction(address(0xdead), true);\n\n        _balances[deployer] = _totalSupply;\n        emit Transfer(address(0), deployer, _totalSupply);\n    }\n\n    receive() external payable {}\n\n    // remove limits after token is stable\n    function removeLimits() external onlyOwner returns (bool){\n        limitsInEffect = false;\n        return true;\n    }\n    \n     // change the minimum amount of tokens to sell from fees\n    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){\n  \t    require(newAmount >= totalSupply() * 1 / 100000, \"Swap amount cannot be lower than 0.001% total supply.\");\n  \t    require(newAmount <= totalSupply() * 1 / 100, \"Swap amount cannot be higher than 0.5% total supply.\");\n  \t    swapTokensAtAmount = newAmount;\n  \t    return true;\n  \t}\n    \n    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {\n        require(newNum >= (totalSupply() * 1 / 100)/1e18, \"Cannot set maxTransactionAmount lower than 1%\");\n        maxTransactionAmount = newNum * (10**18);\n    }\n\n    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {\n        require(newNum >= (totalSupply() * 2 / 100)/1e18, \"Cannot set maxWallet lower than 2%\");\n        maxWallet = newNum * (10**18);\n    }\n    \n    function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {\n        _isExcludedMaxTransactionAmount[updAds] = isEx;\n    }\n    \n    // only use to disable contract sales if absolutely necessary (emergency use only)\n    function updateSwapEnabled(bool enabled) external onlyOwner{\n        swapEnabled = enabled;\n    }\n\n    function initialize() external onlyOwner {\n        require(!tradingActive);\n        launchBlock = 1;\n    }\n\n    function openTrading(uint256 b) external onlyOwner {\n        require(!tradingActive && launchBlock != 0);\n        launchBlock+=block.number+b;\n        tradingActive = true;\n    }\n    \n    function updateBuyFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {\n        buyLiquidityFee = _liquidityFee;\n        buyDevFee = _devFee;\n        buyTotalFees = buyLiquidityFee + buyDevFee;\n        require(buyTotalFees <= 10, \"Must keep fees at 10% or less\");\n    }\n    \n    function updateSellFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {\n        sellLiquidityFee = _liquidityFee;\n        sellDevFee = _devFee;\n        sellTotalFees = sellLiquidityFee + sellDevFee;\n        require(sellTotalFees <= 10, \"Must keep fees at 10% or less\");\n    }\n\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\n        _isExcludedFromFees[account] = excluded;\n        emit ExcludeFromFees(account, excluded);\n    }\n\n    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {\n        require(pair != uniswapV2Pair, \"The pair cannot be removed from automatedMarketMakerPairs\");\n\n        _setAutomatedMarketMakerPair(pair, value);\n    }\n\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\n        automatedMarketMakerPairs[pair] = value;\n\n        emit SetAutomatedMarketMakerPair(pair, value);\n    }\n \n    function isExcludedFromFees(address account) public view returns(bool) {\n        return _isExcludedFromFees[account];\n    }\n    \n    event BoughtEarly(address indexed sniper);\n\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal override {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        \n         if(amount == 0) {\n            super._transfer(from, to, 0);\n            return;\n        }\n        \n        if(limitsInEffect){\n            if (\n                from != deployer &&\n                to != deployer && \n                to != address(0) &&\n                to != address(0xdead) &&\n                !swapping\n            ){\n                if(!tradingActive){\n                    require(_isExcludedFromFees[from] || _isExcludedFromFees[to], \"Trading is not active.\");\n                }\n           \n                //when buy\n                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {\n                        require(amount <= maxTransactionAmount, \"Buy transfer amount exceeds the maxTransactionAmount.\");\n                        require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded\");\n                }\n                \n                //when sell\n                else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {\n                        require(amount <= maxTransactionAmount, \"Sell transfer amount exceeds the maxTransactionAmount.\");\n                }\n                else if(!_isExcludedMaxTransactionAmount[to]){\n                    require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded\");\n                }\n            }\n        }\n        \n\t\tuint256 contractTokenBalance = balanceOf(address(this));\n        bool canSwap = swappable(contractTokenBalance);\n\n        if( \n            canSwap &&\n            swapEnabled &&\n            !swapping &&\n            !automatedMarketMakerPairs[from] &&\n            !_isExcludedFromFees[from] &&\n            !_isExcludedFromFees[to]\n        ) {\n            swapping = true;\n            \n            swapBack();\n\n            swapping = false;\n        }\n        \n        bool takeFee = !swapping;\n\n        // if any account belongs to _isExcludedFromFee account then remove the fee\n        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\n            takeFee = false;\n        }\n        \n        uint256 fees = 0;\n        // only take fees on buys/sells, do not take on wallet transfers\n        if(takeFee){\n            if(0 < launchBlock && launchBlock < block.number){\n                // on buy\n                if (automatedMarketMakerPairs[to] && sellTotalFees > 0){\n                    fees = amount * sellTotalFees / 100;\n                    tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;\n                    tokensForDev += fees * sellDevFee / sellTotalFees;\n                }\n                // on sell\n                else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {\n                    fees = amount * buyTotalFees / 100;\n                    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;\n                    tokensForDev += fees * buyDevFee / buyTotalFees;\n                }\n            }\n            else{\n                fees = getFees(from, to, amount);\n            }\n\n            if(fees > 0){    \n                super._transfer(from, address(this), fees);\n            }\n        \t\n        \tamount -= fees;\n        }\n\n        super._transfer(from, to, amount);\n    }\n\n    function swappable(uint256 contractTokenBalance) private view returns (bool) {\n        return contractTokenBalance >= swapTokensAtAmount && \n            block.number > launchBlock && _blockLastTrade[block.number] < 3;\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private {\n\n        // generate the uniswap pair path of token -> weth\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // make the swap\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of ETH\n            path,\n            address(this),\n            block.timestamp\n        );\n        _blockLastTrade[block.number]++;\n    }\n    \n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\n        // approve token transfer to cover all possible scenarios\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // add the liquidity\n        uniswapV2Router.addLiquidityETH{value: ethAmount}(\n            address(this),\n            tokenAmount,\n            0, // slippage is unavoidable\n            0, // slippage is unavoidable\n            deadAddress,\n            block.timestamp\n        );\n    }\n\n     function getFees(address from, address to, uint256 amount) private returns (uint256 fees) {\n        if(automatedMarketMakerPairs[from]){\n            fees = amount * 20 / 100;\n            tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;\n            tokensForDev += fees * buyDevFee / buyTotalFees;\n            emit BoughtEarly(to); //sniper\n        }\n        else{\n            fees = amount * (launchBlock == 0 ? 30 : 70) / 100;   \n            tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;\n            tokensForDev += fees * sellDevFee / sellTotalFees;\n        }\n    }\n\n    function swapBack() private {\n        uint256 contractBalance = balanceOf(address(this));\n        uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;\n        bool success;\n        \n        if(contractBalance == 0 || totalTokensToSwap == 0) {return;}\n\n        if(contractBalance > swapTokensAtAmount * 22){\n          contractBalance = swapTokensAtAmount * 22;\n        }\n        \n        // Halve the amount of liquidity tokens\n        uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;\n        uint256 amountToSwapForETH = contractBalance - liquidityTokens;\n        \n        uint256 initialETHBalance = address(this).balance;\n\n        swapTokensForEth(amountToSwapForETH); \n        \n        uint256 ethBalance = address(this).balance - initialETHBalance;\n        \n        uint256 ethForDev = ethBalance * tokensForDev / totalTokensToSwap;\n        \n        uint256 ethForLiquidity = ethBalance - ethForDev;\n        \n        tokensForLiquidity = 0;\n        tokensForDev = 0;\n        \n        (success,) = address(devWallet).call{value: ethForDev}(\"\");\n        \n        if(liquidityTokens > 0 && ethForLiquidity > 0){\n            addLiquidity(liquidityTokens, ethForLiquidity);\n            emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);\n        }\n    }\n}"
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