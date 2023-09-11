/**

RexBit Chain (RBC)

https://rexbit.io
https://link.medium.com/vMrzP1Vy3yb
https://t.me/RexBitChain

Introducing RexBit Chain (RBC), the innovative Ethereum layer 2 blockchain poised to transform 
the cryptocurrency landscape. By utilizing the stability, reliability, and scalability of the 
Ethereum blockchain, RexBit aims to create a unique environment that rewards user activity rather 
than solely catering to large holders with minimal activity.

RexBit Chain (RBC) is the core of RexBit, launching on the Ethereum blockchain allowing for full 
integration into our Layer 2 solution. Coded directly into the RBC token is a newly developed 
blockchain ledger, continuously logging all user activity across both Layer 1 and Layer 2. With 
full integration possible through custom interface access, user activity now becomes a pilar and 
main emphasis versus holding alone. This fully unique ability allows for utilities such as RexBit 
Dividends and RexBit DAO.

*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;


library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
    function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked{require(b <= a, errorMessage); return a - b;}}

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked{require(b > 0, errorMessage); return a / b;}}

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked{require(b > 0, errorMessage); return a % b;}}}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function circulatingSupply() external view returns (uint256);
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
    event Approval(address indexed owner, address indexed spender, uint256 value);}

abstract contract Ownable {
    address internal owner;
    constructor(address _owner) {owner = _owner;}
    modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
    function isOwner(address account) public view returns (bool) {return account == owner;}
    function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
    event OwnershipTransferred(address owner);
}

interface stakeIntegration {
    function stakingWithdraw(address depositor, uint256 _amount) external;
    function stakingDeposit(address depositor, uint256 _amount) external;
    function stakingClaimToCompound(address sender, address recipient) external;
}

interface tokenStaking {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function compound() external;
}

interface blockChain {
    function blockchainActivityStats(address user) external view returns (uint256 lastPurchase, uint256 purchaseTimestamp, uint256 lastSold, uint256 soldTimestamp, 
        uint256 lastTransferIn, uint256 transferInTimestamp, uint256 lastTransferOut, uint256 transferOutTimestamp, uint256 totalPurchased, uint256 totalSold, 
        uint256 totalTransferredIn, uint256 totalTransferredOut);
    function blockchainTaxStats(address user) external view returns (uint256 lastBuyTax, uint256 buyTaxTimestamp, uint256 lastSellTax, uint256 sellTaxTimestamp, 
        uint256 totalBuyTaxes, uint256 totalSellTaxes, uint256 totalTaxes);
}

interface IFactory{
        function createPair(address tokenA, address tokenB) external returns (address pair);
        function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IRouter {
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
        uint deadline) external;

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract RexBit is blockChain, tokenStaking, IERC20, Ownable {
    using SafeMath for uint256;
    string private constant _name = 'RexBit';
    string private constant _symbol = 'RBIT';
    uint8 private constant _decimals = 9;
    uint256 private _totalSupply = 10000000 * (10 ** _decimals);
    uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
    uint256 public _maxSellAmount = ( _totalSupply * 200 ) / 10000;
    uint256 public _maxWalletToken = ( _totalSupply * 200 ) / 10000;
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) public isFeeExempt;
    IRouter router;
    address public pair;
    bool private tradingAllowed = false;
    uint256 private liquidityFee = 200;
    uint256 private marketingFee = 200;
    uint256 private developmentFee = 200;
    uint256 private NFTFee = 0;
    uint256 private tokenStakingFee = 0;
    uint256 private lpStakingFee = 0;
    uint256 private totalFee = 600;
    uint256 private sellFee = 600;
    uint256 private transferFee = 0;
    uint256 private denominator = 10000;
    bool private swapEnabled = true;
    uint256 private swapTimes;
    uint256 private swapAmount = 1;
    bool private swapping;
    bool private feeless;
    uint256 private swapThreshold = ( _totalSupply * 300 ) / 100000;
    uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
    modifier feelessTransaction {feeless = true; _; feeless = false;}
    modifier lockTheSwap {swapping = true; _; swapping = false;}
    mapping(address => uint256) public amountStaked;
    uint256 public totalStaked;
    stakeIntegration internal stakingContract;
    address internal token_staking;
    address internal lp_staking;
    address internal NFT_receiver;
    address internal development_receiver; 
    address internal marketing_receiver;
    address internal liquidity_receiver;
    address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;

    struct blockchainActivity {
        uint256 lastPurchase;
        uint256 purchaseTimestamp;
        uint256 lastSold;
        uint256 soldTimestamp;
        uint256 lastTransferIn;
        uint256 transferInTimestamp;
        uint256 lastTransferOut;
        uint256 transferOutTimestamp;
        uint256 totalPurchased; 
        uint256 totalSold;
        uint256 totalTransferredIn;
        uint256 totalTransferredOut;}
    mapping (address => blockchainActivity) private _blockchainActivityStats;
    uint256 public totalTokensTraded;

    struct blockchainTaxes {
        uint256 lastBuyTax;
        uint256 buyTaxTimestamp;
        uint256 lastSellTax;
        uint256 sellTaxTimestamp;
        uint256 totalBuyTaxes;
        uint256 totalSellTaxes;
        uint256 totalTaxes;}
    mapping (address => blockchainTaxes) private _blockchainTaxStats;

    event Deposit(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
    event Withdraw(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
    event Compound(address indexed account, uint256 ethAmount, uint256 indexed timestamp);
    event SetStakingAddress(address indexed stakingAddress, uint256 indexed timestamp);
    event SetisBot(address indexed account, bool indexed isBot, uint256 indexed timestamp);
    event ExcludeFromFees(address indexed account, bool indexed isExcluded, uint256 indexed timestamp);
    event SetDividendExempt(address indexed account, bool indexed isExempt, uint256 indexed timestamp);
    event SetInternalAddresses(address indexed marketing, address indexed liquidity, address indexed treasury, uint256 timestamp);
    event SetDistributionCriteria(uint256 indexed minPeriod, uint256 indexed minDistribution, uint256 indexed distributorGas, uint256 timestamp);
    event SetParameters(uint256 indexed maxTxAmount, uint256 indexed maxWalletToken, uint256 indexed maxTransfer, uint256 timestamp);
    event SetSwapBackSettings(uint256 indexed swapAmount, uint256 indexed swapThreshold, uint256 indexed swapMinAmount, uint256 timestamp);
    event SetStructure(uint256 indexed total, uint256 indexed sell, uint256 transfer, uint256 indexed timestamp);
    event SetStaking(address indexed tokenStaking, address indexed lpStaking, uint256 tokenFee, uint256 lpFee, uint256 timestamp);
    event CreateLiquidity(uint256 indexed tokenAmount, uint256 indexed ETHAmount, address indexed wallet, uint256 timestamp);

    constructor() Ownable(msg.sender) {
        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
        router = _router; pair = _pair;
        token_staking = address(this);
        lp_staking = address(this);
        liquidityFee = uint256(0);
        isFeeExempt[address(this)] = true;
        isFeeExempt[liquidity_receiver] = true;
        isFeeExempt[marketing_receiver] = true;
        isFeeExempt[development_receiver] = true;
        isFeeExempt[msg.sender] = true;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}
    function name() public pure returns (string memory) {return _name;}
    function symbol() public pure returns (string memory) {return _symbol;}
    function decimals() public pure returns (uint8) {return _decimals;}
    function startTrading() external onlyOwner {tradingAllowed = true;}
    function getOwner() external view override returns (address) { return owner; }
    function totalSupply() public view override returns (uint256) {return _totalSupply;}
    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
    function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
    function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
    function isContract(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
    function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
    function availableBalance(address wallet) public view returns (uint256) {return _balances[wallet].sub(amountStaked[wallet]);}
    function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}

    function preTxCheck(address sender, address recipient, uint256 amount) internal view {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        preTxCheck(sender, recipient, amount);
        checkTradingAllowed(sender, recipient);
        checkMaxWallet(sender, recipient, amount); 
        checkTxLimit(sender, recipient, amount);
        setBlockchainLedger(sender, recipient, amount);
        setBlockchainTaxes(sender, recipient, amount);
        swapbackCounters(sender, recipient, amount);
        swapBack(sender, recipient, amount);
        _balances[sender] = _balances[sender].sub(amount);
        uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
    }

    function setBlockchainLedger(address sender, address recipient, uint256 amount) internal {
        if(sender == pair){_blockchainActivityStats[recipient].totalPurchased = _blockchainActivityStats[recipient].totalPurchased.add(amount);
            _blockchainActivityStats[recipient].lastPurchase = amount; _blockchainActivityStats[recipient].purchaseTimestamp = block.timestamp;}
        if(recipient == pair){_blockchainActivityStats[sender].totalSold = _blockchainActivityStats[sender].totalSold.add(amount);
            _blockchainActivityStats[sender].lastSold = amount; _blockchainActivityStats[sender].soldTimestamp = block.timestamp;}
        if(sender != pair && recipient != pair){
            _blockchainActivityStats[sender].totalTransferredOut = _blockchainActivityStats[sender].totalTransferredOut.add(amount);
            _blockchainActivityStats[sender].lastTransferOut = amount; _blockchainActivityStats[sender].transferOutTimestamp = block.timestamp;
            _blockchainActivityStats[recipient].totalTransferredIn = _blockchainActivityStats[recipient].totalTransferredIn.add(amount);
            _blockchainActivityStats[recipient].lastTransferIn = amount; _blockchainActivityStats[recipient].transferInTimestamp = block.timestamp;}
    }

    function setBlockchainTaxes(address sender, address recipient, uint256 amount) internal {
        uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
        if(sender == pair){_blockchainTaxStats[recipient].lastBuyTax = feeAmount; _blockchainTaxStats[recipient].buyTaxTimestamp = block.timestamp;
            _blockchainTaxStats[recipient].totalBuyTaxes = _blockchainTaxStats[recipient].totalBuyTaxes.add(feeAmount);
            _blockchainTaxStats[recipient].totalTaxes = _blockchainTaxStats[recipient].totalTaxes.add(feeAmount);
            totalTokensTraded = totalTokensTraded.add(amount);}
        if(recipient == pair){_blockchainTaxStats[sender].lastSellTax = feeAmount; _blockchainTaxStats[sender].sellTaxTimestamp = block.timestamp;
            _blockchainTaxStats[sender].totalSellTaxes = _blockchainTaxStats[sender].totalSellTaxes.add(feeAmount);
            _blockchainTaxStats[sender].totalTaxes = _blockchainTaxStats[sender].totalTaxes.add(feeAmount);
            totalTokensTraded = totalTokensTraded.add(amount);}
    }


    function blockchainActivityStats(address user) external override view returns (uint256 lastPurchase, uint256 purchaseTimestamp, uint256 lastSold, uint256 soldTimestamp, 
        uint256 lastTransferIn, uint256 transferInTimestamp, uint256 lastTransferOut, uint256 transferOutTimestamp, uint256 totalPurchased, uint256 totalSold, uint256 totalTransferredIn, 
        uint256 totalTransferredOut) { address _address = user;
        return(_blockchainActivityStats[_address].lastPurchase, _blockchainActivityStats[_address].purchaseTimestamp, _blockchainActivityStats[_address].lastSold, _blockchainActivityStats[_address].soldTimestamp,
            _blockchainActivityStats[_address].lastTransferIn, _blockchainActivityStats[_address].transferInTimestamp, _blockchainActivityStats[_address].lastTransferOut, _blockchainActivityStats[_address].transferOutTimestamp,
            _blockchainActivityStats[_address].totalPurchased, _blockchainActivityStats[_address].totalSold, _blockchainActivityStats[_address].totalTransferredIn, _blockchainActivityStats[_address].totalTransferredOut);
    }

    function blockchainTaxStats(address user) external override view returns (uint256 lastBuyTax, uint256 buyTaxTimestamp, uint256 lastSellTax, uint256 sellTaxTimestamp, 
        uint256 totalBuyTaxes, uint256 totalSellTaxes, uint256 totalTaxes) { address _address = user;
        return(_blockchainTaxStats[_address].lastBuyTax, _blockchainTaxStats[_address].buyTaxTimestamp, _blockchainTaxStats[_address].lastSellTax, _blockchainTaxStats[_address].sellTaxTimestamp,
            _blockchainTaxStats[_address].totalBuyTaxes, _blockchainTaxStats[_address].totalSellTaxes, _blockchainTaxStats[_address].totalTaxes);
    }

    function internalDeposit(address sender, uint256 amount) internal {
        require(amount <= _balances[sender].sub(amountStaked[sender]), "ERC20: Cannot stake more than available balance");
        stakingContract.stakingDeposit(sender, amount);
        amountStaked[sender] = amountStaked[sender].add(amount);
        totalStaked = totalStaked.add(amount);
        emit Deposit(sender, amount, block.timestamp);
    }

    function deposit(uint256 amount) override external {
        internalDeposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) override external {
        require(amount <= amountStaked[msg.sender], "ERC20: Cannot unstake more than amount staked");
        stakingContract.stakingWithdraw(msg.sender, amount);
        amountStaked[msg.sender] = amountStaked[msg.sender].sub(amount);
        totalStaked = totalStaked.sub(amount);
        emit Withdraw(msg.sender, amount, block.timestamp);
    }

    function compound() override external feelessTransaction {
        uint256 initialToken = balanceOf(msg.sender);
        stakingContract.stakingClaimToCompound(msg.sender, msg.sender);
        uint256 afterToken = balanceOf(msg.sender).sub(initialToken);
        internalDeposit(msg.sender, afterToken);
        emit Compound(msg.sender, afterToken, block.timestamp);
    }

    function setStakingAddress(address _staking) external onlyOwner {
        stakingContract = stakeIntegration(_staking); isFeeExempt[_staking] = true;
        emit SetStakingAddress(_staking, block.timestamp);
    }

    function setStructure(uint256 _liquidity, uint256 _development, uint256 _marketing, uint256 _nft, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
        liquidityFee = _liquidity; marketingFee = _marketing; developmentFee = _development; NFTFee = _nft; totalFee = _total; sellFee = _sell; transferFee = _trans;
        require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5) && transferFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
        emit SetStructure(_total, _sell, _trans, block.timestamp);
    }

    function setStaking(address _tokenStaking, address _lpStaking, uint256 _token, uint256 _lp) external onlyOwner {
        tokenStakingFee = _token; lpStakingFee = _lp; token_staking = _tokenStaking; lp_staking = _lpStaking; isFeeExempt[_tokenStaking] = true; isFeeExempt[_lpStaking] = true;
        require(tokenStakingFee <= denominator.div(5) && lpStakingFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
        emit SetStaking(_tokenStaking, _lpStaking, _token, _lp, block.timestamp);
    }

    function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
        uint256 newTx = totalSupply().mul(_buy).div(10000); uint256 newTransfer = totalSupply().mul(_trans).div(10000);
        uint256 newWallet = totalSupply().mul(_wallet).div(10000); uint256 limit = totalSupply().mul(5).div(1000);
        require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "ERC20: max TXs and max Wallet cannot be less than .5%");
        _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
        emit SetParameters(newTx, newWallet, newTransfer, block.timestamp);
    }

    function checkTradingAllowed(address sender, address recipient) internal view {
        if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
    }
    
    function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
        if(!isFeeExempt[sender] && !isFeeExempt[recipient] && !feeless && recipient != address(pair) && recipient != address(DEAD)){
            require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
    }

    function swapbackCounters(address sender, address recipient, uint256 amount) internal {
        if(recipient == pair && !isFeeExempt[sender] && !feeless && amount >= minTokenAmount){swapTimes += uint256(1);}
    }

    function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
        if(amountStaked[sender] > uint256(0)){require((amount.add(amountStaked[sender])) <= _balances[sender], "ERC20: Exceeds maximum allowed not currently staked.");}
        if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
        require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
    }

    function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
        swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(100000); minTokenAmount = _totalSupply.mul(_minTokenAmount).div(100000);
        emit SetSwapBackSettings(_swapAmount, _swapThreshold, _minTokenAmount, block.timestamp);  
    }

    function setInternalAddresses(address _marketing, address _liquidity, address _development, address _nft) external onlyOwner {
        marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development; NFT_receiver = _nft;
        isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true; isFeeExempt[_nft] = true;
        emit SetInternalAddresses(_marketing, _liquidity, _development, block.timestamp);
    }

    function setisExempt(address _address, bool _enabled) external onlyOwner {
        isFeeExempt[_address] = _enabled;
        emit ExcludeFromFees(_address, _enabled, block.timestamp);
    }

    function swapAndLiquify() external onlyOwner {
        uint256 amount = balanceOf(address(this)); if(amount >= swapThreshold){amount = swapThreshold;} _swapAndLiquify(amount);
    }

    function _swapAndLiquify(uint256 tokens) private lockTheSwap {
        uint256 _denominator = (liquidityFee.add(developmentFee).add(marketingFee).add(NFTFee)).mul(2);
        uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
        uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
        uint256 initialBalance = address(this).balance;
        swapTokensForETH(toSwap);
        uint256 deltaBalance = address(this).balance.sub(initialBalance);
        uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
        uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
        if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith, liquidity_receiver); }
        uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
        if(marketingAmount > 0){payable(marketing_receiver).transfer(marketingAmount);}
        uint256 NFTAmount = unitBalance.mul(2).mul(NFTFee);
        if(NFTAmount > 0){payable(NFT_receiver).transfer(NFTAmount);}
        uint256 amount = address(this).balance;
        if(amount > uint256(0)){payable(development_receiver).transfer(amount);}
    }

    function addLiquidity(uint256 tokenAmount, uint256 ETHAmount, address receiver) private {
        _approve(address(this), address(router), tokenAmount);
        router.addLiquidityETH{value: ETHAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            address(receiver),
            block.timestamp);
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        _approve(address(this), address(router), tokenAmount);
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp);
    }

    function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
        bool aboveMin = amount >= minTokenAmount;
        bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
        return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] 
            && recipient == pair && swapTimes >= swapAmount && aboveThreshold && !feeless;
    }

    function swapBack(address sender, address recipient, uint256 amount) internal {
        if(shouldSwapBack(sender, recipient, amount)){_swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
    }

    function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
        return !isFeeExempt[sender] && !isFeeExempt[recipient];
    }

    function getTotalFee(address sender, address recipient) internal view returns (uint256) {
        if(recipient == pair && sellFee > uint256(0)){return sellFee.add(tokenStakingFee).add(lpStakingFee);}
        if(sender == pair && totalFee > uint256(0)){return totalFee.add(tokenStakingFee).add(lpStakingFee);}
        return transferFee;
    }

    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        if(getTotalFee(sender, recipient) > 0 && !feeless){
        uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
        if(tokenStakingFee > uint256(0)){_transfer(address(this), address(token_staking), amount.div(denominator).mul(tokenStakingFee));}
        if(lpStakingFee > uint256(0)){_transfer(address(this), address(lp_staking), amount.div(denominator).mul(lpStakingFee));}
        return amount.sub(feeAmount);} return amount;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function transferERC20(address _address, uint256 _amount) external onlyOwner {
        IERC20(_address).transfer(development_receiver, _amount);
    }

    function transferBalance(uint256 _amount) external onlyOwner {
        payable(development_receiver).transfer(_amount);
    }

    function createLiquidity(uint256 tokenAmount) payable public feelessTransaction {
        _approve(msg.sender, address(this), tokenAmount);
        _approve(msg.sender, address(router), tokenAmount);
        _transfer(msg.sender, address(this), tokenAmount);
        _approve(address(this), address(router), tokenAmount);
        addLiquidity(tokenAmount, msg.value, msg.sender);
        emit CreateLiquidity(tokenAmount, msg.value, msg.sender, block.timestamp);
    }
}