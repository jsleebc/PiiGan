{{
  "language": "Solidity",
  "sources": {
    "contract.sol": {
      "content": "/**\r\n\r\nWebsite - https://mongv3.com/\r\nTelegram - https://t.me/mongv3portal\r\nTwitter - https://twitter.com/MongV3Coin\r\n\r\n**/\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\npragma solidity 0.8.20;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function transfer(address recipient, uint256 amount)\r\n        external\r\n        returns (bool);\r\n\r\n    function allowance(address owner, address spender)\r\n        external\r\n        view\r\n        returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n    address private _previousOwner;\r\n    event OwnershipTransferred(\r\n        address indexed previousOwner,\r\n        address indexed newOwner\r\n    );\r\n\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public onlyOwner {\r\n        _transferOwnership(newOwner);\r\n    }\r\n\r\n    function _transferOwnership(address newOwner) internal {\r\n        require(\r\n            newOwner != address(0),\r\n            \"Ownable: new owner is the zero address\"\r\n        );\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB)\r\n        external\r\n        returns (address pair);\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external;\r\n\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n}\r\n\r\ncontract MONG is Context, IERC20, Ownable {\r\n    uint256 private constant _totalSupply = 100_000_000e18;\r\n    uint256 private constant onePercent = 4_750_000e18;\r\n    uint256 private constant minSwap = 250_000e18;\r\n    IUniswapV2Router02 immutable uniswapV2Router;\r\n    address immutable uniswapV2Pair;\r\n    address immutable WETH;\r\n    address payable immutable marketingWallet;\r\n    uint8 private constant _decimals = 18;\r\n    uint256 public buyTax;\r\n    uint256 public sellTax;\r\n    uint8 private launch;\r\n    uint8 private inSwapAndLiquify;\r\n    uint256 private launchBlock;\r\n    mapping(address => uint256) private _balance;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n    mapping(address => bool) private _isExcludedFromFeeWallet;\r\n    uint256 public maxTxAmount = onePercent; //max Tx for first mins after launch\r\n    string private constant _name = \"Mong V3\";\r\n    string private constant _symbol = \"MONGV3\";\r\n\r\n\r\n    constructor() {\r\n        uniswapV2Router = IUniswapV2Router02(\r\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\r\n        );\r\n        WETH = uniswapV2Router.WETH();\r\n        buyTax = 2;\r\n        sellTax = 2;\r\n\r\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(\r\n            address(this),\r\n            WETH\r\n        );\r\n\r\n        marketingWallet = payable(0xE9DC0cc5240132aE2Ed1c47956e255FCc757AAe5);\r\n        _balance[msg.sender] = _totalSupply;\r\n        _allowances[address(this)][address(uniswapV2Router)] = type(uint256)\r\n            .max;\r\n        _isExcludedFromFeeWallet[marketingWallet] = true;\r\n        _isExcludedFromFeeWallet[msg.sender] = true;\r\n        _isExcludedFromFeeWallet[address(this)] = true;\r\n        _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;\r\n        _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)\r\n            .max;\r\n\r\n\r\n        emit Transfer(address(0), _msgSender(), _totalSupply);\r\n    }\r\n\r\n    function name() public pure returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public pure returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount)\r\n        public\r\n        override\r\n        returns (bool)\r\n    {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function decimals() public pure returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public pure override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balance[account];\r\n    }\r\n\r\n    function allowance(address owner, address spender)\r\n        public\r\n        view\r\n        override\r\n        returns (uint256)\r\n    {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount)\r\n        public\r\n        override\r\n        returns (bool)\r\n    {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(\r\n            sender,\r\n            _msgSender(),\r\n            _allowances[sender][_msgSender()] - amount\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function excludeFromFees(address wallet) external onlyOwner {\r\n        _isExcludedFromFeeWallet[wallet] = true;\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) private {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function enableTrade() external onlyOwner {\r\n        launch = 1;\r\n        launchBlock = block.number;\r\n    }\r\n\r\n    function disableLimits() external onlyOwner {\r\n        maxTxAmount = _totalSupply;\r\n    }    \r\n\r\n    function changeFee(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {\r\n        buyTax = newBuyTax;\r\n        sellTax = newSellTax;\r\n    }\r\n\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) private {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(amount > 1e9, \"Min transfer amt\");\r\n\r\n        uint256 _tax;\r\n        if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {\r\n            _tax = 0;\r\n        } else {\r\n            require(\r\n                launch != 0 && amount <= maxTxAmount,\r\n                \"Launch / Max TxAmount 2% at launch\"\r\n            );\r\n\r\n            if (inSwapAndLiquify == 1) {\r\n                //No tax transfer\r\n                _balance[from] -= amount;\r\n                _balance[to] += amount;\r\n\r\n                emit Transfer(from, to, amount);\r\n                return;\r\n            }\r\n\r\n            if (from == uniswapV2Pair) {\r\n                _tax = buyTax;\r\n            } else if (to == uniswapV2Pair) {\r\n                uint256 tokensToSwap = _balance[address(this)];\r\n                if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {\r\n                    if (tokensToSwap > onePercent) {\r\n                        tokensToSwap = onePercent;\r\n                    }\r\n                    inSwapAndLiquify = 1;\r\n                    address[] memory path = new address[](2);\r\n                    path[0] = address(this);\r\n                    path[1] = WETH;\r\n                    uniswapV2Router\r\n                        .swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n                            tokensToSwap,\r\n                            0,\r\n                            path,\r\n                            marketingWallet,\r\n                            block.timestamp\r\n                        );\r\n                    inSwapAndLiquify = 0;\r\n                }\r\n                _tax = sellTax;\r\n            } else {\r\n                _tax = 0;\r\n            }\r\n        }\r\n\r\n        //Is there tax for sender|receiver?\r\n        if (_tax != 0) {\r\n            //Tax transfer\r\n            uint256 taxTokens = (amount * _tax) / 100;\r\n            uint256 transferAmount = amount - taxTokens;\r\n\r\n            _balance[from] -= amount;\r\n            _balance[to] += transferAmount;\r\n            _balance[address(this)] += taxTokens;\r\n            emit Transfer(from, address(this), taxTokens);\r\n            emit Transfer(from, to, transferAmount);\r\n        } else {\r\n            //No tax transfer\r\n            _balance[from] -= amount;\r\n            _balance[to] += amount;\r\n\r\n            emit Transfer(from, to, amount);\r\n        }\r\n    }\r\n\r\n    receive() external payable {}\r\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 250
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