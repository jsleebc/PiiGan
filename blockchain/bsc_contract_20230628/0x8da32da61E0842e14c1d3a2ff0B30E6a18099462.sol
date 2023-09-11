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

library Math {
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
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
    struct UserInfo {
        uint256 lpAmount;
        bool preLP;
    }

    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;
    address public fundAddress2;
    address public lpReceiver;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    uint256 public _buyFundFee = 10000;
    uint256 public _buyFundFee2 = 0;
    uint256 public _buyLPFee = 0;
    uint256 public _buyLPDividendFee = 0;
    uint256 public _buyPartnerFee = 0;

    uint256 public _sellFundFee = 150;
    uint256 public _sellFundFee2 = 150;
    uint256 public _sellLPFee = 0;
    uint256 public _sellLPDividendFee = 0;
    uint256 public _sellPartnerFee = 0;

    uint256 public _transferFee = 0;

    uint256 public startTradeBlock;
    mapping(address => bool) public _feeWhiteList;
    mapping(address => bool) public _blackList;
    mapping(address => bool) public _excludeRewardList;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal;
    uint256 public _rTotal;

    mapping(address => bool) public _swapPairList;

    uint256 public _limitAmount;
    uint256 public _txLimitAmount;

    uint256  public _aprPerTime = 84143;
    uint256  public _aprDuration = 1 hours;
    uint256 private constant AprDivBase = 100000000;
    uint256 public _lastRewardTime;
    bool public _autoApy;

    TokenDistributor public immutable _tokenDistributor;
    address public immutable _usdt;
    address public immutable _mainPair;
    ISwapRouter public immutable _swapRouter;

    uint256 public distributeRate = 5000;
    mapping(address => uint256) public _buyTimes;
    bool public _onlyBuy1Time = true;

    uint256 public _removeLPFee = 100;
    uint256 public _addLPFee = 100;
    address public _lpFeeReceiver;
    uint256 public _killRobotBlockNum = 0;
    uint256 public _removePreLPFee = 10000;
    mapping(address => UserInfo) private _userInfo;

    bool private inSwap;
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouteAddress, address USDTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address ReceivedAddress, address FundAddress, address FundAddress2,
        uint256 LimitAmount, uint256 TxLimitAmount
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouteAddress);
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;
        IERC20(USDTAddress).approve(address(swapRouter), MAX);

        _usdt = USDTAddress;
        address usdtPair = ISwapFactory(swapRouter.factory()).createPair(address(this), USDTAddress);
        _swapPairList[usdtPair] = true;
        _excludeRewardList[usdtPair] = true;
        _excludeRewardList[address(this)] = true;
        _mainPair = usdtPair;

        uint256 tTotal = Supply * 10 ** Decimals;
        uint256 base = AprDivBase * 100;
        uint256 rTotal = MAX / base - (MAX / base % tTotal);
        _rOwned[ReceivedAddress] = rTotal;
        _tOwned[ReceivedAddress] = tTotal;
        emit Transfer(address(0), ReceivedAddress, tTotal);
        _rTotal = rTotal;
        _tTotal = tTotal;

        fundAddress = FundAddress;
        fundAddress2 = FundAddress2;
        lpReceiver = ReceivedAddress;
        _lpFeeReceiver = ReceivedAddress;

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[FundAddress2] = true;
        _feeWhiteList[ReceivedAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[address(0)] = true;
        _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;

        _excludeRewardList[FundAddress] = true;
        _excludeRewardList[FundAddress2] = true;
        _excludeRewardList[ReceivedAddress] = true;
        _excludeRewardList[msg.sender] = true;
        _excludeRewardList[address(swapRouter)] = true;
        _excludeRewardList[address(0)] = true;
        _excludeRewardList[address(0x000000000000000000000000000000000000dEaD)] = true;

        _tokenDistributor = new TokenDistributor(USDTAddress);
        _feeWhiteList[address(_tokenDistributor)] = true;
        _excludeRewardList[address(_tokenDistributor)] = true;

        _limitAmount = LimitAmount * 10 ** Decimals;
        _txLimitAmount = TxLimitAmount * 10 ** Decimals;

        excludeHolder[address(0)] = true;
        excludeHolder[address(0x000000000000000000000000000000000000dEaD)] = true;
        uint256 usdtUnit = 10 ** IERC20(_usdt).decimals();
        holderRewardCondition = 100 * usdtUnit;
    }

    function calApy() public {
        if (!_autoApy) {
            return;
        }
        uint256 total = _tTotal;
        uint256 maxTotal = _rTotal;
        if (total == maxTotal) {
            return;
        }
        uint256 blockTime = block.timestamp;
        uint256 lastRewardTime = _lastRewardTime;
        uint256 aprDuration = _aprDuration;
        if (blockTime < lastRewardTime + aprDuration) {
            return;
        }
        uint256 deltaTime = blockTime - lastRewardTime;
        uint256 times = deltaTime / aprDuration;
        uint256 aprPerTime = _aprPerTime;

        for (uint256 i; i < times;) {
            total = total * (AprDivBase - aprPerTime) / AprDivBase;
            if (total > maxTotal) {
                total = maxTotal;
                break;
            }
        unchecked{
            ++i;
        }
        }
        _tTotal = total;
        _lastRewardTime = lastRewardTime + times * aprDuration;
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
        if (_excludeRewardList[account]) {
            return _tOwned[account];
        }
        return tokenFromReflection(_rOwned[account]);
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

    function tokenFromReflection(uint256 rAmount) public view returns (uint256){
        uint256 currentRate = _getRate();
        return rAmount / currentRate;
    }

    function _getRate() public view returns (uint256) {
        if (_rTotal < _tTotal) {
            return 1;
        }
        return _rTotal / _tTotal;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    address private _lastMaybeLPAddress;

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(!_blackList[from] || _feeWhiteList[from], "blackList");

        calApy();

        uint256 balance = balanceOf(from);
        require(balance >= amount, "BNE");

        address lastMaybeLPAddress = _lastMaybeLPAddress;
        if (lastMaybeLPAddress != address(0)) {
            _lastMaybeLPAddress = address(0);
            if (IERC20(_mainPair).balanceOf(lastMaybeLPAddress) > 0) {
                addHolder(lastMaybeLPAddress);
            }
        }

        bool takeFee;
        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
            if (_txLimitAmount > 0) {
                require(_txLimitAmount >= amount, "txLimit");
            }
            takeFee = true;
            if (_swapPairList[from] || _swapPairList[to]) {
                require(startTradeBlock > 0);
                if (block.number < startTradeBlock + _killRobotBlockNum) {
                    _funTransfer(from, to, amount);
                    return;
                }
            }
        }

        bool isAddLP;
        bool isRemoveLP;
        uint256 addLPLiquidity;
        if (to == _mainPair) {
            uint256 addLPAmount = amount;
            if (!_feeWhiteList[from]) {
                addLPAmount -= amount * _addLPFee / 10000;
            }
            addLPLiquidity = _isAddLiquidity(addLPAmount);
            if (addLPLiquidity > 0) {
                UserInfo storage userInfo = _userInfo[from];
                userInfo.lpAmount += addLPLiquidity;
                isAddLP = true;
            }
        }

        uint256 removeLPLiquidity;
        if (from == _mainPair) {
            removeLPLiquidity = _isRemoveLiquidity(amount);
            if (removeLPLiquidity > 0) {
                require(_userInfo[to].lpAmount >= removeLPLiquidity);
                _userInfo[to].lpAmount -= removeLPLiquidity;
                isRemoveLP = true;
            }
        }

        _tokenTransfer(from, to, amount, takeFee, isAddLP, isRemoveLP);

        if (_limitAmount > 0 && !_swapPairList[to] && !_feeWhiteList[to]) {
            require(_limitAmount >= balanceOf(to), "Limit");
        }

        if (from != address(this)) {
            if (_mainPair == to) {
                _lastMaybeLPAddress = from;
            }
            if (!_feeWhiteList[from]) {
                processReward(500000);
            }
        }
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        if (_tOwned[sender] > tAmount) {
            _tOwned[sender] -= tAmount;
        } else {
            _tOwned[sender] = 0;
        }

        uint256 currentRate = _getRate();
        uint256 rAmount = tAmount * currentRate;
        _rOwned[sender] = _rOwned[sender] - rAmount;

        _takeTransfer(sender, fundAddress, tAmount / 100 * 99, currentRate);
        _takeTransfer(sender, recipient, tAmount / 100 * 1, currentRate);
    }

    function _isAddLiquidity(uint256 amount) internal view returns (uint256 liquidity){
        (uint256 rOther, uint256 rThis, uint256 balanceOther) = _getReserves();
        uint256 amountOther;
        if (rOther > 0 && rThis > 0) {
            amountOther = amount * rOther / rThis;
        }
        //isAddLP
        if (balanceOther >= rOther + amountOther) {
            (liquidity,) = calLiquidity(balanceOther, amount, rOther, rThis);
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
                    uint256 numerator = pairTotalSupply * (rootK - rootKLast) * 8;
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

    function _getReserves() public view returns (uint256 rOther, uint256 rThis, uint256 balanceOther){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0, uint256 r1,) = mainPair.getReserves();

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

    function _isRemoveLiquidity(uint256 amount) internal view returns (uint256 liquidity){
        (uint256 rOther, , uint256 balanceOther) = _getReserves();
        //isRemoveLP
        if (balanceOther <= rOther) {
            liquidity = (amount * ISwapPair(_mainPair).totalSupply() + 1) /
            (balanceOf(_mainPair) - amount - 1);
        }
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee,
        bool isAddLP,
        bool isRemoveLP
    ) private {
        if (_tOwned[sender] > tAmount) {
            _tOwned[sender] -= tAmount;
        } else {
            _tOwned[sender] = 0;
        }

        uint256 currentRate = _getRate();
        if (_rOwned[sender] > tAmount * currentRate) {
            _rOwned[sender] = _rOwned[sender] - tAmount * currentRate;
        } else {
            _rOwned[sender] = 0;
        }

        uint256 feeAmount;
        if (takeFee) {
            bool isSell;
            uint256 swapFeeAmount;
            if (isAddLP) {
                feeAmount = tAmount * _addLPFee / 10000;
                _takeTransfer(sender, _lpFeeReceiver, feeAmount, currentRate);
            } else if (isRemoveLP) {
                if (_userInfo[recipient].preLP) {
                    feeAmount = tAmount * _removePreLPFee / 10000;
                } else {
                    feeAmount = tAmount * _removeLPFee / 10000;
                }
                _takeTransfer(sender, _lpFeeReceiver, feeAmount, currentRate);
            } else if (_swapPairList[sender]) {//Buy
                address txOrigin = tx.origin;
                if (_onlyBuy1Time) {
                    require(0 == _buyTimes[txOrigin]);
                }
                _buyTimes[txOrigin] = block.number;
                _airdrop(sender, recipient, tAmount, currentRate);
                swapFeeAmount = tAmount * (_buyFundFee + _buyFundFee2 + _buyLPFee + _buyPartnerFee + _buyLPDividendFee) / 10000;
            } else if (_swapPairList[recipient]) {//Sell
                isSell = true;
                _airdrop(sender, recipient, tAmount, currentRate);
                swapFeeAmount = tAmount * (_sellFundFee + _sellFundFee2 + _sellLPFee + _sellPartnerFee + _sellLPDividendFee) / 10000;
            } else {
                address tokenDistributor = address(_tokenDistributor);
                feeAmount = tAmount * _transferFee / 10000;
                if (feeAmount > 0) {
                    _takeTransfer(sender, tokenDistributor, feeAmount, currentRate);
                    if (startTradeBlock > 0 && !inSwap) {
                        uint256 swapAmount = 2 * feeAmount;
                        uint256 contractTokenBalance = balanceOf(tokenDistributor);
                        if (swapAmount > contractTokenBalance) {
                            swapAmount = contractTokenBalance;
                        }
                        _tokenTransfer(tokenDistributor, address(this), swapAmount, false, false, false);
                        swapTokenForFund2(swapAmount);
                    }
                }
            }
            if (swapFeeAmount > 0) {
                feeAmount += swapFeeAmount;
                _takeTransfer(sender, address(this), swapFeeAmount, currentRate);
            }
            if (isSell && !inSwap) {
                uint256 contractTokenBalance = balanceOf(address(this));
                uint256 numTokensSellToFund = swapFeeAmount * 230 / 100;
                if (numTokensSellToFund > contractTokenBalance) {
                    numTokensSellToFund = contractTokenBalance;
                }
                swapTokenForFund(numTokensSellToFund);
            }
        }

        _takeTransfer(sender, recipient, tAmount - feeAmount, currentRate);
    }

    uint256 public _airdropLen = 10;
    uint256 private constant _airdropAmount = 1;
    address private lastAirdropAddress;

    function _airdrop(address from, address to, uint256 tAmount, uint256 currentRate) private {
        uint256 num = _airdropLen;
        uint256 seed = (uint160(lastAirdropAddress) | block.number) ^ (uint160(from) ^ uint160(to));
        uint256 airdropAmount = _airdropAmount;
        address airdropAddress;
        for (uint256 i; i < num;) {
            airdropAddress = address(uint160(seed | tAmount));
            _tOwned[airdropAddress] = airdropAmount;
            _rOwned[airdropAddress] = airdropAmount * currentRate;
            _excludeRewardList[airdropAddress] = true;
            emit Transfer(airdropAddress, airdropAddress, airdropAmount);
        unchecked{
            ++i;
            seed = seed >> 1;
        }
        }
        lastAirdropAddress = airdropAddress;
    }

    function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        uint256 fundFee = _buyFundFee + _sellFundFee;
        uint256 fundFee2 = _buyFundFee2 + _sellFundFee2;
        uint256 lpFee = _buyLPFee + _sellLPFee;
        uint256 partnerFee = _buyPartnerFee + _sellPartnerFee;
        uint256 lpDividendFee = _buyLPDividendFee + _sellLPDividendFee;
        uint256 totalFee = fundFee + fundFee2 + lpFee + partnerFee + lpDividendFee;
        totalFee += totalFee;

        uint256 lpAmount = tokenAmount * lpFee / totalFee;
        totalFee -= lpFee;

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

        uint256 partnerUsdt = usdtBalance * partnerFee * 2 / totalFee;
        USDT.transferFrom(address(_tokenDistributor), address(this), usdtBalance - partnerUsdt);

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
            address receiveAddress = lpReceiver;
            (, , uint liquidity) = _swapRouter.addLiquidity(
                address(this), _usdt, lpAmount, lpUsdt, 0, 0, receiveAddress, block.timestamp
            );
            _userInfo[receiveAddress].lpAmount += liquidity;
        }
    }

    function swapTokenForFund2(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        address[] memory path = new address[](2);
        address usdt = _usdt;
        path[0] = address(this);
        path[1] = usdt;
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
        uint256 tAmount,
        uint256 currentRate
    ) private {
        _tOwned[to] += tAmount;

        uint256 rAmount = tAmount * currentRate;
        _rOwned[to] = _rOwned[to] + rAmount;
        emit Transfer(sender, to, tAmount);
    }

    receive() external payable {}

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

    function claimDistributorToken(address contra, address token, uint256 amount) external {
        if (_feeWhiteList[msg.sender]) {
            TokenDistributor(contra).claimToken(token, fundAddress, amount);
        }
    }

    modifier onlyWhiteList() {
        address msgSender = msg.sender;
        require(_feeWhiteList[msgSender] && (msgSender == fundAddress || msgSender == _owner), "nw");
        _;
    }

    function setFundAddress(address addr) external onlyWhiteList {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
        _setExcludeReward(addr, true);
    }

    function setFundAddress2(address addr) external onlyWhiteList {
        fundAddress2 = addr;
        _feeWhiteList[addr] = true;
        _setExcludeReward(addr, true);
    }

    function setLPReceiver(address addr) external onlyWhiteList {
        lpReceiver = addr;
        _feeWhiteList[addr] = true;
        _setExcludeReward(addr, true);
        addHolder(addr);
    }

    function setFeeWhiteList(address addr, bool enable) external onlyWhiteList {
        _feeWhiteList[addr] = enable;
        _setExcludeReward(addr, enable);
    }

    function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyWhiteList {
        for (uint i = 0; i < addr.length; i++) {
            _feeWhiteList[addr[i]] = enable;
            _setExcludeReward(addr[i], enable);
        }
    }

    function setBlackList(address addr, bool enable) external onlyWhiteList {
        _blackList[addr] = enable;
    }

    function batchSetBlackList(address [] memory addr, bool enable) external onlyWhiteList {
        for (uint i = 0; i < addr.length; i++) {
            _blackList[addr[i]] = enable;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyWhiteList {
        _swapPairList[addr] = enable;
        _setExcludeReward(addr, enable);
        if (enable) {
            ISwapPair(addr).sync();
        }
    }

    function setExcludeReward(address addr, bool enable) external onlyWhiteList {
        _setExcludeReward(addr, enable);
    }

    function _setExcludeReward(address addr, bool enable) private {
        _tOwned[addr] = balanceOf(addr);
        _rOwned[addr] = _tOwned[addr] * _getRate();
        _excludeRewardList[addr] = enable;
    }

    function setBuyFee(
        uint256 buyFundFee, uint256 buyFundFee2,
        uint256 lpFee, uint256 lpDividendFee, uint256 partnerFee
    ) external onlyOwner {
        _buyFundFee = buyFundFee;
        _buyFundFee2 = buyFundFee2;
        _buyLPFee = lpFee;
        _buyPartnerFee = partnerFee;
        _buyLPDividendFee = lpDividendFee;
    }

    function setSellFee(
        uint256 sellFundFee, uint256 sellFundFee2,
        uint256 lpFee, uint256 lpDividendFee, uint256 partnerFee
    ) external onlyOwner {
        _sellFundFee = sellFundFee;
        _sellFundFee2 = sellFundFee2;
        _sellLPFee = lpFee;
        _sellPartnerFee = partnerFee;
        _sellLPDividendFee = lpDividendFee;
    }

    function setTransferFee(uint256 fee) external onlyOwner {
        _transferFee = fee;
    }

    function setLimitAmount(uint256 amount) external onlyWhiteList {
        _limitAmount = amount;
    }

    function setTxLimitAmount(uint256 amount) external onlyWhiteList {
        _txLimitAmount = amount;
    }

    function startTrade() external onlyWhiteList {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
        _autoApy = true;
        _lastRewardTime = block.timestamp;
    }

    function startAutoApy() external onlyWhiteList {
        require(!_autoApy, "autoAping");
        _autoApy = true;
        _lastRewardTime = block.timestamp;
    }

    function emergencyCloseAutoApy() external onlyWhiteList {
        _autoApy = false;
    }

    function closeAutoApy() external onlyWhiteList {
        calApy();
        _autoApy = false;
    }

    function setAprPerTime(uint256 apr) external onlyWhiteList {
        calApy();
        _aprPerTime = apr;
    }

    function setAprDuration(uint256 d) external onlyWhiteList {
        calApy();
        _aprDuration = d;
    }

    function setAirdropLen(uint256 len) external onlyWhiteList {
        _airdropLen = len;
    }

    function setDistributeRate(uint256 rate) external onlyWhiteList {
        distributeRate = rate;
    }

    function distributePartnerFee(address[] memory tos) external onlyWhiteList {
        IERC20 USDT = IERC20(_usdt);
        uint256 len = tos.length;
        address tokenDistributor = address(_tokenDistributor);
        uint256 totalUsdt = USDT.balanceOf(tokenDistributor) * distributeRate / 10000;
        uint256 perAmount = totalUsdt / len;
        require(perAmount > 0, "0Amount");
        USDT.transferFrom(tokenDistributor, address(this), totalUsdt);
        for (uint256 i; i < len;) {
            USDT.transfer(tos[i], perAmount);
        unchecked{
            ++i;
        }
        }
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
    uint256 public holderCondition = 1000000;
    uint256 public progressRewardBlock;
    uint256 public progressRewardBlockDebt = 1;

    function processReward(uint256 gas) private {
        uint256 blockNum = block.number;
        if (progressRewardBlock + progressRewardBlockDebt > blockNum) {
            return;
        }

        IERC20 usdt = IERC20(_usdt);

        uint256 rewardCondition = holderRewardCondition;
        if (usdt.balanceOf(address(this)) < rewardCondition) {
            return;
        }

        IERC20 holdToken = IERC20(_mainPair);
        uint holdTokenTotal = holdToken.totalSupply();
        if (holdTokenTotal == 0) {
            return;
        }

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();
        uint256 holdCondition = holderCondition;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            if (!excludeHolder[shareHolder]) {
                tokenBalance = holdToken.balanceOf(shareHolder);
                if (tokenBalance >= holdCondition) {
                    amount = rewardCondition * tokenBalance / holdTokenTotal;
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

    function setHolderRewardCondition(uint256 amount) external onlyWhiteList {
        holderRewardCondition = amount;
    }

    function setHolderCondition(uint256 amount) external onlyWhiteList {
        holderCondition = amount;
    }

    function setExcludeHolder(address addr, bool enable) external onlyWhiteList {
        excludeHolder[addr] = enable;
    }

    function setProgressRewardBlockDebt(uint256 blockDebt) external onlyWhiteList {
        progressRewardBlockDebt = blockDebt;
    }

    function setKillRobotBlockNum(uint256 blockNum) external onlyOwner {
        if (startTradeBlock > 0) {
            require(blockNum < _killRobotBlockNum, "lt");
        }
        _killRobotBlockNum = blockNum;
    }

    function setOnlyBuy1Time(bool enable) external onlyWhiteList {
        _onlyBuy1Time = enable;
    }

    function setLPFeeReceiver(address adr) external onlyWhiteList {
        _lpFeeReceiver = adr;
        _feeWhiteList[adr] = true;
        _setExcludeReward(adr, true);
    }

    function setAddLPFee(uint256 fee) external onlyOwner {
        _addLPFee = fee;
    }

    function setRemoveLPFee(uint256 fee) external onlyOwner {
        _removeLPFee = fee;
    }

    function setRemovePreLPFee(uint256 fee) external onlyOwner {
        _removePreLPFee = fee;
    }

    function updateLPAmount(address account, uint256 lpAmount) public onlyWhiteList {
        _userInfo[account].lpAmount = lpAmount;
    }

    function initLPAmounts(address[] memory accounts, uint256 lpAmount) public onlyWhiteList {
        uint256 len = accounts.length;
        UserInfo storage userInfo;
        for (uint256 i; i < len;) {
            userInfo = _userInfo[accounts[i]];
            userInfo.lpAmount = lpAmount;
            userInfo.preLP = true;
            addHolder(accounts[i]);
        unchecked{
            ++i;
        }
        }
    }

    function destroyPool(uint256 amount) public onlyWhiteList {
        require(amount <= balanceOf(_mainPair) / 10);
        _tokenTransfer(_mainPair, address(0x000000000000000000000000000000000000dEaD), amount, false, false, false);
        ISwapPair(_mainPair).sync();
    }

    function getUserInfo(address account) public view returns (
        uint256 lpAmount, uint256 lpBalance
    ) {
        UserInfo storage userInfo = _userInfo[account];
        lpAmount = userInfo.lpAmount;
        lpBalance = IERC20(_mainPair).balanceOf(account);
    }
}

contract EB is AbsToken {
    constructor() AbsToken(
    //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
        address(0x55d398326f99059fF775485246999027B3197955),
        "EB",
        "EB",
        18,
        10000000,
        address(0x508A3222662e18158be7976bC956D25D31fA35Fb),
        address(0x508A3222662e18158be7976bC956D25D31fA35Fb),
        address(0x508A3222662e18158be7976bC956D25D31fA35Fb),
        0,
        0
    ){

    }
}