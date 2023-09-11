/**
* $FROGS (V2) - Fortune Rewards Our Green Species - by Outhouse Degens #SAFU #DYOR
* Twitter = @FrogsToken
* Telegram = https://t.me/FrogsTokenOfficial
* Website = https://www.frogstoken.com
*
* Contract can not be renounced or it will become a honeypot - see paymenthandler contract line 971 
**/

// SPDX-License-Identifier: MIT

// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol

pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol

pragma solidity >=0.6.2;


interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

//File: Safemath.sol

pragma solidity ^0.8.17;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/utils/Context.sol



pragma solidity ^0.8.17;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol



pragma solidity ^0.8.17;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.8.17;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol



pragma solidity ^0.8.17;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol



pragma solidity ^0.8.17;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

contract paymentHandler is Ownable {
    address admin = address(0xaF56a593c98b8fa2dCbB6C43Fe5874aDB13ae0E2);//Deployer wallet here
    address BUSD = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);// busd address here
    constructor (){
        IERC20(BUSD).approve(msg.sender, ~uint256(0));
    }
    function approveBUSD (address wallet, uint256 amount) external onlyOwner{
        IERC20(BUSD).approve(wallet, amount);
    }
    function withdrawERC20 (address wallet, IERC20 token) external  {
        require (msg.sender == admin, "you're not an admin");
        uint256 balance = token.balanceOf(address(this));
        token.transfer(wallet, balance);
    }
    
}

// File: FROGS.sol
pragma solidity ^0.8.18;


contract FROGS is ERC20, Ownable {
    using SafeMath for uint256;

    struct BuyFee {
        uint16 buyback;
        uint16 dev;
        uint16 autoLP;
    }

    struct SellFee {
        uint16 buyback;
        uint16 dev;
        uint16 autoLP;
        uint16 burn;
    }

    BuyFee public buyFee;
    SellFee public sellFee;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    bool private swapping;
    bool public isTradingEnabled;
    
   

    uint16 private totalBuyFee;
    uint16 private totalSellFee;

    address private  deadWallet = address(0x000000000000000000000000000000000000dEaD);

    address private constant MarvinToken = address (0x54017FDa0ff8f380CCEF600147A66D2e262d6B17);   // buybackToken
    address private constant BUSD = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56); //BUSD
   
    uint256 public swapTokensAtAmount = 2 * 10**6 * (10**18); 
    uint256 public maxTxAmount;
    uint256 public maxWallet;
    uint256 public maxSupply;
    uint256 public coolDown;

    address  public devWallet =address(0x49FBC4AD54E592556510A6C5D3d113F1aD255256); //dev wallet to receive BUSD
    address  public buybackWallet = address(0x000000000000000000000000000000000000dEaD);//buyback wallet to receive Marvin tokens
    address public BUSDhandler;
    
    // exlcude from fees,cooldown and max transaction amount
    mapping(address => bool) public _isExcludedFromFees;

    //track the buy/sell time to implement cooldown
    mapping(address => uint256) public _traded;
    //track sells timestamp for more than 2.5%
    mapping(address => uint256) public _24HourCooldown;
    //track 4hr priceimpact
    mapping(address => uint256) public priceImpactUser4Hr;
    // block temperary for 24 hours
    mapping (address => bool) public _isTempBlacklisted;

    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
    // could be subject to a maximum transfer amount
    mapping(address => bool) public automatedMarketMakerPairs;


    event UpdateUniswapV2Router(
        address indexed newRouter,
        address indexed oldRouter
    );

    event ExcludeFromFees(address indexed account, bool isExcluded);
    
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    event SwapAndLiquify(
        uint256 tokensIntoLiqudity,
        uint256 busdReceived
    );

    constructor() ERC20("Fortune Rewards Our Green Species", "FROGS") {
        

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E //PCS V2 router
        );

        
        // Create a pancakeswap pair for this new token
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), address(BUSD));

        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;
        BUSDhandler = address (new paymentHandler());

        buyFee.buyback = 1;
        buyFee.dev = 1;
        buyFee.autoLP = 1;
        
        totalBuyFee = buyFee.buyback + buyFee.dev + buyFee.autoLP;

        sellFee.buyback = 1;
        sellFee.dev = 2;
        sellFee.autoLP = 2;
        sellFee.burn = 1;
        totalSellFee =  sellFee.buyback + sellFee.dev  + sellFee.autoLP + sellFee.burn;

        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);

         IERC20(BUSD).approve(address(uniswapV2Router), ~uint256(0));
         coolDown = 20;
        

        // exclude from paying fees or having max transaction amount
        excludeFromFees(owner(),true);
        excludeFromFees(devWallet, true);
        excludeFromFees(deadWallet, true);
        excludeFromFees(address(this), true);

    
        _mint(owner(), 42 * 10**10 * (10**18)); //420,000,000,000 FROGS

        maxTxAmount = totalSupply().mul(1).div(100); // 1% per per transaction
        maxWallet = totalSupply().mul(3).div(100);// 3% of the supply per wallet limit
        maxSupply = 42 * 10**10 * (10**18); // 420,000,000,000 FROGS
    }

    receive() external payable {}


    function burn (uint256 amount) external {
        _transfer (msg.sender, address (0xdead), amount * 1e18);
}

    function updateRouter(address newAddress) external onlyOwner {
     require(newAddress != address(uniswapV2Router), "FROGS: The router already has that address");
      emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
            uniswapV2Router = IUniswapV2Router02(newAddress);
            address get_pair = IUniswapV2Factory(uniswapV2Router.factory()).getPair(address(this), address(BUSD));
        if (get_pair == address(0)) {
            uniswapV2Pair =
            IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this),
            address(BUSD));
      } else {
            uniswapV2Pair = get_pair;
        }

        
    }


    function claimStuckTokens(address _token) external onlyOwner {
        require(_token != address(this),"FROGS: No rug pulls");
        if (_token == address(0x0)) {
            payable(owner()).transfer(address(this).balance);
            return;
        }
        IERC20 erc20token = IERC20(_token);
        uint256 balance = erc20token.balanceOf(address(this));
        erc20token.transfer(owner(), balance);
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        require(
            _isExcludedFromFees[account] != excluded,
            "FROGS: Account is already excluded"
        );
        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);
    }

    function enabledTrading() external onlyOwner {
        isTradingEnabled = true;
    }

    


    function setWallets(address  _dev, address _buyback ) external onlyOwner {

        devWallet = _dev;
        buybackWallet = _buyback;
    }
                           
    function setBuyFees(
        uint16 _buyback,
        uint16 _dev,
        uint16 _autoLP
    ) external onlyOwner {
        buyFee.buyback = _buyback;
        buyFee.dev = _dev;
        buyFee.autoLP = _autoLP;

        totalBuyFee = buyFee.buyback + buyFee.dev  + buyFee.autoLP;
        require (totalBuyFee <=10, "Max buy Fees limit is 10 percent");
    }

    function setSellFees(
        uint16 _buyback,
        uint16 _dev,
        uint16 _autoLP,
        uint16 _burn
    ) external onlyOwner {
        sellFee.buyback = _buyback;
        sellFee.dev = _dev;
        sellFee.autoLP = _autoLP;
        sellFee.burn = _burn;

        totalSellFee = sellFee.buyback + sellFee.dev  + sellFee.autoLP + sellFee.burn;
        require (totalSellFee <=10, "Max sell Fees limit is 10 percent");
    }

    function setCoolDownTime (uint256 _newCoolDownInSeconds) external onlyOwner {
        require (_newCoolDownInSeconds <= 300, "Max CoolDown limit is 300 Seconds");
        coolDown = _newCoolDownInSeconds;
    }

    function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
        require(
            pair != uniswapV2Pair
        );

        _setAutomatedMarketMakerPair(pair, value);
    }


    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        require(
            automatedMarketMakerPairs[pair] != value
        );
        automatedMarketMakerPairs[pair] = value;

        
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function setSwapTokens(uint256 amount) external onlyOwner {
        swapTokensAtAmount = amount * 10**18;
    }

function _transfer(
    address from,
    address to,
    uint256 amount
) internal override {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");
    if (!_isExcludedFromFees[from]){
        require (isTradingEnabled, "Trading is not enabled yet");
    }

    // when 24 hours completes, user is removed from temp blacklist
    if(_isTempBlacklisted[from] && block.timestamp - _24HourCooldown[from] >= 24 hours){
        priceImpactUser4Hr[from] = 0;
        _isTempBlacklisted[from] = false;
    }
        require (!_isTempBlacklisted[from], "you're on time out anon");
        require (!_isTempBlacklisted[to],"We don't reward dumpers");
        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            canSwap &&
            !swapping &&
            !automatedMarketMakerPairs[from] &&
            from != owner() &&
            to != owner()
        ) {
            swapping = true;

            swapAndLiquify(contractTokenBalance);
           
            swapping = false;
        }

        bool takeFee = !swapping;

        // if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        if (takeFee) {


            uint256 fees;
            require(amount <= maxTxAmount,"FROGS: Amount exceeds transfer per transaction limit");
            if (!automatedMarketMakerPairs[to]) {
                require(
                    balanceOf(to) + amount <= maxWallet,
                    "FROGS: Balance exceeds Max Wallet limit"
                );
            }
            uint256 burnFee;
            
            if (automatedMarketMakerPairs[from]) {
                require ( block.timestamp - _traded[to] >= coolDown, "FROGS: cooldown Enabled");
                fees = amount.mul(totalBuyFee).div(100);
                _traded[to] = block.timestamp;
                
            } else if (automatedMarketMakerPairs[to]) {
                require ( block.timestamp - _traded[from] >= coolDown, "FROGS: cooldown Enabled");
                fees = amount.mul(totalSellFee).div(100);
                uint256 priceimpact = getPriceImpact(amount-fees);
                require (priceimpact < 30, "Price impact must be lower than 3 percent anon");
                manage24HourCooldown(from, amount-fees);
                burnFee = fees.mul(sellFee.burn)/totalSellFee;
                super._transfer(from, deadWallet, burnFee);
                _traded[from] = block.timestamp;
                
                
            }

            if (fees > 0) {
                amount = amount.sub(fees);
                super._transfer(from, address(this), fees - burnFee);
            }
        }

        super._transfer(from, to, amount);

    }

function manage24HourCooldown(address sender, uint256 amount) internal {
    if (sender != uniswapV2Pair && !_isTempBlacklisted[sender]) {
        // Get the timestamp of the current transaction
       

        // Calculate the price impact of the current transaction
        
        uint256 priceImpact = getPriceImpact(amount);

           if (priceImpact >= 25) {
               if(block.timestamp - _24HourCooldown[sender] > 14400){
             _24HourCooldown[sender] = block.timestamp;
               }
            priceImpactUser4Hr[sender] += priceImpact;
        }

        if(block.timestamp - _24HourCooldown[sender] < 14400 && priceImpactUser4Hr[sender] >=100){
            _isTempBlacklisted[sender] = true;
        }
        
    }
   
}    

function getPriceImpact(uint256 amountIn) public view returns (uint256 priceImpact) {
    // Get the reserves of Token A and Token B in the Uniswap V2 pair
    uint256 resA = IERC20(address(this)).balanceOf(uniswapV2Pair);
    uint256 resB = IERC20(BUSD).balanceOf(uniswapV2Pair);
    /// PriceBefore
    uint256 priceBefore = uniswapV2Router.getAmountOut(1 * 10**18, resA, resB);
    priceBefore  = priceBefore * amountIn;
    priceBefore = priceBefore / 1e18;
    /// priceAfter
    uint256 priceAfter = uniswapV2Router.getAmountOut(amountIn, resA, resB);

    // Calculate the price impact
    uint256 priceGap = (priceAfter * 1000) / priceBefore;
    return (1000 - priceGap);
}

    function setMaxTx (uint256 amount) external onlyOwner {
        require(amount * 10**18 >= (totalSupply().mul(10).div(1000)),"FROGS: Max Tx Limit can't go below 1% of the supply");
        maxTxAmount = amount * 10**18;
    }
  
    function setMaxWallet (uint256 amount) external onlyOwner {
        require (amount * 10**18 >= (totalSupply().mul(10).div(1000)), "FROGS: Max Wallet limit can't go below 1% of the supply");
        maxWallet = amount * 10**18;
    }
/// make sure trading is live and contract has some tokens
   function manualSwap () external onlyOwner {
     uint256 balance = balanceOf(address(this));
       swapAndLiquify(balance);
}
   
    function swapAndLiquify(uint256 tokens) private {
        uint256 initialBalance = IERC20(BUSD).balanceOf(address(this));
        uint256 totalFee = totalBuyFee + totalSellFee - sellFee.burn;
        uint256 swapTokens = tokens.mul(buyFee.buyback + sellFee.buyback + (buyFee.autoLP + sellFee.autoLP)/2
                                        + buyFee.dev + sellFee.dev)
                            .div(totalFee);
        uint256 liqTokens = tokens - swapTokens;

        // swapping tokens for BNB then for BUSD, as direct BUSD conversion is not allowed due to
        // require statement in pancakeswap factory. (as  _token0 and to become identical if try).
        // refer-- line number 430 
        // code line -- require(to != _token0 && to != _token1, 'Pancake: INVALID_TO');
        // code can be found here -- https://bscscan.com/address/0xca143ce32fe78f1f7019d7d551a6402fc5350c73#code

        
        //removing bnb for Marvin Buyback
        

        //swapping the remaining bnb to BUSD for Dev and Liquidity                                
        swapTokensForBUSD(swapTokens);
       uint256 balance = IERC20(BUSD).balanceOf(BUSDhandler);
      IERC20(BUSD).transferFrom(BUSDhandler, address(this), balance);
       
        uint256 newBalance = IERC20(BUSD).balanceOf(address(this)).sub(initialBalance);
        uint256 devPart    = newBalance.mul(buyFee.dev + sellFee.dev).div(totalFee);
        uint256 buybackPart = newBalance.mul(buyFee.buyback + sellFee.buyback).div(totalFee);
        uint256 liqPart    =  newBalance - devPart - buybackPart ;

        if (devPart > 0){                 
        IERC20(BUSD).transfer(devWallet, devPart); //transfer Fee to dev
        }
        if (liqPart > 0){
        addLiquidity(liqTokens, liqPart); // adding liquidity (FROGS, BUSD)
        emit SwapAndLiquify(liqTokens, liqPart);
        }
        if (buybackPart > 0) {
        buybackMarvin(buybackPart); //Buyback Marvin (Partnership buyback)
        }

    }


    
    
    function swapTokensForBUSD(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = BUSD;
        

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            BUSDhandler,
            block.timestamp
        );
    }

    

    function addLiquidity(uint256 tokenAmount, uint256 busdAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // add the liquidity
        uniswapV2Router.addLiquidity(
            address(this),
            BUSD,
            tokenAmount,
            busdAmount,
            0,
            0,
            deadWallet,
            block.timestamp
        );
    }

    function buybackMarvin(uint256 amount) private {
        address[] memory path = new address[](3);
        path[0] = BUSD;
        path[1] = uniswapV2Router.WETH();
        path[2] = MarvinToken;

        IERC20(BUSD).approve(address(uniswapV2Router), amount);

        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amount,
            0, // accept any amount of ETH
            path,
            deadWallet,
            block.timestamp
        );
    }

}