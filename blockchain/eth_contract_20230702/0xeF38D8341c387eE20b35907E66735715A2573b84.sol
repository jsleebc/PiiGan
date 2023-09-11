{{
  "language": "Solidity",
  "sources": {
    "contracts/bonk20.sol": {
      "content": "/**\r\n *Submitted for verification at Etherscan.io on 2023-06-29\r\n*/\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\n// Token   : BONK 2.0 ($BONK2.0)\r\n// Website : http://www.bonk2.tech/\r\n// Telegram: https://t.me/bonk2portal\r\n// Twitter : https://twitter.com/bonk2coin\r\n\r\n\r\npragma solidity ^0.8.18;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n\r\nabstract contract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        _transferOwnership(_msgSender());\r\n    }\r\n\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(owner() == _msgSender(), \"Ownable: Caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        _transferOwnership(address(0));\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: New owner is the zero address\");\r\n        _transferOwnership(newOwner);\r\n    }\r\n\r\n    function _transferOwnership(address newOwner) internal virtual {\r\n        address oldOwner = _owner;\r\n        _owner = newOwner;\r\n        emit OwnershipTransferred(oldOwner, newOwner);\r\n    }\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\ninterface IERC20Metadata is IERC20 {\r\n    function name() external view returns (string memory);\r\n    function symbol() external view returns (string memory);\r\n    function decimals() external view returns (uint8);\r\n}\r\n\r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping(address => uint256) private _balances;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n    uint256 private _totalSupply;\r\n    string private _name;\r\n    string private _symbol;\r\n\r\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 9;\r\n    }\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n\r\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\r\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\r\n        unchecked {\r\n            _approve(sender, _msgSender(), currentAllowance - amount);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\r\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\r\n        unchecked {\r\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n        _beforeTokenTransfer(sender, recipient, amount);\r\n\r\n        uint256 senderBalance = _balances[sender];\r\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\r\n        unchecked {\r\n            _balances[sender] = senderBalance - amount;\r\n        }\r\n        _balances[recipient] += amount;\r\n\r\n        emit Transfer(sender, recipient, amount);\r\n\r\n        _afterTokenTransfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n\r\n        _beforeTokenTransfer(address(0), account, amount);\r\n\r\n        _totalSupply += amount;\r\n        _balances[account] += amount;\r\n        emit Transfer(address(0), account, amount);\r\n\r\n        _afterTokenTransfer(address(0), account, amount);\r\n    }\r\n\r\n    function _burn(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: burn from the zero address\");\r\n\r\n        _beforeTokenTransfer(account, address(0), amount);\r\n\r\n        uint256 accountBalance = _balances[account];\r\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\r\n        unchecked {\r\n            _balances[account] = accountBalance - amount;\r\n        }\r\n        _totalSupply -= amount;\r\n\r\n        emit Transfer(account, address(0), amount);\r\n\r\n        _afterTokenTransfer(account, address(0), amount);\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _beforeTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n\r\n    function _afterTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\r\n}\r\n\r\ninterface IUniswapV2Router {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n}\r\n\r\n\r\ncontract BONK is ERC20, Ownable {\r\n\r\n    bool public tradingEnabled;\r\n    uint256 private constant MAX = type(uint256).max;\r\n    uint256 private maxSupply = 100_000_000;\r\n\r\n    uint8 public buyTax = 20;\r\n    uint8 public sellTax = 30;\r\n    address public marketingWallet = address(0xB47A6E90479E1CFeEBb973b1eB785E18D797Fdf9);\r\n\r\n    IUniswapV2Router public uniswapV2Router;\r\n    address public uniswapV2Pair;\r\n\r\n    mapping (address => bool) private _isExcludedFromTax;\r\n    mapping (address => bool) private _isAuth;\r\n\r\n    constructor() ERC20(\"Bonk 2.0\", \"$BONK2.0\") {\r\n        _mint(msg.sender, maxSupply * 10 ** decimals());\r\n\r\n        _isExcludedFromTax[_msgSender()] = true;\r\n        _isExcludedFromTax[marketingWallet] = true;\r\n        _isExcludedFromTax[address(this)] = true;\r\n\r\n        _isAuth[_msgSender()] = true;\r\n        _isAuth[marketingWallet] = true;\r\n\r\n        IUniswapV2Router _uniswapV2Router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\r\n            .createPair(address(this), _uniswapV2Router.WETH());\r\n        uniswapV2Router = _uniswapV2Router;\r\n\r\n        _isExcludedFromTax[uniswapV2Pair] = true;\r\n        _approve(address(this), address(uniswapV2Router), MAX);\r\n    }\r\n\r\n    function decimals() public pure override returns (uint8) {\r\n        return 9;\r\n    }\r\n\r\n    function _beforeTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual override {\r\n        if (!tradingEnabled) {\r\n            require(from == owner() || to == owner(), \"Trading is not enabled yet!\");\r\n            return;\r\n        } else {\r\n            require(balanceOf(from) >= amount, \"Not enough tokens!\");\r\n            return;\r\n        }\r\n    }\r\n\r\n    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {\r\n        if (!_isAuth[sender] && !_isExcludedFromTax[recipient] && recipient != 0x000000000000000000000000000000000000dEaD) {\r\n            uint256 holdTokens = balanceOf(recipient);\r\n            require((holdTokens + amount) <= 5_000_000 * 10 ** decimals(), \"Can not hold that much!\");\r\n        }\r\n        \r\n        if (!_isExcludedFromTax[sender] || !_isExcludedFromTax[recipient]) {\r\n            uint256 taxAmount = 0;\r\n            \r\n            if (recipient == uniswapV2Pair) {\r\n                taxAmount = amount * sellTax / 100;\r\n            } else if (sender == uniswapV2Pair) {\r\n                taxAmount = amount * buyTax / 100;\r\n            }\r\n\r\n            if (taxAmount > 0) {\r\n                super._transfer(sender, marketingWallet, taxAmount);\r\n                amount = amount - taxAmount;\r\n            }\r\n        }\r\n        super._transfer(sender, recipient, amount);\r\n    }\r\n\r\n    function enableTrading() external onlyOwner{\r\n        require(tradingEnabled == false, \"Trading is already enabled\");\r\n        tradingEnabled = true;\r\n    }\r\n\r\n    function setTax(uint8 _buyTax, uint8 _sellTax) external onlyOwner {\r\n        buyTax  = _buyTax;\r\n        sellTax = _sellTax;\r\n    }\r\n\r\n    function excludeFromTax(address account) external onlyOwner {\r\n        _isExcludedFromTax[account] = true;\r\n    }\r\n}"
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