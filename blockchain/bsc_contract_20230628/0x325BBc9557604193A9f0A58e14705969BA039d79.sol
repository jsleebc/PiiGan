//https://twitter.com/WSB_BABYBSC
//https://t.me/WSBBSC

// SPDX-License-Identifier: UNLICENSED



pragma solidity 0.8.18;

interface IBEP20 {
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



abstract contract Context {
    
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        authorizations[_owner] = true;
        emit OwnershipTransferred(address(0), msgSender);
    }
    mapping (address => bool) internal authorizations;

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

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
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

interface InterfaceLP {
    function sync() external;
}

contract WallStreetBaby is Ownable, IBEP20 {
    using SafeMath for uint256;

    address WBNB;
    address constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address constant ZERO = 0x0000000000000000000000000000000000000000;

    string constant _name = "Wall Street Baby";
    string constant _symbol = "WSB";
    uint8 constant _decimals = 18;

    uint256 _totalSupply = 1 * 10**14 * 10**_decimals;

    uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
    uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);

    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;

    bool public blacklistMode = true;
    mapping (address => bool) public isblacklisted;

    bool public launchMode = false;
    mapping (address => bool) islaunched;

    mapping (address => bool) isFeeExempt;
    mapping (address => bool) isTxLimitExempt;

    uint256 private liquidityFee   = 1;
    uint256 private marketingFee   = 4;
    uint256 private devFee         = 2;
    uint256 private buybackFee     = 0;
    uint256 public burnFee         = 0;
    uint256 public totalFee        = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
    uint256 public feeDenominator  = 100;

    uint256 sellMultiplier = 400;
    uint256 buyMultiplier = 150;
    uint256 transferMultiplier = 1000;

    address private autoLiquidityReceiver;
    address private marketingFeeReceiver;
    address private devFeeReceiver;
    address private buybackFeeReceiver;
    address public burnFeeReceiver;

  
    IDEXRouter public router;
    address public pair;
   
    bool public tradingOpen = false;
    uint256 launchBlock;
       
      
    bool public swapEnabled = true;
    uint256 public swapThreshold = _totalSupply * 15 / 1000;
    bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }

    constructor () {
        router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);        
        WBNB = router.WETH();
        pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
        

        _allowances[address(this)][address(router)] = type(uint256).max;

        isFeeExempt[msg.sender] = true;
        isFeeExempt[marketingFeeReceiver] = true;
        isFeeExempt[devFeeReceiver] = true;
        islaunched[msg.sender] = true;
        isTxLimitExempt[msg.sender] = true;
        isTxLimitExempt[pair] = true;
        isTxLimitExempt[marketingFeeReceiver] = true;
        isTxLimitExempt[devFeeReceiver] = true;

        autoLiquidityReceiver = msg.sender;
        marketingFeeReceiver = 0x3628C006b6D607B1d39554865c0AF05a987A567e;
        devFeeReceiver = msg.sender;
        buybackFeeReceiver = msg.sender;
        burnFeeReceiver = DEAD; 

        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable { }
   
    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) {return owner();}
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][msg.sender] != type(uint256).max){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

       function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
         require(maxWallPercent >= 1); 
        _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
        emit set_MaxWallet(_maxWalletToken);
                
    }

    function setMaxTransaction(uint256 maxTXPercent) external onlyOwner {
         require(maxTXPercent >= 1); 
        _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
        emit set_MaxTX(_maxTxAmount);
    }
  
  
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if(inSwap){ return _basicTransfer(sender, recipient, amount); }

        if(!authorizations[sender] && !authorizations[recipient]){
            require(tradingOpen,"Trading not open yet");

        if(launchMode){
                require(islaunched[recipient],"Not Whitelisted");    
            }
        }
        
        if(blacklistMode){
            require(!isblacklisted[sender],"blacklist");    
        }
        
             
        if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != devFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
            uint256 heldTokens = balanceOf(recipient);
            require((heldTokens + amount) <= _maxWalletToken,"Total Wallet is currently limited, you can not buy that much.");}

      

        checkTxLimit(sender, amount);

        if(shouldSwapBack()){ swapBack(); }
       
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
        _balances[recipient] = _balances[recipient].add(amountReceived);

        emit Transfer(sender, recipient, amountReceived);
        return true;
    
    }


    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function checkTxLimit(address sender, uint256 amount) internal view {
        require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
    }

    function shouldTakeFee(address sender) internal view returns (bool) {
        return !isFeeExempt[sender];
    }

     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {

        uint256 multiplier = transferMultiplier;

        if(recipient == pair) {
            multiplier = sellMultiplier;
        } else if(sender == pair) {
            multiplier = buyMultiplier;
        }

        uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);

        uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
        uint256 contractTokens = feeAmount.sub(burnTokens);

        _balances[address(this)] = _balances[address(this)].add(contractTokens);
        _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
        emit Transfer(sender, address(this), contractTokens);
        
        if(burnTokens > 0){
            emit Transfer(sender, burnFeeReceiver, burnTokens);    
        }

        return amount.sub(feeAmount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    
    }

    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
        require(tokenAddress != address(this), "tokenAddress can not be the native token");

        if(tokens == 0){
            tokens = IBEP20(tokenAddress).balanceOf(address(this));
        }

        emit ClearToken(tokenAddress, tokens);

        return IBEP20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
    }


    function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
        require(amountPercentage < 101, "Cannot Clear Over 100%");
        uint256 amountBNB = address(this).balance;
        uint256 amounttoSend = ( amountBNB * amountPercentage ) / 100;
        payable(msg.sender).transfer(amounttoSend);
        emit ClearStuck(amounttoSend);
        
    }
    
    function updateFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
       
        sellMultiplier = _sell;
        buyMultiplier = _buy;
        transferMultiplier = _trans;   

        require(totalFee.mul(buyMultiplier).div(100) < 35, "Tax cannot be more than 35%");
        require(totalFee.mul(sellMultiplier).div(100) < 35, "Tax cannot be more than 35%"); 
        require(totalFee.mul(transferMultiplier).div(100) < 35, "Tax cannot be more than 35%"); 

        set_fees();

    }

    function setTrading() public onlyOwner {
        tradingOpen = true;
        
    }

    function manualSend() external { 
            payable(autoLiquidityReceiver).transfer(address(this).balance);
        
    }

    function swapBack() internal swapping {

        uint256 totalBNBFee = totalFee;

        uint256 amountToLiquify = (swapThreshold * liquidityFee)/(totalBNBFee * 2);
        uint256 amountToSwap = swapThreshold - amountToLiquify;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

         uint256 amountBNB = address(this).balance;

         totalBNBFee = totalBNBFee - (liquidityFee / 2);
        
        uint256 amountBNBLiquidity = (amountBNB * liquidityFee) / (totalBNBFee * 2);
        uint256 amountBNBMarketing = amountBNB.mul(marketingFee).div(totalBNBFee);
        uint256 amountBNBbuyback = amountBNB.mul(buybackFee).div(totalBNBFee);
        uint256 amountBNBdev = amountBNB.mul(devFee).div(totalBNBFee);

        (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountBNBMarketing}("");
        (tmpSuccess,) = payable(devFeeReceiver).call{value: amountBNBdev}("");
        (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountBNBbuyback}("");
        
        
        tmpSuccess = false;

        if(amountToLiquify > 0){
            router.addLiquidityETH{value: amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                autoLiquidityReceiver,
                block.timestamp
            );
            emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
        }
    }

    function blacklistStatus(bool _status) public onlyOwner {
        blacklistMode = _status;
    }

    
    function set_launch(bool _status) external onlyOwner {
        launchMode = _status;

    }

    function addtoblacklist(address[] calldata addresses, bool status) public onlyOwner {
        for (uint256 i; i < addresses.length; ++i) {
            isblacklisted[addresses[i]] = status;
        }
    }

    function addtolaunch(address[] calldata addresses, bool status) public onlyOwner {
        for (uint256 i; i < addresses.length; ++i) {
            islaunched[addresses[i]] = status;
        }
    }

   function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
        isFeeExempt[holder] = exempt;
         emit user_FeeExempt(holder, exempt);
    }

    function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
        isTxLimitExempt[holder] = exempt;
         emit user_TxExempt(holder, exempt);
    }

    
      function setInternalAddress(address holder, bool exempt) external onlyOwner {
        require(holder != address(0) && holder !=address(DEAD), "Can not be zero address.");
        
        isFeeExempt[holder] = exempt;
        isTxLimitExempt[holder] = exempt;

        emit user_FeeExempt(holder, exempt);
        emit user_TxExempt(holder, exempt);
               
    }

     function set_fees() internal {
      
        emit EditTax( uint8(totalFee.mul(buyMultiplier).div(100)),
            uint8(totalFee.mul(sellMultiplier).div(100)),
            uint8(totalFee.mul(transferMultiplier).div(100))
            );
    }

    function setFeeSpread(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
        liquidityFee = _liquidityFee;
        buybackFee = _buybackFee;
        marketingFee = _marketingFee;
        devFee = _devFee;
        burnFee = _burnFee;
        totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
        feeDenominator = _feeDenominator;
        require(totalFee < feeDenominator/5, "Buy Fees cannot be more than 20%");
        set_fees();
    }

    function setReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
        autoLiquidityReceiver = _autoLiquidityReceiver;
        marketingFeeReceiver = _marketingFeeReceiver;
        devFeeReceiver = _devFeeReceiver;
        burnFeeReceiver = _burnFeeReceiver;
        buybackFeeReceiver = _buybackFeeReceiver;
        emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
    }


    function swapAndLiquifySettings(bool _enabled, uint256 _amount) external onlyOwner {
        swapEnabled = _enabled;
        swapThreshold = _amount;
        emit set_SwapBack(swapThreshold, swapEnabled);
    }

    
    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }


    
event AutoLiquify(uint256 amountBNB, uint256 amountTokens);
event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
event user_FeeExempt(address Wallet, bool Exempt);
event user_TxExempt(address Wallet, bool Exempt);
event ClearStuck(uint256 amount);
event ClearToken(address TokenAddressCleared, uint256 Amount);
event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address stakingFeeReceiver,address devFeeReceiver);
event set_MaxWallet(uint256 maxWallet);
event set_MaxTX(uint256 maxTX);
event set_SwapBack(uint256 Amount, bool Enabled);
}