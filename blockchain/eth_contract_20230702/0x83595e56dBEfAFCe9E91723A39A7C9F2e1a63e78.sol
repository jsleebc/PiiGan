{{
  "language": "Solidity",
  "sources": {
    "contracts/ProfX.sol": {
      "content": "/**\nProfessor X\n$ProfX\n*/\n\n// Sources flattened with hardhat v2.7.0 https://hardhat.org\n\n// File @openzeppelin/contracts/utils/Context.sol@v4.4.0\n\n// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.0 (utils/Context.sol)\n\n\npragma solidity ^0.8.0;\n\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\npragma solidity ^0.8.0;\n\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    \n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    \n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    \n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    \n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    \n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    \n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\npragma solidity ^0.8.0;\n\n\ninterface IERC20 {\n    \n    function totalSupply() external view returns (uint256);\n\n    \n    function balanceOf(address account) external view returns (uint256);\n\n    \n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    \n    function allowance(address owner, address spender) external view returns (uint256);\n\n    \n    function approve(address spender, uint256 amount) external returns (bool);\n\n    \n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    \n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    \n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\npragma solidity ^0.8.0;\n\n\ninterface IERC20Metadata is IERC20 {\n    \n    function name() external view returns (string memory);\n\n    \n    function symbol() external view returns (string memory);\n\n    \n    function decimals() external view returns (uint8);\n}\n\npragma solidity ^0.8.0;\n\n\n\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    \n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    \n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    \n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    \n    function decimals() public view virtual override returns (uint8) {\n        return 9;\n    }\n\n    \n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    \n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    \n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    \n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    \n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    \n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\n        unchecked {\n            _approve(sender, _msgSender(), currentAllowance - amount);\n        }\n\n        return true;\n    }\n\n    \n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    \n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    \n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[sender] = senderBalance - amount;\n        }\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n\n        _afterTokenTransfer(sender, recipient, amount);\n    }\n\n    \n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    \n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n        }\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    \n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    \n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    \n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n\n\n\npragma solidity ^0.8.0;\n\n\ncontract $ProfX is Ownable, ERC20 {\n    bool public limited;\n    uint256 public maxHoldingAmount;\n    uint256 public minHoldingAmount;\n    address public uniswapV2Pair;\n    mapping(address => bool) public blacklists;\n\n\n    constructor() ERC20(\"Professor X\", \"ProfX\") {\n        uint256 totalSupply = 100000000 * (10 ** uint256(decimals()));\n        _mint(msg.sender, totalSupply);\n    }\n\n    function blacklist(address _address, bool _isBlacklisting) external onlyOwner {\n        blacklists[_address] = _isBlacklisting;\n    }\n\n    function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {\n        limited = _limited;\n        uniswapV2Pair = _uniswapV2Pair;\n        maxHoldingAmount = _maxHoldingAmount;\n        minHoldingAmount = _minHoldingAmount;\n    }\n\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) override internal virtual {\n        require(!blacklists[to] && !blacklists[from], \"Blacklisted\");\n\n        if (uniswapV2Pair == address(0)) {\n            require(from == owner() || to == owner(), \"trading is not started\");\n            return;\n        }\n\n        if (limited && from == uniswapV2Pair) {\n            require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, \"Forbid\");\n        }\n    }\n\n    function burn(uint256 value) external {\n        _burn(msg.sender, value);\n    }\n}"
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