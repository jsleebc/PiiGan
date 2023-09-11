// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol


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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol


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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)

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
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
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
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
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
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        _transfer(sender, recipient, amount);

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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol


// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

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

// File: contracts/IPancakeFactory.sol



pragma solidity >=0.5.0;

interface IPancakeFactory {
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
// File: contracts/IPancakePair.sol


// File: contracts\interfaces\IPancakePair.sol

pragma solidity >=0.5.0;

interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// File: contracts/IPancakeRouter.sol


// File: contracts\interfaces\IPancakeRouter01.sol

pragma solidity >=0.6.2;

interface IPancakeRouter01 {
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

// File: contracts\interfaces\IPancakeRouter02.sol

pragma solidity >=0.6.2;

interface IPancakeRouter02 is IPancakeRouter01 {
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
// File: contracts/LiquidityManager.sol



pragma solidity ^0.8.4;




contract LiquidityManager is Ownable {

    address public liquidityWallet = 0x1be9A6E7AcEEc91B3524Edd87F4E24461f32803c;
    address public marketingWallet = 0xA5Cfa2Da885B33e73b800a273db6953C2f515A69;

    address public constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; //mainnet
    //address public constant BUSD = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;  // rinkeby Link

    address public T2K;

    uint public liquidityFee = 300; // 3% in basis points
    uint public marketingFee = 200; // 2% in basis points

    IPancakeRouter02 public pancakeRouter = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // Mainnet
    //IPancakeRouter02 public pancakeRouter = IPancakeRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Rinkeby 

    constructor(address _T2K){
        T2K = _T2K;
    }

    function swapTokensForBUSD(uint tokens, address to) public onlyOwner {
        address[] memory path = new address[](2);
        path[0] = T2K;
        path[1] = BUSD;

        IERC20(T2K).approve(address(pancakeRouter), tokens);
        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokens,
            0,
            path,
            to,
            block.timestamp
        );
    }

    function addLiquidity(uint tokens, uint amountBUSD) internal {
        IERC20(T2K).approve(address(pancakeRouter), tokens);
        IERC20(BUSD).approve(address(pancakeRouter), amountBUSD);

        pancakeRouter.addLiquidity(
            T2K,
            BUSD,
            tokens,
            amountBUSD,
            0,
            0,
            liquidityWallet,
            block.timestamp
        );
    }

    function swapAndLiquify(uint tokens) public onlyOwner {
        uint marketing = (tokens * marketingFee) / (marketingFee + liquidityFee);
        swapTokensForBUSD(marketing, marketingWallet);

        tokens = tokens - marketing;
        uint half = tokens / 2;
        uint otherHalf = tokens - half;
        uint initialBalance = IERC20(BUSD).balanceOf(address(this));

        swapTokensForBUSD(half, address(this));

        uint newBalance = IERC20(BUSD).balanceOf(address(this)) - initialBalance;

        addLiquidity(otherHalf, newBalance);
    }
}

// File: contracts/TokenToolKit.sol









pragma solidity 0.8.4;

contract TokenToolKit is ERC20, Ownable {

    address public liquidityWallet = 0x1be9A6E7AcEEc91B3524Edd87F4E24461f32803c;
    address public marketingWallet = 0xA5Cfa2Da885B33e73b800a273db6953C2f515A69;
    address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
    address public constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; //mainnet
    //address public constant BUSD = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;  // rinkeby Link

    uint public liquidityFee;
    uint public marketingFee;
    uint public sellIncreaseMarketing;
    uint public sellIncreaseLiquidity;
    uint public maxSellAmount;
    uint public swapTokensAtAmount;
    uint public sellTimerDuration;
    uint public maxDailySell;

    bool private swapping;
    bool public tradingEnabled;

    mapping (address => bool) public isExcludedFromFee;
    mapping (address => bool) public canTransferBeforeTradingIsEnabled;
    mapping (address => bool) public isExcludedFromMaxSell;
    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
    // could be subject to a maximum transfer amount
    mapping (address => bool) public automatedMarketMakerPairs;
    // Blacklist for scam contracts/bots
    mapping (address => bool) public isBlacklisted;

    mapping(address => Sell) public sellTimers;

    IPancakeRouter02 public pancakeRouter = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // Mainnet 
    // IPancakeRouter02 public pancakeRouter = IPancakeRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Rinkeby 
    LiquidityManager public liquidityManager;
    address public pancakePair;

    struct Sell {
        uint timestamp;
        uint amount;
        bool activated;
    }

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 busdReceived,
        uint256 tokensIntoLiqudity
    );

    constructor() ERC20("TokenToolKit", "T2K") {
        _mint(owner(), 100000000 * 10**18); // mint tokens

        // Set fees
        liquidityFee = 300; // 3% in basis points
        marketingFee = 200; // 2% in basis points
        sellIncreaseMarketing = 0; // sell increase on liquidity fee, 100 = 1%, 150 = 1.5%...
        sellIncreaseLiquidity = 0; // sell increase on liquidity fee, 100 = 1%, 150 = 1.5%...
        swapTokensAtAmount = 50000 * 10**18; // .05% of total supply
        maxSellAmount = 50000 * 10**18; // .05% of total supply
        maxDailySell = 500000 * 10**18;
        sellTimerDuration = 86400; // 24 hours in seconds

        address _pancakePair = IPancakeFactory(pancakeRouter.factory()) // create lp
        .createPair(address(this), BUSD);
        pancakePair = _pancakePair;

        liquidityManager = new LiquidityManager(address(this));

        automatedMarketMakerPairs[pancakePair] = true;

        isExcludedFromFee[owner()] = true;
        isExcludedFromFee[address(this)] = true;
        isExcludedFromFee[marketingWallet] = true;
        isExcludedFromFee[address(liquidityManager)] = true;

        isExcludedFromMaxSell[address(this)] = true;
        isExcludedFromMaxSell[owner()] = true;
        isExcludedFromMaxSell[address(liquidityManager)] = true;

        canTransferBeforeTradingIsEnabled[owner()] = true;
    }

    receive() external payable {}


    function excludeFromFee(address user, bool value) public onlyOwner {
        isExcludedFromFee[user] = value;
    }

    function excludeFromMaxSell(address user, bool value) public onlyOwner {
        isExcludedFromMaxSell[user] = value;
    }

    function setCanTransferBeforeTrading(address user, bool value) public onlyOwner {
        canTransferBeforeTradingIsEnabled[user] = value;
    }

    function updateMarketingFee(uint newFee) public onlyOwner {
        require(newFee <= 1000, "Max 10% Marketing fee");
        marketingFee = newFee;
    }

    function updateLiquidityFee(uint newFee) public onlyOwner {
        require(newFee <= 1000, "Max 10% Liquidity fee");
        liquidityFee = newFee;
    }

    function updateLiquiditySellIncrease(uint newIncrease) public onlyOwner {
        require(newIncrease <= 1000, "Max 10% sell fees increase");
        sellIncreaseLiquidity = newIncrease;
    }

    function updateMarketingSellIncrease(uint newIncrease) public onlyOwner {
        require(newIncrease <= 1000, "Max 10% sell fees increase");
        sellIncreaseMarketing = newIncrease;
    }

    function updateMarketMakerPairs(address pair, bool value) public onlyOwner {
        require(automatedMarketMakerPairs[pair] != value, "Already Set!");
        automatedMarketMakerPairs[pair] = value;
    }

    function blacklist(address user, bool value) public onlyOwner {
        require(isBlacklisted[user] != value, "Already Set!");
        isBlacklisted[user] = value;
    }

    function updateSwapTokensAtAmount(uint newValue) public onlyOwner {
        swapTokensAtAmount = newValue;
    }

    function updateLiquidityWallet(address newWallet) public onlyOwner {
        liquidityWallet = newWallet;
    }

    function updateMarketingWallet(address newWallet) public onlyOwner {
        marketingWallet = newWallet;
    }

    function updatePancakeRouter(address newRouter) public onlyOwner {
        IPancakeRouter02 updatedRouter = IPancakeRouter02(newRouter);
        pancakeRouter = updatedRouter;
    }

    function updateSellTimerDuration(uint newDuration) public onlyOwner {
        require(newDuration <= 604800, "Cant make sell timer more than 1 week!");
        sellTimerDuration = newDuration;
    }

    function updateMaxSellAmount(uint newMax) public onlyOwner {
        require(newMax >= 10000 * 10**18 && newMax <= 1000000 * 10**18, "Max individual sell must be between .01% and 1% of total supply");
        maxSellAmount = newMax;
    }

    function updateMaxDailySellAmount(uint newMax) public onlyOwner {
        require(newMax >= 100000 * 10**18 && newMax <= 10000000 * 10**18, "Max daily sell must be between .1% and 10% of total supply");
        maxDailySell = newMax;
    }

    function enableTrading() public onlyOwner {
        tradingEnabled = true;
    }

    function _transfer(address from, address to, uint amount) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(!isBlacklisted[to] && !isBlacklisted[from], "Blacklisted Address");

        //handle 0
        if (amount == 0) {
            super._transfer(from,to,0);
            return;
        }

        // check trading enabled
        if (!tradingEnabled) {
            require(canTransferBeforeTradingIsEnabled[from], "Trading not enabled");
        }


        bool sell;
        bool buy;
        // Detect Sell
        if (
            !swapping &&
            automatedMarketMakerPairs[to] && // transfer to LP are sells
            from != address(pancakeRouter) // router -> pair is removing liquidity which isn't a sell (i think, TODO: CHECK THIS)
        ) {
            sell = true;
            if (!isExcludedFromMaxSell[from]) {
                require(amount <= maxSellAmount, "amount above max sell limit");
                if (sellTimers[from].activated) {
                    if (block.timestamp < sellTimers[from].timestamp + sellTimerDuration) {
                        require(sellTimers[from].amount + amount <= maxDailySell, "Max Daily Sell Limit Reached");
                        sellTimers[from].amount += amount;
                    }
                    else {
                        sellTimers[from].amount = amount;
                        sellTimers[from].timestamp = block.timestamp;
                    }
                }
                else {
                    sellTimers[from].amount = amount;
                    sellTimers[from].timestamp = block.timestamp;
                    sellTimers[from].activated = true;
                }
            }
        }
        // Detect Buy
        else if (
            !swapping &&
            automatedMarketMakerPairs[from] &&
            to != pancakePair
            ) {
                buy = true;
            }

        uint contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            canSwap &&
            !swapping &&
            !automatedMarketMakerPairs[from]
        ) {
            swapping = true;
            swapAndLiquify(contractTokenBalance);
            swapping = false;
        }

        bool takeFee = !swapping;

        if (isExcludedFromFee[from] || isExcludedFromFee[to]) { //if either account is excluded dont take fee
            takeFee = false;
        }

        if (!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]) { // regular transfers dont incur fee
            takeFee = false;
        }

        // TODO: Fee is causing bugs...
        if (takeFee) {
            uint marketing;
            uint liquidity;
            if (buy) {
                (amount, marketing, liquidity) = calculateFees(amount, false);
            }
            else if (sell) {
                (amount, marketing, liquidity) = calculateFees(amount, true);
            }
            uint total = marketing + liquidity;
            super._transfer(from, address(this), total);
        }

        super._transfer(from, to, amount);
    }

    function calculateFees(uint amount, bool sell) public view returns(uint,uint,uint){
        uint marketing;
        uint liquidity;
        if (!sell) {
            marketing = (amount * marketingFee) / 10000;
            liquidity = (amount * liquidityFee) / 10000;
            amount = amount - (marketing + liquidity);
        }
        else if (sell) {
            marketing = (amount * (marketingFee + sellIncreaseMarketing)) / 10000;
            liquidity = (amount * (liquidityFee + sellIncreaseLiquidity)) / 10000;
            amount = amount - (marketing + liquidity);
        }
        return (amount, marketing, liquidity);
    }

    function swapAndLiquify(uint tokens) internal {
        _approve(address(this), msg.sender, tokens);
        require(transferFrom(address(this), address(liquidityManager), tokens), "Liquidity Transfer Failed");
        liquidityManager.swapAndLiquify(tokens);
    }
}