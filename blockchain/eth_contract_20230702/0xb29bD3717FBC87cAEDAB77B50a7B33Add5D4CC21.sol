{{
  "language": "Solidity",
  "sources": {
    "SHIBCL.sol": {
      "content": "/*\r\n    \r\n    $SHIBCL - Shiba Cartel\r\n\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠈⠙⠻⣿⣿⠟⠋⠁⠉⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⢠⠟⠁⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠋⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠉⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⣿⣷⣦⣤⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣤⣴⣶⣿⡇⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠉⠓⠒⠶⠤⠤⢤⣤⣤⣤⣤⣤⣤⣤⣤⣴⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣷⣦⣤⣀⡀⠀⢀⣼⣿⠀⠉⠉⠉⠉⠉⠉⠁⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢻⣿⣿⣿⡿⢷⣿⡉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⠉⠀⠈⣻⣿⣦⣀⡀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢿⡁⠹⡈⣳⠶⣿⣿⣽⣛⠋⠁⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⢱⣠⣿⣿⣷⣿⣿⣿⡿⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿\r\n    \r\n\r\n    Telegram: https://t.me/shibacltoken\r\n    Website: https://www.shibacarteltoken.com/ \r\n    Twitter: https://twitter.com/SHIBACARTELETH\r\n\r\n*/\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.17;\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n   \r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\ninterface IERC20Metadata is IERC20 {\r\n    function name() external view returns (string memory);\r\n    function symbol() external view returns (string memory);\r\n    function decimals() external view returns (uint8);\r\n}\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\r\n        return msg.data;\r\n    }\r\n}\r\n\r\nabstract contract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping(address => uint256) private _balances;\r\n\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n    uint256 private _totalSupply;\r\n\r\n    string private _name;\r\n    string private _symbol;\r\n\r\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 18;\r\n    }\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\r\n        if (currentAllowance != type(uint256).max) {\r\n            require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\r\n            unchecked {\r\n                _approve(sender, _msgSender(), currentAllowance - amount);\r\n            }\r\n        }\r\n\r\n        _transfer(sender, recipient, amount);\r\n\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\r\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\r\n        unchecked {\r\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n        uint256 senderBalance = _balances[sender];\r\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\r\n        unchecked {\r\n            _balances[sender] = senderBalance - amount;\r\n        }\r\n        _balances[recipient] += amount;\r\n\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n     function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n\r\n        _totalSupply += amount;\r\n        _balances[account] += amount;\r\n        emit Transfer(address(0), account, amount);\r\n    }\r\n}\r\n\r\ncontract SHIBCL is ERC20, Ownable {\r\n\r\n    IUniswapV2Router02 public uniswapV2Router;\r\n    mapping (address => bool) private _isExcludedFromFees;\r\n    address public uniswapV2Pair;\r\n    address public marketingWallet;\r\n\r\n    uint256 public swapTokensAtAmount;\r\n    bool private swapping;\r\n    bool public tradingEnabled;\r\n\r\n    uint256 public buyTax;\r\n    uint256 public sellTax;\r\n\r\n    constructor () ERC20(\"Shiba Cartel\", \"SHIBCL\") \r\n    {   \r\n        address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\r\n\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);\r\n        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\r\n            .createPair(address(this), _uniswapV2Router.WETH());\r\n\r\n        uniswapV2Router = _uniswapV2Router;\r\n        uniswapV2Pair   = _uniswapV2Pair;\r\n\r\n        _approve(address(this), address(uniswapV2Router), type(uint256).max);\r\n        _isExcludedFromFees[owner()] = true;\r\n        _isExcludedFromFees[address(this)] = true;\r\n        marketingWallet = msg.sender;\r\n        _mint(msg.sender, 690_000_000_000_000 * 1e18);\r\n        swapTokensAtAmount = totalSupply() / 5_000;\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    \r\n    \r\n\r\n    function changeMarketingWallet(address newMarketingWallet) public onlyOwner { \r\n        marketingWallet = newMarketingWallet;\r\n    }\r\n\r\n    function setTaxes(uint256 _buyTax, uint256 _sellTax) public onlyOwner {\r\n        require(_buyTax <= 40 && _sellTax <= 40, \"Cannot set above 40%.\");\r\n        buyTax = _buyTax;\r\n        sellTax = _sellTax;\r\n    }\r\n\r\n    function enableTrading() external onlyOwner {\r\n        require(!tradingEnabled, \"Trading already enabled.\");\r\n        tradingEnabled = true;\r\n    }\r\n\r\n    function _transfer(address from,address to,uint256 amount) internal  override {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > 0, \"Cannot transfer 0 tokens.\");\r\n        require(tradingEnabled || from == owner(), \"Trading not yet enabled!\");\r\n       \r\n\t\tuint256 contractTokenBalance = balanceOf(address(this));\r\n\r\n        bool canSwap = contractTokenBalance >= swapTokensAtAmount;\r\n\r\n        if (canSwap &&\r\n            !swapping &&\r\n            to == uniswapV2Pair\r\n        ) {\r\n            swapping = true;\r\n\r\n            swapAndSendMarketing(contractTokenBalance);     \r\n\r\n            swapping = false;\r\n        }\r\n\r\n        uint256 _totalFees;\r\n        if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {\r\n            _totalFees = 0;\r\n        } else if (from == uniswapV2Pair) {\r\n            _totalFees = buyTax;\r\n        } else if (to == uniswapV2Pair) {\r\n            _totalFees = sellTax;\r\n        } else {\r\n            _totalFees = 0;\r\n        }\r\n\r\n        if (_totalFees > 0) {\r\n            uint256 fees = (amount * _totalFees) / 100;\r\n            amount = amount - fees;\r\n            super._transfer(from, address(this), fees);\r\n        }\r\n\r\n        super._transfer(from, to, amount);\r\n    }\r\n\r\n    function swapAndSendMarketing(uint256 tokenAmount) private {\r\n\r\n        if(tokenAmount == 0) {\r\n            return;\r\n        }\r\n\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n        try\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0,\r\n            path,\r\n            marketingWallet,\r\n            block.timestamp\r\n        )\r\n        {}\r\n        catch {}\r\n    }\r\n\r\n\r\n    function rescueTokens(address token) public onlyOwner {\r\n        uint256 caBalances = IERC20(token).balanceOf(address(this));\r\n        IERC20(token).transfer(msg.sender, caBalances);\r\n    }\r\n\r\n}"
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