{{
  "language": "Solidity",
  "sources": {
    "Booty.sol": {
      "content": "// SPDX-License-Identifier: Unlicense\r\npragma solidity ^0.8.17;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(address recipient, uint256 amount)\r\n        external\r\n        returns (bool);\r\n\r\n    function allowance(address owner, address spender)\r\n        external\r\n        view\r\n        returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n}\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a + b;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a - b;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a * b;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a / b;\r\n    }\r\n\r\n    function sub(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b <= a, errorMessage);\r\n            return a - b;\r\n        }\r\n    }\r\n\r\n    function div(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        //Contract By Techaddict\r\n        unchecked {\r\n            require(b > 0, errorMessage);\r\n            return a / b;\r\n        }\r\n    }\r\n}\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        this;\r\n        return msg.data;\r\n    }\r\n}\r\n\r\nlibrary Address {\r\n    function isContract(address account) internal view returns (bool) {\r\n        uint256 size;\r\n        assembly {\r\n            size := extcodesize(account)\r\n        }\r\n        return size > 0;\r\n    }\r\n\r\n    function sendValue(address payable recipient, uint256 amount) internal {\r\n        require(\r\n            address(this).balance >= amount,\r\n            \"Address: insufficient balance\"\r\n        );\r\n        (bool success, ) = recipient.call{value: amount}(\"\");\r\n        require(\r\n            success,\r\n            \"Address: unable to send value, recipient may have reverted\"\r\n        );\r\n    }\r\n\r\n    function functionCall(address target, bytes memory data)\r\n        internal\r\n        returns (bytes memory)\r\n    {\r\n        return functionCall(target, data, \"Address: low-level call failed\");\r\n    }\r\n\r\n    function functionCall(\r\n        address target,\r\n        bytes memory data,\r\n        string memory errorMessage\r\n    ) internal returns (bytes memory) {\r\n        return functionCallWithValue(target, data, 0, errorMessage);\r\n    }\r\n\r\n    function functionCallWithValue(\r\n        address target,\r\n        bytes memory data,\r\n        uint256 value\r\n    ) internal returns (bytes memory) {\r\n        return\r\n            functionCallWithValue(\r\n                target,\r\n                data,\r\n                value,\r\n                \"Address: low-level call with value failed\"\r\n            );\r\n    }\r\n\r\n    function functionCallWithValue(\r\n        address target,\r\n        bytes memory data,\r\n        uint256 value,\r\n        string memory errorMessage\r\n    ) internal returns (bytes memory) {\r\n        require(\r\n            address(this).balance >= value,\r\n            \"Address: insufficient balance for call\"\r\n        );\r\n        require(isContract(target), \"Address: call to non-contract\");\r\n        (bool success, bytes memory returndata) = target.call{value: value}(\r\n            data\r\n        );\r\n        return _verifyCallResult(success, returndata, errorMessage);\r\n    }\r\n\r\n    function functionStaticCall(address target, bytes memory data)\r\n        internal\r\n        view\r\n        returns (bytes memory)\r\n    {\r\n        return\r\n            functionStaticCall(\r\n                target,\r\n                data,\r\n                \"Address: low-level static call failed\"\r\n            );\r\n    }\r\n\r\n    function functionStaticCall(\r\n        address target,\r\n        bytes memory data,\r\n        string memory errorMessage\r\n    ) internal view returns (bytes memory) {\r\n        require(isContract(target), \"Address: static call to non-contract\");\r\n        (bool success, bytes memory returndata) = target.staticcall(data);\r\n        return _verifyCallResult(success, returndata, errorMessage);\r\n    }\r\n\r\n    function functionDelegateCall(address target, bytes memory data)\r\n        internal\r\n        returns (bytes memory)\r\n    {\r\n        return\r\n            functionDelegateCall(\r\n                target,\r\n                data,\r\n                \"Address: low-level delegate call failed\"\r\n            );\r\n    }\r\n\r\n    function functionDelegateCall(\r\n        address target,\r\n        bytes memory data,\r\n        string memory errorMessage\r\n    ) internal returns (bytes memory) {\r\n        require(isContract(target), \"Address: delegate call to non-contract\");\r\n        (bool success, bytes memory returndata) = target.delegatecall(data);\r\n        return _verifyCallResult(success, returndata, errorMessage);\r\n    }\r\n\r\n    function _verifyCallResult(\r\n        bool success,\r\n        bytes memory returndata,\r\n        string memory errorMessage\r\n    ) private pure returns (bytes memory) {\r\n        if (success) {\r\n            return returndata;\r\n        } else {\r\n            if (returndata.length > 0) {\r\n                assembly {\r\n                    let returndata_size := mload(returndata)\r\n                    revert(add(32, returndata), returndata_size)\r\n                }\r\n            } else {\r\n                revert(errorMessage);\r\n            }\r\n        }\r\n    }\r\n}\r\n\r\nabstract contract Ownable is Context {\r\n    address private _owner;\r\n\r\n    // Set original owner\r\n    event OwnershipTransferred(\r\n        address indexed previousOwner,\r\n        address indexed newOwner\r\n    );\r\n\r\n    constructor() {\r\n        _owner = msg.sender;\r\n        emit OwnershipTransferred(address(0), _owner);\r\n    }\r\n\r\n    // Return current owner\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    // Restrict function to contract owner only\r\n    modifier onlyOwner() {\r\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    // Renounce ownership of the contract\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    // Transfer the contract to to a new owner\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(\r\n            newOwner != address(0),\r\n            \"Ownable: new owner is the zero address\"\r\n        );\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(\r\n        address indexed token0,\r\n        address indexed token1,\r\n        address pair,\r\n        uint256\r\n    );\r\n\r\n    function feeTo() external view returns (address);\r\n\r\n    function feeToSetter() external view returns (address);\r\n\r\n    function getPair(address tokenA, address tokenB)\r\n        external\r\n        view\r\n        returns (address pair);\r\n\r\n    function allPairs(uint256) external view returns (address pair);\r\n\r\n    function allPairsLength() external view returns (uint256);\r\n\r\n    function createPair(address tokenA, address tokenB)\r\n        external\r\n        returns (address pair);\r\n\r\n    function setFeeTo(address) external;\r\n\r\n    function setFeeToSetter(address) external;\r\n}\r\n\r\ninterface IUniswapV2Pair {\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    function name() external pure returns (string memory);\r\n\r\n    function symbol() external pure returns (string memory);\r\n\r\n    function decimals() external pure returns (uint8);\r\n\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address owner) external view returns (uint256);\r\n\r\n    function allowance(address owner, address spender)\r\n        external\r\n        view\r\n        returns (uint256);\r\n\r\n    function approve(address spender, uint256 value) external returns (bool);\r\n\r\n    function transfer(address to, uint256 value) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address from,\r\n        address to,\r\n        uint256 value\r\n    ) external returns (bool);\r\n\r\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\r\n\r\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\r\n\r\n    function nonces(address owner) external view returns (uint256);\r\n\r\n    function permit(\r\n        address owner,\r\n        address spender,\r\n        uint256 value,\r\n        uint256 deadline,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) external;\r\n\r\n    event Burn(\r\n        address indexed sender,\r\n        uint256 amount0,\r\n        uint256 amount1,\r\n        address indexed to\r\n    );\r\n    event Swap(\r\n        address indexed sender,\r\n        uint256 amount0In,\r\n        uint256 amount1In,\r\n        uint256 amount0Out,\r\n        uint256 amount1Out,\r\n        address indexed to\r\n    );\r\n    event Sync(uint112 reserve0, uint112 reserve1);\r\n\r\n    function MINIMUM_LIQUIDITY() external pure returns (uint256);\r\n\r\n    function factory() external view returns (address);\r\n\r\n    function token0() external view returns (address);\r\n\r\n    function token1() external view returns (address);\r\n\r\n    function getReserves()\r\n        external\r\n        view\r\n        returns (\r\n            uint112 reserve0,\r\n            uint112 reserve1,\r\n            uint32 blockTimestampLast\r\n        );\r\n\r\n    function price0CumulativeLast() external view returns (uint256);\r\n\r\n    function price1CumulativeLast() external view returns (uint256);\r\n\r\n    function kLast() external view returns (uint256);\r\n\r\n    function burn(address to)\r\n        external\r\n        returns (uint256 amount0, uint256 amount1);\r\n\r\n    function swap(\r\n        uint256 amount0Out,\r\n        uint256 amount1Out,\r\n        address to,\r\n        bytes calldata data\r\n    ) external;\r\n\r\n    function skim(address to) external;\r\n\r\n    function sync() external;\r\n\r\n    function initialize(address, address) external;\r\n}\r\n\r\ninterface IUniswapV2Router01 {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint256 amountADesired,\r\n        uint256 amountBDesired,\r\n        uint256 amountAMin,\r\n        uint256 amountBMin,\r\n        address to,\r\n        uint256 deadline\r\n    )\r\n        external\r\n        returns (\r\n            uint256 amountA,\r\n            uint256 amountB,\r\n            uint256 liquidity\r\n        );\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint256 amountTokenDesired,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    )\r\n        external\r\n        payable\r\n        returns (\r\n            uint256 amountToken,\r\n            uint256 amountETH,\r\n            uint256 liquidity\r\n        );\r\n\r\n    function removeLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint256 liquidity,\r\n        uint256 amountAMin,\r\n        uint256 amountBMin,\r\n        address to,\r\n        uint256 deadline\r\n    ) external returns (uint256 amountA, uint256 amountB);\r\n\r\n    function removeLiquidityETH(\r\n        address token,\r\n        uint256 liquidity,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    ) external returns (uint256 amountToken, uint256 amountETH);\r\n\r\n    function removeLiquidityWithPermit(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint256 liquidity,\r\n        uint256 amountAMin,\r\n        uint256 amountBMin,\r\n        address to,\r\n        uint256 deadline,\r\n        bool approveMax,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) external returns (uint256 amountA, uint256 amountB);\r\n\r\n    function removeLiquidityETHWithPermit(\r\n        address token,\r\n        uint256 liquidity,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline,\r\n        bool approveMax,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) external returns (uint256 amountToken, uint256 amountETH);\r\n\r\n    function swapExactTokensForTokens(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external returns (uint256[] memory amounts);\r\n\r\n    function swapTokensForExactTokens(\r\n        uint256 amountOut,\r\n        uint256 amountInMax,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external returns (uint256[] memory amounts);\r\n\r\n    function swapExactETHForTokens(\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external payable returns (uint256[] memory amounts);\r\n\r\n    function swapTokensForExactETH(\r\n        uint256 amountOut,\r\n        uint256 amountInMax,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external returns (uint256[] memory amounts);\r\n\r\n    function swapExactTokensForETH(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external returns (uint256[] memory amounts);\r\n\r\n    function swapETHForExactTokens(\r\n        uint256 amountOut,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external payable returns (uint256[] memory amounts);\r\n\r\n    function quote(\r\n        uint256 amountA,\r\n        uint256 reserveA,\r\n        uint256 reserveB\r\n    ) external pure returns (uint256 amountB);\r\n\r\n    function getAmountOut(\r\n        uint256 amountIn,\r\n        uint256 reserveIn,\r\n        uint256 reserveOut\r\n    ) external pure returns (uint256 amountOut);\r\n\r\n    function getAmountIn(\r\n        uint256 amountOut,\r\n        uint256 reserveIn,\r\n        uint256 reserveOut\r\n    ) external pure returns (uint256 amountIn);\r\n\r\n    function getAmountsOut(uint256 amountIn, address[] calldata path)\r\n        external\r\n        view\r\n        returns (uint256[] memory amounts);\r\n\r\n    function getAmountsIn(uint256 amountOut, address[] calldata path)\r\n        external\r\n        view\r\n        returns (uint256[] memory amounts);\r\n}\r\n\r\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\r\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint256 liquidity,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    ) external returns (uint256 amountETH);\r\n\r\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint256 liquidity,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline,\r\n        bool approveMax,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) external returns (uint256 amountETH);\r\n\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external;\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external payable;\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external;\r\n}\r\n\r\ncontract Borat is Context, IERC20, Ownable {\r\n    using SafeMath for uint256;\r\n    using Address for address;\r\n\r\n    mapping(address => uint256) private _tOwned;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n    mapping(address => bool) public _isExcludedFromFee;\r\n    mapping(address => bool) public _isBlacklisted;\r\n\r\n    bool public noBlackList = true;\r\n\r\n    address payable private Wallet_Burn =\r\n        payable(0x000000000000000000000000000000000000dEaD);\r\n    address payable private Wallet_zero =\r\n        payable(0x0000000000000000000000000000000000000000);\r\n\r\n    string private _name = \"Borat\";\r\n    string private _symbol = \"BORAT\";\r\n    uint8 private _decimals = 10;\r\n    uint256 private _tTotal = 420000000000000 * 10**10;\r\n    uint256 private _tFeeTotal;\r\n\r\n    uint8 private txCount = 0;\r\n    uint256 private maxPossibleFee = 100;\r\n\r\n    uint256 private _TotalFee = 0;\r\n    uint256 public _buyFee = 0;\r\n    uint256 public _sellFee = 0;\r\n\r\n    uint256 private _previousTotalFee = _TotalFee;\r\n    uint256 private _previousBuyFee = _buyFee;\r\n    uint256 private _previousSellFee = _sellFee;\r\n\r\n    IUniswapV2Router02 public uniswapV2Router;\r\n    address public uniswapV2Pair;\r\n\r\n    constructor() {\r\n        _tOwned[owner()] = _tTotal;\r\n\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(\r\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\r\n        );\r\n\r\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\r\n            .createPair(address(this), _uniswapV2Router.WETH());\r\n        uniswapV2Router = _uniswapV2Router;\r\n        _isExcludedFromFee[owner()] = true;\r\n        _isExcludedFromFee[address(this)] = true;\r\n\r\n        emit Transfer(address(0), owner(), _tTotal);\r\n    }\r\n\r\n    function name() public view returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public view override returns (uint256) {\r\n        return _tTotal;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _tOwned[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount)\r\n        public\r\n        override\r\n        returns (bool)\r\n    {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender)\r\n        public\r\n        view\r\n        override\r\n        returns (uint256)\r\n    {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount)\r\n        public\r\n        override\r\n        returns (bool)\r\n    {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(\r\n            sender,\r\n            _msgSender(),\r\n            _allowances[sender][_msgSender()].sub(\r\n                amount,\r\n                \"ERC20: transfer amount exceeds allowance\"\r\n            )\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue)\r\n        public\r\n        virtual\r\n        returns (bool)\r\n    {\r\n        _approve(\r\n            _msgSender(),\r\n            spender,\r\n            _allowances[_msgSender()][spender].add(addedValue)\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue)\r\n        public\r\n        virtual\r\n        returns (bool)\r\n    {\r\n        _approve(\r\n            _msgSender(),\r\n            spender,\r\n            _allowances[_msgSender()][spender].sub(\r\n                subtractedValue,\r\n                \"ERC20: decreased allowance below zero\"\r\n            )\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function excludeFromFee(address account) public onlyOwner {\r\n        _isExcludedFromFee[account] = true;\r\n    }\r\n\r\n    function includeInFee(address account) public onlyOwner {\r\n        _isExcludedFromFee[account] = false;\r\n    }\r\n\r\n    function _set_Fees(uint256 Buy_Fee, uint256 Sell_Fee) external onlyOwner {\r\n        require((Buy_Fee + Sell_Fee) <= maxPossibleFee, \"Fee is too high!\");\r\n        _sellFee = Sell_Fee;\r\n        _buyFee = Buy_Fee;\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    function blacklist_Add_Wallets(address[] calldata addresses)\r\n        external\r\n        onlyOwner\r\n    {\r\n        uint256 startGas;\r\n        uint256 gasUsed;\r\n\r\n        for (uint256 i; i < addresses.length; ++i) {\r\n            if (gasUsed < gasleft()) {\r\n                startGas = gasleft();\r\n                if (!_isBlacklisted[addresses[i]]) {\r\n                    _isBlacklisted[addresses[i]] = true;\r\n                }\r\n                gasUsed = startGas - gasleft();\r\n            }\r\n        }\r\n    }\r\n\r\n    function blacklist_Remove_Wallets(address[] calldata addresses)\r\n        external\r\n        onlyOwner\r\n    {\r\n        uint256 startGas;\r\n        uint256 gasUsed;\r\n\r\n        for (uint256 i; i < addresses.length; ++i) {\r\n            if (gasUsed < gasleft()) {\r\n                startGas = gasleft();\r\n                if (_isBlacklisted[addresses[i]]) {\r\n                    _isBlacklisted[addresses[i]] = false;\r\n                }\r\n                gasUsed = startGas - gasleft();\r\n            }\r\n        }\r\n    }\r\n\r\n    function blacklist_Switch(bool true_or_false) public onlyOwner {\r\n        noBlackList = true_or_false;\r\n    }\r\n\r\n    bool public noFeeToTransfer = true;\r\n\r\n    function set_Transfers_Without_Fees(bool true_or_false) external onlyOwner {\r\n        noFeeToTransfer = true_or_false;\r\n    }\r\n\r\n    function removeAllFee() private {\r\n        if (_TotalFee == 0 && _buyFee == 0 && _sellFee == 0) return;\r\n\r\n        _previousBuyFee = _buyFee;\r\n        _previousSellFee = _sellFee;\r\n        _previousTotalFee = _TotalFee;\r\n        _buyFee = 0;\r\n        _sellFee = 0;\r\n        _TotalFee = 0;\r\n    }\r\n\r\n    function restoreAllFee() private {\r\n        _TotalFee = _previousTotalFee;\r\n        _buyFee = _previousBuyFee;\r\n        _sellFee = _previousSellFee;\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) private {\r\n        require(\r\n            owner != address(0) && spender != address(0),\r\n            \"ERR: zero address\"\r\n        );\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) private {\r\n        if (noBlackList) {\r\n            require(\r\n                !_isBlacklisted[from] && !_isBlacklisted[to],\r\n                \"This address is blacklisted. Transaction reverted.\"\r\n            );\r\n        }\r\n\r\n        require(\r\n            from != address(0) && to != address(0),\r\n            \"ERR: Using 0 address!\"\r\n        );\r\n        require(amount > 0, \"Token value must be higher than zero.\");\r\n\r\n        bool takeFee = true;\r\n\r\n        if (\r\n            _isExcludedFromFee[from] ||\r\n            _isExcludedFromFee[to] ||\r\n            (noFeeToTransfer && from != uniswapV2Pair && to != uniswapV2Pair)\r\n        ) {\r\n            takeFee = false;\r\n        } else if (from == uniswapV2Pair) {\r\n            _TotalFee = _buyFee;\r\n        } else if (to == uniswapV2Pair) {\r\n            _TotalFee = _sellFee;\r\n        }\r\n\r\n        _tokenTransfer(from, to, amount, takeFee);\r\n    }\r\n\r\n    function remove_Random_Tokens(\r\n        address random_Token_Address,\r\n        address send_to_wallet,\r\n        uint256 number_of_tokens\r\n    ) public onlyOwner returns (bool _sent) {\r\n        require(\r\n            random_Token_Address != address(this),\r\n            \"Can not remove native token\"\r\n        );\r\n        uint256 randomBalance = IERC20(random_Token_Address).balanceOf(\r\n            address(this)\r\n        );\r\n        if (number_of_tokens > randomBalance) {\r\n            number_of_tokens = randomBalance;\r\n        }\r\n        _sent = IERC20(random_Token_Address).transfer(\r\n            send_to_wallet,\r\n            number_of_tokens\r\n        );\r\n    }\r\n\r\n    function _tokenTransfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount,\r\n        bool takeFee\r\n    ) private {\r\n        if (!takeFee) {\r\n            removeAllFee();\r\n        } else {\r\n            txCount++;\r\n        }\r\n        _transferTokens(sender, recipient, amount);\r\n\r\n        if (!takeFee) restoreAllFee();\r\n    }\r\n\r\n    function _transferTokens(\r\n        address sender,\r\n        address recipient,\r\n        uint256 tAmount\r\n    ) private {\r\n        (uint256 tTransferAmount, uint256 tDev) = _getValues(tAmount);\r\n        _tOwned[sender] = _tOwned[sender].sub(tAmount);\r\n        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\r\n        _tOwned[owner()] = _tOwned[owner()].add(tDev);\r\n        emit Transfer(sender, recipient, tTransferAmount);\r\n    }\r\n\r\n    function _getValues(uint256 tAmount)\r\n        private\r\n        view\r\n        returns (uint256, uint256)\r\n    {\r\n        uint256 tDev = (tAmount * _TotalFee) / 100;\r\n        uint256 tTransferAmount = tAmount.sub(tDev);\r\n        return (tTransferAmount, tDev);\r\n    }\r\n}\r\n"
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