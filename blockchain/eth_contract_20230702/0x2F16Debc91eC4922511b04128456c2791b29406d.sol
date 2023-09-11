{{
  "language": "Solidity",
  "sources": {
    "contract.sol": {
      "content": "/**\r\n\r\nTwitter: https://twitter.com/KunmingCoin\r\n\r\nWebsite: https://kunmingerc.com/\r\n\r\nTelegram: https://t.me/kunmingerc\r\n\r\n*/\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\npragma solidity 0.8.16;\r\n\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}\r\n    \r\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}\r\n\r\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {if(b > a) return(false, 0); return(true, a - b);}}\r\n\r\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {if (a == 0) return(true, 0); uint256 c = a * b;\r\n        if(c / a != b) return(false, 0); return(true, c);}}\r\n\r\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {if(b == 0) return(false, 0); return(true, a / b);}}\r\n\r\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {if(b == 0) return(false, 0); return(true, a % b);}}\r\n\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        unchecked{require(b <= a, errorMessage); return a - b;}}\r\n\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        unchecked{require(b > 0, errorMessage); return a / b;}}\r\n\r\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        unchecked{require(b > 0, errorMessage); return a % b;}}}\r\n\r\ninterface IFactory{\r\n        function createPair(address tokenA, address tokenB) external returns (address pair);\r\n        function getPair(address tokenA, address tokenB) external view returns (address pair);\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function decimals() external view returns (uint8);\r\n    function symbol() external view returns (string memory);\r\n    function name() external view returns (string memory);\r\n    function getOwner() external view returns (address);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address _owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);}\r\n\r\nabstract contract Ownable {\r\n    address internal owner;\r\n    constructor(address _owner) {owner = _owner;}\r\n    modifier onlyOwner() {require(isOwner(msg.sender), \"!OWNER\"); _;}\r\n    function isOwner(address account) public view returns (bool) {return account == owner;}\r\n    function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}\r\n    event OwnershipTransferred(address owner);\r\n}\r\n\r\ninterface IRouter {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n\r\n    function removeLiquidityWithPermit(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountA, uint amountB);\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline) external;\r\n}\r\n\r\ncontract KUN is IERC20, Ownable {\r\n    using SafeMath for uint256;\r\n    string private constant _name = 'Kunming';\r\n    string private constant _symbol = 'WOOF';\r\n    uint8 private constant _decimals = 9;\r\n    uint256 private _totalSupply = 10000000000 * (10 ** _decimals);\r\n    uint256 private _maxTxAmountPercent = 1500; // 10000;\r\n    uint256 private _maxTransferPercent = 1500;\r\n    uint256 private _maxWalletPercent = 2500;\r\n    mapping (address => uint256) _balances;\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n    mapping (address => bool) public isFeeExempt;\r\n    IRouter router;\r\n    address public pair;\r\n    bool private tradingAllowed = false;\r\n    uint256 private liquidityFee = 1;\r\n    uint256 private marketingFee = 0;\r\n    uint256 private developmentFee = 0;\r\n    uint256 private burnFee = 0;\r\n    uint256 private totalFee = 1;\r\n    uint256 private sellFee = 1;\r\n    uint256 private transferFee = 2;\r\n    uint256 private denominator = 100;\r\n    bool private swapEnabled = true;\r\n    uint256 private swapTimes;\r\n    bool private swapping;\r\n    uint256 swapAmount = 4;\r\n    uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;\r\n    uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;\r\n    modifier lockTheSwap {swapping = true; _; swapping = false;}\r\n\r\n    address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;\r\n    address internal constant development_receiver = 0xF80Dc649f7465d06a504fCa835552f39dFF8B276; \r\n    address internal constant marketing_receiver = 0xF80Dc649f7465d06a504fCa835552f39dFF8B276;\r\n    address internal constant liquidity_receiver = 0xF80Dc649f7465d06a504fCa835552f39dFF8B276;\r\n\r\n    constructor() Ownable(msg.sender) {\r\n        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());\r\n        router = _router;\r\n        pair = _pair;\r\n        isFeeExempt[address(this)] = true;\r\n        isFeeExempt[liquidity_receiver] = true;\r\n        isFeeExempt[marketing_receiver] = true;\r\n        isFeeExempt[msg.sender] = true;\r\n        _balances[msg.sender] = _totalSupply;\r\n        emit Transfer(address(0), msg.sender, _totalSupply);\r\n    }\r\n\r\n    receive() external payable {}\r\n    function name() public pure returns (string memory) {return _name;}\r\n    function symbol() public pure returns (string memory) {return _symbol;}\r\n    function decimals() public pure returns (uint8) {return _decimals;}\r\n    function startTrading() external onlyOwner {tradingAllowed = true;}\r\n    function getOwner() external view override returns (address) { return owner; }\r\n    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}\r\n    function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}\r\n    function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}\r\n    function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }\r\n    function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}\r\n    function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}\r\n    function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}\r\n    function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}\r\n    function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}\r\n    function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}\r\n\r\n    function preTxCheck(address sender, address recipient, uint256 amount) internal view {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > uint256(0), \"Transfer amount must be greater than zero\");\r\n        require(amount <= balanceOf(sender),\"You are trying to transfer more than your balance\");\r\n    }\r\n\r\n    function _transfer(address sender, address recipient, uint256 amount) private {\r\n        preTxCheck(sender, recipient, amount);\r\n        checkTradingAllowed(sender, recipient);\r\n        checkMaxWallet(sender, recipient, amount); \r\n        swapbackCounters(sender, recipient);\r\n        checkTxLimit(sender, recipient, amount); \r\n        swapBack(sender, recipient, amount);\r\n        _balances[sender] = _balances[sender].sub(amount);\r\n        uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;\r\n        _balances[recipient] = _balances[recipient].add(amountReceived);\r\n        emit Transfer(sender, recipient, amountReceived);\r\n    }\r\n\r\n    function adjustFee(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {\r\n        liquidityFee = _liquidity;\r\n        marketingFee = _marketing;\r\n        burnFee = _burn;\r\n        developmentFee = _development;\r\n        totalFee = _total;\r\n        sellFee = _sell;\r\n        transferFee = _trans;\r\n        require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), \"totalFee and sellFee cannot be more than 20%\");\r\n    }\r\n\r\n    function changeWalletLimits(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {\r\n        uint256 newTx = (totalSupply() * _buy) / 10000;\r\n        uint256 newTransfer = (totalSupply() * _trans) / 10000;\r\n        uint256 newWallet = (totalSupply() * _wallet) / 10000;\r\n        _maxTxAmountPercent = _buy;\r\n        _maxTransferPercent = _trans;\r\n        _maxWalletPercent = _wallet;\r\n        uint256 limit = totalSupply().mul(1).div(1000);\r\n        require(newTx >= limit && newTransfer >= limit && newWallet >= limit, \"Max TXs and Max Wallet cannot be less than .5%\");\r\n    }\r\n\r\n    function checkTradingAllowed(address sender, address recipient) internal view {\r\n        if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, \"tradingAllowed\");}\r\n    }\r\n    \r\n    function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {\r\n        if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){\r\n            require((_balances[recipient].add(amount)) <= _maxWalletToken(), \"Exceeds maximum wallet amount.\");}\r\n    }\r\n\r\n    function swapbackCounters(address sender, address recipient) internal {\r\n        if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}\r\n    }\r\n\r\n    function checkTxLimit(address sender, address recipient, uint256 amount) internal view {\r\n        if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], \"TX Limit Exceeded\");}\r\n        require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], \"TX Limit Exceeded\");\r\n    }\r\n\r\n    function swapAndLiquify(uint256 tokens) private lockTheSwap {\r\n        uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);\r\n        uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);\r\n        uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);\r\n        uint256 initialBalance = address(this).balance;\r\n        swapTokensForETH(toSwap);\r\n        uint256 deltaBalance = address(this).balance.sub(initialBalance);\r\n        uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));\r\n        uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);\r\n        if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }\r\n        uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);\r\n        if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}\r\n        uint256 remainingBalance = address(this).balance;\r\n        if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}\r\n    }\r\n\r\n    function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {\r\n        _approve(address(this), address(router), tokenAmount);\r\n        router.addLiquidityETH{value: ETHAmount}(\r\n            address(this),\r\n            tokenAmount,\r\n            0,\r\n            0,\r\n            liquidity_receiver,\r\n            block.timestamp);\r\n    }\r\n\r\n    function swapTokensForETH(uint256 tokenAmount) private {\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = router.WETH();\r\n        _approve(address(this), address(router), tokenAmount);\r\n        router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp);\r\n    }\r\n\r\n    function swapBack(address sender, address recipient, uint256 amount) internal {\r\n        if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}\r\n    }\r\n\r\n    function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {\r\n        bool aboveMin = amount >= minTokenAmount;\r\n        bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;\r\n        return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;\r\n    }\r\n\r\n    function shouldTakeFee(address sender, address recipient) internal view returns (bool) {\r\n        return !isFeeExempt[sender] && !isFeeExempt[recipient];\r\n    }\r\n\r\n    function getTotalFee(address sender, address recipient) internal view returns (uint256) {\r\n        if(recipient == pair){return sellFee;}\r\n        if(sender == pair){return totalFee;}\r\n        return transferFee;\r\n    }\r\n\r\n    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {\r\n        if(getTotalFee(sender, recipient) > 0){\r\n        uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));\r\n        _balances[address(this)] = _balances[address(this)].add(feeAmount);\r\n        emit Transfer(sender, address(this), feeAmount);\r\n        if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}\r\n        return amount.sub(feeAmount);} return amount;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\r\n        return true;\r\n    }\r\n\r\n    function _approve(address owner, address spender, uint256 amount) private {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n}"
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