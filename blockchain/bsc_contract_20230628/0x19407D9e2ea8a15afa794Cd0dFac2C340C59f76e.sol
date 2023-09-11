// SPDX-License-Identifier: MIT

pragma solidity =0.6.12;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

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

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
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
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

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

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

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
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b == 0) return (false, 0);
        return (true, a % b);
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
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
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
        require(b <= a, "SafeMath: subtraction overflow");
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
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
        require(b > 0, "SafeMath: modulo by zero");
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
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
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
        require(b > 0, errorMessage);
        return a / b;
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
        require(b > 0, errorMessage);
        return a % b;
    }
}

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
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
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
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
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
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
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
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
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
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
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
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
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
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev Implementation of the {IBEP20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {BEP20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of BEP20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IBEP20-approve}.
 */

contract BEP20 is Context, IBEP20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view override returns (address) {
        return owner();
    }

    /**
     * @dev Returns the token name.
     */
    function name() public view override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the token decimals.
     */
    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {BEP20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {BEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {BEP20-allowance}.
     */
    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {BEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {BEP20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {BEP20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "BEP20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "BEP20: decreased allowance below zero"
            )
        );
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
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
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(
            amount,
            "BEP20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");

        _balances[account] = _balances[account].sub(
            amount,
            "BEP20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
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
    ) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(
            account,
            _msgSender(),
            _allowances[account][_msgSender()].sub(
                amount,
                "BEP20: burn amount exceeds allowance"
            )
        );
    }
}

/**
 * @title SafeBEP20
 * @dev Wrappers around BEP20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IBEP20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IBEP20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IBEP20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeBEP20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(
            value
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeBEP20: decreased allowance below zero"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeBEP20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeBEP20: BEP20 operation did not succeed"
            );
        }
    }
}

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// PERKS PROTOCOL
// website: https://perksprotocol.app
// dapp: https://rewards.perksprotocol.app
// telegram: https://t.me/perksDeFi
// twitter: https://twitter.com/PerksProtocol
// docs: https://docs.perksprotocol.app

contract PerksProtocol is BEP20, ReentrancyGuard {
    using Address for address;
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;
    using Address for address payable;

    // User data
    struct UserData {
        uint256 rewardBalance;
        uint256 claimedReward;
        uint256 lostReward;
        uint256 inputsAmount;
        uint256 nextClaim;
        uint256 nextProcess;
    }

    // Individual user data
    mapping(address => UserData) public userData;

    // Perks address
    address private perksToken;

    // Time-lock
    address private constant TIME_LOCK =
        0x9a0b8234acCDDb572f2e78217A0788b701eE2327;
    // Time-locked
    bool public timeLocked = false;

    // Max supply
    uint256 private constant MAX_SUPPLY = 100_000 ether;

    // Swap router
    IUniswapV2Router02 public swapRouter;
    // Router address
    address private routerAddress = address(swapRouter);
    // Trading pair
    address public swapPair;

    // User processing
    mapping(address => bool) private processing;
    // Process fund delay
    uint256 public processDelay = 60 minutes;
    // Max process fund delay
    uint256 private constant MAX_PROCESS_DELAY = 24 hours;

    // Enable trading
    bool public enableTrading = false;
    // Enable trading time
    uint256 private enableTradingTime;

    // Enable referral
    bool public enableReferral = true;
    // Referrer address
    mapping(address => address) public referrers;
    // Referrer count
    mapping(address => uint256) public referralsCount;
    // Referred claims
    mapping(address => uint256) public referredClaims;
    // Referral rate
    uint256 public rateReferral = 10 ether;
    //Max referral rate
    uint256 private constant MAX_RATE_REFERRAL = 100 ether;

    // Enable burn
    bool public enableBurn = true;
    // Burn rate
    uint256 public rateBurn = 10;
    // Max burn rate
    uint256 private constant MAX_RATE_BURN = 20;
    // Burn address
    address private constant BURN_ADDRESS =
        0x000000000000000000000000000000000000dEaD;

    // Enable liquidity generation
    bool public enableLiquidity = true;
    // Liquidity fund
    uint256 public liquidityFund;
    // Liquidity rate
    uint256 public rateLiquidity = 14;
    // Max liquidity rate
    uint256 private constant MAX_RATE_LIQUIDITY = 25;
    // Liquidity lock
    uint256 private constant LIQUIDITY_LOCK = 365 days;

    // PERKS liquify
    uint256 public perksLiquify = 1 ether;
    // Max PERKS liquify
    uint256 private constant MAX_PERKS_LIQUIFY = 10 ether;

    // Enable treasury
    bool public enableTreasury = true;
    // Treasury fund
    uint256 public treasuryFund;
    // Treasury rate
    uint256 public rateTreasury = 12;
    // Max treasury rate
    uint256 private constant MAX_RATE_TREASURY = 25;
    // Treasury address
    address public treasuryAddress;

    // Enable reward
    bool public enableReward = true;
    // Reward rate
    uint256 public rateReward = 10;
    // Max reward rate
    uint256 private constant MAX_RATE_REWARD = 100;
    // Reward claim delay
    uint256 public claimDelay = 1 days;
    // Max reward claim delay
    uint256 private constant MAX_CLAIM_DELAY = 7 days;

    // Total reward unclaimed
    uint256 public rewardUnclaimed;
    // Total reward claimed
    uint256 public rewardClaimed;

    // Exclude reward address
    mapping(address => bool) public excludeReward;
    // Include reward recipient
    mapping(address => bool) public includeRecipient;
    // Include reward sender
    mapping(address => bool) public includeSender;

    // Enable compound reward
    bool public enableCompound = true;
    // Compound reward rate
    uint256 public rateCompound = 100;
    // Max compound reward rate
    uint256 private constant MAX_RATE_COMPOUND = 100;
    // Compound claim delay
    uint256 public compoundDelay = 7 days;
    // Max compound claim delay
    uint256 private constant MAX_COMPOUND_DELAY = 28 days;
    // Compound list
    mapping(address => uint256) private compoundList;
    // Compound address
    address[] private compoundAddress;
    // Compound status
    mapping(address => uint256) public compoundStatus;

    // Enable bot tax
    bool public enableBotTax = true;
    // Bot transfer
    mapping(address => uint256) public botVerify;
    // Bot tax
    uint256 public botTax = 15;
    // Max bot tax
    uint256 private constant MAX_BOT_TAX = 25;
    // Bot blocks
    uint256 public blockLocks = 5;
    // Max bot blocks
    uint256 private constant MAX_BLOCK_LOCKS = 10;

    // Events
    event TradingEnable(address indexed caller, uint256 timeEnabled);
    event BurnSupply(address indexed caller, uint256 burnAmount);
    event UpdateExcludeReward(
        address indexed caller,
        address indexed excludeAddress,
        bool isExcluded
    );
    event UpdateIncludeRecipient(
        address indexed caller,
        address indexed includeRecipient,
        bool isIncluded
    );
    event UpdateIncludeSender(
        address indexed caller,
        address indexed includeSender,
        bool isIncluded
    );
    event UpdateRates(
        address indexed caller,
        bool liquidityEnabled,
        uint256 liquidityRate,
        bool treasuryEnabled,
        uint256 treasuryRate,
        bool rewardEnabled,
        uint256 rewardRate,
        bool burnEnabled,
        uint256 burnRate,
        bool compoundEnable,
        uint256 compoundRate,
        bool referralEnabled,
        uint256 rateReferral,
        uint256 perksLiquify
    );
    event UpdateTreasuryAddress(
        address indexed caller,
        address indexed AddressTreasury
    );
    event UpdateBot(
        address indexed caller,
        bool botTaxEnabled,
        uint256 botTax,
        uint256 blockLocks
    );
    event UpdateDelay(
        address indexed caller,
        uint256 delayClaim,
        uint256 delayCompound,
        uint256 delayProcess
    );
    event UpdateSwapRouter(
        address indexed caller,
        address indexed router,
        address indexed pair
    );

    /**
     **	timeLock modifier
     **/
    modifier timeLock() {
        address _owner = owner();

        if (enableTrading) {
            _owner = TIME_LOCK;
        }

        require(msg.sender == _owner, "Perks:: timeLock: only owner.");
        _;
    }

    /**
     **	userOnly modifier
     **/
    modifier userOnly() {
        require(msg.sender == tx.origin, "Perks:: userOnly: invalid caller.");
        _;
    }

    /**
     **	inProcess modifier
     */
    modifier inProcess() {
        require(!processing[tx.origin], "Perks:: inProcess: user processing.");
        processing[tx.origin] = true;
        _;
        processing[tx.origin] = false;
    }

    /**
     **	Perks Token constructor
     **/
    constructor(address _routerAddress, address _treasuryAddress)
        public
        BEP20("Perks Protocol", "Perks")
    {
        // Initialize router
        swapRouter = IUniswapV2Router02(_routerAddress);

        // Approve on router
        _approve(address(this), address(swapRouter), type(uint256).max);

        // Create swapPair
        swapPair = IUniswapV2Factory(swapRouter.factory()).createPair(
            address(this),
            swapRouter.WETH()
        );

        treasuryAddress = _treasuryAddress;
        perksToken = address(this);

        // Reward inclusion
        includeSender[swapPair] = true;

        // Reward exclusions
        excludeReward[perksToken] = true;
        excludeReward[msg.sender] = true;
        excludeReward[address(0)] = true;
        excludeReward[BURN_ADDRESS] = true;
        excludeReward[treasuryAddress] = true;

        // Mint total supply
        _mint(treasuryAddress, (MAX_SUPPLY).mul(30).div(100));
        _mint(perksToken, (MAX_SUPPLY).mul(70).div(100));
    }

    /**
     * transferOwnership override
     *
     */
    function transferOwnership(address _timeLock)
        public
        virtual
        override
        onlyOwner
    {
        // Ownership check
        require(!timeLocked, "Perks:: transferOwnership: already transferred.");

        // Only TIME_LOCK
        require(
            _timeLock == TIME_LOCK,
            "Perks:: transferOwnership: only to TIME_LOCK."
        );

        // Transfer ownership
        super.transferOwnership(_timeLock);
    }

    /**
     **	enableTrading function
     **
     **/
    function tradingEnable() external onlyOwner {
        require(!enableTrading, "Perks:: tradingEnable: already enabled.");

        enableTradingTime = block.timestamp;
        enableTrading = true;

        // Ownership transfer: TIME_LOCK
        transferOwnership(TIME_LOCK);

        // Time-locked
        timeLocked = true;

        emit TradingEnable(owner(), enableTradingTime);
    }

    /**
     **	rescueToken function
     **/
    function rescueToken(address _tokenAddress, address _recipient)
        external
        timeLock
    {
        require(_tokenAddress != perksToken, "Perks:: rescueToken: Not Perks.");
        if (_tokenAddress == swapPair)
            require(
                enableTradingTime.add(LIQUIDITY_LOCK) < block.timestamp,
                "Perks:: rescueToken: liquidity locked."
            );

        if (_tokenAddress == address(0x0)) {
            uint256 _balance = perksToken.balance;
            require(_balance > 0, "Perks:: rescueToken: no balance.");
            payable(_recipient).sendValue(_balance);
            return;
        }

        IBEP20 _token = IBEP20(_tokenAddress);
        uint256 _balance = _token.balanceOf(perksToken);
        require(_balance > 0, "Perks:: rescueToken: no balance.");
        _token.safeTransfer(_recipient, _balance);
    }

    /**
     **	canFund function
     **/
    function canFund(uint256 _amount) private view returns (bool) {
        return
            (balanceOf(perksToken)) >=
            (_amount).add(rewardUnclaimed).add(liquidityFund).add(treasuryFund);
    }

    /**
     **	balanceFund function
     **/
    function balanceFund() private view returns (uint256) {
        return
            (balanceOf(perksToken)).sub(
                (rewardUnclaimed).add(liquidityFund).add(treasuryFund)
            );
    }

    /**
     **	compoundCheck function
     **/
    function compoundCheck(address _user, uint256 _compoundable) private {
        // Compounding list
        if (compoundList[_user] == 0) {
            // New user
            compoundList[_user] = 1;

            // Compounding status
            compoundStatus[_user] = _compoundable;

            // Add user
            compoundAddress.push(_user);
        } else {
            // Compounding status
            compoundStatus[_user] = _compoundable;
        }
    }

    /**
     **	botTransferCheck function
     **/
    function botTransferCheck(
        address _user,
        address _sender,
        address _recipient,
        uint256 _amount
    ) private returns (bool) {
        // User
        UserData storage user = userData[_user];

        bool _isBot = false;

        // Bot penalty
        if (enableBotTax && botVerify[_user] > block.number) {
            // Reward unclaimed
            rewardUnclaimed = (rewardUnclaimed).sub(user.rewardBalance);

            // Lost reward
            user.lostReward = user.lostReward.add(user.rewardBalance);

            // Forfeit rewards
            user.rewardBalance = 0;
            user.nextProcess = 0;
            user.nextClaim = 0;

            // Set compounding
            compoundCheck(_user, 0);

            // Max block delay
            botVerify[_user] = (block.number).add(MAX_BLOCK_LOCKS);

            // Bot tax
            uint256 _botTax = (_amount).mul(botTax).div(100);
            _amount = (_amount).sub(_botTax);

            // Burn tax
            _burn(_sender, _botTax);

            // Transfer balance
            super._transfer(_sender, _recipient, _amount);

            // Bot status
            _isBot = true;
        }

        return _isBot;
    }

    /**
     **	addDelay function
     **/
    function addDelay(address _user, uint256 _status) private {
        if (!excludeReward[_user]) {
            // User
            UserData storage user = userData[_user];

            // Set compounding
            compoundCheck(_user, _status);

            // Claiming delay
            user.nextClaim = (block.timestamp).add(claimDelay);

            // Process delay
            user.nextProcess = (block.timestamp).add(processDelay);
        }
    }

    /**
     **	termCompound function
     **/
    function termCompound(address _user) private {
        // Excluded reward
        if (!excludeReward[_user] && enableCompound) {
            // User
            UserData storage user = userData[_user];

            // Check compound
            (uint256 _canCompound, uint256 _compoundBalance) = canCompound(
                _user
            );

            if (_canCompound > 0 && _compoundBalance > 0) {
                // Check fund
                if (canFund(_compoundBalance)) {
                    // Full reward
                    rewardUnclaimed = (rewardUnclaimed).add(_compoundBalance);
                    user.rewardBalance = user.rewardBalance.add(
                        _compoundBalance
                    );
                } else {
                    // Final reward
                    uint256 _balanceFund = balanceFund();

                    if (_balanceFund > user.rewardBalance) {
                        // Partial reward
                        rewardUnclaimed = (rewardUnclaimed).add(_balanceFund);
                        user.rewardBalance = _balanceFund;
                    } else {
                        // Last reward
                        rewardUnclaimed = (rewardUnclaimed).add(_balanceFund);
                        user.rewardBalance = user.rewardBalance.add(
                            _balanceFund
                        );
                    }

                    // Disable rewards
                    enableCompound = false;
                    enableReward = false;
                    enableReferral = false;
                }
            }
        }
    }

    /**
     **	updateBalance function
     **/
    function updateBalance(address _user, uint256 _reward) private {
        if (!excludeReward[_user]) {
            // User
            UserData storage user = userData[_user];

            // Term compound
            termCompound(_user);

            // Compound status
            uint256 _status = compoundStatus[_user];

            // Enable compounding
            if (_reward >= user.claimedReward) _status = 1;

            // Delay & compound status
            addDelay(_user, _status);

            // Reward unclaimed
            rewardUnclaimed = (rewardUnclaimed).add(_reward);

            // Add reward
            user.rewardBalance = user.rewardBalance.add(_reward);
        }
    }

    /**
     **	processReward function
     **/
    function processReward(address _user, uint256 _amount) private {
        // User
        UserData storage user = userData[_user];

        // Transactional reward
        uint256 _rewardAmount = (_amount).mul(rateReward).div(100);

        // User inputs
        user.inputsAmount = (user.inputsAmount).add(_amount);

        // Check funds
        if (canFund(_rewardAmount)) {
            // Update balance
            updateBalance(_user, _rewardAmount);
        }
    }

    /**
     **	executeReward function
     **/
    function executeReward(
        address _user,
        address _sender,
        address _recipient,
        uint256 _amount
    ) private {
        // User
        UserData storage user = userData[_user];

        // Buy reward
        if (_recipient == _user && includeSender[_sender]) {
            // Reward process
            processReward(_user, _amount);

            // Partnership reward
        } else if (_sender == _user && includeRecipient[_recipient]) {
            // Reward process
            processReward(_user, _amount);

            // Other transfers
        } else {
            // Set compounding
            compoundCheck(_user, 0);

            // Reward forfeit
            if (user.nextClaim > block.timestamp) {
                // Reward unclaimed
                rewardUnclaimed = (rewardUnclaimed).sub(user.rewardBalance);

                // Lost reward
                user.lostReward = user.lostReward.add(user.rewardBalance);

                // Reward balance
                user.rewardBalance = 0;
            }
        }
    }

    /**
     **	_transfer function
     **/
    function _transfer(
        address _sender,
        address _recipient,
        uint256 _amount
    ) internal virtual override {
        // Reward address
        address _user = tx.origin;

        // Zero amount
        if (_amount == 0) {
            // Finalize transfer
            super._transfer(_sender, _recipient, _amount);
            return;
        }

        // Burn transfer
        if (_recipient == BURN_ADDRESS) {
            // Perks burn
            _burn(_sender, _amount);
            return;
        }

        // Excluded reward address
        if (
            excludeReward[_sender] ||
            excludeReward[_recipient] ||
            excludeReward[_user]
        ) {
            // Finalize transfer
            super._transfer(_sender, _recipient, _amount);
            return;
        }

        // Bot transfers
        if (botTransferCheck(_user, _sender, _recipient, _amount)) return;

        // Trading enabled
        require(enableTrading, "Perks:: _transfer: trading not enabled.");

        // User reward
        if (enableReward && !processing[_user]) {
            executeReward(_user, _sender, _recipient, _amount);
        }

        // Project funds
        uint256 _liquidityFund;
        uint256 _treasuryFund;
        uint256 _burnFund;

        // Liquidity fund
        _liquidityFund = enableLiquidity
            ? (_amount).mul(rateLiquidity).div(100)
            : _liquidityFund;

        // Treasury fund
        _treasuryFund = enableTreasury
            ? (_amount).mul(rateTreasury).div(100)
            : _treasuryFund;

        // Burn fund
        _burnFund = enableBurn ? (_amount).mul(rateBurn).div(100) : _burnFund;

        // Total required
        uint256 _requiredFund = (_liquidityFund).add(_treasuryFund).add(
            _burnFund
        );

        _requiredFund = !canFund(_requiredFund) ? 0 : _requiredFund;

        // Process funds
        if (_requiredFund > 0) {
            // Update liquidity
            liquidityFund = _liquidityFund > 0
                ? (liquidityFund).add(_liquidityFund)
                : liquidityFund;

            // Update treasury
            treasuryFund = _treasuryFund > 0
                ? (treasuryFund).add(_treasuryFund)
                : treasuryFund;

            // Burn transaction
            if (_burnFund > 0) _burn(perksToken, _burnFund);
        }

        // Router transaction
        bool _pairRouter = (_sender == swapPair) &&
            (_recipient == address(swapRouter));

        // Bot verify
        if (enableBotTax) {
            botVerify[_user] = (block.number).add(blockLocks);
            botVerify[_user] = _pairRouter ? 0 : botVerify[_user];
        }

        // Finalize transfer
        super._transfer(_sender, _recipient, _amount);
    }

    /**
     **	updateClaim function
     **/
    function updateClaim(address _user, uint256 _reward) private {
        // User
        UserData storage user = userData[_user];

        // Reward unclaimed
        rewardUnclaimed = (rewardUnclaimed).sub(_reward);

        // Reward claimed
        rewardClaimed = (rewardClaimed).add(_reward);

        // User reward balance
        user.claimedReward = (user.claimedReward).add(_reward);
        user.rewardBalance = (user.rewardBalance).sub(_reward);
    }

    /**
     **	claimReward function
     **/
    function claimReward() external nonReentrant inProcess userOnly {
        // User
        address _user = tx.origin;
        UserData storage user = userData[_user];
        uint256 _reward = user.rewardBalance;

        require(
            !excludeReward[_user],
            "Perks:: claimReward: excluded from reward."
        );

        require(_reward > 0, "Perks:: claimReward: no reward balance.");

        require(
            user.nextClaim < block.timestamp,
            "Perks:: claimReward: invalid claim time."
        );

        require(user.nextClaim > 0, "Perks:: claimReward: invalid claim time.");

        require(
            user.inputsAmount >= rateReferral,
            "Perks:: claimReward: no inputs."
        );

        // Term compound
        termCompound(_user);

        // Delay & compound status
        addDelay(_user, 0);

        // PERKS contract balance
        uint256 _balanceToken = balanceOf(perksToken);
        uint256 _termReward = user.rewardBalance;
        uint256 _transferReward;

        if (_balanceToken >= _termReward) {
            // Full amount
            _transferReward = _termReward;

            // Update claim
            updateClaim(_user, _termReward);
        } else if (_balanceToken > 0) {
            // Partial amount
            _transferReward = _balanceToken;

            // Update claim
            updateClaim(_user, _termReward);

            // Reward disable
            enableReward = false;
            enableCompound = false;
            enableReferral = false;
        } else {
            // No amount
            _transferReward = 0;

            // Update claim
            updateClaim(_user, _termReward);

            //No amount
            enableReward = false;
            enableCompound = false;
            enableReferral = false;
        }

        // Transfer reward
        if (_transferReward > 0) {
            IBEP20(perksToken).safeTransfer(_user, _transferReward);
        }

        // Reward referral
        if (enableReward && enableReferral) addReferralReward(_user, _reward);
    }

    /**
     **	addReferralReward function
     **/
    function addReferralReward(address _referred, uint256 _reward) private {
        // Referrer address
        address _referrer = referrers[_referred];

        // Referrer reward
        if (_referrer != address(0)) {
            // Check funds
            if (canFund(_reward)) {
                // Update balance
                updateBalance(_referrer, _reward);

                // Referred claims
                referredClaims[_referrer] = referredClaims[_referrer].add(
                    _reward
                );
            } else {
                // Disable referral
                enableReferral = false;
            }
        }
    }

    /**
     **	canReward function
     **/
    function canReward(address _user, uint256 _reward)
        public
        view
        returns (bool)
    {
        // User
        UserData memory user = userData[_user];

        //Reward conditions
        bool _canReward = (enableReward &&
            user.nextProcess < block.timestamp &&
            user.nextProcess > 0 &&
            user.inputsAmount >= rateReferral &&
            canFund(_reward));

        return _canReward;
    }

    /**
     **	canCompound function
     **/
    function canCompound(address _user) public view returns (uint256, uint256) {
        // User
        UserData memory user = userData[_user];
        uint256 _rewardBalance = user.rewardBalance;
        uint256 _compoundDelay = user.nextClaim.add(compoundDelay);
        uint256 _canCompound;
        uint256 _compoundBalance;

        if (
            enableTrading &&
            enableReward &&
            enableCompound &&
            user.nextClaim > 0 &&
            user.inputsAmount >= rateReferral &&
            compoundStatus[_user] > 0 &&
            _compoundDelay < block.timestamp
        ) {
            // Compound reward
            _compoundBalance = (_rewardBalance.mul(rateCompound).div(100));

            // Compound check
            _canCompound = canFund(_compoundBalance) ? 1 : _canCompound;
        }

        return (_canCompound, _compoundBalance);
    }

    /**
     **	compoundUser function
     **/
    function compoundUser(address _user)
        external
        nonReentrant
        userOnly
        inProcess
    {
        require(enableCompound, "Perks:: compoundUser: compound disabled.");

        (uint256 _canCompound, uint256 _compoundBalance) = canCompound(_user);

        require(
            _canCompound > 0 && _compoundBalance > 0,
            "Perks:: compoundUser: no compound."
        );

        // Term compound
        termCompound(_user);

        // Delay & compound status
        addDelay(_user, 0);
    }

    /**
     **	massCompoundReward function
     **/
    function massCompoundReward() public view returns (uint256) {
        // User
        address _user = tx.origin;

        uint256 _compoundRewards;
        uint256 _addressLength = compoundAddress.length;

        for (uint256 i; i < _addressLength; i++) {
            address _compoundUser = compoundAddress[i];

            if (_compoundUser == _user) continue;

            if (compoundStatus[_compoundUser] > 0) {
                (uint256 _canCompound, uint256 _compoundBalance) = canCompound(
                    _compoundUser
                );

                if (
                    _canCompound > 0 &&
                    canFund(_compoundRewards.add(_compoundBalance))
                ) {
                    _compoundRewards = _compoundRewards.add(_compoundBalance);
                }
            }
        }

        uint256 _userReward;

        if (_compoundRewards > 0) {
            // Transactional reward
            _userReward = _compoundRewards.mul(rateReward).div(100);
        }

        // Check funding
        _userReward = canFund(_userReward.add(_compoundRewards))
            ? _userReward
            : 0;

        return _userReward;
    }

    /**
     **	massCompound function
     ** gas guzzler: costly transaction
     **/
    function massCompound() external nonReentrant userOnly inProcess {
        // User
        address _user = tx.origin;

        require(enableCompound, "Perks:: massCompound: compound disabled.");

        uint256 _reward = massCompoundReward();
        bool _canReward = canReward(_user, _reward);

        if ((!_canReward || _reward == 0) && !excludeReward[_user])
            require(_canReward, "Perks:: massCompound: no reward.");

        uint256 _addressLength = compoundAddress.length;

        for (uint256 i; i < _addressLength; i++) {
            address _compoundUser = compoundAddress[i];

            if (_compoundUser == _user) {
                continue;
            }

            if (!enableCompound) {
                compoundStatus[_compoundUser] = 0;
                continue;
            }

            if (compoundStatus[_compoundUser] > 0) {
                // Term compound
                termCompound(_compoundUser);

                // Delay & compound status
                addDelay(_compoundUser, 0);
            }
        }

        // Update balance
        updateBalance(_user, _reward);
    }

    /**
     **	getEstimate function
     **/
    function getEstimate(uint256 _amountToken) private view returns (uint256) {
        address[] memory _path = new address[](2);
        _path[0] = perksToken;
        _path[1] = swapRouter.WETH();
        return swapRouter.getAmountsIn(_amountToken, _path)[0];
    }

    /**
     **	swapToken function
     **/
    function swapToken(uint256 _amountToken) private {
        address[] memory _path = new address[](2);
        _path[0] = perksToken;
        _path[1] = swapRouter.WETH();
        swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            _amountToken,
            0,
            _path,
            perksToken,
            block.timestamp
        );
    }

    /**
     **	addLiquidity function
     **/
    function addLiquidity(uint256 _amountToken, uint256 _amountBNB) private {
        swapRouter.addLiquidityETH{value: _amountBNB}(
            perksToken,
            _amountToken,
            0,
            0,
            perksToken,
            block.timestamp
        );
    }

    /**
     **	processFunding function
     **/
    function processFunding() external nonReentrant userOnly inProcess {
        require(perksLiquify > 0, "Perks:: processFunding: liquify disabled.");

        require(
            enableLiquidity || enableTreasury,
            "Perks:: processFunding: funding disabled."
        );

        uint256 _requiredFund = (getEstimate(perksLiquify));

        require(
            ((liquidityFund >= _requiredFund) ||
                (treasuryFund >= _requiredFund)),
            "Perks:: processFunding: insufficient fund."
        );

        bool _canAddLiquidity = liquidityFund >= _requiredFund;
        bool _canAddTreasury = treasuryFund >= _requiredFund;
        uint256 _rewardAmount;

        _rewardAmount = _canAddLiquidity
            ? (_rewardAmount).add(_requiredFund)
            : _rewardAmount;
        _rewardAmount = _canAddTreasury
            ? (_rewardAmount).add(_requiredFund)
            : _rewardAmount;

        executeFunding(
            _rewardAmount,
            _requiredFund,
            _canAddLiquidity,
            _canAddTreasury
        );
    }

    /**
     **	executeFunding function
     **/
    function executeFunding(
        uint256 _rewardAmount,
        uint256 _requiredFund,
        bool _canAddLiquidity,
        bool _canAddTreasury
    ) private {
        //User
        address _user = tx.origin;
        uint256 _balanceBNB = (perksToken.balance);
        uint256 _reward;

        // Transactional reward
        if (enableReward) _reward = (_rewardAmount).mul(rateReward).div(100);

        bool _canReward = canReward(_user, _reward);

        if ((!_canReward || _reward == 0) && !excludeReward[_user])
            require(_canReward, "Perks:: executeFunding: no user reward.");

        // Liquidity fund
        if (_canAddLiquidity) {
            // Liquidity generation
            uint256 _liquidityHalf = (_requiredFund).mul(50).div(100);
            uint256 _liquidityBalance = (_requiredFund).sub(_liquidityHalf);

            // Swap PERKS
            swapToken(_liquidityHalf);

            uint256 _liquidityBNB = (perksToken.balance).sub(_balanceBNB);

            // Add liquidity
            addLiquidity(_liquidityBalance, _liquidityBNB);

            liquidityFund = (liquidityFund).sub(_requiredFund);
            _balanceBNB = (perksToken.balance);
        }

        // Treasury fund
        if (_canAddTreasury) {
            // Swap PERKS
            swapToken(_requiredFund);
            uint256 _treasuryFund = (perksToken.balance).sub(_balanceBNB);

            // Fund treasury
            payable(treasuryAddress).sendValue(_treasuryFund);
            treasuryFund = (treasuryFund).sub(_requiredFund);
        }

        // Reward user
        if (_canReward && canFund(_reward)) {
            updateBalance(_user, _reward);
        }
    }

    /**
     **	referralAccept function
     **/
    function referralAccept(address _referrer)
        external
        nonReentrant
        userOnly
        inProcess
    {
        // User
        address _referred = tx.origin;
        UserData storage referrer = userData[_referrer];
        UserData storage referred = userData[_referred];

        // Check referral
        require(
            enableTrading &&
                enableReward &&
                enableReferral &&
                _referred != address(0) &&
                _referrer != address(0) &&
                referrers[_referred] == address(0) &&
                referrers[_referrer] != _referred &&
                !excludeReward[_referred] &&
                !excludeReward[_referrer] &&
                _referred != _referrer &&
                referrer.inputsAmount >= referred.inputsAmount &&
                referrer.inputsAmount >= rateReferral,
            "Perks:: referralAccept: invalid referral."
        );

        // Set referral
        referrers[_referred] = _referrer;
        referralsCount[_referrer] = referralsCount[_referrer].add(1);

        // Reward referred
        if (canFund(rateReferral)) {
            // Update reward
            rewardUnclaimed = (rewardUnclaimed).add(rateReferral);
            referred.rewardBalance = referred.rewardBalance.add(rateReferral);
        } else {
            enableReferral = false;
        }
    }

    /**
     **	burnSupply function
     **/
    function burnSupply(uint256 _amount) external timeLock {
        uint256 _balanceToken = balanceOf(perksToken);
        require(_balanceToken > 0, "Perks:: burnSupply: zero.");
        require(_amount > 0, "Perks:: burnSupply: zero.");
        require(canFund(_amount), "Perks:: burnSupply: insufficient balance.");
        _burn(perksToken, _amount);
        emit BurnSupply(TIME_LOCK, _amount);
    }

    /**
     ** updateExcludeReward:
     ** excludeReward
     **/
    function updateExcludeReward(
        address _excludeRewardAddress,
        bool _excludeReward
    ) external timeLock {
        require(
            excludeReward[_excludeRewardAddress] != _excludeReward,
            "Perks:: excludeReward: no change."
        );

        excludeReward[_excludeRewardAddress] = _excludeReward;

        emit UpdateExcludeReward(
            TIME_LOCK,
            _excludeRewardAddress,
            _excludeReward
        );
    }

    /**
     ** updateIncludeRecipient:
     ** includeRecipient
     **/
    function updateIncludeRecipient(
        address _includeRecipient,
        bool _includeReward
    ) external timeLock {
        require(
            _includeRecipient.isContract(),
            "Perks:: includeRecipient: only contract."
        );

        require(
            includeRecipient[_includeRecipient] != _includeReward,
            "Perks:: includeRecipient: no change."
        );

        includeRecipient[_includeRecipient] = _includeReward;

        emit UpdateIncludeRecipient(
            TIME_LOCK,
            _includeRecipient,
            _includeReward
        );
    }

    /**
     ** updateIncludeSender:
     ** includeSender
     **/
    function updateIncludeSender(address _includeSender, bool _includeReward)
        external
        timeLock
    {
        require(
            _includeSender.isContract(),
            "Perks:: includeSender: only contract."
        );

        require(
            includeSender[_includeSender] != _includeReward,
            "Perks:: includeSender: no change."
        );

        includeSender[_includeSender] = _includeReward;

        emit UpdateIncludeSender(TIME_LOCK, _includeSender, _includeReward);
    }

    /**
     ** updateRates:
     ** enableLiquidity, rateLiquidity
     ** enableTreasury, rateTreasury,
     ** enableReward, rateReward
     ** enableCompound, rateCompound
     ** enableBurn, rateBurn
     ** enableReferral, rateReferral
     ** perksLiquify
     **/
    function updateRates(
        uint256 _rateLiquidity,
        uint256 _rateTreasury,
        uint256 _rateReward,
        uint256 _rateBurn,
        uint256 _rateCompound,
        uint256 _rateReferral,
        uint256 _perksLiquify
    ) external timeLock {
        require(
            _rateLiquidity <= MAX_RATE_LIQUIDITY,
            "Perks:: _rateLiquidity: exceeds MAX_RATE_LIQUIDITY."
        );

        require(
            _rateTreasury <= MAX_RATE_TREASURY,
            "Perks:: _rateTreasury: exceeds MAX_RATE_TREASURY."
        );

        require(
            _rateReward <= MAX_RATE_REWARD,
            "Perks:: _rateReward: exceeds MAX_RATE_REWARD."
        );

        require(
            _rateCompound <= MAX_RATE_COMPOUND,
            "Perks:: _rateCompound: exceeds MAX_RATE_COMPOUND."
        );

        require(
            _rateBurn <= MAX_RATE_BURN,
            "Perks:: _rateBurn: exceeds MAX_RATE_BURN."
        );

        require(
            _rateReferral <= MAX_RATE_REFERRAL,
            "Perks:: _rateReferral: exceeds MAX_RATE_REFERRAL."
        );

        require(
            _perksLiquify <= MAX_PERKS_LIQUIFY,
            "Perks:: perksLiquify: exceeds MAX_PERKS_LIQUIFY."
        );

        enableLiquidity = _rateLiquidity > 0 ? true : false;
        enableTreasury = _rateTreasury > 0 ? true : false;
        enableReward = _rateReward > 0 ? true : false;
        enableCompound = _rateCompound > 0 ? true : false;
        enableBurn = _rateBurn > 0 ? true : false;
        enableReferral = _rateReferral > 0 ? true : false;

        rateLiquidity = rateLiquidity != _rateLiquidity
            ? _rateLiquidity
            : rateLiquidity;

        rateTreasury = rateTreasury != _rateTreasury
            ? _rateTreasury
            : rateTreasury;

        rateReward = rateReward != _rateReward ? _rateReward : rateReward;

        rateCompound = rateCompound != _rateCompound
            ? _rateCompound
            : rateCompound;

        rateBurn = rateBurn != _rateBurn ? _rateBurn : rateBurn;

        rateReferral = rateReferral != _rateReferral
            ? _rateReferral
            : rateReferral;

        perksLiquify = perksLiquify != _perksLiquify
            ? _perksLiquify
            : perksLiquify;

        emit UpdateRates(
            TIME_LOCK,
            enableLiquidity,
            _rateLiquidity,
            enableTreasury,
            _rateTreasury,
            enableReward,
            _rateReward,
            enableCompound,
            _rateCompound,
            enableBurn,
            _rateBurn,
            enableReferral,
            _rateReferral,
            _perksLiquify
        );
    }

    /**
     ** updateTreasuryAddress:
     ** treasuryAddress
     **/
    function updateTreasuryAddress(address _treasuryAddress) external timeLock {
        require(
            _treasuryAddress != address(0),
            "Perks:: treasuryAddress: zero address."
        );

        treasuryAddress = treasuryAddress != _treasuryAddress
            ? _treasuryAddress
            : treasuryAddress;

        emit UpdateTreasuryAddress(TIME_LOCK, _treasuryAddress);
    }

    /**
     **	updateBot:
     ** enableBotTax, botTax
     ** blockLocks
     **/
    function updateBot(uint256 _botTax, uint256 _blockLocks) external timeLock {
        require(
            _botTax <= MAX_BOT_TAX,
            "Perks:: _botTax: cannot be exceeded MAX_BOT_TAX."
        );

        require(
            _blockLocks <= MAX_BLOCK_LOCKS,
            "Perks:: blockLocks: cannot be exceeded MAX_BLOCK_LOCKS."
        );

        enableBotTax = (_botTax > 0 && _blockLocks > 0) ? true : false;
        botTax = botTax != _botTax ? _botTax : botTax;
        blockLocks = blockLocks != _blockLocks ? _blockLocks : blockLocks;

        emit UpdateBot(TIME_LOCK, enableBotTax, _botTax, _blockLocks);
    }

    /**
     **	updateDelay:
     ** claimDelay
     ** compoundDelay
     ** processDelay
     **/
    function updateDelay(
        uint256 _claimDelay,
        uint256 _compoundDelay,
        uint256 _processDelay
    ) external timeLock {
        require(
            _claimDelay <= MAX_CLAIM_DELAY,
            "Perks:: claimDelay: exceeds MAX_CLAIM_DELAY."
        );

        require(
            _compoundDelay <= MAX_COMPOUND_DELAY,
            "Perks:: compoundDelay: exceeds MAX_COMPOUND_DELAY."
        );

        require(
            _processDelay <= MAX_PROCESS_DELAY,
            "Perks:: processDelay: exceeds MAX_PROCESS_DELAY."
        );

        claimDelay = claimDelay != _claimDelay ? _claimDelay : claimDelay;

        compoundDelay = compoundDelay != _compoundDelay
            ? _compoundDelay
            : compoundDelay;

        processDelay = processDelay != _processDelay
            ? _processDelay
            : processDelay;

        emit UpdateDelay(TIME_LOCK, _claimDelay, _compoundDelay, _processDelay);
    }

    /**
     **	updateSwapRouter:
     ** swapRouter
     ** swapRouter
     **/
    function updateSwapRouter(address _routerAddress) external timeLock {
        require(
            _routerAddress != address(0),
            "Perks:: swapRouter: zero address."
        );

        require(
            _routerAddress != routerAddress,
            "Perks:: swapRouter: no change."
        );

        // Set router
        swapRouter = IUniswapV2Router02(_routerAddress);

        // Create pair
        swapPair = IUniswapV2Factory(swapRouter.factory()).createPair(
            perksToken,
            swapRouter.WETH()
        );

        // Include pair
        includeSender[swapPair] = true;

        // Approve max
        _approve(perksToken, routerAddress, type(uint256).max);

        emit UpdateSwapRouter(TIME_LOCK, routerAddress, swapPair);
    }

    receive() external payable {}
}