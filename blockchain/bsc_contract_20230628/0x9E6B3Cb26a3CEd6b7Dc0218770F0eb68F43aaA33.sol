// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface IERC20 {

    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
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

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
library SafeMath {
  function add(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    require(c >= a, "SafeMath: addition overflow");
    return c;
  }
  function sub(uint a, uint b) internal pure returns (uint) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }
  function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
    require(b <= a, errorMessage);
    uint c = a - b;
    return c;
  }
  function mul(uint a, uint b) internal pure returns (uint) {
    if (a == 0) {
      return 0;
    }
    uint c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");
    return c;
  }
  function div(uint a, uint b) internal pure returns (uint) {
    return div(a, b, "SafeMath: division by zero");
  }
  function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }
  function mod(uint a, uint b) internal pure returns (uint) {
    return mod(a, b, "SafeMath: modulo by zero");
  }
  function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
    require(b != 0, errorMessage);
    return a % b;
  }
}
library Math {
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}
interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}
interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
contract usdtReceiver {
    address private usdt = 0x55d398326f99059fF775485246999027B3197955;
    constructor() {
        IERC20(usdt).approve(msg.sender,~uint(0));
    }
}
contract MeMeMe is Context, IERC20, Ownable {

    using SafeMath for uint;

    address fundaddress = 0xFEC8Dd7f3468238d510E0497C7D2644a799fD017;
    address usdt = 0x55d398326f99059fF775485246999027B3197955;
    address public immutable pair;
    address lastaccount;

    mapping (address => uint) private _balances;
    mapping (address => mapping (address => uint)) private _allowances;

    mapping(address => bool) public ISIDOLP;
    mapping(address => bool) public ISLPHolder;
    mapping(address => uint) public LPamount;

    address[] public LPHoldList;

    uint fundfee = 3;
    uint lpfee = 2;

    uint lastklast;
    uint nowklast;
    uint lastlptotal;
    uint nowlptotal;

    uint private constant E18 = 1000000000000000000;
    uint private constant MAX = ~uint(0);
    uint private _totalSupply = 2100000000000000 * E18;
    uint private _decimals = 18;
    string private _symbol = "MeMeMe";
    string private _name = "MeMeMe";
    IERC20 USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IUniswapV2Router02 public immutable uniswapV2Router;
    usdtReceiver public USDTReceiver;
    
    bool istrade;
    bool inSwap;
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }
    constructor(address recipient){

        _balances[recipient] = _totalSupply;
        IUniswapV2Router02 Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        pair = IUniswapV2Factory(Router.factory()).createPair(address(this), usdt);
        uniswapV2Router = Router;
        USDTReceiver = new usdtReceiver();
        emit Transfer(address(0), recipient, _totalSupply);

    }

    receive() external payable {}

    function decimals() public view  returns(uint) {
        return _decimals;
    }
    function symbol() public view  returns (string memory) {
        return _symbol;
    }
    function name() public view  returns (string memory) {
        return _name;
    }
    function totalSupply() public override view returns (uint) {
        return _totalSupply;
    }
    function balanceOf(address account) public override view returns (uint) {
        return _balances[account];
    }
    function transfer(address recipient, uint amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view override returns (uint) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function getLPHoldList() view external returns(address[] memory){
        return LPHoldList;
    }
    
    function _transfer(address sender, address to, uint amount) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(_balances[sender] >= amount,"exceed balance!");
        
        lastklast = nowklast;
        nowklast = IUniswapV2Pair(pair).kLast();
        lastlptotal = nowlptotal;
        nowlptotal = IUniswapV2Pair(pair).totalSupply();

        if(nowklast != lastklast){ // last add or remove
            LPamount[lastaccount] = IUniswapV2Pair(pair).balanceOf(lastaccount);
            if(!ISLPHolder[lastaccount]){
                ISLPHolder[lastaccount] = true;
                LPHoldList.push(lastaccount);
            }
        }
        
        if(to == pair){ // sell / addlp

            _tokenTransfer(sender,to,amount,true);
            lastaccount = sender;

        }else if(sender == pair){ // buy / removelp
            if(nowlptotal < lastlptotal){
                if(ISIDOLP[to]){
                    _balances[sender] = _balances[sender].sub(amount);
                    _totalSupply = _totalSupply.sub(amount);
                    _balances[address(0)] = _balances[to].add(amount);
                    emit Transfer(sender, address(0), amount);
                }else{
                    require(LPamount[to] >= (lastlptotal.sub(nowlptotal)),"insufficient lp balance");
                    _tokenTransfer(sender,to,amount,true);
                }
            }else{
                _tokenTransfer(sender,to,amount,true);
            }
            
            lastaccount = to;
        }else{ //transfer
            _tokenTransfer(sender,to,amount,false);
            lastaccount = sender;
        }
        
    }
    function _tokenTransfer(address sender, address to, uint amount, bool ishaveFee) private {

        if(!ishaveFee){
            _balances[sender] = _balances[sender].sub(amount);
            _balances[to] = _balances[to].add(amount);
            emit Transfer(sender, to, amount);
        }else{
            uint feeamount = amount.mul(fundfee.add(lpfee)).mul(100).div(10000);
            uint leftamount = amount.sub(feeamount);

            _balances[sender] = _balances[sender].sub(amount);
            _balances[address(this)] = _balances[address(this)].add(feeamount);
            _balances[to] = _balances[to].add(leftamount);

            emit Transfer(sender, to, leftamount);
            emit Transfer(sender, address(this), feeamount);
        }
    } 

    function DistributeAndLiquify() external {

        uint balance = _balances[address(this)];
        swapTokensForUSDT(balance);
        
        uint usdtAmount = USDT.balanceOf(address(this));
        uint fundfeeamount = usdtAmount.mul(fundfee).div(fundfee.add(lpfee));
        uint leftlpfee = usdtAmount.sub(fundfeeamount);
        USDT.transfer(fundaddress,fundfeeamount);
        
        uint TotalLP;
        IUniswapV2Pair mainPair = IUniswapV2Pair(pair);
        for(uint i; i < LPHoldList.length; i++) {
            TotalLP += mainPair.balanceOf(LPHoldList[i]);
        }
        if(TotalLP > 0){
            for(uint i; i < LPHoldList.length; i++){
                uint lpamount = mainPair.balanceOf(LPHoldList[i]);
                if(lpamount > 0){
                    uint reward = lpamount.mul(leftlpfee).div(TotalLP);
                    USDT.transfer(LPHoldList[i],reward);
                }
            } 
        }
    }
    function swapTokensForUSDT(uint tokenAmount) private {
        
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdt;

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, 
            path,
            address(USDTReceiver),
            block.timestamp
        );
        uint usdtamount = USDT.balanceOf(address(USDTReceiver));
        IERC20(usdt).transferFrom(address(USDTReceiver), address(this), usdtamount);

    }
    function _approve(address owner, address spender, uint amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function SetIDOLPlist(address[] memory account) external onlyOwner {
        require(account.length > 0, "no account");
        for(uint i; i < account.length; i++) {
            address user = account[i];
            if(!ISLPHolder[user]){
                LPHoldList.push(user);
                ISIDOLP[user] = true;
                ISLPHolder[user] = true;
            }
        }
    }
    function setLPAmount(address account, uint256 lpAmount) public onlyOwner {
        LPamount[account] = lpAmount;
    }
    function claimLeftToken(address token) external onlyOwner {
        uint left = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(_msgSender(), left);
    }

}