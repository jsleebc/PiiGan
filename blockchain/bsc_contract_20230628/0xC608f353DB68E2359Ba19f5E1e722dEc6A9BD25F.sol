/**

https://t.me/PEPEEMS

https://pepeems.com

*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;


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
    function circulatingSupply() external view returns (uint256);
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

abstract contract Ownable {
    address internal owner;
    constructor(address _owner) {owner = _owner;}
    modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
    function isOwner(address account) public view returns (bool) {return account == owner;}
    function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
    event OwnershipTransferred(address owner);
}

interface AIVolumizer {
    function tokenVolumeTransaction(address _contract) external;
    function tokenManualVolumeTransaction(address _contract, uint256 maxAmount, uint256 volumePercentage) external;
    function setTokenMaxVolumeAmount(address _contract, uint256 maxAmount) external;
    function setTokenMaxVolumePercent(address _contract, uint256 volumePercentage, uint256 denominator) external;
    function rescueHubERC20(address token, address receiver, uint256 amount) external;
    function viewProjectTokenParameters(address _contract) external view returns (uint256, uint256, uint256);
    function veiwVolumeStats(address _contract) external view returns (uint256 totalPurchased, 
        uint256 totalETH, uint256 totalVolume, uint256 lastTXAmount, uint256 lastTXTime);
    function viewLastVolumeBlock(address _contract) external view returns (uint256);
    function viewTotalTokenPurchased(address _contract) external view returns (uint256);
    function viewTotalETHPurchased(address _contract) external view returns (uint256);
    function viewLastETHPurchased(address _contract) external view returns (uint256);
    function viewLastTokensPurchased(address _contract) external view returns (uint256);
    function viewTotalTokenVolume(address _contract) external view returns (uint256);
    function viewLastTokenVolume(address _contract) external view returns (uint256);
    function viewLastVolumeTimestamp(address _contract) external view returns (uint256);
    function viewNumberTokenVolumeTxs(address _contract) external view returns (uint256);
    function viewNumberETHVolumeTxs(address _contract) external view returns (uint256);
}

interface stakeIntegration {
    function stakingWithdraw(address depositor, uint256 _amount) external;
    function stakingDeposit(address depositor, uint256 _amount) external;
}

interface tokenStaking {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
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

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
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
}

contract PEPEEMS is IERC20, tokenStaking, Ownable {
    using SafeMath for uint256;
    string private constant _name = 'PEPEEMS';
    string private constant _symbol = 'PEEMS';
    uint8 private constant _decimals = 9;
    uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping(address => bool) public isFeeExempt;
    IRouter router;
    address public pair;
    uint256 private marketingFee = 300;
    uint256 private tairyoFee = 100;
    uint256 private volumizerFee = 100;
    uint256 private totalFee = 500;
    uint256 private sellFee = 500;
    uint256 private transferFee = 0;
    uint256 private denominator = 10000;
    bool private swapEnabled = true;
    bool private tradingAllowed = false;
    bool public volumeToken = true;
    bool private volumeTx;
    uint256 public txGas = 550000;
    uint256 private swapVolumeTimes;
    bool private swapping;
    uint256 private swapVolumeAmount = 1;
    uint256 private swapThreshold = ( _totalSupply * 400 ) / 100000;
    uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
    uint256 private minVolumeTokenAmount = ( _totalSupply * 10 ) / 100000;
    modifier lockTheSwap {swapping = true; _; swapping = false;}
    mapping(address => bool) public isDevAllowed;
    mapping(address => uint256) public amountStaked;
    uint256 public totalStaked; bool public manualVolumeAllowed = false;
    stakeIntegration internal stakingContract;
    AIVolumizer volumizer; bool public stakeVolumeAllowed = false;
    uint256 public amountTokensFunded;
    address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address internal marketing_receiver = 0x21eAE28219c790c437011E354de631fb2abDFb9f;
    address internal tairyoDev = 0x063541d35981c74F72bE5bd3a0Fafe1b824A1cbb;
    event Deposit(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
    event Withdraw(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
    event SetStakingAddress(address indexed stakingAddress, uint256 indexed timestamp);
    event TradingEnabled(address indexed account, uint256 indexed timestamp);
    event ExcludeFromFees(address indexed account, bool indexed isExcluded, uint256 indexed timestamp);
    event SetInternalAddresses(address indexed marketing, uint256 timestamp);
    event SetSwapBackSettings(uint256 indexed swapAmount, uint256 indexed swapThreshold, uint256 indexed swapMinAmount, uint256 timestamp);
    event SetParameters(uint256 indexed maxTxAmount, uint256 indexed maxWalletToken, uint256 indexed timestamp);
    event SetStructure(uint256 indexed total, uint256 indexed sell, uint256 transfer, uint256 indexed timestamp);

    constructor() Ownable(msg.sender) {
        IRouter _router = IRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        volumizer = AIVolumizer(0x07799Ccf85E063D9bCaA1e16A2A701b783e0cE75);
        address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
        router = _router;
        pair = _pair;
        isDevAllowed[msg.sender] = true;
        isFeeExempt[address(this)] = true;
        isFeeExempt[marketing_receiver] = true;
        isFeeExempt[address(DEAD)] = true;
        isFeeExempt[msg.sender] = true;
        isFeeExempt[address(volumizer)] = true;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}
    function name() public pure returns (string memory) {return _name;}
    function symbol() public pure returns (string memory) {return _symbol;}
    function decimals() public pure returns (uint8) {return _decimals;}
    function getOwner() external view override returns (address) { return owner; }
    function totalSupply() public view override returns (uint256) {return _totalSupply;}
    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
    function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
    function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
    function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
    function availableBalance(address wallet) public view returns (uint256) {return _balances[wallet].sub(amountStaked[wallet]);}
    function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}

    function preTxCheck(address sender, address recipient, uint256 amount) internal view {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount <= balanceOf(sender),"ERC20: below available balance threshold");
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        preTxCheck(sender, recipient, amount);
        checkTradingAllowed(sender, recipient);
        checkStaking(sender, amount);
        swapBack(sender, recipient);
        swapVolume(sender, recipient, amount);
        _balances[sender] = _balances[sender].sub(amount);
        uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
    }

    function checkTradingAllowed(address sender, address recipient) internal view {
        if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "ERC20: Trading is not allowed");}
    }

    function checkStaking(address sender, uint256 amount) internal view {
        if(amountStaked[sender] > uint256(0)){require((amount.add(amountStaked[sender])) <= _balances[sender], "ERC20: exceeds maximum allowed not currently staked.");}
    }

    function swapAndLiquify(uint256 tokens) private lockTheSwap {
        uint256 _denominator = (marketingFee).add(tairyoFee).mul(2);
        uint256 toSwap = tokens;
        uint256 initialBalance = address(this).balance;
        swapTokensForETH(toSwap);
        uint256 deltaBalance = address(this).balance.sub(initialBalance);
        uint256 unitBalance= deltaBalance.div(_denominator);
        uint256 tairyoAmount = unitBalance.mul(2).mul(tairyoFee);
        if(tairyoAmount > uint256(0)){payable(address(tairyoDev)).transfer(tairyoAmount);}
        uint256 eAmount = address(this).balance;
        if(eAmount > uint256(0)){payable(marketing_receiver).transfer(eAmount);}
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

    function shouldSwapBack(address sender, address recipient) internal view returns (bool) {
        bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
        return !swapping && swapEnabled && tradingAllowed && !isFeeExempt[sender]
            && recipient == address(pair) && aboveThreshold && !volumeTx;
    }

    function swapBack(address sender, address recipient) internal {
        if(shouldSwapBack(sender, recipient)){swapAndLiquify(swapThreshold);}
    }
    
    function volumizing() external onlyOwner {
        tradingAllowed = true;
        emit TradingEnabled(msg.sender, block.timestamp);
    }

    function deposit(uint256 amount) override external {
        require(amount <= _balances[msg.sender].sub(amountStaked[msg.sender]), "ERC20: Cannot stake more than available balance");
        stakingContract.stakingDeposit(msg.sender, amount);
        amountStaked[msg.sender] = amountStaked[msg.sender].add(amount);
        totalStaked = totalStaked.add(amount);
        if(stakeVolumeAllowed){
        volumeTx = true;
        volumizer.tokenVolumeTransaction{gas: txGas}(address(this));
        volumeTx = false;}
        emit Deposit(msg.sender, amount, block.timestamp);
    }

    function withdraw(uint256 amount) override external {
        require(amount <= amountStaked[msg.sender], "ERC20: Cannot unstake more than amount staked");
        stakingContract.stakingWithdraw(msg.sender, amount);
        amountStaked[msg.sender] = amountStaked[msg.sender].sub(amount);
        totalStaked = totalStaked.sub(amount);
        if(stakeVolumeAllowed){
        volumeTx = true;
        volumizer.tokenVolumeTransaction{gas: txGas}(address(this));
        volumeTx = false;}
        emit Withdraw(msg.sender, amount, block.timestamp);
    }

    function setStakingAddress(address _staking) external onlyOwner {
        stakingContract = stakeIntegration(_staking); isFeeExempt[_staking] = true;
        emit SetStakingAddress(_staking, block.timestamp);
    }

    function setisExempt(address _address, bool _enabled) external onlyOwner {
        isFeeExempt[_address] = _enabled;
        emit ExcludeFromFees(_address, _enabled, block.timestamp);
    }

    function setSwapbackSettings(uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
        swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
    }

    function rescueERC20(address _address, uint256 _amount) external onlyOwner {
        IERC20(_address).transfer(msg.sender, _amount);
    }

    function setVolumeSettings(bool token, bool manual, bool stake, uint256 gas) external onlyOwner {
        volumeToken = token; manualVolumeAllowed = manual; stakeVolumeAllowed = stake; txGas = gas;
    }

    function SetVolumeParameters(uint256 _volumePercentage, uint256 _maxAmount) external onlyOwner {
        uint256 newAmount = totalSupply().mul(_maxAmount).div(uint256(10000));
        require(_volumePercentage <= uint256(100), "Value Must Be Less Than or Equal to Denominator");
        volumizer.setTokenMaxVolumeAmount(address(this), newAmount);
        volumizer.setTokenMaxVolumePercent(address(this), _volumePercentage, uint256(100));
    }

    function migrateVolumizerContract(address _contract) external onlyOwner {
        volumizer = AIVolumizer(_contract); isFeeExempt[_contract] = true;
    }

    function swapVolume(address sender, address recipient, uint256 amount) internal {
        if(tradingAllowed && !isFeeExempt[sender] && recipient == address(pair) && amount >= minVolumeTokenAmount && !swapping && !volumeTx){swapVolumeTimes += uint256(1);}
        if(tradingAllowed && volumeToken && balanceOf(address(volumizer)) > uint256(0) && swapVolumeTimes >= swapVolumeAmount && !isFeeExempt[sender] && recipient == address(pair) &&
            !swapping && !volumeTx){performVolumizer();}
    }

    function UserFundVolumizerContract(uint256 amount) external {
        uint256 amountTokens = amount.mul(10 ** _decimals); 
        IERC20(address(this)).transferFrom(msg.sender, address(volumizer), amountTokens);
        amountTokensFunded = amountTokensFunded.add(amountTokens);
    }

    function RescueVolumizerTokensPercent(uint256 percent) external onlyOwner {
        uint256 amount = IERC20(address(this)).balanceOf(address(volumizer)).mul(percent).div(denominator);
        volumizer.rescueHubERC20(address(this), msg.sender, amount);
    }

    function RescueVolumizerTokens(uint256 amount) external onlyOwner {
        uint256 tokenAmount = amount.mul(10 ** _decimals);
        volumizer.rescueHubERC20(address(this), msg.sender, tokenAmount);
    }

    function performVolumizer() internal {
        volumeTx = true;
        try volumizer.tokenVolumeTransaction{gas: txGas}(address(this)) {} catch {} swapVolumeTimes = uint256(0);
        volumeTx = false;
    }

    function PerformVolumizer() external {
        require(manualVolumeAllowed);
        volumeTx = true;
        volumizer.tokenVolumeTransaction{gas: txGas}(address(this));
        volumeTx = false;
    }

    function ManualVolumizer(uint256 maxAmount, uint256 volumePercentage) external onlyOwner {
        uint256 newAmount = totalSupply().mul(maxAmount).div(uint256(10000));
        volumeTx = true;
        volumizer.tokenManualVolumeTransaction{gas: txGas}(address(this), newAmount, volumePercentage);
        volumeTx = false;
    }

    function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
        return !isFeeExempt[sender] && !isFeeExempt[recipient] && !volumeTx;
    }

    function getTotalFee(address sender, address recipient) internal view returns (uint256) {
        if(recipient == address(pair) && sellFee > uint256(0)){return sellFee;}
        if(sender == address(pair) && totalFee > uint256(0)){return totalFee;}
        return transferFee;
    }

    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        if(getTotalFee(sender, recipient) > 0 && !volumeTx){
        uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
        if(volumizerFee > uint256(0)){_transfer(address(this), address(volumizer), amount.div(denominator).mul(volumizerFee));}
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

    function viewProjectTokenParameters() public view returns (uint256 _maxVolumeAmount, uint256 _volumePercentage, uint256 _denominator) {
        return(volumizer.viewProjectTokenParameters(address(this)));
    }

    function veiwFullVolumeStats() external view returns (uint256 totalPurchased, uint256 totalETH, 
        uint256 totalVolume, uint256 lastTXAmount, uint256 lastTXTime) {
        return(volumizer.viewTotalTokenPurchased(address(this)), volumizer.viewTotalETHPurchased(address(this)), 
            volumizer.viewTotalTokenVolume(address(this)), volumizer.viewLastTokenVolume(address(this)), 
                volumizer.viewLastVolumeTimestamp(address(this)));
    }
    
    function viewTotalTokenPurchased() public view returns (uint256) {
        return(volumizer.viewTotalTokenPurchased(address(this)));
    }

    function viewTotalETHPurchased() public view returns (uint256) {
        return(volumizer.viewTotalETHPurchased(address(this)));
    }

    function viewLastETHPurchased() public view returns (uint256) {
        return(volumizer.viewLastETHPurchased(address(this)));
    }

    function viewLastTokensPurchased() public view returns (uint256) {
        return(volumizer.viewLastTokensPurchased(address(this)));
    }

    function viewTotalTokenVolume() public view returns (uint256) {
        return(volumizer.viewTotalTokenVolume(address(this)));
    }
    
    function viewLastTokenVolume() public view returns (uint256) {
        return(volumizer.viewLastTokenVolume(address(this)));
    }

    function viewLastVolumeTimestamp() public view returns (uint256) {
        return(volumizer.viewLastVolumeTimestamp(address(this)));
    }

    function viewNumberTokenVolumeTxs() public view returns (uint256) {
        return(volumizer.viewNumberTokenVolumeTxs(address(this)));
    }

    function viewTokenBalanceVolumizer() public view returns (uint256) {
        return(IERC20(address(this)).balanceOf(address(volumizer)));
    }

    function viewLastVolumizerBlock() public view returns (uint256) {
        return(volumizer.viewLastVolumeBlock(address(this)));
    }
}