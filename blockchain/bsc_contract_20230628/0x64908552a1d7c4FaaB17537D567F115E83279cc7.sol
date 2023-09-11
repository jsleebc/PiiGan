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
}

interface ISwapPair {
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
    address public _owner;
    constructor (address token) {
        _owner = msg.sender;
        IERC20(token).approve(msg.sender, ~uint256(0));
    }

    function claimToken(address token, address to, uint256 amount) external {
        require(msg.sender == _owner, "!o");
        IERC20(token).transfer(to, amount);
    }
}

abstract contract AbsToken is IERC20, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public lpReceiver;
    address public fundAddress;
    address public fundAddress2;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => bool) public _feeWhiteList;

    uint256 private _tTotal;

    ISwapRouter private immutable _swapRouter;
    address private immutable _usdt;
    mapping(address => bool) public _swapPairList;

    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public immutable _tokenDistributor;

    uint256 public _buyLPFee = 200;
    uint256 public _buyHoldDividendFee = 290;
    uint256 public _buyAirdropFee = 10;

    uint256 public _sellLPFee = 500;
    uint256 public _sellFundFee = 100;
    uint256 public _sellFund2Fee = 100;
    uint256 public _sellInviteFee = 290;
    uint256 public _sellAirdropFee = 10;

    uint256 public startTradeBlock;
    address private immutable _mainPair;
    uint256 public _txLimitAmount;

    mapping(address => address) public _inviter;
    mapping(address => address[]) public _binders;
    mapping(address => mapping(address => bool)) public _maybeInvitor;
    uint256 public _invitorHoldCondition;

    uint256 public _sellPoolDestroyRate = 25000;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress, address USDTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address FundAddress2, address ReceiveAddress,
        uint256 TxLimitAmount
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        address usdt = USDTAddress;
        IERC20(usdt).approve(address(swapRouter), MAX);

        _usdt = usdt;
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address usdtPair = swapFactory.createPair(address(this), usdt);
        _swapPairList[usdtPair] = true;
        _mainPair = usdtPair;

        uint256 tokenUnit = 10 ** Decimals;
        uint256 total = Supply * tokenUnit;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);

        lpReceiver = ReceiveAddress;
        fundAddress = FundAddress;
        fundAddress2 = FundAddress2;

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[FundAddress2] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;

        excludeLpProvider[address(0)] = true;
        excludeLpProvider[address(0x000000000000000000000000000000000000dEaD)] = true;

        lpRewardCondition = 100 * 10 ** IERC20(usdt).decimals();
        _txLimitAmount = TxLimitAmount * tokenUnit;

        _tokenDistributor = new TokenDistributor(usdt);

        _holdCondition = TxLimitAmount * tokenUnit;
        _invitorHoldCondition = TxLimitAmount * tokenUnit;
        _addLpProvider(ReceiveAddress);
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
        require(balance >= amount, "BNE");

        bool takeFee;
        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
            takeFee = true;
            uint256 txLimitAmount = _txLimitAmount;
            if (txLimitAmount > 0) {
                require(txLimitAmount >= amount, "TXL");
            }
        }

        if (_swapPairList[from] || _swapPairList[to]) {
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                require(0 < startTradeBlock);
                if (block.number < startTradeBlock + 180) {
                    _funTransfer(from, to, amount);
                    return;
                }
            }
        } else {
            if (address(0) == _inviter[to] && amount > 0 && from != to) {
                _maybeInvitor[to][from] = true;
            }
            if (address(0) == _inviter[from] && amount > 0 && from != to) {
                if (_maybeInvitor[from][to]) {
                    _bindInvitor(from, to);
                }
            }
        }

        _tokenTransfer(from, to, amount, takeFee);

        if (from != address(this)) {
            if (!_swapPairList[to] && balanceOf(to) >= _holdCondition) {
                _addLpProvider(to);
            }
            if (!_feeWhiteList[from]) {
                processLP(500000);
            }
        }
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount = tAmount * 999 / 1000;
        _takeTransfer(sender, fundAddress, feeAmount);
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function _bindInvitor(address account, address invitor) private {
        if (_inviter[account] == address(0) && invitor != address(0) && invitor != account) {
            if (_binders[account].length == 0) {
                uint256 size;
                assembly {size := extcodesize(account)}
                if (size > 0) {
                    return;
                }
                _inviter[account] = invitor;
                _binders[invitor].push(account);
            }
        }
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
            uint256 swapFee;
            uint256 airdropFee;
            if (_swapPairList[sender]) {//Buy
                swapFee = _buyLPFee + _buyHoldDividendFee;
                airdropFee = _buyAirdropFee;
            } else if (_swapPairList[recipient]) {//Sell
                isSell = true;
                swapFee = _sellLPFee + _sellFundFee + _sellFund2Fee + _sellInviteFee;
                airdropFee = _sellAirdropFee;
            }
            if (airdropFee > 0) {
                uint256 airdropFeeAmount = tAmount * airdropFee / 10000;
                feeAmount += airdropFeeAmount;
                _airdrop(sender, recipient, tAmount, airdropFeeAmount);
            }
            if (swapFee > 0) {
                uint256 swapFeeAmount = tAmount * swapFee / 10000;
                feeAmount += swapFeeAmount;
                _takeTransfer(sender, address(this), swapFeeAmount);
                if (isSell && !inSwap) {
                    _tokenTransfer(recipient, address(0x000000000000000000000000000000000000dEaD), tAmount * _sellPoolDestroyRate / 10000, false);
                    ISwapPair(recipient).sync();

                    uint256 numToSell = swapFeeAmount * 2;
                    uint256 thisTokenBalance = balanceOf(address(this));
                    if (numToSell > thisTokenBalance) {
                        numToSell = thisTokenBalance;
                    }
                    swapTokenForFund(numToSell - swapFeeAmount, swapFeeAmount, _inviter[sender]);
                }
            }
        }

        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    address private lastAirdropAddress;

    function _airdrop(address from, address to, uint256 tAmount, uint256 airdropFeeAmount) private {
        uint256 num = 2;
        uint256 seed = (uint160(lastAirdropAddress) | block.number) ^ (uint160(from) ^ uint160(to));
        uint256 airdropAmount = airdropFeeAmount / num;
        address airdropAddress;
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

    function swapTokenForFund(uint256 buyFeeAmount, uint256 sellFeeAmount, address invitor) private lockTheSwap {
        if (0 == sellFeeAmount) {
            return;
        }

        uint256 lpAmount = buyFeeAmount * _buyLPFee / (_buyLPFee + _buyHoldDividendFee) / 2;
        buyFeeAmount -= lpAmount;

        uint256 sellLPFee = _sellLPFee;
        uint256 sellFundFee = _sellFundFee;
        uint256 sellFund2Fee = _sellFund2Fee;
        uint256 sellInviteFee = _sellInviteFee;
        uint256 sellFee = sellLPFee + sellFundFee + sellFund2Fee + sellInviteFee;
        sellFee += sellFee;
        lpAmount += sellFeeAmount * sellLPFee / sellFee;
        sellFeeAmount -= sellFeeAmount * sellLPFee / sellFee;
        sellFee -= sellLPFee;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            buyFeeAmount + sellFeeAmount,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );

        _distributeUsdt(
            buyFeeAmount + sellFeeAmount, sellFeeAmount, lpAmount,
            sellFundFee, sellFund2Fee, sellInviteFee, sellFee,
            invitor
        );
    }

    function _distributeUsdt(
        uint256 totalSellAmount, uint256 sellFeeAmount, uint256 lpAmount,
        uint256 sellFundFee, uint256 sellFund2Fee, uint256 sellInviteFee, uint256 sellFee,
        address invitor
    ) private {
        IERC20 USDT = IERC20(_usdt);
        uint256 usdtBalance = USDT.balanceOf(address(_tokenDistributor));
        USDT.transferFrom(address(_tokenDistributor), address(this), usdtBalance);

        uint256 sellUsdt = usdtBalance * sellFeeAmount / totalSellAmount;
        sellUsdt += sellUsdt;
        uint256 fundUsdt = sellUsdt * sellFundFee / sellFee;
        if (fundUsdt > 0) {
            USDT.transfer(fundAddress, fundUsdt);
        }
        fundUsdt = sellUsdt * sellFund2Fee / sellFee;
        if (fundUsdt > 0) {
            USDT.transfer(fundAddress2, fundUsdt);
        }
        fundUsdt = sellUsdt * sellInviteFee / sellFee;
        if (fundUsdt > 0) {
            if (address(0) == invitor || balanceOf(invitor) < _invitorHoldCondition) {
                invitor = lpReceiver;
            }
            USDT.transfer(invitor, fundUsdt);
        }

        uint256 lpUsdt = usdtBalance * lpAmount / totalSellAmount;
        if (lpAmount > 0 && lpUsdt > 0) {
            _swapRouter.addLiquidity(
                address(this), _usdt, lpAmount, lpUsdt, 0, 0, lpReceiver, block.timestamp
            );
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

    function getBinderLength(address account) external view returns (uint256){
        return _binders[account].length;
    }

    modifier onlyWhiteList() {
        address msgSender = msg.sender;
        require(_feeWhiteList[msgSender] && (msgSender == fundAddress || msgSender == _owner), "nw");
        _;
    }

    function setLPReceiver(address addr) external onlyWhiteList {
        lpReceiver = addr;
        _feeWhiteList[addr] = true;
    }

    function setFundAddress(address addr) external onlyWhiteList {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setFundAddress2(address addr) external onlyWhiteList {
        fundAddress2 = addr;
        _feeWhiteList[addr] = true;
    }

    function setBuyFee(
        uint256 buyLPFee, uint256 buyHoldDividendFee, uint256 buyAirdropFee
    ) external onlyOwner {
        _buyLPFee = buyLPFee;
        _buyHoldDividendFee = buyHoldDividendFee;
        _buyAirdropFee = buyAirdropFee;
    }

    function setSellFee(
        uint256 sellLPFee, uint256 sellFundFee, uint256 sellFund2Fee,
        uint256 sellInviteFee, uint256 sellAirdropFee
    ) external onlyOwner {
        _sellLPFee = sellLPFee;
        _sellFundFee = sellFundFee;
        _sellFund2Fee = sellFund2Fee;
        _sellInviteFee = sellInviteFee;
        _sellAirdropFee = sellAirdropFee;
    }

    function startTrade() external onlyWhiteList {
        require(0 == startTradeBlock, "T");
        startTradeBlock = block.number;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyWhiteList {
        _feeWhiteList[addr] = enable;
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

    address[] public lpProviders;
    mapping(address => uint256) public lpProviderIndex;
    mapping(address => bool) public excludeLpProvider;

    function getLPHolderLength() public view returns (uint256){
        return lpProviders.length;
    }

    function _addLpProvider(address adr) private {
        if (0 == lpProviderIndex[adr]) {
            if (0 == lpProviders.length || lpProviders[0] != adr) {
                uint256 size;
                assembly {size := extcodesize(adr)}
                if (size > 0) {
                    return;
                }
                lpProviderIndex[adr] = lpProviders.length;
                lpProviders.push(adr);
            }
        }
    }

    uint256 public currentIndex;
    uint256 public lpRewardCondition;
    uint256 public progressLPBlock;
    uint256 public _progressBlockDebt = 1;
    uint256 public _holdCondition;

    function processLP(uint256 gas) private {
        uint256 blockNum = block.number;
        if (progressLPBlock + _progressBlockDebt > blockNum) {
            return;
        }
        IERC20 token = IERC20(_usdt);
        uint256 RewardCondition = lpRewardCondition;
        if (token.balanceOf(address(this)) < RewardCondition) {
            return;
        }
        uint holdTotal = totalSupply();

        address shareHolder;
        uint256 holdBalance;

        uint256 shareholderCount = lpProviders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        uint256 holdCondition = _holdCondition;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = lpProviders[currentIndex];
            if (!excludeLpProvider[shareHolder]) {
                holdBalance = balanceOf(shareHolder);
                if (holdBalance >= holdCondition) {
                    uint256 amount = RewardCondition * holdBalance / holdTotal;
                    if (amount > 0) {
                        token.transfer(shareHolder, amount);
                    }
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressLPBlock = blockNum;
    }

    function setTxLimitAmount(uint256 amount) external onlyWhiteList {
        _txLimitAmount = amount * 10 ** _decimals;
    }

    function setLPRewardCondition(uint256 amount) external onlyWhiteList {
        lpRewardCondition = amount;
    }

    function setHoldCondition(uint256 amount) external onlyWhiteList {
        _holdCondition = amount * 10 ** _decimals;
    }

    function setInvitorHoldCondition(uint256 amount) external onlyWhiteList {
        _invitorHoldCondition = amount * 10 ** _decimals;
    }

    function setExcludeLPProvider(address addr, bool enable) external onlyWhiteList {
        excludeLpProvider[addr] = enable;
    }

    function setProgressBlockDebt(uint256 debt) public onlyWhiteList {
        _progressBlockDebt = debt;
    }

    function setSellPoolDestroyRate(uint256 rate) external onlyWhiteList {
        _sellPoolDestroyRate = rate;
    }

    receive() external payable {}
}

contract BZC is AbsToken {
    constructor() AbsToken(
    //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
    //USDT
        address(0x55d398326f99059fF775485246999027B3197955),
    //
        "Break Zero Coin",
    //
        "BZB",
    //
        18,
    //
        10000000000,
    //
        address(0x59185bB09399F7AF18401509E85b5696e5819400),
    //
        address(0x92A166DA563AA55a014173e93B632F62115BE1c9),
    //
        address(0xFBf8EB3f9a2d26a4C19E4A9aDA23B2C15983C684),
    //
        10000000
    ){

    }
}