{{
  "language": "Solidity",
  "sources": {
    "tismtoken.sol": {
      "content": "/*\n\n    \n        /$$$$$$  /$$   /$$ /$$$$$$$$ /$$$$$$  /$$$$$$  /$$      /$$\n       /$$__  $$| $$  | $$|__  $$__/|_  $$_/ /$$__  $$| $$$    /$$$\n      | $$  \\ $$| $$  | $$   | $$     | $$  | $$  \\__/| $$$$  /$$$$\n      | $$$$$$$$| $$  | $$   | $$     | $$  |  $$$$$$ | $$ $$/$$ $$\n      | $$__  $$| $$  | $$   | $$     | $$   \\____  $$| $$  $$$| $$\n      | $$  | $$| $$  | $$   | $$     | $$   /$$  \\ $$| $$\\  $ | $$\n      | $$  | $$|  $$$$$$/   | $$    /$$$$$$|  $$$$$$/| $$ \\/  | $$\n      |__/  |__/ \\______/    |__/   |______/ \\______/ |__/     |__/\n                                                                \n\n* Twitter : https://twitter.com/erctism\n* Telegram: https://t.me/Erctism\n* Website: tism.lol\n\n*/\n\n// SPDX-License-Identifier:MIT\n\npragma solidity ^0.8.10;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address _account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount)\n        external\n        returns (bool);\n    function allowance(address owner, address spender)\n        external\n        view\n        returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(\n        address indexed previousOwner,\n        address indexed newOwner\n    );\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _setOwner(_msgSender());\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if called by any _account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _setOwner(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(\n            newOwner != address(0),\n            \"Ownable: new owner is the zero address\"\n        );\n        _setOwner(newOwner);\n    }\n\n    function _setOwner(address newOwner) private {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\nlibrary SafeMath {\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c >= a, \"SafeMath: addition overflow\");\n\n        return c;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b <= a, errorMessage);\n        uint256 c = a - b;\n\n        return c;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        if (a == 0) {\n            return 0;\n        }\n\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n\n        return c;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b > 0, errorMessage);\n        uint256 c = a / b;\n        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n\n        return c;\n    }\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return mod(a, b, \"SafeMath: modulo by zero\");\n    }\n\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b != 0, errorMessage);\n        return a % b;\n    }\n}\n\ninterface IDexSwapFactory {\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n}\n\ninterface IDexSwapPair {\n    event Approval(address indexed owner, address indexed spender, uint value);\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function name() external pure returns (string memory);\n    function symbol() external pure returns (string memory);\n    function decimals() external pure returns (uint8);\n    function totalSupply() external view returns (uint);\n    function balanceOf(address owner) external view returns (uint);\n    function allowance(address owner, address spender) external view returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n    function transfer(address to, uint value) external returns (bool);\n    function transferFrom(address from, address to, uint value) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n    function nonces(address owner) external view returns (uint);\n\n    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n    \n    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n    event Swap(\n        address indexed sender,\n        uint amount0In,\n        uint amount1In,\n        uint amount0Out,\n        uint amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\n    function factory() external view returns (address);\n    function token0() external view returns (address);\n    function token1() external view returns (address);\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n    function price0CumulativeLast() external view returns (uint);\n    function price1CumulativeLast() external view returns (uint);\n    function kLast() external view returns (uint);\n\n    function burn(address to) external returns (uint amount0, uint amount1);\n    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n    function skim(address to) external;\n    function sync() external;\n\n    function initialize(address, address) external;\n}\n\ninterface IDexSwapRouter {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n\n}\n\ncontract AutismToken is Context, IERC20, Ownable {\n\n    using SafeMath for uint256;\n\n    string private _name = \"AUTISM\";\n    string private _symbol = \"TISM\";\n    uint8 private _decimals = 18; \n\n    address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;\n    address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;\n\n    uint256 public _buyTreasuryFee = 0;\n    uint256 public _sellTreasuryFee = 250;\n\n    address public Treasury;\n    \n    uint256 feedenominator = 1000;\n\n    mapping (address => uint256) _balances;\n    mapping (address => mapping (address => uint256)) private _allowances;\n\n    mapping (address => bool) public isExcludedFromFee;\n    mapping (address => bool) public isMarketPair;\n\n    uint256 private _totalSupply = 150_000_000 * 10**_decimals;\n\n    uint256 public swapThreshold = 20_000 * 10**_decimals;\n\n    bool public swapEnabled = true;\n\n    IDexSwapRouter public dexRouter;\n    address public dexPair;\n\n    bool inSwap;\n    bool public swapbylimit = false;\n    \n    modifier onlyGuard() {\n        require(msg.sender == Treasury,\"Error: Invalid Caller!\");\n        _;\n    }\n\n    modifier swapping() {\n        inSwap = true;\n        _;\n        inSwap = false;\n    }\n    \n    event SwapTokensForETH(\n        uint256 amountIn,\n        address[] path\n    );\n\n    constructor() {\n\n        IDexSwapRouter _dexRouter = IDexSwapRouter(\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\n        );\n\n        dexPair = IDexSwapFactory(_dexRouter.factory()).createPair(\n            address(this),\n            _dexRouter.WETH()\n        );\n\n        dexRouter = _dexRouter;\n\n        Treasury = msg.sender;\n\n        isExcludedFromFee[address(this)] = true;\n        isExcludedFromFee[msg.sender] = true;\n        isExcludedFromFee[address(dexRouter)] = true;\n\n        isMarketPair[address(dexPair)] = true;\n\n        _allowances[address(this)][address(dexRouter)] = ~uint256(0);\n        _allowances[address(this)][address(dexPair)] = ~uint256(0);\n\n        _balances[msg.sender] = _totalSupply;\n        emit Transfer(address(0), msg.sender, _totalSupply);\n    }\n\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public view override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n       return _balances[account];     \n    }\n\n    function allowance(address owner, address spender) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n    \n    function getCirculatingSupply() public view returns (uint256) {\n        return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, \"ERC20: decreased allowance below zero\"));\n        return true;\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n     //to recieve ETH from Router when swaping\n    receive() external payable {}\n\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\n        return true;\n    }\n\n    function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {\n\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n    \n        if (inSwap) {\n            return _basicTransfer(sender, recipient, amount);\n        }\n        else {\n\n            uint256 contractTokenBalance = balanceOf(address(this));\n            bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;\n\n            if (overMinimumTokenBalance && !inSwap && !isMarketPair[sender] && swapEnabled) {\n                swapBack(contractTokenBalance);\n            }\n            \n            _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\n\n            uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);\n\n            _balances[recipient] = _balances[recipient].add(finalAmount);\n\n            emit Transfer(sender, recipient, finalAmount);\n            return true;\n\n        }\n\n    }\n\n    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\n        _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\n        _balances[recipient] = _balances[recipient].add(amount);\n        emit Transfer(sender, recipient, amount);\n        return true;\n    }\n    \n    function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {\n        if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {\n            return true;\n        }\n        else if (isMarketPair[sender] || isMarketPair[recipient]) {\n            return false;\n        }\n        else {\n            return false;\n        }\n    }\n\n    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {\n        \n        uint feeAmount;\n\n        unchecked {\n\n            if(isMarketPair[sender]) { \n                feeAmount = amount.mul(_buyTreasuryFee).div(feedenominator);\n            } \n            else if(isMarketPair[recipient]) { \n                feeAmount = amount.mul(_sellTreasuryFee).div(feedenominator);\n            }\n\n            if(feeAmount > 0) {\n                _balances[address(this)] = _balances[address(this)].add(feeAmount);\n                emit Transfer(sender, address(this), feeAmount);\n            }\n\n            return amount.sub(feeAmount);\n        }\n        \n    }\n\n    function swapBack(uint contractBalance) internal swapping {\n\n        if(swapbylimit) contractBalance = swapThreshold;\n\n        uint256 initialBalance = address(this).balance;\n        swapTokensForEth(contractBalance);\n        uint256 amountReceived = address(this).balance.sub(initialBalance);\n\n       if(amountReceived > 0) payable(Treasury).transfer(amountReceived);\n\n    }\n\n    function swapTokensForEth(uint256 tokenAmount) private {\n        // generate the uniswap pair path of token -> weth\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = dexRouter.WETH();\n\n        _approve(address(this), address(dexRouter), tokenAmount);\n\n        // make the swap\n        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0, // accept any amount of ETH\n            path,\n            address(this), // The contract\n            block.timestamp\n        );\n        \n        emit SwapTokensForETH(tokenAmount, path);\n    }\n\n    function rescueFunds() external onlyGuard { \n        (bool os,) = payable(msg.sender).call{value: address(this).balance}(\"\");\n        require(os,\"Transaction Failed!!\");\n    }\n\n    function rescueTokens(IERC20 adr,address recipient,uint amount) external onlyGuard {\n        adr.transfer(recipient,amount);\n    }\n\n    function setFee(uint _buyFee, uint _sellFee) external onlyOwner {    \n        _buyTreasuryFee = _buyFee;\n        _sellTreasuryFee = _sellFee;\n    }\n\n    function setDeno(uint _deno) external onlyOwner {    \n        feedenominator = _deno;\n    }\n\n    function excludeFromFee(address _adr,bool _status) external onlyOwner {\n        isExcludedFromFee[_adr] = _status;\n    }\n    \n    function setTreasuryWallet(address _newWallet) external onlyOwner {\n        Treasury = _newWallet;\n    }\n\n    function setMarketPair(address _pair, bool _status) external onlyOwner {\n        isMarketPair[_pair] = _status;\n    }\n\n    function setSwapBackSettings(bool _enabled, bool _limited, uint256 _amount)\n        external\n        onlyOwner\n    {\n        swapEnabled = _enabled;\n        swapThreshold = _amount;\n        swapbylimit = _limited;\n    }\n\n    function setManualRouter(address _router) external onlyOwner {\n        dexRouter = IDexSwapRouter(_router);\n    }\n\n    function setManualPair(address _pair) external onlyOwner {\n        dexPair = _pair;\n    }\n\n\n}"
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