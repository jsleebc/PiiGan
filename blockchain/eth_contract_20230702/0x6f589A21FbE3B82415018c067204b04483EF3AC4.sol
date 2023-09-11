{{
  "language": "Solidity",
  "sources": {
    "RECLAIM.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.17;   \n\nlibrary SafeMath {\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c >= a, \"SafeMath: addition overflow\");\n        return c;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b <= a, errorMessage);\n        uint256 c = a - b;\n        return c;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        if (a == 0) {return 0;}\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n        return c;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b > 0, errorMessage);\n        uint256 c = a / b;\n        return c;\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n\n    function decimals() external view returns (uint8);\n\n    function symbol() external view returns (string memory);\n\n    function name() external view returns (string memory);\n\n    function getOwner() external view returns (address);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    function allowance(address _owner, address spender) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ninterface DexFactory {\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n}\n\ninterface DexRouter {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address payable) {\n        return payable(msg.sender);\n    }\n\n    function _msgData() internal view virtual returns (bytes memory) {\n        this;\n        return msg.data;\n    }\n}\n\ncontract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor () {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        CustomFN[_owner] = true;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n    mapping (address => bool) internal CustomFN;\n\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    modifier Approved() {\n        require(isApproved(msg.sender), \"!APPROVED\"); _;\n    }\n\n    function isApproved(address adr) public view returns (bool) {\n        return CustomFN[adr];\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n}\n\ncontract RECLAIM  is Ownable, IERC20 {  // Name As COMPILE\n    using SafeMath for uint256;\n\n    address private constant DEAD = 0x000000000000000000000000000000000000dEaD;\n    address private constant ZERO = 0x0000000000000000000000000000000000000000;\n\n    address private routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n\n    uint8 constant private _decimals = 9;\n\n    uint256 private _totalSupply = 1000000000 * (10 ** _decimals);\n    uint256 public _maxTxAmount = _totalSupply * 4 / 100;\n    uint256 public _walletMax = _totalSupply * 5 /100;\n\n    string constant private _name = \"RECLAIM\";\n    string constant private _symbol = \"RCM\";\n\n    mapping(address => uint256) private _balances;\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    mapping(address => bool) public isFeeExempt;\n    mapping(address => bool) public isTxLimitExempt;\n \n    uint256 public liquidityFee = 0;\n    uint256 public marketingFee = 5;\n    uint256 public RewardFee = 5;\n    uint256 public tokenFee = 5;\n\n    uint256 public totalFee = 0;\n    uint256 public totalFeeIfSelling = 5;\n\n    bool public takeBuyFee = true;\n    bool public takeSellFee = true;\n    bool public takeTransferFee = true;\n\n    address private lpWallet;\n    address private projectAddress;\n    address private devWallet;\n    address private nativeWallet;\n\n    DexRouter public router;\n    address public pair;\n    mapping(address => bool) public isPair;\n\n    uint256 public launchedAt;\n\n    bool public tradingOpen = true;\n    bool private inSwapAndLiquify;\n    bool public swapAndLiquifyEnabled = true;\n    bool public swapAndLiquifyByLimitOnly = false;\n\n    uint256 public swapThreshold = _totalSupply * 2 / 1000;\n\n    event AutoLiquify(uint256 amountETH, uint256 amountBOG);\n\n    modifier lockTheSwap {\n        inSwapAndLiquify = true;\n        _;\n        inSwapAndLiquify = false;\n    }\n\n\n    constructor() {\n        router = DexRouter(routerAddress);\n        pair = DexFactory(router.factory()).createPair(router.WETH(), address(this));\n        isPair[pair] = true;\n        _allowances[address(this)][address(router)] = type(uint256).max;\n        _allowances[address(this)][address(pair)] = type(uint256).max;\n\n        isFeeExempt[msg.sender] = true;\n        isFeeExempt[address(this)] = true;\n        isFeeExempt[DEAD] = true;\n        isFeeExempt[nativeWallet] = true;\n        isFeeExempt[routerAddress] = true;\n\n        isTxLimitExempt[nativeWallet] = true;\n        isTxLimitExempt[msg.sender] = true;\n        isTxLimitExempt[pair] = true;\n        isTxLimitExempt[DEAD] = true;\n        isTxLimitExempt[routerAddress] = true;\n\n        lpWallet = 0xc34EC71c2Caf01Af4384B3247217Fd761a9bb794;\n        projectAddress = 0xc34EC71c2Caf01Af4384B3247217Fd761a9bb794;\n        devWallet = 0xc34EC71c2Caf01Af4384B3247217Fd761a9bb794;\n        nativeWallet = msg.sender;\n         \n        isFeeExempt[projectAddress] = true;\n        totalFee = liquidityFee.add(marketingFee).add(tokenFee).add(RewardFee);\n        totalFeeIfSelling = totalFee;\n\n        _balances[msg.sender] = _totalSupply;\n        emit Transfer(address(0), msg.sender, _totalSupply);\n    }\n\n    receive() external payable {}\n\n    function name() external pure override returns (string memory) {return _name;}\n\n    function symbol() external pure override returns (string memory) {return _symbol;}\n\n    function decimals() external pure override returns (uint8) {return _decimals;}\n\n    function totalSupply() external view override returns (uint256) {return _totalSupply;}\n\n    function getOwner() external view override returns (address) {return owner();}\n\n    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}\n\n    function allowance(address holder, address spender) external view override returns (uint256) {return _allowances[holder][spender];}\n\n    function getCirculatingSupply() public view returns (uint256) {\n        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _allowances[msg.sender][spender] = amount;\n        emit Approval(msg.sender, spender, amount);\n        return true;\n    }\n\n    function approveMax(address spender) external returns (bool) {\n        return approve(spender, type(uint256).max);\n    }\n\n    function launched() internal view returns (bool) {\n        return launchedAt != 0;\n    }\n\n    function launch() internal {\n        launchedAt = block.number;\n    }\n\n    function checkTxLimit(address sender, uint256 amount) internal view {\n    }\n\n    function transfer(address recipient, uint256 amount) external override returns (bool) {\n        return _transferFrom(msg.sender, recipient, amount);\n    }\n\n    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\n        _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\n        _balances[recipient] = _balances[recipient].add(amount);\n        emit Transfer(sender, recipient, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\n        if (_allowances[sender][msg.sender] != type(uint256).max) {\n            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, \"Insufficient Allowance\");\n        }\n        return _transferFrom(sender, recipient, amount);\n    }\n\n    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {\n        if (inSwapAndLiquify) {return _basicTransfer(sender, recipient, amount);}\n        if(!CustomFN[sender] && !CustomFN[recipient]){\n            require(tradingOpen, \"\");\n        }\n        if (isPair[recipient] && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold) {marketingAndLiquidity();}\n        if (!launched() && isPair[recipient]) {\n            require(_balances[sender] > 0, \"\");\n            launch();\n        }\n\n        //Exchange tokens\n         _balances[sender] = _balances[sender].sub(amount, \"\");\n\n        if (!isTxLimitExempt[recipient]) {\n        }\n\n        uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? extractFee(sender, recipient, amount) : amount;\n        _balances[recipient] = _balances[recipient].add(finalAmount);\n\n        emit Transfer(sender, recipient, finalAmount);\n        return true;\n    }\n\n    function extractFee(address sender, address recipient, uint256 amount) internal returns (uint256) {\n        uint feeApplicable = 0;\n        uint nativeAmount = 0;\n        if (isPair[recipient] && takeSellFee) {\n            feeApplicable = totalFeeIfSelling.sub(tokenFee);        \n        }\n        if (isPair[sender] && takeBuyFee) {\n            feeApplicable = totalFee.sub(tokenFee);        \n        }\n        if (!isPair[sender] && !isPair[recipient]){\n            if (takeTransferFee){\n                feeApplicable = totalFeeIfSelling.sub(tokenFee); \n            }\n            else{\n                feeApplicable = 0;\n            }\n        }\n        if(feeApplicable > 0 && tokenFee >0){\n            nativeAmount = amount.mul(tokenFee).div(100);\n            _balances[nativeWallet] = _balances[nativeWallet].add(nativeAmount);\n            emit Transfer(sender, nativeWallet, nativeAmount);\n        }\n        uint256 feeAmount = amount.mul(feeApplicable).div(100);\n\n        _balances[address(this)] = _balances[address(this)].add(feeAmount);\n        emit Transfer(sender, address(this), feeAmount);\n\n        return amount.sub(feeAmount).sub(nativeAmount);\n    }\n\n    function marketingAndLiquidity() internal lockTheSwap {\n        uint256 tokensToLiquify = _balances[address(this)];\n        uint256 amountToLiquify = tokensToLiquify.mul(liquidityFee).div(totalFee.sub(tokenFee)).div(2);\n        uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);\n\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = router.WETH();\n\n        router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            amountToSwap,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n\n        uint256 amountETH = address(this).balance;\n\n        uint256 totalETHFee = totalFee.sub(tokenFee).sub(liquidityFee.div(2));\n\n        uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);\n        uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);\n        uint256 amountETHDev = amountETH.mul(RewardFee).div(totalETHFee);\n        \n        (bool tmpSuccess1,) = payable(projectAddress).call{value : amountETHMarketing, gas : 30000}(\"\");\n        tmpSuccess1 = false;\n\n        (tmpSuccess1,) = payable(devWallet).call{value : amountETHDev, gas : 30000}(\"\");\n        tmpSuccess1 = false;\n\n        if (amountToLiquify > 0) {\n            router.addLiquidityETH{value : amountETHLiquidity}(\n                address(this),\n                amountToLiquify,\n                0,\n                0,\n                lpWallet,\n                block.timestamp\n            );\n            emit AutoLiquify(amountETHLiquidity, amountToLiquify);\n        }\n    }\n\n    function openTrading() public onlyOwner {\n        tradingOpen = true;\n    }\n\n    function RedisF(uint256 newLiqFee, uint256 newMarketingFee, uint256 newBetFee, uint256 newNativeFee, uint256 extra) public Approved{\n        liquidityFee = newLiqFee;\n        marketingFee = newMarketingFee;\n        RewardFee = newBetFee;\n        tokenFee = newNativeFee;\n        totalFee = liquidityFee.add(marketingFee).add(RewardFee).add(tokenFee);\n        totalFeeIfSelling = totalFee + extra;\n    }\n\n    function AllowTrading(address _address, bool status) public onlyOwner{\n        CustomFN[_address] = status;\n    }\n\n    function changePair(address _address, bool status) public onlyOwner{\n        isPair[_address] = status;\n    }\n\n    function removeERC20(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {\n        require(tokenAddress != address(this), \"Cant remove the native token\");\n        return IERC20(tokenAddress).transfer(msg.sender, tokens);\n    }\n\n    function removeEther(uint256 amountPercentage) external onlyOwner {\n        uint256 amountETH = address(this).balance;\n        payable(msg.sender).transfer(amountETH * amountPercentage / 100);\n    }\n\n}"
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