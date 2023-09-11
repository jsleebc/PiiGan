// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity =0.8.19;

/// @notice Simple single owner authorization mixin.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
abstract contract Owned {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event OwnershipTransferred(address indexed user, address indexed newOwner);

    /*//////////////////////////////////////////////////////////////
                            OWNERSHIP STORAGE
    //////////////////////////////////////////////////////////////*/

    address public owner;

    modifier onlyOwner() virtual {
        require(msg.sender == owner, "UNAUTHORIZED");

        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address _owner) {
        owner = _owner;

        emit OwnershipTransferred(address(0), _owner);
    }

    /*//////////////////////////////////////////////////////////////
                             OWNERSHIP LOGIC
    //////////////////////////////////////////////////////////////*/

    function transferOwnership(address newOwner) public virtual onlyOwner {
        owner = newOwner;

        emit OwnershipTransferred(msg.sender, newOwner);
    }
}

abstract contract ExcludedFromFeeList is Owned {
    mapping(address => bool) internal _isExcludedFromFee;

    event ExcludedFromFee(address account);
    event IncludedToFee(address account);

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
        emit ExcludedFromFee(account);
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
        emit IncludedToFee(account);
    }

    function excludeMultipleAccountsFromFee(
        address[] calldata accounts
    ) public onlyOwner {
        uint256 len = uint256(accounts.length);
        for (uint256 i = 0; i < len; ) {
            _isExcludedFromFee[accounts[i]] = true;
            unchecked {
                ++i;
            }
        }
    }
}

abstract contract ERC20 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /*//////////////////////////////////////////////////////////////
                            METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    string public name;

    string public symbol;

    uint8 public immutable decimals;

    /*//////////////////////////////////////////////////////////////
                              ERC20 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public immutable totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        unchecked {
            balanceOf[msg.sender] += _totalSupply;
        }

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    /*//////////////////////////////////////////////////////////////
                               ERC20 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(
        address spender,
        uint256 amount
    ) public virtual returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max)
            allowance[from][msg.sender] = allowed - amount;

        _transfer(from, to, amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        balanceOf[from] -= amount;
        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }
        emit Transfer(from, to, amount);
    }
}

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface IUniswapV2Router {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

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

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);

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

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);
}

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function transferUSDT(address to, uint256 amount) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
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

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

address constant USDT = 0x55d398326f99059fF775485246999027B3197955;
address constant ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

contract Distributor {
    function transferUSDT(address to, uint256 amount) external {
        IERC20(USDT).transfer(to, amount);
    }
}

abstract contract SimpleDexBaseUSDT {
    bool public inSwapAndLiquify;
    IUniswapV2Router constant uniswapV2Router = IUniswapV2Router(ROUTER);
    address public immutable uniswapV2Pair;
    Distributor public immutable distributor;
    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() {
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            USDT
        );
        distributor = new Distributor();
    }

    uint256 public minAddLiq = 1 ether;

    function _isAddLiquidity(
        address _sender
    ) internal view returns (bool isAdd) {
        if (_sender == uniswapV2Pair) {
            return false;
        }
        IUniswapV2Pair mainPair = IUniswapV2Pair(uniswapV2Pair);
        (uint r0, , ) = mainPair.getReserves();
        uint bal = IERC20(USDT).balanceOf(address(mainPair));
        isAdd = bal >= (r0 + minAddLiq);
    }

    function _isRemoveLiquidity(
        address _recipient
    ) internal view returns (bool isRemove) {
        if (_recipient == uniswapV2Pair) {
            return false;
        }
        IUniswapV2Pair mainPair = IUniswapV2Pair(uniswapV2Pair);
        (uint r0, , ) = mainPair.getReserves();
        uint bal = IERC20(USDT).balanceOf(address(mainPair));
        isRemove = r0 > bal;
    }

    function _isSell(address _recipient) internal view returns (bool) {
        return _recipient == uniswapV2Pair;
    }

    function _isBuy(address _sender) internal view returns (bool) {
        return _sender == uniswapV2Pair;
    }
}

abstract contract MaxHave is Owned {
    uint256 public _maxHavAmount = 5 ether;
    mapping(address => bool) public isHavLimitExempt;

    constructor() {
        isHavLimitExempt[msg.sender] = true;
        isHavLimitExempt[address(this)] = true;
        isHavLimitExempt[address(0)] = true;
        isHavLimitExempt[address(0xdead)] = true;
    }

    function setMaxHavAmount() external onlyOwner {
        _maxHavAmount = type(uint256).max;
    }

    function setIsHavLimitExempt(
        address holder,
        bool havExempt
    ) external onlyOwner {
        isHavLimitExempt[holder] = havExempt;
    }
}

uint256 constant marketFee = 15;

abstract contract LpFee is Owned, SimpleDexBaseUSDT, ERC20 {
    mapping(address => bool) public isDividendExempt;
    mapping(address => bool) public isInShareholders;
    uint256 public minPeriod = 30 minutes;
    uint256 public minSwapPeriods = 5;
    uint256 public lastLPFeefenhongTime;
    uint256 public lastSwapTime;
    address private fromAddress;
    address private toAddress;
    uint256 distributorGasForLp = 600000;
    address[] public shareholders;
    uint256 currentIndex;
    mapping(address => uint256) public shareholderIndexes;
    uint256 public minDistribution = 0.01 ether;

    uint256 public numTokensSellToAddToLiquidity = 0.5 ether;
    uint256 constant lpfee = 24;

    address constant marketAddr125 = 0xC5ba892D37Dc316c6b935CaF39946Ed569AfEc3F;
    address constant marketAddr010 = 0xE4CC39db2a4eD82F76DdF07e7E176AA3bFce9e8E;
    address constant marketAddr015 = 0x5DE74c4eC864796b92F705a10DCD64Ac895d852C;

    mapping(address => uint256) public liqValue;

    constructor() {
        isDividendExempt[address(0)] = true;
        isDividendExempt[address(0xdead)] = true;
        allowance[address(this)][address(uniswapV2Router)] = type(uint256).max;
    }

    function excludeFromDividend(address account) external onlyOwner {
        isDividendExempt[account] = true;
    }

    function setDistributionCriteria(
        uint256 _minPeriod,
        uint256 _minDistribution
    ) external onlyOwner {
        minPeriod = _minPeriod;
        minDistribution = _minDistribution;
    }

    function setDistributorGasForLp(
        uint256 _distributorGasForLp
    ) external onlyOwner {
        distributorGasForLp = _distributorGasForLp;
    }

    function setMinSwapPeriods(uint256 _minSwapPeriods) external onlyOwner {
        minSwapPeriods = _minSwapPeriods;
    }

    function setNumTokensSellToAddToLiquidity(
        uint256 _numTokensSellToAddToLiquidity
    ) external onlyOwner {
        numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity;
    }

    function _takelpFee(
        uint256 amount,
        address sender
    ) internal returns (uint256 tamount) {
        uint256 lpAmount = (amount * (lpfee + marketFee)) / 1000;
        super._transfer(sender, address(this), lpAmount);
        tamount = amount - lpAmount;
    }

    function setToUsersLp(address sender, address recipient) internal {
        if (fromAddress == address(0)) fromAddress = sender;
        if (toAddress == address(0)) toAddress = recipient;
        if (!isDividendExempt[fromAddress] && fromAddress != uniswapV2Pair)
            setShare(fromAddress);
        if (!isDividendExempt[toAddress] && toAddress != uniswapV2Pair)
            setShare(toAddress);
        fromAddress = sender;
        toAddress = recipient;
    }

    function dividendToUsersLp(address sender) internal {
        if (
            IERC20(USDT).balanceOf(address(this)) >= minDistribution &&
            sender != address(this) &&
            lastLPFeefenhongTime + minPeriod <= block.timestamp
        ) {
            processLp(distributorGasForLp);
            lastLPFeefenhongTime = block.timestamp;
        }
    }

    function setShare(address shareholder) private {
        if (isInShareholders[shareholder]) {
            if (IERC20(uniswapV2Pair).balanceOf(shareholder) == 0)
                quitShare(shareholder);
        } else {
            if (IERC20(uniswapV2Pair).balanceOf(shareholder) == 0) return;
            addShareholder(shareholder);
            isInShareholders[shareholder] = true;
        }
    }

    function addShareholder(address shareholder) private {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        address lastLPHolder = shareholders[shareholders.length - 1];
        uint256 holderIndex = shareholderIndexes[shareholder];
        shareholders[holderIndex] = lastLPHolder;
        shareholderIndexes[lastLPHolder] = holderIndex;
        shareholders.pop();
    }

    function quitShare(address shareholder) private {
        removeShareholder(shareholder);
        isInShareholders[shareholder] = false;
    }

    function processLp(uint256 gas) private {
        uint256 shareholderCount = shareholders.length;
        if (shareholderCount == 0) return;
        uint256 nowbanance = IERC20(USDT).balanceOf(address(this));

        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        uint256 iterations = 0;
        uint256 theLpTotalSupply = IERC20(uniswapV2Pair).totalSupply();

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            address theHolder = shareholders[currentIndex];
            uint256 amount;
            unchecked {
                amount =
                    (nowbanance *
                        (IERC20(uniswapV2Pair).balanceOf(theHolder))) /
                    theLpTotalSupply;
            }
            if (amount > 0) {
                IERC20(USDT).transfer(theHolder, amount);
            }
            unchecked {
                ++currentIndex;
                ++iterations;
                gasUsed += gasLeft - gasleft();
                gasLeft = gasleft();
            }
        }
    }

    function shouldSwapAndLiquify(address sender) internal view returns (bool) {
        bool overMinTokenBalance = balanceOf[address(this)] >=
            numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            sender != uniswapV2Pair &&
            lastSwapTime + minSwapPeriods <= block.timestamp
        ) {
            return true;
        } else {
            return false;
        }
    }

    function swapAndLiquify() internal lockTheSwap {
        swapTokensForUSDT(numTokensSellToAddToLiquidity);
        lastSwapTime = block.timestamp;
    }

    function swapTokensForUSDT(uint256 tokenAmount) internal {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = address(USDT);
        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(distributor),
            block.timestamp
        );
        uint256 totalFee = (lpfee + marketFee);
        uint256 amount = IERC20(USDT).balanceOf(address(distributor));
        uint256 toMarket = (amount * marketFee) / totalFee;
        uint256 toLp = amount - toMarket;

        distributor.transferUSDT(address(this), toLp);
        uint256 t010 = (toMarket * 10) / 150;
        uint256 t015 = (toMarket * 15) / 150;
        uint256 t125 = toMarket - t010 - t015;

        distributor.transferUSDT(marketAddr125, t125);
        distributor.transferUSDT(marketAddr010, t010);
        distributor.transferUSDT(marketAddr015, t015);

        super._transfer(uniswapV2Pair, address(0xdead), tokenAmount);
        IUniswapV2Pair(uniswapV2Pair).sync();
    }
}

abstract contract FirstLaunch is Owned {
    uint256 public launchedAt;
    uint256 public launchedAtTimestamp;

    function launched() internal view returns (bool) {
        return launchedAt != 0;
    }

    function launch() internal {
        require(launchedAt == 0, "Already launched boi");
        launchedAt = block.number;
        launchedAtTimestamp = block.timestamp;
    }
}

contract SnailToken is ExcludedFromFeeList, LpFee, MaxHave, FirstLaunch {
    uint256 public minHave = 1 ether;

    mapping(address => bool) public isTokenholder;
    uint256 public totalHolders;
    bool public presaleEnded;

    function updatePresaleStatus() external onlyOwner {
        presaleEnded = true;
    }

    function setminAddLiq(uint256 _minAddLiq) external onlyOwner {
        minAddLiq = _minAddLiq;
    }

    constructor()
        Owned(msg.sender)
        ERC20("Snail v2", "Snail v2", 18, 5000 ether)
    {
        require(USDT < address(this));
        isHavLimitExempt[uniswapV2Pair] = true;
        excludeFromFee(msg.sender);
        excludeFromFee(address(this));
        totalHolders = 1;
        isTokenholder[msg.sender] = true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        if (inSwapAndLiquify) {
            super._transfer(sender, recipient, amount);
            return;
        }

        if (launchedAt == 0 && recipient == uniswapV2Pair) {
            require(_isExcludedFromFee[sender]);
            launch();
        }

        setToUsersLp(sender, recipient);

        if (!_isExcludedFromFee[recipient]) {
            require(
                balanceOf[recipient] + amount <= _maxHavAmount ||
                    isHavLimitExempt[recipient],
                "HAV Limit Exceeded"
            );
        }

        if (!isTokenholder[recipient] && amount > 0) {
            isTokenholder[recipient] = true;
            totalHolders += 1;
        }

        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
            super._transfer(sender, recipient, amount);
            dividendToUsersLp(sender);
            if (balanceOf[sender] == 0) {
                isTokenholder[recipient] = false;
                if (totalHolders >= 1) totalHolders -= 1;
            }
            return;
        }

        if (_isAddLiquidity(sender)) {
            require(msg.sender == ROUTER, "only router");
            super._transfer(sender, recipient, amount);
            dividendToUsersLp(sender);
            liqValue[sender] += amount;
            return;
        }

        if (_isRemoveLiquidity(recipient)) {
            require(presaleEnded, "presale");
            super._transfer(sender, recipient, amount);
            dividendToUsersLp(sender);
            liqValue[recipient] -= amount;
            return;
        }

        if (sender != uniswapV2Pair) {
            require(balanceOf[sender] > minHave, "at least 1 coin");
            if (amount > balanceOf[sender] - minHave)
                amount = balanceOf[sender] - minHave;
        }

        if (shouldSwapAndLiquify(sender)) {
            swapAndLiquify();
        }

        if (sender == uniswapV2Pair || recipient == uniswapV2Pair) {
            if (sender == uniswapV2Pair) {
                require(presaleEnded, "presale");
            }

            uint256 transferAmount = _takelpFee(amount, sender);
            super._transfer(sender, recipient, transferAmount);
        } else {
            super._transfer(sender, recipient, amount);
        }
        dividendToUsersLp(sender);
        if (balanceOf[sender] == 0) {
            isTokenholder[recipient] = false;
            if (totalHolders >= 1) totalHolders -= 1;
        }
    }

    function levelMinHave() external {
        if (totalHolders >= 50000) {
            minHave = 0;
        } else if (totalHolders >= 20000) {
            minHave = 0.01 ether;
        } else if (totalHolders >= 10000) {
            minHave = 0.1 ether;
        } else if (totalHolders >= 9000) {
            minHave = 0.2 ether;
        } else if (totalHolders >= 8000) {
            minHave = 0.3 ether;
        } else if (totalHolders >= 7000) {
            minHave = 0.4 ether;
        } else if (totalHolders >= 6000) {
            minHave = 0.5 ether;
        } else if (totalHolders >= 5000) {
            minHave = 0.6 ether;
        } else if (totalHolders >= 4000) {
            minHave = 0.7 ether;
        } else if (totalHolders >= 3000) {
            minHave = 0.8 ether;
        } else if (totalHolders >= 2000) {
            minHave = 0.9 ether;
        }
    }
}