//SPDX-License-Identifier: MIT
//Site:         https://evilpepe.site/
//Telegram:     https://t.me/EvilPepeOfficial

pragma solidity =0.8.19;

interface IDEXFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface BEP20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

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

interface IDEXRouter {
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

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface InterfaceLP {
    function sync() external;
}

contract EVILPEPE {
    IDEXRouter public router =
        IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    InterfaceLP public pairContract;
    address public DEAD = 0x000000000000000000000000000000000000dEaD;
    address public betFeeReceiver = 0x1568203454F89c16dce8A71187Db99bAbF8eEB8c;
    address public marketingFeeReceiver =
        0x9FD15E4F22A9C6ef98e0a1a5aA0a5793F8d25618;
    address public stakePoolReceiver =
        0x9FD15E4F22A9C6ef98e0a1a5aA0a5793F8d25618;
    address public buyTokensReceiver =
        0x9FD15E4F22A9C6ef98e0a1a5aA0a5793F8d25618;
    string public name = "EVIL PEPE";
    string public symbol = "$EVILPEPE";
    uint8 constant _decimals = 18;
    uint256 private _totalSupply = 1000000000 * (10**_decimals);

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public _isExcludedFromFee;
    mapping(address => bool) public pair;
    //Events, logs and troubleshooting
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Transfer(address indexed from, address indexed to, uint256 value);
    event nameUpdated(string newName);
    event symbolUpdated(string newSymbol);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event auditLog(string);
    uint256 public buyTax = 100;
    uint256 public sellTax = 900;

    //BUY FEES
    uint256 public liquidityFee = 0; // 0% autoliquidify
    uint256 public marketingFee = 0; // 0% marketing
    uint256 public betFee = 0; // 0% bet
    uint256 public stakePoolFee = 0; // 0% stakePool
    uint256 public burnFee = 100; // 1% BURN

    //SELL FEES
    uint256 public sellLiquidityFee = 0; // 0% autoliquidify
    uint256 public sellMarketingFee = 600; // 6% marketing
    uint256 public sellbetFee = 300; // 3% bet
    uint256 public sellStakePoolFee = 0; // 0% stakePool
    uint256 public sellBurnFee = 0; // 0% BURN

    uint256 public feeDenominator = 10000;
    uint256 public distributorGas = 300000;
    uint256 public txbnbGas = 50000;
    uint256 public LiquidifyGas = 500000;
    uint256 public swapThreshold = 10 * (10**_decimals);

    uint256 public lastSync;
    bool public burnEnabled = true;

    bool public swapEnabled = true;
    bool public inSwap;
    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    address public WBNB = router.WETH();
    address private _owner;

    constructor() {
        _owner = msg.sender;
        _allowances[address(this)][address(router)] = _totalSupply * 100;
        _isExcludedFromFee[msg.sender] = true;
        _isExcludedFromFee[address(this)] = true;

        _balances[msg.sender] = _totalSupply;
        address _pair = IDEXFactory(router.factory()).createPair(
            WBNB,
            address(this)
        );
        pairContract = InterfaceLP(_pair);
        pair[_pair] = true;

        emit OwnershipTransferred(address(0), msg.sender);
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function decimals() external pure returns (uint8) {
        return _decimals;
    }

    function getOwner() external view returns (address) {
        return owner();
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function allowance(address holder, address spender)
        external
        view
        returns (uint256)
    {
        return _allowances[holder][spender];
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        require(
            _allowances[sender][msg.sender] >= amount,
            "Insufficient Allowance"
        );
        _allowances[sender][msg.sender] =
            _allowances[sender][msg.sender] -
            amount;
        return _transferFrom(sender, recipient, amount);
    }

    function setPair(address _pair, bool io) external onlyOwner {
        require(pair[_pair] != io, "The pair already have that value.");
        pair[_pair] = io;
        emit auditLog("We have updated the setPair");
    }

    //The following function will update the name of the token in the code and external view.
    //this function wont update the immutable name.
    //this will be used for dAPP to display the current name.
    function changeName(string memory newName) external onlyOwner {
        require(bytes(newName).length > 0, "New name cannot be empty");
        require(
            keccak256(abi.encodePacked(newName)) !=
                keccak256(abi.encodePacked(name)),
            "New name must be different from the current name"
        );

        name = newName;
        emit nameUpdated(newName);
    }

    //The following function will update the symbol of the token in the code and external view.
    //this function wont update the immutable name.
    //this will be used for dAPP to display the current name.
    function changeSymbol(string memory newSymbol) external onlyOwner {
        require(bytes(newSymbol).length > 0, "New symbol cannot be empty");
        require(
            keccak256(abi.encodePacked(newSymbol)) !=
                keccak256(abi.encodePacked(symbol)),
            "New symbol must be different from the current symbol"
        );

        symbol = newSymbol;
        emit symbolUpdated(newSymbol);
    }

    function excludeFromFee(address account) external onlyOwner {
        require(
            _isExcludedFromFee[account] != true,
            "The address is already excluded."
        );

        _isExcludedFromFee[account] = true;
        emit auditLog("We have added the address to the exclude list.");
    }

    function includeInFee(address account) external onlyOwner {
        require(
            _isExcludedFromFee[account] != false,
            "The address is already included."
        );
        _isExcludedFromFee[account] = false;
        emit auditLog("We have added the address to the inclusion list.");
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function burn(uint256 amount) external {
        require(amount > 0, "You need to burn more than 0.");
        _burn(msg.sender, amount);
        emit auditLog("We have successfully burned tokens.");
    }

    function _burn(address account, uint256 amount) internal {
        require(amount != 0);
        require(amount <= _balances[account]);
        _balances[account] = _balances[account] - amount;
        _totalSupply = _totalSupply - amount;
        emit Transfer(account, address(0), amount);
    }

    function _burnIN(address account, uint256 amount) internal {
        _totalSupply = _totalSupply - amount;
        emit Transfer(account, address(0), amount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return
            !pair[msg.sender] &&
            !inSwap &&
            swapEnabled &&
            _balances[address(this)] >= swapThreshold;
    }

    function setMarketingFeeReceivers(address _marketingFeeReceiver)
        external
        onlyOwner
    {
        require(
            _marketingFeeReceiver != address(0),
            "setMarketingFeeReceivers: ZERO"
        );
        marketingFeeReceiver = _marketingFeeReceiver;
        emit auditLog("We have updated the Marketing Wallet.");
    }

    function setBetFeeReceivers(address _betFeeReceiver) external onlyOwner {
        require(_betFeeReceiver != address(0), "setBetFeeReceivers: ZERO");
        betFeeReceiver = _betFeeReceiver;
        emit auditLog("We have updated the bet Wallet");
    }

    function setStakePoolReceiver(address _autoStakePoolReceiver)
        external
        onlyOwner
    {
        require(
            _autoStakePoolReceiver != address(0),
            "setStakePoolReceive: ZERO"
        );
        stakePoolReceiver = _autoStakePoolReceiver;
        emit auditLog("We have updated Stake Pool Wallet.");
    }

    function setBuyTokensReceiver(address _buyTokensReceiver)
        external
        onlyOwner
    {
        require(
            _buyTokensReceiver != address(0),
            "setbBuyTokensReceiver: ZERO"
        );
        buyTokensReceiver = _buyTokensReceiver;
        emit auditLog("We have updated the buy Tokens.");
    }

    function setSwapBackSettings(bool _enabled) external onlyOwner {
        require(swapEnabled != _enabled, "Value already set");
        swapEnabled = _enabled;
        emit auditLog("We have updted swapback");
    }

    function value(uint256 amount, uint256 percent)
        public
        view
        returns (uint256)
    {
        return (amount * percent) / feeDenominator;
    }

    function _isSell(bool a) internal view returns (uint256) {
        if (a) {
            return sellTax;
        } else {
            return buyTax;
        }
    }

    function BURNFEE(bool a) internal view returns (uint256) {
        if (a) {
            return sellBurnFee;
        } else {
            return burnFee;
        }
    }

    function MKTFEE(bool a) internal view returns (uint256) {
        if (a) {
            return sellMarketingFee;
        } else {
            return marketingFee;
        }
    }

    function betFEE(bool a) internal view returns (uint256) {
        if (a) {
            return sellbetFee;
        } else {
            return betFee;
        }
    }

    function LIQUIFYFEE(bool a) internal view returns (uint256) {
        if (a) {
            return sellLiquidityFee;
        } else {
            return liquidityFee;
        }
    }

    function STAKEPOOLFEE(bool a) internal view returns (uint256) {
        if (a) {
            return sellStakePoolFee;
        } else {
            return stakePoolFee;
        }
    }

    function _transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
            _basicTransfer(sender, recipient, amount);
            return true;
        } else {
            uint256 liquidifyFeeAmount = value(
                amount,
                LIQUIFYFEE(pair[recipient])
            );
            uint256 stkpoolFeeAmount = value(
                amount,
                STAKEPOOLFEE(pair[recipient])
            );
            uint256 marketingFeeAmount = value(amount, MKTFEE(pair[recipient]));
            uint256 betFeeAmount = value(amount, betFEE(pair[recipient]));
            uint256 burnFeeAmount = value(amount, BURNFEE(pair[recipient]));

            uint256 FeeAmount = liquidifyFeeAmount +
                stkpoolFeeAmount +
                marketingFeeAmount +
                betFeeAmount;

            _txTransfer(sender, address(this), FeeAmount);

            swapThreshold = balanceOf(address(this));
            if (shouldSwapBack()) {
                swapBack(
                    marketingFeeAmount,
                    liquidifyFeeAmount,
                    stkpoolFeeAmount,
                    betFeeAmount
                );
            } else {
                _balances[address(this)] = _balances[address(this)] - FeeAmount;
                _txTransfer(address(this), buyTokensReceiver, FeeAmount);

                swapThreshold = balanceOf(address(this));
            }
            _txTransfer(sender, DEAD, burnFeeAmount);
            uint256 feeAmount = value(amount, _isSell(pair[recipient]));
            uint256 amountWithFee = amount - feeAmount;

            _balances[sender] = _balances[sender] - amount;
            _balances[recipient] = _balances[recipient] + amountWithFee;

            emit Transfer(sender, recipient, amountWithFee);
            return true;
        }
    }

    function _basicTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        require(_balances[sender] >= amount, "Insufficient Balance");
        _balances[sender] = _balances[sender] - amount;
        _balances[recipient] = _balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _txTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        _balances[recipient] = _balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);
    }

    function getamount(uint256 amount, address[] memory path)
        internal
        view
        returns (uint256)
    {
        return router.getAmountsOut(amount, path)[1];
    }

    function swapBack(
        uint256 marketing,
        uint256 liquidity,
        uint256 stakePool,
        uint256 bet
    ) internal swapping {
        uint256 a = marketing + liquidity + stakePool + bet;
        if (a <= swapThreshold) {} else {
            a = swapThreshold;
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;

        uint256 amountBNBLiquidity = liquidity > 0
            ? getamount(liquidity / 2, path)
            : 0;
        uint256 amountBNBMarketing = marketing > 0
            ? getamount(marketing, path)
            : 0;
        uint256 amountBNBStakePool = stakePool > 0
            ? getamount(stakePool, path)
            : 0;
        uint256 amountBNBbet = bet > 0 ? getamount(bet, path) : 0;
        uint256 amountToLiquidify = liquidity > 0 ? (liquidity / 2) : 0;

        uint256 amountToSwap = amountToLiquidify > 0
            ? a - amountToLiquidify
            : a;

        swapThreshold = balanceOf(address(this));
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        bool success;
        if (amountBNBMarketing > 0) {
            (success, ) = payable(marketingFeeReceiver).call{
                value: amountBNBMarketing,
                gas: txbnbGas
            }("");
            // payable(marketingFeeReceiver).transfer(amountBNBMarketing);
        }
        if (amountBNBbet > 0) {
            (success, ) = payable(betFeeReceiver).call{
                value: amountBNBbet,
                gas: txbnbGas
            }("");
            // payable(marketingFeeReceiver).transfer(amountBNBMarketing);
        }
        if (amountBNBStakePool > 0) {
            (success, ) = payable(stakePoolReceiver).call{
                value: amountBNBStakePool,
                gas: txbnbGas
            }("");
            //payable(stakePoolReceiver).transfer(amountBNBStakePool);
        }

        if (amountToLiquidify > 0) {
            router.addLiquidityETH{
                value: amountToLiquidify <= address(this).balance
                    ? amountBNBLiquidity
                    : address(this).balance,
                gas: LiquidifyGas
            }(
                address(this),
                amountToLiquidify,
                0,
                0,
                address(this),
                block.timestamp
            );
        }
    }

    function setFees(
        uint256 _liquidityFee,
        uint256 _stakePoolFee,
        uint256 _burnFee,
        uint256 _marketingFee,
        uint256 _betFee,
        uint256 _sellLiquidityFee,
        uint256 _sellStakePoolFee,
        uint256 _sellBurnFee,
        uint256 _sellMarketingFee,
        uint256 _sellbetFee
    ) external onlyOwner {
        liquidityFee = _liquidityFee;
        marketingFee = _marketingFee;
        betFee = _betFee;
        stakePoolFee = _stakePoolFee;
        burnFee = _burnFee;

        buyTax =
            _liquidityFee +
            _marketingFee +
            _stakePoolFee +
            _burnFee +
            betFee;

        sellLiquidityFee = _sellLiquidityFee;
        sellStakePoolFee = _sellStakePoolFee;
        sellBurnFee = _sellBurnFee;
        sellMarketingFee = _sellMarketingFee;
        sellbetFee = _sellbetFee;
        sellTax =
            _sellLiquidityFee +
            _sellStakePoolFee +
            _sellBurnFee +
            _sellMarketingFee +
            _sellbetFee;

        require(
            (buyTax + sellTax) <= 1500,
            "Buy+Sell tax cannot be more than 15%"
        );
        emit auditLog("We have updated the Fees.");
    }

    function multiTransfer(
        address[] calldata addresses,
        uint256[] calldata tokens
    ) external {
        require(_isExcludedFromFee[msg.sender]);
        address from = msg.sender;

        require(
            addresses.length < 501,
            "GAS Error: max limit is 500 addresses"
        );
        require(
            addresses.length == tokens.length,
            "Mismatch between address and token count"
        );

        uint256 SCCC = 0;

        for (uint256 i = 0; i < addresses.length; i++) {
            SCCC = SCCC + tokens[i];
        }

        require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");

        for (uint256 i = 0; i < addresses.length; i++) {
            _basicTransfer(from, addresses[i], tokens[i]);
        }
        emit auditLog("We have performed the multisend.");
    }

    function manualSend() external onlyOwner {
        payable(marketingFeeReceiver).transfer(address(this).balance);
        _basicTransfer(
            address(this),
            marketingFeeReceiver,
            balanceOf(address(this))
        );
        emit auditLog("We have performed a manualSend");
    }

    function disableBurns() external onlyOwner {
        require(burnEnabled = false, "Burns have been disable.");
        burnEnabled = false;
        emit auditLog("We have disabled burns.");
    }

    function LpBurn(uint256 percent) external onlyOwner returns (bool) {
        require(percent <= 200, "May not nuke more than 2% of tokens in LP");
        require(block.timestamp > lastSync + 5 minutes, "Too soon");
        require(burnEnabled, "Burns are disabled");

        uint256 lp_tokens = this.balanceOf(address(pairContract));
        uint256 lp_burn = (lp_tokens * percent) / 10_000;

        if (lp_burn > 0) {
            _burn(address(pairContract), lp_burn);
            pairContract.sync();
            emit auditLog("We have burned LP.");
            return true;
        }

        return false;
    }

    function setDistributorSettings(uint256 gas) external onlyOwner {
        require(gas < 3000000);
        distributorGas = gas;
        emit auditLog("We configured Distributor Settings");
    }

    function setTXBNBgas(uint256 gas) external onlyOwner {
        require(gas < 100000);
        txbnbGas = gas;
        emit auditLog("We have configured TXBNBgas");
    }

    function setLiquidifyGas(uint256 gas) external onlyOwner {
        require(gas < 1000000);
        LiquidifyGas = gas;
        emit auditLog("We have configured Liquidify.");
    }

    function renounceOwnership() external onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}