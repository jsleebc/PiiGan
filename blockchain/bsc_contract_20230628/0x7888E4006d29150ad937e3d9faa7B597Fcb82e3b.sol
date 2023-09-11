// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
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
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
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


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
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


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


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
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;


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


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;




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
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
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
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
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
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
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
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
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
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
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
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
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
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
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

// File: ETXEToken.sol



pragma solidity ^0.8.0;




interface IUniswapV2Pair {
    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function sync() external;
}

interface ISwapRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface ETXENft {
    function counter() external returns (uint256);

    function ownerOf(uint256 tokenId) external returns (address);
}

interface Warp {
    function withdraw() external returns (bool);
}

abstract contract AbcToken is ERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => bool) private _feeList;
    mapping(address => bool) private _inhibitList;
    mapping(address => bool) private _permitList;
    mapping(address => bool) private _swapPairList;

    ISwapRouter private _swapRouter;
    Warp private warp;
    ETXENft nft;

    bool private permitRobot;
    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);

    mapping(uint256 => uint256) private oneUsdtEqualsToToken;
    uint256 private recordStartTime;

    uint256 private _fundFee = 200;
    uint256 private _marketingFee = 100;
    uint256 private _communityFee = 100;
    uint256 private _technologyFee = 100;
    uint256 private _nftDividendFee = 200;

    uint256 private _transferFee = 1000;

    uint256 private tokensToSwap = 1000 * 10**18;

    uint256 private pairTokenLimit;

    address public mainPair;
    address private baseToken;

    address private tokenOwner;
    address private lpAddress;
    address private fundAddress;
    address private marketAddress;
    address private communityAddress;
    address private technologyAddress;
    address private deadWallet = 0x000000000000000000000000000000000000dEaD;

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(
        address RouterAddress,
        address BaseToken,
        string memory Name,
        string memory Symbol,
        uint256 Supply,
        address TokenOwner,
        address LPAddress,
        address FundAddress,
        address MarketAddress,
        address CommunityAddress,
        address TechnologyAddress
    ) ERC20(Name, Symbol) {
        baseToken = BaseToken;
        tokenOwner = TokenOwner;
        lpAddress = LPAddress;
        fundAddress = FundAddress;
        marketAddress = MarketAddress;
        communityAddress = CommunityAddress;
        technologyAddress = TechnologyAddress;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        _swapRouter = swapRouter;
        _approve(address(this), address(swapRouter), MAX);
        ERC20(BaseToken).approve(address(swapRouter), MAX);

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(BaseToken, address(this));
        mainPair = swapPair;
        _swapPairList[swapPair] = true;

        _mint(TokenOwner, Supply.mul(70).div(100));
        _mint(LPAddress, Supply.mul(30).div(100));

        _feeList[TokenOwner] = true;
        _feeList[LPAddress] = true;
        _feeList[address(this)] = true;
        _feeList[address(swapRouter)] = true;

        _permitList[swapPair] = true;
        _permitList[address(swapRouter)] = true;

        excludeHolder[address(0)] = true;
        excludeHolder[address(deadWallet)] = true;

        require(address(this) > BaseToken);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(
            permitRobot || !isContract(msg.sender) || _permitList[msg.sender],
            "ERC20: robot call"
        );
        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");
        require(!_inhibitList[from], "inhibitList");
        require(amount > 0, "amountIsZero");

        if (!_feeList[from] && !_feeList[to]) {
            uint256 maxSellAmount = balance.mul(9999).div(10000);
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
        }

        bool takeSwapFee;
        bool takeTransferFee;

        if (!_feeList[from] && !_feeList[to]) {
            if (_swapPairList[from] || _swapPairList[to]) {
                if (_swapPairList[to]) {
                    if (balanceOf(address(this)) > tokensToSwap) {
                        swapToken(tokensToSwap, address(warp));
                        warp.withdraw();
                    }
                }

                takeSwapFee = true;
            } else {
                takeTransferFee = true;
            }
        }

        _tokenTransfer(from, to, amount, takeSwapFee, takeTransferFee);

        if (_swapPairList[from] || _swapPairList[to]) {
            (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(mainPair)
                .getReserves();

            if (reserve0 > 0 && reserve1 > 0) {
                if (recordStartTime == 0) {
                    recordStartTime = block.timestamp;
                }

                uint256 index = block.timestamp.div(24 hours).sub(
                    recordStartTime.div(24 hours)
                );
                oneUsdtEqualsToToken[index] = reserve1.mul(10**18).div(
                    reserve0
                );
            }
        }

        if (from != address(this) && !_feeList[from]) {
            processReward(500000);
        }
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeSwapFee,
        bool takeTransferFee
    ) private {
        uint256 feeAmount;

        if (takeSwapFee) {
            uint256 fundFee = tAmount.mul(_fundFee).div(10000);
            uint256 marketingFee = tAmount.mul(_marketingFee).div(10000);
            uint256 communityFee = tAmount.mul(_communityFee).div(10000);
            uint256 technologyFee = tAmount.mul(_technologyFee).div(10000);
            uint256 nftDividendFee = tAmount.mul(_nftDividendFee).div(10000);

            if (fundFee > 0) {
                feeAmount += fundFee;
                _takeTransfer(sender, fundAddress, fundFee);
            }
            if (marketingFee > 0) {
                feeAmount += marketingFee;
                _takeTransfer(sender, marketAddress, marketingFee);
            }
            if (communityFee > 0) {
                feeAmount += communityFee;
                _takeTransfer(sender, communityAddress, communityFee);
            }
            if (technologyFee > 0) {
                feeAmount += technologyFee;
                _takeTransfer(sender, technologyAddress, technologyFee);
            }
            if (nftDividendFee > 0) {
                feeAmount += nftDividendFee;
                _takeTransfer(sender, address(this), nftDividendFee);
            }
        } else if (takeTransferFee) {
            uint256 transferFee = (tAmount * _transferFee) / 10000;

            if (transferFee > 0) {
                feeAmount += transferFee;
                _takeTransfer(sender, mainPair, feeAmount);
                IUniswapV2Pair(mainPair).sync();
            }
        }

        _takeTransfer(sender, recipient, tAmount.sub(feeAmount));

        if (_swapPairList[sender] || _swapPairList[recipient]) {
            uint256 tokenAmount = balanceOf(mainPair);

            if (takeSwapFee && tokenAmount < pairTokenLimit) {
                _takeTransfer(
                    lpAddress,
                    mainPair,
                    pairTokenLimit.sub(tokenAmount)
                );
            }
        }
    }

    function swapToken(uint256 tokenAmount, address to) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = baseToken;

        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            to,
            block.timestamp
        );
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
    ) private {
        super._transfer(sender, to, tAmount);
    }

    function _supplementTokensToPair(uint256 tokens) private {
        _takeTransfer(lpAddress, mainPair, tokens);
        IUniswapV2Pair(mainPair).sync();
    }

    function supplementTokensToPair(uint256 tokens) external {
        require(tokenOwner == msg.sender || lpAddress == msg.sender);
        _supplementTokensToPair(tokens);
    }

    function setETXENft(address _nft) external onlyOwner {
        nft = ETXENft(_nft);
    }

    function setSwapWarp(address _warp) external onlyOwner {
        warp = Warp(_warp);
    }

    function setTokensToSwap(uint256 tokens) external onlyOwner {
        tokensToSwap = tokens;
    }

    function setFeeList(address addr, bool isList) external onlyOwner {
        _feeList[addr] = isList;
    }

    function setInhibitList(address account, bool inhibit) external onlyOwner {
        _inhibitList[account] = inhibit;
    }

    function setMultipleInhibitList(address[] calldata accounts, bool inhibit)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < accounts.length; i++) {
            _inhibitList[accounts[i]] = inhibit;
        }
    }

    function setPermitList(address account, bool permit) external {
        require(tokenOwner == msg.sender || owner() == msg.sender);
        _permitList[account] = permit;
    }

    function setPermitRobot(bool permit) external {
        require(tokenOwner == msg.sender || owner() == msg.sender);
        permitRobot = permit;
    }

    function rescueToken(uint256 tokens) external {
        require(msg.sender == tokenOwner);
        ERC20(baseToken).transfer(msg.sender, tokens);
    }

    function setFundFee(uint256 fee) external onlyOwner {
        _fundFee = fee;
    }

    function setMarketingFee(uint256 fee) external onlyOwner {
        _marketingFee = fee;
    }

    function setCommunityFee(uint256 fee) external onlyOwner {
        _communityFee = fee;
    }

    function setTechnologyFee(uint256 fee) external onlyOwner {
        _technologyFee = fee;
    }

    function setNftDividendFee(uint256 fee) external onlyOwner {
        _nftDividendFee = fee;
    }

    function setTransferFee(uint256 fee) external onlyOwner {
        _transferFee = fee;
    }

    function setPairTokenLimit(uint256 limit) external onlyOwner {
        pairTokenLimit = limit;
    }

    receive() external payable {}

    mapping(address => bool) excludeHolder;
    uint256 private currentIndex = 1;
    uint256 private holderRewardCondition = 1000 * 10**18;
    uint256 private progressRewardBlock;

    function processReward(uint256 gas) private {
        if (progressRewardBlock + 100 > block.number) {
            return;
        }

        ERC20 USDT = ERC20(baseToken);

        uint256 balance = USDT.balanceOf(address(this));
        if (balance < holderRewardCondition) {
            return;
        }

        uint256 holdTokenTotal = nft.counter();

        address shareHolder;
        uint256 amount;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        while (gasUsed < gas && iterations < holdTokenTotal) {
            if (currentIndex > holdTokenTotal) {
                currentIndex = 1;
            }

            shareHolder = nft.ownerOf(currentIndex);
            if (!excludeHolder[shareHolder]) {
                amount = balance.div(holdTokenTotal);
                if (amount > 0) {
                    USDT.transfer(shareHolder, amount);
                }
            }

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = block.number;
    }

    function setHolderRewardCondition(uint256 amount) external {
        require(msg.sender == tokenOwner || msg.sender == owner());
        holderRewardCondition = amount;
    }

    function setExcludeHolder(address addr, bool enable) external {
        require(msg.sender == tokenOwner || msg.sender == owner());
        excludeHolder[addr] = enable;
    }

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    function getTokenPriceSum(uint256 start, uint256 end)
        external
        view
        returns (uint256 tokenPriceSum)
    {
        if (start > end) return 0;
        start = start > recordStartTime ? start : recordStartTime;
        start = start.div(24 hours).sub(recordStartTime.div(24 hours));
        end = end.div(24 hours).sub(recordStartTime.div(24 hours));

        uint256 price;
        uint256 i;

        for (i = start; i < end; i++) {
            price = getTokenPriceByIndex(i);
            tokenPriceSum = tokenPriceSum.add(price);
        }

        return tokenPriceSum;
    }

    function getTokenPriceByOneDay(uint256 dayTime)
        external
        view
        returns (uint256)
    {
        if (dayTime < recordStartTime) return 0;

        uint256 index = dayTime.div(24 hours).sub(
            recordStartTime.div(24 hours)
        );

        uint256 i;

        for (i = index; i >= 0; i--) {
            if (oneUsdtEqualsToToken[i] > 0) {
                return oneUsdtEqualsToToken[i];
            }
        }

        return 0;
    }

    function getTokenPriceByIndex(uint256 index)
        internal
        view
        returns (uint256)
    {
        uint256 i;

        for (i = index; i >= 0; i--) {
            if (oneUsdtEqualsToToken[i] > 0) {
                return oneUsdtEqualsToToken[i];
            }
        }

        return 0;
    }

    function getTokenPriceToday() external view returns (uint256) {
        uint256 index = block.timestamp.div(24 hours).sub(
            recordStartTime.div(24 hours)
        );

        uint256 i;

        for (i = index; i >= 0; i--) {
            if (oneUsdtEqualsToToken[i] > 0) {
                return oneUsdtEqualsToToken[i];
            }
        }

        return 0;
    }
}

contract ETXEToken is AbcToken {
    constructor()
        AbcToken(
            address(0x10ED43C718714eb63d5aA57B78B54704E256024E), //RouterAddress
            address(0x55d398326f99059fF775485246999027B3197955), //BaseToken
            "ETXEToken", //Name
            "ETXE", //Symbol
            96800000 * 10**18, //Supply
            address(0x0293Db27c868Bf9A16878Bf12D2Fa78fCd9C47aD), //TokenOwner
            address(0x507d69EF8d02688890699D2bFa71BF41e430A15D), //LPAddress
            address(0xddEA004Ce8b2960a4183c84c1EE0F6e4DcC18e75), //FundAddress
            address(0x529DD83B934cA9EB1F5C70Ab7075B3f477beD519), //MarketAddress
            address(0xe5114DF3d5D6EA6bB8F6704e6F8FbDD9b1f4d3d7), //CommunityAddress
            address(0xbbE8CC4318Cac29c3062dEFcc947bb59F32a3476) //TechnologyAddress
        )
    {}
}