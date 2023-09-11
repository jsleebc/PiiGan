{{
  "language": "Solidity",
  "sources": {
    "contracts/Aids.sol": {
      "content": " /* ███████╗██████╗ ██████╗ ███████╗ █████╗ ██████╗      █████╗ ██╗██████╗ ███████╗\n    ██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗    ██╔══██╗██║██╔══██╗██╔════╝\n    ███████╗██████╔╝██████╔╝█████╗  ███████║██║  ██║    ███████║██║██║  ██║███████╗\n    ╚════██║██╔═══╝ ██╔══██╗██╔══╝  ██╔══██║██║  ██║    ██╔══██║██║██║  ██║╚════██║\n    ███████║██║     ██║  ██║███████╗██║  ██║██████╔╝    ██║  ██║██║██████╔╝███████║\n    ╚══════╝╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝     ╚═╝  ╚═╝╚═╝╚═════╝ ╚══════╝ */ \n             \n             /* * * * * * * * * * * * * * * * * * * * * * * * \n                * Website:    https://spreadaids.com/       *\n                * Telegram:   https://t.me/SpreadingAids    *\n                * Twitter:    https://twitter.com/etheraids *\n                * * * * * * * * * * * * * * * * * * * * * * * */\n\n\n\n// SPDX-License-Identifier: MIT\n\npragma solidity 0.8.12;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        this; \n        return msg.data;\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ninterface IERC20Metadata is IERC20 {\n\n    function name() external view returns (string memory);\n\n    function symbol() external view returns (string memory);\n\n    function decimals() external view returns (uint8);\n}\n\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping (address => uint256) internal _balances;\n\n    mapping (address => mapping (address => uint256)) internal _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    constructor (string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\n        _approve(sender, _msgSender(), currentAllowance - amount);\n\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n\n        return true;\n    }\n\n    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        _balances[sender] = senderBalance - amount;\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n    }\n\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n    }\n\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        _balances[account] = accountBalance - amount;\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n    }\n\n    function _approve(address owner, address spender, uint256 amount) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n}\n\nlibrary Address{\n    function sendValue(address payable recipient, uint256 amount) internal {\n        require(address(this).balance >= amount, \"Address: insufficient balance\");\n\n        (bool success, ) = recipient.call{value: amount}(\"\");\n        require(success, \"Address: unable to send value, recipient may have reverted\");\n    }\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor() {\n        _setOwner(_msgSender());\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _setOwner(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _setOwner(newOwner);\n    }\n\n    function _setOwner(address newOwner) private {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\ninterface IFactory{\n        function createPair(address tokenA, address tokenB) external returns (address pair);\n}\n\ninterface IRouter {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline) external;\n}\n\ncontract AidsToken is ERC20, Ownable{\n    using Address for address payable;\n    \n    IRouter public router;\n    address public pair;\n    \n    bool private swapping;\n    bool public swapEnabled;\n    bool public tradingEnabled;\n\n    uint256 public genesis_block;\n    uint256 public deadblocks = 0;\n    \n    uint256 public swapThreshold = 10_000 * 10e18;\n    uint256 public maxTxAmount = 1_500_000 * 10**18;\n    uint256 public maxWalletAmount = 1_500_000 * 10**18;\n    \n    address public marketingWallet = 0xA541D7C4b725dd762ac8D7e0bA350A9A43c273Df;\n    address public devWallet = 0xA541D7C4b725dd762ac8D7e0bA350A9A43c273Df;\n    \n    struct Taxes {\n        uint256 marketing;\n        uint256 liquidity; \n        uint256 dev;\n    }\n    \n    Taxes public taxes = Taxes(0,0,0);\n    Taxes public sellTaxes = Taxes(0,0,0);\n    uint256 public totTax = 0;\n    uint256 public totSellTax = 0;\n    \n    mapping (address => bool) public excludedFromFees;\n    mapping (address => bool) private isBot;\n    \n    modifier inSwap() {\n        if (!swapping) {\n            swapping = true;\n            _;\n            swapping = false;\n        }\n    }\n        \n    constructor() ERC20(\"Aids Token\", \"AIDS\") {\n        _mint(msg.sender, 1e8 * 10 ** decimals());\n        excludedFromFees[msg.sender] = true;\n\n        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        address _pair = IFactory(_router.factory())\n            .createPair(address(this), _router.WETH());\n\n        router = _router;\n        pair = _pair;\n        excludedFromFees[address(this)] = true;\n        excludedFromFees[marketingWallet] = true;\n        excludedFromFees[devWallet] = true;\n    }\n    \n    function _transfer(address sender, address recipient, uint256 amount) internal override {\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n        require(!isBot[sender] && !isBot[recipient], \"You can't transfer tokens\");\n                \n        \n        if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){\n            require(tradingEnabled, \"Trading not active yet\");\n            if(genesis_block + deadblocks > block.number){\n                if(recipient != pair) isBot[recipient] = true;\n                if(sender != pair) isBot[sender] = true;\n            }\n            require(amount <= maxTxAmount, \"You are exceeding maxTxAmount\");\n            if(recipient != pair){\n                require(balanceOf(recipient) + amount <= maxWalletAmount, \"You are exceeding maxWalletAmount\");\n            }\n        }\n\n        uint256 fee;\n        \n  \n        if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;\n        \n \n        else{\n            if(recipient == pair) fee = amount * totSellTax / 100;\n            else fee = amount * totTax / 100;\n        }\n        \n\n        if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();\n\n        super._transfer(sender, recipient, amount - fee);\n        if(fee > 0) super._transfer(sender, address(this) ,fee);\n\n    }\n\n    function swapForFees() private inSwap {\n        uint256 contractBalance = balanceOf(address(this));\n        if (contractBalance >= swapThreshold) {\n\n                    uint256 denominator = totSellTax * 2;\n            uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;\n            uint256 toSwap = contractBalance - tokensToAddLiquidityWith;\n    \n            uint256 initialBalance = address(this).balance;\n    \n            swapTokensForETH(toSwap);\n    \n            uint256 deltaBalance = address(this).balance - initialBalance;\n            uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);\n            uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;\n    \n            if(ethToAddLiquidityWith > 0){\n                // Add liquidity to Uniswap\n                addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);\n            }\n    \n            uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;\n            if(marketingAmt > 0){\n                payable(marketingWallet).sendValue(marketingAmt);\n            }\n            \n            uint256 devAmt = unitBalance * 2 * sellTaxes.dev;\n            if(devAmt > 0){\n                payable(devWallet).sendValue(devAmt);\n            }\n        }\n    }\n\n\n    function swapTokensForETH(uint256 tokenAmount) private {\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = router.WETH();\n\n        _approve(address(this), address(router), tokenAmount);\n\n        // make the swap\n        router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);\n\n    }\n\n    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {\n        // approve token transfer to cover all possible scenarios\n        _approve(address(this), address(router), tokenAmount);\n\n        // add the liquidity\n        router.addLiquidityETH{value: bnbAmount}(\n            address(this),\n            tokenAmount,\n            0, // slippage is unavoidable\n            0, // slippage is unavoidable\n            devWallet,\n            block.timestamp\n        );\n    }\n\n    function setSwapEnabled(bool state) external onlyOwner {\n        swapEnabled = state;\n    }\n\n    function setSwapThreshold(uint256 new_amount) external onlyOwner {\n        swapThreshold = new_amount;\n    }\n\n    function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{\n        require(!tradingEnabled, \"Trading already active\");\n        tradingEnabled = true;\n        swapEnabled = true;\n        genesis_block = block.number;\n        deadblocks = numOfDeadBlocks;\n    }\n\n    function setBuyTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{\n        taxes = Taxes(_marketing, _liquidity, _dev);\n        totTax = _marketing + _liquidity + _dev;\n    }\n\n    function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{\n        sellTaxes = Taxes(_marketing, _liquidity, _dev);\n        totSellTax = _marketing + _liquidity + _dev;\n    }\n    \n    function updateMarketingWallet(address newWallet) external onlyOwner{\n        marketingWallet = newWallet;\n    }\n\n    function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{\n        router = _router;\n        pair = _pair;\n    }\n    \n    function addBots(address[] memory isBot_) public onlyOwner {\n        for (uint i = 0; i < isBot_.length; i++) {\n            isBot[isBot_[i]] = true;\n        }\n    }\n    function updateExcludedFromFees(address _address, bool state) external onlyOwner {\n        excludedFromFees[_address] = state;\n    }\n    \n    function updateMaxTxAmount(uint256 amount) external onlyOwner{\n        maxTxAmount = amount * 10**18;\n    }\n    \n    function updateMaxWalletAmount(uint256 amount) external onlyOwner{\n        maxWalletAmount = amount * 10**18;\n    }\n\n    function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{\n        IERC20(tokenAddress).transfer(owner(), amount);\n    }\n\n    function rescueETH(uint256 weiAmount) external onlyOwner{\n        payable(owner()).sendValue(weiAmount);\n    }\n\n    function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{\n        uint256 initBalance = address(this).balance;\n        swapTokensForETH(amount);\n        uint256 newBalance = address(this).balance - initBalance;\n        if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));\n        if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));\n    }\n\n    // fallbacks\n    receive() external payable {}\n    \n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": false,
      "runs": 512
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