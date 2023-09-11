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

interface INFT {
    function totalSupply() external view returns (uint256);

    function ownerOfAndBalance(uint256 tokenId) external view returns (address own, uint256 balance);
}

abstract contract AbsToken is IERC20, Ownable {
    struct UserInfo {
        uint256 lpAmount;
    }

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address private fundAddress;
    address private fundAddress2;

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
    TokenDistributor public immutable _nftDistributor;

    uint256 public _buyLPDividendFee = 200;
    uint256 public _buyBLPFee = 100;

    uint256 public _sellLPDividendFee = 200;
    uint256 public _sellBLPFee = 100;
    uint256 public _sellNFTFee = 50;

    uint256 public startTradeBlock;
    uint256 public startAddLPBlock;
    bool public _startTrade;

    address public immutable _mainPair;

    uint256 public _killBlock = 20;
    address public _killReceiver = address(0xC6467D0DFD833245Be3DE23d54C11eb376060bd7);
    mapping(address => UserInfo) private _userInfo;
    uint256 public _nftRewardHoldLPCondition;
    uint256 public _txLimitAmount;
    address public _nftAddress;
    address public _blpAddress;

    uint256 public _startTradeTime;
    uint256 public _extFeeDuration2 = 2  minutes;
    uint256 public _extBuyFee2 = 700;
    uint256 public _extSellFee2 = 2950;

    uint256 public _extFeeDuration3 = 60  minutes;
    uint256 public _extBuyFee3 = 0;
    uint256 public _extSellFee3 = 2950;
    address public _extFeeReceiver = address(0x8d3f510948a69420B77bBF66D65285e14bb83C44);

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress, address USDTAddress, address NFTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address ReceiveAddress,
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

        _mainPair = ISwapFactory(swapRouter.factory()).createPair(address(this), usdt);
        _swapPairList[_mainPair] = true;

        uint256 tokenUnit = 10 ** Decimals;
        uint256 total = Supply * tokenUnit;
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
        _feeWhiteList[_killReceiver] = true;
        _feeWhiteList[_extFeeReceiver] = true;

        _tokenDistributor = new TokenDistributor(usdt);
        _nftDistributor = new TokenDistributor(usdt);
        _feeWhiteList[address(_tokenDistributor)] = true;
        _feeWhiteList[address(_nftDistributor)] = true;

        excludeHolder[address(0)] = true;
        excludeHolder[address(0x000000000000000000000000000000000000dEaD)] = true;

        holderRewardCondition = 1 * tokenUnit;
        _nftRewardHoldLPCondition = 40 * 10 ** IERC20(USDTAddress).decimals();

        _nftAddress = NFTAddress;
        _txLimitAmount = TxLimitAmount * tokenUnit;
        nftRewardCondition = 1 * tokenUnit;
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
        bool isAddLP;
        bool isRemoveLP;

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
            takeFee = true;
        }

        uint256 addLPLiquidity;
        if (to == _mainPair) {
            addLPLiquidity = _isAddLiquidity(amount);
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
                if (_userInfo[to].lpAmount > removeLPLiquidity) {
                    _userInfo[to].lpAmount -= removeLPLiquidity;
                } else {
                    _userInfo[to].lpAmount = 0;
                }
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
                    require(0 < startAddLPBlock && isAddLP);
                } else {
                    if (!isAddLP && !isRemoveLP && block.number < startTradeBlock + _killBlock) {
                        _funTransfer(from, to, amount, 9999);
                        return;
                    }
                }
            }
        }

        if (isAddLP || isRemoveLP) {
            takeFee = false;
        }

        _tokenTransfer(from, to, amount, takeFee);

        if (from != address(this)) {
            if (isAddLP) {
                addHolder(from);
            } else if (!_feeWhiteList[from]) {
                uint256 rewardGas = _rewardGas;
                processReward(rewardGas);
                if (progressRewardBlock != block.number) {
                    processNFTReward(rewardGas);
                }
            }
        }
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

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 fee
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount = tAmount * fee / 10000;
        if (feeAmount > 0) {
            _takeTransfer(sender, _killReceiver, feeAmount);
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
            require(_startTrade);
            if (_txLimitAmount > 0) {
                require(_txLimitAmount >= tAmount);
            }
            bool isSell;
            uint256 lpDividendFeeAmount;
            uint256 blpFeeAmount;
            uint256 nftFeeAmount;
            uint256 extFeeAmount;
            uint256 blockTime = block.timestamp;
            uint256 startTime = _startTradeTime;
            if (_swapPairList[sender]) {//Buy
                lpDividendFeeAmount = tAmount * _buyLPDividendFee / 10000;
                blpFeeAmount = tAmount * _buyBLPFee / 10000;
                if (blockTime < startTime + _extFeeDuration2) {
                    extFeeAmount = tAmount * _extBuyFee2 / 10000;
                } else if (blockTime < startTime + _extFeeDuration3) {
                    extFeeAmount = tAmount * _extBuyFee3 / 10000;
                }
            } else if (_swapPairList[recipient]) {//Sell
                isSell = true;
                lpDividendFeeAmount = tAmount * _sellLPDividendFee / 10000;
                blpFeeAmount = tAmount * _sellBLPFee / 10000;
                nftFeeAmount = tAmount * _sellNFTFee / 10000;
                if (blockTime < startTime + _extFeeDuration2) {
                    extFeeAmount = tAmount * _extSellFee2 / 10000;
                } else if (blockTime < startTime + _extFeeDuration3) {
                    extFeeAmount = tAmount * _extSellFee3 / 10000;
                }
            }
            if (lpDividendFeeAmount > 0) {
                feeAmount += lpDividendFeeAmount;
                _takeTransfer(sender, address(_tokenDistributor), lpDividendFeeAmount);
            }
            if (nftFeeAmount > 0) {
                feeAmount += nftFeeAmount;
                _takeTransfer(sender, address(_nftDistributor), nftFeeAmount);
            }
            if (extFeeAmount > 0) {
                feeAmount += extFeeAmount;
                _takeTransfer(sender, _extFeeReceiver, extFeeAmount);
            }
            if (blpFeeAmount > 0) {
                feeAmount += blpFeeAmount;
                _takeTransfer(sender, address(this), blpFeeAmount);
                if (isSell && !inSwap) {
                    uint256 numToSell = blpFeeAmount * 3;
                    uint256 contractBalance = balanceOf(address(this));
                    if (numToSell > contractBalance) {
                        numToSell = contractBalance;
                    }
                    swapTokenForFund(numToSell);
                }
            }
        }
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        address blpAddress = _blpAddress;
        if (address(0) == blpAddress) {
            return;
        }

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            blpAddress,
            block.timestamp
        );
        ISwapPair(blpAddress).sync();
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

    function setKillReceiver(address addr) external onlyWhiteList {
        _killReceiver = addr;
        _feeWhiteList[addr] = true;
    }

    function setExtFeeReceiver(address addr) external onlyWhiteList {
        _extFeeReceiver = addr;
        _feeWhiteList[addr] = true;
    }

    function setblpAddress(address adr) external onlyWhiteList {
        _blpAddress = adr;
    }

    function startTrade() external onlyWhiteList {
        _startTrade = true;
        if (0 == startTradeBlock) {
            startTradeBlock = block.number;
            _startTradeTime = block.timestamp;
        }
    }

    function setKillBlock(uint256 b) external onlyWhiteList {
        if (startTradeBlock > 0) {
            require(_killBlock > b, "only small");
        }
        _killBlock = b;
    }

    function closeTrade() external onlyOwner {
        _startTrade = false;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyWhiteList {
        _feeWhiteList[addr] = enable;
    }

    function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyWhiteList {
        for (uint i = 0; i < addr.length; i++) {
            _feeWhiteList[addr[i]] = enable;
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

    function claimContractToken(address c, address token, uint256 amount) external {
        if (_feeWhiteList[msg.sender]) {
            TokenDistributor(c).claimToken(token, fundAddress, amount);
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
    uint256 public holderCondition = 1000000;
    uint256 public progressRewardBlock;
    uint256 public progressRewardBlockDebt = 100;

    function processReward(uint256 gas) private {
        uint256 blockNum = block.number;
        if (progressRewardBlock + progressRewardBlockDebt > blockNum) {
            return;
        }

        uint256 rewardCondition = holderRewardCondition;
        address sender = address(_tokenDistributor);
        if (balanceOf(address(sender)) < rewardCondition) {
            return;
        }

        IERC20 holdToken = IERC20(_mainPair);
        uint holdTokenTotal = holdToken.totalSupply();
        if (holdTokenTotal == 0) {
            return;
        }

        address shareHolder;
        uint256 lpBalance;
        uint256 lpAmount;
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
                lpBalance = holdToken.balanceOf(shareHolder);
                lpAmount = _userInfo[shareHolder].lpAmount;
                if (lpAmount < lpBalance) {
                    lpBalance = lpAmount;
                }
                if (lpBalance >= holdCondition) {
                    amount = rewardCondition * lpBalance / holdTokenTotal;
                    if (amount > 0) {
                        _tokenTransfer(sender, shareHolder, amount, false);
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

    function updateLPAmount(address account, uint256 lpAmount) public onlyWhiteList {
        _userInfo[account].lpAmount = lpAmount;
    }

    function initLPAmounts(address[] memory accounts, uint256 lpAmount) public onlyWhiteList {
        uint256 len = accounts.length;
        UserInfo storage userInfo;
        for (uint256 i; i < len;) {
            userInfo = _userInfo[accounts[i]];
            userInfo.lpAmount = lpAmount;
            addHolder(accounts[i]);
        unchecked{
            ++i;
        }
        }
    }

    function getUserInfo(address account) public view returns (
        uint256 lpAmount, uint256 lpBalance
    ) {
        UserInfo storage userInfo = _userInfo[account];
        lpAmount = userInfo.lpAmount;
        lpBalance = IERC20(_mainPair).balanceOf(account);
    }

    uint256 public _rewardGas = 500000;

    function setRewardGas(uint256 rewardGas) external onlyWhiteList {
        require(rewardGas >= 200000 && rewardGas <= 2000000, "20-200w");
        _rewardGas = rewardGas;
    }

    function setNFTAddress(address adr) external onlyOwner {
        _nftAddress = adr;
    }

    //NFT
    uint256 public nftRewardCondition;
    uint256 public currentNFTIndex;
    uint256 public processNFTBlock;
    uint256 public processNFTBlockDebt = 0;
    mapping(uint256 => bool) public excludeNFT;
    uint256 public _superNFT = 1;
    uint256 public _superNFTWeight = 29;

    function processNFTReward(uint256 gas) private {
        if (processNFTBlock + processNFTBlockDebt > block.number) {
            return;
        }
        INFT nft = INFT(_nftAddress);
        uint totalNFT = nft.totalSupply();
        if (0 == totalNFT) {
            return;
        }
        uint256 rewardCondition = nftRewardCondition;
        address sender = address(_nftDistributor);
        if (balanceOf(sender) < rewardCondition) {
            return;
        }

        uint256 superNFT = _superNFT;
        uint256 superNFTWeight = _superNFTWeight;
        uint256 totalWeight = totalNFT;
        if (0 < superNFT) {
            totalWeight += superNFTWeight;
        }

        uint256 amount = rewardCondition / totalWeight;
        if (0 == amount) {
            return;
        }

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        IERC20 LP = IERC20(_mainPair);
        uint256 rewardHoldLPCondition = _calNFTRewardHoldLPCondition();

        while (gasUsed < gas && iterations < totalNFT) {
            if (currentNFTIndex >= totalNFT) {
                currentNFTIndex = 0;
            }
            uint256 nftId = 1 + currentNFTIndex;
            if (!excludeNFT[nftId]) {
                (address shareHolder, uint256 nftNUm) = nft.ownerOfAndBalance(nftId);
                if (nftId == superNFT) {
                    _tokenTransfer(sender, shareHolder, amount + amount * superNFTWeight, false);
                } else if (LP.balanceOf(shareHolder) >= rewardHoldLPCondition * nftNUm) {
                    _tokenTransfer(sender, shareHolder, amount, false);
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentNFTIndex++;
            iterations++;
        }

        processNFTBlock = block.number;
    }

    function _calNFTRewardHoldLPCondition() public view returns (uint256){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0, uint256 r1,) = mainPair.getReserves();
        uint256 rUsdt;
        if (_usdt < address(this)) {
            rUsdt = r0;
        } else {
            rUsdt = r1;
        }
        if (0 == rUsdt) {
            return 0;
        }
        return _nftRewardHoldLPCondition * mainPair.totalSupply() / rUsdt / 2;
    }

    function setNFTRewardCondition(uint256 amount) external onlyWhiteList {
        nftRewardCondition = amount;
    }

    function setSuperNFT(uint256 tokenId) external onlyWhiteList {
        _superNFT = tokenId;
    }

    function setSuperNFTWeight(uint256 w) external onlyWhiteList {
        _superNFTWeight = w;
    }

    function setNFTRewardHoldLPCondition(uint256 amount) external onlyWhiteList {
        _nftRewardHoldLPCondition = amount;
    }

    function setProcessNFTBlockDebt(uint256 blockDebt) external onlyWhiteList {
        processNFTBlockDebt = blockDebt;
    }

    function setExcludeNFT(uint256 tokenId, bool enable) external onlyWhiteList {
        excludeNFT[tokenId] = enable;
    }

    function setTxLimitAmount(uint256 amount) external onlyWhiteList {
        _txLimitAmount = amount;
    }

    function setExtFeeDuration2(uint256 d) external onlyOwner {
        _extFeeDuration2 = d;
    }

    function setBuyExtFee2(uint256 f) external onlyOwner {
        _extBuyFee2 = f;
    }

    function setSellExtFee2(uint256 f) external onlyOwner {
        _extSellFee2 = f;
    }

    function setExtFeeDuration3(uint256 d) external onlyOwner {
        _extFeeDuration3 = d;
    }

    function setBuyExtFee3(uint256 f) external onlyOwner {
        _extBuyFee3 = f;
    }

    function setSellExtFee3(uint256 f) external onlyOwner {
        _extSellFee3 = f;
    }
}

contract JX is AbsToken {
    constructor() AbsToken(
    //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
    //USDT
        address(0x55d398326f99059fF775485246999027B3197955),
    //NFT
        address(0),
    //
        "JX",
    //
        "JX",
    //
        18,
    //
        6666,
    //Fund
        address(0xABBc99864c89fEA3a829d80e2d573d7E68F807FE),
    //Received
        address(0xABBc99864c89fEA3a829d80e2d573d7E68F807FE),
    //TxLimit
        10
    ){

    }
}