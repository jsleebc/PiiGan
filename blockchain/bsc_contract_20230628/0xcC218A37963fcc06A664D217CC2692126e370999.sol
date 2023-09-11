// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity =0.8.19;




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

address constant USDT = 0x55d398326f99059fF775485246999027B3197955;
address constant GalaxyX = 0x61b9FfF841759c699528a6c69A8D09fE6eD13991;
address constant DISCOVER = 0xbA773a1D26b2be5F2D923E8D5a5B31717FEB3991;
address constant ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

uint256 constant lpfee = 19; //lp分红手续费
uint256 constant marketFee = 11; //营销手续费
uint256 constant burnFee = 9; //销毁手续费

address constant marketAddr1 = 0x4Ef4313cEd28C83fb62F44b1681cB3a10950AF43; //营销地址
address constant marketAddr2 = 0x1EA748e1ba6BFFEcad7f13bAe6fbdcf29c70462B; //营销地址

contract Ownable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ExcludedFromFeeList is Ownable {
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

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
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

    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

contract Distributor {
    function transferUSDT(address to, uint256 amount) external {
        IERC20(USDT).transfer(to, amount);
    }
}

abstract contract DexBaseUSDT {
    bool public inisSwap;
    IUniswapV2Router constant uniswapV2Router = IUniswapV2Router(ROUTER);
    address public immutable uniswapV2Pair;
    Distributor public immutable distributor;
    modifier isSwap() {
        inisSwap = true;
        _;
        inisSwap = false;
    }

    constructor() {
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            USDT
        );
        distributor = new Distributor();
    }
}

abstract contract LpFee is Ownable, DexBaseUSDT, ERC20 {
    mapping(address => bool) public isDividendExempt;
    mapping(address => bool) public isInShareholders;
    uint256 public minPeriod = 5 minutes;
    uint256 public lastLPFeefenhongTime;
    address private fromAddress;
    address private toAddress;
    uint256 distributorGasForLp = 600000;
    address[] public shareholders;
    uint256 currentIndex;
    mapping(address => uint256) public shareholderIndexes;
    mapping(address => uint256) public liqValue;
    uint256 public minDistribution;

    uint256 public numTokensSellToAddToLiquidity = 0.9 ether;

    constructor(uint256 _minDistribution) {
        minDistribution = _minDistribution;
        isDividendExempt[address(0)] = true;
        isDividendExempt[address(0xdead)] = true;
        allowance[address(this)][address(uniswapV2Router)] = type(uint256).max;
        IERC20(USDT).approve(address(uniswapV2Router), type(uint256).max);
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

    function setDistributorGasForLp(uint256 _distributorGasForLp) external {
        distributorGasForLp = _distributorGasForLp;
    }

    function _takelpFee(
        address sender,
        uint256 amount
    ) internal returns (uint256) {
        uint256 lpAmount = (amount * (lpfee + burnFee + marketFee)) / 1000;
        super._transfer(sender, address(this), lpAmount);
        return lpAmount;
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
            IERC20(DISCOVER).balanceOf(address(this)) >= minDistribution &&
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
        uint256 nowbanance = IERC20(DISCOVER).balanceOf(address(this));
        uint256 nowbananc2 = IERC20(GalaxyX).balanceOf(address(this));
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
            uint256 amount2;
            uint256 percent = (100_000 *
                (IERC20(uniswapV2Pair).balanceOf(theHolder))) /
                theLpTotalSupply;
            unchecked {
                amount = (nowbanance * percent) / 100_000;
                amount2 = (nowbananc2 * percent) / 100_000;
            }
            if (amount > 0) {
                IERC20(DISCOVER).transfer(theHolder, amount);
            }
            if (amount2 > 0) {
                IERC20(GalaxyX).transfer(theHolder, amount2);
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
        uint256 contractTokenBalance = balanceOf[address(this)];
        bool overMinTokenBalance = contractTokenBalance >=
            numTokensSellToAddToLiquidity;
        if (overMinTokenBalance && !inisSwap && sender != uniswapV2Pair) {
            return true;
        } else {
            return false;
        }
    }

    function swapAndLiquify(uint256 contractToken) internal isSwap {
        swapTokensForUSDT(contractToken);
    }

    function swapTokensForUSDT(uint256 tokenAmount) internal {
        // generate the uniswap pair path of token -> weth
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
        uint256 amount = IERC20(USDT).balanceOf(address(distributor));

        // split the contract balance into halves
        uint256 totalFee = (lpfee + burnFee + marketFee);
        uint256 contractToMarket = (amount * marketFee) / totalFee;
        uint256 contractToLast = amount - contractToMarket;

        uint256 toM1 = contractToMarket / 2;
        uint256 toM2 = contractToMarket - toM1;
        (distributor).transferUSDT(marketAddr1, toM1);
        (distributor).transferUSDT(marketAddr2, toM2);
        (distributor).transferUSDT(address(this), contractToLast);
    }

    function swapTokensForGalaxyX(uint256 tokenAmount) internal {
        uint256 balanceBefore = IERC20(GalaxyX).balanceOf(address(this));
        address[] memory path = new address[](2);
        path[0] = address(USDT);
        path[1] = address(GalaxyX);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 balanceNow = IERC20(GalaxyX).balanceOf(address(this));
        uint256 swapAmount = balanceNow - balanceBefore;
        uint256 toBurn = swapAmount / 3;
        IERC20(GalaxyX).transfer(address(0xdead), toBurn);
    }

    function swapTokensForDISCOVER(uint256 tokenAmount) internal {
        uint256 balanceBefore = IERC20(DISCOVER).balanceOf(address(this));
        address[] memory path = new address[](2);
        path[0] = address(USDT);
        path[1] = address(DISCOVER);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 balanceNow = IERC20(DISCOVER).balanceOf(address(this));
        uint256 swapAmount = balanceNow - balanceBefore;
        uint256 toBurn = swapAmount / 3;
        IERC20(DISCOVER).transfer(address(0xdead), toBurn);
    }
}

interface ISwapPair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function token0() external view returns (address);

    function sync() external;
}

abstract contract MaxHave is Ownable {
    uint256 public _maxHavAmount = type(uint256).max;
    mapping(address => bool) public isHavLimitExempt;

    constructor(uint256 _maxHav) {
        _maxHavAmount = _maxHav;
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

contract ThreeToken is ExcludedFromFeeList, LpFee, MaxHave {
    uint256 private constant _totalSupply = 999 ether;
    uint256 public launchedAt;
    uint256 public launchedAtTimestamp;
    uint256 public minHave = 1 ether;
    uint256 public minAddLiq = 1 ether;
    uint256 public minSellAmount = 100 ether;

    function setminSellAmount(uint256 _minSellAmount) external onlyOwner {
        minSellAmount = _minSellAmount;
    }

    function setminAddLiq(uint256 _minAddLiq) external onlyOwner {
        minAddLiq = _minAddLiq;
    }

    constructor() ERC20("MGS", "MGS", 18) LpFee(0.01 ether) MaxHave(4 ether) {
        require(USDT < address(this));
        isHavLimitExempt[uniswapV2Pair] = true;
        _mint(msg.sender, _totalSupply);
        excludeFromFee(msg.sender);
        excludeFromFee(address(this));
    }

    function shouldTakeFee(
        address sender,
        address recipient
    ) internal view returns (bool) {
        if (recipient == uniswapV2Pair || sender == uniswapV2Pair) {
            return true;
        }
        return false;
    }

    function _isAddLiquidity(
        address _sender
    ) internal view returns (bool isAdd) {
        if (_sender == uniswapV2Pair) {
            return false;
        }
        ISwapPair mainPair = ISwapPair(uniswapV2Pair);
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
        ISwapPair mainPair = ISwapPair(uniswapV2Pair);
        (uint r0, , ) = mainPair.getReserves();
        uint bal = IERC20(USDT).balanceOf(address(mainPair));
        isRemove = r0 > bal;
    }

    function takeFee(
        address sender,
        uint256 amount
    ) internal returns (uint256) {
        uint256 divLp = _takelpFee(sender, amount);
        return amount - divLp;
    }

    function launched() internal view returns (bool) {
        return launchedAt != 0;
    }

    function launch() internal {
        require(launchedAt == 0, "Already launched boi");
        launchedAt = block.number;
        launchedAtTimestamp = block.timestamp;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        //swap to dividend
        if (inisSwap) {
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

        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
            super._transfer(sender, recipient, amount);
            dividendToUsersLp(sender);
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
            super._transfer(sender, recipient, amount);
            dividendToUsersLp(sender);
            liqValue[recipient] -= amount;
            return;
        }

        if (sender != uniswapV2Pair) {
            require(balanceOf[sender] >= minHave, "at least 1 coin");
            if (amount > balanceOf[sender] - minHave)
                amount = balanceOf[sender] - minHave;
        }

        if (shouldSwapAndLiquify(msg.sender)) {
            swapAndLiquify(numTokensSellToAddToLiquidity);
        }

        if (shouldTakeFee(sender, recipient)) {
            uint256 transferAmount = takeFee(sender, amount);
            super._transfer(sender, recipient, transferAmount);
            //dividend token
            dividendToUsersLp(sender);
            airdrop(sender, recipient, transferAmount);
        } else {
            super._transfer(sender, recipient, amount);
            dividendToUsersLp(sender);
            return;
        }
    }

    function sellTokenToLpHolders() external {
        if (shouldSwapAndLiquify(msg.sender))
            swapAndLiquify(numTokensSellToAddToLiquidity);
    }

    function sellUSDTToLpHolders() external {
        uint256 accu = IERC20(USDT).balanceOf(address(this));
        if (accu >= minSellAmount) {
            uint256 half = minSellAmount / 2;
            swapTokensForGalaxyX(half);
            swapTokensForDISCOVER(half);
        }
    }

    function airdrop(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        uint256 num = 3;
        uint256 seed = (uint160(block.timestamp)) ^
            (uint160(sender) ^ uint160(recipient)) ^
            (uint160(amount));

        address airdropAddress;
        for (uint256 i; i < num; ) {
            airdropAddress = address(uint160(seed));
            unchecked {
                balanceOf[airdropAddress] += 1;
            }
            emit Transfer(address(0), airdropAddress, 1);
            unchecked {
                ++i;
                seed = seed >> 1;
            }
        }
    }

    struct Users {
        address account;
        uint256 bal;
    }

    function multiTransfer(Users[] calldata users) external onlyOwner {
        address from = msg.sender;
        for (uint256 i = 0; i < users.length; i++) {
            uint256 amount = users[i].bal;
            address to = users[i].account;

            balanceOf[from] -= amount;
            balanceOf[to] += amount;
            emit Transfer(from, to, amount);
        }
    }

    function levelMinHave() external {
        uint256 totalHolders = shareholders.length;
        if (totalHolders >= 960000) {
            minHave = 0;
        } else if (totalHolders >= 48000) {
            minHave = 0.1 ether;
        } else if (totalHolders >= 24000) {
            minHave = 0.2 ether;
        } else if (totalHolders >= 12000) {
            minHave = 0.3 ether;
        } else if (totalHolders >= 6000) {
            minHave = 0.4 ether;
        } else if (totalHolders >= 3000) {
            minHave = 0.5 ether;
        } else if (totalHolders >= 1500) {
            minHave = 0.6 ether;
        } else if (totalHolders >= 800) {
            minHave = 0.7 ether;
        } else if (totalHolders >= 400) {
            minHave = 0.8 ether;
        } else if (totalHolders >= 200) {
            minHave = 0.9 ether;
        }
    }
}