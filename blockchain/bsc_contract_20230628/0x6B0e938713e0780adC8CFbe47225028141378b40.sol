// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

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
    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
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
    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
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
    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
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
    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
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
    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
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

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IBEP20 {
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
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

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
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) external virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// --------------------------------
// Class Contract
// --------------------------------
contract Contract is IBEP20, Context, Ownable {
    using SafeMath for uint256;

    // Token information
    string public constant symbol = "LuckyMeme";
    string public constant name = "Lucky Meme";
    uint256 public constant decimals = 8;
    uint256 private _supply = 100 * (10 ** 6) * (10 ** decimals);
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowed;
    mapping(address => bool) private _masterAddress;
    address private _taxWallet;
    string public website = "";

    // Manager for reward
    address public rewardWallet = address(0);
    address[] public rewardHolders;
    uint256 public rewardMinHoldingBalance;
    uint256 public rewardTax;
    uint256 public rewardReceivedTax;
    uint256 public rewardMaxReceivedAmount;
    uint256 public rewardPeriod = 0;
    uint256 public rewardMinHoldersToGenerate = 10;
    mapping(uint256 => mapping(address => uint256)) public rewardResults;
    address[] private _luckyWallets;
    
    event SetWebsite(string url);
    event SetRewardMinHoldingBalance(uint256 min);
    event SetRewardMaxReceivedAmount(uint256 max);
    event SetRewardMinHoldersToGenerate(uint256 min);
    event SetRewardReceivedTax(uint256 tax);
    event SetRewardTax(uint256 tax);
    event SetRewardWallet(address addr);
    event GenerateReward(address holder, uint256 amount);
    event SetTaxWallet(address addr);

    constructor() {
        _balances[_msgSender()] = _supply;
        emit Transfer(address(0), _msgSender(), _supply);
    }

    // For transaction
    function totalSupply() external view override returns (uint256) {
        return _supply;
    }

    function balanceOf(
        address wallet
    ) public view override returns (uint256 balance) {
        return _balances[wallet];
    }

    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool success) {
        _allowed[_msgSender()][spender] = amount;
        emit Approval(_msgSender(), spender, amount);
        return true;
    }

    function validTransfer(
        address from,
        address to,
        uint256 amount
    ) private view returns (bool) {
        require(to != address(0), "Receive address must be a valid address");
        require(
            _balances[from] >= amount,
            "You have transferred in excess of the available quantity."
        );
        return true;
    }

    function transfer(
        address to,
        uint256 amount
    ) external override returns (bool success) {
        validTransfer(_msgSender(), to, amount);
        _balances[_msgSender()] = _balances[_msgSender()].sub(amount);
        _balances[to] = _balances[to].add(amount);

        if (_balances[_msgSender()] < rewardMinHoldingBalance)
            delRewardHolder(_msgSender());

        emit Transfer(_msgSender(), to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool success) {
        validTransfer(from, to, amount);
        require(
            _allowed[from][_msgSender()] >= amount,
            "Allowance is not enough to transfer"
        );

        uint256 tax = amount * rewardTax / 100;
        uint256 received = amount - tax;

        _allowed[from][_msgSender()] = _allowed[from][_msgSender()].sub(amount);
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(received);
        _balances[rewardWallet] = _balances[rewardWallet].add(tax);
        
        if (!isMasterWallet(from) && _balances[from] < rewardMinHoldingBalance) delRewardHolder(from);
        if (!isMasterWallet(to) && _balances[to] >= rewardMinHoldingBalance) addRewardHolder(to);

        emit Transfer(from, to, amount);
        return true;
    }

    function allowance(
        address tokenOwner,
        address spender
    ) external view override returns (uint256 remaining) {
        return _allowed[tokenOwner][spender];
    }

    function isMasterWallet(address holder) private view returns (bool) {
        return _masterAddress[holder] || owner() == holder;
    }

    function delRewardHolder(address holder) private {
        uint256 i;
        uint256 len = rewardHolders.length;

        for (i = 0; i < len; i++) {
            if (rewardHolders[i] == holder) {
                delete rewardHolders[i];
                return;
            }
        }
    }

    function addRewardHolder(address holder) private {
        rewardHolders.push(holder);
    }

    function rewardBalance() public view virtual returns (uint256) {
        return _balances[rewardWallet];
    }

    function setRewardMinHoldingBalance(uint256 amount) external onlyOwner {
        require(amount > 0, "Reward min holding balance must be > 0");
        rewardMinHoldingBalance = amount;
        emit SetRewardMinHoldingBalance(amount);
    }

    function setRewardTax(uint256 tax) external onlyOwner {
        require(tax > 0, "Tax must be > 0");
        rewardTax = tax;
        emit SetRewardTax(tax);
    }

    function setRewardReceivedTax(uint256 tax) external onlyOwner {
        require(tax > 0, "Tax must be > 0");
        rewardReceivedTax = tax;
        emit SetRewardReceivedTax(tax);
    }

    function setRewardMaxReceivedAmount(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be > 0");
        rewardMaxReceivedAmount = amount;
        emit SetRewardMaxReceivedAmount(amount);
    }

    function setRewardWallet(address addr) external onlyOwner {
        rewardWallet = addr;
        emit SetRewardWallet(addr);
    }

    function setRewardMinHoldersToGenerate(uint256 min) external onlyOwner {
        rewardMinHoldersToGenerate = min;
        emit SetRewardMinHoldersToGenerate(min);
    }

    function setWebsite(string memory w) external onlyOwner {
        website = w;
        emit SetWebsite(w);
    }

    function setTaxWallet(address addr) external onlyOwner {
        _taxWallet = addr;
        emit SetTaxWallet(addr);
    }

    function updateMasterAddress(address maddr, bool status) external onlyOwner {
      require(maddr != address(0), "Master address must be a valid address");
      _masterAddress[maddr] = status;
    }

    function randomHolderToReceiveReward() external onlyOwner{
        require(rewardHolders.length >= rewardMinHoldersToGenerate, "Min holders to receive a reward");

        // Get receivable balance
        uint256 rewardReceived = 0;

        if (rewardMaxReceivedAmount > 0 && _balances[rewardWallet] > rewardMaxReceivedAmount) rewardReceived = rewardMaxReceivedAmount;
        else rewardReceived = _balances[rewardWallet];

        // Get random lucky address
        rewardPeriod++;
        uint256 rand = uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,rewardPeriod))) % (rewardHolders.length - 1);
        address luckyWallet = rewardHolders[rand];

        // Calculate tax
        uint256 tax = rewardReceived * rewardReceivedTax / 100;
        uint256 balance = rewardReceived - tax;

        _balances[rewardWallet] = _balances[rewardWallet].sub(rewardReceived);
        _balances[_taxWallet] = _balances[_taxWallet].add(tax); // Tax to develop team
        _balances[luckyWallet] = _balances[luckyWallet].add(balance);

        // Add histories
        rewardResults[rewardPeriod][luckyWallet] = rewardReceived;

        delRewardHolder(luckyWallet);

        emit Transfer(rewardWallet, _taxWallet, tax);
        emit Transfer(rewardWallet, luckyWallet, balance);
        emit GenerateReward(luckyWallet, rewardReceived);
    }
}