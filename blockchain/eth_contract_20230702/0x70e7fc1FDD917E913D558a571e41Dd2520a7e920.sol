// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

/*

BIGCOCK is an innovative and dynamic ERC20 token that tracks and rewards its biggest buyer. 
The token's name continuously changes to reflect the address or ENS name 
(if the biggest buyer has one, else their public wallet adress will be used)

Do you have the biggest COCK on the market?




*/

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
    function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
    
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {if(b > a) return(false, 0); return(true, a - b);}}

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
        if(c / a != b) return(false, 0); return(true, c);}}

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {if(b == 0) return(false, 0); return(true, a / b);}}

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {if(b == 0) return(false, 0); return(true, a % b);}}

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked{require(b <= a, errorMessage); return a - b;}}

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked{require(b > 0, errorMessage); return a / b;}}

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked{require(b > 0, errorMessage); return a % b;}}}

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
    event Approval(address indexed owner, address indexed spender, uint256 value);}

    interface IENSResolver {
        function name(address addr) external view returns (string memory);
    }

abstract contract Ownable {
    address internal owner;
    constructor(address _owner) {owner = _owner;}
    modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
    function isOwner(address account) public view returns (bool) {return account == owner;}
    function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
    function renounceOwnership() public onlyOwner {owner = 0x000000000000000000000000000000000000dEaD; emit OwnershipTransferred(0x000000000000000000000000000000000000dEaD);}
    event OwnershipTransferred(address owner);
   
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

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

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
}

contract BIGCOCK is IERC20, Ownable {
    using SafeMath for uint256;
    string public _name = "The biggst cock has: Here could stand your ENS/Wallet adress";
    string public _symbol = "BIGCOCK";
    uint8 private constant _decimals = 9;
    uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
    uint256 private _maxTxAmountPercent = 150; // 10000;
    uint256 private _maxTransferPercent = 150;
    uint256 private _maxWalletPercent = 150;
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) public isExcludedFromFees;
    mapping (address => bool) private isBlacklisted;
    IRouter router;
    address public pair;
    bool private tradingLive = true;
    uint256 private liquidityFee = 0;
    uint256 private marketingFee = 0;
    uint256 private developmentFee = 25;
    uint256 private burnFee = 0;
    uint256 private totalFee = 20;
    uint256 private sellFee = 40;
    uint256 private transferFee = 100;
    uint256 private denominator = 100;
    bool private swapEnabled = true;
    uint256 private swapTimes;
    bool private swapping;
    uint256 swapAmount = 4;
    uint256 private swapThreshold = ( _totalSupply * 2000 ) / 100000;
    uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
    modifier lockTheSwap {swapping = true; _; swapping = false;}
    uint256 public largestPurchase;
    address public biggestBuyer;

    address private constant ENS_REGISTRY = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;

    address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address internal constant development_receiver = 0xC84b8f22d14282d63FbA681eD7A0977E1B0141C3; 
    address internal constant marketing_receiver = 0xC84b8f22d14282d63FbA681eD7A0977E1B0141C3;
    address internal constant liquidity_receiver = 0xC84b8f22d14282d63FbA681eD7A0977E1B0141C3;

    constructor() Ownable(msg.sender) {
        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
        router = _router;
        pair = _pair;
        isExcludedFromFees[address(this)] = true;
        isExcludedFromFees[liquidity_receiver] = true;
        isExcludedFromFees[marketing_receiver] = true;
        isExcludedFromFees[msg.sender] = true;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}
    function name() public view returns (string memory) {return _name;}
    function symbol() public view returns (string memory) {return _symbol;}
    function decimals() public pure returns (uint8) {return _decimals;}
    function getOwner() external view override returns (address) { return owner; }
    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
    function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
    function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
    function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
    function Blacklist(address _address, bool _enabled) external onlyOwner {isBlacklisted[_address] = _enabled;}
    function excludeFromFees(address _address, bool _enabled) external onlyOwner {isExcludedFromFees[_address] = _enabled;}
    function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
    function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
    function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
    function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
    function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
    function getBiggestBuyer() public view returns (address) {return biggestBuyer;}
    function getLargestPurchase() public view returns (address) {return biggestBuyer;}
    function preTxCheck(address sender, address recipient, uint256 amount) internal view {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > uint256(0), "Transfer amount must be greater than zero");
        require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
    }

   


    function updateTokenName() private {
        IENSResolver resolver = IENSResolver(ENS_REGISTRY);
        string memory ensName = resolver.name(biggestBuyer);
        if (bytes(ensName).length > 0) {
            _name = string(abi.encodePacked("The biggest cock has: ", ensName));
        } else {
            _name = string(abi.encodePacked("The biggest cock has: ", toAsciiString(biggestBuyer)));
        }
    }
     function toAsciiString(address x) private pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2 ** (8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) private pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        preTxCheck(sender, recipient, amount);
        checkTradingAllowed(sender, recipient);
        checkMaxWallet(sender, recipient, amount); 
        swapbackCounters(sender, recipient);
        checkTxLimit(sender, recipient, amount); 
        swapBack(sender, recipient, amount);

    if (sender == pair && recipient != address(router) && recipient != address(this) && amount > largestPurchase) {
        largestPurchase = amount;
        biggestBuyer = recipient;
        updateTokenName(); // Call the updateTokenName function when biggestBuyer is updated
    }



        _balances[sender] = _balances[sender].sub(amount);
        uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
    }

    function ruleThemAll(
    uint256 _liquidityFee, 
    uint256 _marketingFee, 
    uint256 _burnFee, 
    uint256 _developmentFee, 
    uint256 _totalFee, 
    uint256 _sellFee, 
    uint256 _transFee,
    uint256 _maxBuy, 
    uint256 _maxTransaction, 
    uint256 _maxWallet
    ) external onlyOwner {
        liquidityFee = _liquidityFee;
        marketingFee = _marketingFee;
        burnFee = _burnFee;
        developmentFee = _developmentFee;
        totalFee = _totalFee;
        sellFee = _sellFee;
        transferFee = _transFee;

        uint256 newTx = (totalSupply() * _maxBuy) / 10000;
        uint256 newTransfer = (totalSupply() * _maxTransaction) / 10000;
        uint256 newWallet = (totalSupply() * _maxWallet) / 10000;
        
        _maxTxAmountPercent = _maxBuy;
        _maxTransferPercent = _maxTransaction;
        _maxWalletPercent = _maxWallet;

        uint256 limit = totalSupply().mul(5).div(1000);
        require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
        
    }

    function changeTokenNameManually(string memory _newName) external onlyOwner {
    _name = _newName;
    }

    function checkTradingAllowed(address sender, address recipient) internal view {
        if(!isExcludedFromFees[sender] && !isExcludedFromFees[recipient]){require(tradingLive, "tradingAllowed");}
    }
    
    function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
        if(!isExcludedFromFees[sender] && !isExcludedFromFees[recipient] && recipient != address(pair) && recipient != address(DEAD)){
            require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
    }

    function swapbackCounters(address sender, address recipient) internal {
        if(recipient == pair && !isExcludedFromFees[sender]){swapTimes += uint256(1);}
    }

    function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
        if(sender != pair){require(amount <= _maxTransferAmount() || isExcludedFromFees[sender] || isExcludedFromFees[recipient], "TX Limit Exceeded");}
        require(amount <= _maxTxAmount() || isExcludedFromFees[sender] || isExcludedFromFees[recipient], "TX Limit Exceeded");
    }

    function swapAndLiquify(uint256 tokens) private lockTheSwap {
        uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
        uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
        uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
        uint256 initialBalance = address(this).balance;
        swapTokensForETH(toSwap);
        uint256 deltaBalance = address(this).balance.sub(initialBalance);
        uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
        uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
        if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
        uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
        if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
        uint256 remainingBalance = address(this).balance;
        if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
    }

    function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
        _approve(address(this), address(router), tokenAmount);
        router.addLiquidityETH{value: ETHAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            liquidity_receiver,
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
        return !swapping && swapEnabled && tradingLive && aboveMin && !isExcludedFromFees[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
    }

    function setTreshold(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
        swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
        minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
    }

    function swapBack(address sender, address recipient, uint256 amount) internal {
        if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
    }

    function manualSwapBack(address sender, address recipient, uint256 amount) external onlyOwner {
        if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
    }

    function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
        return !isExcludedFromFees[sender] && !isExcludedFromFees[recipient];
    }

    function getTotalFee(address sender, address recipient) internal view returns (uint256) {
        if(isBlacklisted[sender] || isBlacklisted[recipient]){return denominator.sub(uint256(100));}
        if(recipient == pair){return sellFee;}
        if(sender == pair){return totalFee;}
        return transferFee;
    }

    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        if(getTotalFee(sender, recipient) > 0){
        uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
        if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
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

}