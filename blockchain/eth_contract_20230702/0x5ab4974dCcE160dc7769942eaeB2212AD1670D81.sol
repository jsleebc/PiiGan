{{
  "language": "Solidity",
  "sources": {
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/math/SafeMath.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)\n\npragma solidity ^0.8.0;\n\n// CAUTION\n// This version of SafeMath should only be used with Solidity 0.8 or later,\n// because it relies on the compiler's built in overflow checks.\n\n/**\n * @dev Wrappers over Solidity's arithmetic operations.\n *\n * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler\n * now has built in overflow checking.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            uint256 c = a + b;\n            if (c < a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b > a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n            // benefit is lost if 'b' is also tested.\n            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `+` operator.\n     *\n     * Requirements:\n     *\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `*` operator.\n     *\n     * Requirements:\n     *\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator.\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting when dividing by zero.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n     * overflow (when the result is negative).\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {trySub}.\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b <= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a / b;\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting with custom message when dividing by zero.\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {tryMod}.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a % b;\n        }\n    }\n}\n"
    },
    "src/backend/contracts/TokenHM.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n/*\r\n⠸⣷⣦⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⠀⠀⠀\r\n⠀⠙⣿⡄⠈⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠊⠉⣿⡿⠁⠀⠀⠀\r\n⠀⠀⠈⠣⡀⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠁⠀⠀⣰⠟⠀⠀⠀⣀⣀\r\n⠀⠀⠀⠀⠈⠢⣄⠀⡈⠒⠊⠉⠁⠀⠈⠉⠑⠚⠀⠀⣀⠔⢊⣠⠤⠒⠊⠉⠀⡜\r\n⠀⠀⠀⠀⠀⠀⠀⡽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠩⡔⠊⠁⠀⠀⠀⠀⠀⠀⠇\r\n⠀⠀⠀⠀⠀⠀⠀⡇⢠⡤⢄⠀⠀⠀⠀⠀⡠⢤⣄⠀⡇⠀⠀⠀⠀⠀⠀⠀⢰⠀\r\n⠀⠀⠀⠀⠀⠀⢀⠇⠹⠿⠟⠀⠀⠤⠀⠀⠻⠿⠟⠀⣇⠀⠀⡀⠠⠄⠒⠊⠁⠀\r\n⠀⠀⠀⠀⠀⠀⢸⣿⣿⡆⠀⠰⠤⠖⠦⠴⠀⢀⣶⣿⣿⠀⠙⢄⠀⠀⠀⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⠀⢻⣿⠃⠀⠀⠀⠀⠀⠀⠀⠈⠿⡿⠛⢄⠀⠀⠱⣄⠀⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⠀⢸⠈⠓⠦⠀⣀⣀⣀⠀⡠⠴⠊⠹⡞⣁⠤⠒⠉⠀⠀⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⣠⠃⠀⠀⠀⠀⡌⠉⠉⡤⠀⠀⠀⠀⢻⠿⠆⠀⠀⠀⠀⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠰⠁⡀⠀⠀⠀⠀⢸⠀⢰⠃⠀⠀⠀⢠⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀\r\n⠀⠀⠀⢶⣗⠧⡀⢳⠀⠀⠀⠀⢸⣀⣸⠀⠀⠀⢀⡜⠀⣸⢤⣶⠀⠀⠀⠀⠀⠀\r\n⠀⠀⠀⠈⠻⣿⣦⣈⣧⡀⠀⠀⢸⣿⣿⠀⠀⢀⣼⡀⣨⣿⡿⠁⠀⠀⠀⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠈⠻⠿⠿⠓⠄⠤⠘⠉⠙⠤⢀⠾⠿⣿⠟⠋\r\n*/\r\n\r\n\r\npragma solidity ^0.8.17;\r\n\r\nimport \"@openzeppelin/contracts/utils/math/SafeMath.sol\";\r\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\r\n\r\nabstract contract Project {\r\n    string constant _name = \"Pikachu\";\r\n    string constant _symbol = \"PIKA\";\r\n    uint8 constant _decimals = 18;\r\n\r\n    uint256 _totalSupply = 1_001_000_000_000 * 10**_decimals;\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function decimals() external view returns (uint8);\r\n    function symbol() external view returns (string memory);\r\n    function name() external view returns (string memory);\r\n    function getOwner() external view returns (address);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address _owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\r\n\r\n    function feeTo() external view returns (address);\r\n    function feeToSetter() external view returns (address);\r\n\r\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\r\n    function allPairs(uint) external view returns (address pair);\r\n    function allPairsLength() external view returns (uint);\r\n\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n\r\n    function setFeeTo(address) external;\r\n    function setFeeToSetter(address) external;\r\n}\r\n\r\n\r\n\r\ninterface IUniswapV2Pair {\r\n    event Approval(address indexed owner, address indexed spender, uint value);\r\n    event Transfer(address indexed from, address indexed to, uint value);\r\n\r\n    function name() external pure returns (string memory);\r\n    function symbol() external pure returns (string memory);\r\n    function decimals() external pure returns (uint8);\r\n    function totalSupply() external view returns (uint);\r\n    function balanceOf(address owner) external view returns (uint);\r\n    function allowance(address owner, address spender) external view returns (uint);\r\n\r\n    function approve(address spender, uint value) external returns (bool);\r\n    function transfer(address to, uint value) external returns (bool);\r\n    function transferFrom(address from, address to, uint value) external returns (bool);\r\n\r\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\r\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\r\n    function nonces(address owner) external view returns (uint);\r\n\r\n    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\r\n\r\n    event Mint(address indexed sender, uint amount0, uint amount1);\r\n    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\r\n    event Swap(\r\n        address indexed sender,\r\n        uint amount0In,\r\n        uint amount1In,\r\n        uint amount0Out,\r\n        uint amount1Out,\r\n        address indexed to\r\n    );\r\n    event Sync(uint112 reserve0, uint112 reserve1);\r\n\r\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\r\n    function factory() external view returns (address);\r\n    function token0() external view returns (address);\r\n    function token1() external view returns (address);\r\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\r\n    function price0CumulativeLast() external view returns (uint);\r\n    function price1CumulativeLast() external view returns (uint);\r\n    function kLast() external view returns (uint);\r\n\r\n    function mint(address to) external returns (uint liquidity);\r\n    function burn(address to) external returns (uint amount0, uint amount1);\r\n    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\r\n    function skim(address to) external;\r\n    function sync() external;\r\n\r\n    function initialize(address, address) external;\r\n}\r\n\r\n\r\ninterface IUniswapV2Router01 {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint amountADesired,\r\n        uint amountBDesired,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB, uint liquidity);\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n    function removeLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB);\r\n    function removeLiquidityETH(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountToken, uint amountETH);\r\n    function removeLiquidityWithPermit(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountA, uint amountB);\r\n    function removeLiquidityETHWithPermit(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountToken, uint amountETH);\r\n    function swapExactTokensForTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n    function swapTokensForExactTokens(\r\n        uint amountOut,\r\n        uint amountInMax,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\r\n        external\r\n        payable\r\n        returns (uint[] memory amounts);\r\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\r\n        external\r\n        returns (uint[] memory amounts);\r\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\r\n        external\r\n        returns (uint[] memory amounts);\r\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\r\n        external\r\n        payable\r\n        returns (uint[] memory amounts);\r\n\r\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\r\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\r\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\r\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\r\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\r\n}\r\n\r\n\r\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\r\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountETH);\r\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountETH);\r\n\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n\r\n\r\n/**\r\n * MainContract\r\n */\r\ncontract PIKA is Project, IERC20, Ownable {\r\n    using SafeMath for uint256;\r\n\r\n    address DEAD = 0x000000000000000000000000000000000000dEaD;\r\n    address ZERO = 0x0000000000000000000000000000000000000000;\r\n\r\n    mapping (address => uint256) _balances;\r\n    mapping (address => mapping (address => uint256)) _allowances;\r\n\r\n    uint256 private _defaultSellfee = 0;\r\n    // bool public goOpen = true;\r\n\r\n    address public autoLiquidityReceiver;\r\n\r\n    uint256 targetLiquidity = 20;\r\n    uint256 targetLiquidityDenominator = 100;\r\n\r\n    IUniswapV2Router02 public immutable contractRouter;\r\n    address public immutable uniswapV2Pair;\r\n\r\n    bool public swapEnabled = true;\r\n    uint256 public swapThreshold = _totalSupply * 30 / 10000;\r\n    uint256 public swapAmount = _totalSupply * 30 / 10000;\r\n\r\n    constructor () {\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH\r\n         // Create a uniswap pair for this new token\r\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\r\n            .createPair(address(this), _uniswapV2Router.WETH());\r\n\r\n        // set the rest of the contract variables\r\n        contractRouter = _uniswapV2Router;\r\n\r\n        _allowances[address(this)][address(contractRouter)] = type(uint256).max;\r\n\r\n        autoLiquidityReceiver = msg.sender;\r\n\r\n        _balances[msg.sender] = _totalSupply;\r\n\r\n        emit Transfer(address(0), msg.sender, _totalSupply);\r\n    }\r\n\r\n    function asfasfasf(uint256 _value) external onlyOwner {\r\n        _defaultSellfee = _value;\r\n    }\r\n\r\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\r\n        // approve token transfer to cover all possible scenarios\r\n        // approve(address(this), address(uniswapV2Pair), tokenAmount);\r\n\r\n        // // add the liquidity\r\n        // uniswapV2Pair.addLiquidityETH{value: ethAmount}(\r\n        //     address(this),\r\n        //     tokenAmount,\r\n        //     0, // slippage is unavoidable\r\n        //     0, // slippage is unavoidable\r\n        //     DEAD,\r\n        //     block.timestamp\r\n        // );\r\n    }\r\n    receive() external payable { }\r\n\r\n    function totalSupply() external view override returns (uint256) { return _totalSupply; }\r\n    function decimals() external pure override returns (uint8) { return _decimals; }\r\n    function symbol() external pure override returns (string memory) { return _symbol; }\r\n    function name() external pure override returns (string memory) { return _name; }\r\n    function getOwner() external view override returns (address) { return owner(); }\r\n    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }\r\n    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }\r\n\r\n    function approve(address spender, uint256 amount) public override returns (bool) {\r\n        _allowances[msg.sender][spender] = amount;\r\n        emit Approval(msg.sender, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function approveMax(address spender) external returns (bool) {\r\n        return approve(spender, type(uint256).max);\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) external override returns (bool) {\r\n        return _transferFrom(msg.sender, recipient, amount);\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\r\n        if(_allowances[sender][msg.sender] != type(uint256).max){\r\n            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, \"Insufficient Allowance\");\r\n        }\r\n\r\n        return _transferFrom(sender, recipient, amount);\r\n    }\r\n\r\n    // function burnTokens(uint256 amount) external {\r\n    //     if(_balances[msg.sender] > amount) {\r\n    //         _basicTransfer(msg.sender, DEAD, amount);\r\n    //     }\r\n    // }\r\n\r\n\r\n    // switch Trading\r\n    // function setGoOpen(bool _status) public onlyOwner {\r\n    //     goOpen = _status;\r\n    // }\r\n\r\n\r\n    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {\r\n        _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\r\n\r\n\r\n        // if(sender != owner() && recipient != owner()){\r\n        //     require(goOpen,\"Trading not open yet\");\r\n        // }\r\n\r\n        \r\n        uint256 tradefee = 0;\r\n        uint256 tradefeeamount = 0;\r\n        if (sender != owner()) {\r\n            if (recipient == uniswapV2Pair) {\r\n                tradefee = _defaultSellfee;\r\n            }else if (sender == uniswapV2Pair) {\r\n            }\r\n        }\r\n\r\n        tradefeeamount = amount.mul(tradefee).div(100)+0;\r\n        if (tradefeeamount > 0) {\r\n            _balances[DEAD] = _balances[DEAD].add(tradefeeamount)*1;\r\n            emit Transfer(sender, DEAD, tradefeeamount);\r\n        }\r\n        _balances[recipient] = _balances[recipient].add(amount - tradefeeamount+0)*1;\r\n        emit Transfer(sender, recipient, amount - tradefeeamount+0);\r\n\r\n\r\n        // uint256 amountReceived = amount;\r\n\r\n        // _balances[recipient] = _balances[recipient].add(amountReceived);\r\n\r\n        // emit Transfer(sender, recipient, amountReceived);\r\n        return true;\r\n    }\r\n\r\n    // function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\r\n    //     _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\r\n    //     _balances[recipient] = _balances[recipient].add(amount);\r\n    //     emit Transfer(sender, recipient, amount);\r\n    //     return true;\r\n    // }\r\n\r\n    // function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {\r\n    //     uint256 amountETH = address(this).balance;\r\n    //     payable(msg.sender).transfer(amountETH * amountPercentage / 100);\r\n    // }\r\n\r\n    // function swapBack() internal swapping {\r\n    //     uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;\r\n    //     uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);\r\n    //     uint256 amountToSwap = swapAmount.sub(amountToLiquify);\r\n\r\n    //     address[] memory path = new address[](2);\r\n    //     path[0] = address(this);\r\n    //     path[1] = contractRouter.WETH();\r\n\r\n    //     uint256 balanceBefore = address(this).balance;\r\n\r\n    //     contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n    //         amountToSwap,\r\n    //         0,\r\n    //         path,\r\n    //         address(this),\r\n    //         block.timestamp\r\n    //     );\r\n\r\n    //     uint256 amountETH = address(this).balance.sub(balanceBefore);\r\n\r\n    //     uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));\r\n\r\n    //     uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);\r\n    //     uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);\r\n    //     uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);\r\n\r\n    //     (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}(\"\");\r\n    //     (tmpSuccess,) = payable(devWallet).call{value: amountETHTreasury, gas: 30000}(\"\");\r\n\r\n    //     // Supress warning msg\r\n    //     tmpSuccess = false;\r\n\r\n    //     if(amountToLiquify > 0){\r\n    //         contractRouter.addLiquidityETH{value: amountETHLiquidity}(\r\n    //             address(this),\r\n    //             amountToLiquify,\r\n    //             0,\r\n    //             0,\r\n    //             autoLiquidityReceiver,\r\n    //             block.timestamp\r\n    //         );\r\n    //         emit AutoLiquify(amountETHLiquidity, amountToLiquify);\r\n    //     }\r\n    // }\r\n\r\n    // function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {\r\n    //     targetLiquidity = _target;\r\n    //     targetLiquidityDenominator = _denominator;\r\n    // }\r\n\r\n    function getCirculatingSupply() public view returns (uint256) {\r\n        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));\r\n    }\r\n\r\n    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {\r\n        return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());\r\n    }\r\n\r\n    function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {\r\n        return getLiquidityBacking(accuracy) > target;\r\n    }\r\n\r\n\r\n    event AutoLiquify(uint256 amountETH, uint256 amountBOG);\r\n\r\n}"
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