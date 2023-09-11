{"chinPoke35 - ETH Main.sol":{"content":"// SPDX-License-Identifier: Unlicensed\npragma solidity 0.8.20;\n\n/**\n\nCHINPOKEMON TEST v35\n\n*/\n\nimport \"./IERC20.sol\";\nimport \"./Context.sol\";\nimport \"./Ownable.sol\";\n\ninterface IUniswapV2Factory {\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n}\n\ninterface IUniswapV2Pair {\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n}\n\ninterface IUniswapV2Router {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n\ncontract ChinPokemon35 is Context, IERC20, Ownable {\n\n    struct RValuesStruct {\n        uint256 rAmount;\n        uint256 rTransferAmount;\n        uint256 rReflectionFee;\n        uint256 rMarketingFee;\n    }\n\n    struct TValuesStruct {\n        uint256 tTransferAmount;\n        uint256 tReflectionFee;\n        uint256 tMarketingFee;\n    }\n\n    struct ValuesStruct {\n        uint256 rAmount;\n        uint256 rTransferAmount;\n        uint256 rReflectionFee;\n        uint256 rMarketingFee;\n        uint256 tTransferAmount;\n        uint256 tReflectionFee;\n        uint256 tMarketingFee;\n    }\n\n    mapping (address =\u003e uint256) private _rOwned;\n    mapping (address =\u003e uint256) private _tOwned;\n    \n    mapping (address =\u003e bool)    private _isExcludedFromFee;\n    mapping (address =\u003e bool)    private _isExcluded; // should be as low as possible to keep transactions fees low\n    mapping (address =\u003e bool)    private _isContractAdmin;\n\tmapping (address =\u003e bool)    private _isContractManager;\n\n    mapping (address =\u003e bool)    public isAntiBotDistribution;\n    mapping (address =\u003e bool)    public isWhitelisted;\n    mapping (address =\u003e bool)    public automatedMarketMakerPairs;\n    mapping (address =\u003e uint256) public userTransferTax;\n\n    mapping (address =\u003e mapping (address =\u003e uint256)) private _allowances;\n\t\t\t \n    uint256 private constant MAX = ~uint256(0);\n    uint256 private constant _tTotal = 1e10 * 10 ** _decimals; // 10 Billion Tokens\n\n    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n    uint256 private _tReflectionFeeTotal;\n    uint256 private _numTokensSwapForMarketing = 3e3 * 10 ** _decimals;\n\n    uint256 public maxTxAmount = _tTotal / 100;\n    uint256 public marketingFeeTokensCounter = 0;\n\n    uint8 private constant _decimals = 18;\n\n    uint8 public reflectionFeeSell = 1;\n    uint8 public reflectionFeeBuy = 1;\n    uint8 public marketingFeeSell = 4;\n    uint8 public marketingFeeTransfer = 1;\n    uint8 public transferFeeRatio = 100;\n\n    string private constant _name = \"CHINPOKEMON35TEST\";\n    string private constant _symbol = \"CHINKO35TEST\";\n\n    address public constant WBTC = 0xC04B0d3107736C32e19F1c62b2aF67BE61d63a05;\n\n    address public immutable uniswapV2Pair;\n\n    address public marketingFeeWallet = 0x21F0C38DC1dC10da34eADb93Ddc72A8CBf01adc8;\n    address public swapTokenAddress = WBTC; //Default to WBTC\n\n    address[] private _excluded;\n\n    IUniswapV2Router public immutable uniswapV2Router;\n\n    bool private _inMarketingSellSwap = false;\n    \n    bool public marketingConvertToToken = true;\n    bool public fairLaunchStarted = false;\n    bool public fairLaunchCompleted = false;\n\n    event ExcludeFromReward(address account);\n    event AccountAntiBotDistribution(address account, bool status);\n    event MarketingTokensSwapped(uint256 amount);\n    event ContractManagerChange(address account, bool status);\n    event ContractAdminChange(address account, bool status);\n    event WhitelistedStatus(address account, bool status);\n    event FeesUpdated(uint8 reflectionFeeBuy, uint8 reflectionFeeSell, uint8 marketingFeeSell, uint8 marketingFeeTransfer);\n    event ChangeSwapToken(address newSwapToken);\n    event ChangeMarketingWallet(address newAddress);\n    event SetMaxTx(uint256 amount);\n    event FairlaunchStarted(bool);\n    event FairlaunchCompleted(bool);\n    event SetMarketingConvertToToken(bool status);\n    event SetSwapForMarketing(uint256 amount);\n    event ChangeUserTransferTax(address user, uint256 amount);\n    event ChangeTransferFeeRatio(uint8 amount);\n    event SetAMM(address pair, bool status);\n    event ETHRecovered(uint256 amount);\n    event ERC20Rescued(address tokenAddress, uint256 amount);\n \n    modifier lockTheSwap {\n        _inMarketingSellSwap = true;\n        _;\n        _inMarketingSellSwap = false;\n    }\n\n    modifier contractAdmin() {\n        require(isContractAdmin(_msgSender())  || _isOwner(), \"Admin: caller is not a contract Administrator\");\n        _;\n    }\n\n    modifier contractManager() {\n        require(isContractManager(_msgSender())  || _isOwner(), \"Manager: caller is not a contract Manager\");\n        _;\n    }\n\n    constructor () {\n        _rOwned[_msgSender()] = _rTotal;\n \n        IUniswapV2Router _uniswapV2Router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);  // Uniswap V2\n        // Create a uniswap pair for this new token\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\n        //.createPair(address(this), _uniswapV2Router.WETH9());\n        .createPair(WBTC, address(this));\n\n        _allowances[address(this)][address(_uniswapV2Router)] = type(uint256).max;\n        automatedMarketMakerPairs[uniswapV2Pair] = true;\n\n        // set the rest of the contract variables\n        uniswapV2Router = _uniswapV2Router;\n\n        //exclude owner and this contract from fee\n        _isExcludedFromFee[owner()] = true;\n        _isExcludedFromFee[address(this)] = true;\n\n        _isContractAdmin[owner()] = true;\n        _isContractManager[owner()] = true;                                \n        \n        emit Transfer(address(0), _msgSender(), _tTotal);\n    }\n\n    function name() external pure returns (string memory) {\n        return _name;\n    }\n\n    function symbol() external pure returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() external pure returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() external pure override returns (uint256) {\n        return _tTotal;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        if (_isExcluded[account]) return _tOwned[account];\n        return tokenFromReflection(_rOwned[account]);\n    }\n\n    function allowance(address owner, address spender) external view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function approve(address spender, uint256 amount) external override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\n        require(_allowances[sender][_msgSender()] \u003e= amount, \"ERC20: transfer amount exceeds allowance\");\n        _transfer(sender, recipient, amount);\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {\n        require(_allowances[_msgSender()][spender] \u003e= subtractedValue, \"ERC20: decreased allowance below zero\");\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);\n        return true;\n    }\n\n    function isExcludedFromReward(address account) external view returns (bool) {\n        return _isExcluded[account];\n    }\n\n    function totalReflectionFees() external view returns (uint256) {\n        return _tReflectionFeeTotal;\n    }\n\n    /**\n     * @dev Returns the Number of tokens in contract that are needed to be reached before swapping to Set Token and sending to Marketing Wallet.\n     */\n    function numTokensSwapForMarketing() external view returns (uint256) {\n        return _numTokensSwapForMarketing;\n    }\n\n    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {\n        require(rAmount \u003c= _rTotal, \"Amount must be less than total reflections\");\n        uint256 currentRate =  _getRate();\n        return rAmount / currentRate;\n    }\n\n    function excludeFromReward(address account) external contractManager() {\n        require(account != address(uniswapV2Router), \u0027We can not exclude Uniswap router.\u0027);\n        require(!_isExcluded[account], \"Account already excluded\");\n        require(_excluded.length \u003c 100, \"Excluded list is too long\");\n        if(_rOwned[account] \u003e 0) {\n            _tOwned[account] = tokenFromReflection(_rOwned[account]);\n        }\n        _isExcluded[account] = true;\n        _excluded.push(account);\n\n        emit ExcludeFromReward(account);\n    }\n\n    //to recieve ETH from uniswapV2Router when swapping\n    receive() external payable {}\n\n    function _getValues(uint256 tAmount, uint256 tReflectionFee, uint256 tMarketingFee) private view returns (ValuesStruct memory) {\n        TValuesStruct memory tvs = _getTValues(tAmount, tReflectionFee, tMarketingFee);\n        RValuesStruct memory rvs = _getRValues(tAmount, tvs.tReflectionFee, tvs.tMarketingFee, _getRate()) ;\n\n        return ValuesStruct(\n            rvs.rAmount,\n            rvs.rTransferAmount,\n            rvs.rReflectionFee,\n            rvs.rMarketingFee,\n            tvs.tTransferAmount,\n            tvs.tReflectionFee,\n            tvs.tMarketingFee\n        );\n    }\n\n    function _getTValues(uint256 tAmount, uint256 _tReflectionFee, uint256 _tMarketingFee) private pure returns (TValuesStruct memory) {\n        uint256 tReflectionFee = _tReflectionFee;\n        uint256 tMarketingFee = _tMarketingFee;\n        \n        uint256 tTransferAmount = tAmount - tReflectionFee - tMarketingFee;\n        return TValuesStruct(tTransferAmount, tReflectionFee, tMarketingFee);\n    }\n\n    function _getRValues(uint256 tAmount, uint256 tReflectionFee, uint256 tMarketingFee, uint256 currentRate) private pure returns (RValuesStruct memory) {\n        uint256 rAmount = tAmount * currentRate;\n        uint256 rReflectionFee = tReflectionFee * currentRate;\n        uint256 rMarketingFee = tMarketingFee * currentRate;\n       \n        uint256 rTransferAmount = rAmount - rReflectionFee - rMarketingFee;\n        return RValuesStruct(rAmount, rTransferAmount, rReflectionFee, rMarketingFee);\n    }\n\n    function _getRate() private view returns(uint256) {\n        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n        return rSupply / tSupply;\n    }\n\n    function _getCurrentSupply() private view returns(uint256, uint256) {\n        uint256 rSupply = _rTotal;\n        uint256 tSupply = _tTotal;\n        for (uint256 i = 0; i \u003c _excluded.length; i++) {\n            if (_rOwned[_excluded[i]] \u003e rSupply || _tOwned[_excluded[i]] \u003e tSupply) return (_rTotal, _tTotal);\n            rSupply = rSupply - _rOwned[_excluded[i]];\n            tSupply = tSupply - _tOwned[_excluded[i]];\n        }\n        if (rSupply \u003c _rTotal / _tTotal) return (_rTotal, _tTotal);\n        return (rSupply, tSupply);\n    }\n\n    function _getRandomNumber(uint256 inputValue) private view returns (uint256) {\n        // Generate a random number using keccak256, block.timestamp and msg.sender\n        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 100;\n\n        // Calculate the percentage of the input value\n        uint256 result = inputValue * randomNumber / 100;\n\n        return result;\n    }\n\n    function _takeMarketingFee(uint256 rMarketingFee, uint256 tMarketingFee) private {\n        if (tMarketingFee \u003e 0) {\n            if(!marketingConvertToToken) {\n                _rOwned[marketingFeeWallet] = _rOwned[marketingFeeWallet] + rMarketingFee;\n                if(_isExcluded[marketingFeeWallet]) _tOwned[marketingFeeWallet] = _tOwned[marketingFeeWallet] + tMarketingFee;\n            } else {\n                _rOwned[address(this)] = _rOwned[address(this)] + rMarketingFee;\n                if(_isExcluded[address(this)]) _tOwned[address(this)] = _tOwned[address(this)] + tMarketingFee;\n            }\n        }\n    }\n\n    function _distributeFee(uint256 rReflectionFee, uint256 tReflectionFee) private {\n        if (tReflectionFee \u003e 0) {\n            _rTotal = _rTotal - rReflectionFee;\n            _tReflectionFeeTotal = _tReflectionFeeTotal + tReflectionFee;\n        }\n    }\n\n    function _calculateFeeAmount(uint256 amount, uint256 fee) private pure returns (uint256) {\n        return amount * fee / 100;\n    }\n\n    function _isContract(address account) internal view returns (bool) {\n        return account.code.length \u003e 0;\n    }\n\n    /* In case of emergency dev can apply a 25% reflection tax on compromised wallets or bots causing detriment to project, this doesn\u0027t apply to smartcontracts (like LPs and farms).\n    Additionally only not excluded from fees addresses can\u0027t have this applied. Once the contract is renounced this function doesn\u0027t apply anymore. */\n    function antiBotDistribution(address target, bool status) external onlyOwner {\n        require (!_isContract(target), \"Can\u0027t apply to a contract\");\n        require(!_isExcludedFromFee[target], \"Can\u0027t use with an excluded from fee account\");\n\n        isAntiBotDistribution[target] = status;\n        emit AccountAntiBotDistribution(target, status);\n    }\n\n    function isExcludedFromFee(address account) external view returns(bool) {\n        return _isExcludedFromFee[account];\n    }\n\n    function isContractAdmin(address account) public view returns(bool) {\n        return _isContractAdmin[account];\n    }\n\n\tfunction isContractManager(address account) public view returns(bool) {\n        return _isContractManager[account];\n    }\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t   \n\n    function _isOwner() private view returns(bool) {\n        return owner() == msg.sender;\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\t\t_allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) private {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        require(amount \u003e 0, \"Transfer amount must be greater than zero\");\n        require(balanceOf(from) \u003e= amount, \"Insufficient Balance\");\n        \n        // whitelisted both excluded from fees and allowed to buy\n        // block trading until owner has added liquidity \u0026 launched\n        if (!fairLaunchStarted \u0026\u0026 from != owner() \u0026\u0026 to != owner() \u0026\u0026 from != address(this) \u0026\u0026 !_isExcludedFromFee[from]) {\n            revert(\"Trading not yet enabled!\");\n        }\n\n        // revert trading from non authorized users till fairlaunch is completed\n        if(fairLaunchStarted \u0026\u0026 !fairLaunchCompleted \u0026\u0026 from != owner() \u0026\u0026 to != owner() \u0026\u0026 !isWhitelisted[to] \u0026\u0026 from != address(this)) {\n            revert(\"Trading not yet enabled!\");\n        }\n\n        if (automatedMarketMakerPairs[to]) {\n            uint256 contractTokenBalance = balanceOf(address(this));\n            bool overMinTokenBalance = contractTokenBalance \u003e= _numTokensSwapForMarketing;\n            uint256 amountToSwap = _getRandomNumber(_numTokensSwapForMarketing);\n\n            if (\n                overMinTokenBalance \u0026\u0026\n                !_inMarketingSellSwap \u0026\u0026\n                marketingConvertToToken\n            ) {\n                swapMarketingAndSendToken(amountToSwap); //Perform a Swap of Token for ETH Portion of Marketing Fees\n            }\n        }\n\n        //transfer amount, it will take tax, burn, liquidity fee\n        _tokenTransfer(from,to,amount);\n    }\n\n    function swapMarketingAndSendToken(uint256 tokenAmount) internal lockTheSwap {\n        address[] memory path;\n        if (swapTokenAddress == WBTC) {\n            // generate the uniswap pair path of token -\u003e weth\n            path = new address[](2);\n            path[0] = address(this);\n            path[1] = WBTC;\n        } else {\n            path = new address[](4);\n            path[0] = address(this);\n            path[1] = WBTC;\n            path[2] = uniswapV2Router.WETH();\n            path[3] = swapTokenAddress;\n\n            address pairAddress = pairFor(uniswapV2Router.factory(), path[2], path[3]);\n            (uint112 reserve0, , ) = IUniswapV2Pair(pairAddress).getReserves();\n            uint liquidity = uint(reserve0);\n\n            if (liquidity == 0) {\n                // Swap pair does not exist or has no liquidity, skip this iteration\n                return;\n            }\n        }\n\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // make the swap in a try-catch block\n        try uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of token to receive\n            path,\n            marketingFeeWallet,\n            block.timestamp\n        ) {\n            if (marketingFeeTokensCounter \u003c tokenAmount) marketingFeeTokensCounter = 0;\n            else marketingFeeTokensCounter -= tokenAmount;\n        } catch {\n            return;\n        }\n\n        emit MarketingTokensSwapped(tokenAmount);\n    }\n\n    // Helper function to get the pair address\n    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address) {\n        return address(uint160(uint(keccak256(abi.encodePacked(\n            hex\u0027ff\u0027,\n            factory,\n            keccak256(abi.encodePacked(tokenA, tokenB)),\n            hex\u002796e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f\u0027\n        )))));\n    }\n\n    function calculateReflectionFee(uint256 amount, address recipient, address sender) private view returns (uint256) {\n        if (!_excludedFromFee(recipient, sender)) {\n            if (_antiBotDistribution(recipient, sender) \u0026\u0026 !isRenounced()) {\n                return _calculateFeeAmount(amount, 25);\n            } else if (automatedMarketMakerPairs[recipient]) {\n                return _calculateFeeAmount(amount, reflectionFeeSell);\n            } else if (automatedMarketMakerPairs[sender]) {\n                return _calculateFeeAmount(amount, reflectionFeeBuy);\n            } else {\n                return 0;\n            }\n        } else {\n            return 0;\n        }\n    }\n\n    function calculateMarketingFee(uint256 amount, address recipient, address sender) private view returns (uint256) {\n        uint256 marketingFee = 0;\n        if (!_excludedFromFee(recipient, sender)) {\n            if (_antiBotDistribution(recipient, sender) \u0026\u0026 !isRenounced()) {\n                return 0;\n            } else if (automatedMarketMakerPairs[recipient]) {\n                return _calculateFeeAmount(amount, marketingFeeSell);\n            } else if (!automatedMarketMakerPairs[sender]) {\n                marketingFee = _calculateFeeAmount(amount, marketingFeeTransfer);\n            }\n        }\n\n        if (marketingFee \u003e 0) {\n            uint256 tax = getTaxAmount(recipient, sender);\n            if (tax == 1) marketingFee = 0;\n            else marketingFee = _calculateFeeAmount(marketingFee, tax);\n        }\n\n        return marketingFee;\n    }\n\n    function getTaxAmount(address recipient, address sender) private view returns (uint256) {\n        if (userTransferTax[recipient] \u003e 0 \u0026\u0026 userTransferTax[sender] \u003e 0) {\n            return min(userTransferTax[recipient], userTransferTax[sender]);\n        } else if (userTransferTax[recipient] \u003e 0) {\n            return userTransferTax[recipient];\n        } else if (userTransferTax[sender] \u003e 0) {\n            return userTransferTax[sender];\n        } else {\n            return transferFeeRatio;\n        }\n    }\n\n    function min(uint256 a, uint256 b) private pure returns (uint256) {\n        return a \u003c b ? a : b;\n    }\n\n    function _excludedFromFee(address recipient, address sender) private view returns (bool) {\n        return _inMarketingSellSwap || _isExcludedFromFee[recipient] || _isExcludedFromFee[sender];\n    }\n\n    function _antiBotDistribution(address recipient, address sender) private view returns (bool) {\n        return (isAntiBotDistribution[recipient] || isAntiBotDistribution[sender]) \u0026\u0026 !isRenounced();\n    }\n\n    function takeFee(address sender, uint256 amount, address recipient) internal view returns (uint256[2] memory) {\n        uint256 reflectionFee = calculateReflectionFee(amount, recipient, sender);\n        uint256 marketingFee = calculateMarketingFee(amount, recipient, sender);\n\n        return [reflectionFee, marketingFee];\n    }\n\n    //this method is responsible for taking all fee, if takeFee is true\n    function _tokenTransfer(address sender, address recipient, uint256 amount) private {\n        if(!_isExcludedFromFee[sender] \u0026\u0026 !_isExcludedFromFee[recipient])  {\n            require(amount \u003c= maxTxAmount, \"Transfer amount exceeds the maxTxAmount.\");\n        }\n\n        uint256[2] memory calculateFees = takeFee(sender, amount, recipient);\n        uint256 reflectionFee = calculateFees[0];\n        uint256 marketingFee = calculateFees[1];\n\n        marketingFeeTokensCounter += marketingFee;\n        ValuesStruct memory vs = _getValues(amount, reflectionFee, marketingFee);\n        _takeMarketingFee(vs.rMarketingFee, vs.tMarketingFee);\n        _distributeFee(vs.rReflectionFee, vs.tReflectionFee);\n        \n        if (_isExcluded[sender] \u0026\u0026 !_isExcluded[recipient]) {\n            _transferFromExcluded(sender, recipient, amount, vs);\n        } else if (!_isExcluded[sender] \u0026\u0026 _isExcluded[recipient]) {\n            _transferToExcluded(sender, recipient, vs);\n        } else if (!_isExcluded[sender] \u0026\u0026 !_isExcluded[recipient]) {\n            _transferStandard(sender, recipient, vs);\n        } else if (_isExcluded[sender] \u0026\u0026 _isExcluded[recipient]) {\n            _transferBothExcluded(sender, recipient, amount, vs);\n        }\n    }\n\n    function _transferStandard(address sender, address recipient, ValuesStruct memory vs) private {\n        _rOwned[sender] = _rOwned[sender] - vs.rAmount;\n        _rOwned[recipient] = _rOwned[recipient] + vs.rTransferAmount;\n        emit Transfer(sender, recipient, vs.tTransferAmount);\n    }\n\n    function _transferToExcluded(address sender, address recipient, ValuesStruct memory vs) private {\n        _rOwned[sender] = _rOwned[sender] - vs.rAmount;\n        _tOwned[recipient] = _tOwned[recipient] + vs.tTransferAmount;\n        _rOwned[recipient] = _rOwned[recipient] + vs.rTransferAmount;\n        emit Transfer(sender, recipient, vs.tTransferAmount);\n    }\n\n    function _transferFromExcluded(address sender, address recipient, uint256 tAmount, ValuesStruct memory vs) private {\n        _tOwned[sender] = _tOwned[sender] - tAmount;\n        _rOwned[sender] = _rOwned[sender] - vs.rAmount;\n        _rOwned[recipient] = _rOwned[recipient] + vs.rTransferAmount;\n        emit Transfer(sender, recipient, vs.tTransferAmount);\n    }\n\n    function _transferBothExcluded(address sender, address recipient, uint256 tAmount, ValuesStruct memory vs) private {\n        _tOwned[sender] = _tOwned[sender] - tAmount;\n        _rOwned[sender] = _rOwned[sender] - vs.rAmount;\n        _tOwned[recipient] = _tOwned[recipient] + vs.tTransferAmount;\n        _rOwned[recipient] = _rOwned[recipient] + vs.rTransferAmount;\n        emit Transfer(sender, recipient, vs.tTransferAmount);\n    }\n\n    function excludeFromFee(address[] calldata accounts) external contractAdmin {\n        unchecked {\n            require(accounts.length \u003c 501,\"GAS Error: max limit is 500 addresses\");\n            for (uint32 i = 0; i \u003c accounts.length; i++) {\n                _isExcludedFromFee[accounts[i]] = true;\n            }\n        }\n    }\n\n    function setContractManager(address account, bool status) external contractManager {\n        require(account != address(0), \"Contract Manager Can\u0027t be the zero address\");\n        _isContractManager[account] = status;\n\n        emit ContractManagerChange(account, status);\n    }\n\n    function setContractAdmin(address account, bool status) external contractManager {\n        require(account != address(0), \"Contract Admin Can\u0027t be the zero address\");\n        _isContractAdmin[account] = status;\n\n        emit ContractAdminChange(account, status);\n    }\n\n    function setIsWhitelisted(address account, bool status) external onlyOwner {\n        require(isWhitelisted[account] != status || _isExcludedFromFee[account] != status, \"Nothing to change\");\n        if (isWhitelisted[account] != status) isWhitelisted[account] = status;\n        if (_isExcludedFromFee[account] != status) _isExcludedFromFee[account] = status;\n\n        emit WhitelistedStatus(account, status);\n    }\n\n    function includeInFee(address[] calldata accounts) external contractAdmin {\n        unchecked {\n            require(accounts.length \u003c 501, \"GAS Error: max limit is 500 addresses\");\n            for (uint32 i = 0; i \u003c accounts.length; i++) {\n                _isExcludedFromFee[accounts[i]] = false;\n            }\n        }\n    }\n\n    function isRenounced() public view returns(bool) {\n        return owner() == address(0);\n    }\n\n    function setFeesWithLimits(uint8 _reflectionFeeBuy, uint8 _reflectionFeeSell, uint8 _marketingFeeSell, uint8 _marketingFeeTransfer) external onlyOwner() {\n        require(_reflectionFeeBuy \u003c= 1 \u0026\u0026 _reflectionFeeSell + _marketingFeeSell \u003c= 5 \u0026\u0026 _marketingFeeTransfer \u003c= 1, \"Fees too high\");\n        reflectionFeeBuy = _reflectionFeeBuy;\n        reflectionFeeSell = _reflectionFeeSell;\n        marketingFeeSell = _marketingFeeSell;\n        marketingFeeTransfer = _marketingFeeTransfer;\n\n        emit FeesUpdated(reflectionFeeBuy, reflectionFeeSell, marketingFeeSell, marketingFeeTransfer);\n    }\n\n    function setSwapTokenAddress(address newToken) external contractAdmin() {\n        require(newToken != address(0), \"Swap Token address can\u0027t be the zero address\");\n        swapTokenAddress = newToken;\n\n        emit ChangeSwapToken(newToken);\n    }\n\n    function setMarketingWallet(address newWallet) external contractAdmin() {\n        require(newWallet != address(0), \"Marketing Wallet Can\u0027t be the zero address\");\n        marketingFeeWallet = newWallet;\n\n        emit ChangeMarketingWallet(newWallet);\n    }\n\n    function setMaxTxAmount(uint256 maxAmountInTokensWithDecimals) external contractAdmin {\n        require(maxAmountInTokensWithDecimals \u003e _tTotal / 1000, \"Cannot set transaction amount less than 0.1 percent of initial Total Supply!\");\n        maxTxAmount = maxAmountInTokensWithDecimals;\n\n        emit SetMaxTx(maxAmountInTokensWithDecimals);\n    }\n\n    function startFairlaunch() external onlyOwner {\n        require(!fairLaunchStarted, \"Fairlaunch Already enabled!\");\n        fairLaunchStarted = true;\n\n        emit FairlaunchStarted(true);\n    }\n\n    function completeFairlaunch() external onlyOwner {\n        require(!fairLaunchCompleted, \"Fairlaunch Already Completed!\");\n        fairLaunchCompleted = true;\n        if (!fairLaunchStarted) {\n            fairLaunchStarted = true;\n            emit FairlaunchStarted(true);\n        }\n\n        emit FairlaunchCompleted(true);\n    }\n\n    function setMarketingConvertToToken(bool status) external contractAdmin {\n        require(marketingConvertToToken != status);\n        marketingConvertToToken = status;\n\n        emit SetMarketingConvertToToken(status);\n    }\n\n    // Number of Tokens to Accrue before Selling To Add to Marketing\n\tfunction setTokensSwapForMarketingAmounts(uint256 numTokensSwap) external contractAdmin {\n        require(numTokensSwap \u003c= _tTotal/100, \"Can\u0027t swap more than 1% at once\");\n        _numTokensSwapForMarketing = numTokensSwap;\n\n        emit SetSwapForMarketing(numTokensSwap);\n    }\n    \n    /* This function sets a percentage of the Marketing Transfer Tax that is used for specific wallets. This is to be have a way\n    to be able to offer exchanges a reduced Transfer Tax Amount below the standard 1%. Ie. If set to 100 Fee is 1%, if set to 50 Fee is 0.5%  \n    */\n    function setUserTransferTax(address user, uint256 amount) external contractAdmin {\n        require(amount \u003c= 100, \"Amount out of percentage range!\");\n        userTransferTax[user] = amount;\n\n        emit ChangeUserTransferTax(user, amount);\n    }\n\n    /* This function sets a percentage of the Marketing Transfer Tax that is used globaly. It is used to reduce the Marketing Transfer Fee to below 1\n    Ie. If set to 100 Fee is 1%, if set to 50 Fee is 0.5%  \n    */\n    function setTransferFeeRatio(uint8 amount) external contractAdmin {\n        require(amount \u003c= 100, \"Amount out of percentage range!\");\n        transferFeeRatio = amount;\n\n        emit ChangeTransferFeeRatio(amount);\n    }\n\n    function setAutomatedMarketMakerPair(address pair, bool status) public onlyOwner {\n        require(pair != uniswapV2Pair, \"The original pair cannot be removed from automatedMarketMakerPairs\");\n        automatedMarketMakerPairs[pair] = status;\n\n        emit SetAMM(pair, status);\n    }\n\n    /**\n     * @dev Function to recover any ETH sent to Contract by Mistake.\n    */\t\n    function recoverETHFromContract(uint256 weiAmount) external contractManager{\n        require(address(this).balance \u003e= weiAmount, \"Insufficient ETH balance\");\n        payable(owner()).transfer(weiAmount);\n\n        emit ETHRecovered(weiAmount);\n    }\n\n    function rescueToken(address tokenAddr, address to) external contractManager {\n        uint256 amount = IERC20(tokenAddr).balanceOf(address(this));\n        if (tokenAddr == address(this)) {\n            if (marketingFeeTokensCounter \u003e amount) {\n                revert(\"No tokens to withdraw!\");\n            }\n            amount -= marketingFeeTokensCounter;\n        }\n        bool success = IERC20(tokenAddr).transfer(to, amount);\n        require(success, \"ERC20 transfer failed!\");\n\n        emit ERC20Rescued(tokenAddr, amount);\n    }\n}\n\n"},"Context.sol":{"content":"// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"},"IERC20.sol":{"content":"// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\npragma solidity 0.8.20;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller\u0027s account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller\u0027s tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender\u0027s allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller\u0027s\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) external returns (bool);\n}\n"},"Ownable.sol":{"content":"// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity 0.8.20;\n\nimport \"./Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"}}