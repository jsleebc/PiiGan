{{
  "language": "Solidity",
  "sources": {
    "/contracts/Token.sol": {
      "content": "/**\n * \n * PRAGMAAI - Find Your Next Shitcoin\n * \n * https://t.me/pragma_ERC\n * https://twitter.com/AiPragma\n * https://pragmaai.tools\n * \n * Zero Tax\n * \n */\n// SPDX-License-Identifier: UNLICENSED\n\npragma solidity 0.8.17;\npragma experimental ABIEncoderV2;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(\n        address indexed previousOwner,\n        address indexed newOwner\n    );\n\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(\n            newOwner != address(0),\n            \"Ownable: new owner is the zero address\"\n        );\n        _transferOwnership(newOwner);\n    }\n\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    function allowance(\n        address owner,\n        address spender\n    ) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n}\n\ninterface IERC20Metadata is IERC20 {\n    function name() external view returns (string memory);\n\n    function symbol() external view returns (string memory);\n\n    function decimals() external view returns (uint8);\n}\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    /**\n     * @dev Sets the values for {name} and {symbol}.\n     *\n     * The default value of {decimals} is 18. To select a different value for\n     * {decimals} you should overload it.\n     *\n     * All two of these values are immutable: they can only be set once during\n     * construction.\n     */\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5.05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n     * overridden;\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(\n        address account\n    ) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `recipient` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(\n        address owner,\n        address spender\n    ) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(\n        address spender,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * Requirements:\n     *\n     * - `sender` and `recipient` cannot be the zero address.\n     * - `sender` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``sender``'s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(\n            currentAllowance >= amount,\n            \"ERC20: transfer amount exceeds allowance\"\n        );\n        unchecked {\n            _approve(sender, _msgSender(), currentAllowance - amount);\n        }\n\n        return true;\n    }\n\n    /**\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function increaseAllowance(\n        address spender,\n        uint256 addedValue\n    ) public virtual returns (bool) {\n        _approve(\n            _msgSender(),\n            spender,\n            _allowances[_msgSender()][spender] + addedValue\n        );\n        return true;\n    }\n\n    /**\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     * - `spender` must have allowance for the caller of at least\n     * `subtractedValue`.\n     */\n    function decreaseAllowance(\n        address spender,\n        uint256 subtractedValue\n    ) public virtual returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(\n            currentAllowance >= subtractedValue,\n            \"ERC20: decreased allowance below zero\"\n        );\n        unchecked {\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    /**\n     * @dev Moves `amount` of tokens from `sender` to `recipient`.\n     *\n     * This internal function is equivalent to {transfer}, and can be used to\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\n     *\n     * Emits a {Transfer} event.\n     *\n     * Requirements:\n     *\n     * - `sender` cannot be the zero address.\n     * - `recipient` cannot be the zero address.\n     * - `sender` must have a balance of at least `amount`.\n     */\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(\n            senderBalance >= amount,\n            \"ERC20: transfer amount exceeds balance\"\n        );\n        unchecked {\n            _balances[sender] = senderBalance - amount;\n        }\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n\n        _afterTokenTransfer(sender, recipient, amount);\n    }\n\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n     * the total supply.\n     *\n     * Emits a {Transfer} event with `from` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, reducing the\n     * total supply.\n     *\n     * Emits a {Transfer} event with `to` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     * - `account` must have at least `amount` tokens.\n     */\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n        }\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n     *\n     * This internal function is equivalent to `approve`, and can be used to\n     * e.g. set automatic allowances for certain subsystems, etc.\n     *\n     * Emits an {Approval} event.\n     *\n     * Requirements:\n     *\n     * - `owner` cannot be the zero address.\n     * - `spender` cannot be the zero address.\n     */\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    /**\n     * @dev Hook that is called before any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * will be transferred to `to`.\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    /**\n     * @dev Hook that is called after any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * has been transferred to `to`.\n     * - when `from` is zero, `amount` tokens have been minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n\n////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol\n// OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)\n\n/* pragma solidity ^0.8.0; */\n\n// CAUTION\n// This version of SafeMath should only be used with Solidity 0.8 or later,\n// because it relies on the compiler's built in overflow checks.\n\n/**\n * @dev Wrappers over Solidity's arithmetic operations.\n *\n * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler\n * now has built in overflow checking.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryAdd(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            uint256 c = a + b;\n            if (c < a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function trySub(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b > a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMul(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n            // benefit is lost if 'b' is also tested.\n            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryDiv(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMod(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `+` operator.\n     *\n     * Requirements:\n     *\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `*` operator.\n     *\n     * Requirements:\n     *\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator.\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting when dividing by zero.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n     * overflow (when the result is negative).\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {trySub}.\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b <= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a / b;\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting with custom message when dividing by zero.\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {tryMod}.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a % b;\n        }\n    }\n}\n\n////// src/IUniswapV2Factory.sol\n/* pragma solidity 0.8.10; */\n/* pragma experimental ABIEncoderV2; */\n\ninterface IUniswapV2Factory {\n    event PairCreated(\n        address indexed token0,\n        address indexed token1,\n        address pair,\n        uint256\n    );\n\n    function feeTo() external view returns (address);\n\n    function feeToSetter() external view returns (address);\n\n    function getPair(\n        address tokenA,\n        address tokenB\n    ) external view returns (address pair);\n\n    function allPairs(uint256) external view returns (address pair);\n\n    function allPairsLength() external view returns (uint256);\n\n    function createPair(\n        address tokenA,\n        address tokenB\n    ) external returns (address pair);\n\n    function setFeeTo(address) external;\n\n    function setFeeToSetter(address) external;\n}\n\n////// src/IUniswapV2Pair.sol\n/* pragma solidity 0.8.10; */\n/* pragma experimental ABIEncoderV2; */\n\ninterface IUniswapV2Pair {\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    function name() external pure returns (string memory);\n\n    function symbol() external pure returns (string memory);\n\n    function decimals() external pure returns (uint8);\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address owner) external view returns (uint256);\n\n    function allowance(\n        address owner,\n        address spender\n    ) external view returns (uint256);\n\n    function approve(address spender, uint256 value) external returns (bool);\n\n    function transfer(address to, uint256 value) external returns (bool);\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 value\n    ) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n\n    function nonces(address owner) external view returns (uint256);\n\n    function permit(\n        address owner,\n        address spender,\n        uint256 value,\n        uint256 deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) external;\n\n    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\n    event Burn(\n        address indexed sender,\n        uint256 amount0,\n        uint256 amount1,\n        address indexed to\n    );\n    event Swap(\n        address indexed sender,\n        uint256 amount0In,\n        uint256 amount1In,\n        uint256 amount0Out,\n        uint256 amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint256);\n\n    function factory() external view returns (address);\n\n    function token0() external view returns (address);\n\n    function token1() external view returns (address);\n\n    function getReserves()\n        external\n        view\n        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n\n    function price0CumulativeLast() external view returns (uint256);\n\n    function price1CumulativeLast() external view returns (uint256);\n\n    function kLast() external view returns (uint256);\n\n    function mint(address to) external returns (uint256 liquidity);\n\n    function burn(\n        address to\n    ) external returns (uint256 amount0, uint256 amount1);\n\n    function swap(\n        uint256 amount0Out,\n        uint256 amount1Out,\n        address to,\n        bytes calldata data\n    ) external;\n\n    function skim(address to) external;\n\n    function sync() external;\n\n    function initialize(address, address) external;\n}\n\n////// src/IUniswapV2Router02.sol\n/* pragma solidity 0.8.10; */\n/* pragma experimental ABIEncoderV2; */\n\ninterface IUniswapV2Router02 {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint256 amountADesired,\n        uint256 amountBDesired,\n        uint256 amountAMin,\n        uint256 amountBMin,\n        address to,\n        uint256 deadline\n    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);\n\n    function addLiquidityETH(\n        address token,\n        uint256 amountTokenDesired,\n        uint256 amountTokenMin,\n        uint256 amountETHMin,\n        address to,\n        uint256 deadline\n    )\n        external\n        payable\n        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external payable;\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n}\n\n/* pragma solidity >=0.8.10; */\n\n/* import {IUniswapV2Router02} from \"./IUniswapV2Router02.sol\"; */\n/* import {IUniswapV2Factory} from \"./IUniswapV2Factory.sol\"; */\n/* import {IUniswapV2Pair} from \"./IUniswapV2Pair.sol\"; */\n/* import {IERC20} from \"lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol\"; */\n/* import {ERC20} from \"lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol\"; */\n/* import {Ownable} from \"lib/openzeppelin-contracts/contracts/access/Ownable.sol\"; */\n/* import {SafeMath} from \"lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol\"; */\n\ncontract PragmaAi is ERC20, Ownable {\n    using SafeMath for uint256;\n\n    IUniswapV2Router02 public immutable uniswapV2Router;\n    address public immutable uniswapV2Pair;\n\n    bool private swapping;\n\n    address public marketingWallet;\n\n    uint256 public maxTransactionAmount;\n    uint256 public swapTokensAtAmount;\n    uint256 public maxWallet;\n\n    bool public limitsInEffect = true;\n    bool public launched = false;\n    bool public tradingActive = false;\n    bool public swapEnabled = false;\n\n    uint256 public buyTotalFees;\n    uint256 private buyMarketingFee;\n\n    uint256 public sellTotalFees;\n    uint256 public sellMarketingFee;\n\n    uint256 public tokensForMarketing;\n\n    // exlcude from fees and max transaction amount\n    mapping(address => bool) private _isExcludedFromFees;\n    mapping(address => bool) public _isExcludedMaxTransactionAmount;\n\n    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses\n    // could be subject to a maximum transfer amount\n    mapping(address => bool) public automatedMarketMakerPairs;\n\n    event UpdateUniswapV2Router(\n        address indexed newAddress,\n        address indexed oldAddress\n    );\n\n    event ExcludeFromFees(address indexed account, bool isExcluded);\n\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\n\n    event marketingWalletUpdated(\n        address indexed newWallet,\n        address indexed oldWallet\n    );\n\n    event SwapAndLiquify(\n        uint256 tokensSwapped,\n        uint256 ethReceived,\n        uint256 tokensIntoLiquidity\n    );\n\n    constructor() ERC20(\"Pragma Ai\", \"PRAGMA\") {\n\n        IUniswapV2Router02 _uniswapV2Rout = IUniswapV2Router02(\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\n        );\n\n        uniswapV2Router = _uniswapV2Rout;\n\n        excludeFromMaxTransaction(address(_uniswapV2Rout), true);\n\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Rout.factory()).createPair(address(this), _uniswapV2Rout.WETH());\n\n        excludeFromMaxTransaction(address(uniswapV2Pair), true);\n\n\n        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);\n\n        // TAXES 0/0 after Launch\n        uint256 _buyMarketingFee = 23;\n        uint256 _sellMarketingFee = 27;\n\n        uint256 totalSupply = 100_000_000_000 * 1e18;\n\n        maxTransactionAmount = 2_000_000_000 * 1e18;\n        maxWallet = 2_000_000_000 * 1e18;\n        swapTokensAtAmount = 1_000_000_000 * 1e18;\n\n        buyMarketingFee = _buyMarketingFee;\n        buyTotalFees = buyMarketingFee;\n\n        sellMarketingFee = _sellMarketingFee;\n        sellTotalFees = sellMarketingFee;\n\n        // Marketing wallet\n        marketingWallet = address(0x58B164f750b8bB8D8C87F7382D9E5A2A8C54a772); \n\n        // exclude from paying fees or having max transaction amount\n        excludeFromFees(owner(), true);\n        excludeFromFees(address(this), true);\n        excludeFromFees(address(0xdead), true);\n\n        excludeFromMaxTransaction(owner(), true);\n        excludeFromMaxTransaction(address(this), true);\n        excludeFromMaxTransaction(address(0xdead), true);\n\n        _mint(msg.sender, totalSupply);\n    }\n\n    receive() external payable {}\n\n    // once enabled, can never be turned off\n    function enableTrading() external onlyOwner {\n        tradingActive = true;\n        swapEnabled = true;\n    }\n\n    // remove limits after token is stable\n    function removeLimits() external onlyOwner returns (bool) {\n        limitsInEffect = false;\n        return true;\n    }\n\n    // change the minimum amount of tokens to sell from fees\n    function updateSwapTokensAtAmount(\n        uint256 newAmount\n    ) external onlyOwner returns (bool) {\n        require(\n            newAmount >= (totalSupply() * 1) / 100000,\n            \"Swap amount cannot be lower than 0.001% total supply.\"\n        );\n        require(\n            newAmount <= (totalSupply() * 5) / 1000,\n            \"Swap amount cannot be higher than 0.5% total supply.\"\n        );\n        swapTokensAtAmount = newAmount;\n        return true;\n    }\n\n    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {\n        require(\n            newNum >= ((totalSupply() * 1) / 1000) / 1e18,\n            \"Cannot set maxTransactionAmount lower than 0.1%\"\n        );\n        maxTransactionAmount = newNum * (10 ** 18);\n    }\n\n    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {\n        require(\n            newNum >= ((totalSupply() * 5) / 1000) / 1e18,\n            \"Cannot set maxWallet lower than 0.5%\"\n        );\n        maxWallet = newNum * (10 ** 18);\n    }\n\n    function excludeFromMaxTransaction(\n        address updAds,\n        bool isEx\n    ) public onlyOwner {\n        _isExcludedMaxTransactionAmount[updAds] = isEx;\n    }\n\n    // only use to disable contract sales if absolutely necessary (emergency use only)\n    function updateSwapEnabled(bool enabled) external onlyOwner {\n        swapEnabled = enabled;\n    }\n\n    function updateBuyFees(uint256 _marketingFee) external onlyOwner {\n        buyMarketingFee = _marketingFee;\n        buyTotalFees = buyMarketingFee;\n        require(buyTotalFees <= 23, \"Must keep fees at 23% or less\");\n    }\n\n    function updateSellFees(uint256 _marketingFee) external onlyOwner {\n        sellMarketingFee = _marketingFee;\n        sellTotalFees = sellMarketingFee;\n        require(sellTotalFees <= 27, \"Must keep fees at 27% or less\");\n    }\n\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\n        _isExcludedFromFees[account] = excluded;\n        emit ExcludeFromFees(account, excluded);\n    }\n\n    function manualswap(uint256 amount) external {\n        require(\n            amount <= balanceOf(address(this)) && amount > 0,\n            \"Wrong amount\"\n        );\n        swapTokensForEth(amount);\n    }\n\n    function manualsend() external {\n        bool success;\n        (success, ) = address(marketingWallet).call{\n            value: address(this).balance\n        }(\"\");\n    }\n\n    function setAutomatedMarketMakerPair(\n        address pair,\n        bool value\n    ) public onlyOwner {\n        require(\n            pair != uniswapV2Pair,\n            \"The pair cannot be removed from automatedMarketMakerPairs\"\n        );\n\n        _setAutomatedMarketMakerPair(pair, value);\n    }\n\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\n        automatedMarketMakerPairs[pair] = value;\n\n        emit SetAutomatedMarketMakerPair(pair, value);\n    }\n\n    function updateMarketingWallet(\n        address newMarketingWallet\n    ) external onlyOwner {\n        emit marketingWalletUpdated(newMarketingWallet, marketingWallet);\n        marketingWallet = newMarketingWallet;\n    }\n\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal override {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        if (amount == 0) {\n            super._transfer(from, to, 0);\n            return;\n        }\n\n        if (limitsInEffect) {\n            if (\n                from != owner() &&\n                to != owner() &&\n                to != address(0) &&\n                to != address(0xdead) &&\n                !swapping\n            ) {\n                if (!tradingActive) {\n                    require(\n                        _isExcludedFromFees[from] || _isExcludedFromFees[to],\n                        \"Trading is not active.\"\n                    );\n                }\n\n                //when buy\n                if (\n                    automatedMarketMakerPairs[from] &&\n                    !_isExcludedMaxTransactionAmount[to]\n                ) {\n                    require(\n                        amount <= maxTransactionAmount,\n                        \"Buy transfer amount exceeds the maxTransactionAmount.\"\n                    );\n                    require(\n                        amount + balanceOf(to) <= maxWallet,\n                        \"Max wallet exceeded\"\n                    );\n                }\n                //when sell\n                else if (\n                    automatedMarketMakerPairs[to] &&\n                    !_isExcludedMaxTransactionAmount[from]\n                ) {\n                    require(\n                        amount <= maxTransactionAmount,\n                        \"Sell transfer amount exceeds the maxTransactionAmount.\"\n                    );\n                } else if (!_isExcludedMaxTransactionAmount[to]) {\n                    require(\n                        amount + balanceOf(to) <= maxWallet,\n                        \"Max wallet exceeded\"\n                    );\n                }\n            }\n        }\n\n        uint256 contractTokenBalance = balanceOf(address(this));\n\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\n\n        if (\n            canSwap &&\n            swapEnabled &&\n            !swapping &&\n            !automatedMarketMakerPairs[from] &&\n            !_isExcludedFromFees[from] &&\n            !_isExcludedFromFees[to]\n        ) {\n            swapping = true;\n\n            swapBack();\n\n            swapping = false;\n        }\n\n        bool takeFee = !swapping;\n\n        // if any account belongs to _isExcludedFromFee account then remove the fee\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\n            takeFee = false;\n        }\n\n        uint256 fees = 0;\n        // only take fees on buys/sells, do not take on wallet transfers\n        if (takeFee) {\n            // on sell\n            if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {\n                fees = amount.mul(sellTotalFees).div(100);\n                tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;\n            }\n            // on buy\n            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {\n                fees = amount.mul(buyTotalFees).div(100);\n                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;\n            }\n\n            if (fees > 0) {\n                super._transfer(from, address(this), fees);\n            }\n\n            amount -= fees;\n        }\n\n        super._transfer(from, to, amount);\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private {\n        // generate the uniswap pair path of token -> weth\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // make the swap\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of ETH\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function swapBack() private {\n        uint256 contractBalance = balanceOf(address(this));\n        uint256 totalTokensToSwap = tokensForMarketing;\n        bool success;\n\n        if (contractBalance == 0 || totalTokensToSwap == 0) {\n            return;\n        }\n\n        if (contractBalance > swapTokensAtAmount * 20) {\n            contractBalance = swapTokensAtAmount * 20;\n        }\n\n        // Halve the amount of liquidity tokens\n\n        uint256 amountToSwapForETH = contractBalance;\n\n        swapTokensForEth(amountToSwapForETH);\n\n        tokensForMarketing = 0;\n\n        (success, ) = address(marketingWallet).call{\n            value: address(this).balance\n        }(\"\");\n    }\n}\n"
    }
  },
  "settings": {
    "remappings": [],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "evmVersion": "london",
    "libraries": {},
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