{{
  "language": "Solidity",
  "sources": {
    "GOAT.sol": {
      "content": "/*\n\nTG: https://t.me/GOATverify\nTWITTER: https://twitter.com/GOATonETH\nWebsite: https://goateth.info\n*/\n\n// SPDX-License-Identifier: MIT\npragma solidity ^0.8.9;\n\nimport \"@openzeppelin/contracts/token/ERC20/ERC20.sol\";\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\n\ncontract GOAT is ERC20, Ownable {\n    IUniswapV2Router02 public immutable uniswapV2Router;\n    address public immutable uniswapV2Pair;\n\n    // Limits\n    uint256 public maxTx = 10; // 10 = 1%\n    uint256 public maxWallet = 20; // 20 = 2%\n\n    // Fees\n    uint256 public marketingFee = 215; // 20 = 2%\n    uint256 public liquidityFee = 10; // 20 = 2%\n    uint256 public totalFees = marketingFee + liquidityFee;\n    uint256 public numTokensToLiquify = 3000 * 10 ** 18;\n    address public marketingWallet = 0x6aB81297e2E9F075d7F6C1B95722629E9C90B8E6;\n    bool inSwapAndLiq;\n    bool public SwapAndSendEnabled = true;\n\n    //Mappings\n    mapping(address => bool) public _isExcludedFromFee;\n    mapping(address => bool) public _isExcluded;\n    mapping(address => bool) public _isBlacklisted;\n\n    // Anti-Bot/Sniper\n    mapping(address => bool) public earlyBuyerHODL;\n    mapping(address => uint256) public earlyBuyerTimeOut;\n    uint8 public HODLBLOCKS;\n    uint8 public botsCaught;\n    uint32 public tradingStartBlock = 77777777;\n\n    modifier lockTheSwap() {\n        inSwapAndLiq = true;\n        _;\n        inSwapAndLiq = false;\n    }\n\n    receive() external payable {}\n\n    constructor() ERC20(\"Greatest Of All Tokens\", \"GOAT\") {\n        _mint(msg.sender, 1000000 * 10 ** decimals());\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\n        );\n\n        // Create a uniswap pair for this new token\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\n            .createPair(address(this), _uniswapV2Router.WETH());\n\n        // set the rest of the contract variables\n        uniswapV2Router = _uniswapV2Router;\n\n        _isExcludedFromFee[msg.sender] = true;\n        _isExcludedFromFee[address(this)] = true;\n        _isExcludedFromFee[marketingWallet] = true;\n        _isExcludedFromFee[uniswapV2Pair] = true;\n    }\n\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal override {\n        uint256 maxTxAmount = (totalSupply() * maxTx) / 1000;\n        uint256 maxWalletAmount = (totalSupply() * maxWallet) / 1000;\n        uint256 taxAmount;\n\n        if (block.number <= tradingStartBlock) {\n            require(from == owner(), \"Trading hasnt started\");\n        }\n\n        if (from == uniswapV2Pair) {\n            //Buy\n            if (!_isExcludedFromFee[to]) {\n                require(amount <= maxTxAmount, \"Amount over max tx\");\n                require(\n                    balanceOf(to) + amount <= maxWalletAmount,\n                    \"Max wallet in effect\"\n                );\n                taxAmount = (amount * totalFees) / 1000;\n            }\n\n            if (block.number <= tradingStartBlock + HODLBLOCKS) {\n                earlyBuyerHODL[to] = true;\n                earlyBuyerTimeOut[to] = block.timestamp + 1 weeks;\n                botsCaught += 1;\n            }\n        }\n\n        if (to == uniswapV2Pair) {\n            //Sell\n            if (!_isExcludedFromFee[from]) {\n                require(amount <= maxTxAmount, \"Amount over max tx\");\n                require(!_isBlacklisted[from], \"Account blacklisted\");\n                taxAmount = (amount * totalFees) / 1000;\n            }\n\n            if (earlyBuyerHODL[from]) {\n                require(block.timestamp > earlyBuyerTimeOut[from]);\n            }\n        }\n\n        if (to != uniswapV2Pair && from != uniswapV2Pair) {\n            if (!_isExcludedFromFee[to] || !_isExcludedFromFee[from]) {\n                require(\n                    balanceOf(to) + amount <= maxWalletAmount,\n                    \"Max wallet in effect\"\n                );\n            }\n\n            if (earlyBuyerHODL[to])\n                require(block.timestamp > earlyBuyerTimeOut[to]);\n        }\n\n        uint256 contractTokenBalance = balanceOf(address(this));\n        bool overMinTokenBalance = contractTokenBalance >= numTokensToLiquify;\n\n        if (contractTokenBalance >= numTokensToLiquify) {\n            contractTokenBalance = numTokensToLiquify;\n        }\n\n        if (\n            overMinTokenBalance &&\n            !inSwapAndLiq &&\n            from != uniswapV2Pair &&\n            SwapAndSendEnabled\n        ) {\n            handleTax(contractTokenBalance);\n        }\n        // Fees\n        if (taxAmount > 0) {\n            uint256 userAmount = amount - taxAmount;\n\n            super._transfer(from, address(this), taxAmount);\n            super._transfer(from, to, userAmount);\n        } else {\n            super._transfer(from, to, amount);\n        }\n    }\n\n    function handleTax(uint256 _contractTokenBalance) internal lockTheSwap {\n        uint256 tokensToLiquidity = (((((liquidityFee) * 1000) / totalFees)) *\n            _contractTokenBalance) / 1000;\n\n        uint256 tokensToMarketing = _contractTokenBalance - tokensToLiquidity;\n        _transfer(address(this), marketingWallet, tokensToMarketing);\n        addLiquidity(tokensToLiquidity);\n    }\n\n    function addLiquidity(uint256 amount) internal {\n        uint256 half = amount / 2;\n        uint256 otherHalf = amount - half;\n        uint256 initialBalance = address(this).balance;\n        swapTokensForEth(half);\n        uint256 newBalance = address(this).balance - initialBalance;\n        _addLiquidity(otherHalf, newBalance);\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) internal {\n        // generate the uniswap pair path of token -> weth\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // make the swap\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of ETH\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // add the liquidity\n        uniswapV2Router.addLiquidityETH{value: ethAmount}(\n            address(this),\n            tokenAmount,\n            0, // slippage is unavoidable\n            0, // slippage is unavoidable\n            owner(),\n            block.timestamp\n        );\n    }\n\n    // SETTERS\n\n    function startTrading(uint8 _blacklistBlocks) external onlyOwner {\n        tradingStartBlock = uint32(block.number);\n        HODLBLOCKS = _blacklistBlocks;\n    }\n\n    function includeInFee(address account) external onlyOwner {\n        _isExcludedFromFee[account] = false;\n    }\n\n    function excludeFromFee(address account) external onlyOwner {\n        _isExcludedFromFee[account] = true;\n    }\n\n    function addToBlackList(address _address) external onlyOwner {\n        _isBlacklisted[_address] = true;\n    }\n\n    function removeFromBlackList(address account) external onlyOwner {\n        _isBlacklisted[account] = false;\n    }\n\n    function _setMarketingWallet(address payable wallet) external onlyOwner {\n        marketingWallet = wallet;\n    }\n\n    function _setMaxTxAmount(uint256 _maxTxAmount) external onlyOwner {\n        maxTx = _maxTxAmount;\n    }\n\n    function _setMaxWalletAmount(uint256 _maxWalletAmount) external onlyOwner {\n        maxWallet = _maxWalletAmount;\n    }\n\n    function setNewFees(uint256 _marketingFee, uint256 _liquidityFee) external onlyOwner {\n        marketingFee = _marketingFee;\n        liquidityFee = _liquidityFee;\n         totalFees = marketingFee + liquidityFee;\n    }\n\n    function setSwapAndSendEnabled(bool _active) external onlyOwner {\n        SwapAndSendEnabled = _active;\n    }\n\n    function decreaseEarlyBuyerTimeOut(\n        address _address,\n        uint256 _newTimeOut\n    ) external onlyOwner {\n        require(\n            _newTimeOut < earlyBuyerTimeOut[_address],\n            \"Cannot increase time, only decrease\"\n        );\n        earlyBuyerTimeOut[_address] = _newTimeOut;\n    }\n\n    function removeEarlyBuyerHODL(address _address) external onlyOwner {\n        require(earlyBuyerHODL[_address], \"Address is not on forced HODL\");\n        earlyBuyerHODL[_address] = false;\n    }\n}\n\n// Interfaces\ninterface IUniswapV2Factory {\n    event PairCreated(\n        address indexed token0,\n        address indexed token1,\n        address pair,\n        uint\n    );\n\n    function feeTo() external view returns (address);\n\n    function feeToSetter() external view returns (address);\n\n    function getPair(\n        address tokenA,\n        address tokenB\n    ) external view returns (address pair);\n\n    function allPairs(uint) external view returns (address pair);\n\n    function allPairsLength() external view returns (uint);\n\n    function createPair(\n        address tokenA,\n        address tokenB\n    ) external returns (address pair);\n\n    function setFeeTo(address) external;\n\n    function setFeeToSetter(address) external;\n}\n\ninterface IUniswapV2Pair {\n    event Approval(address indexed owner, address indexed spender, uint value);\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function name() external pure returns (string memory);\n\n    function symbol() external pure returns (string memory);\n\n    function decimals() external pure returns (uint8);\n\n    function totalSupply() external view returns (uint);\n\n    function balanceOf(address owner) external view returns (uint);\n\n    function allowance(\n        address owner,\n        address spender\n    ) external view returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n\n    function transfer(address to, uint value) external returns (bool);\n\n    function transferFrom(\n        address from,\n        address to,\n        uint value\n    ) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n\n    function nonces(address owner) external view returns (uint);\n\n    function permit(\n        address owner,\n        address spender,\n        uint value,\n        uint deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) external;\n\n    event Mint(address indexed sender, uint amount0, uint amount1);\n    event Burn(\n        address indexed sender,\n        uint amount0,\n        uint amount1,\n        address indexed to\n    );\n    event Swap(\n        address indexed sender,\n        uint amount0In,\n        uint amount1In,\n        uint amount0Out,\n        uint amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\n\n    function factory() external view returns (address);\n\n    function token0() external view returns (address);\n\n    function token1() external view returns (address);\n\n    function getReserves()\n        external\n        view\n        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n\n    function price0CumulativeLast() external view returns (uint);\n\n    function price1CumulativeLast() external view returns (uint);\n\n    function kLast() external view returns (uint);\n\n    function mint(address to) external returns (uint liquidity);\n\n    function burn(address to) external returns (uint amount0, uint amount1);\n\n    function swap(\n        uint amount0Out,\n        uint amount1Out,\n        address to,\n        bytes calldata data\n    ) external;\n\n    function skim(address to) external;\n\n    function sync() external;\n\n    function initialize(address, address) external;\n}\n\ninterface IUniswapV2Router01 {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    )\n        external\n        payable\n        returns (uint amountToken, uint amountETH, uint liquidity);\n\n    function removeLiquidity(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB);\n\n    function removeLiquidityETH(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountToken, uint amountETH);\n\n    function removeLiquidityWithPermit(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline,\n        bool approveMax,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) external returns (uint amountA, uint amountB);\n\n    function removeLiquidityETHWithPermit(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) external returns (uint amountToken, uint amountETH);\n\n    function swapExactTokensForTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n\n    function swapTokensForExactTokens(\n        uint amountOut,\n        uint amountInMax,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n\n    function swapExactETHForTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable returns (uint[] memory amounts);\n\n    function swapTokensForExactETH(\n        uint amountOut,\n        uint amountInMax,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n\n    function swapExactTokensForETH(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n\n    function swapETHForExactTokens(\n        uint amountOut,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable returns (uint[] memory amounts);\n\n    function quote(\n        uint amountA,\n        uint reserveA,\n        uint reserveB\n    ) external pure returns (uint amountB);\n\n    function getAmountOut(\n        uint amountIn,\n        uint reserveIn,\n        uint reserveOut\n    ) external pure returns (uint amountOut);\n\n    function getAmountIn(\n        uint amountOut,\n        uint reserveIn,\n        uint reserveOut\n    ) external pure returns (uint amountIn);\n\n    function getAmountsOut(\n        uint amountIn,\n        address[] calldata path\n    ) external view returns (uint[] memory amounts);\n\n    function getAmountsIn(\n        uint amountOut,\n        address[] calldata path\n    ) external view returns (uint[] memory amounts);\n}\n\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountETH);\n\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) external returns (uint amountETH);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n"
    },
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/ERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)\n\npragma solidity ^0.8.0;\n\nimport \"./IERC20.sol\";\nimport \"./extensions/IERC20Metadata.sol\";\nimport \"../../utils/Context.sol\";\n\n/**\n * @dev Implementation of the {IERC20} interface.\n *\n * This implementation is agnostic to the way tokens are created. This means\n * that a supply mechanism has to be added in a derived contract using {_mint}.\n * For a generic mechanism see {ERC20PresetMinterPauser}.\n *\n * TIP: For a detailed writeup see our guide\n * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How\n * to implement supply mechanisms].\n *\n * We have followed general OpenZeppelin Contracts guidelines: functions revert\n * instead returning `false` on failure. This behavior is nonetheless\n * conventional and does not conflict with the expectations of ERC20\n * applications.\n *\n * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n * This allows applications to reconstruct the allowance for all accounts just\n * by listening to said events. Other implementations of the EIP may not emit\n * these events, as it isn't required by the specification.\n *\n * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n * functions have been added to mitigate the well-known issues around setting\n * allowances. See {IERC20-approve}.\n */\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    /**\n     * @dev Sets the values for {name} and {symbol}.\n     *\n     * The default value of {decimals} is 18. To select a different value for\n     * {decimals} you should overload it.\n     *\n     * All two of these values are immutable: they can only be set once during\n     * construction.\n     */\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5.05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n     * overridden;\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _transfer(owner, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on\n     * `transferFrom`. This is semantically equivalent to an infinite approval.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * NOTE: Does not update the allowance if the current allowance\n     * is the maximum `uint256`.\n     *\n     * Requirements:\n     *\n     * - `from` and `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``from``'s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        address spender = _msgSender();\n        _spendAllowance(from, spender, amount);\n        _transfer(from, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\n        return true;\n    }\n\n    /**\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     * - `spender` must have allowance for the caller of at least\n     * `subtractedValue`.\n     */\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        uint256 currentAllowance = allowance(owner, spender);\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(owner, spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    /**\n     * @dev Moves `amount` of tokens from `from` to `to`.\n     *\n     * This internal function is equivalent to {transfer}, and can be used to\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\n     *\n     * Emits a {Transfer} event.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     */\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(from, to, amount);\n\n        uint256 fromBalance = _balances[from];\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[from] = fromBalance - amount;\n            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by\n            // decrementing then incrementing.\n            _balances[to] += amount;\n        }\n\n        emit Transfer(from, to, amount);\n\n        _afterTokenTransfer(from, to, amount);\n    }\n\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n     * the total supply.\n     *\n     * Emits a {Transfer} event with `from` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        unchecked {\n            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.\n            _balances[account] += amount;\n        }\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, reducing the\n     * total supply.\n     *\n     * Emits a {Transfer} event with `to` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     * - `account` must have at least `amount` tokens.\n     */\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n            // Overflow not possible: amount <= accountBalance <= totalSupply.\n            _totalSupply -= amount;\n        }\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n     *\n     * This internal function is equivalent to `approve`, and can be used to\n     * e.g. set automatic allowances for certain subsystems, etc.\n     *\n     * Emits an {Approval} event.\n     *\n     * Requirements:\n     *\n     * - `owner` cannot be the zero address.\n     * - `spender` cannot be the zero address.\n     */\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    /**\n     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.\n     *\n     * Does not update the allowance amount in case of infinite allowance.\n     * Revert if not enough allowance is available.\n     *\n     * Might emit an {Approval} event.\n     */\n    function _spendAllowance(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        uint256 currentAllowance = allowance(owner, spender);\n        if (currentAllowance != type(uint256).max) {\n            require(currentAllowance >= amount, \"ERC20: insufficient allowance\");\n            unchecked {\n                _approve(owner, spender, currentAllowance - amount);\n            }\n        }\n    }\n\n    /**\n     * @dev Hook that is called before any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * will be transferred to `to`.\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    /**\n     * @dev Hook that is called after any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * has been transferred to `to`.\n     * - when `from` is zero, `amount` tokens have been minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../IERC20.sol\";\n\n/**\n * @dev Interface for the optional metadata functions from the ERC20 standard.\n *\n * _Available since v4.1._\n */\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) external returns (bool);\n}\n"
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