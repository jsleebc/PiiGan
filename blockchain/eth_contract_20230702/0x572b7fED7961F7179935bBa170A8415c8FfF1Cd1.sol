{{
  "language": "Solidity",
  "sources": {
    "RAbbit.sol": {
      "content": "/**\r\nhttps://twitter.com/WeRGenZ\r\nhttps://wergenz.com/\r\nhttps://www.facebook.com/WeRGenZ\r\nhttps://t.me/Genz_Community\r\n2AM UTC Friday, June 23, 2023\r\n*/\r\n// SPDX-License-Identifier: Unlicensed\r\npragma solidity ^0.8.14;\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n}\r\n\r\ncontract Ownable is Context {\r\n    address private _owner;\r\n    address private _previousOwner;\r\n    event OwnershipTransferred(\r\n        address indexed previousOwner,\r\n        address indexed newOwner\r\n    );\r\n\r\n    constructor() {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    function owner() public view returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    modifier onlyOwner() {\r\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        emit OwnershipTransferred(_owner, address(0));\r\n        _owner = address(0);\r\n    }\r\n\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n\r\n}\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c >= a, \"SafeMath: addition overflow\");\r\n        return c;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    function sub(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        require(b <= a, errorMessage);\r\n        uint256 c = a - b;\r\n        return c;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n        return c;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    function div(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        require(b > 0, errorMessage);\r\n        uint256 c = a / b;\r\n        return c;\r\n    }\r\n}\r\n\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB)\r\n        external\r\n        returns (address pair);\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external;\r\n\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint256 amountTokenDesired,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    )\r\n        external\r\n        payable\r\n        returns (\r\n            uint256 amountToken,\r\n            uint256 amountETH,\r\n            uint256 liquidity\r\n        );\r\n}\r\n\r\ncontract GENZ is Context, IERC20, Ownable {\r\n\r\n    using SafeMath for uint256;\r\n\r\n    string private constant _name = \"GENZ\";\r\n    string private constant _symbol = \"GENZ\";\r\n    uint8 private constant _decimals = 9;\r\n\r\n    mapping(address => uint256) private _rOwned;\r\n    mapping(address => uint256) private _tOwned;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n    mapping(address => bool) private _isExcludedFromFee;\r\n    uint256 private constant MAX = ~uint256(0);\r\n    uint256 private constant _tTotal = 10000000000 * 10**9;\r\n    uint256 private _rTotal = (MAX - (MAX % _tTotal));\r\n    uint256 private _tFeeTotal;\r\n    uint256 private _redisFeeOnBuy = 0;\r\n    uint256 private _taxFeeOnBuy = 1;\r\n    uint256 private _redisFeeOnSell = 0;\r\n    uint256 private _taxFeeOnSell = 1;\r\n\r\n    //Original Fee\r\n    uint256 private _redisFee = _redisFeeOnSell;\r\n    uint256 private _taxFee = _taxFeeOnSell;\r\n\r\n    uint256 private _previousredisFee = _redisFee;\r\n    uint256 private _previoustaxFee = _taxFee;\r\n\r\n    mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;\r\n    mapping (address => bool) public preTrader;\r\n    address payable private _developmentAddress = payable(0xB0019a38E360a21afc5EB0e792809Ba0D62BE6fe);\r\n    address payable private _marketingAddress = payable(0xB0019a38E360a21afc5EB0e792809Ba0D62BE6fe);\r\n\r\n    IUniswapV2Router02 public uniswapV2Router;\r\n    address public uniswapV2Pair;\r\n\r\n    bool private tradingOpen;\r\n    bool private inSwap = false;\r\n    bool private swapEnabled = true;\r\n\r\n    uint256 public _maxTxAmount = 2000000000 * 10**9;\r\n    uint256 public _maxWalletSize = 4000000000 * 10**9;\r\n    uint256 public _swapTokensAtAmount = 2000000 * 10**9;\r\n\r\n    event MaxTxAmountUpdated(uint256 _maxTxAmount);\r\n    modifier lockTheSwap {\r\n        inSwap = true;\r\n        _;\r\n        inSwap = false;\r\n    }\r\n\r\n    constructor() {\r\n\r\n        _rOwned[_msgSender()] = _rTotal;\r\n\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//\r\n        uniswapV2Router = _uniswapV2Router;\r\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\r\n            .createPair(address(this), _uniswapV2Router.WETH());\r\n\r\n        _isExcludedFromFee[owner()] = true;\r\n        _isExcludedFromFee[address(this)] = true;\r\n        _isExcludedFromFee[_developmentAddress] = true;\r\n        _isExcludedFromFee[_marketingAddress] = true;\r\n\r\n        emit Transfer(address(0), _msgSender(), _tTotal);\r\n    }\r\n\r\n    function name() public pure returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public pure returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public pure returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public pure override returns (uint256) {\r\n        return _tTotal;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return tokenFromReflection(_rOwned[account]);\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount)\r\n        public\r\n        override\r\n        returns (bool)\r\n    {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender)\r\n        public\r\n        view\r\n        override\r\n        returns (uint256)\r\n    {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount)\r\n        public\r\n        override\r\n        returns (bool)\r\n    {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(\r\n            sender,\r\n            _msgSender(),\r\n            _allowances[sender][_msgSender()].sub(\r\n                amount,\r\n                \"ERC20: transfer amount exceeds allowance\"\r\n            )\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function tokenFromReflection(uint256 rAmount)\r\n        private\r\n        view\r\n        returns (uint256)\r\n    {\r\n        require(\r\n            rAmount <= _rTotal,\r\n            \"Amount must be less than total reflections\"\r\n        );\r\n        uint256 currentRate = _getRate();\r\n        return rAmount.div(currentRate);\r\n    }\r\n\r\n    function removeAllFee() private {\r\n        if (_redisFee == 0 && _taxFee == 0) return;\r\n\r\n        _previousredisFee = _redisFee;\r\n        _previoustaxFee = _taxFee;\r\n\r\n        _redisFee = 0;\r\n        _taxFee = 0;\r\n    }\r\n\r\n    function restoreAllFee() private {\r\n        _redisFee = _previousredisFee;\r\n        _taxFee = _previoustaxFee;\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) private {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) private {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > 0, \"Transfer amount must be greater than zero\");\r\n\r\n        \tif (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {\r\n\r\n            //Trade start check\r\n            if (!tradingOpen) {\r\n                require(preTrader[from], \"TOKEN: This account cannot send tokens until trading is enabled\");\r\n            }\r\n\r\n            require(amount <= _maxTxAmount, \"TOKEN: Max Transaction Limit\");\r\n            require(!bots[from] && !bots[to], \"TOKEN: Your account is blacklisted!\");\r\n\r\n            if(to != uniswapV2Pair) {\r\n                require(balanceOf(to) + amount < _maxWalletSize, \"TOKEN: Balance exceeds wallet size!\");\r\n            }\r\n\r\n            uint256 contractTokenBalance = balanceOf(address(this));\r\n            bool canSwap = contractTokenBalance >= _swapTokensAtAmount;\r\n\r\n            if(contractTokenBalance >= _maxTxAmount)\r\n            {\r\n                contractTokenBalance = _maxTxAmount;\r\n            }\r\n\r\n            if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {\r\n                swapTokensForEth(contractTokenBalance);\r\n                uint256 contractETHBalance = address(this).balance;\r\n                if (contractETHBalance > 0) {\r\n                    sendETHToFee(address(this).balance);\r\n                }\r\n            }\r\n        }\r\n\r\n        bool takeFee = true;\r\n\r\n        //Transfer Tokens\r\n        if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {\r\n            takeFee = false;\r\n        } else {\r\n\r\n            //Set Fee for Buys\r\n            if(from == uniswapV2Pair && to != address(uniswapV2Router)) {\r\n                _redisFee = _redisFeeOnBuy;\r\n                _taxFee = _taxFeeOnBuy;\r\n            }\r\n\r\n            //Set Fee for Sells\r\n            if (to == uniswapV2Pair && from != address(uniswapV2Router)) {\r\n                _redisFee = _redisFeeOnSell;\r\n                _taxFee = _taxFeeOnSell;\r\n            }\r\n\r\n        }\r\n\r\n        _tokenTransfer(from, to, amount, takeFee);\r\n    }\r\n\r\n    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {\r\n        address[] memory path = new address[](2);\r\n        path[0] = address(this);\r\n        path[1] = uniswapV2Router.WETH();\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n            tokenAmount,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp\r\n        );\r\n    }\r\n\r\n    function sendETHToFee(uint256 amount) private {\r\n        _marketingAddress.transfer(amount);\r\n    }\r\n\r\n    function setTrading(bool _tradingOpen) public onlyOwner {\r\n        tradingOpen = _tradingOpen;\r\n    }\r\n\r\n    function manualswap() external {\r\n        require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);\r\n        uint256 contractBalance = balanceOf(address(this));\r\n        swapTokensForEth(contractBalance);\r\n    }\r\n\r\n    function manualsend() external {\r\n        require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);\r\n        uint256 contractETHBalance = address(this).balance;\r\n        sendETHToFee(contractETHBalance);\r\n    }\r\n\r\n    function blockBots(address[] memory bots_) public onlyOwner {\r\n        for (uint256 i = 0; i < bots_.length; i++) {\r\n            bots[bots_[i]] = true;\r\n        }\r\n    }\r\n\r\n    function unblockBot(address notbot) public onlyOwner {\r\n        bots[notbot] = false;\r\n    }\r\n\r\n    function _tokenTransfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount,\r\n        bool takeFee\r\n    ) private {\r\n        if (!takeFee) removeAllFee();\r\n        _transferStandard(sender, recipient, amount);\r\n        if (!takeFee) restoreAllFee();\r\n    }\r\n\r\n    function _transferStandard(\r\n        address sender,\r\n        address recipient,\r\n        uint256 tAmount\r\n    ) private {\r\n        (\r\n            uint256 rAmount,\r\n            uint256 rTransferAmount,\r\n            uint256 rFee,\r\n            uint256 tTransferAmount,\r\n            uint256 tFee,\r\n            uint256 tTeam\r\n        ) = _getValues(tAmount);\r\n        _rOwned[sender] = _rOwned[sender].sub(rAmount);\r\n        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);\r\n        _takeTeam(tTeam);\r\n        _reflectFee(rFee, tFee);\r\n        emit Transfer(sender, recipient, tTransferAmount);\r\n    }\r\n\r\n    function _takeTeam(uint256 tTeam) private {\r\n        uint256 currentRate = _getRate();\r\n        uint256 rTeam = tTeam.mul(currentRate);\r\n        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);\r\n    }\r\n\r\n    function _reflectFee(uint256 rFee, uint256 tFee) private {\r\n        _rTotal = _rTotal.sub(rFee);\r\n        _tFeeTotal = _tFeeTotal.add(tFee);\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    function _getValues(uint256 tAmount)\r\n        private\r\n        view\r\n        returns (\r\n            uint256,\r\n            uint256,\r\n            uint256,\r\n            uint256,\r\n            uint256,\r\n            uint256\r\n        )\r\n    {\r\n        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =\r\n            _getTValues(tAmount, _redisFee, _taxFee);\r\n        uint256 currentRate = _getRate();\r\n        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =\r\n            _getRValues(tAmount, tFee, tTeam, currentRate);\r\n        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);\r\n    }\r\n\r\n    function _getTValues(\r\n        uint256 tAmount,\r\n        uint256 redisFee,\r\n        uint256 taxFee\r\n    )\r\n        private\r\n        pure\r\n        returns (\r\n            uint256,\r\n            uint256,\r\n            uint256\r\n        )\r\n    {\r\n        uint256 tFee = tAmount.mul(redisFee).div(100);\r\n        uint256 tTeam = tAmount.mul(taxFee).div(100);\r\n        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);\r\n        return (tTransferAmount, tFee, tTeam);\r\n    }\r\n\r\n    function _getRValues(\r\n        uint256 tAmount,\r\n        uint256 tFee,\r\n        uint256 tTeam,\r\n        uint256 currentRate\r\n    )\r\n        private\r\n        pure\r\n        returns (\r\n            uint256,\r\n            uint256,\r\n            uint256\r\n        )\r\n    {\r\n        uint256 rAmount = tAmount.mul(currentRate);\r\n        uint256 rFee = tFee.mul(currentRate);\r\n        uint256 rTeam = tTeam.mul(currentRate);\r\n        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);\r\n        return (rAmount, rTransferAmount, rFee);\r\n    }\r\n\r\n    function _getRate() private view returns (uint256) {\r\n        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\r\n        return rSupply.div(tSupply);\r\n    }\r\n\r\n    function _getCurrentSupply() private view returns (uint256, uint256) {\r\n        uint256 rSupply = _rTotal;\r\n        uint256 tSupply = _tTotal;\r\n        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\r\n        return (rSupply, tSupply);\r\n    }\r\n\r\n    function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {\r\n        _redisFeeOnBuy = redisFeeOnBuy;\r\n        _redisFeeOnSell = redisFeeOnSell;\r\n        _taxFeeOnBuy = taxFeeOnBuy;\r\n        _taxFeeOnSell = taxFeeOnSell;\r\n    }\r\n\r\n    //Set minimum tokens required to swap.\r\n    function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {\r\n        _swapTokensAtAmount = swapTokensAtAmount;\r\n    }\r\n\r\n    //Set minimum tokens required to swap.\r\n    function toggleSwap(bool _swapEnabled) public onlyOwner {\r\n        swapEnabled = _swapEnabled;\r\n    }\r\n\r\n    //Set maximum transaction\r\n    function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {\r\n        _maxTxAmount = maxTxAmount;\r\n    }\r\n\r\n    function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {\r\n        _maxWalletSize = maxWalletSize;\r\n    }\r\n\r\n    function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {\r\n        for(uint256 i = 0; i < accounts.length; i++) {\r\n            _isExcludedFromFee[accounts[i]] = excluded;\r\n        }\r\n    }\r\n\r\n    function allowPreTrading(address[] calldata accounts) public onlyOwner {\r\n        for(uint256 i = 0; i < accounts.length; i++) {\r\n                 preTrader[accounts[i]] = true;\r\n        }\r\n    }\r\n\r\n    function removePreTrading(address[] calldata accounts) public onlyOwner {\r\n        for(uint256 i = 0; i < accounts.length; i++) {\r\n                 delete preTrader[accounts[i]];\r\n        }\r\n    }\r\n}"
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