// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.13;

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

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
} 

interface IPancakeSwapPair {
		function factory() external view returns (address);
		function sync() external;
}

interface IPancakeSwapRouter{
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
		function swapExactTokensForTokens(
				uint amountIn,
				uint amountOutMin,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapTokensForExactTokens(
				uint amountOut,
				uint amountInMax,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapExactTokensForETHSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
}

interface IPancakeSwapFactory {
		function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract Ownable {
    address private _owner;

    event OwnershipRenounced(address indexed previousOwner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(_owner);
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
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
}

contract BobChain is IERC20, Ownable {
    using SafeMath for uint256;
    using SafeMathInt for int256;

    IPancakeSwapPair public pairContract;
    IPancakeSwapRouter public router;

    string public _name = "BOBCHAIN";
    string public _symbol = "BOBCHA";
    uint8 public _decimals = 9;

    uint256 public constant DECIMALS = 9;
    uint256 public constant MAX_UINT256 = ~uint256(0);
    uint8 public constant RATE_DECIMALS = 7;

    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 10000 * 10**3 * 10**DECIMALS;

    uint256 public liquidityFee = 40;
    uint256 public treasuryFee = 40;
    uint256 public marketingFee = 40;
    
    uint256 public totalFee = liquidityFee.add(treasuryFee).add(marketingFee);
    uint256 public feeDenominator = 1000;

    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address public constant ZERO = 0x0000000000000000000000000000000000000000;

    address public autoLiquidityFund;
    address public treasuryFund;
    address public marketingFund;

    address public pairAddress;
    address public pair;
    address routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    bool public swapEnabled = true;
    bool inSwap = false;

    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    modifier validRecipient(address to) {
        require(to != address(0x0));
        _;
    }

    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
    uint256 private constant MAX_SUPPLY = 325 * 10**7 * 10**DECIMALS;

    uint256 public INDEX;

    bool public _autoRebase;
    bool public _autoAddLiquidity;
    bool public whitelistOnly;
    bool public abilityToBlacklist;
    bool public abilityToChangeTaxes;

    uint256 public _initRebaseStartTime;
    uint256 public _lastRebasedTime;
    uint256 public rebaseRate = 40000;
    uint256 public _lastAddLiquidityTime;
    uint256 public _rebaseCooldown;
    uint256 public _totalSupply;
    uint256 private _gonsPerFragment;

    bool public useTradeLimits = true;
    uint256 public swapLimitNum;
    uint256 public maxWalletDenom = 100;
    uint256 public constant swapLimitDenom = 1000;    

    mapping (address => uint256) private _gonBalances;
    mapping (address => mapping(address => uint256)) private _allowedFragments;
    mapping (address => bool) public blacklistedUsers;
    mapping (address => bool) public whitelistedUsers;
    mapping (address => bool) public _isFeeExempt;

    event LogRebase(uint256 indexed epoch, uint256 totalSupply);
        

    constructor() Ownable() {        
        router = IPancakeSwapRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E); 
        pair = IPancakeSwapFactory(router.factory()).createPair(
            router.WETH(),
            address(this)
        );
      
        autoLiquidityFund = 0xa013C82895E32F6a989ae0Be14fe3FDA33602a7D;
        treasuryFund = msg.sender;
        marketingFund = 0x8593483B6738214953B473B2f6bD90Ec84111953;

        abilityToBlacklist = true;
        abilityToChangeTaxes = true;
         

        _allowedFragments[address(this)][address(router)] = type(uint256).max;
        pairAddress = pair;
        pairContract = IPancakeSwapPair(pair);

        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
        _gonBalances[treasuryFund] = TOTAL_GONS;
        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _initRebaseStartTime = block.timestamp;
        _lastRebasedTime = block.timestamp;
        _rebaseCooldown = 15 minutes;
        _autoRebase = true;
        _autoAddLiquidity = true;
        _isFeeExempt[treasuryFund] = true;
        _isFeeExempt[address(this)] = true;

        swapLimitNum = 2;

        whitelistOnly = true;
        whitelistedUsers[routerAddress] = true;
        whitelistedUsers[msg.sender] = true;
        whitelistedUsers[autoLiquidityFund] = true;
        whitelistedUsers[address(this)] = true;

        INDEX = gonsForBalance(100000);
        emit Transfer(address(0x0), treasuryFund, _totalSupply);
    }

    function rebase() internal {
        if ( inSwap ) return;
        
        uint256 deltaTime = block.timestamp - _lastRebasedTime;
        uint256 times = deltaTime.div(_rebaseCooldown);
        uint256 epoch = times.mul(_rebaseCooldown/60);

        for (uint256 i = 0; i < times; i++) {
            _totalSupply = _totalSupply
                .mul((10**RATE_DECIMALS))
                .div((10**RATE_DECIMALS).add(rebaseRate));
        }

        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _lastRebasedTime = _lastRebasedTime.add(times.mul(_rebaseCooldown));

        pairContract.sync();

        emit LogRebase(epoch, _totalSupply);
    }

    function manualRebase(uint256 rebaseRateManual) external onlyOwner {

        _totalSupply = _totalSupply
                .mul((10**RATE_DECIMALS))
                .div((10**RATE_DECIMALS).add(rebaseRateManual));

        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _lastRebasedTime = block.timestamp;

        pairContract.sync();
    }

    function transfer(address to, uint256 value)
        external
        override
        validRecipient(to)
        returns (bool)
    {
        _transferFrom(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override validRecipient(to) returns (bool) {
        if (_allowedFragments[from][msg.sender] !=  type(uint256).max) {
            _allowedFragments[from][msg.sender] = _allowedFragments[from][
                msg.sender
            ].sub(value, "Insufficient Allowance");
        }
        _transferFrom(from, to, value);
        return true;
    }

    function _basicTransfer(
        address from,
        address to,
        uint256 amount
    ) internal returns (bool) {
        uint256 gonAmount = amount.mul(_gonsPerFragment);
        _gonBalances[from] = _gonBalances[from].sub(gonAmount);
        _gonBalances[to] = _gonBalances[to].add(gonAmount);
        return true;
    }

    function _transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        require(!blacklistedUsers[sender] && !blacklistedUsers[recipient], "You was banned mate");

        if (whitelistOnly) {
            require(whitelistedUsers[sender] || whitelistedUsers[recipient], "Only whitelisted users can buy rn");
        }

        if (inSwap) {
            return _basicTransfer(sender, recipient, amount);
        }
        if (shouldRebase()) {
           rebase();
        }

        if (shouldAddLiquidity()) {
            addLiquidity();
        }

        if (shouldSwapBack()) {
            swapBack();
        }

        uint256 gonAmount = amount.mul(_gonsPerFragment);
        if(useTradeLimits && sender != owner() && recipient != pair){
             require(_gonBalances[recipient].add(gonAmount) <= gonsForBalance(_totalSupply) / maxWalletDenom, "Initial 1% max wallet restriction");
        }

        _gonBalances[sender] = _gonBalances[sender].sub(gonAmount);
        uint256 gonAmountReceived = shouldTakeFee(sender, recipient)
            ? takeFee(sender, gonAmount)
            : gonAmount;
        _gonBalances[recipient] = _gonBalances[recipient].add(
            gonAmountReceived
        );

        emit Transfer(
            sender,
            recipient,
            gonAmountReceived.div(_gonsPerFragment)
        );
        return true;
    }

    function setTradeRestrictions(bool _useTradeLimits, uint256 _maxWalletDenom) external onlyOwner {
        useTradeLimits = _useTradeLimits;
        maxWalletDenom = _maxWalletDenom;
    }

    function takeFee(
        address sender,
        uint256 gonAmount
    ) internal  returns (uint256) {
  
        uint256 feeAmount = gonAmount.div(feeDenominator).mul(totalFee);
       
        _gonBalances[address(this)] = _gonBalances[address(this)].add(
            gonAmount.div(feeDenominator).mul(treasuryFee.add(marketingFee))
        );
        _gonBalances[autoLiquidityFund] = _gonBalances[autoLiquidityFund].add(
            gonAmount.div(feeDenominator).mul(liquidityFee)
        );
        
        emit Transfer(sender, address(this), feeAmount.div(_gonsPerFragment));
        return gonAmount.sub(feeAmount);
    }

    function addLiquidity() internal swapping {
        uint256 autoLiquidityAmount = _gonBalances[autoLiquidityFund].div(
            _gonsPerFragment
        );
        _gonBalances[address(this)] = _gonBalances[address(this)].add(
            _gonBalances[autoLiquidityFund]
        );
        _gonBalances[autoLiquidityFund] = 0;
        uint256 amountToLiquify = autoLiquidityAmount.div(2);
        uint256 amountToSwap = autoLiquidityAmount.sub(amountToLiquify);

        if( amountToSwap == 0 ) {
            return;
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        uint256 balanceBefore = address(this).balance;


        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountETHLiquidity = address(this).balance.sub(balanceBefore);

        if (amountToLiquify > 0 && amountETHLiquidity > 0) {
            router.addLiquidityETH{value: amountETHLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                treasuryFund,
                block.timestamp
            );
        }
        _lastAddLiquidityTime = block.timestamp;
    }

    function getSwapLimit() internal view returns (uint256){
        return swapLimitNum * _totalSupply / 1000;
    }

    function swapBack() internal swapping {
        uint256 swapLimit = getSwapLimit();
        uint256 amountToSwap = _gonBalances[address(this)].div(_gonsPerFragment);
        amountToSwap = amountToSwap >= swapLimit ? swapLimit : amountToSwap;
        if( amountToSwap == 0) {
            return;
        }

        uint256 balanceBefore = address(this).balance;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountETHToTreasuryAndMarketing = address(this).balance.sub(
            balanceBefore
        );

        (bool success, ) = payable(treasuryFund).call{
            value: amountETHToTreasuryAndMarketing.mul(treasuryFee).div(
                treasuryFee.add(marketingFee)
            ),
            gas: 30000
        }("");
        (success, ) = payable(marketingFund).call{
            value: amountETHToTreasuryAndMarketing.mul(marketingFee).div(
                treasuryFee.add(marketingFee)
            ),
            gas: 30000
        }("");
    }

    function withdrawAllToTreasury() external swapping onlyOwner {
        uint256 amountToSwap = _gonBalances[address(this)].div(_gonsPerFragment);
        require( amountToSwap > 0,"There are tokens deposited in contract");
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            treasuryFund,
            block.timestamp
        );
    }

    function claimStuckBalance() external swapping onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance,
            gas: 30000
        }(""); success;
    }

    function shouldTakeFee(address from, address to)
        internal
        view
        returns (bool)
    {
        return 
            (pair == from || pair == to) &&
            !_isFeeExempt[from];
    }

    function shouldRebase() internal view returns (bool) {
        return _autoRebase && (_totalSupply < MAX_SUPPLY) && msg.sender != pair &&
         !inSwap && block.timestamp >= (_lastRebasedTime + _rebaseCooldown);
    }

    function shouldAddLiquidity() internal view returns (bool) {
        return
            _autoAddLiquidity && 
            !inSwap && 
            msg.sender != pair &&
            block.timestamp >= (_lastAddLiquidityTime + 30 minutes);
    }

    function shouldSwapBack() internal view returns (bool) {
        return 
            !inSwap &&
            msg.sender != pair  ; 
    }

    function setAutoRebase(bool _flag, uint256 rebaseCooldown, uint256 _rebaseRate) external onlyOwner {
        if (_flag) {
            _autoRebase = _flag;
            _lastRebasedTime = block.timestamp;
            _rebaseCooldown = rebaseCooldown;
            rebaseRate = _rebaseRate;
        } else {
            _autoRebase = _flag;
        }
    }

    function setAutoAddLiquidity(bool _flag) external onlyOwner {
        if(_flag) {
            _autoAddLiquidity = _flag;
            _lastAddLiquidityTime = block.timestamp;
        } else {
            _autoAddLiquidity = _flag;
        }
    }

    function allowance(address owner_, address spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowedFragments[owner_][spender];
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.sub(
                subtractedValue
            );
        }
        emit Approval(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][
            spender
        ].add(addedValue);
        emit Approval(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

    function approve(address spender, uint256 value)
        external
        override
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function checkFeeExempt(address _addr) external view returns (bool) {
        return _isFeeExempt[_addr];
    }

    function getCirculatingSupply() public view returns (uint256) {
        return
            (TOTAL_GONS.sub(_gonBalances[DEAD]).sub(_gonBalances[ZERO])).div(
                _gonsPerFragment
            );
    }

    function isNotInSwap() external view returns (bool) {
        return !inSwap;
    }

    function manualSync() external {
        IPancakeSwapPair(pair).sync();
    }

    function setFeeReceivers(address _autoLiquidityFund, address _treasuryFund, address _marketingFund) external onlyOwner {
        autoLiquidityFund = _autoLiquidityFund;
        treasuryFund = _treasuryFund;
        marketingFund = _marketingFund; 
    }

    function setFeesAmount(uint256 _liquidityFee, uint256 _treasuryFee, uint256 _marketingFee) external onlyOwner {
        require(abilityToChangeTaxes, "Ability to change taxes was disabled. You can't change taxes without it.");
        liquidityFee = _liquidityFee;
        treasuryFee = _treasuryFee;
        marketingFee = _marketingFee;

        totalFee = liquidityFee.add(treasuryFee).add(marketingFee);
    }

    function removeTaxesFromUser(address _address, bool _taxless) external onlyOwner {
        _isFeeExempt[_address] = _taxless;
    }

    function addUsersToBlacklist(address[] memory _stinkies) external onlyOwner {
        require (abilityToBlacklist, "Ability to blacklist was disabled. You can't blacklist without it.");
        for (uint256 i = 0; i < _stinkies.length; i++) {
            address walletOfRetard = _stinkies[i];
            blacklistedUsers[walletOfRetard] = true;
        }
    }

    function removeFromBlacklist(address _victim) external onlyOwner {
        blacklistedUsers[_victim] = false;
    }

    function addUsersToWhitelist(address[] memory _usersToWhitelist, bool _isWhitelisted) public onlyOwner {
        for(uint256 i = 0; i < _usersToWhitelist.length; i++){
            address wallet = _usersToWhitelist[i];
            whitelistedUsers[wallet] = _isWhitelisted;
        }
    }

    function setWhitelistOnly(bool _value) public onlyOwner {
        whitelistOnly = _value;
    }

    function burnAbilityToBlacklist() external onlyOwner {
        abilityToBlacklist = false;
    }

    function burnAbilityToChangeTaxes() external onlyOwner {
        abilityToChangeTaxes = false;
    }
    
    function setPairAddress(address _pairAddress) external onlyOwner {
        pairAddress = _pairAddress;
    }

    function setLP(address _address) external onlyOwner {
        pairContract = IPancakeSwapPair(_address);
    }

    function getLiquidityBacking(uint256 accuracy)
        external
        view
        returns (uint256)
    {
        uint256 liquidityBalance = _gonBalances[pair].div(_gonsPerFragment);
        return
            accuracy.mul(liquidityBalance.mul(2)).div(getCirculatingSupply());
    }
    
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function name() public view returns (string memory) {
        return _name;
    }
  
    function symbol() public view returns (string memory) {
        return _symbol;
    }
  
    function decimals() public view returns (uint256) {
        return _decimals;
    }
   
    function balanceOf(address who) external view override returns (uint256) {
        return _gonBalances[who].div(_gonsPerFragment);
    }

    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

    function gonsForBalance(uint256 amount) public view returns (uint256) {
        return amount.mul(_gonsPerFragment);
    }

    function balanceForGons(uint256 gons) public view returns (uint256) {
        return gons.div(_gonsPerFragment);
    }

    function index() public view returns (uint256) {
        return balanceForGons(INDEX);
    }

    receive() external payable {}
}