{{
  "language": "Solidity",
  "sources": {
    "kage/Kage.sol": {
      "content": "// Website:  https://www.kagemix.io/\r\n// Telegram: https://t.me/KAGEMIX\r\n// Twitter:  https://twitter.com/kagemix_io\r\n\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.17;\r\n\r\nimport \"@openzeppelin/contracts/utils/Context.sol\";\r\nimport \"@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol\";\r\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\r\nimport \"@openzeppelin/contracts/utils/math/SafeMath.sol\";\r\nimport \"./interfaces/IUniswapV2Factory.sol\";\r\nimport \"./interfaces/IUniswapV2Router02.sol\";\r\n\r\ncontract Kage is Context, IERC20, IERC20Metadata, Ownable {\r\n    using SafeMath for uint256;\r\n    mapping(address => uint256) private _balances;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n    string private constant _name = \"Kagemix\";\r\n    string private constant _symbol = \"KAGE\";\r\n\r\n    IUniswapV2Router02 private _uniswapV2Router;\r\n    address private uniswapV2Pair;\r\n    address payable private immutable _taxWallet;\r\n    mapping(address => bool) private _isExcludedFromFee;\r\n\r\n    uint8 private constant _decimals = 9;\r\n    uint32 public buyTax = 50000;\r\n    uint32 public sellTax = 200000;\r\n    uint256 private _totalSupply = 10 ** 9 * 10 ** _decimals;\r\n    uint256 public maxTrxnAmount = _totalSupply.mul(2).div(100);\r\n    uint256 public maxWalletSize = _totalSupply.mul(2).div(100);\r\n    bool private inSwap;\r\n\r\n    modifier lockTheSwap() {\r\n        inSwap = true;\r\n        _;\r\n        inSwap = false;\r\n    }\r\n\r\n    constructor(address uniswapRouter) {\r\n        require(uniswapRouter != address(0), \"UniswapRouter is the zero address\");\r\n\r\n        _uniswapV2Router = IUniswapV2Router02(uniswapRouter);\r\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(\r\n            address(this),\r\n            _uniswapV2Router.WETH()\r\n        );\r\n        _balances[owner()] = _totalSupply;\r\n        _isExcludedFromFee[owner()] = true;\r\n        _isExcludedFromFee[address(this)] = true;\r\n        _taxWallet = payable(_msgSender());\r\n    }\r\n\r\n    function name() public pure returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public pure returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public pure returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public view returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address to, uint256 amount) public returns (bool) {\r\n        address owner = _msgSender();\r\n        _transfer(owner, to, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public returns (bool) {\r\n        address owner = _msgSender();\r\n        _approve(owner, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address from, address to, uint256 amount) public returns (bool) {\r\n        address spender = _msgSender();\r\n        _spendAllowance(from, spender, amount);\r\n        _transfer(from, to, amount);\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\r\n        address owner = _msgSender();\r\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\r\n        address owner = _msgSender();\r\n        uint256 currentAllowance = allowance(owner, spender);\r\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\r\n        unchecked {\r\n            _approve(owner, spender, currentAllowance - subtractedValue);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function setBuyCommisioPercent(uint32 buyTaxPercent) external onlyOwner {\r\n        require(buyTaxPercent <= 50000, \"Buy tax restricted by 5%\");\r\n        buyTax = buyTaxPercent;\r\n    }\r\n\r\n    function setSellCommisioPercent(uint32 sellTaxPercent) external onlyOwner {\r\n        require(sellTaxPercent <= 50000, \"Sell tax restricted by 5%\");\r\n        sellTax = sellTaxPercent;\r\n    }\r\n\r\n    function ChangeWallletRestrictions(uint8 percent) external onlyOwner {\r\n        uint256 localtotalSupply = _totalSupply;\r\n        maxTrxnAmount = localtotalSupply.mul(percent).div(100);\r\n        maxWalletSize = localtotalSupply.mul(percent).div(100);\r\n    }\r\n\r\n    function redeemAllRestriction() external onlyOwner {\r\n        buyTax = 0;\r\n        sellTax = 0;\r\n        _transferOwnership(address(0));\r\n    }\r\n\r\n    function _transfer(address from, address to, uint256 amount) private {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n        address uniswapV2PairLocal = uniswapV2Pair;\r\n        IUniswapV2Router02 uniswapV2Router = _uniswapV2Router;\r\n        uint256 lMaxTrxnAmunt = maxTrxnAmount;\r\n        uint256 lMaxWalletSize = maxWalletSize;\r\n        uint32 lbuyTax = buyTax;\r\n        uint32 lsellTax = sellTax;\r\n        uint256 taxWalletBalance = _balances[address(this)];\r\n        bool isSelling;\r\n        uint256 taxAmount;\r\n\r\n        // Buy condition\r\n        if (lbuyTax > 0 && from == uniswapV2PairLocal && !_isExcludedFromFee[to]) {\r\n            require(amount <= lMaxTrxnAmunt, \"Exceeds the maxTrxnAmount.\");\r\n            require(balanceOf(to) + amount <= lMaxWalletSize, \"Exceeds the maxWalletSize.\");\r\n            taxAmount = amount.mul(lbuyTax).div(uint256(1e6));\r\n        }\r\n        // Sell Condition\r\n        else if (!inSwap && lsellTax > 0 && to == uniswapV2PairLocal && !_isExcludedFromFee[from]) {\r\n            taxAmount = amount.mul(lsellTax).div(uint256(1e6));\r\n            isSelling = true;\r\n        }\r\n\r\n        if (taxAmount > 0) {\r\n            amount = amount.sub(taxAmount);\r\n            taxWalletBalance = taxWalletBalance.add(taxAmount);\r\n            _balances[address(this)] = taxWalletBalance;\r\n        }\r\n\r\n        if (isSelling && taxWalletBalance > 0) {\r\n            swapTokensForEth(taxWalletBalance, address(uniswapV2Router));\r\n            uint256 currentETHBalance = address(this).balance;\r\n            if (currentETHBalance > 0) {\r\n                sendCommisionsToTeam(currentETHBalance);\r\n            }\r\n        }\r\n\r\n        uint256 fromBalance = _balances[from];\r\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\r\n        unchecked {\r\n            _balances[from] = fromBalance.sub(amount);\r\n            _balances[to] += amount;\r\n        }\r\n\r\n        emit Transfer(from, to, amount);\r\n    }\r\n\r\n    function _burn(address account, uint256 amount) private {\r\n        require(account != address(0), \"ERC20: burn from the zero address\");\r\n\r\n        uint256 accountBalance = _balances[account];\r\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\r\n        unchecked {\r\n            _balances[account] = accountBalance.sub(amount);\r\n            // Overflow not possible: amount <= accountBalance <= totalSupply.\r\n            _totalSupply -= amount;\r\n        }\r\n\r\n        emit Transfer(account, address(0), amount);\r\n    }\r\n\r\n    function _approve(address owner, address spender, uint256 amount) private {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _spendAllowance(address owner, address spender, uint256 amount) private {\r\n        uint256 currentAllowance = allowance(owner, spender);\r\n        if (currentAllowance != type(uint256).max) {\r\n            require(currentAllowance >= amount, \"ERC20: insufficient allowance\");\r\n            unchecked {\r\n                _approve(owner, spender, currentAllowance - amount);\r\n            }\r\n        }\r\n    }\r\n\r\n    function swapTokensForEth(uint256 tokenAmount, address uniswapV2RouterAddress) private lockTheSwap {\r\n        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(uniswapV2RouterAddress);\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function sendCommisionsToTeam(uint256 amount) private {\r\n        _taxWallet.transfer(amount);\r\n    }\r\n\r\n    receive() external payable {}\r\n}\r\n"
    },
    "kage/interfaces/IUniswapV2Router02.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.17;\r\n\r\nimport \"./IUniswapV2Router01.sol\";\r\n\r\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\r\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountETH);\r\n\r\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) external returns (uint amountETH);\r\n\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n"
    },
    "kage/interfaces/IUniswapV2Factory.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.17;\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\r\n\r\n    function feeTo() external view returns (address);\r\n\r\n    function feeToSetter() external view returns (address);\r\n\r\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\r\n\r\n    function allPairs(uint) external view returns (address pair);\r\n\r\n    function allPairsLength() external view returns (uint);\r\n\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n\r\n    function setFeeTo(address) external;\r\n\r\n    function setFeeToSetter(address) external;\r\n}\r\n"
    },
    "@openzeppelin/contracts/utils/math/SafeMath.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)\n\npragma solidity ^0.8.0;\n\n// CAUTION\n// This version of SafeMath should only be used with Solidity 0.8 or later,\n// because it relies on the compiler's built in overflow checks.\n\n/**\n * @dev Wrappers over Solidity's arithmetic operations.\n *\n * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler\n * now has built in overflow checking.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            uint256 c = a + b;\n            if (c < a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b > a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n            // benefit is lost if 'b' is also tested.\n            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `+` operator.\n     *\n     * Requirements:\n     *\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `*` operator.\n     *\n     * Requirements:\n     *\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator.\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting when dividing by zero.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n     * overflow (when the result is negative).\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {trySub}.\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        unchecked {\n            require(b <= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a / b;\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting with custom message when dividing by zero.\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {tryMod}.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a % b;\n        }\n    }\n}\n"
    },
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby disabling any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../IERC20.sol\";\n\n/**\n * @dev Interface for the optional metadata functions from the ERC20 standard.\n *\n * _Available since v4.1._\n */\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "kage/interfaces/IUniswapV2Router01.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.17;\r\n\r\ninterface IUniswapV2Router01 {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint amountADesired,\r\n        uint amountBDesired,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB, uint liquidity);\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n\r\n    function removeLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB);\r\n\r\n    function removeLiquidityETH(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountToken, uint amountETH);\r\n\r\n    function removeLiquidityWithPermit(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) external returns (uint amountA, uint amountB);\r\n\r\n    function removeLiquidityETHWithPermit(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) external returns (uint amountToken, uint amountETH);\r\n\r\n    function swapExactTokensForTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n\r\n    function swapTokensForExactTokens(\r\n        uint amountOut,\r\n        uint amountInMax,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n\r\n    function swapExactETHForTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint[] memory amounts);\r\n\r\n    function swapTokensForExactETH(\r\n        uint amountOut,\r\n        uint amountInMax,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n\r\n    function swapExactTokensForETH(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n\r\n    function swapETHForExactTokens(\r\n        uint amountOut,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint[] memory amounts);\r\n\r\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\r\n\r\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\r\n\r\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\r\n\r\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\r\n\r\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\r\n}\r\n"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n"
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