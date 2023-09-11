{{
  "language": "Solidity",
  "sources": {
    "Elon Tweet.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n/**\r\n\r\nTelegram: https://t.me/TheXplatform\r\n\r\n\r\n\r\nTweet: https://twitter.com/Dex_Insider/status/1664323132373581833?s=20\r\n\r\n**/\r\n\r\npragma solidity 0.8.17;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c >= a, \"SafeMath: addition overflow\");\r\n        return c;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b <= a, errorMessage);\r\n        uint256 c = a - b;\r\n        return c;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n        return c;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b > 0, errorMessage);\r\n        uint256 c = a / b;\r\n        return c;\r\n    }\r\n\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n}\r\ncontract ElonTweet  is Context , IERC20, Ownable {\r\n    using SafeMath for uint256;\r\n    mapping (address => uint256) private _balances;\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n    mapping (address => bool) private _isExcludedFromFee;\r\n    mapping (address => bool) private bots;\r\n    mapping(address => uint256) private _holderLastTransferTimestamp;\r\n    bool public transferDelayEnabled = true;\r\n    address payable private _taxWallet;\r\n\r\n    uint256 private _initialBuyTax=20;\r\n    uint256 private _initialSellTax=20;\r\n    uint256 private _finalBuyTax=0;\r\n    uint256 private _finalSellTax=0;\r\n    uint256 private _reduceBuyTaxAt=20;\r\n    uint256 private _reduceSellTaxAt=25;\r\n    uint256 private _preventSwapBefore=20;\r\n    uint256 private _buyCount=0;\r\n\r\n    uint8 private constant _decimals = 9;\r\n    uint256 private constant _tTotal = 1000000 * 10**_decimals;\r\n    string private constant _name = unicode\" The X platform \";\r\n    string private constant _symbol = unicode\"X \";\r\n    uint256 public _maxTxAmount = 20000 * 10**_decimals;\r\n    uint256 public _maxWalletSize = 20000 * 10**_decimals;\r\n    uint256 public _taxSwapThreshold= 10000 * 10**_decimals;\r\n    uint256 public _maxTaxSwap= 10000 * 10**_decimals;\r\n\r\n    IUniswapV2Router02 private uniswapV2Router;\r\n    address private uniswapV2Pair;\r\n    bool private tradingOpen;\r\n    bool private inSwap = false;\r\n    bool private swapEnabled = false;\r\n\r\n    event MaxTxAmountUpdated(uint _maxTxAmount);\r\n    modifier lockTheSwap {\r\n        inSwap = true;\r\n        _;\r\n        inSwap = false;\r\n    }\r\n\r\n    constructor () {\r\n        _taxWallet = payable(_msgSender());\r\n        _balances[_msgSender()] = _tTotal;\r\n        _isExcludedFromFee[owner()] = true;\r\n        _isExcludedFromFee[address(this)] = true;\r\n        _isExcludedFromFee[_taxWallet] = true;\r\n\r\n        emit Transfer(address(0), _msgSender(), _tTotal);\r\n    }\r\n\r\n    function name() public pure returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public pure returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public pure returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public pure override returns (uint256) {\r\n        return _tTotal;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\r\n        return true;\r\n    }\r\n\r\n    function _approve(address owner, address spender, uint256 amount) private {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _transfer(address from, address to, uint256 amount) private {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > 0, \"Transfer amount must be greater than zero\");\r\n        uint256 taxAmount=0;\r\n        if (from != owner() && to != owner()) {\r\n            require(!bots[from] && !bots[to]);\r\n            taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);\r\n\r\n            if (transferDelayEnabled) {\r\n                  if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {\r\n                      require(\r\n                          _holderLastTransferTimestamp[tx.origin] <\r\n                              block.number,\r\n                          \"_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.\"\r\n                      );\r\n                      _holderLastTransferTimestamp[tx.origin] = block.number;\r\n                  }\r\n              }\r\n\r\n            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {\r\n                require(amount <= _maxTxAmount, \"Exceeds the _maxTxAmount.\");\r\n                require(balanceOf(to) + amount <= _maxWalletSize, \"Exceeds the maxWalletSize.\");\r\n                _buyCount++;\r\n            }\r\n\r\n            if(to == uniswapV2Pair && from!= address(this) ){\r\n                taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);\r\n            }\r\n\r\n            uint256 contractTokenBalance = balanceOf(address(this));\r\n            if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {\r\n                swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));\r\n                uint256 contractETHBalance = address(this).balance;\r\n                if(contractETHBalance > 0) {\r\n                    sendETHToFee(address(this).balance);\r\n                }\r\n            }\r\n        }\r\n\r\n        if(taxAmount>0){\r\n          _balances[address(this)]=_balances[address(this)].add(taxAmount);\r\n          emit Transfer(from, address(this),taxAmount);\r\n        }\r\n        _balances[from]=_balances[from].sub(amount);\r\n        _balances[to]=_balances[to].add(amount.sub(taxAmount));\r\n        emit Transfer(from, to, amount.sub(taxAmount));\r\n    }\r\n\r\n\r\n    function min(uint256 a, uint256 b) private pure returns (uint256){\r\n      return (a>b)?b:a;\r\n    }\r\n\r\n    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function removeLimits() external onlyOwner{\r\n        _maxTxAmount = _tTotal;\r\n        _maxWalletSize=_tTotal;\r\n        transferDelayEnabled=false;\r\n        emit MaxTxAmountUpdated(_tTotal);\r\n    }\r\n\r\n    function sendETHToFee(uint256 amount) private {\r\n        _taxWallet.transfer(amount);\r\n    }\r\n\r\n    function addBots(address[] memory bots_) public onlyOwner {\r\n        for (uint i = 0; i < bots_.length; i++) {\r\n            bots[bots_[i]] = true;\r\n        }\r\n    }\r\n\r\n    function delBots(address[] memory notbot) public onlyOwner {\r\n      for (uint i = 0; i < notbot.length; i++) {\r\n          bots[notbot[i]] = false;\r\n      }\r\n    }\r\n\r\n    function isBot(address a) public view returns (bool){\r\n      return bots[a];\r\n    }\r\n\r\n    function openTrading() external onlyOwner() {\r\n        require(!tradingOpen,\"trading is already open\");\r\n        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        _approve(address(this), address(uniswapV2Router), _tTotal);\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\r\n        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);\r\n        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);\r\n        swapEnabled = true;\r\n        tradingOpen = true;\r\n    }\r\n\r\n    \r\n    function reduceFee(uint256 _newFee) external{\r\n      require(_msgSender()==_taxWallet);\r\n      require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);\r\n      _finalBuyTax=_newFee;\r\n      _finalSellTax=_newFee;\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    function manualSwap() external {\r\n        require(_msgSender()==_taxWallet);\r\n        uint256 tokenBalance=balanceOf(address(this));\r\n        if(tokenBalance>0){\r\n          swapTokensForEth(tokenBalance);\r\n        }\r\n        uint256 ethBalance=address(this).balance;\r\n        if(ethBalance>0){\r\n          sendETHToFee(ethBalance);\r\n        }\r\n    }\r\n}"
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