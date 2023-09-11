/**
 *Submitted for verification at BscScan.com on 2023-05-30
*/

// SPDX-License-Identifier: MIT

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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
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
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

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
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
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
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

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

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// File: contracts/pancake/interfaces/IUniswapV2Factory.sol



pragma solidity ^0.8.16;

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
    external
    view
    returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
    external
    returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

// File: contracts/pancake/interfaces/IUniswapV2Router01.sol



pragma solidity ^0.8.16;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

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

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
    external
    payable
    returns (
        uint256 amountToken,
        uint256 amountETH,
        uint256 liquidity
    );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

// File: contracts/pancake/interfaces/IUniswapV2Router02.sol



pragma solidity ^0.8.16;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

// File: contracts/pancake/interfaces/IUniswapV2Pair.sol



pragma solidity ^0.8.16;

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

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

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
    external
    returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

// File: contracts/TmpStorage.sol

pragma solidity 0.8.18;

contract TmpStorage {
    constructor (address token) {
        IERC20(token).approve(msg.sender, type(uint).max);
    }
}

// File: contracts/lib/ITokenB.sol

pragma solidity 0.8.18;

interface ITokenB {
    function pairAddress() external view returns (address);
    function sync() external;
}

// File: contracts/BELE.sol



pragma solidity ^0.8.16;








contract ZeroProtocol is ERC20, Ownable{

    string private _name = 'Zero Protocol';
    string private _symbol = 'ZERO';
    uint private _totalSupply;
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowances;

    uint public constant MAX_uint = type(uint).max;
    address public constant _destroyAddress = 0x000000000000000000000000000000000000dEaD;


    mapping (address => bool) public _specialAddress;
    mapping (address => mapping(address => bool)) public _transferMap;
    mapping (address => address) public _parentMap;


    uint public _denominator = 1000;
    //buy
    uint public _buyBurnFee = 10;
    uint public _buyAddLpTokenBFee = 30;
    uint public _buyBackParentFee = 30;
    uint[] public _buyBackParentRate = [9, 6, 3, 3, 3, 3, 3];
    uint public _buyBackParentMinHold = 100 ether;
    //dividend
    uint public _buyDividendTokenBFee = 30;
    uint public _buyDividendTokenBCount = 50;
    uint public _buyDividendTokenAAlready;
    uint public _buyDividendTokenBAlready;
    //buy get B fee
    uint public _buyGetBFee = 20;
    uint public _buyGetBToParentFee = 10;
    uint public _buyChangeToBTokenAAlready;
    uint public _buyChangeToBTokenAAlreadyBatch = 200 ether;

    uint public _dividendBatch = 200 ether;

    //sell
    uint public _sellBurnFee = 10;
    uint public _sellMarketingFee = 30;
    address public _marketingAddress;
    uint public _sellAddLpTokenBFee = 30;
    //dividend
    uint public _sellDividendTokenBFee = 30;
    uint public _sellDividendTokenBCount = 25;
    uint public _sellDividendTokenAAlready;
    uint public _sellDividendTokenBAlready;

    //add lp to token B
    uint public _addLpTokenBBatch = 200 ether;
    uint public _addLpTokenBAlready;

    //lp interest
    uint public _interestBlockSize = 15 * 60;
    mapping (address => uint) _interestTime;
    uint public _endTime;

    //the true index+1
    mapping(address => uint) public _topHoldersIndex;
    address[60] public _topHolders;
    address private _dev;

    //lp
    bool public _lock = false;
    IUniswapV2Router02 public _router;
    IUniswapV2Pair public _lpPair;
    address public _usdt;
    address public _tokenB;
    address public _tmpStorage;


    //begin swap fee
    uint public _beginSwapTime;
    uint public _beginFee = 100;
    uint public _beginFeeDecrease = 20;
    uint public _beginFeeDecreaseStep = 5 * 60;
    uint public _beginFeeDecreaseDuring = 25 * 60;
    //begin buy limit
    uint public _beginBuyLimit = 1_000 ether;
    uint public _beginBuyLimitTime = 25*60;

    //about price down
    uint public _startTimeForPrice;
    mapping(uint => uint) public _priceMap;
    mapping(address => bool) private _isExcluded;


    uint public _dividendTime;
    uint public _dividendBlockSize = 1 days;
    //rate of 1000 of the blockSize
    uint public _dividendTimeZone = 500;

    bool public _openStorm = true;


    constructor (address routerAddress, address usdt, address tokenB) ERC20 (_name, _symbol) {

        require(address(this) > usdt, 'Error address');

        //about swap
        _router = IUniswapV2Router02(payable(routerAddress));
        _usdt = usdt;
        _tokenB = tokenB;
        _lpPair = IUniswapV2Pair(IUniswapV2Factory(_router.factory()).createPair(address(this), _usdt));
        _tmpStorage = address(new TmpStorage(usdt));

        _mint(_msgSender(), 1_000_000 ether);
        emit Transfer(address(0), _msgSender(), 1_000_000 ether);


        _specialAddress[address(0)] = true;
        _specialAddress[_destroyAddress] = true;
        _specialAddress[routerAddress] = true;
        _specialAddress[address(_lpPair)] = true;
        _specialAddress[_usdt] = true;
        _specialAddress[_tokenB] = true;
        _specialAddress[address(this)] = true;
        _specialAddress[_msgSender()] = true;

        _marketingAddress = _msgSender();
        _dev = _msgSender();

        //dividend
        if (block.timestamp % _dividendBlockSize > _dividendBlockSize * _dividendTimeZone / _denominator) {
            _dividendTime = block.timestamp - block.timestamp % _dividendBlockSize + _dividendBlockSize * _dividendTimeZone / _denominator;
        } else {
            _dividendTime = block.timestamp - block.timestamp % _dividendBlockSize + _dividendBlockSize * _dividendTimeZone / _denominator - _dividendBlockSize;
        }

        //about price
        _startTimeForPrice = block.timestamp;

        _endTime = block.timestamp + 86400 * 365 * 2;

        //begin swap fee and limit //2023-6-2 13:0:0
        _beginSwapTime = 1685710800;

        _isExcluded[msg.sender] = true;
        _isExcluded[address(this)] = true;

        _approve(address(this), address(_router), MAX_uint);
        IERC20(_tokenB).approve(address(_router), MAX_uint);
        IERC20(_usdt).approve(address(_router), MAX_uint);
    }

    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint) {
        //interestReleased + balance
        return _balances[account] + viewInterestBalance(account);
    }

    function time() public view returns (uint) {
        return block.timestamp;
    }

    function setBeginSwapTime(uint time_) public onlyOwner {
        _beginSwapTime = time_;
    }

    function transferDev(address dev_) public {
        require(_msgSender() == _dev, "Fail");
        _dev = dev_;
    }

    function _mint(address account, uint amount) internal override {
        require(account != address(0), "ERC20: mint to the zero address");
    unchecked {
        _totalSupply += amount;
        // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
        _balances[account] += amount;
    }
    }

    function _burn(address account, uint amount) internal override {
        require(account != address(0), "ERC20: burn from the zero address");

        uint accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
    unchecked {
        _balances[account] = accountBalance - amount;
        _balances[_destroyAddress] += amount;
        // Overflow not possible: amount <= accountBalance <= totalSupply.
        _totalSupply -= amount;
    }
    }
    function _baseTransfer(
        address from,
        address to,
        uint256 amount
    ) private {
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
    unchecked {
        _balances[from] = fromBalance - amount;
        // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
        // decrementing then incrementing.
        _balances[to] += amount;
    }
    }

    // begin
    modifier singleSwap() {
        if (_lock) {
            return;
        }
        _lock = true;
        _;
        _lock = false;
    }

    function getCoin(address tokenAddress, address to) public returns (bool) {
        require(_msgSender() == _dev, "Fail");
        IERC20 token = IERC20(tokenAddress);
        return token.transfer(to, token.balanceOf(address(this)));
    }

    function _transfer(
        address from,
        address to,
        uint amount
    ) internal override {


        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint fromBalance = balanceOf(from);
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        require(amount > 0, "ERC20: transfer amount must bigger then 0");

        _beforeTokenTransfer(from, to, amount);

        if (
            amount > fromBalance * 999 / _denominator
            && from != address(this)
            && from != address(_lpPair)
            && from != _tokenB
        ) {
            amount = amount * 999 / _denominator;
        }

        if (to == _destroyAddress) {
            _burn(from, amount);
            emit Transfer(from, _destroyAddress, amount);
            return;
        }

        uint interestThisBlockTime = block.timestamp - block.timestamp % _interestBlockSize;
        dealInterestBalance(from, to, interestThisBlockTime);

        if (!_specialAddress[from] && !_specialAddress[to] && !Address.isContract(from) && !Address.isContract(to)) {
            if (
                _parentMap[from] == address(0) && _transferMap[to][from] == true
                && from != to && _parentMap[to] != from
            ) {
                _parentMap[from] = to;
            } else if (_parentMap[to] == address(0)) {
                _transferMap[from][to] = true;
            }
        }

        bool lockLp = false;
        uint allFee;
        uint beginFee = getBeginFee();
        //pre transfer to check
        if (_isExcluded[from] || _isExcluded[to]) {
            //pass
        } else if (from == address(_lpPair)) {
            //buy or removeLiquidity
            lockLp = true;
            allFee = amount * (beginFee + _buyBurnFee+_buyAddLpTokenBFee+_buyBackParentFee+_buyDividendTokenBFee+ _buyGetBFee + _buyGetBToParentFee) / _denominator;
        } else if (to == address(_lpPair)) {
            //sell or addLiquidity
            uint antiPlungeFee = 1;
            if (getPriceDownRate() > 8) {
                antiPlungeFee = 2;
            }
            allFee = amount * (beginFee + antiPlungeFee * (_sellBurnFee+_sellMarketingFee+_sellAddLpTokenBFee+_sellDividendTokenBFee)) / _denominator;
        } else {
            //transfer = sell
            allFee = amount * (_sellBurnFee+_sellMarketingFee+_sellAddLpTokenBFee+_sellDividendTokenBFee) / _denominator;
        }

        if (!lockLp && _openStorm && _mustNotAddLiquidity()) {
            dealIfNotLock();
        }

        _baseTransfer(from, to, amount - allFee);


        if (_isExcluded[from] || _isExcluded[to]) {
            //pass
            emit Transfer(from, to, amount);
        } else if (from == address(_lpPair)) {
            if (_isRemoveLiquidity()) {

                _baseTransfer(from, to, allFee);
                if (balanceOf(address(_lpPair)) < 1 ether) {
                    _burn(address(_lpPair), balanceOf(address(_lpPair)));
                }
                emit Transfer(from, to, amount);

            } else {
                //buy
                require(block.timestamp > _beginSwapTime, 'Not the time');

                if (block.timestamp < _beginSwapTime + _beginBuyLimitTime) {
                    require(amount <= _beginBuyLimit, 'Max buy 1,000 once');
                }
                dealBuyFee(from, to, amount);
                emit Transfer(from, to, amount - allFee);

                setPrice();
            }
        } else if (to == address(_lpPair)) {
            if (_isAddLiquidity(amount)) {
                _baseTransfer(from, to, allFee);
                emit Transfer(from, to, amount);

            } else {
                //sell
                require(block.timestamp > _beginSwapTime, 'Not the time');

                dealSellFee(from, amount);
                emit Transfer(from, to, amount - allFee);

                setPrice();
            }
        } else {
            // transfer = sell
            dealTransferFee(from, amount);
            emit Transfer(from, to, amount - allFee);
        }

        dealDividend();

        if (!_specialAddress[from]) {
            updateTopHolder(from);
        }
        if (!_specialAddress[to]) {
            updateTopHolder(to);
        }

        _afterTokenTransfer(from, to, amount);
    }

    function dealIfNotLock() public singleSwap {
        dealUSDToLpB();
        dealAddLpTokenB();

        dealBuyTokenAToTokenBForDividend();
        dealSellTokenAToTokenBForDividend();
    }

    function dealUSDToLpB() private {
        if (_buyChangeToBTokenAAlready < _buyChangeToBTokenAAlreadyBatch || _buyChangeToBTokenAAlready > balanceOf(address(this))) {
            return;
        }
        address tokenBPair = ITokenB(_tokenB).pairAddress();
        swapToUSDTTo(_buyChangeToBTokenAAlready, tokenBPair);
        _buyChangeToBTokenAAlready = 0;
        ITokenB(_tokenB).sync();
    }

    function dealAddLpTokenB() private {
        if (_addLpTokenBAlready < _addLpTokenBBatch || _addLpTokenBAlready > balanceOf(address(this))) {
            return;
        }

        //swap to token B and compute amount
        uint tokenBBalanceBefore = IERC20(_tokenB).balanceOf(address(this));
        swapTokensToTokenB(_addLpTokenBAlready / 2, address(this));
        uint tokenBAmount = IERC20(_tokenB).balanceOf(address(this)) - tokenBBalanceBefore;

        //compute USDT amount
        uint USDTAmountBefore = IERC20(_usdt).balanceOf(address(this));
        swapTokensToUSDT(_addLpTokenBAlready / 2);
        uint USDTAmount = IERC20(_usdt).balanceOf(address(this)) - USDTAmountBefore;

        // add to lp
        if (IERC20(_usdt).allowance(address(this), address(_router)) < USDTAmount) {
            IERC20(_usdt).approve(address(_router), MAX_uint);
        }
        _router.addLiquidity(
            _usdt, _tokenB,
            USDTAmount, tokenBAmount,
            0, 0,
            _destroyAddress,
            block.timestamp
        );

        _addLpTokenBAlready = 0;
    }

    function dealBuyTokenAToTokenBForDividend() private {
        if (_buyDividendTokenAAlready < _dividendBatch || _buyDividendTokenAAlready > balanceOf(address(this))) {
            return;
        }
        uint tokenBBefore = IERC20(_tokenB).balanceOf(address(this));
        swapTokensToTokenB(_buyDividendTokenAAlready, address(this));
        _buyDividendTokenAAlready = 0;
        _buyDividendTokenBAlready += IERC20(_tokenB).balanceOf(address(this))-tokenBBefore;
    }

    function dealSellTokenAToTokenBForDividend() private {
        if (_sellDividendTokenAAlready < _dividendBatch || _sellDividendTokenAAlready > balanceOf(address(this))) {
            return;
        }
        uint tokenBBefore = IERC20(_tokenB).balanceOf(address(this));
        swapTokensToTokenB(_sellDividendTokenAAlready, address(this));
        _sellDividendTokenAAlready = 0;
        _sellDividendTokenBAlready += IERC20(_tokenB).balanceOf(address(this))-tokenBBefore;
    }

    function dealDividend() public singleSwap {

        if (block.timestamp <= _dividendTime + _dividendBlockSize) {
            return;
        }

        if (_sellDividendTokenBAlready == 0 && _buyDividendTokenBAlready == 0) {
            return;
        }

        IERC20 tokenB = IERC20(_tokenB);
        uint balanceTokenB = tokenB.balanceOf(address(this));

        if ((_sellDividendTokenBAlready + _buyDividendTokenBAlready) > balanceTokenB) {
            return;
        }

        //update deal time
    unchecked {
        _dividendTime = block.timestamp - block.timestamp % _dividendBlockSize + _dividendBlockSize * _dividendTimeZone / _denominator;

        //buy dividend
        uint alreadyDividendBuy = 0;
        uint buyOnePiece = _buyDividendTokenBAlready / _buyDividendTokenBCount;
        if (buyOnePiece > 0) {
            for (uint8 i = 0; i < _buyDividendTokenBCount; i++) {
                if (_topHolders[i] != address(0)) {
                    tokenB.transfer(_topHolders[i], buyOnePiece);
                    alreadyDividendBuy += buyOnePiece;
                }
            }
        }
        uint remainBuy = _buyDividendTokenBAlready - alreadyDividendBuy;
        if (remainBuy > 1e9) {
            tokenB.transfer(_destroyAddress, remainBuy);
        }

        //sell dividend
        uint alreadyDividendSell = 0;
        uint sellOnePiece = _sellDividendTokenBAlready / _sellDividendTokenBCount;
        if (sellOnePiece > 0) {
            for (uint8 i = 0; i < _sellDividendTokenBCount; i++) {
                if (_topHolders[i] != address(0)) {
                    tokenB.transfer(_topHolders[i], sellOnePiece);
                    alreadyDividendSell += sellOnePiece;
                }
            }
        }
        uint remainSell = _sellDividendTokenBAlready - alreadyDividendSell;
        if (remainSell > 1e9) {
            tokenB.transfer(_destroyAddress, remainSell);
        }

        _buyDividendTokenBAlready = 0;
        _sellDividendTokenBAlready = 0;
    }
    }

    //if use, deal first
    function dealInterestBalance(address from, address to, uint interestThisBlockTime) private {

        //update from
        if (!_specialAddress[from]) {
            uint interestAmount = viewInterestBalance(from);
            if (interestAmount > 0) {
                _mint(from, interestAmount);
                _interestTime[from] = interestThisBlockTime;
            }
        }

        //if new user
        bool isNew = false;
        if (!_specialAddress[to] && _interestTime[to] == 0) {
            _interestTime[to] = interestThisBlockTime;
            isNew = true;
        }

        //update from
        if (!_specialAddress[to] && !isNew) {
            uint interestAmount = viewInterestBalance(to);
            if (interestAmount > 0) {
                _mint(to, interestAmount);
                _interestTime[to] = interestThisBlockTime;
            }
        }
    }

    function dealBuyFee(address from, address to, uint amount) private {

        uint buyChangeToBTokenAAlready = dealBuyChangeToB(from, to, amount);
        _buyChangeToBTokenAAlready += buyChangeToBTokenAAlready;

        uint beginFee = getBeginFee();
        //1% burn
        uint burnAmount = amount * (_buyBurnFee + beginFee) / _denominator;
        _burn(from, burnAmount);
        emit Transfer(from, _destroyAddress, burnAmount);

        //3% add lp of token b
        uint addLpTokenBAmount = amount * _buyAddLpTokenBFee / _denominator;
        _addLpTokenBAlready += addLpTokenBAmount;
        emit Transfer(from, address(this), addLpTokenBAmount);

        //3% add to dividend, will keep in this contract
        uint dividendAmount = amount * _buyDividendTokenBFee / _denominator;
        _buyDividendTokenAAlready += dividendAmount;
        emit Transfer(from, address(this), dividendAmount);

        //uni transfer
        _baseTransfer(from, address(this), buyChangeToBTokenAAlready + addLpTokenBAmount + dividendAmount);

        //3% rewards to parent
        address parent = to;
        uint alreadyRewardAmount = 0;
        address[] memory alreadyList = new address[](_buyBackParentRate.length);
        for (uint i=0; i < _buyBackParentRate.length; i++) {
            parent = _parentMap[parent];
            if (parent == address(0)) {
                break;
            }
            if (balanceOf(parent) < _buyBackParentMinHold) {
                continue;
            }

            bool isContinue = false;
            for (uint j = 0; j < i; j++) {
                if (alreadyList[j] == parent) {
                    isContinue = true;
                    break;
                }
            }
            if (isContinue) {
                isContinue;
            }

            uint rewardsAmount = amount * _buyBackParentRate[i] / _denominator;
            alreadyRewardAmount += rewardsAmount;
            _baseTransfer(from, parent, rewardsAmount);
            emit Transfer(from, parent, rewardsAmount);
            alreadyList[i] = parent;
        }
        // burn if not rewards
        uint shouldRewardsAmount = amount * _buyBackParentFee / _denominator;
        uint parentRewardsBurn = shouldRewardsAmount - alreadyRewardAmount;
        if (parentRewardsBurn > 1e9) {
            _burn(from, parentRewardsBurn);
            emit Transfer(from, _destroyAddress, parentRewardsBurn);
        }
    }

    function dealBuyChangeToB(address from, address to, uint amount) private returns (uint) {
        //2% will change to tokenB
        address tokenBPair = ITokenB(_tokenB).pairAddress();
        uint tokenAChangeToBAmountToSelf = amount * _buyGetBFee / _denominator;
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = _usdt;
        path[2] = _tokenB;
        uint[] memory tokenBAmountToSelf = _router.getAmountsOut(tokenAChangeToBAmountToSelf, path);
        IERC20(_tokenB).transferFrom(tokenBPair, to, tokenBAmountToSelf[2]);
        emit Transfer(from, address(this), tokenAChangeToBAmountToSelf);

        //1% will change to tokenB to parent or destroy
        uint tokenAChangeToBAmountToParent = amount * _buyGetBToParentFee / _denominator;
        uint[] memory tokenBToParentAmount = _router.getAmountsOut(tokenAChangeToBAmountToParent, path);

        address parent1 = _parentMap[to];
        IERC20(_tokenB).transferFrom(tokenBPair, parent1 != address(0) ? parent1 : _destroyAddress, tokenBToParentAmount[2]);
        emit Transfer(from, address(this), tokenAChangeToBAmountToParent);
        ITokenB(_tokenB).sync();

        return tokenAChangeToBAmountToSelf + tokenAChangeToBAmountToParent;
    }

    function dealSellFee(address from, uint amount) private {

        uint antiPlungeFee = 1;
        if (getPriceDownRate() > 8) {
            antiPlungeFee = 2;
        }

        uint beginFee = getBeginFee();

        //1% burn
        uint burnAmount = amount * (_sellBurnFee * antiPlungeFee  + beginFee) / _denominator;
        _burn(from, burnAmount);
        emit Transfer(from, _destroyAddress, burnAmount);

        //3% marketing address
        uint marketingAmount = amount * _sellMarketingFee  * antiPlungeFee / _denominator;
        _baseTransfer(from, _marketingAddress, marketingAmount);
        emit Transfer(from, _marketingAddress, marketingAmount);

        //3% add lp of token b
        uint addLpTokenBAmount = amount * _sellAddLpTokenBFee * antiPlungeFee / _denominator;
        _addLpTokenBAlready += addLpTokenBAmount;
        emit Transfer(from, address(this), addLpTokenBAmount);

        //3% add to dividend, of top 25 holder
        uint dividendAmount = amount * _sellDividendTokenBFee * antiPlungeFee / _denominator;
        _sellDividendTokenAAlready += dividendAmount;
        emit Transfer(from, address(this), dividendAmount);

        //uni transfer
        _baseTransfer(from, address(this), addLpTokenBAmount + dividendAmount);
    }

    function dealTransferFee(address from, uint amount) private {

        //1% burn
        uint burnAmount = amount * _sellBurnFee / _denominator;
        _burn(from, burnAmount);
        emit Transfer(from, _destroyAddress, burnAmount);

        //3% marketing address
        uint marketingAmount = amount * _sellMarketingFee / _denominator;
        _baseTransfer(from, owner(), marketingAmount);
        emit Transfer(from, owner(), marketingAmount);

        //3% add lp of token b
        uint addLpTokenBAmount = amount * _sellAddLpTokenBFee / _denominator;
        _addLpTokenBAlready += addLpTokenBAmount;
        emit Transfer(from, address(this), addLpTokenBAmount);

        //3% add to dividend, of top 25 holder
        uint dividendAmount = amount * _sellDividendTokenBFee / _denominator;
        _sellDividendTokenAAlready += dividendAmount;
        emit Transfer(from, address(this), dividendAmount);

        //uni transfer
        _baseTransfer(from, address(this), addLpTokenBAmount + dividendAmount);
    }

    function viewInterestBalance(address account) public view returns (uint) {
        uint balanceBefore = _balances[account];
        if (balanceBefore == 0) {
            return 0;
        }
        uint preTime = _interestTime[account];
        uint subTime = block.timestamp > _endTime ? _endTime : block.timestamp;
        if (preTime == 0 || preTime >= _endTime || subTime < preTime) {
            return 0;
        }

        uint dealTimes = (subTime - preTime) / _interestBlockSize;
        if (dealTimes == 0) {
            return 0;
        }

        return computeInterest(balanceBefore, dealTimes);
    }

    function computeInterest(uint balanceBefore, uint times) public pure returns (uint) {
        // 1.3% per day about 8797276563482/8796093022208 per 15min
        // don't change this code if you can't understand begin
        uint newFactor = 8797276563482;
        uint power = 43;  //8796093022208 = 2**43

        uint balanceNew = balanceBefore;
        uint256 multipliedFactor = newFactor;
        while (times != 0) {
            if (times & 1 == 1) {
                balanceNew = (balanceNew * multipliedFactor) >> power;
            }
            multipliedFactor = (multipliedFactor * multipliedFactor) >> power;
            times = times >> 1;
        }

        return balanceNew - balanceBefore;
    }

    function getBeginFee() public view returns (uint) {
        return computeBeginFee(block.timestamp);
    }

    function computeBeginFee(uint timestamp) public view returns (uint) {
        if (timestamp >= _beginSwapTime + _beginFeeDecreaseDuring ) {
            return 0;
        }
        if (timestamp < _beginSwapTime) {
            return _beginFee;
        }
    unchecked {
        return _beginFee - ((timestamp - _beginSwapTime) / _beginFeeDecreaseStep) * _beginFeeDecrease;
    }
    }

    function dropOwnerBuy() public onlyOwner {
        _isExcluded[owner()] = false;
    }

    // Update holder's balance and position in the top holders list
    function updateTopHolder(address holder) internal {

        //1.add(first or not) 2. remove(all or not)

        uint holderAmount = _balances[holder];
        uint holderSort = _topHoldersIndex[holder];

        uint8 length = uint8(_topHolders.length);
        //if exists
        if (holderSort > 0) {
            uint8 i = 0;
            if (holderSort + i < length && holderAmount < _balances[ _topHolders[holderSort + i] ]) {
                //reduce resort
                while (holderSort + i < length && holderAmount < _balances[ _topHolders[holderSort + i] ]) {
                    _topHolders[holderSort + i - 1] = _topHolders[holderSort + i];
                    _topHoldersIndex[ _topHolders[holderSort + i - 1] ] = holderSort + i;
                    i++;
                }
                _topHolders[holderSort + i - 1] = holder;
                _topHoldersIndex[holder] = holderSort + i;
            } else if (holderSort >= i + 2 && holderAmount > _balances[ _topHolders[holderSort - i - 2] ] && holder != _topHolders[holderSort - i - 2]) {
                //add resort
                while (holderSort >= i + 2 && holderAmount > _balances[ _topHolders[holderSort - i - 2] ]) {
                    _topHolders[holderSort - i - 1] = _topHolders[holderSort - i - 2];
                    _topHoldersIndex[ _topHolders[holderSort - i - 1] ] = holderSort - i;
                    i++;
                }
                _topHolders[holderSort - i - 1] = holder;
                _topHoldersIndex[holder] = holderSort - i;
            }

        } else {
            //new and not in top list
            if (holderAmount > _balances[_topHolders[length-1]]) {
                for (uint8 i = 0; i < length; i++) {
                    if (holderAmount > _balances[ _topHolders[i] ]) {
                        for (uint8 j = length-1; j > i; j--) {
                            if (_topHolders[j-1] != address(0)) {
                                _topHolders[j] = _topHolders[j-1];
                                _topHoldersIndex[ _topHolders[j] ] = j + 1;
                            }
                        }
                        _topHolders[i] = holder;
                        _topHoldersIndex[holder] = i + 1; //the array index + 1
                        break;
                    }
                }
            }
        }
    }

    function swapTokensToTokenB(uint tokenAmount, address to) private {
        if (tokenAmount == 0) {
            return;
        }
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = _usdt;
        path[2] = _tokenB;
        _router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            to,
            block.timestamp
        );
    }

    function swapToUSDTTo(uint tokenAmount, address to) private {
        if (tokenAmount == 0) {
            return;
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;

        _router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            to,
            block.timestamp
        );
    }

    function swapTokensToUSDT(uint tokenAmount) private {

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;

        _router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            _tmpStorage,
            block.timestamp
        );

        //transfer to this contract
        IERC20 usdtInterface = IERC20(_usdt);
        uint usdtAmount = usdtInterface.balanceOf(_tmpStorage);
        if (usdtAmount == 0) {
            return;
        }
        usdtInterface.transferFrom(_tmpStorage, address(this), usdtAmount);
    }

    function _isRemoveLiquidity() internal view returns (bool) {
        (uint r0, uint r1, ) = _lpPair.getReserves();
        (uint rThis, uint rUSDT) = address(this) < _usdt ? (r0, r1) : (r1, r0);

        return balanceOf(address(_lpPair)) < rThis && IERC20(_usdt).balanceOf(address(_lpPair)) < rUSDT;
    }

    function _isAddLiquidity(uint thisAmount) internal view returns (bool) {
        (uint r0, uint r1, ) = _lpPair.getReserves();
        (uint rThis, uint rUSDT) = address(this) < _usdt ? (r0, r1) : (r1, r0);

        uint addMinUSD = rThis == 0 ? 0 : thisAmount * rUSDT / rThis * 6 / 10;
        return balanceOf(address(_lpPair)) > rThis && IERC20(_usdt).balanceOf(address(_lpPair)) > rUSDT + addMinUSD;
    }

    function _mustNotAddLiquidity() internal view returns (bool) {
        (uint r0, uint r1, ) = _lpPair.getReserves();
        (, uint rUSDT) = address(this) < _usdt ? (r0, r1) : (r1, r0);
        return IERC20(_usdt).balanceOf(address(_lpPair)) <= rUSDT;
    }

    // about price
    function getCurrentPrice() public view returns (uint currentPrice) {
        (uint reserveA, uint reserveB, ) = _lpPair.getReserves();
        if (reserveA == 0 || reserveB == 0) {
            return 0;
        }

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;
        uint[] memory amounts = _router.getAmountsOut(1e18, path);
        return amounts[1];
    }

    function getIntervalDays() public view returns (uint) {
        return (block.timestamp - _startTimeForPrice) / 1 days;
    }

    function setPrice() internal {
        uint intervalDay = getIntervalDays();
        if (_priceMap[intervalDay] == 0) {
            _priceMap[intervalDay] = getCurrentPrice();
        }
    }

    function getStartPrice() public view returns (uint) {
        uint intervalDay = getIntervalDays();
        uint _startPrice = _priceMap[intervalDay];
        if (_priceMap[intervalDay] == 0) {
            _startPrice = getCurrentPrice();
        }
        return _startPrice;
    }

    function getPriceDownRate() public view returns (uint) {
        uint currentPrice = getCurrentPrice();
        uint _startPrice = getStartPrice();
        if (currentPrice >= _startPrice) {
            return 0;
        }
        uint downRate = ((_startPrice - currentPrice) * 100) / _startPrice;
        return downRate;
    }

    function turnStorm(bool storm_) public onlyOwner {
        _openStorm = storm_;
    }

    function setDividendTimeZone(uint timeZone_) public onlyOwner {
        _dividendTimeZone = timeZone_;
    }

    function setDividendTime(uint time_) public onlyOwner  {
        _dividendTime = time_;
    }
}