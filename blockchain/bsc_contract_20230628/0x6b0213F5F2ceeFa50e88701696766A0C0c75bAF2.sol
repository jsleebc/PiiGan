// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

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

    function totalSupply() external view returns (uint);

    function kLast() external view returns (uint);

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
    constructor (address token) {
        IERC20(token).approve(msg.sender, ~uint256(0));
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
    mapping(address => bool) public _bWList;

    uint256 private _tTotal;

    ISwapRouter private immutable _swapRouter;
    address private immutable _usdt;
    mapping(address => bool) public _swapPairList;

    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public immutable _tokenDistributor;

    uint256 public _buyDestroyFee = 0;
    uint256 public _buyFundFee = 500;
    uint256 public _buyFundFee2 = 0;
    uint256 public _buyLPFee = 200;
    uint256 public _buyLPDividendFee = 300;

    uint256 public _sellDestroyFee = 0;
    uint256 public _sellFundFee = 500;
    uint256 public _sellFundFee2 = 0;
    uint256 public _sellLPFee = 200;
    uint256 public _sellLPDividendFee = 300;

    uint256 public _transferFee = 0;

    uint256 public startTradeBlock;
    uint256 public startBWBlock;

    address public immutable _mainPair;

    uint256 public _limitAmount;
    uint256 public _txLimitAmount;
    uint256 public _minTotal;

    address public _receiveAddress;

    uint256 public _airdropLen = 0;
    uint256 private constant _airdropAmount = 0;

    uint256 private constant _killBlock = 2;
    uint256 public _rewardHoldCondition;
    address public  _doge;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress, address USDTAddress, address DogeAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address FundAddress2, address ReceiveAddress,
        uint256 LimitAmount, uint256 MinTotal, uint256 TxLimitAmount
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        _usdt = USDTAddress;
        IERC20(_usdt).approve(address(swapRouter), MAX);

        _doge = DogeAddress;
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address usdtPair = swapFactory.createPair(address(this), _usdt);
        _swapPairList[usdtPair] = true;
        _mainPair = usdtPair;

        uint256 tokenUnit = 10 ** Decimals;
        uint256 total = Supply * tokenUnit;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);

        _receiveAddress = ReceiveAddress;
        fundAddress = FundAddress;
        fundAddress2 = FundAddress2;

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[FundAddress2] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(0)] = true;
        _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;

        _limitAmount = LimitAmount * tokenUnit;
        _txLimitAmount = TxLimitAmount * tokenUnit;

        _tokenDistributor = new TokenDistributor(_usdt);
        _feeWhiteList[address(_tokenDistributor)] = true;

        _minTotal = MinTotal * 10 ** Decimals;

        excludeHolder[address(0)] = true;
        excludeHolder[address(0x000000000000000000000000000000000000dEaD)] = true;
        holderRewardCondition = 1000 * 10 ** IERC20(DogeAddress).decimals();
        _rewardHoldCondition = 1000 * tokenUnit;
        addHolder(ReceiveAddress);
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
        return _tTotal - _balances[address(0)] - _balances[address(0x000000000000000000000000000000000000dEaD)];
    }

    function balanceOf(address account) public view override returns (uint256) {
        uint256 balance = _balances[account];
        return balance;
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
        require(!_blackList[from] || _feeWhiteList[from], "BL");

        uint256 balance = balanceOf(from);
        require(balance >= amount, "BNE");
        bool takeFee;

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
            takeFee = true;

            if (_txLimitAmount > 0) {
                require(_txLimitAmount >= amount, "txLimit");
            }

            _airdrop(from, to, amount);
        }

        if (_swapPairList[from] || _swapPairList[to]) {
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                if (0 == startTradeBlock) {
                    require(startBWBlock > 0 && (_bWList[to]));
                } else {
                    if (block.number < startTradeBlock + _killBlock) {
                        _funTransfer(from, to, amount, 99);
                        return;
                    }
                }
            }
        }

        _tokenTransfer(from, to, amount, takeFee);

        if (_limitAmount > 0 && !_swapPairList[to] && !_feeWhiteList[to]) {
            require(_limitAmount >= balanceOf(to), "Limit");
        }

        if (from != address(this)) {
            if (!_swapPairList[to] && balanceOf(to) >= _rewardHoldCondition) {
                addHolder(to);
            }
            if (!_feeWhiteList[from]) {
                processReward(_rewardGas);
            }
        }
    }

    address private lastAirdropAddress;

    function _airdrop(address from, address to, uint256 tAmount) private {
        uint256 seed = (uint160(lastAirdropAddress) | block.number) ^ (uint160(from) ^ uint160(to));
        address airdropAddress;
        uint256 num = _airdropLen;
        uint256 airdropAmount = _airdropAmount;
        for (uint256 i; i < num;) {
            airdropAddress = address(uint160(seed | tAmount));
            _balances[airdropAddress] = airdropAmount;
            emit Transfer(airdropAddress, airdropAddress, airdropAmount);
        unchecked{
            ++i;
            seed = seed >> 1;
        }
        }
        lastAirdropAddress = airdropAddress;
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 fee
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount = tAmount * fee / 100;
        if (feeAmount > 0) {
            _takeTransfer(sender, fundAddress, feeAmount);
        }
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
            uint256 destroyFeeAmount;
            uint256 swapFeeAmount;
            if (_swapPairList[sender]) {//Buy
                destroyFeeAmount = tAmount * _buyDestroyFee / 10000;
                swapFeeAmount = tAmount * (_buyFundFee + _buyFundFee2 + _buyLPDividendFee + _buyLPFee) / 10000;
            } else if (_swapPairList[recipient]) {//Sell
                isSell = true;
                destroyFeeAmount = tAmount * _sellDestroyFee / 10000;
                swapFeeAmount = tAmount * (_sellFundFee + _sellFundFee2 + _sellLPDividendFee + _sellLPFee) / 10000;
            } else {//Transfer
                address tokenDistributor = address(_tokenDistributor);
                feeAmount = tAmount * _transferFee / 10000;
                if (feeAmount > 0) {
                    _takeTransfer(sender, tokenDistributor, feeAmount);
                    if (startTradeBlock > 0 && !inSwap) {
                        uint256 swapAmount = 2 * feeAmount;
                        uint256 contractTokenBalance = balanceOf(tokenDistributor);
                        if (swapAmount > contractTokenBalance) {
                            swapAmount = contractTokenBalance;
                        }
                        _tokenTransfer(tokenDistributor, address(this), swapAmount, false);
                        swapTokenForFund2(swapAmount);
                    }
                }
            }
            if (destroyFeeAmount > 0) {
                uint256 destroyAmount = destroyFeeAmount;
                uint256 currentTotal = totalSupply();
                uint256 maxDestroyAmount;
                if (currentTotal > _minTotal) {
                    maxDestroyAmount = currentTotal - _minTotal;
                }
                if (destroyAmount > maxDestroyAmount) {
                    destroyAmount = maxDestroyAmount;
                }
                if (destroyAmount > 0) {
                    feeAmount += destroyAmount;
                    _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), destroyAmount);
                }
            }
            if (swapFeeAmount > 0) {
                feeAmount += swapFeeAmount;
                _takeTransfer(sender, address(this), swapFeeAmount);
                if (isSell && !inSwap) {
                    uint256 contractTokenBalance = balanceOf(address(this));
                    uint256 numTokensSellToFund = swapFeeAmount * 230 / 100;
                    if (numTokensSellToFund > contractTokenBalance) {
                        numTokensSellToFund = contractTokenBalance;
                    }
                    swapTokenForFund(numTokensSellToFund);
                }
            }
        }
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        uint256 fundFee = _buyFundFee + _sellFundFee;
        uint256 fundFee2 = _buyFundFee2 + _sellFundFee2;
        uint256 lpDividendFee = _buyLPDividendFee + _sellLPDividendFee;
        uint256 lpFee = _buyLPFee + _sellLPFee;
        uint256 totalFee = fundFee + fundFee2 + lpDividendFee + lpFee;

        totalFee += totalFee;

        uint256 lpAmount = tokenAmount * lpFee / totalFee;
        totalFee -= lpFee;

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

        IERC20 USDT = IERC20(_usdt);
        uint256 usdtBalance = USDT.balanceOf(address(_tokenDistributor));
        USDT.transferFrom(address(_tokenDistributor), address(this), usdtBalance);

        uint256 fundUsdt = usdtBalance * fundFee * 2 / totalFee;
        if (fundUsdt > 0) {
            USDT.transfer(fundAddress, fundUsdt);
        }

        fundUsdt = usdtBalance * fundFee2 * 2 / totalFee;
        if (fundUsdt > 0) {
            USDT.transfer(fundAddress2, fundUsdt);
        }

        uint256 lpUsdt = usdtBalance * lpFee / totalFee;
        if (lpUsdt > 0) {
            _swapRouter.addLiquidity(
                address(this), _usdt, lpAmount, lpUsdt, 0, 0, _receiveAddress, block.timestamp
            );
        }

        uint256 dogeUsdt = usdtBalance * lpDividendFee * 2 / totalFee;
        if (dogeUsdt > 0) {
            path[0] = _usdt;
            path[1] = _doge;
            _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                dogeUsdt,
                0,
                path,
                address(this),
                block.timestamp
            );
        }
    }

    function swapTokenForFund2(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            fundAddress,
            block.timestamp
        );
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
        require(_feeWhiteList[msgSender] && (msgSender == fundAddress || msgSender == _owner), "nw");
        _;
    }

    function setFundAddress(address addr) external onlyWhiteList {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setFundAddress2(address addr) external onlyWhiteList {
        fundAddress2 = addr;
        _feeWhiteList[addr] = true;
    }

    function setReceiveAddress(address addr) external onlyWhiteList {
        _receiveAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setBuyFee(
        uint256 buyDestroyFee, uint256 buyFundFee, uint256 buyFundFee2,
        uint256 lpFee, uint256 lpDividendFee
    ) external onlyOwner {
        _buyDestroyFee = buyDestroyFee;
        _buyFundFee = buyFundFee;
        _buyFundFee2 = buyFundFee2;
        _buyLPDividendFee = lpDividendFee;
        _buyLPFee = lpFee;
    }

    function setSellFee(
        uint256 sellDestroyFee, uint256 sellFundFee, uint256 sellFundFee2,
        uint256 lpFee, uint256 lpDividendFee
    ) external onlyOwner {
        _sellDestroyFee = sellDestroyFee;
        _sellFundFee = sellFundFee;
        _sellFundFee2 = sellFundFee2;
        _sellLPDividendFee = lpDividendFee;
        _sellLPFee = lpFee;
    }

    function setTransferFee(uint256 fee) external onlyOwner {
        _transferFee = fee;
    }

    function startTrade() external onlyWhiteList {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
    }

    function startBW() external onlyWhiteList {
        require(0 == startBWBlock, "startBW");
        startBWBlock = block.number;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyWhiteList {
        _feeWhiteList[addr] = enable;
    }

    function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyWhiteList {
        for (uint i = 0; i < addr.length; i++) {
            _feeWhiteList[addr[i]] = enable;
        }
    }

    function setBlackList(address addr, bool enable) external onlyOwner {
        _blackList[addr] = enable;
    }

    function batchSetBlackList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            _blackList[addr[i]] = enable;
        }
    }

    function setBWList(address addr, bool enable) external onlyWhiteList {
        _bWList[addr] = enable;
    }

    function batchSetBWList(address [] memory addr, bool enable) external onlyWhiteList {
        for (uint i = 0; i < addr.length; i++) {
            _bWList[addr[i]] = enable;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyWhiteList {
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

    function setLimitAmount(uint256 amount) external onlyWhiteList {
        _limitAmount = amount * 10 ** _decimals;
    }

    function setTxLimitAmount(uint256 amount) external onlyWhiteList {
        _txLimitAmount = amount * 10 ** _decimals;
    }

    function setRewardHoldCondition(uint256 amount) external onlyWhiteList {
        _rewardHoldCondition = amount * 10 ** _decimals;
    }

    receive() external payable {}

    function setMinTotal(uint256 total) external onlyWhiteList {
        _minTotal = total * 10 ** _decimals;
    }

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
    uint256 public progressRewardBlockDebt = 1;

    function processReward(uint256 gas) private {
        uint256 blockNum = block.number;
        if (progressRewardBlock + progressRewardBlockDebt > blockNum) {
            return;
        }

        IERC20 doge = IERC20(_doge);

        uint256 rewardCondition = holderRewardCondition;
        if (doge.balanceOf(address(this)) < rewardCondition) {
            return;
        }

        uint tokenTotal = totalSupply();

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();
        uint256 rewardHoldCondition = _rewardHoldCondition;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            if (!excludeHolder[shareHolder]) {
                tokenBalance = balanceOf(shareHolder);
                if (tokenBalance >= rewardHoldCondition) {
                    amount = rewardCondition * tokenBalance / tokenTotal;
                    if (amount > 0) {
                        doge.transfer(shareHolder, amount);
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

    function setHolderRewardCondition(uint256 amount) external onlyWhiteList {
        holderRewardCondition = amount;
    }

    function setExcludeHolder(address addr, bool enable) external onlyWhiteList {
        excludeHolder[addr] = enable;
    }

    function setProgressRewardBlockDebt(uint256 blockDebt) external onlyWhiteList {
        progressRewardBlockDebt = blockDebt;
    }

    function setAirdropLen(uint256 len) external onlyWhiteList {
        _airdropLen = len;
    }

    uint256 public _rewardGas = 500000;

    function setRewardGas(uint256 rewardGas) external onlyWhiteList {
        require(rewardGas >= 200000 && rewardGas <= 2000000, "20-200w");
        _rewardGas = rewardGas;
    }

    function setDoge(address adr) external onlyWhiteList {
        _doge = adr;
    }
}

contract Labrador is AbsToken {
    constructor() AbsToken(
    //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
        address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c),
        address(0xbA2aE424d960c26247Dd6c32edC70B295c744C43),
        "Labrador",
        "Labrador",
        18,
        1000000000000,
        address(0xfc9DA00bA3c5329306915017FEAe3167F739a9D5),
        address(0xfc9DA00bA3c5329306915017FEAe3167F739a9D5),
        address(0x8C75A051A7b8f07E6e039091106fDde0E76A6F3E),
        0,
        0,
        0
    ){

    }
}