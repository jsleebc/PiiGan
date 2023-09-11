// Sources flattened with hardhat v2.7.0 https://hardhat.org

// File @openzeppelin/contracts/utils/Context.sol@v4.4.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (utils/Context.sol)

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


// File @openzeppelin/contracts/access/Ownable.sol@v4.4.0


// OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)

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


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0


// OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

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


// File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0


// OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)

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


// File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0


// OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)

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

// File contracts/Eagle.sol
//PR

pragma solidity ^0.8.0;


contract Eagle is Ownable, ERC20 {
    bool public limited;
    uint256 public maxHoldingAmount;
    uint256 public minHoldingAmount;
    address public uniswapV2Pair;

    constructor(uint256 _totalSupply) ERC20("1933", "EAGLE") {
        _mint(msg.sender, _totalSupply);
    }


    function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
        limited = _limited;
        uniswapV2Pair = _uniswapV2Pair;
        maxHoldingAmount = _maxHoldingAmount;
        minHoldingAmount = _minHoldingAmount;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) override internal virtual {

        if (uniswapV2Pair == address(0)) {
            require(from == owner() || to == owner(), "trading is not started");
            return;
        }

        if (limited && from == uniswapV2Pair) {
            require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
        }
    }

    function burn(uint256 value) external {
        _burn(msg.sender, value);
    }
}

/*
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&#BGP5YJJJ????JJJYY5PGB#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#G5J?7!!~!!!77?????????777!!!!7?JYPB&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@#GY?!~~!7?Y5GB#&&&@@@@@@@@@@@&&##BP5Y?7!!!?YPB&@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@&GY7~~!7YPB&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#G5J7!!7JP#@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@&PJ!~~7YG&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#PY7!!?5B@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@GJ!~~?P#@@@@@@@@@@@@@@@&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&B5?!!?P#@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@&P7~~?5#@@@@@@@@@@@@@@@&#GGGGB#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B57!7YB@@@@@@@@@@@@@@@
@@@@@@@@@@@@@&5!~!JB@@@@@@@@@@@@@@@@@#5YYY5PGB&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&P?!7JB@@@@@@@@@@@@@
@@@@@@@@@@@&5!~!Y#@@@@@@@@@@@@@@@@@@#?777?JYPG&@@@@@@@@@@@@@@@@@@@@@@@@@@&#GBGB&@@@GJ77JB@@@@@@@@@@@
@@@@@@@@@@G7~~J#@@@@@@@@@@@@@@@@@@@#?777777?J#@@@@@@@@@@@@@@@@@@@@@@@@@@G5YY5PGB&@@@@G?775&@@@@@@@@@
@@@@@@@@&J~~7G@@@@@@@@@@@@@@@@@@@@B?777777?75@@@@@@@@@@@@@@@@@@@@@@@@@@57777?YPB&@@@@@&577?G@@@@@@@@
@@@@@@@B7~~Y&@@@@@@@@@@@@@@@@@@@@B7777777?7J&@@@@@@@@@@@@@@@@@@@@@@@@@P777777?JB@@@@@@@@#J775&@@@@@@
@@@@@@P!~!G@@@@@@@@@@@@@@@@@@@@@&?777777??7B@@@@@@@@@@@@@@@@@@@@@@@@@5777777?7Y@@@@@@@@@@&577J&@@@@@
@@@@@5~~7#@@@@@@@@@@@@@@@@@@@@@@5777777??7J&@@@@@@@@@@@@@@@@@@@@@@@@5777777?7J#@@@@@@@@@@@@P77J#@@@@
@@@@P~~7#@@@@@@@@@@@@@@@@@@@@@@P777777??7J#@@@@@@@@@@@@@@@@@@@@@@@@G777777??7P@@@@@@@@@@@@@@P77J&@@@
@@@G!~!#@@@@@@@@@@@@@@@@@@@@@@P777777??7?#@@@@@@@@@@@@@@@@@@@@@@@@#?77777??7?#@@@@@@@@@@@@@@@P77Y@@@
@@#!~!G@@@@@@@@@@@@@@@@@@BGBGY7777777?7?B@@@@@@@@@@@@@@@@@@@@@@@@&J77777??7?#@@@@@@@@@@@@@@@@@Y77P@@
@@J~~Y@@@@@@@@@@@@@@@@@@@G7777777777??Y#@@@@@@@@@@@@@@@@@@@@@@@@#J77777??7?B@@@@@@@@@@@@@@@@@@&???#@
@B!!!#@@@@@@@@@@@@@@@@@@@@57777777???JYYYYY&@@@@@@@@@@@@@@@&PY5Y?77777777?B@@@@@@@@@@@@@@@@@@@@P??Y@
@Y~~Y@@@@@@@@@@@@@@@@@@@&5777777777????????#@@@@@@@@@@@@@@@@#?!7777777?JYB&&#&@@@@@@@@@@@@@@@@@&???#
&7!!B@@@@@@@@@@@@@@@@@@G?77777777J????????Y@@@@@@@@@@@@@@@@@&J7777777????????G@@@@@@@@@@@@@@@@@@5??P
B!!7&@@@@@@@@@@@@@@@&GJ7777777777G#??????Y#@@@@@@@@@@@@@@@@G?777777?77???????B@@@@@@@@@@@@@@@@@@G??Y
G!!?@@@@@@@@@@@@@@&P?7777777777?G@@#??J5B@@@@@@@@@@@@@@@@BJ77777777?PJ??????Y&@@@@@@@@@@@@@@@@@@B??J
P!!J@@@@@@@@@@@@@G?!7777777777Y#@@@@##&@@@@@@@@@@@@@@@&GJ77777777775@#J7??JP@@@@@@@@@@@@@@@@@@@@#???
P!!?@@@@@@@@@@@GJ!7777777777JB@@@@@@@@@@@@@@@@@@@@@@@G?!777777777?G@@@#5P#@@@@@@@@@@@@@@@@@@@@@@#??J
B!!7&@@@@@@@@#5!!777777777JG&@@@@@@@@@@@@@@@@@@@@@@BJ!777777777?5&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G??Y
&7!!#@@@@@@@#PY77777777?P#@@@@@@@@@@@@@@@@@@@@@@@#Y!!77777777?Y#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P??5
@J!!P@@@@@@@GP5JJJ??7JB&@@@@@@@@@@@@@@@@@@@@@@@&G5?!7777777JP#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&J??B
@G!!?&@@@@@@#PPP5GPGB@@@@@@@@@@@@@@@@@@@@@@@@@@&P5J??7?775B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B??Y@
@@?!!P@@@@@@@&B#B##@@@@@@@@@@@@@@@@@@@@@@@@@@@@#GP55PYG5#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y??B@
@@B!!7#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#BG#G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P??5@@
@@@5!!?&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B??J&@@
@@@@Y!!Y@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@&&&@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@#J?J#@@@
@@@@@Y!!Y@@@@@@@@@@@@@@@@@@@@@@@@&G75@@@@PJJYYY#@@#YY55YG@@@PY5555#@@@@@@@@@@@@@@@@@@@@@@@@BJ?JB@@@@
@@@@@@Y!!J&@@@@@@@@@@@@@@@@@@@@@5JY!5@@@5!B@@@57#@P5@@@P7#@#5#@@&JY@@@@@@@@@@@@@@@@@@@@@@@BJ?JB@@@@@
@@@@@@@P7!?B@@@@@@@@@@@@@@@@@@@@#@@75@@@5!B@@&5!G@@@&PY?5@@@@@B5YJ#@@@@@@@@@@@@@@@@@@@@@&P??Y#@@@@@@
@@@@@@@@B?!75&@@@@@@@@@@@@@@@@@@@@&75@@@@GYYY557G@@@@&&BJ5@@@@&&#PJ#@@@@@@@@@@@@@@@@@@@BY??5&@@@@@@@
@@@@@@@@@&57!?G@@@@@@@@@@@@@@@@@@@&75@@@#P#@@&Y?&&5P@@@&JY@BY#@@@G?B@@@@@@@@@@@@@@@@@&5??YB@@@@@@@@@
@@@@@@@@@@@BJ7!JG@@@@@@@@@@@@@@@@@&?P@@@@5J55Y5&@@BYY55YP&@&PY5P55B@@@@@@@@@@@@@@@@&PJ?JP&@@@@@@@@@@
@@@@@@@@@@@@@BJ7!JG&@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@&&&@@@@@@@&&&@@@@@@@@@@@@@@@@#PJ?JP&@@@@@@@@@@@@
@@@@@@@@@@@@@@@BY7!?5#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&B5??JP&@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@#5?77JP#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&B5J??YB&@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&B5?77J5B&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#G5J??YG#@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@&B5J77?J5B#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#G5J??J5G#@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@#G5J?77?Y5PB#&&@@@@@@@@@@@@@@@@@@@&##GP5YJ??J5P#&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BG5YJ?????JYY55PPPPGPPPP55YYJJ???JY5PB#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&#BGP5YJJ?????????JJJY55PGB#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
***FORBIDDEN***
*/