/**
 

______________ ___ .____________ _________   _________     _____   ____  __.___________
\__    ___/   |   \|   \_   ___ \\_   ___ \  \_   ___ \   /  _  \ |    |/ _|\_   _____/
  |    | /    ~    \   /    \  \//    \  \/  /    \  \/  /  /_\  \|      <   |    __)_ 
  |    | \    Y    /   \     \___\     \____ \     \____/    |    \    |  \  |        \
  |____|  \___|_  /|___|\______  /\______  /  \______  /\____|__  /____|__ \/_______  /
                \/             \/        \/          \/         \/        \/        \/ 

                                  THICC CAKE rewards        Bringing back the rewards token
THICC CAKE is here to bring       THICC CAKE liquidity      Let's start staking those CAKES
                                  THICC CAKE memes          Ready for the next Market LIFT OFF

TG: https://t.me/THICC_CAKE_Portal

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

library SafeMath {
    function tryAdd(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
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

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface IDexFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IDexRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IERC20Extended {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = payable(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IDividendDistributor {
    function setShare(address shareholder, uint256 amount) external;

    function deposit() external payable;

    function claimDividend(address _user) external;

    function getPaidEarnings(address shareholder)
        external
        view
        returns (uint256);

    function getUnpaidEarnings(address shareholder)
        external
        view
        returns (uint256);

    function totalDistributed() external view returns (uint256);
}

contract DividendDistributor is IDividendDistributor {
    using SafeMath for uint256;

    address public _token;
    address public _owner;

    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }

    IERC20Extended public CAKE =
        IERC20Extended(0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82);
    IDexRouter public router;

    address[] public shareholders;
    mapping(address => uint256) public shareholderIndexes;
    mapping(address => uint256) public shareholderClaims;

    mapping(address => Share) public shares;

    uint256 public totalShares;
    uint256 public totalDividends;
    uint256 public totalDistributed;
    uint256 public dividendsPerShare;
    uint256 public dividendsPerShareAccuracyFactor = 10**36;

    bool initialized;
    modifier initializer() {
        require(!initialized);
        _;
        initialized = true;
    }

    modifier onlyToken() {
        require(msg.sender == _token);
        _;
    }

    constructor(address router_, address owner_) {
        _token = msg.sender;
        router = IDexRouter(router_);
        _owner = owner_;
    }

    function setShare(address shareholder, uint256 amount)
        external
        override
        onlyToken
    {
        if (shares[shareholder].amount > 0) {
            distributeDividend(shareholder);
        }

        if (amount > 0 && shares[shareholder].amount == 0) {
            addShareholder(shareholder);
        } else if (amount == 0 && shares[shareholder].amount > 0) {
            removeShareholder(shareholder);
        }

        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
        shares[shareholder].amount = amount;
        shares[shareholder].totalExcluded = getCumulativeDividends(
            shares[shareholder].amount
        );
    }

    function deposit() external payable override onlyToken {
        uint256 balanceBefore = CAKE.balanceOf(address(this));

        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = address(CAKE);

        router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: msg.value
        }(0, path, address(this), block.timestamp);

        uint256 amount = CAKE.balanceOf(address(this)).sub(balanceBefore);

        uint256 ownerReward = amount.mul(20).div(100);
        CAKE.transfer(_owner, ownerReward);

        totalDividends = totalDividends.add(amount.sub(ownerReward));
        dividendsPerShare = dividendsPerShare.add(
            dividendsPerShareAccuracyFactor.mul(amount).div(totalShares)
        );
    }

    function distributeDividend(address shareholder) internal {
        if (shares[shareholder].amount == 0) {
            return;
        }

        uint256 amount = getUnpaidEarnings(shareholder);
        if (amount > 0) {
            totalDistributed = totalDistributed.add(amount);
            CAKE.transfer(shareholder, amount);
            shareholderClaims[shareholder] = block.timestamp;
            shares[shareholder].totalRealised = shares[shareholder]
                .totalRealised
                .add(amount);
            shares[shareholder].totalExcluded = getCumulativeDividends(
                shares[shareholder].amount
            );
        }
    }

    function claimDividend(address _user) external {
        distributeDividend(_user);
    }

    function getPaidEarnings(address shareholder)
        public
        view
        returns (uint256)
    {
        return shares[shareholder].totalRealised;
    }

    function getUnpaidEarnings(address shareholder)
        public
        view
        returns (uint256)
    {
        if (shares[shareholder].amount == 0) {
            return 0;
        }

        uint256 shareholderTotalDividends = getCumulativeDividends(
            shares[shareholder].amount
        );
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;

        if (shareholderTotalDividends <= shareholderTotalExcluded) {
            return 0;
        }

        return shareholderTotalDividends.sub(shareholderTotalExcluded);
    }

    function getCumulativeDividends(uint256 share)
        internal
        view
        returns (uint256)
    {
        return
            share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[
            shareholders.length - 1
        ];
        shareholderIndexes[
            shareholders[shareholders.length - 1]
        ] = shareholderIndexes[shareholder];
        shareholders.pop();
    }
}

// main contract
contract THICC is IERC20Extended, Ownable {
    using SafeMath for uint256;

    string private constant _name = "THICC CAKE";
    string private constant _symbol = "THICC";
    uint8 private constant _decimals = 18;
    uint256 private constant _totalSupply = 69_000_000_000_000 * 10**_decimals;

    address public CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address private constant DEAD = address(0xdead);
    address private constant ZERO = address(0);
    IDexRouter public router;
    address public pair;

    uint256 public liquidityFee = 2;
    uint256 public rewardFee = 4;
    uint256 public marketingFee = 2;
    uint256 public totalFee = liquidityFee.add(rewardFee).add(marketingFee);
    uint256 private constant _feeDenominator = 100;

    DividendDistributor public distributor;
    uint256 public maxTxnAmount = _totalSupply / 100;
    uint256 public maxWalletAmount = (_totalSupply * 15) / 1000;
    uint256 public targetLiquidity = 50;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public isFeeExempt;
    mapping(address => bool) public isLimitExmpt;
    mapping(address => bool) public isWalletExmpt;
    mapping(address => bool) public isDividendExempt;

    bool public swapEnabled;
    uint256 public swapThreshold = _totalSupply / 2000;
    bool public trading;
    bool inSwap;
    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    event AutoLiquify(uint256 amountBNB, uint256 amountBOG);

    constructor() Ownable() {
        address router_ = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

        router = IDexRouter(router_);
        pair = IDexFactory(router.factory()).createPair(
            address(this),
            router.WETH()
        );
        distributor = new DividendDistributor(router_, msg.sender);

        isFeeExempt[msg.sender] = true;
        isFeeExempt[address(this)] = true;

        isDividendExempt[pair] = true;
        isDividendExempt[address(this)] = true;
        isDividendExempt[DEAD] = true;
        isDividendExempt[ZERO] = true;

        isLimitExmpt[msg.sender] = true;
        isLimitExmpt[address(this)] = true;

        isWalletExmpt[msg.sender] = true;
        isWalletExmpt[pair] = true;
        isWalletExmpt[address(this)] = true;

        _allowances[address(this)][address(router)] = _totalSupply;
        _allowances[address(this)][address(pair)] = _totalSupply;

        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}

    function totalSupply() external view override returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }

    function decimals() external pure override returns (uint8) {
        return _decimals;
    }

    function symbol() external pure override returns (string memory) {
        return _symbol;
    }

    function name() external pure override returns (string memory) {
        return _name;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function allowance(address holder, address spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowances[holder][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount)
        external
        override
        returns (bool)
    {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        if (_allowances[sender][msg.sender] != _totalSupply) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
                .sub(amount, "Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        if (!isLimitExmpt[sender] && !isLimitExmpt[recipient]) {
            require(amount <= maxTxnAmount, "Max txn limit exceeds");

            // trading disable till launch
            if (!trading) {
                require(
                    pair != sender && pair != recipient,
                    "Trading is disable"
                );
            }
        }

        if (!isWalletExmpt[recipient]) {
            require(
                balanceOf(recipient).add(amount) <= maxWalletAmount,
                "Max Wallet limit exceeds"
            );
        }

        if (inSwap) {
            return _basicTransfer(sender, recipient, amount);
        }

        if (shouldSwapBack()) {
            swapBack();
        }

        _balances[sender] = _balances[sender].sub(
            amount,
            "Insufficient Balance"
        );

        uint256 amountReceived;
        if (
            isFeeExempt[sender] ||
            isFeeExempt[recipient] ||
            (sender != pair && recipient != pair)
        ) {
            amountReceived = amount;
        } else {
            uint256 feeAmount;
            feeAmount = amount.mul(totalFee).div(_feeDenominator);
            amountReceived = amount.sub(feeAmount);
            takeFee(sender, feeAmount);
        }

        _balances[recipient] = _balances[recipient].add(amountReceived);

        if (!isDividendExempt[sender]) {
            try distributor.setShare(sender, _balances[sender]) {} catch {}
        }
        if (!isDividendExempt[recipient]) {
            try
                distributor.setShare(recipient, _balances[recipient])
            {} catch {}
        }

        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    function _basicTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(
            amount,
            "Insufficient Balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function takeFee(address sender, uint256 feeAmount) internal {
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return
            msg.sender != pair &&
            !inSwap &&
            swapEnabled &&
            _balances[address(this)] >= swapThreshold;
    }

    function swapBack() internal swapping {
        uint256 feesToSwap = swapThreshold;

        uint256 amountToLiquify = feesToSwap.mul(liquidityFee).div(totalFee).div(2);
        uint256 amountToSwap = feesToSwap.sub(amountToLiquify);

        uint256 initialBnbBalance = address(this).balance;

        _swapTokensForBNB(amountToSwap);

        uint256 newBnbBalance = address(this).balance.sub(initialBnbBalance);

        uint256 amountBNBMarketing = newBnbBalance.mul(marketingFee).div(totalFee);
        uint256 amountBNBReward = newBnbBalance.mul(rewardFee).div(totalFee);
        uint256 amountBNBLiquidity = newBnbBalance.sub(amountBNBMarketing).sub(amountBNBReward);

        payable(owner()).transfer(amountBNBMarketing);

        try distributor.deposit{value: amountBNBReward}() {} catch {}

        if (_calculateLiquidityRatio() > targetLiquidity) {
            _addLiquidity(amountToLiquify, amountBNBLiquidity);
        } else {
            _swapBNBForTokens(amountBNBLiquidity);
        }
    }

    function _swapTokensForBNB(uint256 tokenAmount) private {
        // Generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        // Make the swap
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // Accept any amount of BNB
            path,
            address(this),
            block.timestamp
        );
    }

    function _swapBNBForTokens(uint256 bnbAmount) private {
        // Generate the uniswap pair path of weth -> token
        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = address(this);

        // Make the swap
        router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: bnbAmount
        }(
            0, // Accept any amount of tokens
            path,
            owner(),
            block.timestamp
        );
    }

    function _addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
        // Add the liquidity
        router.addLiquidityETH{value: bnbAmount}(
            address(this),
            tokenAmount,
            0, // Slippage is unavoidable
            0, // Slippage is unavoidable
            owner(),
            block.timestamp
        );

        emit AutoLiquify(bnbAmount, tokenAmount);
    }

    function claimDividend() external {
        distributor.claimDividend(msg.sender);
    }

    function getPaidDividend(address shareholder)
        public
        view
        returns (uint256)
    {
        return distributor.getPaidEarnings(shareholder);
    }

    function getUnpaidDividend(address shareholder)
        external
        view
        returns (uint256)
    {
        return distributor.getUnpaidEarnings(shareholder);
    }

    function getTotalDistributedDividend() external view returns (uint256) {
        return distributor.totalDistributed();
    }

    function setIsDividendExempt(address holder, bool exempt)
        external
        onlyOwner
    {
        require(holder != address(this) && holder != pair);
        isDividendExempt[holder] = exempt;
        if (exempt) {
            distributor.setShare(holder, 0);
        } else {
            distributor.setShare(holder, _balances[holder]);
        }
    }

    function enableTrading() external onlyOwner {
        require(!trading, "Already enabled");
        trading = true;
        swapEnabled = true;
    }

    function removeStuckEth(uint256 amount) external onlyOwner {
        payable(owner()).transfer(amount);
    }

    function rescueERC20(address _tokenAddress)
        external
        onlyOwner
        returns (bool)
    {
        IERC20Extended recoverableToken = IERC20Extended(_tokenAddress);
        return
            recoverableToken.transfer(
                msg.sender,
                recoverableToken.balanceOf(address(this))
            );
    }

    function setMaxTxnAmount(uint256 amount) external onlyOwner {
        maxTxnAmount = amount;
    }

    function setMaxWalletAmount(uint256 amount) external onlyOwner {
        maxWalletAmount = amount;
    }

    function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
        isFeeExempt[holder] = exempt;
    }

    function setIsLimitExempt(address holder, bool exempt) external onlyOwner {
        isLimitExmpt[holder] = exempt;
    }

    function setIsWalletExempt(address holder, bool exempt) external onlyOwner {
        isWalletExmpt[holder] = exempt;
    }

    function setLiquidityFee(uint256 _newLiquidityFee) external onlyOwner {
        liquidityFee = _newLiquidityFee;
        totalFee = liquidityFee.add(rewardFee).add(marketingFee);
        require(
            totalFee <= 15,
            "Can't be greater than 15%"
        );
    }

    function setRewardFee(uint256 _newRewardFee) external onlyOwner {
        rewardFee = _newRewardFee;
        totalFee = liquidityFee.add(rewardFee).add(marketingFee);
        require(
            totalFee <= 15,
            "Can't be greater than 15%"
        );
    }

    function setMarketingFee(uint256 _newMarketingFee) external onlyOwner {
        marketingFee = _newMarketingFee;
        totalFee = liquidityFee.add(rewardFee).add(marketingFee);
        require(
            totalFee <= 15,
            "Can't be greater than 15%"
        );
    }


    function setSwapBackSettings(bool _enabled, uint256 _amount)
        external
        onlyOwner
    {
        swapEnabled = _enabled;
        swapThreshold = _amount;
    }

    function setTargetLiquidity(uint256 _target)
        external
        onlyOwner
    {
        require(
            _target >= 20 && _target <= 50 && _target != targetLiquidity,
            "New Liqiduity target can't be lower than 20%, higher than 50% and can't be the same value as it already is"
        );
        targetLiquidity = _target;
    }

    function _calculateLiquidityRatio() private view returns (uint256) {
        uint256 tokenLiquidity = balanceOf(pair);
        return tokenLiquidity.mul(100).div(this.totalSupply());
    }
}