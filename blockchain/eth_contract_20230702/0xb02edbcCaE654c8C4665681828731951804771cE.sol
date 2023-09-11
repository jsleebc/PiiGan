{{
  "language": "Solidity",
  "sources": {
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) external returns (bool);\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/math/SafeMath.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)\n\npragma solidity ^0.8.0;\n\n// CAUTION\n// This version of SafeMath should only be used with Solidity 0.8 or later,\n// because it relies on the compiler's built in overflow checks.\n\n/**\n * @dev Wrappers over Solidity's arithmetic operations.\n *\n * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler\n * now has built in overflow checking.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            uint256 c = a + b;\n            if (c < a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b > a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n            // benefit is lost if 'b' is also tested.\n            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `+` operator.\n     *\n     * Requirements:\n     *\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `*` operator.\n     *\n     * Requirements:\n     *\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator.\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting when dividing by zero.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n     * overflow (when the result is negative).\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {trySub}.\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b <= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a / b;\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting with custom message when dividing by zero.\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {tryMod}.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a % b;\n        }\n    }\n}\n"
    },
    "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol": {
      "content": "pragma solidity >=0.5.0;\n\ninterface IUniswapV2Factory {\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n\n    function feeTo() external view returns (address);\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\n    function allPairs(uint) external view returns (address pair);\n    function allPairsLength() external view returns (uint);\n\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n\n    function setFeeTo(address) external;\n    function setFeeToSetter(address) external;\n}\n"
    },
    "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol": {
      "content": "pragma solidity >=0.6.2;\n\ninterface IUniswapV2Router01 {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n    function removeLiquidity(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETH(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountToken, uint amountETH);\n    function removeLiquidityWithPermit(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETHWithPermit(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountToken, uint amountETH);\n    function swapExactTokensForTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapTokensForExactTokens(\n        uint amountOut,\n        uint amountInMax,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n}\n"
    },
    "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol": {
      "content": "pragma solidity >=0.6.2;\n\nimport './IUniswapV2Router01.sol';\n\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountETH);\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountETH);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n"
    },
    "contracts/Degen.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.9;\nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\nimport \"@openzeppelin/contracts/utils/Context.sol\";\nimport \"@openzeppelin/contracts/utils/math/SafeMath.sol\";\nimport \"@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol\";\nimport \"@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol\";\n\n/**\nhttps://t.me/degencoinz\nhttps://twitter.com/degencoinz\n\n$DEGEN\n\n- Liquidity locked\n- Ownership renounced\n*/\n\ncontract Degen is Context, IERC20, Ownable {\n    using SafeMath for uint256;\n\n    string private constant _name = unicode\"Degen\";\n    string private constant _symbol = unicode\"DEGEN\";\n\n    mapping(address => uint256) private _rOwned;\n    mapping(address => uint256) private _tOwned;\n    mapping(address => mapping(address => uint256)) private _allowances;\n    mapping(address => bool) private _isExcludedFromFee;\n    uint8 private constant _decimals = 9;\n\n    uint256 private constant MAX = ~uint256(0);\n    uint256 private constant _tTotal = 133_333_337 * 10 ** _decimals;\n    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n    uint256 private _tFeeTotal;\n    uint256 private _redisFeeOnBuy = 0;\n    uint256 private _taxFeeOnBuy = 2;\n    uint256 private _redisFeeOnSell = 0;\n    uint256 private _taxFeeOnSell = 2;\n\n    uint256 private _redisFee = _redisFeeOnSell;\n    uint256 private _taxFee = _taxFeeOnSell;\n\n    uint256 private _previousredisFee = _redisFee;\n    uint256 private _previoustaxFee = _taxFee;\n\n    mapping(address => uint256) public _buyMap;\n    address payable private _developmentAddress =\n        payable(0xCCf931043a4C1c2CC254c63DCeca3330d6E7bbE6);\n    address payable private _marketingAddress =\n        payable(0xCCf931043a4C1c2CC254c63DCeca3330d6E7bbE6);\n\n    IUniswapV2Router02 public uniswapV2Router;\n    address public uniswapV2Pair;\n\n    bool private tradingOpen = true;\n    bool private inSwap = false;\n    bool private swapEnabled = true;\n\n    modifier lockTheSwap() {\n        inSwap = true;\n        _;\n        inSwap = false;\n    }\n\n    constructor() {\n        _rOwned[_msgSender()] = _rTotal;\n\n        _isExcludedFromFee[owner()] = true;\n        _isExcludedFromFee[address(this)] = true;\n        _isExcludedFromFee[_developmentAddress] = true;\n        _isExcludedFromFee[_marketingAddress] = true;\n\n        emit Transfer(address(0), _msgSender(), _tTotal);\n    }\n\n    function name() public pure returns (string memory) {\n        return _name;\n    }\n\n    function decimals() public pure returns (uint8) {\n        return _decimals;\n    }\n\n    function symbol() public pure returns (string memory) {\n        return _symbol;\n    }\n\n    function totalSupply() public pure override returns (uint256) {\n        return _tTotal;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return tokenFromReflection(_rOwned[account]);\n    }\n\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(\n        address owner,\n        address spender\n    ) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(\n        address spender,\n        uint256 amount\n    ) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(\n            sender,\n            _msgSender(),\n            _allowances[sender][_msgSender()].sub(\n                amount,\n                \"ERC20: transfer amount exceeds allowance\"\n            )\n        );\n        return true;\n    }\n\n    function addLiquidityAndLock(\n        uint256 tokenAmount,\n        uint256 ethAmount,\n        address lockContractAddress\n    ) external onlyOwner {\n        // Approve Uniswap router to transfer tokens\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // Add liquidity\n        (, , uint256 liquidity) = uniswapV2Router.addLiquidityETH{\n            value: ethAmount\n        }(address(this), tokenAmount, 0, 0, address(this), block.timestamp);\n\n        // Transfer LP tokens to the lock contract\n        IERC20(uniswapV2Pair).transfer(lockContractAddress, liquidity);\n    }\n\n    function tokenFromReflection(\n        uint256 rAmount\n    ) private view returns (uint256) {\n        require(\n            rAmount <= _rTotal,\n            \"Amount must be less than total reflections\"\n        );\n        uint256 currentRate = _getRate();\n        return rAmount.div(currentRate);\n    }\n\n    function removeAllFee() private {\n        if (_redisFee == 0 && _taxFee == 0) return;\n\n        _previousredisFee = _redisFee;\n        _previoustaxFee = _taxFee;\n\n        _redisFee = 0;\n        _taxFee = 0;\n    }\n\n    function restoreAllFee() private {\n        _redisFee = _previousredisFee;\n        _taxFee = _previoustaxFee;\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _transfer(address from, address to, uint256 amount) private {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n        require(\n            amount <= balanceOf(from),\n            \"Transfer amount exceeds sender's balance\"\n        );\n\n        if (from != owner() && to != owner()) {\n            //Trade start check\n            if (!tradingOpen) {\n                require(\n                    from == owner(),\n                    \"TOKEN: This account cannot send tokens until trading is enabled\"\n                );\n            }\n\n            uint256 contractTokenBalance = balanceOf(address(this));\n\n            if (\n                !inSwap &&\n                from != uniswapV2Pair &&\n                swapEnabled &&\n                !_isExcludedFromFee[from] &&\n                !_isExcludedFromFee[to]\n            ) {\n                swapTokensForEth(contractTokenBalance);\n                uint256 contractETHBalance = address(this).balance;\n                if (contractETHBalance > 0) {\n                    sendETHToFee(address(this).balance);\n                }\n            }\n        }\n\n        bool takeFee = true;\n\n        //Transfer Tokens\n        if (\n            (_isExcludedFromFee[from] || _isExcludedFromFee[to]) ||\n            (from != uniswapV2Pair && to != uniswapV2Pair)\n        ) {\n            takeFee = false;\n        } else {\n            //Set Fee for Buys\n            if (from == uniswapV2Pair && to != address(uniswapV2Router)) {\n                _redisFee = _redisFeeOnBuy;\n                _taxFee = _taxFeeOnBuy;\n            }\n\n            //Set Fee for Sells\n            if (to == uniswapV2Pair && from != address(uniswapV2Router)) {\n                _redisFee = _redisFeeOnSell;\n                _taxFee = _taxFeeOnSell;\n            }\n        }\n\n        _tokenTransfer(from, to, amount, takeFee);\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function sendETHToFee(uint256 amount) private {\n        _marketingAddress.transfer(amount);\n    }\n\n    //Camelot Dex Router 0xc873fEcbd354f5A56E00E710B90EF4201db2448d\n    function setTrading(bool _tradingOpen) public onlyOwner {\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\n        );\n        uniswapV2Router = _uniswapV2Router;\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\n            .createPair(address(this), _uniswapV2Router.WETH());\n        tradingOpen = _tradingOpen;\n    }\n\n    function manualswap() external {\n        require(\n            _msgSender() == _developmentAddress ||\n                _msgSender() == _marketingAddress\n        );\n        uint256 contractBalance = balanceOf(address(this));\n        swapTokensForEth(contractBalance);\n    }\n\n    function manualsend() external {\n        require(\n            _msgSender() == _developmentAddress ||\n                _msgSender() == _marketingAddress\n        );\n        uint256 contractETHBalance = address(this).balance;\n        sendETHToFee(contractETHBalance);\n    }\n\n    function _tokenTransfer(\n        address sender,\n        address recipient,\n        uint256 amount,\n        bool takeFee\n    ) private {\n        if (!takeFee) removeAllFee();\n        _transferStandard(sender, recipient, amount);\n        if (!takeFee) restoreAllFee();\n    }\n\n    function _transferStandard(\n        address sender,\n        address recipient,\n        uint256 tAmount\n    ) private {\n        (\n            uint256 rAmount,\n            uint256 rTransferAmount,\n            uint256 rFee,\n            uint256 tTransferAmount,\n            uint256 tFee,\n            uint256 tTeam\n        ) = _getValues(tAmount);\n        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);\n        _takeTeam(tTeam);\n        _reflectFee(rFee, tFee);\n        emit Transfer(sender, recipient, tTransferAmount);\n    }\n\n    function _takeTeam(uint256 tTeam) private {\n        uint256 currentRate = _getRate();\n        uint256 rTeam = tTeam.mul(currentRate);\n        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);\n    }\n\n    function _reflectFee(uint256 rFee, uint256 tFee) private {\n        _rTotal = _rTotal.sub(rFee);\n        _tFeeTotal = _tFeeTotal.add(tFee);\n    }\n\n    receive() external payable {}\n\n    function _getValues(\n        uint256 tAmount\n    )\n        private\n        view\n        returns (uint256, uint256, uint256, uint256, uint256, uint256)\n    {\n        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(\n            tAmount,\n            _redisFee,\n            _taxFee\n        );\n        uint256 currentRate = _getRate();\n        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(\n            tAmount,\n            tFee,\n            tTeam,\n            currentRate\n        );\n        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);\n    }\n\n    function _getTValues(\n        uint256 tAmount,\n        uint256 redisFee,\n        uint256 taxFee\n    ) private pure returns (uint256, uint256, uint256) {\n        uint256 tFee = tAmount.mul(redisFee).div(100);\n        uint256 tTeam = tAmount.mul(taxFee).div(100);\n        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);\n        return (tTransferAmount, tFee, tTeam);\n    }\n\n    function _getRValues(\n        uint256 tAmount,\n        uint256 tFee,\n        uint256 tTeam,\n        uint256 currentRate\n    ) private pure returns (uint256, uint256, uint256) {\n        uint256 rAmount = tAmount.mul(currentRate);\n        uint256 rFee = tFee.mul(currentRate);\n        uint256 rTeam = tTeam.mul(currentRate);\n        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);\n        return (rAmount, rTransferAmount, rFee);\n    }\n\n    function _getRate() private view returns (uint256) {\n        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n        return rSupply.div(tSupply);\n    }\n\n    function _getCurrentSupply() private view returns (uint256, uint256) {\n        uint256 rSupply = _rTotal;\n        uint256 tSupply = _tTotal;\n        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\n        return (rSupply, tSupply);\n    }\n\n    //Set minimum tokens required to swap.\n    function toggleSwap(bool _swapEnabled) public onlyOwner {\n        swapEnabled = _swapEnabled;\n    }\n}\n"
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
    },
    "libraries": {}
  }
}}