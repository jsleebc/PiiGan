// SPDX-License-Identifier: MIT

 pragma solidity ^0.8.17;

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ISwapRouter {
    function factory() external pure returns (address);

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

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface ISwapPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function token0() external view returns (address);

    function sync() external;
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TokenDistributor {
    address public _owner;
    constructor (address token) {
        _owner = msg.sender;
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }

    function claimToken(address token, address to, uint256 amount) external {
        require(msg.sender == _owner, "not owner");
        IERC20(token).transfer(to, amount);
    }
}

abstract contract AbsToken is IERC20, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    address public marketAddress = address(0xCD9354CE6EBBF5b822005873dE9Fe4331AbC4e27);
    address public consensusAddress = address(0xDda772a1B3941904E309673eDFdB048B0eB00153);
    address public nodeAddress = address(0x733699803AD491BBFc2149a2C4C6Eff9d5f773c0);
    address public techAddress = address(0x4aDCb86d733aB500Efb15a6d6de0B7678F4D8943);
    address public inviterAddress = address(0x4A1ae936309DEb2258aD72B3374E6a2A5c58e92B);
    

    mapping(address => bool) public _feeWhiteList;

    uint256 private _tTotal;

    ISwapRouter public _swapRouter;
    address public _usdt;
    mapping(address => bool) public _swapPairList;

    bool private inSwap;

    uint256 public constant MAX = ~uint256(0);

    uint256 public _lpDividendFee = 0;
    uint256 public _sellFeeRate = 1000;
    uint256 public _buyFeeRate = 1000;

    uint256 public startTradeBlock;
    uint256 public startTradeTime;
    uint256 public startAddLPBlock;

    address public uniswapV2PairBNB;
    address public uniswapV2PairUSDT;    

    uint256 public TOTAL_GONS;
    uint256 public _lastRebasedTime=0;
    uint256 public _gonsPerFragment;
    uint256 public usdtPairBalance;
    uint256 public bnbPairBalance;
    uint256 public thisTokenBalance=0;

    uint256 public _usdtBalance = 0;

    address public _mainPair;

    TokenDistributor public _tokenDistributor;

    uint256 public _limitAmount;

    uint256 public constant MAX_UINT256 = type(uint256).max;
    uint256 public constant MAX_SUPPLY = 1000000000000000 * 1e18;
    uint256 private startTime = 1661252400; 
    uint256 private _totalSupply;
    uint256 public rebaseRate = 10366;

    mapping(uint256 => uint256) public dayPrice;
    uint256 public checkCanBuyDelay = 10;
    uint256 public maxPriceRate = 110;
    uint256 public maxPriceSellRate = 99;


    event LogRebase(uint256 indexed epoch, uint256 totalSupply);

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    mapping (address => bool) public _roler;
    mapping (address => address) public inviter;
    mapping (address => address) public preInviter;

    constructor (
        address RouterAddress, address USDTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address ReceiveAddress
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        IERC20(USDTAddress).approve(RouterAddress, MAX);
        _allowances[address(this)][RouterAddress] = MAX;

        _usdt = USDTAddress;
        _swapRouter = swapRouter;
        
        

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), USDTAddress);
        uniswapV2PairUSDT = swapPair;
        _mainPair = swapPair;
        _swapPairList[swapPair] = true;

        uint256 total = Supply * 10 ** Decimals;

         _tTotal = total;
         _totalSupply = _tTotal;


        TOTAL_GONS = MAX_UINT256 / 1e10 - (MAX_UINT256 / 1e10 % _tTotal);
        _balances[ReceiveAddress] = TOTAL_GONS;

        _gonsPerFragment = TOTAL_GONS / _tTotal;   

        emit Transfer(address(0), ReceiveAddress, total);

        fundAddress = FundAddress;

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(0)] = true;
        _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;

        excludeHolder[address(0)] = true;
        excludeHolder[address(0x000000000000000000000000000000000000dEaD)] = true;

        _tokenDistributor = new TokenDistributor(USDTAddress);

        holderRewardCondition = 1 * 10 ** Decimals;

        _feeWhiteList[address(_tokenDistributor)] = true;



    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    

    function balanceOf(address account) public view override returns (uint256) {

        if (account == uniswapV2PairUSDT){
            return usdtPairBalance;
        }else if (account == uniswapV2PairBNB){
            return bnbPairBalance;
        }else if (account == address(this)){
            return thisTokenBalance;
        }else {
            return _balances[account] / _gonsPerFragment;
        }
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {


        uint256 fromBalance;
        if (from == uniswapV2PairUSDT) {
            fromBalance = usdtPairBalance;
        } else if (from == uniswapV2PairBNB) {
            fromBalance = bnbPairBalance;
        } else if (from == address(this)){
            fromBalance = thisTokenBalance;
        }else {
            fromBalance = _balances[from] / _gonsPerFragment;
        }

        _rebase(from);


        uint256 balance = fromBalance;
        require(balance >= amount, "balance Not Enough");

         uint256 day = today();
         if (0 == dayPrice[day]) {
            dayPrice[day] = tokenPrice();
         }


        if (_swapPairList[from]) {
            _checkCanBuy(to);
        }

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
        }

        bool takeFee;

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            takeFee = true;
        }

        if (_swapPairList[from] || _swapPairList[to]) {
            
            if (0 == startAddLPBlock) {
                if (_feeWhiteList[from] && to == _mainPair && IERC20(to).totalSupply() == 0) {
                    startAddLPBlock = block.number;
                }
            }

            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                takeFee = true;

                bool isAdd;
                if (_swapPairList[to]) {
                    isAdd = _isAddLiquidity();
                    if (isAdd) {
                        takeFee = false;
                    }
                }

                if(0 == startTradeBlock)
                {
                    require(isAdd,"Add Liquidity Only");
                }


                if (block.number < startTradeBlock + 4) {
                    _funTransfer(from, to, amount);
                    return;
                }
            }
        }        

        

        bool shouldInvite = (inviter[to] == address(0) 
            && !isContract(from) && !isContract(to));

        _tokenTransfer(from, to, amount, takeFee);

        if (shouldInvite) {
            preInviter[to] = from;
        }

        if(inviter[from]==address(0) && preInviter[from]==to)
        {
            inviter[from] = to;
        }

        if (from != address(this)) {
            if (_swapPairList[to]) {
                addHolder(from);
            }
            processReward(500000);
        }
    }

    

    function _rebase(address from) internal {


        if(_totalSupply<=getContractNum(1000000000000))
        {
            rebaseRate = 10366;
        }else if(_totalSupply<=getContractNum(10000000000000))
        {
            rebaseRate = 8293;
        }else if(_totalSupply<=getContractNum(100000000000000))
        {
            rebaseRate = 6219;
        }else if(_totalSupply<=getContractNum(1000000000000000))
        {
            rebaseRate = 4146;
        }
        
        
        if (
            _totalSupply < MAX_SUPPLY &&
            from != uniswapV2PairUSDT  &&
            from != uniswapV2PairBNB  &&
            _lastRebasedTime > 0 &&
            block.timestamp >= (_lastRebasedTime + 15 minutes) &&
            block.timestamp < (startTime + 3650 days)
        ) {
            uint256 deltaTime = block.timestamp - _lastRebasedTime;
            uint256 times = deltaTime / (15 minutes);
            uint256 epoch = times * 15;

            for (uint256 i = 0; i < times; i++) {
                _totalSupply = _totalSupply
                * (10 ** 8 + rebaseRate)
                / (10 ** 8);
            }

            _gonsPerFragment = TOTAL_GONS / _totalSupply;
            _lastRebasedTime = _lastRebasedTime + times * 15 minutes;

            emit LogRebase(epoch, _totalSupply);
        }
    }
    

    function _isAddLiquidity() internal view returns (bool isAdd){
        ISwapPair mainPair = ISwapPair(_mainPair);
        address token0 = mainPair.token0();
        if (token0 == address(this)) {
            return false;
        }
        (uint r0,,) = mainPair.getReserves();
        uint bal0 = IERC20(token0).balanceOf(address(mainPair));
        isAdd = bal0 > r0;
    }

    function _isRemoveLiquidity() internal view returns (bool isRemove){
        ISwapPair mainPair = ISwapPair(_mainPair);
        address token0 = mainPair.token0();
        if (token0 == address(this)) {
            return false;
        }
        (uint r0,,) = mainPair.getReserves();
        uint bal0 = IERC20(token0).balanceOf(address(mainPair));
        isRemove = r0 > bal0;
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {

        uint256 gonAmount = tAmount * _gonsPerFragment;

        if (sender == uniswapV2PairUSDT){
            usdtPairBalance = usdtPairBalance - tAmount;
        } else if (sender == uniswapV2PairBNB){
            bnbPairBalance = bnbPairBalance - tAmount;
        } else if (sender == address(this)){
            thisTokenBalance = thisTokenBalance - tAmount;
        }else {
            _balances[sender] = _balances[sender] - gonAmount;
        }

        uint256 feeAmount = tAmount * 99 / 100;
        _takeTransfer(sender, fundAddress, feeAmount);
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {

        uint256 gonAmount = tAmount * _gonsPerFragment;
        if (sender == uniswapV2PairUSDT){
            usdtPairBalance = usdtPairBalance - tAmount;
        } else if (sender == uniswapV2PairBNB){
            bnbPairBalance = bnbPairBalance - tAmount;
        } else if (sender == address(this)){
            thisTokenBalance = thisTokenBalance-tAmount;
        }else {
            _balances[sender] = _balances[sender] - gonAmount;
        }

        

        uint256 feeAmount;

        if (takeFee) {

            if(sender==uniswapV2PairUSDT)
            {

                require(tAmount <= 205000000 * 10 ** _decimals, "Max:200000000");

                uint256 buyFee = tAmount * 3 /100;
                if (buyFee > 0) {
                    feeAmount += buyFee;
                    _takeTransfer(sender, address(this), buyFee);
                }

                uint256 deadAmount = tAmount * 2 /100;
                if (deadAmount > 0) {
                    feeAmount += deadAmount;
                    _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), deadAmount);
                }

                _takeInviterFee(sender, recipient, tAmount);

                uint256 inviterFee = tAmount * 5 /100;
                feeAmount += inviterFee;                


            }else if(recipient==uniswapV2PairUSDT)
            {
                uint256 sellFee = tAmount * _sellFeeRate / 10000;
                if (sellFee > 0) {
                    feeAmount += sellFee;
                    _takeTransfer(sender, address(this), sellFee);
                }

                uint256 contractTokenBalance = balanceOf(address(this));

                uint256 numTokensSellToFund = sellFee * 10;
                if (numTokensSellToFund > contractTokenBalance) {
                    numTokensSellToFund = contractTokenBalance;
                }
              
                if(numTokensSellToFund > 0 )
                {                   

                    swapTokenForFund(numTokensSellToFund);

                    address usdt = _usdt;
                    IERC20 USDT = IERC20(usdt);
                    uint256 usdtNum;
                    uint256 usdtBalance = USDT.balanceOf(address(this));

                    usdtNum = usdtBalance * 2 / 13;
                    USDT.transfer(_mainPair, usdtNum);

                    usdtNum = usdtBalance * 3 / 13;
                    USDT.transfer(marketAddress, usdtNum);

                    usdtNum = usdtBalance * 4 / 13;
                    USDT.transfer(consensusAddress, usdtNum);

                    usdtNum = usdtBalance * 2 / 13;
                    USDT.transfer(nodeAddress, usdtNum);

                    usdtNum = usdtBalance * 2 / 13;
                    USDT.transfer(techAddress, usdtNum);
                }

            }                 
            
        }
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        address usdt = _usdt;
        address tokenDistributor = address(_tokenDistributor);
        IERC20 USDT = IERC20(usdt);
        uint256 usdtBalance = USDT.balanceOf(tokenDistributor);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            tokenDistributor,
            block.timestamp
        );

        usdtBalance = USDT.balanceOf(tokenDistributor) - usdtBalance;
        USDT.transferFrom(tokenDistributor, address(this), usdtBalance);
    }

    function _takeTransfer(address sender, address to, uint256 tAmount) private {

        uint256 gonAmount = tAmount * _gonsPerFragment;

        if (to == uniswapV2PairUSDT){
            usdtPairBalance = usdtPairBalance + tAmount;
        } else if (to == uniswapV2PairBNB){
            bnbPairBalance = bnbPairBalance + tAmount;
        } else if (to == address(this)){
            thisTokenBalance = thisTokenBalance + tAmount;
        }else {
            _balances[to] = _balances[to] + gonAmount;
        }

        emit Transfer(sender, to, tAmount);
    }

    function setFundAddress(address addr) external onlyOwner {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setTradeFee(uint256 sellFeeRate,uint256 buyFeeRate)external onlyOwner {
        _buyFeeRate = buyFeeRate;
        _sellFeeRate = sellFeeRate;

    }

    function startTrade() external onlyOwner {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
        startTradeTime = block.timestamp;
        _lastRebasedTime = startTradeTime;
        startTime = startTradeTime;
    }


    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
    }

    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
    }

    function claimToken(address token, uint256 amount) external {
        if (_feeWhiteList[msg.sender]) {
            IERC20(token).transfer(fundAddress, amount);
        }
    }

    function claimContractToken(address token, uint256 amount) external {
        if (_feeWhiteList[msg.sender]) {
            _tokenDistributor.claimToken(token, fundAddress, amount);
        }
    }

    receive() external payable {}

    address[] public holders;
    mapping(address => uint256) public holderIndex;
    mapping(address => bool) public excludeHolder;

    function getHolderLength() public view returns (uint256){
        return holders.length;
    }

    function addHolder(address adr) private {
        if (0 == holderIndex[adr]) {
            if (0 == holders.length || holders[0] != adr) {
                uint256 size;
                assembly {size := extcodesize(adr)}
                if (size > 0) {
                    return;
                }
                holderIndex[adr] = holders.length;
                holders.push(adr);
            }
        }
    }

    uint256 public currentIndex;
    uint256 public holderRewardCondition;
    uint256 public progressRewardBlock;
    uint256 public _progressBlockDebt = 200;

    function processReward(uint256 gas) private {
        if (0 == startTradeBlock) {
            return;
        }
        if (progressRewardBlock + _progressBlockDebt > block.number) {
            return;
        }

        address sender = address(_tokenDistributor);
        uint256 balance = balanceOf(sender);
        if (balance < holderRewardCondition) {
            return;
        }

        IERC20 holdToken = IERC20(_mainPair);
        uint holdTokenTotal = holdToken.totalSupply();

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            tokenBalance = holdToken.balanceOf(shareHolder);
            if (tokenBalance > 0 && !excludeHolder[shareHolder]) {
                amount = balance * tokenBalance / holdTokenTotal;
                if (amount > 0) {
                    _tokenTransfer(sender, shareHolder, amount, false);
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = block.number;
    }

    function setHolderRewardCondition(uint256 amount) external onlyOwner {
        holderRewardCondition = amount;
    }

    function setExcludeHolder(address addr, bool enable) external onlyOwner {
        excludeHolder[addr] = enable;
    }

    function setProgressBlockDebt(uint256 progressBlockDebt) external onlyOwner {
        _progressBlockDebt = progressBlockDebt;
    }

    function _takeInviterFee(
        address sender, address recipient, uint256 tAmount
    ) private {

        address cur = sender;
        address rAddress = sender;
        if (isContract(sender)) {
            cur = recipient;
        } 
        uint8[2] memory inviteRate = [30, 20];
        for (uint8 i = 0; i < inviteRate.length; i++) {
            uint8 rate = inviteRate[i];
            cur = inviter[cur];
            rAddress = cur;
            if (cur == address(0))
            {
                cur = fundAddress;
                rAddress = inviterAddress;
            }else{                
                if(balanceOf(cur) < 100000000 * 10 ** _decimals)
                {
                    rAddress = inviterAddress;
                }
            }
             
            uint256 curTAmount = tAmount * rate / 1000;
            
            _takeTransfer(sender, rAddress, curTAmount);
        }
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }



    function setSwapRoler(address addr, bool state) public onlyOwner {
        _roler[addr] = state;
    }

    function getContractNum(uint256 num) internal view returns (uint256)
    {
        return num * 10 **_decimals;
    }

    function today() public view returns (uint256){
        return block.timestamp / 86400;
    }

    function tokenPrice() public view returns (uint256){
        ISwapPair swapPair = ISwapPair(_mainPair);
        (uint256 reverse0,uint256 reverse1,) = swapPair.getReserves();
        address token0 = swapPair.token0();
        uint256 usdtReverse;
        uint256 tokenReverse;
        if (_usdt == token0) {
            usdtReverse = reverse0;
            tokenReverse = reverse1;
        } else {
            usdtReverse = reverse1;
            tokenReverse = reverse0;
        }
        if (0 == tokenReverse) {
            return 0;
        }
        return 10 ** _decimals * usdtReverse / tokenReverse;
    }

    function _checkCanBuy(address to) private view {
        if (0 == startTradeBlock || block.number <= startTradeBlock + checkCanBuyDelay) {
            return;
        }
        if (_feeWhiteList[to]) {
            return;
        }
        uint256 todayPrice = dayPrice[today()];
        if (0 == todayPrice) {
            return;
        }
        uint256 price = tokenPrice();
        uint256 priceRate = price * 100 / todayPrice;
        require(priceRate <= maxPriceRate, "maxPriceRate");
    }

}

contract AITIP is AbsToken {
    constructor() AbsToken( 
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
        address(0x55d398326f99059fF775485246999027B3197955),
        "AITIP",
        "AITIP",
        18,
        200000000000,
        address(0xea99F41e27F0a3F478A89F218C06D6B6D4325dD3),
        address(0xea99F41e27F0a3F478A89F218C06D6B6D4325dD3)
    ){

    }
}