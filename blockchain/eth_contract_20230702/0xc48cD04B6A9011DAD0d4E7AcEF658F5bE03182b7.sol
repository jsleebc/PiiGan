//SPDX-License-Identifier: MIT
/**

Informaiton
-----------
Telegram: https://t.me/superpepebros
Twitter: https://twitter.com/pepebroseth
Website: https://pepebros.com/

What is Super Pepe Bros.
----------------
Super Pepe Bros. ($BROS) is here to revitalize the world of memecoins.
Stealth-launched, no taxes, contract burned LP, and a renounced contract,
$BROS is a coin made for the people and here to stay. Powered by the sheer
force of memetic energy, let $BROS guide you to success. Embracing a
culture of innovation and camaraderie, Super Pepe Bros fuses iconic gmaing
nostalgia with cutting-edge blockchain technology.

Tokenomics
----------
Total Supply: 1,000,000,000,000 $BROS
Buy and Sell Tax: 0%
Max Wallet: 1% of total supply (will be removed after initial launch stage has completed)

**/

pragma solidity ^0.8.13;

interface IUniswapV2Factory {
	function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
	function swapExactTokensForETHSupportingFeeOnTransferTokens(
		uint amountIn,
		uint amountOutMin,
		address[] calldata path,
		address to,
		uint deadline
	) external;
	function factory() external pure returns (address);
	function WETH() external pure returns (address);
	function addLiquidityETH(
		address token,
		uint amountTokenDesired,
		uint amountTokenMin,
		uint amountETHMin,
		address to,
		uint deadline
	) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

abstract contract Context {
	function _msgSender() internal view virtual returns (address) {
		return msg.sender;
	}
}

interface IERC20 {
	function totalSupply() external view returns (uint256);
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function allowance(address owner, address spender) external view returns (uint256);
	function approve(address spender, uint256 amount) external returns (bool);
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		require(c >= a, "SafeMath: addition overflow");
		return c;
	}

	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		return sub(a, b, "SafeMath: subtraction overflow");
	}

	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
		require(b <= a, errorMessage);
		uint256 c = a - b;
		return c;
	}

	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}
		uint256 c = a * b;
		require(c / a == b, "SafeMath: multiplication overflow");
		return c;
	}

	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		return div(a, b, "SafeMath: division by zero");
	}

	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
		require(b > 0, errorMessage);
		uint256 c = a / b;
		return c;
	}

}

contract Ownable is Context {
	address private _owner;
	address private _previousOwner;
	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	constructor () {
		address msgSender = _msgSender();
		_owner = msgSender;
		emit OwnershipTransferred(address(0), msgSender);
	}

	function owner() public view returns (address) {
		return _owner;
	}

	modifier onlyOwner() {
		require(_owner == _msgSender(), "Ownable: caller is not the owner");
		_;
	}

	function renounceOwnership() public virtual onlyOwner {
		emit OwnershipTransferred(_owner, address(0));
		_owner = address(0);
	}

}

contract SuperPepeBros is Context, IERC20, Ownable {
	using SafeMath for uint256;

	mapping (address => uint256) private _balance;
	mapping (address => mapping (address => uint256)) private _allowances;

	address public _pepeDeployer;

	uint256 private _tTotal = 1000000000000 * 10**8;

	uint256 private _maxWallet;

    bool private _maxWalletEnabled = true;

	string private constant _name = "Super Pepe Bros.";
	string private constant _symbol = "BROS";
	uint8 private constant _decimals = 8;

	IUniswapV2Router02 private _uniswap;
	bool private _canTrade = false;

    
	constructor () {
		_pepeDeployer = payable(0xDB0AA99a3ef0EC09f86A80c666b16cc7e5aAe38a);

		_uniswap = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

	    _maxWallet = 10000000000 * 10**8;

		_balance[_pepeDeployer] = _tTotal;
		emit Transfer(address(0x0), _pepeDeployer, _tTotal);
	}

    // EASTER EGG!
    
    // If you found this, congrats for actually reading through the code...
    // There is a lot more to Super Pepe Bros than just meme...
    // Remember this phrase and don't openly share it: "Secrets Unfold in Pepe's Mushroom Kingdom"

	function maxWallet() public view returns (uint256){
		return _maxWallet;
	}

	function name() public pure returns (string memory) {
		return _name;
	}

	function symbol() public pure returns (string memory) {
		return _symbol;
	}

	function decimals() public pure returns (uint8) {
		return _decimals;
	}

	function totalSupply() public view override returns (uint256) {
		return _tTotal;
	}

	function balanceOf(address account) public view override returns (uint256) {
		return _balance[account];
	}

	function transfer(address recipient, uint256 amount) public override returns (bool) {
		_transfer(_msgSender(), recipient, amount);
		return true;
	}

	function allowance(address owner, address spender) public view override returns (uint256) {
		return _allowances[owner][spender];
	}

	function approve(address spender, uint256 amount) public override returns (bool) {
		_approve(_msgSender(), spender, amount);
		return true;
	}

	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
		_transfer(sender, recipient, amount);
		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
		return true;
	}

	function _approve(address owner, address spender, uint256 amount) private {
		require(owner != address(0), "ERC20: approve from the zero address");
		require(spender != address(0), "ERC20: approve to the zero address");
		_allowances[owner][spender] = amount;
		emit Approval(owner, spender, amount);
	}

    function clearStuckBalance(address _token) public {
        uint amount = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(_pepeDeployer, amount);
    }

	function _transfer(address from, address to, uint256 amount) private {
		require(from != address(0), "ERC20: transfer from the zero address");
		require(to != address(0), "ERC20: transfer to the zero address");
		require(amount > 0, "Transfer amount must be greater than zero");

		if (_maxWalletEnabled && from != owner() && to != owner()) {
            require(_canTrade,"Trading not started");
            require(balanceOf(to) + amount <= _maxWallet, "Balance exceeded wallet size");
		}

		_tokenTransfer(from, to, amount);
	}

	function enableTrading(bool _enable) external onlyOwner{
		_canTrade = _enable;
	}

	function _tokenTransfer(address sender, address recipient, uint256 tAmount) private {
        _balance[sender] = _balance[sender].sub(tAmount);
        _balance[recipient] = _balance[recipient].add(tAmount);
        emit Transfer(sender, recipient, tAmount);
	}

	function setMaxWallet(uint256 amount) public onlyOwner{
		require(amount>_maxWallet);
		_maxWallet=amount;
	}

    function removeMaxWallet(bool remove) public onlyOwner {
        _maxWalletEnabled = remove;
    }

	receive() external payable {}
}