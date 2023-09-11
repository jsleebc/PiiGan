{{
  "language": "Solidity",
  "sources": {
    "src/SONICFlattened.sol": {
      "content": "/*\n  Website: https://sonic.markets\n\n  Telegram: https://t.me/sonicportal\n\n       ___------__\n |\\__-- /\\       _-\n |/    __      -\n //\\  /  \\    /__\n |  o|  0|__     --_\n \\\\____-- __ \\   ___-\n (@@    __/  / /_\n    -_____---   --_\n     //  \\ \\\\   ___-\n   //|\\__/  \\\\  \\\n   \\_-\\_____/  \\-\\\n        // \\\\--\\|   <== The dev made this ASCII art all by himself! 🤭\n   ____//  ||_\n  /_____\\ /___\\\n______________________\n */\n\n// SPDX-License-Identifier: Unlicensed\npragma solidity ^0.8.13;\n\n// OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)\n\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby disabling any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\ninterface IUniswapV2Router01 {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n    function removeLiquidity(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETH(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountToken, uint amountETH);\n    function removeLiquidityWithPermit(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETHWithPermit(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountToken, uint amountETH);\n    function swapExactTokensForTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapTokensForExactTokens(\n        uint amountOut,\n        uint amountInMax,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n}\n\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountETH);\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountETH);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n\ninterface IUniswapV2Factory {\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n\n    function feeTo() external view returns (address);\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\n    function allPairs(uint) external view returns (address pair);\n    function allPairsLength() external view returns (uint);\n\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n\n    function setFeeTo(address) external;\n    function setFeeToSetter(address) external;\n}\n\ncontract SONIC is IERC20, Ownable {\n    string public constant _name = \"Sonic The Hedgehog\";\n    string public constant _symbol = \"SONIC\";\n    uint8 public constant _decimals = 9;\n\n    uint256 public constant _totalSupply = 100_000_000_000_000 * (10 ** _decimals);\n\n    mapping (address => uint256) public _balances;\n    mapping (address => mapping (address => uint256)) public _allowances;\n\n    mapping (address => bool) public noTax;\n    mapping (address => bool) public noMax;\n    mapping (address => bool) public dexPair;\n\n    mapping (address => bool) public blacklist;\n\n    uint256 public buyFeeTeam = 0;\n    uint256 public buyFeeLiqToken = 0;\n    uint256 public buyFee = 0;\n    uint256 public sellFeeTeam = 0;\n    uint256 public sellFeeLiqToken = 0;\n    uint256 public sellFee = 0;\n\n    uint256 private _tokensTeam = 0;\n    uint256 private _tokensLiqToken = 0;\n\n    address public walletTeam = msg.sender;\n    address public walletLiqToken = msg.sender;\n\n    address public immutable WETH;\n    IUniswapV2Router02 public immutable router;\n    address public pair;\n\n    uint256 public maxWallet = 2_500_000_000_000 * (10 ** _decimals);\n\n    bool private _swapping;\n\n    modifier swapping() {\n        _swapping = true;\n        _;\n        _swapping = false;\n    }\n\n    constructor () {\n        router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        WETH = router.WETH();\n        pair = IUniswapV2Factory(router.factory()).createPair(WETH, address(this));\n        _allowances[address(this)][address(router)] = _totalSupply;\n\n        noTax[msg.sender] = true;\n        noMax[msg.sender] = true;\n\n        dexPair[pair] = true;\n        noMax[pair] = true;\n\n        approve(address(router), _totalSupply);\n        approve(address(pair), _totalSupply);\n\n        _balances[msg.sender] = _totalSupply;\n        emit Transfer(address(0), msg.sender, _totalSupply);\n    }\n\n    function totalSupply() external pure override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function decimals() external pure returns (uint8) {\n        return _decimals;\n    }\n\n    function symbol() external pure returns (string memory) {\n        return _symbol;\n    }\n\n    function name() external pure returns (string memory) {\n        return _name;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _balances[account];\n    }\n\n    function allowance(address holder, address spender) external view override returns (uint256) {\n        return _allowances[holder][spender];\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _allowances[msg.sender][spender] = amount;\n        emit Approval(msg.sender, spender, amount);\n        return true;\n    }\n\n    function transfer(address recipient, uint256 amount) external override returns (bool) {\n        return _transferFrom(msg.sender, recipient, amount);\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\n        if (_allowances[sender][msg.sender] != _totalSupply) {\n            require(_allowances[sender][msg.sender] >= amount, \"Insufficient allowance\");\n            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;\n        }\n\n        return _transferFrom(sender, recipient, amount);\n    }\n\n    function _transferFrom(address sender, address recipient, uint256 amount) private returns (bool) {\n        require(!blacklist[sender] && !blacklist[recipient], \"Blacklisted\");\n        if (_swapping) return _basicTransfer(sender, recipient, amount);\n\n        address routerAddress = address(router);\n        bool _sell = dexPair[recipient] || recipient == routerAddress;\n\n        if (!_sell && !noMax[recipient]) require((_balances[recipient] + amount) < maxWallet, \"Max wallet triggered\");\n\n        if (_sell) {\n            if (!dexPair[msg.sender] && !_swapping && _balances[address(this)] >= 1_000_000_000) _sellTaxedTokens();\n        }\n\n        require(_balances[sender] >= amount, \"Insufficient balance\");\n        _balances[sender] = _balances[sender] - amount;\n\n        uint256 amountReceived = (((dexPair[sender] || sender == address(router)) || (dexPair[recipient]|| recipient == address(router))) ? !noTax[sender] && !noTax[recipient] : false) ? _collectTaxedTokens(sender, recipient, amount) : amount;\n\n        _balances[recipient] = _balances[recipient] + amountReceived;\n\n        emit Transfer(sender, recipient, amountReceived);\n        return true;\n    }\n\n    function _basicTransfer(address sender, address recipient, uint256 amount) private returns (bool) {\n        require(_balances[sender] >= amount, \"Insufficient balance\");\n        _balances[sender] = _balances[sender] - amount;\n        _balances[recipient] = _balances[recipient] + amount;\n        return true;\n    }\n\n    function _collectTaxedTokens(address sender, address receiver, uint256 amount) private returns (uint256) {\n        bool _sell = dexPair[receiver] || receiver == address(router);\n        uint256 _fee = _sell ? sellFee : buyFee;\n        uint256 _tax = amount * _fee / 10_000;\n\n        if (_fee > 0) {\n            if (_sell) {\n                if (sellFeeTeam > 0) _tokensTeam += _tax * sellFeeTeam / _fee;\n                if (sellFeeLiqToken > 0) _tokensLiqToken += _tax * sellFeeLiqToken / _fee;\n            } else {\n                if (buyFeeTeam > 0) _tokensTeam += _tax * buyFeeTeam / _fee;\n                if (buyFeeLiqToken > 0) _tokensLiqToken += _tax * buyFeeLiqToken / _fee;\n            }\n        }\n\n        _balances[address(this)] = _balances[address(this)] + _tax;\n        emit Transfer(sender, address(this), _tax);\n\n        return amount - _tax;\n    }\n\n    function _sellTaxedTokens() private swapping {\n        uint256 _tokens = _tokensTeam + _tokensLiqToken;\n\n        uint256 _liquidityTokensToSwapHalf = _tokensLiqToken / 2;\n        uint256 _swapInput = balanceOf(address(this)) - _liquidityTokensToSwapHalf;\n\n        uint256 _balanceSnapshot = address(this).balance;\n\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = WETH;\n        router.swapExactTokensForETHSupportingFeeOnTransferTokens(_swapInput, 0, path, address(this), block.timestamp);\n\n        uint256 _tax = address(this).balance - _balanceSnapshot;\n\n        uint256 _taxTeam = _tax * _tokensTeam / _tokens;\n        uint256 _taxLiqToken = _tax - _taxTeam;\n\n        _tokensTeam = 0;\n        _tokensLiqToken = 0;\n\n        if (_taxTeam > 0) payable(walletTeam).call{value: _taxTeam}(\"\");\n        if (_taxLiqToken > 0) router.addLiquidityETH{value: _taxLiqToken}(address(this), _liquidityTokensToSwapHalf, 0, 0, walletLiqToken, block.timestamp);\n    }\n\n    function changeDexPair(address _pair, bool _value) external onlyOwner {\n        dexPair[_pair] = _value;\n    }\n\n    function fetchDexPair(address _pair) external view returns (bool) {\n        return dexPair[_pair];\n    }\n\n    function changeNoTax(address _wallet, bool _value) external onlyOwner {\n        noTax[_wallet] = _value;\n    }\n\n    function fetchNoTax(address _wallet) external view returns (bool) {\n        return noTax[_wallet];\n    }\n\n    function changeNoMax(address _wallet, bool _value) external onlyOwner {\n        noMax[_wallet] = _value;\n    }\n\n    function fetchNoMax(address _wallet) external view onlyOwner returns (bool) {\n        return noMax[_wallet];\n    }\n\n    function changeBlacklist(address _wallet, bool _value) external onlyOwner {\n        blacklist[_wallet] = _value;\n    }\n\n    function fetchBlacklist(address _wallet) external view onlyOwner returns (bool) {\n        return blacklist[_wallet];\n    }\n\n    function fetchMaxWallet() external view returns (uint256) {\n        return maxWallet;\n    }\n\n    function changeMaxWallet(uint256 _maxWallet) external onlyOwner {\n        maxWallet = _maxWallet;\n    }\n\n    function changeFees(uint256 _buyFeeTeam, uint256 _buyFeeLiqToken, uint256 _sellFeeTeam, uint256 _sellFeeLiqToken) external onlyOwner {\n        buyFeeTeam = _buyFeeTeam;\n        buyFeeLiqToken = _buyFeeLiqToken;\n        buyFee = _buyFeeTeam + _buyFeeLiqToken;\n        sellFeeTeam = _sellFeeTeam;\n        sellFeeLiqToken = _sellFeeLiqToken;\n        sellFee = _sellFeeTeam + _sellFeeLiqToken;\n        require(buyFee <= 1000 && sellFee <= 1000);\n    }\n\n    function changeWallets(address _walletTeam, address _walletLiqToken) external onlyOwner {\n        walletTeam = _walletTeam;\n        walletLiqToken = _walletLiqToken;\n    }\n\n    function transferETH() external onlyOwner {\n        payable(msg.sender).call{value: address(this).balance}(\"\");\n    }\n\n    function transferERC(address token) external onlyOwner {\n        IERC20 Token = IERC20(token);\n        Token.transfer(msg.sender, Token.balanceOf(address(this)));\n    }\n\n    receive() external payable {}\n}\n\n"
    }
  },
  "settings": {
    "remappings": [
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "erc4626-tests/=lib/openzeppelin-contracts/lib/erc4626-tests/",
      "forge-std/=lib/forge-std/src/",
      "openzeppelin-contracts/=lib/openzeppelin-contracts/",
      "openzeppelin/=lib/openzeppelin-contracts/contracts/",
      "v2-core/=lib/v2-core/contracts/",
      "v2-periphery/=lib/v2-periphery/contracts/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "metadata": {
      "bytecodeHash": "ipfs"
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
    "evmVersion": "london",
    "libraries": {}
  }
}}