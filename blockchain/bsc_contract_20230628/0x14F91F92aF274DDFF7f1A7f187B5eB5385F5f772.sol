// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

library EnumerableSet {
    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

abstract contract ReentrancyGuard {

    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {

        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;

        _;

        _status = _NOT_ENTERED;
    }
}

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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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

library SafeMath {
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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
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
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
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
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    function ceil(uint a, uint m) internal pure returns (uint r) {
        return (a + m - 1) / m * m;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

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

contract SRGONE is Ownable, IERC20, ReentrancyGuard {
    using SafeMath for uint256;
    enum TxType { FromExcluded, ToExcluded, BothExcluded, Standard }

    mapping (address => uint256) private rSRGONEBalance;
    mapping (address => uint256) private tSRGONEBalance;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => uint256) private totalDeposits;
    mapping (address => uint256) private totalWithdrawals;
    mapping (address => uint256) private totalTransfersOut;
    mapping (address => uint256) private totalTransfersIn;
    mapping (address => uint256) private feesAccruedByAddress;

    EnumerableSet.AddressSet excluded;

    uint256 private tSRGONESupply;
    uint256 private rSRGONESupply;
    uint256 private feesAccrued;

    string private _name = 'Surge One';
    string private _symbol = 'SRGONE';
    uint8  private _decimals = 9;

    address public SRG = 0x9f19c8e321bD14345b797d43E01f0eED030F5Bff;

    event  Deposit(address indexed account, uint amount);
    event  Withdrawal(address indexed account, uint amount);

    constructor () {
        EnumerableSet.add(excluded, address(0));
        emit Transfer(address(0), msg.sender, 0);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return tSRGONESupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (EnumerableSet.contains(excluded, account)) return tSRGONEBalance[account];
        (uint256 r, uint256 t) = currentSupply();
        return (rSRGONEBalance[account] * t) / r;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
        return true;
    }

    function isExcluded(address account) public view returns (bool) {
        return EnumerableSet.contains(excluded, account);
    }

    function totalFees() public view returns (uint256) {
        return feesAccrued;
    }

    function totalFeesByAddress(address account) public view returns (uint256) {
        return feesAccruedByAddress[account];
    }

    function getAccount(address _account) public view returns (address account, bool excludedFromFees, uint256 balance, uint256 deposits, uint256 withdrawals, uint256 transfersOut, uint256 transfersIn, uint256 fees) {
        account = _account;
        excludedFromFees = isExcluded(_account);
        balance = balanceOf(_account);
        deposits = totalDeposits[_account];
        withdrawals = totalWithdrawals[_account];
        transfersOut = totalTransfersOut[_account];
        transfersIn = totalTransfersIn[_account];
        fees = feesAccruedByAddress[_account];
    }

    function deposit(uint256 _amount) public {
        require(_amount > 0, "can't deposit nothing");
        _receiveBaseToken(msg.sender, _amount);
        (uint256 r, uint256 t) = currentSupply();
        uint256 fee = _amount / 100;
        uint256 net = fee != 0 ? (_amount - (fee)) : _amount;
        tSRGONESupply += _amount;
        if(isExcluded(msg.sender)){
            tSRGONEBalance[msg.sender] += (_amount- fee);
        }

        rSRGONESupply += ((net * r) / t);
        rSRGONEBalance[msg.sender] += ((net * r) / t);

        feesAccrued += fee;
        totalDeposits[msg.sender] += _amount;
        feesAccruedByAddress[msg.sender] += fee;

        emit Transfer(address(0), msg.sender, (_amount - fee));
        emit Deposit(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount && _amount <= totalSupply(), "invalid _amount");
        (uint256 r, uint256 t) = currentSupply();
        uint256 fee = _amount / 100;
        uint256 net = _amount - fee;
        if(isExcluded(msg.sender)) {
            tSRGONEBalance[msg.sender] -= _amount;
            rSRGONEBalance[msg.sender] -= ((_amount * r) / t);
        } else {
            rSRGONEBalance[msg.sender] -= ((_amount * r) / t);
        }

        tSRGONESupply -= net;
        rSRGONESupply -= ((net * r ) / t);
        feesAccrued += fee;
        _sendBaseToken(msg.sender, net);

        totalWithdrawals[msg.sender] += _amount;
        feesAccruedByAddress[msg.sender] += fee;

        emit Transfer(msg.sender, address(0), _amount);
        emit Withdrawal(msg.sender, net);
    }

    function _receiveBaseToken(address from, uint amount) internal nonReentrant {
        bool xfer = IERC20(SRG).transferFrom(from, address(this), amount);
        require(xfer, "ERR_ERC20_FALSE");
    }

    function _sendBaseToken(address to, uint amount) internal nonReentrant {
        bool xfer = IERC20(SRG).transfer(to, amount);
        require(xfer, "ERR_ERC20_FALSE");
    }

    function rSRGONEToEveryone(uint256 amt) public {
        require(!isExcluded(msg.sender), "not allowed");
        (uint256 r, uint256 t) = currentSupply();
        rSRGONEBalance[msg.sender] -= ((amt * r) / t);
        rSRGONESupply -= ((amt * r) / t);
        feesAccrued += amt;
        feesAccruedByAddress[msg.sender] += amt;
    }

    function excludeFromFees(address account) external onlyOwner {
        require(!EnumerableSet.contains(excluded, account), "address excluded");
        if(rSRGONEBalance[account] > 0) {
            (uint256 r, uint256 t) = currentSupply();
            tSRGONEBalance[account] = (rSRGONEBalance[account] * (t)) / (r);
        }
        EnumerableSet.add(excluded, account);
    }

    function includeInFees(address account) external onlyOwner {
        require(EnumerableSet.contains(excluded, account), "address not excluded");
        tSRGONEBalance[account] = 0;
        EnumerableSet.remove(excluded, account);
    }

    function tSRGONEFromrSRGONE(uint256 rSRGONEAmount) external view returns (uint256) {
        (uint256 r, uint256 t) = currentSupply();
        return (rSRGONEAmount * t) / r;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function getTxType(address sender, address recipient) internal view returns (TxType t) {
        bool isSenderExcluded = EnumerableSet.contains(excluded, sender);
        bool isRecipientExcluded = EnumerableSet.contains(excluded, recipient);
        if (isSenderExcluded && !isRecipientExcluded) {
            t = TxType.FromExcluded;
        } else if (!isSenderExcluded && isRecipientExcluded) {
            t = TxType.ToExcluded;
        } else if (!isSenderExcluded && !isRecipientExcluded) {
            t = TxType.Standard;
        } else if (isSenderExcluded && isRecipientExcluded) {
            t = TxType.BothExcluded;
        } else {
            t = TxType.Standard;
        }
        return t;
    }

    function _transfer(address sender, address recipient, uint256 amt) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amt > 0, "Transfer amt must be greater than zero");
        (uint256 r, uint256 t) = currentSupply();
        uint256 fee = amt / 100;
        TxType tt = getTxType(sender, recipient);
        if (tt == TxType.ToExcluded) {
            rSRGONEBalance[sender] -= ((amt * r) / t);
            tSRGONEBalance[recipient] += (amt - fee);
            rSRGONEBalance[recipient] += (((amt - fee) * r) / t);
            feesAccruedByAddress[sender] += fee;
        } else if (tt == TxType.FromExcluded) {
            tSRGONEBalance[sender] -= (amt);
            rSRGONEBalance[sender] -= ((amt * r) / t);
            rSRGONEBalance[recipient] += (((amt - fee) * r) / t);
            feesAccruedByAddress[recipient] += fee;
        } else if (tt == TxType.BothExcluded) {
            tSRGONEBalance[sender] -= (amt);
            rSRGONEBalance[sender] -= ((amt * r) / t);
            tSRGONEBalance[recipient] += (amt - fee);
            rSRGONEBalance[recipient] += (((amt - fee) * r) / t);
        } else {
            rSRGONEBalance[sender] -= ((amt * r) / t);
            rSRGONEBalance[recipient] += (((amt - fee) * r) / t);
            feesAccruedByAddress[sender] += fee;
            feesAccruedByAddress[recipient] += fee;
        }
        rSRGONESupply  -= ((fee * r) / t);
        feesAccrued += fee;

        totalTransfersOut[sender] += amt;
        totalTransfersIn[recipient] += amt;

        emit Transfer(sender, recipient, amt - fee);
    }

    function currentSupply() public view returns(uint256, uint256) {
        if(rSRGONESupply == 0 || tSRGONESupply == 0) return (1000000000, 1);
        uint256 rSupply = rSRGONESupply;
        uint256 tSupply = tSRGONESupply;
        for (uint256 i = 0; i < EnumerableSet.length(excluded); i++) {
            if (rSRGONEBalance[EnumerableSet.at(excluded, i)] > rSupply || tSRGONEBalance[EnumerableSet.at(excluded, i)] > tSupply) return (rSRGONESupply, tSRGONESupply);
            rSupply -= (rSRGONEBalance[EnumerableSet.at(excluded, i)]);
            tSupply -= (tSRGONEBalance[EnumerableSet.at(excluded, i)]);
        }
        if (rSupply < rSRGONESupply / tSRGONESupply) return (rSRGONESupply, tSRGONESupply);
        return (rSupply, tSupply);
    }

    //collect random tokens sent to contract
    function claimRandomToken(address token_address) external onlyOwner {
        require(token_address != address(this), "can't claim this token");
        require(token_address != SRG, "can't claim the base token");
        uint256 amt = IERC20(token_address).balanceOf(address(this));
        IERC20(token_address).transfer(owner(), amt);
    }

    //collect random native token sent to contract
    receive() external payable {
        payable(owner()).transfer(address(this).balance);
    }
}