{{
  "language": "Solidity",
  "sources": {
    "main": {
      "content": "// SPDX-License-Identifier: MIT\n/**\n\nTg: https://t.me/GOTGeth\nWeb: https://www.gotg.site/\nTwitter: https://twitter.com/gotgeth\n\n**/\npragma solidity 0.8.19;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\nlibrary SafeMath {\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c >= a, \"SafeMath: addition overflow\");\n        return c;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b <= a, errorMessage);\n        uint256 c = a - b;\n        return c;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        if (a == 0) {\n            return 0;\n        }\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n        return c;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b > 0, errorMessage);\n        uint256 c = a / b;\n        return c;\n    }\n\n}\n\ncontract Ownable is Context {\n    address private _owner;\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor () {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n\n}\n\ninterface IUniswapV2Factory {\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n}\n\ninterface IUniswapV2Router02 {\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n}\n\ncontract GOTG is Context, IERC20, Ownable {\n    using SafeMath for uint256;\n    mapping (address => uint256) private _balances;\n    mapping (address => mapping (address => uint256)) private _allowances;\n    mapping (address => bool) private _isExcludedFromFee;\n    mapping (address => bool) private bots;\n    mapping(address => uint256) private _holderLastTransferTimestamp;\n    bool public transferDelayEnabled = true;\n    address payable private _taxWallet;\n\n    uint256 private _initialBuyTax=18;\n    uint256 private _initialSellTax=25;\n    uint256 private _finalBuyTax=2;\n    uint256 private _finalSellTax=2;\n    uint256 private _reduceBuyTaxAt=1;\n    uint256 private _reduceSellTaxAt=25;\n    uint256 private _preventSwapBefore=60;\n    uint256 private _buyCount=0;\n\n    uint8 private constant _decimals = 8;\n    uint256 private constant _tTotal = 500000000 * 10**_decimals;\n    string private constant _name = unicode\"Guardians of the Galaxy\";\n    string private constant _symbol = unicode\"GOTG\";\n    uint256 public _maxTxAmount =   10000000 * 10**_decimals;\n    uint256 public _maxWalletSize = 10000000 * 10**_decimals;\n    uint256 public _taxSwapThreshold=2500000 * 10**_decimals;\n    uint256 public _maxTaxSwap=2500000 * 10**_decimals;\n\n    IUniswapV2Router02 private uniswapV2Router;\n    address private uniswapV2Pair;\n    bool private tradingOpen;\n    bool private inSwap = false;\n    bool private swapEnabled = false;\n\n    event MaxTxAmountUpdated(uint _maxTxAmount);\n    modifier lockTheSwap {\n        inSwap = true;\n        _;\n        inSwap = false;\n    }\n\n    constructor () {\n        _taxWallet = payable(_msgSender());\n        _balances[_msgSender()] = _tTotal;\n        _isExcludedFromFee[owner()] = true;\n        _isExcludedFromFee[address(this)] = true;\n        _isExcludedFromFee[_taxWallet] = true;\n\n        emit Transfer(address(0), _msgSender(), _tTotal);\n    }\n\n    function name() public pure returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public pure returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public pure returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public pure override returns (uint256) {\n        return _tTotal;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\n        return true;\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _transfer(address from, address to, uint256 amount) private {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n        uint256 taxAmount=0;\n        if (from != owner() && to != owner()) {\n            require(!bots[from] && !bots[to]);\n\n            if (transferDelayEnabled) {\n                if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {\n                  require(_holderLastTransferTimestamp[tx.origin] < block.number,\"Only one transfer per block allowed.\");\n                  _holderLastTransferTimestamp[tx.origin] = block.number;\n                }\n            }\n\n            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {\n                require(amount <= _maxTxAmount, \"Exceeds the _maxTxAmount.\");\n                require(balanceOf(to) + amount <= _maxWalletSize, \"Exceeds the maxWalletSize.\");\n                _buyCount++;\n            }\n\n\n            taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);\n            if(to == uniswapV2Pair && from!= address(this) ){\n                require(amount <= _maxTxAmount, \"Exceeds the _maxTxAmount.\");\n                taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);\n            }\n\n            uint256 contractTokenBalance = balanceOf(address(this));\n            if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {\n                swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));\n                uint256 contractETHBalance = address(this).balance;\n                if(contractETHBalance > 0) {\n                    sendETHToFee(address(this).balance);\n                }\n            }\n        }\n\n        if(taxAmount>0){\n          _balances[address(this)]=_balances[address(this)].add(taxAmount);\n          emit Transfer(from, address(this),taxAmount);\n        }\n        _balances[from]=_balances[from].sub(amount);\n        _balances[to]=_balances[to].add(amount.sub(taxAmount));\n        emit Transfer(from, to, amount.sub(taxAmount));\n    }\n\n\n    function min(uint256 a, uint256 b) private pure returns (uint256){\n      return (a>b)?b:a;\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {\n        if(tokenAmount==0){return;}\n        if(!tradingOpen){return;}\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function removeLimits() external onlyOwner{\n        _maxTxAmount = _tTotal;\n        _maxWalletSize=_tTotal;\n        transferDelayEnabled=false;\n        emit MaxTxAmountUpdated(_tTotal);\n    }\n\n    function sendETHToFee(uint256 amount) private {\n        _taxWallet.transfer(amount);\n    }\n\n    function isBot(address a) public view returns (bool){\n      return bots[a];\n    }\n\n    function openTrading() external onlyOwner() {\n        require(!tradingOpen,\"trading is already open\");\n        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        _approve(address(this), address(uniswapV2Router), _tTotal);\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\n        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);\n        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);\n        swapEnabled = true;\n        tradingOpen = true;\n    }\n\n    receive() external payable {}\n\n    function manualSwap() external {\n        require(_msgSender()==_taxWallet);\n        uint256 tokenBalance=balanceOf(address(this));\n        if(tokenBalance>0){\n          swapTokensForEth(tokenBalance);\n        }\n        uint256 ethBalance=address(this).balance;\n        if(ethBalance>0){\n          sendETHToFee(ethBalance);\n        }\n    }\n\n    \n    \n    function reduceFee(uint256 _newFee) external{\n      require(_msgSender()==_taxWallet);\n      require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);\n      _finalBuyTax=_newFee;\n      _finalSellTax=_newFee;\n    }\n    \n}\n"
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