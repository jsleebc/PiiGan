{{
  "language": "Solidity",
  "sources": {
    "TheOG.sol": {
      "content": "/**\nhttps://t.me/OGBotChannel\n**/\n// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.17;\n\nlibrary Address{\n    function sendValue(address payable recipient, uint256 amount) internal {\n        require(address(this).balance >= amount, \"Address: insufficient balance\");\n\n        (bool success, ) = recipient.call{value: amount}(\"\");\n        require(success, \"Address: unable to send value, recipient may have reverted\");\n    }\n}\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address payable) {\n        return payable(msg.sender);\n    }\n\n    function _msgData() internal view virtual returns (bytes memory) {\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n        return msg.data;\n    }\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor() {\n        _setOwner(_msgSender());\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _setOwner(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _setOwner(newOwner);\n    }\n\n    function _setOwner(address newOwner) private {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\ninterface IERC20 {\n\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ninterface IFactory{\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n}\n\ninterface IRouter {\n    function factory() external pure returns (address);\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n    function WETH() external pure returns (address);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline) external;\n}\n\ncontract OG is Context, IERC20, Ownable {\n\n    using Address for address payable;\n\n    IRouter public router;\n    address public pair;\n    \n    mapping (address => uint256) private _tOwned;\n    mapping (address => mapping (address => uint256)) private _allowances;\n\n    mapping (address => bool) public _isExcludedFromFee;\n    mapping (address => bool) public _isExcludedFromMaxBalance;\n    mapping (address => bool) public _isBlacklisted;\n    mapping (address => uint256) public _dogSellTime;\n    \n    uint256 private _dogSellTimeOffset = 3;\n    bool public watchdogMode = true;\n    uint256 public _caughtDogs;\n\n    uint8 private constant _decimals = 9; \n    uint256 private _tTotal = 1_000_000_000 * (10**_decimals); //1b\n    uint256 public swapThreshold = 10_000_000 * (10**_decimals); //10m 1%\n    uint256 public maxTxAmount = 20_000_000 * (10**_decimals); // 20m 2%\n    uint256 public maxWallet =  20_000_000 * (10**_decimals);\n    \n    string private constant _name = \"OG\"; \n    string private constant _symbol = \"OG\";\n\n    struct Tax{\n        uint8 marketingTax;\n        uint8 devTax;\n    }\n\n    struct TokensFromTax{\n        uint marketingTokens;\n        uint devTokens;\n    }\n    TokensFromTax public totalTokensFromTax;\n\n    Tax public buyTax = Tax(0,0);\n    Tax public sellTax = Tax(45,45);\n    \n    address public marketingWallet = 0x430172CFeF7A90afDf7262308aDc6aFd6b5ceB0D;\n    address public devWallet = 0x525bFCb552b39DcaaDD3D1CEdC4BD252B5dd9c28;\n    \n    bool private swapping;\n    bool public disableMaxes = false;\n    modifier lockTheSwap {\n        swapping = true;\n        _;\n        swapping = false;\n    }\n\n\n    constructor () {\n        _tOwned[_msgSender()] = _tTotal;\n        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());\n        router = _router;\n        pair = _pair;\n        _approve(owner(), address(router), ~uint256(0));\n\n        _isExcludedFromFee[owner()] = true;\n        _isExcludedFromFee[address(this)] = true;\n        _isExcludedFromFee[marketingWallet] = true;\n        _isExcludedFromFee[devWallet] = true;\n\n        _isExcludedFromMaxBalance[owner()] = true;\n        _isExcludedFromMaxBalance[address(this)] = true;\n        _isExcludedFromMaxBalance[pair] = true;\n        _isExcludedFromMaxBalance[marketingWallet] = true;\n        _isExcludedFromMaxBalance[devWallet] = true;\n        \n        emit Transfer(address(0), _msgSender(), _tTotal);\n    }\n\n\n// ================= ERC20 =============== //\n    function name() public pure returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public pure returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public pure returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public view override returns (uint256) {\n        return _tTotal;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _tOwned[account];\n    }\n\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);\n        return true;\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n    \n    receive() external payable {}\n// ========================================== //\n\n//============== Owner Functions ===========//\n\n    function owner_rescueETH(uint256 weiAmount) public onlyOwner{\n        require(address(this).balance >= weiAmount, \"Insufficient ETH balance\");\n        payable(msg.sender).transfer(weiAmount);\n    }\n    \n    function owner_rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount_EXACT, uint _decimal) public onlyOwner {\n        IERC20(_tokenAddr).transfer(_to, _amount_EXACT *10**_decimal);\n    }\n\n    function owner_setExcludedFromFee(address account,bool isExcluded) public onlyOwner {\n        _isExcludedFromFee[account] = isExcluded;\n    }\n\n    function owner_setExcludedFromMaxBalance(address account,bool isExcluded) public onlyOwner {\n        _isExcludedFromMaxBalance[account] = isExcluded;\n    }\n\n    function owner_setBuyTaxes(uint8 marketingTax, uint8 devTax) external onlyOwner{\n        uint tTax =  marketingTax + devTax ;\n        require(tTax <= 49, \"Can't set tax too high\");\n        buyTax = Tax(marketingTax,devTax);\n        emit TaxesChanged();\n    }\n\n    function owner_setSellTaxes(uint8 marketingTax, uint8 devTax) external onlyOwner{\n        uint tTax = marketingTax + devTax ;\n        require(tTax <= 49, \"Can't set tax too high\");\n        sellTax = Tax(marketingTax,devTax);\n        emit TaxesChanged();\n    }\n    \n    function owner_setTransferMaxesStatus(bool status_) external onlyOwner{\n        disableMaxes = status_; //true = no more max wallet / max tx\n    }\n\n    function owner_setTransferMaxes(uint maxTX_EXACT, uint maxWallet_EXACT) public onlyOwner{\n        uint pointFiveSupply = (_tTotal * 5 / 1000) / (10**_decimals);\n        require(maxTX_EXACT >= pointFiveSupply && maxWallet_EXACT >= pointFiveSupply, \"Invalid Settings\");\n        maxTxAmount = maxTX_EXACT * (10**_decimals);\n        maxWallet = maxWallet_EXACT * (10**_decimals);\n    }\n\n    function owner_setSwapThreshold(uint swapthreshold_EXACT) public onlyOwner{\n        swapThreshold = swapthreshold_EXACT * (10**_decimals);\n    }\n\n    function owner_setBlacklisted(address account, bool isBlacklisted) public onlyOwner{\n        _isBlacklisted[account] = isBlacklisted;\n    }\n    \n    function owner_setBulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{\n        for(uint256 i =0; i < accounts.length; i++){\n            _isBlacklisted[accounts[i]] = state;\n        }\n    }\n\n    function owner_setWallets(address newMarketingWallet, address newDevWallet) public onlyOwner{\n        marketingWallet = newMarketingWallet;\n        devWallet = newDevWallet;\n    }\n\n    function owner_setWatchDogStatusLaunch(bool status_) external onlyOwner{\n        watchdogMode = status_;\n    }\n\n    function owner_setDogSellTimeForAddress(address holder, uint dTime) external onlyOwner{\n        _dogSellTime[holder] = block.timestamp + dTime;\n    }\n\n// ========================================//\n    \n    function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){\n        Tax memory tmpTaxes = buyTax;\n        if (isSell)\n            tmpTaxes = sellTax;\n        \n        uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100;\n        uint tokensForDev = amount * tmpTaxes.devTax / 100;\n\n        if(tokensForMarketing > 0)\n            totalTokensFromTax.marketingTokens += tokensForMarketing;\n\n        if(tokensForDev > 0)\n            totalTokensFromTax.devTokens += tokensForDev;\n\n        uint totalTaxedTokens = tokensForMarketing + tokensForDev;\n\n        _tOwned[address(this)] += totalTaxedTokens;\n        if(totalTaxedTokens > 0)\n            emit Transfer (from, address(this), totalTaxedTokens);\n            \n        return (amount - totalTaxedTokens);\n    }\n\n    function _transfer(address from,address to,uint256 amount) private {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n        require(!_isBlacklisted[from] && !_isBlacklisted[to], \"Blacklisted, can't trade\");\n\n        if(!disableMaxes){\n            require(amount <= maxTxAmount || _isExcludedFromMaxBalance[from], \"Transfer amount exceeds the _maxTxAmount.\");\n            \n            if(!_isExcludedFromMaxBalance[to])\n                require(balanceOf(to) + amount <= maxWallet, \"Transfer amount exceeds the _maxWallet.\");  \n        }\n            \n        if (balanceOf(address(this)) >= swapThreshold && !swapping && from != pair && from != owner() && to != owner())\n            swapAndLiquify();\n          \n        _tOwned[from] -= amount;\n        uint256 transferAmount = amount;\n        \n        if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){\n            transferAmount = _getTaxValues(amount, from, to == pair);\n            if (from == pair && watchdogMode){\n                _caughtDogs++;\n                _dogSellTime[to] = block.timestamp + _dogSellTimeOffset;\n            }else{\n                if (_dogSellTime[from] != 0)\n                    require(block.timestamp < _dogSellTime[from]); \n            }\n        }\n\n        _tOwned[to] += transferAmount;\n        emit Transfer(from, to, transferAmount);\n    }\n\n    function swapAndLiquify() private lockTheSwap{\n        \n        uint256 totalTokensForSwap = totalTokensFromTax.marketingTokens+totalTokensFromTax.devTokens;\n\n        if(totalTokensForSwap > 0){\n            uint256 ethSwapped = swapTokensForETH(totalTokensForSwap);\n            uint256 ethForMarketing = ethSwapped * totalTokensFromTax.marketingTokens / totalTokensForSwap;\n            uint256 ethForDev = ethSwapped * totalTokensFromTax.devTokens / totalTokensForSwap;\n            if(ethForMarketing > 0){\n                payable(marketingWallet).transfer(ethForMarketing);\n                totalTokensFromTax.marketingTokens = 0;\n            }\n            if(ethForDev > 0){\n                payable(devWallet).transfer(ethForDev);\n                totalTokensFromTax.devTokens = 0;\n            }\n        }   \n\n        emit SwapAndLiquify();\n\n    }\n\n    function swapTokensForETH(uint256 tokenAmount) private returns (uint256) {\n        uint256 initialBalance = address(this).balance;\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = router.WETH();\n\n        _approve(address(this), address(router), tokenAmount);\n\n        router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n        return (address(this).balance - initialBalance);\n    }\n\n    event SwapAndLiquify();\n    event TaxesChanged();\n\n   \n}"
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