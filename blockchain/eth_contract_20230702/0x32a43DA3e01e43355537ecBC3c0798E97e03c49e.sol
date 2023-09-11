{{
  "language": "Solidity",
  "sources": {
    "contract.sol": {
      "content": "/*\r\n\r\nTwitter - https://twitter.com/Protectronio\r\n\r\nTelegram - https://t.me/protectronportal\r\n\r\nWebsite - https://protectron.io/\r\n\r\n*/\r\n\r\n// SPDX-License-Identifier: UNLICENSED\r\n\r\npragma solidity ^0.8.7;\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c >= a, \"SafeMath: addition overflow\");\r\n\r\n        return c;\r\n    }\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b <= a, errorMessage);\r\n        uint256 c = a - b;\r\n\r\n        return c;\r\n    }\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n\r\n        return c;\r\n    }\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b > 0, errorMessage);\r\n        uint256 c = a / b;\r\n        return c;\r\n    }\r\n}\r\n\r\ninterface ERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function decimals() external view returns (uint8);\r\n    function symbol() external view returns (string memory);\r\n    function name() external view returns (string memory);\r\n    function getOwner() external view returns (address);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address _owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\nabstract contract Context {\r\n    \r\n    function _msgSender() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes memory) {\r\n        this;\r\n        return msg.data;\r\n    }\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address public _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        authorizations[_owner] = true;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n    mapping (address => bool) internal authorizations;\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ninterface IDEXFactory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ninterface IDEXRouter {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint amountADesired,\r\n        uint amountBDesired,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB, uint liquidity);\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n\r\ninterface InterfaceLP {\r\n    function sync() external;\r\n}\r\n\r\ncontract PROTECT is Ownable, ERC20 {\r\n    using SafeMath for uint256;\r\n    address WETH;\r\n    address DEAD = 0x000000000000000000000000000000000000dEaD;\r\n    address ZERO = 0x0000000000000000000000000000000000000000;\r\n    string constant _name = \"Protectron\";\r\n    string constant _symbol = \"TRON\";\r\n    uint8 constant _decimals = 18; \r\n    uint256 _totalSupply = 1 * 10**11 * 10**_decimals;\r\n    uint256 public _maxTxAmount = _totalSupply.mul(30).div(1000);\r\n    uint256 public _maxWalletToken = _totalSupply.mul(30).div(1000);\r\n    mapping (address => uint256) _balances;\r\n    mapping (address => mapping (address => uint256)) _allowances;\r\n    mapping (address => bool) isFeeExempt;\r\n    mapping (address => bool) isTxLimitExempt;\r\n    uint256 private liquidityFee    = 2;\r\n    uint256 private marketingFee    = 2;\r\n    uint256 private devFee          = 1;\r\n    uint256 private teamFee         = 0; \r\n    uint256 private burnFee         = 0;\r\n    uint256 public totalFee        = teamFee + marketingFee + liquidityFee + devFee + burnFee;\r\n    uint256 private feeDenominator  = 100;\r\n    uint256 sellMultiplier = 100;\r\n    uint256 buyMultiplier = 100;\r\n    uint256 transferMultiplier = 1200; \r\n    bool public swapEnabled = true;\r\n    uint256 public swapThreshold = _totalSupply * 2 / 1000; \r\n    bool inSwap;\r\n    modifier swapping() { inSwap = true; _; inSwap = false; }\r\n    address private autoLiquidityReceiver;\r\n    address private marketingFeeReceiver;\r\n    address private devFeeReceiver;\r\n    address private teamFeeReceiver;\r\n    address private burnFeeReceiver;\r\n\r\n    uint256 targetLiquidity = 5;\r\n    uint256 targetLiquidityDenominator = 100;\r\n\r\n    IDEXRouter public router;\r\n    InterfaceLP private pairContract;\r\n    address public pair;\r\n    bool public TradingOpen = false;    \r\n\r\n    constructor () {\r\n        router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        WETH = router.WETH();\r\n        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));\r\n        pairContract = InterfaceLP(pair);\r\n        \r\n        _allowances[address(this)][address(router)] = type(uint256).max;\r\n\r\n        isFeeExempt[msg.sender] = true;\r\n        isFeeExempt[devFeeReceiver] = true;\r\n        isFeeExempt[marketingFeeReceiver] = true;  \r\n        isTxLimitExempt[msg.sender] = true;\r\n        isTxLimitExempt[pair] = true;\r\n        isTxLimitExempt[devFeeReceiver] = true;\r\n        isTxLimitExempt[marketingFeeReceiver] = true;\r\n        isTxLimitExempt[address(this)] = true;\r\n        \r\n        autoLiquidityReceiver = msg.sender;\r\n        marketingFeeReceiver = 0x401Ccd25ac5FAF0969218f41b45d3C9658b65D14;\r\n        devFeeReceiver = msg.sender;\r\n        teamFeeReceiver = msg.sender;\r\n        burnFeeReceiver = DEAD; \r\n\r\n        _balances[msg.sender] = _totalSupply;\r\n        emit Transfer(address(0), msg.sender, _totalSupply);\r\n    }\r\n\r\n    receive() external payable { }\r\n\r\n    function totalSupply() external view override returns (uint256) { return _totalSupply; }\r\n    function decimals() external pure override returns (uint8) { return _decimals; }\r\n    function symbol() external pure override returns (string memory) { return _symbol; }\r\n    function name() external pure override returns (string memory) { return _name; }\r\n    function getOwner() external view override returns (address) {return owner();}\r\n    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }\r\n    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }\r\n\r\n    function approve(address spender, uint256 amount) public override returns (bool) {\r\n        _allowances[msg.sender][spender] = amount;\r\n        emit Approval(msg.sender, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function approveMax(address spender) external returns (bool) {\r\n        return approve(spender, type(uint256).max);\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) external override returns (bool) {\r\n        return _transferFrom(msg.sender, recipient, amount);\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\r\n        if(_allowances[sender][msg.sender] != type(uint256).max){\r\n            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, \"Insufficient Allowance\");\r\n        }\r\n\r\n        return _transferFrom(sender, recipient, amount);\r\n    }\r\n\r\n        function setMaxWalletPercent(uint256 maxWallPercent) public {\r\n        require(_maxWalletToken >= _totalSupply / 1000); //no less than .1%\r\n        _maxWalletToken = (_totalSupply * maxWallPercent ) / 100;\r\n                \r\n    }\r\n\r\n    function setTransactionAmount(uint256 maxTXPercent) public {\r\n        require(_maxTxAmount >= _totalSupply / 1000); //anti honeypot no less than .1%\r\n        _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;\r\n    }\r\n    \r\n    function setTxLimitAbsolute(uint256 amount) external onlyOwner {\r\n        require(_maxTxAmount >= _totalSupply / 1000);\r\n        _maxTxAmount = amount;\r\n    }\r\n\r\n    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {\r\n        if(inSwap){ return _basicTransfer(sender, recipient, amount); }\r\n\r\n        if(!authorizations[sender] && !authorizations[recipient]){\r\n            require(TradingOpen,\"Trading not open yet\");\r\n\r\n        }\r\n\r\n        if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){\r\n            uint256 heldTokens = balanceOf(recipient);\r\n            require((heldTokens + amount) <= _maxWalletToken,\"Total Holding is currently limited, you can not buy that much.\");}\r\n\r\n        // Checks max transaction limit\r\n        checkTxLimit(sender, amount); \r\n\r\n        if(shouldSwapBack()){ swapBack(); }\r\n                    \r\n         //Exchange tokens\r\n        _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\r\n\r\n        uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);\r\n        _balances[recipient] = _balances[recipient].add(amountReceived);\r\n\r\n        emit Transfer(sender, recipient, amountReceived);\r\n        return true;\r\n    }\r\n    \r\n    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\r\n        _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\r\n        _balances[recipient] = _balances[recipient].add(amount);\r\n        emit Transfer(sender, recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function checkTxLimit(address sender, uint256 amount) internal view {\r\n        require(amount <= _maxTxAmount || isTxLimitExempt[sender], \"TX Limit Exceeded\");\r\n    }\r\n\r\n    function shouldTakeFee(address sender) internal view returns (bool) {\r\n        return !isFeeExempt[sender];\r\n    }\r\n\r\n    function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {\r\n        \r\n        uint256 multiplier = transferMultiplier;\r\n\r\n        if(recipient == pair) {\r\n            multiplier = sellMultiplier;\r\n        } else if(sender == pair) {\r\n            multiplier = buyMultiplier;\r\n        }\r\n\r\n        uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);\r\n        uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);\r\n        uint256 contractTokens = feeAmount.sub(burnTokens);\r\n\r\n        _balances[address(this)] = _balances[address(this)].add(contractTokens);\r\n        _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);\r\n        emit Transfer(sender, address(this), contractTokens);\r\n        \r\n        if(burnTokens > 0){\r\n            emit Transfer(sender, burnFeeReceiver, burnTokens);    \r\n        }\r\n\r\n        return amount.sub(feeAmount);\r\n    }\r\n\r\n    function shouldSwapBack() internal view returns (bool) {\r\n        return msg.sender != pair\r\n        && !inSwap\r\n        && swapEnabled\r\n        && _balances[address(this)] >= swapThreshold;\r\n    }\r\n\r\n    function clearStuckBalance(uint256 amountPercentage) external onlyOwner { // to marketing\r\n        uint256 amountETH = address(this).balance;\r\n        payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);\r\n    }\r\n\r\n    function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {\r\n     if(tokens == 0){\r\n            tokens = ERC20(tokenAddress).balanceOf(address(this));\r\n        }\r\n        return ERC20(tokenAddress).transfer(msg.sender, tokens);\r\n    }\r\n\r\n    function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {\r\n        sellMultiplier = _sell;\r\n        buyMultiplier = _buy;\r\n        transferMultiplier = _trans;    \r\n      \r\n    }\r\n\r\n    function enableTrading() public onlyOwner {\r\n        TradingOpen = true;\r\n    }\r\n    \r\n    function swapBack() internal swapping {\r\n        uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;\r\n        uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);\r\n        uint256 amountToSwap = swapThreshold.sub(amountToLiquify);\r\n\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = WETH;\r\n\r\n        uint256 balanceBefore = address(this).balance;\r\n\r\n        router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            amountToSwap,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n\r\n        uint256 amountETH = address(this).balance.sub(balanceBefore);\r\n\r\n        uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));\r\n        \r\n        uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);\r\n        uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);\r\n        uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);\r\n        uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);\r\n\r\n        (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}(\"\");\r\n        (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}(\"\");\r\n        (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}(\"\");\r\n        \r\n        tmpSuccess = false;\r\n\r\n        if(amountToLiquify > 0){\r\n            router.addLiquidityETH{value: amountETHLiquidity}(\r\n                address(this),\r\n                amountToLiquify,\r\n                0,\r\n                0,\r\n                autoLiquidityReceiver,\r\n                block.timestamp\r\n            );\r\n            emit AutoLiquify(amountETHLiquidity, amountToLiquify);\r\n        }\r\n    }\r\n\r\n    function setIsFeeExempt(address holder, bool exempt) external onlyOwner {\r\n        isFeeExempt[holder] = exempt;\r\n    }\r\n\r\n    function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {\r\n        autoLiquidityReceiver = _autoLiquidityReceiver;\r\n        marketingFeeReceiver = _marketingFeeReceiver;\r\n        devFeeReceiver = _devFeeReceiver;\r\n        burnFeeReceiver = _burnFeeReceiver;\r\n        teamFeeReceiver = _teamFeeReceiver;\r\n    }\r\n\r\n    function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {\r\n        swapEnabled = _enabled;\r\n        swapThreshold = _amount;\r\n    }\r\n\r\n    function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {\r\n        isTxLimitExempt[holder] = exempt;\r\n    }\r\n\r\n    function setTaxes(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {\r\n        liquidityFee = _liquidityFee;\r\n        teamFee = _teamFee;\r\n        marketingFee = _marketingFee;\r\n        devFee = _devFee;\r\n        burnFee = _burnFee;\r\n        totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_devFee).add(_burnFee);\r\n        feeDenominator = _feeDenominator;\r\n        require(totalFee < feeDenominator/4, \"Fees cannot be more than 25%\"); //antihoneypot\r\n    }\r\n\r\n    function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {\r\n        targetLiquidity = _target;\r\n        targetLiquidityDenominator = _denominator;\r\n    }\r\n    \r\n    function getCirculatingSupply() public view returns (uint256) {\r\n        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));\r\n    }\r\n\r\n    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {\r\n        return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());\r\n    }\r\n\r\n    function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {\r\n        return getLiquidityBacking(accuracy) > target;\r\n    }\r\n\r\nevent AutoLiquify(uint256 amountETH, uint256 amountTokens);\r\n\r\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    }
  }
}}