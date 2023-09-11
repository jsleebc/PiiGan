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
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(\r\n        address indexed token0,\r\n        address indexed token1,\r\n        address pair,\r\n        uint\r\n    );\r\n\r\n    function feeTo() external view returns (address);\r\n\r\n    function feeToSetter() external view returns (address);\r\n\r\n    function getPair(address tokenA, address tokenB)\r\n        external\r\n        view\r\n        returns (address pair);\r\n\r\n    function allPairs(uint) external view returns (address pair);\r\n\r\n    function allPairsLength() external view returns (uint);\r\n\r\n    function createPair(address tokenA, address tokenB)\r\n        external\r\n        returns (address pair);\r\n\r\n    function setFeeTo(address) external;\r\n\r\n    function setFeeToSetter(address) external;\r\n}"
    },
    "contracts/interfaces/IUniswapV2Pair.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\ninterface IUniswapV2Pair {\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint value\r\n    );\r\n    event Transfer(address indexed from, address indexed to, uint value);\r\n\r\n    function name() external pure returns (string memory);\r\n\r\n    function symbol() external pure returns (string memory);\r\n\r\n    function decimals() external pure returns (uint8);\r\n\r\n    function totalSupply() external view returns (uint);\r\n\r\n    function balanceOf(address owner) external view returns (uint);\r\n\r\n    function allowance(address owner, address spender)\r\n        external\r\n        view\r\n        returns (uint);\r\n\r\n    function approve(address spender, uint value) external returns (bool);\r\n\r\n    function transfer(address to, uint value) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address from,\r\n        address to,\r\n        uint value\r\n    ) external returns (bool);\r\n\r\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\r\n\r\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\r\n\r\n    function nonces(address owner) external view returns (uint);\r\n\r\n    function permit(\r\n        address owner,\r\n        address spender,\r\n        uint value,\r\n        uint deadline,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) external;\r\n\r\n    event Mint(address indexed sender, uint amount0, uint amount1);\r\n    event Burn(\r\n        address indexed sender,\r\n        uint amount0,\r\n        uint amount1,\r\n        address indexed to\r\n    );\r\n    event Swap(\r\n        address indexed sender,\r\n        uint amount0In,\r\n        uint amount1In,\r\n        uint amount0Out,\r\n        uint amount1Out,\r\n        address indexed to\r\n    );\r\n    event Sync(uint112 reserve0, uint112 reserve1);\r\n\r\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\r\n\r\n    function factory() external view returns (address);\r\n\r\n    function token0() external view returns (address);\r\n\r\n    function token1() external view returns (address);\r\n\r\n    function getReserves()\r\n        external\r\n        view\r\n        returns (\r\n            uint112 reserve0,\r\n            uint112 reserve1,\r\n            uint32 blockTimestampLast\r\n        );\r\n\r\n    function price0CumulativeLast() external view returns (uint);\r\n\r\n    function price1CumulativeLast() external view returns (uint);\r\n\r\n    function kLast() external view returns (uint);\r\n\r\n    function mint(address to) external returns (uint liquidity);\r\n\r\n    function burn(address to)\r\n        external\r\n        returns (uint amount0, uint amount1);\r\n\r\n    function swap(\r\n        uint amount0Out,\r\n        uint amount1Out,\r\n        address to,\r\n        bytes calldata data\r\n    ) external;\r\n\r\n    function skim(address to) external;\r\n\r\n    function sync() external;\r\n\r\n    function initialize(address, address) external;\r\n}"
    },
    "contracts/interfaces/IUniswapV2Router02.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint amountADesired,\r\n        uint amountBDesired,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    )\r\n        external\r\n        returns (\r\n            uint amountA,\r\n            uint amountB,\r\n            uint liquidity\r\n        );\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    )\r\n        external\r\n        payable\r\n        returns (\r\n            uint amountToken,\r\n            uint amountETH,\r\n            uint liquidity\r\n        );\r\n\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}"
    },
    "contracts/SingularityToken.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\n/*\r\n    (THE) SINGULARITY\r\n    $ZERO\r\n\r\n    Website: https://thiswillgotozero.com\r\n    Twitter: https://twitter.com/TWGT_ZERO\r\n    Telegram: https://t.me/thiswillgotozero\r\n */\r\n\r\nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\r\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\r\nimport \"@openzeppelin/contracts/utils/math/SafeMath.sol\";\r\n\r\nimport \"./interfaces/IUniswapV2Factory.sol\";\r\nimport \"./interfaces/IUniswapV2Router02.sol\";\r\nimport \"./interfaces/IUniswapV2Pair.sol\";\r\n\r\ncontract SingularityToken is IERC20, Ownable {\r\n    using SafeMath for uint;\r\n\r\n    uint private constant DECIMALS = 9;\r\n    uint private constant MAX_uint = ~uint(0);\r\n\r\n    IUniswapV2Router02 public immutable uniswapV2Router;\r\n    IUniswapV2Pair public immutable uniswapV2Pair;\r\n    address public immutable WETH;\r\n    \r\n    uint private constant REBASE_PERIOD = 6 hours;\r\n    uint private constant INITIAL_FRAGMENTS_SUPPLY = 1_000_000_000_000 * 10**DECIMALS;\r\n\r\n    // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.\r\n    // Use the highest value that fits in a uint for max granularity.\r\n    uint private constant TOTAL_GONS = MAX_uint - (MAX_uint % INITIAL_FRAGMENTS_SUPPLY);\r\n\r\n    // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2\r\n    uint private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1\r\n\r\n    uint public constant maxWallet = INITIAL_FRAGMENTS_SUPPLY / 100;\r\n    uint public currentEpoch = 1;\r\n    uint public lastEpochTimestamp;\r\n    uint private _totalSupply;\r\n    uint private _gonsPerFragment;\r\n    mapping(address => uint) private _gonBalances;\r\n\r\n    // This is denominated in Fragments, because the gons-fragments conversion might change before\r\n    // it's fully paid.\r\n    mapping (address => mapping (address => uint)) private _allowedFragments;\r\n\r\n    // Anti-bot and anti-whale mappings and variables\r\n    mapping(address => uint) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch\r\n    bool public limitsEnabled = true;\r\n\r\n    string private _name = \"Singularity\";\r\n    string private _symbol = \"ZERO\";\r\n    uint8 private _decimals = uint8(DECIMALS);\r\n\r\n    event LogRebase(uint indexed epoch, uint totalSupply);\r\n\r\n    modifier validRecipient(address to) {\r\n        require(to != address(0x0));\r\n        require(to != address(this));\r\n        _;\r\n    }\r\n\r\n    constructor()\r\n    {\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\r\n\r\n        address pair = IUniswapV2Factory(_uniswapV2Router.factory())\r\n            .createPair(address(this), WETH);\r\n            \r\n        uniswapV2Router = _uniswapV2Router;\r\n        uniswapV2Pair = IUniswapV2Pair(pair);\r\n\r\n        lastEpochTimestamp = 1686081600;\r\n\r\n        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;\r\n        _gonBalances[msg.sender] = TOTAL_GONS;\r\n        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\r\n        \r\n        emit Transfer(address(0x0), msg.sender, _totalSupply);\r\n    }\r\n\r\n        /**\r\n     * @dev Returns the name of the token.\r\n     */\r\n    function name() public view returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the symbol of the token, usually a shorter version of the\r\n     * name.\r\n     */\r\n    function symbol() public view returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the number of decimals used to get its user representation.\r\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\r\n     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\r\n     *\r\n     * Tokens usually opt for a value of 18, imitating the relationship between\r\n     * Ether and Wei.\r\n     *\r\n     * NOTE: This information is only used for _display_ purposes: it in\r\n     * no way affects any of the arithmetic of the contract, including\r\n     * {IERC20-balanceOf} and {IERC20-transfer}.\r\n     */\r\n    function decimals() public view returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    /**\r\n     * @return The total number of fragments.\r\n     */\r\n    function totalSupply()\r\n        external\r\n        view\r\n        returns (uint)\r\n    {\r\n        return _totalSupply;\r\n    }\r\n\r\n    /**\r\n     * @param who The address to query.\r\n     * @return The balance of the specified address.\r\n     */\r\n    function balanceOf(address who)\r\n        public\r\n        view\r\n        returns (uint)\r\n    {\r\n        return _gonBalances[who].div(_gonsPerFragment);\r\n    }\r\n\r\n    /**\r\n     * @dev Transfer tokens to a specified address.\r\n     * @param to The address to transfer to.\r\n     * @param value The amount to be transferred.\r\n     * @return True on success, false otherwise.\r\n     */\r\n    function transfer(address to, uint value)\r\n        external\r\n        validRecipient(to)\r\n        returns (bool)\r\n    {\r\n        if (limitsEnabled) {\r\n            if (\r\n                to != owner() &&\r\n                to != address(0x0) && \r\n                to != address(0xdead) &&\r\n                to != address(uniswapV2Router) &&\r\n                to != address(uniswapV2Pair)\r\n            ) {\r\n                require(\r\n                    _holderLastTransferTimestamp[msg.sender] <\r\n                        block.number,\r\n                    \"transfer:: Transfer Delay enabled. Only one purchase per block allowed.\"\r\n                );\r\n                _holderLastTransferTimestamp[msg.sender] = block.number;\r\n\r\n                require(\r\n                    value + balanceOf(to) <= maxWallet,\r\n                    \"transfer:: Max wallet exceeded\"\r\n                );\r\n            }\r\n        }\r\n\r\n        uint gonValue = value.mul(_gonsPerFragment);\r\n        _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);\r\n        _gonBalances[to] = _gonBalances[to].add(gonValue);\r\n        emit Transfer(msg.sender, to, value);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Transfer tokens from one address to another.\r\n     * @param from The address you want to send tokens from.\r\n     * @param to The address you want to transfer to.\r\n     * @param value The amount of tokens to be transferred.\r\n     */\r\n    function transferFrom(address from, address to, uint value)\r\n        external\r\n        validRecipient(to)\r\n        returns (bool)\r\n    {\r\n        if (limitsEnabled) {\r\n            if (\r\n                to != owner() &&\r\n                to != address(0x0) && \r\n                to != address(0xdead) &&\r\n                to != address(uniswapV2Router) &&\r\n                to != address(uniswapV2Pair)\r\n            ) {\r\n                require(\r\n                    _holderLastTransferTimestamp[from] <\r\n                        block.number,\r\n                    \"transfer:: Transfer Delay enabled. Only one purchase per block allowed.\"\r\n                );\r\n                _holderLastTransferTimestamp[from] = block.number;\r\n\r\n                require(\r\n                    value + balanceOf(to) <= maxWallet,\r\n                    \"transfer:: Max wallet exceeded\"\r\n                );\r\n            }\r\n        }\r\n\r\n        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);\r\n\r\n        uint gonValue = value.mul(_gonsPerFragment);\r\n        _gonBalances[from] = _gonBalances[from].sub(gonValue);\r\n        _gonBalances[to] = _gonBalances[to].add(gonValue);\r\n        emit Transfer(from, to, value);\r\n\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Function to check the amount of tokens that an owner has allowed to a spender.\r\n     * @param owner_ The address which owns the funds.\r\n     * @param spender The address which will spend the funds.\r\n     * @return The number of tokens still available for the spender.\r\n     */\r\n    function allowance(address owner_, address spender)\r\n        external\r\n        view\r\n        returns (uint)\r\n    {\r\n        return _allowedFragments[owner_][spender];\r\n    }\r\n\r\n    /**\r\n     * @dev Approve the passed address to spend the specified amount of tokens on behalf of\r\n     * msg.sender. This method is included for ERC20 compatibility.\r\n     * increaseAllowance and decreaseAllowance should be used instead.\r\n     * Changing an allowance with this method brings the risk that someone may transfer both\r\n     * the old and the new allowance - if they are both greater than zero - if a transfer\r\n     * transaction is mined before the later approve() call is mined.\r\n     *\r\n     * @param spender The address which will spend the funds.\r\n     * @param value The amount of tokens to be spent.\r\n     */\r\n    function approve(address spender, uint value)\r\n        external\r\n        returns (bool)\r\n    {\r\n        _allowedFragments[msg.sender][spender] = value;\r\n        emit Approval(msg.sender, spender, value);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Increase the amount of tokens that an owner has allowed to a spender.\r\n     * This method should be used instead of approve() to avoid the double approval vulnerability\r\n     * described above.\r\n     * @param spender The address which will spend the funds.\r\n     * @param addedValue The amount of tokens to increase the allowance by.\r\n     */\r\n    function increaseAllowance(address spender, uint addedValue)\r\n        external\r\n        returns (bool)\r\n    {\r\n        _allowedFragments[msg.sender][spender] =\r\n            _allowedFragments[msg.sender][spender].add(addedValue);\r\n        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Decrease the amount of tokens that an owner has allowed to a spender.\r\n     *\r\n     * @param spender The address which will spend the funds.\r\n     * @param subtractedValue The amount of tokens to decrease the allowance by.\r\n     */\r\n    function decreaseAllowance(address spender, uint subtractedValue)\r\n        external\r\n        returns (bool)\r\n    {\r\n        uint oldValue = _allowedFragments[msg.sender][spender];\r\n        if (subtractedValue >= oldValue) {\r\n            _allowedFragments[msg.sender][spender] = 0;\r\n        } else {\r\n            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);\r\n        }\r\n        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Notifies Fragments contract about a new rebase cycle.\r\n     * @return The total number of fragments after the supply adjustment.\r\n     */\r\n    function rebase()\r\n        external\r\n        returns (uint)\r\n    {\r\n        require(lastEpochTimestamp.add(REBASE_PERIOD) < block.timestamp,\r\n            \"rebase:: Too soon to trigger next rebase!\");\r\n\r\n        currentEpoch++;\r\n        lastEpochTimestamp = block.timestamp;\r\n        _totalSupply = _totalSupply.sub(_totalSupply / 2);\r\n        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\r\n        uniswapV2Pair.sync();\r\n\r\n        emit LogRebase(currentEpoch, _totalSupply);\r\n        return _totalSupply;\r\n    }\r\n\r\n    // disable Transfer delay - cannot be reenabled\r\n    function disableLimits() external onlyOwner returns (bool) {\r\n        limitsEnabled = false;\r\n        return true;\r\n    }\r\n}"
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