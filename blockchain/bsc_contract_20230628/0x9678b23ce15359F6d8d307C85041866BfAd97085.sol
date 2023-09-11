// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.13;

/*


░░░░░██╗░█████╗░██╗███╗░░██╗  ████████╗██╗░░██╗███████╗  ██╗███████╗███╗░░██╗░█████╗░██████╗░
░░░░░██║██╔══██╗██║████╗░██║  ╚══██╔══╝██║░░██║██╔════╝  ██║╚════██║████╗░██║██╔══██╗██╔══██╗
░░░░░██║██║░░██║██║██╔██╗██║  ░░░██║░░░███████║█████╗░░  ██║░░███╔═╝██╔██╗██║██║░░██║██████╔╝
██╗░░██║██║░░██║██║██║╚████║  ░░░██║░░░██╔══██║██╔══╝░░  ██║██╔══╝░░██║╚████║██║░░██║██╔═══╝░
╚█████╔╝╚█████╔╝██║██║░╚███║  ░░░██║░░░██║░░██║███████╗  ██║███████╗██║░╚███║╚█████╔╝██║░░░░░
░╚════╝░░╚════╝░╚═╝╚═╝░░╚══╝  ░░░╚═╝░░░╚═╝░░╚═╝╚══════╝  ╚═╝╚══════╝╚═╝░░╚══╝░╚════╝░╚═╝░░░░░

    
    █████▀██████████████████████████████████████████████████████████████████████████████
    █─▄▄▄▄█▄─██─▄██▀▄─██▄─▄▄▀██▀▄─██▄─▀█▄─▄█─▄─▄─█▄─▄▄─█▄─▄▄─█▄─▄▄▀████▀▄─██▄─▄▄─█▄─█─▄█
    █─██▄─██─██─███─▀─███─▄─▄██─▀─███─█▄▀─████─████─▄█▀██─▄█▀██─██─████─▀─███─▄▄▄██▄─▄██
    ▀▄▄▄▄▄▀▀▄▄▄▄▀▀▄▄▀▄▄▀▄▄▀▄▄▀▄▄▀▄▄▀▄▄▄▀▀▄▄▀▀▄▄▄▀▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▀▀▀▀▄▄▀▄▄▀▄▄▄▀▀▀▀▄▄▄▀▀


                        █▀▄▄▀█░▄▄▄█▀▀▀▀▀██░▄▄▄███─▄─▄─██▀▄─██▄─▀─▄█
                        ██▀▄██▄▄▄▒████████▄▄▄▒█████─████─▀─███▀─▀██
                        ▀▄▄▄▄▀▄▄▄▄▀▀▀▀▀▀▀▀▄▄▄▄▀▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄█▄▄▀

                            https://t.me/+VjarsWT8LVkxODhh

*/

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

interface Antibot {
    function checkValidBuy(address sender, address recipient, uint256 amount) external view returns (bool);
}

interface IPancakeSwapPair {
		event Approval(address indexed owner, address indexed spender, uint value);
		event Transfer(address indexed from, address indexed to, uint value);

		function name() external pure returns (string memory);
		function symbol() external pure returns (string memory);
		function decimals() external pure returns (uint8);
		function totalSupply() external view returns (uint);
		function balanceOf(address owner) external view returns (uint);
		function allowance(address owner, address spender) external view returns (uint);

		function approve(address spender, uint value) external returns (bool);
		function transfer(address to, uint value) external returns (bool);
		function transferFrom(address from, address to, uint value) external returns (bool);

		function DOMAIN_SEPARATOR() external view returns (bytes32);
		function PERMIT_TYPEHASH() external pure returns (bytes32);
		function nonces(address owner) external view returns (uint);

		function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

		event Mint(address indexed sender, uint amount0, uint amount1);
		event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
		event Swap(
				address indexed sender,
				uint amount0In,
				uint amount1In,
				uint amount0Out,
				uint amount1Out,
				address indexed to
		);
		event Sync(uint112 reserve0, uint112 reserve1);

		function MINIMUM_LIQUIDITY() external pure returns (uint);
		function factory() external view returns (address);
		function token0() external view returns (address);
		function token1() external view returns (address);
		function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
		function price0CumulativeLast() external view returns (uint);
		function price1CumulativeLast() external view returns (uint);
		function kLast() external view returns (uint);

		function mint(address to) external returns (uint liquidity);
		function burn(address to) external returns (uint amount0, uint amount1);
		function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
		function skim(address to) external;
		function sync() external;

		function initialize(address, address) external;
}

interface IPancakeSwapRouter{
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
		function removeLiquidity(
				address tokenA,
				address tokenB,
				uint liquidity,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline
		) external returns (uint amountA, uint amountB);
		function removeLiquidityETH(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external returns (uint amountToken, uint amountETH);
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
		function removeLiquidityETHWithPermit(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline,
				bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountToken, uint amountETH);
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
		function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);
		function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);

		function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
		function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
		function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
		function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
		function removeLiquidityETHSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline
		) external returns (uint amountETH);
		function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline,
			bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountETH);
	
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
}

interface IPancakeSwapFactory {
		event PairCreated(address indexed token0, address indexed token1, address pair, uint);

		function feeTo() external view returns (address);
		function feeToSetter() external view returns (address);

		function getPair(address tokenA, address tokenB) external view returns (address pair);
		function allPairs(uint) external view returns (address pair);
		function allPairsLength() external view returns (uint);

		function createPair(address tokenA, address tokenB) external returns (address pair);

		function setFeeTo(address) external;
		function setFeeToSetter(address) external;
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

contract IZNOP20 is ERC20Detailed, Ownable {
    using SafeMath for uint256;
    using SafeMathInt for int256;

    event LogRebase(uint256 indexed epoch, uint256 totalSupply);

    string public _name = "Iznop Inu";
    string public _symbol = "OHM";
    uint8 public _decimals = 9;

    IPancakeSwapPair public pairContract;
    mapping(address => bool) _isFeeExempt;

    modifier validRecipient(address to) {
        require(to != address(0x0));
        _;
    }

    uint256 public constant DECIMALS = 18;
    uint256 public constant MAX_UINT256 = ~uint256(0);
    uint8 public constant RATE_DECIMALS = 7;

    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 10 * 10**9 * 10**DECIMALS;
    uint256 public liquidityFee = 0;
    uint256 public treasuryFee = 250;
    uint256 public RFVfee = 0;

    uint256 public totalFee =
        liquidityFee.add(treasuryFee).add(RFVfee);
    
    uint256 public totalSellFee = 50;
    uint256 public feeDenominator = 1000;

    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address public constant ZERO = 0x0000000000000000000000000000000000000000;

    address public autoLiquidityFund;
    address public treasuryFund;
    address public RFV;
    address public pairAddress;
    bool public swapEnabled = true;

    IPancakeSwapRouter public router;
    address public pair;
    bool inSwap = false;

    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
    uint256 private constant MAX_SUPPLY = 10 * 10**12 * 10**DECIMALS;
    uint256 public INDEX;

    Antibot antibot;

    bool public antibotActive;
    bool public _autoRebase;
    bool public _autoAddLiquidity;

    uint256 public _initRebaseStartTime;
    uint256 public _lastRebasedTime;
    uint256 public rebaseRate = 300000;
    uint256 public _lastAddLiquidityTime;
    uint256 public _rebaseCooldown;

    uint256 public _totalSupply;
    uint256 private _gonsPerFragment;

    bool public useTradeLimits = true;
    bool public tradingEnabled = false;

    uint256 public swapLimitNum;
    uint256 public maxWalletDenom = 100;
    uint256 public constant swapLimitDenom = 1000;    

    mapping(address => uint256) private _gonBalances;
    mapping(address => mapping(address => uint256)) private _allowedFragments;
    mapping(address => bool) public blacklist;
    mapping(address => bool) public isDividendExempt;

    address public usdtAddress = 0x55d398326f99059fF775485246999027B3197955;

    constructor() ERC20Detailed(_name, _symbol, uint8(DECIMALS)) Ownable() {     

        address _dexRouter;

        if(block.chainid == 1){
            _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
        } else if(block.chainid == 5){
            _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
        } else if(block.chainid == 56){
            _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
        } else if(block.chainid == 97){
            _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
        } else if(block.chainid == 42161){
            _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
        } else {
            revert("Chain not configured");
        }

        router = IPancakeSwapRouter(_dexRouter); 

        pair = IPancakeSwapFactory(router.factory()).createPair(
            address(this),
            usdtAddress
        );
      
        autoLiquidityFund = msg.sender;
        treasuryFund = msg.sender;
        RFV = msg.sender;
         
        _allowedFragments[address(this)][address(router)] = type(uint256).max;
        pairAddress = pair;
        pairContract = IPancakeSwapPair(pair);

        antibotActive = false;

        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
        _gonBalances[treasuryFund] = TOTAL_GONS;
        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _initRebaseStartTime = block.timestamp;
        _lastRebasedTime = block.timestamp;
        _rebaseCooldown = 15 minutes;
        _autoRebase = false;
        _autoAddLiquidity = false;
        _isFeeExempt[treasuryFund] = true;
        _isFeeExempt[address(this)] = true;
        
        swapLimitNum = 2; 

        INDEX = gonsForBalance(100000);

        emit Transfer(address(0x0), treasuryFund, _totalSupply);
    }

    //once enabled trading is unable to be paused
    function startTrading() external onlyOwner {
        tradingEnabled = true;
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

    function selectAntibot(bool _antibotActive, address _antibot) external onlyOwner {
        antibotActive = _antibotActive;
        antibot = Antibot(_antibot);
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

        //trading enabled
        if (!_isFeeExempt[sender] && !_isFeeExempt[recipient]) {
            require(tradingEnabled, "Trading not open");
        }

        require(!blacklist[sender] && !blacklist[recipient], "in_blacklist");

        if (antibotActive){
            require(antibot.checkValidBuy(sender, recipient, amount), "No bots allowed.");
        }

        if (inSwap || _isFeeExempt[sender] || _isFeeExempt[recipient]) {
            return _basicTransfer(sender, recipient, amount);
        }
        
        if (shouldRebase()) {
           rebase();
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
            ? takeFee(sender, recipient, gonAmount)
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
        address recipient,
        uint256 gonAmount
    ) internal returns (uint256) {
        if(recipient == pair) {

            uint256 _feeAmount = gonAmount.div(feeDenominator).mul(totalSellFee);
       
            _gonBalances[address(this)] = _gonBalances[address(this)].add(
                gonAmount.div(feeDenominator).mul(totalSellFee)
            );

            emit Transfer(sender, address(this), _feeAmount.div(_gonsPerFragment));
            return gonAmount.sub(_feeAmount);

        } else {
            uint256 feeAmount = gonAmount.div(feeDenominator).mul(totalFee);
       
            _gonBalances[address(this)] = _gonBalances[address(this)].add(
                gonAmount.div(feeDenominator).mul(treasuryFee.add(RFVfee))
            );
            _gonBalances[autoLiquidityFund] = _gonBalances[autoLiquidityFund].add(
                gonAmount.div(feeDenominator).mul(liquidityFee)
            );
            
            emit Transfer(sender, address(this), feeAmount.div(_gonsPerFragment));
            return gonAmount.sub(feeAmount);
        }  
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

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdtAddress;
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(treasuryFund),
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

    function setFeeReceivers(
        address _autoLiquidityFund,
        address _treasuryFund,
        address _RFV 
    ) external onlyOwner {
        autoLiquidityFund = _autoLiquidityFund;
        treasuryFund = _treasuryFund;
        RFV = _RFV; 
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

    function setWhitelist(address _addr, bool _whitelist) external onlyOwner {
        _isFeeExempt[_addr] = _whitelist;
    }

    function setBotBlacklist(address _botAddress, bool _flag) external onlyOwner {
        blacklist[_botAddress] = _flag;    
    }

    function massBotBlacklist(address[] calldata _botAddress, bool _flag) external onlyOwner {
        for(uint256 i = 0; i < _botAddress.length; i++){
            blacklist[_botAddress[i]] = _flag;
        }
    }

    function setFees(uint256 _liqFee, uint256 _tresFee, uint256 _fundFee, uint256 _totalSellFee) external onlyOwner {
        liquidityFee = _liqFee;
        treasuryFee = _tresFee;
        RFVfee = _fundFee;

        totalFee =
        liquidityFee.add(treasuryFee).add(RFVfee);

        totalSellFee = _totalSellFee;

        require(totalFee <= 250, "Less than 25%");
        require(totalSellFee <= 50, "Less than 5%");
    }
    
    function setPairAddress(address _pairAddress) external onlyOwner {
        pairAddress = _pairAddress;
    }

    function setLP(address _address) external onlyOwner {
        pairContract = IPancakeSwapPair(_address);
    }
    
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }
   
    function balanceOf(address who) public view override returns (uint256) {
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

    function forceSwapBack() external onlyOwner {
        swapBack();
    }

    function withdrawTokens(address _token, address _to) external onlyOwner returns (bool _sent) {
        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
        _sent = IERC20(_token).transfer(_to, _contractBalance);
    }

    function withdrawStuckETH() external onlyOwner {
        bool success;
        (success,) = address(msg.sender).call{value: address(this).balance}("");
    }

    function setupMM(address[] calldata mmList) external onlyOwner {
        for(uint256 i = 0; i < mmList.length; i++){
            _isFeeExempt[mmList[i]] = true;
        }
    }

    receive() external payable {}
}