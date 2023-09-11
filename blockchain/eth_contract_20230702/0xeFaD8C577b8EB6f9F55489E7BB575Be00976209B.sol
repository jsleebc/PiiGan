{{
  "language": "Solidity",
  "sources": {
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby disabling any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/math/SafeMath.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)\n\npragma solidity ^0.8.0;\n\n// CAUTION\n// This version of SafeMath should only be used with Solidity 0.8 or later,\n// because it relies on the compiler's built in overflow checks.\n\n/**\n * @dev Wrappers over Solidity's arithmetic operations.\n *\n * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler\n * now has built in overflow checking.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            uint256 c = a + b;\n            if (c < a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b > a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n            // benefit is lost if 'b' is also tested.\n            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `+` operator.\n     *\n     * Requirements:\n     *\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `*` operator.\n     *\n     * Requirements:\n     *\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator.\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting when dividing by zero.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n     * overflow (when the result is negative).\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {trySub}.\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        unchecked {\n            require(b <= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a / b;\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting with custom message when dividing by zero.\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {tryMod}.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a % b;\n        }\n    }\n}\n"
    },
    "contracts/interfaces/IUniswapV2Factory.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ninterface IUniswapV2Factory {\n    event PairCreated(\n        address indexed token0,\n        address indexed token1,\n        address pair,\n        uint\n    );\n\n    function feeTo() external view returns (address);\n\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB)\n        external\n        view\n        returns (address pair);\n\n    function allPairs(uint) external view returns (address pair);\n\n    function allPairsLength() external view returns (uint);\n\n    function createPair(address tokenA, address tokenB)\n        external\n        returns (address pair);\n\n    function setFeeTo(address) external;\n\n    function setFeeToSetter(address) external;\n}"
    },
    "contracts/interfaces/IUniswapV2Pair.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ninterface IUniswapV2Pair {\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint value\n    );\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function name() external pure returns (string memory);\n\n    function symbol() external pure returns (string memory);\n\n    function decimals() external pure returns (uint8);\n\n    function totalSupply() external view returns (uint);\n\n    function balanceOf(address owner) external view returns (uint);\n\n    function allowance(address owner, address spender)\n        external\n        view\n        returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n\n    function transfer(address to, uint value) external returns (bool);\n\n    function transferFrom(\n        address from,\n        address to,\n        uint value\n    ) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n\n    function nonces(address owner) external view returns (uint);\n\n    function permit(\n        address owner,\n        address spender,\n        uint value,\n        uint deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) external;\n\n    event Mint(address indexed sender, uint amount0, uint amount1);\n    event Burn(\n        address indexed sender,\n        uint amount0,\n        uint amount1,\n        address indexed to\n    );\n    event Swap(\n        address indexed sender,\n        uint amount0In,\n        uint amount1In,\n        uint amount0Out,\n        uint amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\n\n    function factory() external view returns (address);\n\n    function token0() external view returns (address);\n\n    function token1() external view returns (address);\n\n    function getReserves()\n        external\n        view\n        returns (\n            uint112 reserve0,\n            uint112 reserve1,\n            uint32 blockTimestampLast\n        );\n\n    function price0CumulativeLast() external view returns (uint);\n\n    function price1CumulativeLast() external view returns (uint);\n\n    function kLast() external view returns (uint);\n\n    function mint(address to) external returns (uint liquidity);\n\n    function burn(address to)\n        external\n        returns (uint amount0, uint amount1);\n\n    function swap(\n        uint amount0Out,\n        uint amount1Out,\n        address to,\n        bytes calldata data\n    ) external;\n\n    function skim(address to) external;\n\n    function sync() external;\n\n    function initialize(address, address) external;\n}"
    },
    "contracts/interfaces/IUniswapV2Router02.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ninterface IUniswapV2Router02 {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    )\n        external\n        returns (\n            uint amountA,\n            uint amountB,\n            uint liquidity\n        );\n\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    )\n        external\n        payable\n        returns (\n            uint amountToken,\n            uint amountETH,\n            uint liquidity\n        );\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}"
    },
    "contracts/PandemoniumToken.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\n/*\n    PANDEMONIUM\n    $CHAOS\n\n    Website: https://pandemonium.wtf\n    Twitter: https://twitter.com/Chaotic_DeFi\n    Telegram: https://t.me/chaoticdefi\n */\n\nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\nimport \"@openzeppelin/contracts/utils/math/SafeMath.sol\";\n\nimport \"./interfaces/IUniswapV2Factory.sol\";\nimport \"./interfaces/IUniswapV2Router02.sol\";\nimport \"./interfaces/IUniswapV2Pair.sol\";\n\ncontract PandemoniumToken is IERC20, Ownable {\n    using SafeMath for uint;\n\n    uint private constant internalDecimals = 10**24;\n    uint private constant BASE = 10**18;\n    uint public scalingFactor;\n    uint public initSupply;\n\n    IUniswapV2Router02 public immutable uniswapV2Router;\n    IUniswapV2Pair public immutable uniswapV2Pair;\n    address public immutable WETH;\n    \n    uint private constant REBASE_PERIOD = 1 hours; // 1 hour between rebases\n    uint public maxRebasePercentage = 50;\n\n    address public vault;\n    uint public currentEpoch;\n    uint public lastEpochTimestamp;\n    \n    uint private constant INIT_SUPPLY = 1_000_000 * 10**18;\n    uint public constant maxWallet = INIT_SUPPLY / 100;\n\n    uint private _totalSupply;\n    mapping (address => uint) internal _supplyBalances;\n    mapping (address => mapping(address => uint)) internal _allowedFragments;\n\n    // Anti-bot and anti-whale mappings and variables\n    mapping(address => uint) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch\n    mapping(address => bool) private _isExcluded;\n    bool public limitsEnabled = true;\n\n    string private _name = \"Pandemonium\";\n    string private _symbol = \"CHAOS\";\n    uint8 private _decimals = uint8(18);\n\n    /**\n     * @notice Event emitted when tokens are rebased\n     */\n    event Rebase(\n        uint epoch,\n        uint prefix,\n        uint percentage,\n        uint prevScalingFactor,\n        uint newScalingFactor\n    );\n\n    event Mint(address to, uint amount);\n    event Burn(address from, uint amount);\n\n    modifier validRecipient(address to) {\n        require(to != address(0x0));\n        require(to != address(this));\n        _;\n    }\n\n    modifier onlyVault() {\n        require(msg.sender == vault);\n        _;\n    }\n\n    constructor()\n    {\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n\n        address pair = IUniswapV2Factory(_uniswapV2Router.factory())\n            .createPair(address(this), WETH);\n            \n        uniswapV2Router = _uniswapV2Router;\n        uniswapV2Pair = IUniswapV2Pair(pair);\n\n        lastEpochTimestamp = 1687467600;\n\n        scalingFactor = BASE;\n        initSupply = _fragmentsToSupply(INIT_SUPPLY);\n        _totalSupply = INIT_SUPPLY;\n        _supplyBalances[owner()] = initSupply;\n        \n        emit Transfer(address(0x0), msg.sender, INIT_SUPPLY);\n    }\n\n        /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei.\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n\n    /**\n     * @return The total number of fragments.\n     */\n    function totalSupply()\n        external\n        view\n        returns (uint)\n    {\n        return _totalSupply;\n    }\n\n    /**\n     * @param who The address to query.\n     * @return The balance of the specified address.\n     */\n    function balanceOf(address who) public view returns (uint) {\n        return _supplyToFragments(_supplyBalances[who]);\n    }\n\n    function mint(address to, uint amount) external onlyVault returns (bool) {\n        _mint(to, amount);\n        return true;\n    }\n\n    function _mint(address to, uint amount) internal {\n        _totalSupply = _totalSupply.add(amount);\n        uint supplyValue = _fragmentsToSupply(amount);\n\n        initSupply = initSupply.add(supplyValue);\n\n        require(\n            scalingFactor <= _maxScalingFactor(),\n            \"max scaling factor too low\"\n        );\n\n        _supplyBalances[to] = _supplyBalances[to].add(supplyValue);\n\n        emit Mint(to, amount);\n        emit Transfer(address(0), to, amount);\n    }\n\n    function burn(uint amount) external onlyVault returns (bool) {\n        _burn(amount);\n        return true;\n    }\n\n    function _burn(uint amount) internal {\n        _totalSupply = _totalSupply.sub(amount);\n        uint supplyValue = _fragmentsToSupply(amount);\n\n        initSupply = initSupply.sub(supplyValue);\n        _supplyBalances[msg.sender] = _supplyBalances[msg.sender].sub(supplyValue);\n\n        emit Burn(msg.sender, amount);\n        emit Transfer(msg.sender, address(0), amount);\n    }\n\n    /**\n     * @dev Transfer tokens to a specified address.\n     * @param to The address to transfer to.\n     * @param value The amount to be transferred.\n     * @return True on success, false otherwise.\n     */\n    function transfer(address to, uint value)\n        external\n        validRecipient(to)\n        returns (bool)\n    {\n        if (limitsEnabled) {\n            if (\n                to != owner() &&\n                to != address(0x0) && \n                to != address(0xdead) &&\n                to != address(uniswapV2Router) &&\n                to != address(uniswapV2Pair) &&\n                !(_isExcluded[msg.sender] || _isExcluded[to])\n            ) {\n                require(\n                    _holderLastTransferTimestamp[msg.sender] <\n                        block.number,\n                    \"transfer:: Transfer Delay enabled. Only one purchase per block allowed.\"\n                );\n                _holderLastTransferTimestamp[msg.sender] = block.number;\n\n                require(\n                    value + balanceOf(to) <= maxWallet,\n                    \"transfer:: Max wallet exceeded\"\n                );\n            }\n        }\n\n        uint supplyValue = _fragmentsToSupply(value);\n        _supplyBalances[msg.sender] = _supplyBalances[msg.sender].sub(supplyValue);\n        _supplyBalances[to] = _supplyBalances[to].add(supplyValue);\n\n        emit Transfer(msg.sender, to, value);\n        return true;\n    }\n\n    /**\n     * @dev Transfer tokens from one address to another.\n     * @param from The address you want to send tokens from.\n     * @param to The address you want to transfer to.\n     * @param value The amount of tokens to be transferred.\n     */\n    function transferFrom(address from, address to, uint value)\n        external\n        validRecipient(to)\n        returns (bool)\n    {\n        if (limitsEnabled) { \n            if (\n                to != owner() &&\n                to != address(0x0) && \n                to != address(0xdead) &&\n                to != address(uniswapV2Router) &&\n                to != address(uniswapV2Pair) &&\n                !(_isExcluded[from] || _isExcluded[to])\n            ) {\n                require(\n                    _holderLastTransferTimestamp[msg.sender] <\n                        block.number,\n                    \"transfer:: Transfer Delay enabled. Only one purchase per block allowed.\"\n                );\n                _holderLastTransferTimestamp[msg.sender] = block.number;\n\n                require(\n                    value + balanceOf(to) <= maxWallet,\n                    \"transfer:: Max wallet exceeded\"\n                );\n            }\n        }\n\n        _allowedFragments[from][msg.sender] = _allowedFragments[from][\n            msg.sender\n        ].sub(value);\n\n        uint supplyValue = _fragmentsToSupply(value);\n        _supplyBalances[from] = _supplyBalances[from].sub(supplyValue);\n        _supplyBalances[to] = _supplyBalances[to].add(supplyValue);\n\n        emit Transfer(from, to, value);\n        return true;\n    }\n\n    /**\n     * @dev Function to check the amount of tokens that an owner has allowed to a spender.\n     * @param owner_ The address which owns the funds.\n     * @param spender The address which will spend the funds.\n     * @return The number of tokens still available for the spender.\n     */\n    function allowance(address owner_, address spender)\n        external\n        view\n        returns (uint)\n    {\n        return _allowedFragments[owner_][spender];\n    }\n\n    /**\n     * @dev Approve the passed address to spend the specified amount of tokens on behalf of\n     * msg.sender. This method is included for ERC20 compatibility.\n     * increaseAllowance and decreaseAllowance should be used instead.\n     * Changing an allowance with this method brings the risk that someone may transfer both\n     * the old and the new allowance - if they are both greater than zero - if a transfer\n     * transaction is mined before the later approve() call is mined.\n     *\n     * @param spender The address which will spend the funds.\n     * @param value The amount of tokens to be spent.\n     */\n    function approve(address spender, uint value)\n        external\n        returns (bool)\n    {\n        _allowedFragments[msg.sender][spender] = value;\n        emit Approval(msg.sender, spender, value);\n        return true;\n    }\n\n    /**\n     * @dev Increase the amount of tokens that an owner has allowed to a spender.\n     * This method should be used instead of approve() to avoid the double approval vulnerability\n     * described above.\n     * @param spender The address which will spend the funds.\n     * @param addedValue The amount of tokens to increase the allowance by.\n     */\n    function increaseAllowance(address spender, uint addedValue)\n        external\n        returns (bool)\n    {\n        _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][\n            spender\n        ].add(addedValue);\n        emit Approval(\n            msg.sender,\n            spender,\n            _allowedFragments[msg.sender][spender]\n        );\n        return true;\n    }\n\n    /**\n     * @dev Decrease the amount of tokens that an owner has allowed to a spender.\n     *\n     * @param spender The address which will spend the funds.\n     * @param subtractedValue The amount of tokens to decrease the allowance by.\n     */\n    function decreaseAllowance(address spender, uint subtractedValue)\n        external\n        returns (bool)\n    {\n        uint oldValue = _allowedFragments[msg.sender][spender];\n        if (subtractedValue >= oldValue) {\n            _allowedFragments[msg.sender][spender] = 0;\n        } else {\n            _allowedFragments[msg.sender][spender] = oldValue.sub(\n                subtractedValue\n            );\n        }\n        emit Approval(\n            msg.sender,\n            spender,\n            _allowedFragments[msg.sender][spender]\n        );\n        return true;\n    }\n\n    /**\n     * @dev Notifies Fragments contract about a new rebase cycle.\n     * @return The total number of fragments after the supply adjustment.\n     */\n    function rebase()\n        external\n        returns (uint)\n    {\n        require(lastEpochTimestamp.add(REBASE_PERIOD) < block.timestamp,\n            \"rebase:: Too soon to trigger next rebase!\");\n\n        uint nonce = random();\n        uint prefix = nonce % 2;\n        uint percentage = nonce % maxRebasePercentage;\n        if (percentage == 0) percentage = maxRebasePercentage;\n\n        currentEpoch++;\n        lastEpochTimestamp = block.timestamp;\n        uint prevScalingFactor = scalingFactor;\n\n        if (prefix == 1) {\n            // positive rebase\n            uint newScalingFactor = scalingFactor\n                .mul(BASE.add(BASE.mul(percentage).div(100)))\n                .div(BASE);\n\n            if (newScalingFactor < _maxScalingFactor()) {\n                scalingFactor = newScalingFactor;\n            } else {\n                scalingFactor = _maxScalingFactor();\n            }\n        } else {\n            // negative rebase\n            scalingFactor = scalingFactor\n                .mul(BASE.sub(BASE.mul(percentage).div(100)))\n                .div(BASE);\n        }\n\n        _totalSupply = _supplyToFragments(initSupply);\n        uniswapV2Pair.sync();\n\n        emit Rebase(\n            currentEpoch, \n            prefix,\n            percentage,\n            prevScalingFactor, \n            scalingFactor\n        );\n        return _totalSupply;\n    }\n\n    function canRebase() external view returns (bool) {\n        return lastEpochTimestamp.add(REBASE_PERIOD) < block.timestamp;\n    }\n\n    function toggleLimits() external onlyOwner returns (bool) {\n        limitsEnabled = !limitsEnabled;\n        return true;\n    }\n\n    // for token airdrop\n    function excludeAddress(address _address) external onlyOwner {\n        _isExcluded[_address] = true;\n    }\n\n    function setVault(address _vault) external onlyOwner {\n        vault = _vault;\n    }\n\n    function setMaxRebase(uint percentage) external onlyOwner {\n        require (percentage <= 50,\n            \"Max rebase percentage must be lte than 50\");\n\n        maxRebasePercentage = percentage;\n    }\n\n    function random() internal view returns (uint) {\n        return uint(\n            keccak256(\n                abi.encodePacked(\n                    block.timestamp, \n                    block.difficulty,\n                    currentEpoch, \n                    scalingFactor\n                )\n            )\n        );\n    }\n\n    /** VIEWS */\n\n    function maxScalingFactor() external view returns (uint) {\n        return _maxScalingFactor();\n    }\n\n    function _maxScalingFactor() internal view returns (uint) {\n        return uint(int256(-1)) / initSupply;\n    }\n\n    function _fragmentsToSupply(uint amount) internal view returns (uint) {\n        return amount.mul(internalDecimals).div(scalingFactor);\n    }\n\n    function _supplyToFragments(uint amount) internal view returns (uint) {\n        return amount.mul(scalingFactor).div(internalDecimals);\n    }\n}"
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