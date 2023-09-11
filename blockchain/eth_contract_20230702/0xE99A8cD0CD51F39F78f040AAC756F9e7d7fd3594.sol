{{
  "language": "Solidity",
  "sources": {
    "main": {
      "content": "\n// SPDX-License-Identifier: UNLICENSED\n/**\n\nhttps://t.me/babymongcoin\nhttps://twitter.com/babymongcoin/\n\n**/\n\npragma solidity 0.8.19;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\nlibrary SafeMath {\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c >= a, \"SafeMath: addition overflow\");\n        return c;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b <= a, errorMessage);\n        uint256 c = a - b;\n        return c;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        if (a == 0) {\n            return 0;\n        }\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n        return c;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b > 0, errorMessage);\n        uint256 c = a / b;\n        return c;\n    }\n\n}\n\ncontract Ownable is Context {\n    address private _owner;\n    address private _previousOwner;\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor () {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n\n}\n\ninterface IUniswapV2Factory {\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n}\n\ninterface IUniswapV2Router02 {\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n}\n\ncontract BABYmongtoken is Context, IERC20, Ownable {\n    using SafeMath for uint256;\n    mapping (address => uint256) private _rOwned;\n    mapping (address => uint256) private _tOwned;\n    mapping (address => mapping (address => uint256)) private _allowances;\n    mapping (address => bool) private _isExcludedFromFee;\n    mapping (address => bool) private bots;\n    mapping (address => uint) private cooldown;\n    uint256 private constant MAX = ~uint256(0);\n\n    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n    uint256 private _tFeeTotal;\n\n    uint256 private _feeAddr1;\n    uint256 private _feeAddr2;\n    uint256 private _initialTax=15;\n    uint256 private _finalTax=4;\n    uint256 private _reduceTaxAt=1;\n    uint256 private _startLiquidateAt=80;\n    uint256 private _buyCount=0;\n    address payable private _feeAddrWallet;\n\n    string private constant _name = unicode\"BabyMongCoin\";\n    string private constant _symbol = unicode\"BABYMONG\";\n    uint8 private constant _decimals = 8;\n\n    IUniswapV2Router02 private uniswapV2Router;\n    address private uniswapV2Pair;\n    bool private tradingOpen;\n    bool private inSwap = false;\n    bool private swapEnabled = false;\n    bool private cooldownEnabled = false;\n    uint256 private constant _tTotal = 690000000000 * 10**_decimals;\n    uint256 private _maxTxAmount = 13800000000 * 10**_decimals;\n    uint256 private _maxWalletSize = 13800000000 * 10**_decimals;\n    uint256 private _swapThreshold=3450000000*10**_decimals;\n    event MaxTxAmountUpdated(uint _maxTxAmount);\n    modifier lockTheSwap {\n        inSwap = true;\n        _;\n        inSwap = false;\n    }\n\n    constructor () {\n        _feeAddrWallet = payable(_msgSender());\n        _rOwned[_msgSender()] = _rTotal;\n        _isExcludedFromFee[owner()] = true;\n        _isExcludedFromFee[address(this)] = true;\n        _isExcludedFromFee[_feeAddrWallet] = true;\n\n        emit Transfer(address(0), _msgSender(), _tTotal);\n    }\n\n    function name() public pure returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public pure returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public pure returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public pure override returns (uint256) {\n        return _tTotal;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return tokenFromReflection(_rOwned[account]);\n    }\n\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\n        return true;\n    }\n\n    function setCooldownEnabled(bool onoff) external onlyOwner() {\n        cooldownEnabled = onoff;\n    }\n\n    function addBots(address[] memory bots_) public onlyOwner {\n        for (uint i = 0; i < bots_.length; i++) {\n            bots[bots_[i]] = true;\n        }\n    }\n\n    function delBots(address[] memory notbot) public onlyOwner {\n      for (uint i = 0; i < notbot.length; i++) {\n          bots[notbot[i]] = false;\n      }\n    }\n\n    function tokenFromReflection(uint256 rAmount) private view returns(uint256) {\n        require(rAmount <= _rTotal, \"Amount must be less than total reflections\");\n        uint256 currentRate =  _getRate();\n        return rAmount.div(currentRate);\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _transfer(address from, address to, uint256 amount) private {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n\n\n        if (from != owner() && to != owner()) {\n            require(!bots[from] && !bots[to]);\n            _feeAddr1 = 2;\n            _feeAddr2 = (_buyCount>=_reduceTaxAt)?_finalTax:_initialTax;\n            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {\n                // Cooldown\n                require(amount <= _maxTxAmount, \"Exceeds the _maxTxAmount.\");\n                require(balanceOf(to) + amount <= _maxWalletSize, \"Exceeds the maxWalletSize.\");\n                _buyCount++;\n            }\n\n\n            uint256 contractTokenBalance = balanceOf(address(this));\n            if (!inSwap &&  to  == uniswapV2Pair && swapEnabled && contractTokenBalance>=_swapThreshold && _buyCount>_startLiquidateAt) {\n                swapTokensForEth(_swapThreshold>amount?amount:_swapThreshold);\n                uint256 contractETHBalance = address(this).balance;\n                if(contractETHBalance > 0) {\n                    sendETHToFee(address(this).balance);\n                }\n            }\n        }else{\n          _feeAddr1 = 0;\n          _feeAddr2 = 0;\n        }\n\n        _tokenTransfer(from,to,amount);\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n\n    function removeLimits() external onlyOwner{\n        _maxTxAmount = _tTotal;\n        _maxWalletSize = _tTotal;\n    }\n\n    function sendETHToFee(uint256 amount) private {\n        _feeAddrWallet.transfer(amount);\n    }\n\n    function openTrading() external onlyOwner() {\n        require(!tradingOpen,\"trading is already open\");\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        uniswapV2Router = _uniswapV2Router;\n        _approve(address(this), address(uniswapV2Router), _tTotal);\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\n        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);\n        swapEnabled = true;\n        cooldownEnabled = true;\n\n        tradingOpen = true;\n        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);\n    }\n\n    function _tokenTransfer(address sender, address recipient, uint256 amount) private {\n        _transferStandard(sender, recipient, amount);\n    }\n\n    function _transferStandard(address sender, address recipient, uint256 tAmount) private {\n        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);\n        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);\n        _takeTeam(tTeam);\n        _reflectFee(rFee, tFee);\n        emit Transfer(sender, recipient, tTransferAmount);\n    }\n\n    function _takeTeam(uint256 tTeam) private {\n        uint256 currentRate =  _getRate();\n        uint256 rTeam = tTeam.mul(currentRate);\n        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);\n    }\n\n    function _reflectFee(uint256 rFee, uint256 tFee) private {\n        _rTotal = _rTotal.sub(rFee);\n        _tFeeTotal = _tFeeTotal.add(tFee);\n    }\n\n    receive() external payable {}\n\n    function manualSwap() external {\n        require(_msgSender()==_feeAddrWallet);\n        uint256 tokenBalance=balanceOf(address(this));\n        if(tokenBalance>0){\n          swapTokensForEth(tokenBalance);\n        }\n        uint256 ethBalance=address(this).balance;\n        if(ethBalance>0){\n          sendETHToFee(ethBalance);\n        }\n    }\n\n    function isBot(address a) public view returns (bool){\n      return bots[a];\n    }\n\n\n    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {\n        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);\n        uint256 currentRate =  _getRate();\n        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);\n        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);\n    }\n\n    function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {\n        uint256 tFee = tAmount.mul(taxFee).div(100);\n        uint256 tTeam = tAmount.mul(TeamFee).div(100);\n        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);\n        return (tTransferAmount, tFee, tTeam);\n    }\n\n    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {\n        uint256 rAmount = tAmount.mul(currentRate);\n        uint256 rFee = tFee.mul(currentRate);\n        uint256 rTeam = tTeam.mul(currentRate);\n        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);\n        return (rAmount, rTransferAmount, rFee);\n    }\n\n\tfunction _getRate() private view returns(uint256) {\n        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n        return rSupply.div(tSupply);\n    }\n\n    function _getCurrentSupply() private view returns(uint256, uint256) {\n        uint256 rSupply = _rTotal;\n        uint256 tSupply = _tTotal;\n        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\n        return (rSupply, tSupply);\n    }\n}\n"
    }
  },
  "settings": {
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
    "optimizer": {
      "enabled": true,
      "runs": 200
    }
  }
}}