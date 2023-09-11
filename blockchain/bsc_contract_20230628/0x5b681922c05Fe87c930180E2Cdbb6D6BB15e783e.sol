{{
  "language": "Solidity",
  "sources": {
    "contracts/Token.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity 0.8.17;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address payable) {\n        return payable(msg.sender);\n    }\n\n    function _msgData() internal view virtual returns (bytes memory) {\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n        return msg.data;\n    }\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor () {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        emit OwnershipTransferred(_owner, newOwner);\n        _owner = newOwner;\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n   \n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\nlibrary Address {\n    function isContract(address account) internal view returns (bool) {\n        bytes32 codehash;\n        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n        assembly { codehash := extcodehash(account) }\n        return (codehash != accountHash && codehash != 0x0);\n    }\n\n    function sendValue(address payable recipient, uint256 amount) internal returns(bool){\n        require(address(this).balance >= amount, \"Address: insufficient balance\");\n        (bool success, ) = recipient.call{ value: amount }(\"\");\n        return success;\n    }\n\n    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n      return functionCall(target, data, \"Address: low-level call failed\");\n    }\n\n    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n        return _functionCallWithValue(target, data, 0, errorMessage);\n    }\n\n    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n        return functionCallWithValue(target, data, value, \"Address: low-level call with value failed\");\n    }\n\n    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n        require(address(this).balance >= value, \"Address: insufficient balance for call\");\n        return _functionCallWithValue(target, data, value, errorMessage);\n    }\n\n    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n        require(isContract(target), \"Address: call to non-contract\");\n        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n        if (success) {\n            return returndata;\n        } else {\n            // Look for revert reason and bubble it up if present\n            if (returndata.length > 0) {\n                assembly {\n                    let returndata_size := mload(returndata)\n                    revert(add(32, returndata), returndata_size)\n                }\n            } else {\n                revert(errorMessage);\n            }\n        }\n    }\n}\n\ninterface IUniswapV2Factory {\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n\n    function feeTo() external view returns (address);\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\n    function allPairs(uint) external view returns (address pair);\n    function allPairsLength() external view returns (uint);\n\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n\n    function setFeeTo(address) external;\n    function setFeeToSetter(address) external;\n}\n\ninterface IUniswapV2Pair {\n    event Approval(address indexed owner, address indexed spender, uint value);\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function name() external pure returns (string memory);\n    function symbol() external pure returns (string memory);\n    function decimals() external pure returns (uint8);\n    function totalSupply() external view returns (uint);\n    function balanceOf(address owner) external view returns (uint);\n    function allowance(address owner, address spender) external view returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n    function transfer(address to, uint value) external returns (bool);\n    function transferFrom(address from, address to, uint value) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n    function nonces(address owner) external view returns (uint);\n\n    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n\n    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n    event Swap(\n        address indexed sender,\n        uint amount0In,\n        uint amount1In,\n        uint amount0Out,\n        uint amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\n    function factory() external view returns (address);\n    function token0() external view returns (address);\n    function token1() external view returns (address);\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n    function price0CumulativeLast() external view returns (uint);\n    function price1CumulativeLast() external view returns (uint);\n    function kLast() external view returns (uint);\n\n    function burn(address to) external returns (uint amount0, uint amount1);\n    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n    function skim(address to) external;\n    function sync() external;\n\n    function initialize(address, address) external;\n}\n\ninterface IUniswapV2Router01 {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n    function removeLiquidity(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETH(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountToken, uint amountETH);\n    function removeLiquidityWithPermit(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETHWithPermit(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountToken, uint amountETH);\n    function swapExactTokensForTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapTokensForExactTokens(\n        uint amountOut,\n        uint amountInMax,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n}\n\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountETH);\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountETH);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n\ncontract KishuInu is Context, IERC20, Ownable {\n    using Address for address;\n    using Address for address payable;\n\n    mapping (address => uint256) private _rOwned;\n    mapping (address => uint256) private _tOwned;\n    mapping (address => mapping (address => uint256)) private _allowances;\n\n    mapping (address => bool) private _isExcludedFromFees;\n    mapping (address => bool) private _isExcluded;\n    address[] private _excluded;\n\n    string private _name     = \"Kishu Inu 2.0\";\n    string private _symbol   = \"Ki2\";\n    uint8  private _decimals = 18;\n   \n    uint256 private constant MAX = type(uint256).max;\n    uint256 private _tTotal = 1000000000000 * (10 ** _decimals);\n    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n    uint256 private _tFeeTotal;\n\n    uint256 public taxFeeonBuy;\n    uint256 public taxFeeonSell;\n\n    uint256 public liquidityFeeonBuy;\n    uint256 public liquidityFeeonSell;\n\n    uint256 public marketingFeeonBuy;\n    uint256 public marketingFeeonSell;\n\n    uint256 public _taxFee;\n    uint256 public _liquidityFee;\n    uint256 public _marketingFee;\n\n    uint256 totalBuyFees;\n    uint256 totalSellFees;\n\n    address public marketingWallet;\n\n    bool public walletToWalletTransferWithoutFee;\n    \n    address private DEAD = 0x000000000000000000000000000000000000dEaD;\n\n    IUniswapV2Router02 public  uniswapV2Router;\n    address public  uniswapV2Pair;\n\n    bool private inSwapAndLiquify;\n    bool public swapEnabled;\n    bool public tradingEnabled;\n    uint256 public swapTokensAtAmount;\n    \n    event ExcludeFromFees(address indexed account, bool isExcluded);\n    event MarketingWalletChanged(address marketingWallet);\n    event SwapEnabledUpdated(bool enabled);\n    event SwapAndLiquify(uint256 tokensSwapped, uint256 bnbReceived, uint256 tokensIntoLiqudity);\n    event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);\n    event SwapTokensAtAmountUpdated(uint256 amount);\n    event BuyFeesChanged(uint256 taxFee, uint256 liquidityFee, uint256 marketingFee);\n    event SellFeesChanged(uint256 taxFee, uint256 liquidityFee, uint256 marketingFee);\n    event WalletToWalletTransferWithoutFeeEnabled(bool enabled);\n    \n    constructor() \n    {        \n        address router;\n        if (block.chainid == 56) {\n            router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; \n        } else if (block.chainid == 97) {\n            router =  0xD99D1c33F9fC3444f8101754aBC46c52416550D1; \n        } else if (block.chainid == 1 || block.chainid == 5) {\n            router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; \n        } else {\n            revert();\n        }\n\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\n            .createPair(address(this), _uniswapV2Router.WETH());\n        uniswapV2Router = _uniswapV2Router;\n\n        _approve(address(this), address(uniswapV2Router), MAX);\n\n        taxFeeonBuy = 0;\n        taxFeeonSell = 5;\n\n        liquidityFeeonBuy = 0;\n        liquidityFeeonSell = 0;\n\n        marketingFeeonBuy = 5;\n        marketingFeeonSell = 5;\n\n        totalBuyFees = taxFeeonBuy + liquidityFeeonBuy + marketingFeeonBuy;\n        totalSellFees = taxFeeonSell + liquidityFeeonSell + marketingFeeonSell;\n\n        marketingWallet = 0x61dC0731569BC2Aa34B54aD3DA6c3dE3214A72DC;\n        \n        swapEnabled = true;\n        swapTokensAtAmount = _tTotal / 5000;\n    \n        walletToWalletTransferWithoutFee = true;\n        \n        _isExcludedFromFees[owner()] = true;\n        _isExcludedFromFees[address(0xdead)] = true;\n        _isExcludedFromFees[address(this)] = true;\n\n        _isExcluded[address(this)] = true;\n        _isExcluded[address(0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE)] = true; //pinklock\n        _isExcluded[address(0xdead)] = true;\n        _isExcluded[address(uniswapV2Pair)] = true;\n\n        _rOwned[owner()] = _rTotal;\n        _tOwned[owner()] = _tTotal;\n\n        emit Transfer(address(0), owner(), _tTotal);\n    }\n\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public view override returns (uint256) {\n        return _tTotal;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        if (_isExcluded[account]) return _tOwned[account];\n        return tokenFromReflection(_rOwned[account]);\n    }\n\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);\n        return true;\n    }\n\n    function isExcludedFromReward(address account) public view returns (bool) {\n        return _isExcluded[account];\n    }\n\n    function totalReflectionDistributed() public view returns (uint256) {\n        return _tFeeTotal;\n    }\n\n    function deliver(uint256 tAmount) public {\n        address sender = _msgSender();\n        require(!_isExcluded[sender], \"Excluded addresses cannot call this function\");\n        (uint256 rAmount,,,,,,) = _getValues(tAmount);\n        _rOwned[sender] = _rOwned[sender] - rAmount;\n        _rTotal = _rTotal - rAmount;\n        _tFeeTotal = _tFeeTotal + tAmount;\n    }\n\n    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {\n        require(tAmount <= _tTotal, \"Amount must be less than supply\");\n        if (!deductTransferFee) {\n            (uint256 rAmount,,,,,,) = _getValues(tAmount);\n            return rAmount;\n        } else {\n            (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);\n            return rTransferAmount;\n        }\n    }\n\n    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {\n        require(rAmount <= _rTotal, \"Amount must be less than total reflections\");\n        uint256 currentRate =  _getRate();\n        return rAmount / currentRate;\n    }\n\n    function excludeFromReward(address account) public onlyOwner() {\n        require(!_isExcluded[account], \"Account is already excluded\");\n        if(_rOwned[account] > 0) {\n            _tOwned[account] = tokenFromReflection(_rOwned[account]);\n        }\n        _isExcluded[account] = true;\n        _excluded.push(account);\n    }\n\n    function includeInReward(address account) external onlyOwner() {\n        require(_isExcluded[account], \"Account is already included\");\n        for (uint256 i = 0; i < _excluded.length; i++) {\n            if (_excluded[i] == account) {\n                _excluded[i] = _excluded[_excluded.length - 1];\n                _tOwned[account] = 0;\n                _isExcluded[account] = false;\n                _excluded.pop();\n                break;\n            }\n        }\n    }\n\n    receive() external payable {}\n\n    function claimStuckTokens(address token) external onlyOwner {\n        require(token != address(this), \"Owner cannot claim native tokens\");\n        if (token == address(0x0)) {\n            payable(msg.sender).sendValue(address(this).balance);\n            return;\n        }\n        IERC20 ERC20token = IERC20(token);\n        uint256 balance = ERC20token.balanceOf(address(this));\n        ERC20token.transfer(msg.sender, balance);\n    }\n\n    function _reflectFee(uint256 rFee, uint256 tFee) private {\n        _rTotal = _rTotal - rFee;\n        _tFeeTotal = _tFeeTotal + tFee;\n    }\n\n    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {\n        (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getTValues(tAmount);\n        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, _getRate());\n        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tMarketing);\n    }\n\n    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {\n        uint256 tFee = calculateTaxFee(tAmount);\n        uint256 tLiquidity = calculateLiquidityFee(tAmount);\n        uint256 tMarketing = calculateMarketingFee(tAmount);\n        uint256 tTransferAmount = tAmount - tFee - tLiquidity - tMarketing;\n        return (tTransferAmount, tFee, tLiquidity, tMarketing);\n    }\n\n    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {\n        uint256 rAmount = tAmount * currentRate;\n        uint256 rFee = tFee * currentRate;\n        uint256 rLiquidity = tLiquidity * currentRate;\n        uint256 rMarketing = tMarketing * currentRate;\n        uint256 rTransferAmount = rAmount - rFee - rLiquidity - rMarketing;\n        return (rAmount, rTransferAmount, rFee);\n    }\n\n    function _getRate() private view returns(uint256) {\n        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n        return rSupply / tSupply;\n    }\n\n    function _getCurrentSupply() private view returns(uint256, uint256) {\n        uint256 rSupply = _rTotal;\n        uint256 tSupply = _tTotal;      \n        for (uint256 i = 0; i < _excluded.length; i++) {\n            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);\n            rSupply = rSupply - _rOwned[_excluded[i]];\n            tSupply = tSupply - _tOwned[_excluded[i]];\n        }\n        if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);\n        return (rSupply, tSupply);\n    }\n    \n    function _takeLiquidity(uint256 tLiquidity) private {\n        if (tLiquidity > 0) {\n            uint256 currentRate =  _getRate();\n            uint256 rLiquidity = tLiquidity * currentRate;\n            _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;\n            if(_isExcluded[address(this)])\n                _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;\n        }\n    }\n\n    function _takeMarketing(uint256 tMarketing) private {\n        if (tMarketing > 0) {\n            uint256 currentRate =  _getRate();\n            uint256 rMarketing = tMarketing * currentRate;\n            _rOwned[address(this)] = _rOwned[address(this)] + rMarketing;\n            if(_isExcluded[address(this)])\n                _tOwned[address(this)] = _tOwned[address(this)] + tMarketing;\n        }\n    }\n    \n    function calculateTaxFee(uint256 _amount) private view returns (uint256) {\n        return _amount * _taxFee / 100;\n    }\n\n    function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {\n        return _amount * _liquidityFee / 100;\n    }\n    \n    function calculateMarketingFee(uint256 _amount) private view returns (uint256) {\n        return _amount * _marketingFee / 100;\n    }\n    \n    function removeAllFee() private {\n        if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;\n        \n        _taxFee = 0;\n        _marketingFee = 0;\n        _liquidityFee = 0;\n    }\n    \n    function setBuyFee() private{\n        if(_taxFee == taxFeeonBuy && _liquidityFee == liquidityFeeonBuy && _marketingFee == marketingFeeonBuy) return;\n\n        _taxFee = taxFeeonBuy;\n        _marketingFee = marketingFeeonBuy;\n        _liquidityFee = liquidityFeeonBuy;\n    }\n\n    function setSellFee() private{\n        if(_taxFee == taxFeeonSell && _liquidityFee == liquidityFeeonSell && _marketingFee == marketingFeeonSell) return;\n\n        _taxFee = taxFeeonSell;\n        _marketingFee = marketingFeeonSell;\n        _liquidityFee = liquidityFeeonSell;\n    }\n    \n    function isExcludedFromFee(address account) public view returns(bool) {\n        return _isExcludedFromFees[account];\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function enableTrading() external onlyOwner{\n        require(tradingEnabled == false, \"Trading is already enabled\");\n        tradingEnabled = true;\n    }\n    \n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) private {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n\n        if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {\n            require(tradingEnabled, \"Trading is not enabled yet\");\n        }\n\n        uint256 contractTokenBalance = balanceOf(address(this));        \n        bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;\n        if (\n            overMinTokenBalance &&\n            !inSwapAndLiquify &&\n            to == uniswapV2Pair &&\n            swapEnabled\n        ) {\n            inSwapAndLiquify = true;\n            \n            uint256 marketingShare = marketingFeeonBuy + marketingFeeonSell;\n            uint256 liquidityShare = liquidityFeeonBuy + liquidityFeeonSell;\n            uint256 totalShare = marketingShare + liquidityShare;\n            if(totalShare > 0) {\n                if(liquidityShare > 0) {\n                    uint256 liquidityTokens = (contractTokenBalance * liquidityShare) / totalShare;\n                    swapAndLiquify(liquidityTokens);\n                }\n                \n                if(marketingShare > 0) {\n                    uint256 marketingTokens = (contractTokenBalance * marketingShare) / totalShare;\n                    swapAndSendMarketing(marketingTokens);\n                } \n            }\n            inSwapAndLiquify = false;\n        }\n        \n        //transfer amount, it will take tax, burn, liquidity fee\n        _tokenTransfer(from,to,amount);\n    }\n\n    function swapAndLiquify(uint256 tokens) private {\n        uint256 half = tokens / 2;\n        uint256 otherHalf = tokens - half;\n\n        uint256 initialBalance = address(this).balance;\n\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            half,\n            0, // accept any amount of ETH\n            path,\n            address(this),\n            block.timestamp);\n        \n        uint256 newBalance = address(this).balance - initialBalance;\n\n        uniswapV2Router.addLiquidityETH{value: newBalance}(\n            address(this),\n            otherHalf,\n            0, // slippage is unavoidable\n            0, // slippage is unavoidable\n            DEAD,\n            block.timestamp\n        );\n\n        emit SwapAndLiquify(half, newBalance, otherHalf);\n    }\n\n    function swapAndSendMarketing(uint256 tokenAmount) private {\n        uint256 initialBalance = address(this).balance;\n\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of ETH\n            path,\n            address(this),\n            block.timestamp);\n\n        uint256 newBalance = address(this).balance - initialBalance;\n\n        payable(marketingWallet).sendValue(newBalance);\n\n        emit SwapAndSendMarketing(tokenAmount, newBalance);\n    }\n\n    function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner() {\n        require(newAmount > totalSupply() / 1e5, \"SwapTokensAtAmount must be greater than 0.001% of total supply\");\n        swapTokensAtAmount = newAmount;\n        emit SwapTokensAtAmountUpdated(newAmount);\n    }\n    \n    function setSwapEnabled(bool _enabled) external onlyOwner {\n        swapEnabled = _enabled;\n        emit SwapEnabledUpdated(_enabled);\n    }\n\n    function _tokenTransfer(address sender, address recipient, uint256 amount) private {\n         if (_isExcludedFromFees[sender] || \n            _isExcludedFromFees[recipient] \n            ) {\n            removeAllFee();\n        }else if(recipient == uniswapV2Pair){\n            setSellFee();\n        }else if(sender == uniswapV2Pair){\n            setBuyFee();\n        }else if(walletToWalletTransferWithoutFee){\n            removeAllFee();\n        }else{\n            setSellFee();\n        }\n\n        if (_isExcluded[sender] && !_isExcluded[recipient]) {\n            _transferFromExcluded(sender, recipient, amount);\n        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {\n            _transferToExcluded(sender, recipient, amount);\n        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {\n            _transferStandard(sender, recipient, amount);\n        } else if (_isExcluded[sender] && _isExcluded[recipient]) {\n            _transferBothExcluded(sender, recipient, amount);\n        } else {\n            _transferStandard(sender, recipient, amount);\n        }\n\n    }\n\n    function _transferStandard(address sender, address recipient, uint256 tAmount) private {\n        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);\n        _rOwned[sender] = _rOwned[sender] - rAmount;\n        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;\n        _takeMarketing(tMarketing);\n        _takeLiquidity(tLiquidity);\n        _reflectFee(rFee, tFee);\n        emit Transfer(sender, recipient, tTransferAmount);\n    }\n\n    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {\n        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);\n        _rOwned[sender] = _rOwned[sender] - rAmount;\n        _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;\n        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;\n        _takeMarketing(tMarketing);           \n        _takeLiquidity(tLiquidity);\n        _reflectFee(rFee, tFee);\n        emit Transfer(sender, recipient, tTransferAmount);\n    }\n\n    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {\n        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);\n        _tOwned[sender] = _tOwned[sender] - tAmount;\n        _rOwned[sender] = _rOwned[sender] - rAmount;\n        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount; \n        _takeMarketing(tMarketing);  \n        _takeLiquidity(tLiquidity);\n        _reflectFee(rFee, tFee);\n        emit Transfer(sender, recipient, tTransferAmount);\n    }\n\n    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {\n        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);\n        _tOwned[sender] = _tOwned[sender] - tAmount;\n        _rOwned[sender] = _rOwned[sender] - rAmount;\n        _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;\n        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;\n        _takeMarketing(tMarketing);        \n        _takeLiquidity(tLiquidity);\n        _reflectFee(rFee, tFee);\n        emit Transfer(sender, recipient, tTransferAmount);\n    }\n\n    function excludeFromFees(address account, bool excluded) external onlyOwner {\n        require(_isExcludedFromFees[account] != excluded, \"Account is already the value of 'excluded'\");\n        _isExcludedFromFees[account] = excluded;\n\n        emit ExcludeFromFees(account, excluded);\n    }\n    \n    function changeMarketingWallet(address _marketingWallet) external onlyOwner {\n        require(_marketingWallet != marketingWallet, \"Marketing wallet is already that address\");\n        require(_marketingWallet!=address(0), \"Marketing wallet is the zero address\");\n        marketingWallet = _marketingWallet;\n        emit MarketingWalletChanged(marketingWallet);\n    }\n\n    function setBuyFeePercentages(uint256 _taxFeeonBuy, uint256 _liquidityFeeonBuy, uint256 _marketingFeeonBuy) external onlyOwner {\n        taxFeeonBuy = _taxFeeonBuy;\n        liquidityFeeonBuy = _liquidityFeeonBuy;\n        marketingFeeonBuy = _marketingFeeonBuy;\n        totalBuyFees = _taxFeeonBuy + _liquidityFeeonBuy + _marketingFeeonBuy;\n        require(totalBuyFees <= 10, \"Buy fees cannot be greater than 10%\");\n        emit BuyFeesChanged(taxFeeonBuy, liquidityFeeonBuy, marketingFeeonBuy);\n    }\n\n    function setSellFeePercentages(uint256 _taxFeeonSell, uint256 _liquidityFeeonSell, uint256 _marketingFeeonSell) external onlyOwner {\n        taxFeeonSell = _taxFeeonSell;\n        liquidityFeeonSell = _liquidityFeeonSell;\n        marketingFeeonSell = _marketingFeeonSell;\n        totalSellFees = _taxFeeonSell + _liquidityFeeonSell + _marketingFeeonSell;\n        require(totalSellFees <= 10, \"Sell fees cannot be greater than 10%\");\n        emit SellFeesChanged(taxFeeonSell, liquidityFeeonSell, marketingFeeonSell);\n    }\n\n    function enableWalletToWalletTransferWithoutFee(bool enable) external onlyOwner {\n        require(walletToWalletTransferWithoutFee != enable, \"Wallet to wallet transfer without fee is already set to that value\");\n        walletToWalletTransferWithoutFee = enable;\n        emit WalletToWalletTransferWithoutFeeEnabled(enable);\n    }\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 2000
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
    "metadata": {
      "useLiteralContent": true
    },
    "libraries": {}
  }
}}