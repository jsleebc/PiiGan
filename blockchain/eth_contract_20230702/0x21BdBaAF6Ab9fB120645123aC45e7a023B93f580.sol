{{
  "language": "Solidity",
  "sources": {
    "contracts/BURGERKING.sol": {
      "content": "pragma solidity ^0.8.0;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ninterface IERC20Metadata is IERC20 {\n    function name() external view returns (string memory);\n    function symbol() external view returns (string memory);\n    function decimals() external view returns (uint8);\n}\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n    mapping(address => mapping(address => uint256)) private _allowances;\n    uint256 private _totalSupply;\n    string private _name;\n    string private _symbol;\n\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\n        unchecked {\n            _approve(sender, _msgSender(), currentAllowance - amount);\n        }\n\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[sender] = senderBalance - amount;\n        }\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n\n        _afterTokenTransfer(sender, recipient, amount);\n    }\n\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n        }\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n\ncontract BURGERKING is ERC20, Ownable {\n    constructor() ERC20(\"BURGERKING\", \"BURGERKING\") {\n        _mint(msg.sender, 690000000000 * 10 ** decimals());\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 1000
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