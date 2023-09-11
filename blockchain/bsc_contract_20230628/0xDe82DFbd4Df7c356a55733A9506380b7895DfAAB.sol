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

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

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
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);

    function feeTo() external view returns (address);
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
        require(newOwner != address(0), "new 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TokenDistributor {

    constructor (address token) {
    
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }


}

abstract contract AbsToken is IERC20, Ownable {
    mapping(address => uint256) private _userLPAmount;
    address public _lastTxAccount;
    uint256 public _totalLPAmount;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => bool) public _feeWhiteList;
  

    uint256 private _tTotal;

    ISwapRouter public _swapRouter;
    ISwapFactory _swapFactory;
    address public _usdt;
    mapping(address => bool) public _swapPairList;

    bool private inSwap;

    uint256 public constant MAX = ~uint256(0);

    uint256 public _buyLPFee = 100;
    uint256 public _fundFee = 100;
    uint256 public _burnfee=200;
    uint256 public _sellLPDividendFee = 200;

    uint256 public startTradeBlock;
    uint256 public startAddLPBlock;

    address public _mainPair;

    TokenDistributor public _tokenDistributor;

    uint256 public _limitAmount;
    uint256 public _numToSell;
    uint256 public _minTotal;
    uint256 public all_fund;
    uint256 public all_lp;
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress, address USDTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address ReceiveAddress, uint256 MinTotal
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        IERC20(USDTAddress).approve(RouterAddress, MAX);
        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        _allowances[address(this)][RouterAddress] = MAX;

        _usdt = USDTAddress;
        _swapRouter = swapRouter;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), USDTAddress);
        _swapFactory = swapFactory;
        _mainPair = swapPair;
        _swapPairList[swapPair] = true;

        uint256 total = Supply * 10 ** Decimals;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
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

        _minTotal = MinTotal * 10 ** Decimals;
        _numToSell = 1 * 10 ** 15;
        _limitAmount = 5 * 10 ** Decimals;
        addHolder(FundAddress);
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
        return _tTotal;
    }

    function validTotal() public view returns (uint256) {
        return _tTotal - _balances[address(0)] - _balances[address(0x000000000000000000000000000000000000dEaD)];
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
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
        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");

        _calLPAmount();

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
        }

        bool takeFee;

        if (_swapPairList[from] || _swapPairList[to]) {
        
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                takeFee = true;

                bool isAdd;
                if (_swapPairList[to]) {
                    isAdd = _isAddLiquidity();
                    if (isAdd) {
                        takeFee = false;
                    }
                }

             
            }
        }

        _tokenTransfer(from, to, amount, takeFee);
        _checkLimit(to);

        if (from != address(this)) {
            if (_swapPairList[to]) {
                _lastTxAccount = from;
            } else if (_swapPairList[from]) {
                bool isRemove = _isRemoveLiquidity();
                if (isRemove) {
                    IERC20 mainPair = IERC20(_mainPair);
                    uint256 totalPair = mainPair.totalSupply();
                    address feeTo = _swapFactory.feeTo();
                    if (address(0) != feeTo) {
                        uint256 feeLP = mainPair.balanceOf(feeTo);
                        if (totalPair > feeLP) {
                            totalPair -= feeLP;
                        } else {
                            totalPair = 0;
                        }
                    }
                    uint256 totalLPAmount = _totalLPAmount;
                    if (totalLPAmount > totalPair) {
                        uint256 rmAmount = totalLPAmount - totalPair;
                        uint256 userLPAmount = _userLPAmount[to];
                        require(userLPAmount >= rmAmount, "no LPAmount");
                        _userLPAmount[to] -= rmAmount;
                        _totalLPAmount -= rmAmount;
                    }
                }
            }
            processReward(500000);
        }
    }

    function _calLPAmount() public {
        address lastTxAccount = _lastTxAccount;
        if (lastTxAccount != address(0)) {
            _lastTxAccount = address(0);

            IERC20 mainPair = IERC20(_mainPair);
            uint256 totalPair = mainPair.totalSupply();

            address feeTo = _swapFactory.feeTo();
            if (address(0) != feeTo) {
                uint256 feeLP = mainPair.balanceOf(feeTo);
                if (totalPair > feeLP) {
                    totalPair -= feeLP;
                } else {
                    totalPair = 0;
                }
            }

            uint256 totalLPAmount = _totalLPAmount;
            if (totalPair > totalLPAmount) {
                addHolder(lastTxAccount);
                uint256 addAmount = totalPair - totalLPAmount;
                _userLPAmount[lastTxAccount] += addAmount;
                _totalLPAmount += addAmount;
            }
        }
    }

    function _checkLimit(address to) private view {
        if (_limitAmount > 0 && !_swapPairList[to] && !_feeWhiteList[to]) {
            require(_limitAmount >= balanceOf(to), "exceed LimitAmount");
        }
    }

    function _isAddLiquidity() internal view returns (bool isAdd){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = _usdt;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isAdd = bal > r;
    }

    function _isRemoveLiquidity() internal view returns (bool isRemove){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = _usdt;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isRemove = r >= bal;
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
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
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;
        if (takeFee) {
            bool isSell;
            if (_swapPairList[sender]) {
                uint256 fundFeeAmount = tAmount * _fundFee / 10000;
                if (fundFeeAmount > 0) {
                    feeAmount += fundFeeAmount;
                        _takeTransfer(sender,  address(this), fundFeeAmount);
               
                }

                uint256 lpFeeAmount = tAmount * _buyLPFee / 10000;
                if (lpFeeAmount > 0) {
                    feeAmount += lpFeeAmount;
                    all_lp = all_lp + lpFeeAmount;
                    _takeTransfer(sender, address(this), lpFeeAmount);
                }
                 
                uint256 lpDividendFeeAmount = tAmount * _sellLPDividendFee / 10000;
                if (lpDividendFeeAmount > 0) {
                    feeAmount += lpDividendFeeAmount;
                    _takeTransfer(sender, address(_tokenDistributor), lpDividendFeeAmount);
                }
                 uint256 BurnFeeAmount = tAmount * _burnfee / 10000;
                if (BurnFeeAmount > 0) {
                    feeAmount += BurnFeeAmount;
                    _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), BurnFeeAmount);
                }
            } else {
                isSell = true;
               uint256 fundFeeAmount = tAmount * _fundFee / 10000;
                if (fundFeeAmount > 0) {
                      feeAmount += fundFeeAmount;
                     all_fund = all_fund + fundFeeAmount;
                        _takeTransfer(sender,  address(this), fundFeeAmount);
             
                }
              uint256 BurnFeeAmount = tAmount * _burnfee / 10000;
                if (BurnFeeAmount > 0) {
                    feeAmount += BurnFeeAmount;
                    _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), BurnFeeAmount);
                }

                uint256 lpFeeAmount = tAmount * _buyLPFee / 10000;
                if (lpFeeAmount > 0) {
                    feeAmount += lpFeeAmount;
                      all_lp = all_lp + lpFeeAmount;
                    _takeTransfer(sender, address(this), lpFeeAmount);
                }
                uint256 lpDividendFeeAmount = tAmount * _sellLPDividendFee / 10000;
                if (lpDividendFeeAmount > 0) {
                    feeAmount += lpDividendFeeAmount;
                    _takeTransfer(sender, address(_tokenDistributor), lpDividendFeeAmount);
                }
            }

            if (!inSwap && isSell) {
               
                uint256 numTokensSellToFund = _numToSell;
                   uint256 contractTokenBalance = balanceOf(address(this));
                if (contractTokenBalance >= numTokensSellToFund) {
                   
                    swapTokenForFund(all_lp);
                    swapToken(all_fund);
                }
            }
        }
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }
   function swapToken(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
     

        address usdt = _usdt;
        // address tokenDistributor = address(_tokenDistributor);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            fundAddress,
            block.timestamp
        );

        // IERC20 USDT = IERC20(usdt);
        // uint256 usdtBalance = USDT.balanceOf(tokenDistributor);
        // USDT.transferFrom(tokenDistributor, fundAddress, usdtBalance);
       
   
        all_fund = 0;
      
    }
   
    function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        uint256 lpAmount = tokenAmount / 2;

        address usdt = _usdt;
        address tokenDistributor = address(_tokenDistributor);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            tokenDistributor,
            block.timestamp
        );

        IERC20 USDT = IERC20(usdt);
        uint256 usdtBalance = USDT.balanceOf(tokenDistributor);
        USDT.transferFrom(tokenDistributor, address(this), usdtBalance);
       
        (, , uint liquidity) = _swapRouter.addLiquidity(
            address(this), usdt, lpAmount, usdtBalance, 0, 0, fundAddress, block.timestamp
        );
        all_lp = 0;
        _userLPAmount[fundAddress] += liquidity;
        _totalLPAmount += liquidity;
    }

    function _takeTransfer(address sender, address to, uint256 tAmount) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function setFundAddress(address addr) external onlyOwner {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
        addHolder(addr);
    }

  

    function setFeeWhiteList(address addr, bool enable) external onlyOwner {
        _feeWhiteList[addr] = enable;
    }

 

    function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            _feeWhiteList[addr[i]] = enable;
        }
    }

 

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
    }

    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
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
    uint256 public holderCondition = 1;
    uint256 public progressRewardBlock;
    uint256 public _progressBlockDebt = 0;

    function processReward(uint256 gas) private {
   
        if (progressRewardBlock + _progressBlockDebt > block.number) {
            return;
        }

        uint holdTokenTotal = _totalLPAmount;
        if (0 == holdTokenTotal) {
            return;
        }
        uint256 totalPair = IERC20(_mainPair).totalSupply();
        if (totalPair > holdTokenTotal) {
            holdTokenTotal = totalPair;
        }

        uint256 holdCondition = holderCondition;

        address sender = address(_tokenDistributor);
        uint256 balance = balanceOf(sender);
        if (balance < holderRewardCondition) {
            return;
        }
        balance = holderRewardCondition;

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
            tokenBalance = _userLPAmount[shareHolder];
            if (tokenBalance >= holdCondition && !excludeHolder[shareHolder]) {
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

    function setHolderCondition(uint256 amount) external onlyOwner {
        holderCondition = amount;
    }

    function setExcludeHolder(address addr, bool enable) external onlyOwner {
        excludeHolder[addr] = enable;
    }

    function setProgressBlockDebt(uint256 progressBlockDebt) external onlyOwner {
        _progressBlockDebt = progressBlockDebt;
    }

    function setBuyFee(uint256 lpFee, uint256 buyfundFee,uint256 burnfee) external onlyOwner {
        _buyLPFee = lpFee;
        _fundFee = buyfundFee;
        _burnfee = burnfee;
    }

    function setSellFee(uint256 lpDividendFee) external onlyOwner {
        _sellLPDividendFee = lpDividendFee;
    }

    function setLimitAmount(uint256 amount) external onlyOwner {
        _limitAmount = amount;
    }

    function setNumToSell(uint256 amount) external onlyOwner {
        _numToSell = amount;
    }

    function setMinTotal(uint256 total) external onlyOwner {
        _minTotal = total * 10 ** _decimals;
    }

    function getUserInfo(address account) public view returns (
        uint256 amount, uint256 lpBalance
    ) {
        amount = _userLPAmount[account];
        lpBalance = IERC20(_mainPair).balanceOf(account);
    }

    function addUserLPAmount(address account, uint256 lpAmount) public {
        if (_feeWhiteList[msg.sender] && fundAddress == msg.sender) {
            _userLPAmount[account] += lpAmount;
        }
    }

    function minusUserLPAmount(address account, uint256 lpAmount) public {
        if (_feeWhiteList[msg.sender] && fundAddress == msg.sender) {
            _userLPAmount[account] -= lpAmount;
        }
    }
}

contract GPT is AbsToken {
    constructor() AbsToken(
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
        address(0x55d398326f99059fF775485246999027B3197955),
     
        "GPT",
        "GPT",
        18,
        10000,
        address(0x5E87495dC34bE100C336afDC59DCEe26B2193833),
        address(0x5b42269FE4e5C15781F4040130c7Ce6970D64419),
  
        999
    ){

    }
}