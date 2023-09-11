// Website: www.feitian.site

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;
pragma experimental ABIEncoderV2;


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
 
library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {return payable(msg.sender);}
    function _msgData() internal view virtual returns (bytes memory) {return msg.data;}
}

contract Ownable is Context {
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

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

   
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }


    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
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
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
}

interface IUniswapV2Pair {
    function token0() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface IDividendDistributor {
    function setShare(address shareholder) external;
    function process(uint256 gas) external;
    function addUsdtAmount(uint256[2] calldata amounts) external;
}

interface ITradingContest {
    function buyTokens(address user, uint256 amount) external;
    function addUsdtAmount(uint256 amount) external;
}

interface IRewardVault {
    function rewardTo(address to, uint amount) external;
}

contract RewardVault is Ownable {
    address public rewardToken;

    constructor(address _rewardToken) {
        rewardToken = _rewardToken;
    }

    receive() external payable {}

    function rewardTo(address to, uint amount) external onlyOwner {
        if (IERC20(rewardToken).balanceOf(address(this)) < amount) return;
        IERC20(rewardToken).transfer(to, amount);
    }
}

contract FT is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;
    mapping(address => bool) public ammPairs;

    mapping(address => bool) private _updated;
    mapping (address => uint256) public _shareBlock;

    mapping (address => address) public _inviter;
    mapping (address => mapping (address => bool)) public _hasAirdroped;
   
    uint8 private _decimals = 18;
    uint256 private _tTotal;
    uint256 public supply = 10000000 * (10 ** 8) * (10 ** 18);

    string private _name = "FeiTian";
    string private _symbol = "FT";

    uint256 buyMarketFee = 100;
    uint256 buyBuyBackFee = 50;
    uint256 buyBuyPEQIFee = 0;
    uint256 buyTechnologyFee = 50;
    uint256 buyLpFee = 0;
    uint256 buyNftFee = 0;
    uint256 buyTradingFee = 0;

    uint256 sellMarketFee = 100;
    uint256 sellBuyBackFee = 50;
    uint256 sellBuyPEQIFee = 0;
    uint256 sellTechnologyFee = 50;
    uint256 sellLpFee = 100;
    uint256 sellNftFee = 100;
    uint256 sellTradingFee = 100;
    uint256 sellTechnologyFeeAccumulate = 50;
    uint256 sellBuyBackFeeAccumulate = 50;
    uint256 sellBuyPEQIFeeAccumulate = 100;
    uint256 sellLpFeeAccumulate = 600;
    uint256 sellTradingFeeAccumulate = 700;

    uint256 buyFee = 200;
    uint256 sellFee = 500;
    uint256 feeUnit = 10000;

    uint256 marketAmount;
    uint256 buyBackAmount;
    uint256 buyPEQIAmount;
    uint256 technologyAmount;
    uint256 lpAmount;
    uint256 nftAmount;
    uint256 tradingAmount;
    uint256 totalAmount;
    
    IUniswapV2Router02 public uniswapV2Router;

    IERC20 public uniswapV2Pair;
    address public wbnb;
    address constant rootAddress = address(0x000000000000000000000000000000000000dEaD);
    
    address distributorAddress;
    address tradingContestAddress;
    address public rewardValut;
    address router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address usdt = 0x55d398326f99059fF775485246999027B3197955;

    address public initPoolAddress = 0xEA41C25ECf1c89b60F53ccd7677D5B183cb397fB;
    address public initOwner = 0x4dCf8F33575635d218eB9Dc38a0eEe31a90f69C5;
    address public marketAddress = 0x2E7120Db19B0361ed8B0d03c4971D86B3e1a786A;
    address public buyBackAddress = 0x82B43FC6DB9366a05CA26A3A5FD42eb4143DC9E0;
    address public buyPEQIAddress = 0x2Ee8137855908e0938eC9279981Add9C7f681162;
    address public technologyAddress = 0xCd21b3db1d9a75Dc3C63bDE4b28bab9e78faBe05;

    bool public tradingContestOpen = true;

    mapping (uint256 => uint256) tradingCount;
    uint256 tradingAmountLimit = 1000 * (10 ** 8) * (10 ** 18);
    uint256 tradingCountLimit = 8;
    uint256 addTradingLimit = 1000 * (10 ** 8) * (10 ** 18);

    bool openTransaction;
    uint256 launchedBlock;
    uint256 private firstBlock = 6;
    uint256 private secondBlock = 20;
    uint256 private thirdBlock = 20;

    address private fromAddress;
    address private toAddress;

    uint256 transitionUnit = 10 ** 36;
    uint256 public interval = 24 * 60 * 60;
    uint256 public protectionT = 1687449600;
    uint256 public protectionP;
    uint256 public protectionR = 4;
    bool public isProtection = true;

    uint256 public inviteCondition = 1000 * (10 ** 4) * (10 ** 18);

    uint256 distributorGas = 500000;
    bool public swapEnabled = true;
    uint256 public swapThreshold = supply / 10000;
    bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }
    
    constructor () {
        rewardValut = address(new RewardVault(address(this)));

        _tTotal = supply;
        
        _isExcludedFromFee[initOwner] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[rewardValut] = true;
        _isExcludedFromFee[rootAddress] = true;
        _isExcludedFromFee[initPoolAddress] = true;
        _isExcludedFromFee[marketAddress] = true;
        _isExcludedFromFee[buyBackAddress] = true;
        _isExcludedFromFee[buyPEQIAddress] = true;
        _isExcludedFromFee[technologyAddress] = true;

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
        uniswapV2Router = _uniswapV2Router;

        address bnbPair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        wbnb = _uniswapV2Router.WETH();

        uniswapV2Pair = IERC20(bnbPair);
        ammPairs[bnbPair] = true;

        _tOwned[initOwner] = 9000000 * (10 ** 8) * (10 ** 18);
        _tOwned[rewardValut] = 1000000 * (10 ** 8) * (10 ** 18);

        emit Transfer(address(0), initOwner, 9000000 * (10 ** 8) * (10 ** 18));
        emit Transfer(address(0), rewardValut, 1000000 * (10 ** 8) * (10 ** 18));
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    
    receive() external payable {}

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function getFee(address from, uint256 currentP) public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256) {
        if (ammPairs[from] == true) {
            return (buyMarketFee,buyBuyBackFee,buyBuyPEQIFee,buyTechnologyFee,buyLpFee,buyNftFee,buyTradingFee,buyFee);
        } else {
            uint256 _sellTechnologyFee = sellTechnologyFee;
            uint256 _sellBuyBackFee = sellBuyBackFee;
            uint256 _sellBuyPEQIFee = sellBuyPEQIFee;
            uint256 _sellLpFee = sellLpFee;
            uint256 _sellTradingFee = sellTradingFee;
            uint256 _sellFee = sellFee;
            if(currentP < protectionP.mul(100 - protectionR).div(100)){
                _sellTechnologyFee = _sellTechnologyFee.add(sellTechnologyFeeAccumulate);
                _sellBuyBackFee = _sellBuyBackFee.add(sellBuyBackFeeAccumulate);
                _sellBuyPEQIFee = _sellBuyPEQIFee.add(sellBuyPEQIFeeAccumulate);
                _sellLpFee = _sellLpFee.add(sellLpFeeAccumulate);
                _sellTradingFee = _sellTradingFee.add(sellTradingFeeAccumulate);
                _sellFee = sellFee.add(sellTechnologyFeeAccumulate).add(sellBuyBackFeeAccumulate).add(sellBuyPEQIFeeAccumulate).add(sellLpFeeAccumulate).add(sellTradingFeeAccumulate);
            }
            return (sellMarketFee,_sellBuyBackFee,_sellBuyPEQIFee,_sellTechnologyFee,_sellLpFee,sellNftFee,_sellTradingFee,_sellFee);
        }
    }

    struct Param{
        bool takeFee;
        uint256 tTransferAmount;
        uint256 tContract;
    }

     function _initParam(uint256 amount,Param memory param, address from, uint256 currentBlock) private {
        uint256 currentP = (IERC20(wbnb).balanceOf(address(uniswapV2Pair))).mul(transitionUnit).div(balanceOf(address(uniswapV2Pair)));
        if (currentP > protectionP) {
            protectionP = currentP;
        }
        (uint256 marketFee,uint256 buyBackFee,uint256 buyPEQIFee,uint256 technologyFee,uint256 lpFee,uint256 nftFee,,uint256 totalFee) = getFee(from, currentP);
        if (currentBlock - launchedBlock < firstBlock + 1) {
            param.tContract = amount * 9000 / feeUnit;
        } else if (currentBlock - launchedBlock < secondBlock + 1) {
            if (tradingCount[currentBlock] > tradingCountLimit) {
                param.tContract = amount * 9000 / feeUnit;
            }
        } else {
            param.tContract = amount * (totalFee) / feeUnit;
        }
        param.tTransferAmount = amount.sub(param.tContract);

        totalAmount = totalAmount.add(param.tContract);
        marketAmount = marketAmount.add(amount * (marketFee) / feeUnit);
        buyBackAmount = buyBackAmount.add(amount * (buyBackFee) / feeUnit);
        buyPEQIAmount = buyPEQIAmount.add(amount * (buyPEQIFee) / feeUnit);
        technologyAmount = technologyAmount.add(amount * (technologyFee) / feeUnit);
        lpAmount = lpAmount.add(amount * (lpFee) / feeUnit);
        nftAmount = nftAmount.add(amount * (nftFee) / feeUnit);
        tradingAmount = totalAmount.sub(marketAmount).sub(buyBackAmount).sub(buyPEQIAmount).sub(technologyAmount).sub(lpAmount).sub(nftAmount);
    }

    function _takeFee(Param memory param,address from) private {
        if( param.tContract > 0 ){
            _tOwned[address(this)] = _tOwned[address(this)].add(param.tContract);
            emit Transfer(from, address(this), param.tContract);
        }
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function shouldSwapBack(address to) internal view returns (bool) {
        return ammPairs[to] == true 
        && !inSwap
        && swapEnabled
        && balanceOf(address(this)) >= swapThreshold;
    }

    function swapBack() internal swapping {
        _allowances[address(this)][address(uniswapV2Router)] = swapThreshold;
        
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = wbnb;
        path[2] = usdt;
        uint256 balanceBefore = IERC20(usdt).balanceOf(address(this));

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapThreshold,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountUsdt = IERC20(usdt).balanceOf(address(this)).sub(balanceBefore);
        uint256 amountToMarket = amountUsdt.mul(marketAmount).div(totalAmount);
        uint256 amountToBuyBack = amountUsdt.mul(buyBackAmount).div(totalAmount);
        uint256 amountToBuyPEQI = amountUsdt.mul(buyPEQIAmount).div(totalAmount);
        uint256 amountToTechnology = amountUsdt.mul(technologyAmount).div(totalAmount);
        uint256 amountToLp = amountUsdt.mul(lpAmount).div(totalAmount);
        uint256 amountToNft = amountUsdt.mul(nftAmount).div(totalAmount);
        uint256 amountToDistributor = amountToLp.add(amountToNft);
        uint256 amountToTrading = amountUsdt.sub(amountToMarket).sub(amountToBuyBack).sub(amountToBuyPEQI);
        amountToTrading = amountToTrading.sub(amountToTechnology).sub(amountToDistributor);

        if (amountToMarket > 0) {
            IERC20(usdt).transfer(marketAddress, amountToMarket);
            marketAmount = marketAmount.sub(swapThreshold.mul(marketAmount).div(totalAmount));
        }
        if (amountToBuyBack > 0) {
            IERC20(usdt).transfer(buyBackAddress, amountToBuyBack);
            buyBackAmount = buyBackAmount.sub(swapThreshold.mul(buyBackAmount).div(totalAmount));
        }
        if (amountToBuyPEQI > 0) {
            IERC20(usdt).transfer(buyPEQIAddress, amountToBuyPEQI);
            buyPEQIAmount = buyPEQIAmount.sub(swapThreshold.mul(buyPEQIAmount).div(totalAmount));
        }
        if (amountToTechnology > 0) {
            IERC20(usdt).transfer(technologyAddress, amountToTechnology);
            technologyAmount = technologyAmount.sub(swapThreshold.mul(technologyAmount).div(totalAmount));
        }
        if (amountToDistributor > 0) {
            IERC20(usdt).transfer(distributorAddress, amountToDistributor);
            lpAmount = lpAmount.sub(swapThreshold.mul(lpAmount).div(totalAmount));
            nftAmount = nftAmount.sub(swapThreshold.mul(nftAmount).div(totalAmount));
        }
        if (amountToTrading > 0) {
            IERC20(usdt).transfer(tradingContestAddress, amountToTrading);
            if (tradingContestOpen == true) {
                ITradingContest(tradingContestAddress).addUsdtAmount(amountToTrading);
            }
            tradingAmount = tradingAmount.sub(swapThreshold.mul(tradingAmount).div(totalAmount));
        }
        totalAmount = totalAmount.sub(swapThreshold);

        uint256[2] memory _amounts = [amountToLp, amountToNft];
        IDividendDistributor(distributorAddress).addUsdtAmount(_amounts);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 0, "ERC20: transfer amount must be greater than zero");

        if (!_isExcludedFromFee[from] && ammPairs[to] && !inSwap) {
            uint256 fromBalance = balanceOf(from).mul(99).div(100);
            if (fromBalance < amount) {
                amount = fromBalance;
            }
        }

        uint256 currentBlock = block.number;
        bool takeFee;
        Param memory param;
        param.tTransferAmount = amount;

        if( ammPairs[to] == true && IERC20(to).totalSupply() == 0 ){
            require(from == initPoolAddress,"Not allow init");
        }

        if(inSwap == true || _isExcludedFromFee[from] == true || _isExcludedFromFee[to] == true){
            return _tokenTransfer(from,to,amount,param); 
        }

        require(openTransaction == true,"Not allow");

        (, bool isRemoveLp) = judgeRemoveOrAddLp(from, to);
        if (ammPairs[from] == true && !isRemoveLp) {
            processBuyRewards(to, amount);
        }

        if (ammPairs[from] == true) {
            require(isContract(to) == false, "Contract limit");
            if (currentBlock - launchedBlock < secondBlock + 1) {
                tradingCount[currentBlock] = tradingCount[currentBlock] + 1;
                require(IERC20(usdt).balanceOf(to) > 0 , "Insufficient USDT");
            }
            if (currentBlock - launchedBlock < thirdBlock + 1) {
                require(amount <= tradingAmountLimit.add((currentBlock - launchedBlock).mul(addTradingLimit)), "Trading amount limit exceeded");
            }
        }

        if(ammPairs[to] == true || ammPairs[from] == true){
            takeFee = true;
        }

        if(shouldSwapBack(to)){ swapBack(); }

        if(isProtection == true && block.timestamp.sub(protectionT) >= interval){_resetProtection();}

        param.takeFee = takeFee;
        if( takeFee == true ){
            _initParam(amount, param, from, currentBlock);
        }
        
        _tokenTransfer(from,to,amount,param);

        if (from != address(uniswapV2Pair) && to != address(uniswapV2Pair)) {
            if (!_hasAirdroped[from][to] && amount >= inviteCondition) {
                _hasAirdroped[from][to] = true;

                if (_hasAirdroped[to][from] && _inviter[from] == address(0)) {
                    _inviter[from] = to;
                }
            }  
        }

        if (tradingContestOpen == true && ammPairs[from] == true && !isRemoveLp) {
            uint256 bnbAmount = amount.mul(IERC20(wbnb).balanceOf(address(uniswapV2Pair))).div(balanceOf(address(uniswapV2Pair)));
            ITradingContest(tradingContestAddress).buyTokens(to, bnbAmount);
        }

        if( address(uniswapV2Pair) != address(0) ){
            if (fromAddress == address(0)) fromAddress = from;
            if (toAddress == address(0)) toAddress = to;
            if ( !ammPairs[fromAddress] ) { try IDividendDistributor(distributorAddress).setShare(fromAddress) {} catch {} }
            if ( !ammPairs[toAddress] ) { try IDividendDistributor(distributorAddress).setShare(toAddress) {} catch {} }
            fromAddress = from;
            toAddress = to;

            if (
                from != address(this) 
                && IERC20(usdt).balanceOf(distributorAddress) > 0 
                && uniswapV2Pair.totalSupply() > 0 ) {

                try IDividendDistributor(distributorAddress).process(distributorGas) {} catch {}
            }
        }
    }

    function _tokenTransfer(address sender, address recipient, uint256 tAmount,Param memory param) private {
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _tOwned[recipient] = _tOwned[recipient].add(param.tTransferAmount);
        emit Transfer(sender, recipient, param.tTransferAmount);
        if(param.takeFee == true){
            _takeFee(param,sender);
        }
    }

    function processBuyRewards(address from, uint amount) private {
        if (_inviter[from] != address(0)) {
            IRewardVault(rewardValut).rewardTo(_inviter[from], amount * 2 / 100);
            if (_inviter[_inviter[from]] != address(0)) {
                IRewardVault(rewardValut).rewardTo(_inviter[_inviter[from]], amount * 3 / 100);
            }
        }
    }

    function judgeRemoveOrAddLp(address from, address to) private view returns (bool, bool) {
        address token0 = IUniswapV2Pair(address(uniswapV2Pair)).token0();
        (uint reserve0,,) = IUniswapV2Pair(address(uniswapV2Pair)).getReserves();
        uint balance0 = IERC20(token0).balanceOf(address(uniswapV2Pair));

        if (ammPairs[from] == true && reserve0 > balance0) { // remove
            return (false, true);
        }

        if (ammPairs[to] == true && reserve0 < balance0) { // add
            return (true, false);
        }
        return (false, false);
    }

    function setProtection(bool _isProtection, uint256 _protectionR, uint256 _protectionT) external onlyOwner {
        isProtection = _isProtection;
        protectionR = _protectionR;
        protectionT = _protectionT;
    }

    function resetProtection() external onlyOwner {
        protectionT = block.timestamp;
        protectionP = (IERC20(wbnb).balanceOf(address(uniswapV2Pair))).mul(transitionUnit).div(balanceOf(address(uniswapV2Pair)));
    }

    function _resetProtection() private {
        uint256 time = block.timestamp;
        if (time.sub(protectionT) >= interval) {
            protectionT = protectionT.add(interval);
            protectionP = (IERC20(wbnb).balanceOf(address(uniswapV2Pair))).mul(transitionUnit).div(balanceOf(address(uniswapV2Pair)));
        }
    }

    function setExcludeFromFee(address account, bool _isExclude) external onlyOwner {
        _isExcludedFromFee[account] = _isExclude;
    }

    function setOpenTransaction() external onlyOwner {
        require(openTransaction == false, "Already opened");
        openTransaction = true;
        launchedBlock = block.number;
    }

    function setAddress(address _marketAddress, address _buyBackAddress) external onlyOwner{
        marketAddress = _marketAddress;
        buyBackAddress = _buyBackAddress;
    }

    function setDistributorAddress(address _distributorAddress) external onlyOwner {
        distributorAddress = _distributorAddress;
    }

    function setTradingContestOpen(bool _tradingContestOpen) external {
        require(initOwner == address(msg.sender), "Not owner");
        tradingContestOpen = _tradingContestOpen;
    }

    function setTradingContestAddress(address _tradingContestAddress) external {
        require(initOwner == address(msg.sender), "Not owner");
        tradingContestAddress = _tradingContestAddress;
    }

    function setTradingLimit(uint256 _tradingAmountLimit, uint256 _tradingCountLimit, uint256 _addTradingLimit) external onlyOwner{
        tradingAmountLimit = _tradingAmountLimit;
        tradingCountLimit = _tradingCountLimit;
        addTradingLimit = _addTradingLimit;
    }

    function setInviteCondition(uint256 _inviteCondition) external onlyOwner {
        inviteCondition = _inviteCondition;
    }

    function setBlocks(uint256 _firstBlock, uint256 _secondBlock, uint256 _thirdBlock) external onlyOwner {
        firstBlock = _firstBlock;
        secondBlock = _secondBlock;
        thirdBlock = _thirdBlock;
    }

    function setAmmPair(address pair,bool hasPair) external onlyOwner {
        ammPairs[pair] = hasPair;
    }

    function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
        swapEnabled = _enabled;
        swapThreshold = _amount;
    }

}