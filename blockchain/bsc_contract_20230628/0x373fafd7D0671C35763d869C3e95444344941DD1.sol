/**
 *Submitted for verification at BscScan.com on 2023-06-02
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

abstract contract Context {
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }
  function _msgData() internal view virtual returns (bytes memory) {
    this;
    // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
    external
    view
    returns (
        uint112 reserve0,
        uint112 reserve1,
        uint32 blockTimestampLast
    );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
    external
    returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
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

contract Ownable is Context {
    address _owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender() , "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
    external
    returns (
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
    external
    payable
    returns (
        uint256 amountToken,
        uint256 amountETH,
        uint256 liquidity
    );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}

contract TokenReceiver{
    constructor (address token) {
      IERC20(token).approve(msg.sender,10 ** 15 * 10**18);
    }
}

contract BFWToken is Context, IERC20, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;

    uint8 private _decimals = 18;
    uint256 private _tTotal = 1000000000 * 10 ** _decimals;

    string private _name = "BFW";
    string private _symbol = "BFW";
    
    uint256 public _backflowFee = 3;
    uint256 public _repoFee = 2;
    uint256 public totalFee = 5;

    IUniswapV2Router02 public uniswapV2Router;

    mapping(address => bool) public ammPairs;

    bool inSwapAndLiquify;
    
    address public uniswapV2Pair;
    address public awardToken = address(0xC9882dEF23bc42D53895b8361D0b1EDC7570Bc6A);
    address public _route = address(0x1B6C9c20693afDE803B27F8782156c0f892ABC2d);
    // address public awardToken = address(0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684);
    // address public _route = address(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);

    address public deadWallet = address(0x000000000000000000000000000000000000dEaD);
    address public MKAddress = address(0x2c4b7Df57E1EfC9cbAD7CabB814B33b450BAdeFB);
    address public tokenReceiver;

    bool public swapsEnabled = true;

    uint256 public maxTxAmount = 10 * 10** _decimals;

    uint256 public maxFistAmount = 1 * 10 ** _decimals;

    uint256 public currentTime;
    uint256 public limitTime = 48 hours;


    uint256 currentIndex;
    uint256 distributorGas = 500000;
    uint256 public minPeriod = 10 minutes;
    uint256 public LPFeefenhong;
    mapping(address => bool) private _updated;

    address private fromAddress;
    address private toAddress;

    address[] shareholders;
    mapping(address => uint256) shareholderIndexes;

    constructor () {
      _tOwned[msg.sender] = _tTotal;
      
      _isExcludedFromFee[msg.sender] = true;
      _isExcludedFromFee[address(this)] = true;
      _isExcludedFromFee[address(0)] = true;

      uniswapV2Router = IUniswapV2Router02(_route);
        
      uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), awardToken);

      ammPairs[uniswapV2Pair] = true;

      tokenReceiver = address(new TokenReceiver(address(awardToken)));
      _owner = msg.sender;

      currentTime = block.timestamp;
      LPFeefenhong = block.timestamp;
      emit Transfer(address(0), msg.sender, _tTotal);
    }

    receive() external payable {}

    function setAmmPair(address pair,bool hasPair)external onlyOwner{
        ammPairs[pair] = hasPair;
    }

    function setTxAmount(uint256 _tx)external onlyOwner{
        maxTxAmount = _tx;
    }

    function setTime(uint256 _limit)external onlyOwner{
        limitTime = _limit;
        currentTime = block.timestamp;
    }

    function setFistAmount(uint256 ft)external onlyOwner{
        maxFistAmount = ft;
    }

    function setMinPeriod(uint mp)external onlyOwner{
        minPeriod = mp;
    }

    function setSwapsEnabled(bool _enabled) public onlyOwner {
      swapsEnabled = _enabled;
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
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
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

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    
    function excludeFromFee(address account) public onlyOwner {
      _isExcludedFromFee[account] = true;
    }
    
    function includeInFee(address account) public onlyOwner {
      _isExcludedFromFee[account] = false;
    }

    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(address owner, address spender, uint256 amount) private {
      require(owner != address(0), "ERC20: approve from the zero address");
      require(spender != address(0), "ERC20: approve to the zero address");

      _allowances[owner][spender] = amount;
      emit Approval(owner, spender, amount);
    }

    struct Param{
        bool takeFee;
        uint tTransferAmount;
        uint tbackflow;
        uint trepo;
    }

    function _initParam(uint256 tAmount,Param memory param) private view  {
      param.tbackflow = tAmount * _backflowFee / 100;
      param.trepo = tAmount * _repoFee / 100;
      uint tFee = tAmount * totalFee / 100;
      param.tTransferAmount = tAmount.sub(tFee);
    }

    function _takeFee(Param memory param,address from)private {
      if( param.tbackflow > 0 ){
        _take(param.tbackflow, from, address(this));
      }
      if( param.trepo > 0 ){
        _take(param.trepo, from, address(this));
      }
    }

    function _take(uint256 tValue,address from,address to) private {
      _tOwned[to] = _tOwned[to].add(tValue);
      emit Transfer(from, to, tValue);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(swapsEnabled || _isExcludedFromFee[from] || _isExcludedFromFee[to], "zero");

        bool hasLiquidity = IERC20(uniswapV2Pair).totalSupply() > 1000;

        bool isAddLdx;
        if(to == uniswapV2Pair){
          isAddLdx = _isAddLiquidityV1();
        }

        bool isRemoveLP;
        if(from == uniswapV2Pair){
          isRemoveLP = _isRemoveLiquidity();
        }

        Param memory param;

        param.tTransferAmount = amount;

        uint256 contractTokenBalance = balanceOf(address(this));
        
        if( 
            contractTokenBalance >= maxTxAmount 
            && !inSwapAndLiquify 
            && !ammPairs[from] 
            && hasLiquidity 
            && !isAddLdx){

            contractTokenBalance = maxTxAmount;

            inSwapAndLiquify = true;
            // LP
            swapAndAward(contractTokenBalance.mul(6).div(10));
            // MK
            swapAndMK(contractTokenBalance.mul(4).div(10));
            inSwapAndLiquify = false;
        }

        bool takeFee = true;

        if( ammPairs[from] && _isExcludedFromFee[to]  ){
            takeFee = false;
        }

        if( ammPairs[to] && _isExcludedFromFee[from] ){
            takeFee = false;
        }

        if( !ammPairs[from] && !ammPairs[to] && (_isExcludedFromFee[from] || _isExcludedFromFee[to]) ){
            takeFee = false;
        }

        if (block.timestamp > currentTime.add(limitTime)) {
            isRemoveLP = false;
        }

        if (isAddLdx || isRemoveLP) {
          takeFee = false;
        }

        param.takeFee = takeFee;
        if( takeFee ){
          _initParam(amount,param);
        }

        _tokenTransfer(from,to,amount,isRemoveLP,param);

        if (fromAddress == address(0)) fromAddress = from;
        if (toAddress == address(0)) toAddress = to;
        if ( !ammPairs[fromAddress] ) setShare(fromAddress);
        if ( !ammPairs[toAddress] ) setShare(toAddress);
        fromAddress = from;
        toAddress = to;

        if (
            LPFeefenhong.add(minPeriod) <= block.timestamp 
            && IERC20(awardToken).balanceOf(address(this)) > maxFistAmount
            && hasLiquidity && !isAddLdx ) {

            process(distributorGas);
            LPFeefenhong = block.timestamp;
        }
    }

    function swapAndMK(uint256 tokenAmount) private  {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = awardToken;

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            tokenReceiver,
            block.timestamp
        );

        uint bal = IERC20(awardToken).balanceOf(tokenReceiver);
        if( bal > 0 ){
          IERC20(awardToken).transferFrom(tokenReceiver,MKAddress,bal);
        }
    }

    function swapAndAward(uint256 tokenAmount) private  {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = awardToken;

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            tokenReceiver,
            block.timestamp
        );

        uint bal = IERC20(awardToken).balanceOf(tokenReceiver);
        if( bal > 0 ){
          IERC20(awardToken).transferFrom(tokenReceiver,address(this),bal);
        }
    }

    function _tokenTransfer(address sender, address recipient, uint256 tAmount,bool isRemoveLP,Param memory param) private {
        if (isRemoveLP) {
            _tOwned[sender] = _tOwned[sender].sub(tAmount);
            _tOwned[deadWallet] = _tOwned[deadWallet].add(param.tTransferAmount);
            emit Transfer(sender, deadWallet, param.tTransferAmount);
        } else {
            _tOwned[sender] = _tOwned[sender].sub(tAmount);
            _tOwned[recipient] = _tOwned[recipient].add(param.tTransferAmount);
            emit Transfer(sender, recipient, param.tTransferAmount);
            if(param.takeFee){
                _takeFee(param,sender);
            }
        }
    }

    function donateDust(address addr, uint256 amount) external onlyOwner {
        TransferHelper.safeTransfer(addr, _msgSender(), amount);
    }

    function donateEthDust(uint256 amount) external onlyOwner {
        TransferHelper.safeTransferETH(_msgSender(), amount);
    }
    
    function process(uint256 gas) private {
      uint256 shareholderCount = shareholders.length;

      if (shareholderCount == 0) return;
      uint256 nowBalance = IERC20(awardToken).balanceOf(address(this));
      uint256 gasUsed = 0;
      uint256 gasLeft = gasleft();
      uint256 iterations = 0;

      while (gasUsed < gas && iterations < shareholderCount) {
        if (currentIndex >= shareholderCount) {
          currentIndex = 0;
        }

        uint256 amount = nowBalance.mul(IERC20(uniswapV2Pair).balanceOf(shareholders[currentIndex])).div(IERC20(uniswapV2Pair).totalSupply());
        if (amount < 1 * 10 ** 3) {
          currentIndex++;
          iterations++;
          continue;
        }
        IERC20(awardToken).transfer(shareholders[currentIndex], amount);
        gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
        gasLeft = gasleft();
        currentIndex++;
        iterations++;
      }
    }

    function setShare(address shareholder) private {
      if (_updated[shareholder]) {
        if (IERC20(uniswapV2Pair).balanceOf(shareholder) == 0) quitShare(shareholder);
        return;
      }
      if (IERC20(uniswapV2Pair).balanceOf(shareholder) == 0) return;
      addShareholder(shareholder);
      _updated[shareholder] = true;
    }

    function addShareholder(address shareholder) internal {
      shareholderIndexes[shareholder] = shareholders.length;
      shareholders.push(shareholder);
    }

    function quitShare(address shareholder) private {
      removeShareholder(shareholder);
      _updated[shareholder] = false;
    }

    function removeShareholder(address shareholder) internal {
      shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1];
      shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder];
      shareholders.pop();
    }

    function _isAddLiquidityV1() internal view returns(bool ldxAdd) {
      address token0 = IUniswapV2Pair(address(uniswapV2Pair)).token0();
      address token1 = IUniswapV2Pair(address(uniswapV2Pair)).token1();
      (uint r0,uint r1,) = IUniswapV2Pair(address(uniswapV2Pair)).getReserves();
      uint bal1 = IERC20(token1).balanceOf(address(uniswapV2Pair));
      uint bal0 = IERC20(token0).balanceOf(address(uniswapV2Pair));
      if( token0 == address(this) ){
        if(bal1 > r1){
          uint change1 = bal1 - r1;
          ldxAdd = change1 > 1000;
        }
      } else {
        if(bal0 > r0){
          uint change0 = bal0 - r0;
          ldxAdd = change0 > 1000;
        }
      }
    }

    function _isRemoveLiquidity() internal view returns (bool isRemove){
        IUniswapV2Pair mainPair = IUniswapV2Pair(address(uniswapV2Pair));
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = awardToken;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }
        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isRemove = r >= bal;
    }
}