// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
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

library Address {

    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {codehash := extcodehash(account)}
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success,) = recipient.call{ value : amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{ value : weiValue}(data);
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
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
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * This is a contract copied from 'Ownable.sol'
 * It has the same fundation of Ownable, besides it accept pendingOwner for mor Safe Use
 */
abstract contract SafeOwnable is Context {
    address private _owner;
    address private _pendingOwner;

    event ChangePendingOwner(address indexed previousPendingOwner, address indexed newPendingOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function pendingOwner() public view virtual returns (address) {
        return _pendingOwner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    modifier onlyPendingOwner() {
        require(pendingOwner() == _msgSender(), "Ownable: caller is not the pendingOwner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
        if (_pendingOwner != address(0)) {
            emit ChangePendingOwner(_pendingOwner, address(0));
            _pendingOwner = address(0);
        }
    }

    function setPendingOwner(address pendingOwner_) public virtual onlyOwner {
        require(pendingOwner_ != address(0), "Ownable: pendingOwner is the zero address");
        emit ChangePendingOwner(_pendingOwner, pendingOwner_);
        _pendingOwner = pendingOwner_;
    }

    function acceptOwner() public virtual onlyPendingOwner {
        emit OwnershipTransferred(_owner, _pendingOwner);
        _owner = _pendingOwner;
        emit ChangePendingOwner(_pendingOwner, address(0));
        _pendingOwner = address(0);
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

contract Relation{
    mapping(address => address) public relationship;
}


contract DorfSwapWrapper is SafeOwnable{
    using SafeMath for uint256;
    IUniswapV2Router02 public uniswapV2Router;
    address public deadAddress = 0x000000000000000000000000000000000000dEaD;

    address public usdtAddress;
    address public dorAddress;
    address public tokenAddress;

    address public marketAddress;
    address public backAddress;

    uint256 public deadDor = 0;
    uint256 public backLiquidity = 0;
    uint256 public lpAward = 0;


    constructor(address router,address usdt,address dor,address token,address market,address back) {
        uniswapV2Router = IUniswapV2Router02(router);
        usdtAddress = usdt;
        dorAddress = dor;
        tokenAddress = token;
        marketAddress = market;
        backAddress = back;
    }

    function setMarketAddress(address market) public onlyOwner{
        marketAddress = market;
    }

    function setBackAddress(address back) public onlyOwner{
        marketAddress = back;
    }

    function allocToken(uint256 _deadDor,uint256 _backLiquidity,uint256 _lpAward)  public onlyOwner{
        deadDor = deadDor.add(_deadDor);
        backLiquidity =  backLiquidity.add(_backLiquidity);
        lpAward = lpAward.add(_lpAward);
    }

    function swapAndLiquidity() public onlyOwner{
  
        swapTokensForToken(deadDor,tokenAddress,dorAddress,deadAddress);
      
        deadDor = 0;

        uint sellAmount = backLiquidity.div(2);
        sellAmount = sellAmount.add(lpAward);
        swapTokensForToken(sellAmount,tokenAddress,usdtAddress,address(this));
        uint256 usdtAmount = IERC20(usdtAddress).balanceOf(address(this));
        uint256 backUsdt = usdtAmount.mul(backLiquidity.add(lpAward)).mul(2).div(backLiquidity);
        uint256 backDorf = backLiquidity.div(2);
       
        addLiquidity(backUsdt,backDorf);
        backLiquidity = 0;

      
        uint256 usdtAmount2 = IERC20(usdtAddress).balanceOf(address(this));
        IERC20(usdtAddress).transfer(marketAddress,usdtAmount2);
        lpAward = 0;
    }


    function swapTokensForToken(
        uint256 tokenAmount,
        address path0,
        address path1,
        address to
    ) private {
        address[] memory path = new address[](2);
        path[0] = path0;
        path[1] = path1;
        IERC20(path[0]).approve(address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            to,
            block.timestamp + 60
        );
    }

    function addLiquidity(uint256 usdtAmount, uint256 tokenAmount) private {
        IERC20(usdtAddress).approve(address(uniswapV2Router), usdtAmount);
        IERC20(tokenAddress).approve(address(uniswapV2Router), tokenAmount);
        // add the liquidity
        uniswapV2Router.addLiquidity(
            usdtAddress,
            tokenAddress,
            usdtAmount,
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            backAddress,
            block.timestamp + 60
        );
    }
}

contract DORf is IERC20,SafeOwnable{
    using SafeMath for uint256;
    using Address for address;
    mapping(address => address) public relationship;
    mapping(address => bool) public isMarketPair;
    mapping(address => bool) public isExcludedFromFee;
    address public deadAddress = 0x000000000000000000000000000000000000dEaD;
    string private _name = "DORf";
    string private _symbol = "DORf";
    uint8 private _decimals = 18;
    uint256 private _totalSupply = 150 * 10 ** 8 * 10 ** _decimals;
    mapping(address => uint256) _balances;
    mapping (address => mapping(address => uint256)) private _allowances;

    bool inSwapAndLiquidity;
    IUniswapV2Router02 public uniswapV2Router;
    DorfSwapWrapper public wrapper;
    address public uniswapPair;
    address public uniDorPair;
    address public relationAddress;

    uint256 private minTokenSwap = 0;
    uint256 public openBlock = 97719596;

    modifier lockTheSwap {
        inSwapAndLiquidity = true;
        _;
        inSwapAndLiquidity = false;
    }

    constructor (address router,address usdt,address dor,address relation,address market,address back) {
        init(router,usdt,dor,relation,market,back);
    }

    function init(address router,address usdt,address dor,address relation,address market,address back) private{
        wrapper = new DorfSwapWrapper(router,usdt,dor,address(this),market,back);
        uniswapV2Router = IUniswapV2Router02(router);

        uniswapPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), usdt);
        uniDorPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), dor);
        relationAddress = relation;

        _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;

        isMarketPair[address(uniswapPair)] = true;
        isMarketPair[address(uniDorPair)] = true;

        _balances[_msgSender()] = _totalSupply;
        emit Transfer(address(0), _msgSender(), _totalSupply);

        isExcludedFromFee[owner()] = true;        
        isExcludedFromFee[address(wrapper)] = true;
        isExcludedFromFee[market] = true;
        isExcludedFromFee[back] = true;
        isExcludedFromFee[address(this)] = true;
        isExcludedFromFee[router] = true;
    }

    function setMarketAddress(address _marketAddress)  public onlyOwner{
        wrapper.setMarketAddress(_marketAddress);
    }

    function setBackLiquidityAddress(address _backAddress)  public onlyOwner{
        wrapper.setBackAddress(_backAddress);
    }

    function setRelationAddress(address _relationAddress)  public onlyOwner{
        relationAddress = _relationAddress;
    }

    function setMinTokenSwap(uint256 minTokenBalance) public onlyOwner{
        minTokenSwap = minTokenBalance;
    }

    function setIsExcludedFromFee(address account, bool newValue) public onlyOwner{
        isExcludedFromFee[account] = newValue;
    }

    function setOpenBlock(uint256 _openBlock) public  onlyOwner{
        openBlock = _openBlock;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(address(0)));
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");        
      
        if (inSwapAndLiquidity || isExcludedFromFee[sender] || isExcludedFromFee[recipient])
        {
            return _basicTransfer(sender, recipient, amount);
        }
        else
        {
            require(block.number > openBlock, "ERC20: not open yet");        
            uint256 contractBalance = _balances[address(this)];
            if(contractBalance >= minTokenSwap && !isMarketPair[sender]){
                swapAndLiquidity();
            }
           
            _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

          
            _balances[recipient] = _balances[recipient].add(amount.mul(92).div(100));
            emit Transfer(sender, recipient, amount.mul(92).div(100));

           
            if(isMarketPair[sender]){
               
                address parent = Relation(relationAddress).relationship(recipient);
                _balances[parent] = _balances[parent].add(amount.mul(2).div(100));
                emit Transfer(sender, parent, amount.mul(2).div(100));

                
                _balances[address(wrapper)] = _balances[address(wrapper)].add(amount.mul(6).div(100));
                emit Transfer(sender, address(wrapper), amount.mul(6).div(100));
                wrapper.allocToken(amount.mul(1).div(100),amount.mul(2).div(100),amount.mul(3).div(100));
            }
           
            else{
                _balances[address(wrapper)] = _balances[address(wrapper)].add(amount.mul(8).div(100));
                emit Transfer(sender, address(wrapper), amount.mul(8).div(100));
                wrapper.allocToken(amount.mul(1).div(100),amount.mul(2).div(100),amount.mul(5).div(100));
            }

            return true;
        }
    }

    function swapAndLiquidity() private lockTheSwap {
        wrapper.swapAndLiquidity();
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }
}