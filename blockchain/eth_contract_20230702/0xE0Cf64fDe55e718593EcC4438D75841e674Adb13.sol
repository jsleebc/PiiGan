{{
  "language": "Solidity",
  "sources": {
    "contracts/NembusToken.sol": {
      "content": "// SPDX-License-Identifier: Unlicensed\n\npragma solidity ^0.8.4;\n\nabstract contract Context {\n\n    function _msgSender() internal view virtual returns (address payable) {\n        return payable(msg.sender);\n    }\n\n    function _msgData() internal view virtual returns (bytes memory) {\n        this;\n        return msg.data;\n    }\n}\n\ninterface IERC20 {\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\nlibrary SafeMath {\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c >= a, \"SafeMath: addition overflow\");\n\n        return c;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b <= a, errorMessage);\n        uint256 c = a - b;\n\n        return c;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        if (a == 0) {\n            return 0;\n        }\n\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n\n        return c;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b > 0, errorMessage);\n        uint256 c = a / b;\n        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n\n        return c;\n    }\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return mod(a, b, \"SafeMath: modulo by zero\");\n    }\n\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b != 0, errorMessage);\n        return a % b;\n    }\n}\n\nlibrary Address {\n\n    function isContract(address account) internal view returns (bool) {\n        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n        // for accounts without code, i.e. `keccak256('')`\n        bytes32 codehash;\n        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n        // solhint-disable-next-line no-inline-assembly\n        assembly {codehash := extcodehash(account)}\n        return (codehash != accountHash && codehash != 0x0);\n    }\n\n    function sendValue(address payable recipient, uint256 amount) internal {\n        require(address(this).balance >= amount, \"Address: insufficient balance\");\n\n        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n        (bool success,) = recipient.call{value : amount}(\"\");\n        require(success, \"Address: unable to send value, recipient may have reverted\");\n    }\n\n    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n        return functionCall(target, data, \"Address: low-level call failed\");\n    }\n\n    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n        return _functionCallWithValue(target, data, 0, errorMessage);\n    }\n\n    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n        return functionCallWithValue(target, data, value, \"Address: low-level call with value failed\");\n    }\n\n    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n        require(address(this).balance >= value, \"Address: insufficient balance for call\");\n        return _functionCallWithValue(target, data, value, errorMessage);\n    }\n\n    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n        require(isContract(target), \"Address: call to non-contract\");\n\n        (bool success, bytes memory returndata) = target.call{value : weiValue}(data);\n        if (success) {\n            return returndata;\n        } else {\n\n            if (returndata.length > 0) {\n                assembly {\n                    let returndata_size := mload(returndata)\n                    revert(add(32, returndata), returndata_size)\n                }\n            } else {\n                revert(errorMessage);\n            }\n        }\n    }\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\ninterface IUniswapV2Factory {\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n\n    function feeTo() external view returns (address);\n\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\n\n    function allPairs(uint) external view returns (address pair);\n\n    function allPairsLength() external view returns (uint);\n\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n\n    function setFeeTo(address) external;\n\n    function setFeeToSetter(address) external;\n}\n\ninterface IUniswapV2Pair {\n    event Approval(address indexed owner, address indexed spender, uint value);\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function name() external pure returns (string memory);\n\n    function symbol() external pure returns (string memory);\n\n    function decimals() external pure returns (uint8);\n\n    function totalSupply() external view returns (uint);\n\n    function balanceOf(address owner) external view returns (uint);\n\n    function allowance(address owner, address spender) external view returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n\n    function transfer(address to, uint value) external returns (bool);\n\n    function transferFrom(address from, address to, uint value) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n\n    function nonces(address owner) external view returns (uint);\n\n    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n\n    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n    event Swap(\n        address indexed sender,\n        uint amount0In,\n        uint amount1In,\n        uint amount0Out,\n        uint amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\n\n    function factory() external view returns (address);\n\n    function token0() external view returns (address);\n\n    function token1() external view returns (address);\n\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n\n    function price0CumulativeLast() external view returns (uint);\n\n    function price1CumulativeLast() external view returns (uint);\n\n    function kLast() external view returns (uint);\n\n    function burn(address to) external returns (uint amount0, uint amount1);\n\n    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n\n    function skim(address to) external;\n\n    function sync() external;\n\n    function initialize(address, address) external;\n}\n\ninterface IUniswapV2Router01 {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n\n    function removeLiquidity(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB);\n\n    function removeLiquidityETH(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountToken, uint amountETH);\n\n    function removeLiquidityWithPermit(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountA, uint amountB);\n\n    function removeLiquidityETHWithPermit(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountToken, uint amountETH);\n\n    function swapExactTokensForTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n\n    function swapTokensForExactTokens(\n        uint amountOut,\n        uint amountInMax,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n    external\n    payable\n    returns (uint[] memory amounts);\n\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n    external\n    returns (uint[] memory amounts);\n\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n    external\n    returns (uint[] memory amounts);\n\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n    external\n    payable\n    returns (uint[] memory amounts);\n\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n}\n\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountETH);\n\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountETH);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n\ncontract NembusToken is Context, IERC20, Ownable {\n\n    using SafeMath for uint256;\n    using Address for address;\n\n    string private _name;\n    string private _symbol;\n    uint8 private _decimals;\n    address payable public marketingWalletAddress;\n    address payable public teamWalletAddress;\n    address public deadAddress = address(0);\n\n    mapping(address => uint256) _balances;\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    mapping(address => bool) public isExcludedFromFee;\n    mapping(address => bool) public isWalletLimitExempt;\n    mapping(address => bool) public isMarketPair;\n\n    uint256 public _buyLiquidityFee;\n    uint256 public _buyMarketingFee;\n    uint256 public _buyTeamFee;\n    uint256 public _buyBurnFee;\n\n    uint256 public _sellLiquidityFee;\n    uint256 public _sellMarketingFee;\n    uint256 public _sellTeamFee;\n    uint256 public _sellBurnFee;\n\n    uint256 public _liquidityShare;\n    uint256 public _marketingShare;\n    uint256 public _teamShare;\n    uint256 public _totalDistributionShares;\n\n    uint256 public _totalTaxIfBuying;\n    uint256 public _totalTaxIfSelling;\n\n    uint256 public _totalBurnedTokens;\n    uint256 public _maxBurnAmount;\n    uint256 private _totalSupply;\n    uint256 public _walletMax;\n    uint256 private _minimumTokensBeforeSwap;\n\n    IUniswapV2Router02 public uniswapV2Router;\n    address public uniswapPair;\n\n    bool inSwapAndLiquify;\n    bool public swapAndLiquifyEnabled = true;\n    bool public swapAndLiquifyByLimitOnly = false;\n    bool public checkWalletLimit = true;\n\n    event SwapAndLiquifyEnabledUpdated(bool enabled);\n    event SwapAndLiquify(\n        uint256 tokensSwapped,\n        uint256 ethReceived,\n        uint256 tokensIntoLiqudity\n    );\n\n    event SwapETHForTokens(\n        uint256 amountIn,\n        address[] path\n    );\n\n    event SwapTokensForETH(\n        uint256 amountIn,\n        address[] path\n    );\n\n    modifier lockTheSwap {\n        inSwapAndLiquify = true;\n        _;\n        inSwapAndLiquify = false;\n    }\n\n    constructor(address router) {\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);\n        uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())\n        .createPair(address(this), _uniswapV2Router.WETH());\n        uniswapV2Router = _uniswapV2Router;\n\n        // Base token info\n        _name = \"NembusToken\";\n        _symbol = \"NEMBUS\";\n        _decimals = 6;\n        _totalSupply = 1000000000000 * 10 ** _decimals;\n\n        // Limits\n        _walletMax = 20000000000 * 10 ** _decimals;\n        _maxBurnAmount = 1000000000000 * 10 ** _decimals;\n        _minimumTokensBeforeSwap = 0 * 10 ** _decimals;\n\n        // Wallets\n        marketingWalletAddress = payable(owner());\n        teamWalletAddress = payable(owner());\n\n        // Fees\n        _buyLiquidityFee = 0;\n        _buyMarketingFee = 3;\n        _buyTeamFee = 0;\n        _buyBurnFee = 0;\n\n        _sellLiquidityFee = 0;\n        _sellMarketingFee = 3;\n        _sellTeamFee = 0;\n        _sellBurnFee = 0;\n\n        _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);\n        _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);\n\n        // Shares\n        _liquidityShare = 0;\n        _marketingShare = 100;\n        _teamShare = 0;\n        _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);\n\n        isExcludedFromFee[owner()] = true;\n        isExcludedFromFee[address(this)] = true;\n\n        isWalletLimitExempt[owner()] = true;\n        isWalletLimitExempt[address(uniswapPair)] = true;\n        isWalletLimitExempt[address(this)] = true;\n        isWalletLimitExempt[deadAddress] = true;\n\n        isMarketPair[address(uniswapPair)] = true;\n\n        // Mint tokens\n        _balances[address(this)] = _totalSupply;\n        emit Transfer(address(0), address(this), _totalSupply);\n    }\n\n    function addInitialLiquidity() external payable onlyOwner {\n        // Approve tokens\n        _allowances[address(this)][address(uniswapV2Router)] = balanceOf(address(this));\n\n        // Disable\n        isExcludedFromFee[address(uniswapV2Router)] = true;\n        swapAndLiquifyEnabled = false;\n\n        // Init liquidity pool\n        uniswapV2Router.addLiquidityETH{value : address(this).balance}(\n            address(this),\n            _totalSupply,\n            0,\n            0,\n            owner(),\n            block.timestamp\n        );\n\n        // Enable\n        isExcludedFromFee[address(uniswapV2Router)] = false;\n        swapAndLiquifyEnabled = true;\n    }\n\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public view override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _balances[account];\n    }\n\n    function allowance(address owner, address spender) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, \"ERC20: decreased allowance below zero\"));\n        return true;\n    }\n\n    function minimumTokensBeforeSwapAmount() public view returns (uint256) {\n        return _minimumTokensBeforeSwap;\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function setMarketPairStatus(address account, bool newValue) public onlyOwner {\n        isMarketPair[account] = newValue;\n    }\n\n    function setMaxBurnAmount(uint256 maxBurn) public onlyOwner {\n        _maxBurnAmount = maxBurn;\n    }\n\n    function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax, uint256 newBurnTax) external onlyOwner() {\n        require(newLiquidityTax + newMarketingTax + newTeamTax + newBurnTax <= 5, \"Buy tax can't be grater than 5%\");\n        _buyLiquidityFee = newLiquidityTax;\n        _buyMarketingFee = newMarketingTax;\n        _buyTeamFee = newTeamTax;\n        _buyBurnFee = newBurnTax;\n\n        _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee).add(_buyBurnFee);\n    }\n\n    function setSellTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax, uint256 newBurnTax) external onlyOwner() {\n        require(newLiquidityTax + newMarketingTax + newTeamTax + newBurnTax <= 5, \"Sell tax can't be grater than 5%\");\n        _sellLiquidityFee = newLiquidityTax;\n        _sellMarketingFee = newMarketingTax;\n        _sellTeamFee = newTeamTax;\n        _sellBurnFee = newBurnTax;\n\n        _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee).add(_sellBurnFee);\n    }\n\n    function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newTeamShare) external onlyOwner() {\n        _liquidityShare = newLiquidityShare;\n        _marketingShare = newMarketingShare;\n        _teamShare = newTeamShare;\n\n        _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);\n    }\n\n    function enableDisableWalletLimit(bool newValue) external onlyOwner {\n        checkWalletLimit = newValue;\n    }\n\n    function setWalletLimit(uint256 newLimit) external onlyOwner {\n        _walletMax = newLimit;\n    }\n\n    function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {\n        _minimumTokensBeforeSwap = newLimit;\n    }\n\n    function setMarketingWalletAddress(address newAddress) external onlyOwner() {\n        marketingWalletAddress = payable(newAddress);\n    }\n\n    function setTeamWalletAddress(address newAddress) external onlyOwner() {\n        teamWalletAddress = payable(newAddress);\n    }\n\n    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {\n        swapAndLiquifyEnabled = _enabled;\n        emit SwapAndLiquifyEnabledUpdated(_enabled);\n    }\n\n    function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {\n        swapAndLiquifyByLimitOnly = newValue;\n    }\n\n    function getCirculatingSupply() public view returns (uint256) {\n        return _totalSupply.sub(balanceOf(deadAddress));\n    }\n\n    function transferToAddressETH(address payable recipient, uint256 amount) private {\n        recipient.transfer(amount);\n    }\n\n    function changeRouterVersion(address newRouterAddress) public onlyOwner returns (address newPairAddress) {\n\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress);\n\n        newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());\n\n        if (newPairAddress == address(0)) //Create If Doesnt exist\n        {\n            newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())\n            .createPair(address(this), _uniswapV2Router.WETH());\n        }\n\n        uniswapPair = newPairAddress;\n        //Set new pair address\n        uniswapV2Router = _uniswapV2Router;\n        //Set new router address\n\n        isWalletLimitExempt[address(uniswapPair)] = true;\n        isMarketPair[address(uniswapPair)] = true;\n    }\n\n    //to receive ETH from uniswapV2Router when swapping\n    receive() external payable {}\n\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\n        return true;\n    }\n\n    function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n        if (inSwapAndLiquify) {\n            return _basicTransfer(sender, recipient, amount);\n        } else {\n            uint256 contractTokenBalance = balanceOf(address(this));\n            bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;\n\n            if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) {\n                if (swapAndLiquifyByLimitOnly) {\n                    contractTokenBalance = _minimumTokensBeforeSwap;\n                }\n                swapAndLiquify(contractTokenBalance);\n            }\n\n            _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\n\n            uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient])\n            ? amount : takeFees(sender, recipient, amount);\n\n            if (checkWalletLimit && !isWalletLimitExempt[recipient]) {\n                require(balanceOf(recipient).add(finalAmount) <= _walletMax);\n            }\n\n            _balances[recipient] = _balances[recipient].add(finalAmount);\n            emit Transfer(sender, recipient, finalAmount);\n\n            return true;\n        }\n    }\n\n    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\n        _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\n        _balances[recipient] = _balances[recipient].add(amount);\n        emit Transfer(sender, recipient, amount);\n        return true;\n    }\n\n    function swapAndLiquify(uint256 tAmount) private lockTheSwap {\n        uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);\n        uint256 tokensForSwap = tAmount.sub(tokensForLP);\n\n        swapTokensForEth(tokensForSwap);\n        uint256 amountReceived = address(this).balance;\n\n        uint256 totalFee = _totalDistributionShares.sub(_liquidityShare.div(2));\n\n        uint256 amountLiquidity = amountReceived.mul(_liquidityShare).div(totalFee).div(2);\n        uint256 amountTeam = amountReceived.mul(_teamShare).div(totalFee);\n        uint256 amountMarketing = amountReceived.sub(amountLiquidity).sub(amountTeam);\n\n        if (amountMarketing > 0)\n            transferToAddressETH(marketingWalletAddress, amountMarketing);\n\n        if (amountTeam > 0)\n            transferToAddressETH(teamWalletAddress, amountTeam);\n\n        if (amountLiquidity > 0 && tokensForLP > 0)\n            addLiquidity(tokensForLP, amountLiquidity);\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private {\n        // generate the uniswap pair path of token -> weth\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // make the swap\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of ETH\n            path,\n            address(this), // The contract\n            block.timestamp\n        );\n\n        emit SwapTokensForETH(tokenAmount, path);\n    }\n\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\n        // approve token transfer to cover all possible scenarios\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\n\n        // add the liquidity\n        uniswapV2Router.addLiquidityETH{value : ethAmount}(\n            address(this),\n            tokenAmount,\n            0, // slippage is unavoidable\n            0, // slippage is unavoidable\n            owner(),\n            block.timestamp\n        );\n    }\n\n    function takeFees(address sender, address recipient, uint256 amount) internal returns (uint256) {\n        uint256 feeAmount = 0;\n        uint256 burnAmount = 0;\n\n        if (isMarketPair[sender]) {\n            feeAmount = amount.mul(_totalTaxIfBuying.sub(_buyBurnFee)).div(100);\n            if (_buyBurnFee > 0 && _totalBurnedTokens < _maxBurnAmount) {\n                burnAmount = amount.mul(_buyBurnFee).div(100);\n                takeBurnFee(sender, burnAmount);\n            }\n        } else if (isMarketPair[recipient]) {\n            feeAmount = amount.mul(_totalTaxIfSelling.sub(_sellBurnFee)).div(100);\n            if (_sellBurnFee > 0 && _totalBurnedTokens < _maxBurnAmount) {\n                burnAmount = amount.mul(_sellBurnFee).div(100);\n                takeBurnFee(sender, burnAmount);\n            }\n        }\n\n        if (feeAmount > 0) {\n            _balances[address(this)] = _balances[address(this)].add(feeAmount);\n            emit Transfer(sender, address(this), feeAmount);\n        }\n\n        return amount.sub(feeAmount.add(burnAmount));\n    }\n\n    function takeBurnFee(address sender, uint256 tAmount) private {\n        // stop burn\n        if (_totalBurnedTokens >= _maxBurnAmount) return;\n\n        _balances[deadAddress] = _balances[deadAddress].add(tAmount);\n        _totalBurnedTokens = _totalBurnedTokens.add(tAmount);\n        emit Transfer(sender, deadAddress, tAmount);\n    }\n}"
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
    },
    "libraries": {}
  }
}}