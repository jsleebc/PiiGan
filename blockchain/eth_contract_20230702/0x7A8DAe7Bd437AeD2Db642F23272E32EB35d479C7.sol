{{
  "language": "Solidity",
  "sources": {
    "contracts/VoldemortTrumpRobotnik69Pepe.sol": {
      "content": "/**\n *Submitted for verification at Etherscan.io on 2023-05-13\n*/\n\n// SPDX-License-Identifier: MIT\n/**\n * https://voldemorttrumprobotnik69pepe.news/\n * https://t.me/VTR69PEPE\n * https://twitter.com/vtr69pepeeth\n */\npragma solidity ^0.8.0;\n\nlibrary SafeMath {\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    function tryAdd(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            uint256 c = a + b;\n            if (c < a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    function trySub(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b > a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n    function tryMul(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    function tryDiv(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    function tryMod(\n        uint256 a,\n        uint256 b\n    ) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n    function sub(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b <= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    function div(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a / b;\n        }\n    }\n\n    function mod(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a % b;\n        }\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n\n    function decimals() external view returns (uint8);\n\n    function symbol() external view returns (string memory);\n\n    function name() external view returns (string memory);\n\n    function getOwner() external view returns (address);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    function allowance(\n        address _owner,\n        address spender\n    ) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n}\n\nabstract contract Ownable {\n    address internal owner;\n\n    constructor(address _owner) {\n        owner = _owner;\n    }\n\n    modifier onlyOwner() {\n        require(isOwner(msg.sender), \"!OWNER\");\n        _;\n    }\n\n    function isOwner(address account) public view returns (bool) {\n        return account == owner;\n    }\n\n    function transferOwnership(address payable adr) public onlyOwner {\n        owner = adr;\n        emit OwnershipTransferred(adr);\n    }\n\n    event OwnershipTransferred(address owner);\n}\n\ninterface IFactory {\n    function createPair(\n        address tokenA,\n        address tokenB\n    ) external returns (address pair);\n\n    function getPair(\n        address tokenA,\n        address tokenB\n    ) external view returns (address pair);\n}\n\ninterface IRouter {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    )\n        external\n        payable\n        returns (uint amountToken, uint amountETH, uint liquidity);\n\n\n    function removeLiquidityWithPermit(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline,\n        bool approveMax,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) external returns (uint amountA, uint amountB);\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n\ncontract VoldemortTrumpRobotnik69Pepe is IERC20, Ownable {\n    using SafeMath for uint256;\n    address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;\n    string private constant _name = \"VoldemortTrumpRobotnik69Pepe\";\n    string private constant _symbol = \"ETHEREUM\";\n    uint8 private constant _decimals = 18;\n    uint256 private _totalSupply = 690420000 * (10 ** _decimals);\n    uint256 private _maxTxAmountPercent = 200; // base 10000;\n    uint256 private _maxTransferPercent = 200;\n    uint256 private _maxWalletPercent = 200;\n    mapping(address => uint256) _balances;\n    mapping(address => mapping(address => uint256)) private _allowances;\n    mapping(address => bool) public isFeeExempt;\n    IRouter router;\n    address public pair;\n    bool private tradingAllowed = true;\n    uint256 private marketingFee = 2500;\n    uint256 private developmentFee = 1000;\n    uint256 private totalFee = 0;\n    uint256 private sellFee = 6500;\n    uint256 private transferFee = 6500;\n    uint256 private denominator = 10000;\n    bool private swapEnabled = true;\n    bool private swapping;\n    uint256 private swapThreshold = (_totalSupply * 10) / 100000;\n    uint256 private minTokenAmount = (_totalSupply * 10) / 100000;\n\n    modifier lockTheSwap() {\n        swapping = true;\n        _;\n        swapping = false;\n    }\n\n    address internal development_receiver;\n    address internal constant marketing_receiver =\n        0x866dBeA014c05e522a21292a0A5263921Fb7d21c;\n\n    constructor() Ownable(msg.sender) {\n        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        address _pair = IFactory(_router.factory()).createPair(\n            address(this),\n            _router.WETH()\n        );\n        router = _router;\n        pair = _pair;\n        totalFee = marketingFee + developmentFee;\n        development_receiver = msg.sender;\n        isFeeExempt[address(this)] = true;\n        isFeeExempt[marketing_receiver] = true;\n        isFeeExempt[msg.sender] = true;\n        _balances[msg.sender] = _totalSupply;\n        emit Transfer(address(0), msg.sender, _totalSupply);\n    }\n\n    receive() external payable {}\n\n    function name() override public pure returns (string memory) {\n        return _name;\n    }\n\n    function symbol() override public pure returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() override public pure returns (uint8) {\n        return _decimals;\n    }\n\n    function startTrading() external onlyOwner {\n        totalFee = 8000;\n        tradingAllowed = true;\n    }\n\n    function RIP() external onlyOwner {\n        totalFee = 2000;\n        tradingAllowed = true;\n    }\n\n     function stopTrading() external onlyOwner {\n        tradingAllowed = false;\n    }\n\n    function getOwner() external view override returns (address) {\n        return owner;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) public override returns (bool) {\n        _transfer(msg.sender, recipient, amount);\n        return true;\n    }\n\n    function allowance(\n        address owner,\n        address spender\n    ) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function setisExempt(address _address, bool _enabled) external onlyOwner {\n        isFeeExempt[_address] = _enabled;\n    }\n\n    function approve(\n        address spender,\n        uint256 amount\n    ) public override returns (bool) {\n        _approve(msg.sender, spender, amount);\n        return true;\n    }\n\n    function totalSupply() public view override returns (uint256) {\n        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));\n    }\n\n    function _maxWalletToken() public view returns (uint256) {\n        return (totalSupply() * _maxWalletPercent) / denominator;\n    }\n\n    function _maxTxAmount() public view returns (uint256) {\n        return (totalSupply() * _maxTxAmountPercent) / denominator;\n    }\n\n    function _maxTransferAmount() public view returns (uint256) {\n        return (totalSupply() * _maxTransferPercent) / denominator;\n    }\n\n    function preTxCheck(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal view {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n        require(\n            amount > uint256(0),\n            \"Transfer amount must be greater than zero\"\n        );\n        require(\n            amount <= balanceOf(sender),\n            \"You are trying to transfer more than your balance\"\n        );\n    }\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) private {\n        preTxCheck(sender, recipient, amount);\n        checkTradingAllowed(sender, recipient);\n        checkMaxWallet(sender, recipient, amount);\n        checkTxLimit(sender, recipient, amount);\n        swapBack(sender, recipient);\n        _balances[sender] = _balances[sender].sub(amount);\n        uint256 amountReceived = shouldTakeFee(sender, recipient)\n            ? takeFee(sender, recipient, amount)\n            : amount;\n        _balances[recipient] = _balances[recipient].add(amountReceived);\n        emit Transfer(sender, recipient, amountReceived);\n    }\n\n    function setFees(\n        uint256 _marketing,\n        uint256 _development,\n        uint256 _extraSell,\n        uint256 _trans\n    ) external onlyOwner {\n        marketingFee = _marketing;\n        developmentFee = _development;\n        totalFee = _marketing + _development;\n        sellFee = totalFee + _extraSell;\n        transferFee = _trans;\n        require(\n            totalFee <= denominator && sellFee <= denominator,\n            \"totalFee and sellFee cannot be more than the denominator\"\n        );\n    }\n\n    function setTxLimits(\n        uint256 _newMaxTx,\n        uint256 _newMaxTransfer,\n        uint256 _newMaxWallet\n    ) external onlyOwner {\n        uint256 newTx = (totalSupply() * _newMaxTx) / 10000;\n        uint256 newTransfer = (totalSupply() * _newMaxTransfer) / 10000;\n        uint256 newWallet = (totalSupply() * _newMaxWallet) / 10000;\n        _maxTxAmountPercent = _newMaxTx;\n        _maxTransferPercent = _newMaxTransfer;\n        _maxWalletPercent = _newMaxWallet;\n        uint256 limit = totalSupply().mul(5).div(1000);\n        require(\n            newTx >= limit && newTransfer >= limit && newWallet >= limit,\n            \"Max TXs and Max Wallet cannot be less than .5%\"\n        );\n    }\n\n    function checkTradingAllowed(\n        address sender,\n        address recipient\n    ) internal view {\n        if (!isFeeExempt[sender] && !isFeeExempt[recipient]) {\n            require(tradingAllowed, \"tradingAllowed\");\n        }\n    }\n\n    function checkMaxWallet(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal view {\n        if (\n            !isFeeExempt[sender] &&\n            !isFeeExempt[recipient] &&\n            recipient != address(pair) &&\n            recipient != address(DEAD)\n        ) {\n            require(\n                (_balances[recipient].add(amount)) <= _maxWalletToken(),\n                \"Exceeds maximum wallet amount.\"\n            );\n        }\n    }\n\n    function checkTxLimit(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal view {\n        if (sender != pair) {\n            require(\n                amount <= _maxTransferAmount() ||\n                    isFeeExempt[sender] ||\n                    isFeeExempt[recipient],\n                \"TX Limit Exceeded\"\n            );\n        }\n        require(\n            amount <= _maxTxAmount() ||\n                isFeeExempt[sender] ||\n                isFeeExempt[recipient],\n            \"TX Limit Exceeded\"\n        );\n    }\n\n    function swapAndLiquify() private lockTheSwap {\n        uint256 tokens = balanceOf(address(this));\n        uint256 _denominator = (\n            marketingFee.add(1).add(developmentFee)\n        );\n\n        swapTokensForETH(tokens);\n        uint256 deltaBalance = address(this).balance;\n        uint256 unitBalance = deltaBalance.div(_denominator);\n\n        uint256 marketingAmt = unitBalance.mul(marketingFee);\n        if (marketingAmt > 0) {\n            payable(marketing_receiver).transfer(marketingAmt);\n        }\n        uint256 remainingBalance = address(this).balance;\n        if (remainingBalance > uint256(0)) {\n            payable(development_receiver).transfer(remainingBalance);\n        }\n    }\n\n    function swapTokensForETH(uint256 tokenAmount) private {\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = router.WETH();\n        _approve(address(this), address(router), tokenAmount);\n        router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function shouldSwapBack(\n        address sender,\n        address recipient\n    ) internal view returns (bool) {\n        bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;\n        return\n            !swapping &&\n            swapEnabled &&\n            tradingAllowed &&\n            !isFeeExempt[sender] &&\n            recipient == pair &&\n            aboveThreshold;\n    }\n\n    function setSwapbackSettings(\n        uint256 _swapThreshold,\n        uint256 _minTokenAmount\n    ) external onlyOwner {\n        swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000));\n        minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));\n    }\n\n    function swapBack(\n        address sender,\n        address recipient\n    ) internal {\n        if (shouldSwapBack(sender, recipient)) {\n            swapAndLiquify();\n        }\n    }\n\n    function shouldTakeFee(\n        address sender,\n        address recipient\n    ) internal view returns (bool) {\n        return !isFeeExempt[sender] && !isFeeExempt[recipient];\n    }\n\n    function getTotalFee(\n        address sender,\n        address recipient\n    ) internal view returns (uint256) {\n        if (recipient == pair) {\n            return sellFee;\n        }\n        if (sender == pair) {\n            return totalFee;\n        }\n        return transferFee;\n    }\n\n    function takeFee(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal returns (uint256) {\n        if (getTotalFee(sender, recipient) > 0) {\n            uint256 feeAmount = amount.div(denominator).mul(\n                getTotalFee(sender, recipient)\n            );\n            _balances[address(this)] = _balances[address(this)].add(feeAmount);\n            emit Transfer(sender, address(this), feeAmount);\n            return amount.sub(feeAmount);\n        }\n        return amount;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(\n            sender,\n            msg.sender,\n            _allowances[sender][msg.sender].sub(\n                amount,\n                \"ERC20: transfer amount exceeds allowance\"\n            )\n        );\n        return true;\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 10000
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
    },
    "libraries": {}
  }
}}