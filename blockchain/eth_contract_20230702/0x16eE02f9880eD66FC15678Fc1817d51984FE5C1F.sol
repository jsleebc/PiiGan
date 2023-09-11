{{
  "language": "Solidity",
  "sources": {
    "contracts/MyContract.sol": {
      "content": "/**\n *Submitted for verification at Etherscan.io on 2023-05-04\n*/\n\n// SPDX-License-Identifier: MIT\n\n\npragma solidity ^0.8.18;\n\n\ninterface IERC20 {\n\n    function totalSupply() external view returns (uint256);\n\n\n    function balanceOf(address account) external view returns (uint256);\n\n\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n\n    function allowance(address owner, address spender) external view returns (uint256);\n\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n\n\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\n\ninterface IERC20Metadata is IERC20 {\n\n    function name() external view returns (string memory);\n\n\n    function symbol() external view returns (string memory);\n\n\n    function decimals() external view returns (uint8);\n}\n\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n\n\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(currentAllowance >= amount, \"ERC20: transfer amount exceeds allowance\");\n    unchecked {\n        _approve(sender, _msgSender(), currentAllowance - amount);\n    }\n\n        return true;\n    }\n\n\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n    unchecked {\n        _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n    }\n\n        return true;\n    }\n\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n    unchecked {\n        _balances[sender] = senderBalance - amount;\n    }\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n\n        _afterTokenTransfer(sender, recipient, amount);\n    }\n\n\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n    unchecked {\n        _balances[account] = accountBalance - amount;\n    }\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n\n    function renounceOwnership() public virtual onlyOwner {\n        _setOwner(address(0));\n    }\n\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _setOwner(newOwner);\n    }\n\n\n\n    function _setOwner(address newOwner) internal {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\n\nabstract contract Pausable is Context {\n    /**\n     * @dev Emitted when the pause is triggered by `account`.\n     */\n    event Paused(address account);\n\n    /**\n     * @dev Emitted when the pause is lifted by `account`.\n     */\n    event Unpaused(address account);\n\n    bool private _paused;\n\n    /**\n     * @dev Initializes the contract in unpaused state.\n     */\n    constructor() {\n        _paused = false;\n    }\n\n\n    function paused() public view virtual returns (bool) {\n        return _paused;\n    }\n\n\n    modifier whenNotPaused() {\n        require(!paused(), \"Pausable: paused\");\n        _;\n    }\n\n\n    modifier whenPaused() {\n        require(paused(), \"Pausable: not paused\");\n        _;\n    }\n\n\n    function _pause() internal virtual whenNotPaused {\n        _paused = true;\n        emit Paused(_msgSender());\n    }\n\n\n    function _unpause() internal virtual whenPaused {\n        _paused = false;\n        emit Unpaused(_msgSender());\n    }\n}\n\ninterface IUniswapV2Pair {\n    event Approval(address indexed owner, address indexed spender, uint value);\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function name() external pure returns (string memory);\n    function symbol() external pure returns (string memory);\n    function decimals() external pure returns (uint8);\n    function totalSupply() external view returns (uint);\n    function balanceOf(address owner) external view returns (uint);\n    function allowance(address owner, address spender) external view returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n    function transfer(address to, uint value) external returns (bool);\n    function transferFrom(address from, address to, uint value) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n    function nonces(address owner) external view returns (uint);\n\n    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n\n    event Mint(address indexed sender, uint amount0, uint amount1);\n    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n    event Swap(\n        address indexed sender,\n        uint amount0In,\n        uint amount1In,\n        uint amount0Out,\n        uint amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\n    function factory() external view returns (address);\n    function token0() external view returns (address);\n    function token1() external view returns (address);\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n    function price0CumulativeLast() external view returns (uint);\n    function price1CumulativeLast() external view returns (uint);\n    function kLast() external view returns (uint);\n\n    function mint(address to) external returns (uint liquidity);\n    function burn(address to) external returns (uint amount0, uint amount1);\n    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n    function skim(address to) external;\n    function sync() external;\n\n    function initialize(address, address) external;\n}\n\ninterface IUniswapV2Factory {\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n\n    function feeTo() external view returns (address);\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\n    function allPairs(uint) external view returns (address pair);\n    function allPairsLength() external view returns (uint);\n\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n\n    function setFeeTo(address) external;\n    function setFeeToSetter(address) external;\n}\n\ninterface IUniswapV2Router01 {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n    function removeLiquidity(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETH(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountToken, uint amountETH);\n    function removeLiquidityWithPermit(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETHWithPermit(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountToken, uint amountETH);\n    function swapExactTokensForTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapTokensForExactTokens(\n        uint amountOut,\n        uint amountInMax,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n    external\n    payable\n    returns (uint[] memory amounts);\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n    external\n    returns (uint[] memory amounts);\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n    external\n    returns (uint[] memory amounts);\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n    external\n    payable\n    returns (uint[] memory amounts);\n\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n}\n\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountETH);\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountETH);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n\ncontract PepeBoat is ERC20, Ownable, Pausable {\n\n    IERC20 public pepeToken;\n\n    uint256 private initialSupply;\n\n    uint256 private denominator = 100;\n\n    uint256 private swapThreshold = 0.0000009 ether;\n\n    uint256 private devTaxBuy;\n    uint256 private liquidityTaxBuy;\n\n\n    uint256 private devTaxSell;\n    uint256 private liquidityTaxSell;\n    uint256 public maxWallet;\n\n    address private devTaxWallet;\n    address private liquidityTaxWallet;\n\n    address public pepeTokenAddress;\n    address public launchpadAddress;\n\n\n\n    // Mappings\n\n    mapping (address => bool) private blacklist;\n    mapping (address => bool) private excludeList;\n\n\n    mapping (string => uint256) private buyTaxes;\n    mapping (string => uint256) private sellTaxes;\n    mapping (string => address) private taxWallets;\n\n    bool public taxStatus = true;\n\n    IUniswapV2Router02 private uniswapV2Router02;\n    IUniswapV2Factory private uniswapV2Factory;\n    IUniswapV2Pair private uniswapV2Pair;\n\n    constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol)      payable\n    {\n        initialSupply =_supply * (10**18);\n        maxWallet = initialSupply * 2 / 100; //2% of the supply\n        _setOwner(msg.sender);\n        uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());\n        uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));\n        taxWallets[\"liquidity\"] = address(0);\n        setBuyTax(13,2); //dev tax, liquidity tax\n        setSellTax(13,2); //dev tax, liquidity tax\n        setTaxWallets(msg.sender);\n        exclude(msg.sender);\n        exclude(address(this));\n        exclude(devTaxWallet);\n        _mint(msg.sender, initialSupply);\n    }\n\n\n    uint256 private devTokens;\n    uint256 private liquidityTokens;\n\n\n\n    function handleTax(address from, address to, uint256 amount) private returns (uint256) {\n        address[] memory sellPath = new address[](2);\n        sellPath[0] = address(this);\n        sellPath[1] = uniswapV2Router02.WETH();\n\n        if(!isExcluded(from) && !isExcluded(to)) {\n            uint256 tax;\n            uint256 baseUnit = amount / denominator;\n            if(from == address(uniswapV2Pair)) {\n                tax += baseUnit * buyTaxes[\"dev\"];\n                tax += baseUnit * buyTaxes[\"liquidity\"];\n\n\n                if(tax > 0) {\n                    _transfer(from, address(this), tax);\n                }\n\n\n                devTokens += baseUnit * buyTaxes[\"dev\"];\n                liquidityTokens += baseUnit * buyTaxes[\"liquidity\"];\n\n            } else if(to == address(uniswapV2Pair)) {\n\n                tax += baseUnit * sellTaxes[\"dev\"];\n                tax += baseUnit * sellTaxes[\"liquidity\"];\n\n\n                if(tax > 0) {\n                    _transfer(from, address(this), tax);\n                }\n\n\n                devTokens += baseUnit * sellTaxes[\"dev\"];\n                liquidityTokens += baseUnit * sellTaxes[\"liquidity\"];\n\n\n                uint256 taxSum =  devTokens + liquidityTokens;\n\n                if(taxSum == 0) return amount;\n\n                uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];\n\n                if(ethValue >= swapThreshold) {\n                    uint256 startBalance = address(this).balance;\n\n                    uint256 toSell = devTokens + liquidityTokens / 2 ;\n\n                    _approve(address(this), address(uniswapV2Router02), toSell);\n\n                    uniswapV2Router02.swapExactTokensForETH(\n                        toSell,\n                        0,\n                        sellPath,\n                        address(this),\n                        block.timestamp\n                    );\n\n                    uint256 ethGained = address(this).balance - startBalance;\n\n                    uint256 liquidityToken = liquidityTokens / 2;\n                    uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;\n\n\n                    uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;\n\n\n                    _approve(address(this), address(uniswapV2Router02), liquidityToken);\n\n                    uniswapV2Router02.addLiquidityETH{value: liquidityETH}(\n                        address(this),\n                        liquidityToken,\n                        0,\n                        0,\n                        taxWallets[\"liquidity\"],\n                        block.timestamp\n                    );\n\n                    uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);\n\n                    if(remainingTokens > 0) {\n                        _transfer(address(this), taxWallets[\"dev\"], remainingTokens);\n                    }\n\n\n                    (bool success,) = taxWallets[\"dev\"].call{value: devETH}(\"\");\n                    require(success, \"transfer to  dev wallet failed\");\n\n\n                    if(ethGained - ( devETH + liquidityETH) > 0) {\n                        (bool success1,) = taxWallets[\"dev\"].call{value: ethGained - (devETH + liquidityETH)}(\"\");\n                        require(success1, \"transfer to  dev wallet failed\");\n                    }\n\n\n\n\n                    devTokens = 0;\n                    liquidityTokens = 0;\n\n                }\n\n            }\n\n            amount -= tax;\n            if (to != address(uniswapV2Pair)){\n                require(balanceOf(to) + amount <= maxWallet, \"maxWallet limit exceeded\");\n            }\n\n        }\n\n        return amount;\n    }\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal override virtual {\n        require(!paused(), \"ERC20: token transfer while paused\");\n        require(!isBlacklisted(msg.sender), \"ERC20: sender blacklisted\");\n        require(!isBlacklisted(recipient), \"ERC20: recipient blacklisted\");\n        require(!isBlacklisted(tx.origin), \"ERC20: sender blacklisted\");\n\n        if(taxStatus) {\n            amount = handleTax(sender, recipient, amount);\n        }\n\n        super._transfer(sender, recipient, amount);\n    }\n\n\n\n    /**\n     * @dev Triggers the tax handling functionality\n     */\n    function triggerTax() public onlyOwner {\n        handleTax(address(0), address(uniswapV2Pair), 0);\n    }\n\n    function setPepeTokenAddress(address _pepeTokenAddress) external onlyOwner {\n        pepeTokenAddress = _pepeTokenAddress;\n        pepeToken = IERC20(pepeTokenAddress);\n    }\n\n    function pepeRewards(address[] calldata holders, uint256[] calldata rewards) external onlyOwner {\n        require(holders.length == rewards.length, \"Holders and rewards arrays must have the same length.\");\n\n        for (uint256 i = 0; i < holders.length; i++) {\n            require(pepeToken.transferFrom(msg.sender, holders[i], rewards[i]), \"Transfer failed.\");\n        }\n    }\n\n    /**\n     * @dev Pauses transfers on the token.\n     */\n    function pause() public onlyOwner {\n        require(!paused(), \"ERC20: Contract is already paused\");\n        _pause();\n    }\n\n    /**\n     * @dev Unpauses transfers on the token.\n     */\n    function unpause() public onlyOwner {\n        require(paused(), \"ERC20: Contract is not paused\");\n        _unpause();\n    }\n\n    /**\n    * @dev set max wallet limit per address.\n     */\n\n    function setMaxWallet (uint256 amount) external onlyOwner {\n        require (amount > 10000, \"NO rug pull\");\n        maxWallet = amount * 10**18;\n    }\n\n    /**\n     * @dev Burns tokens from caller address.\n     */\n    function burn(uint256 amount) public onlyOwner {\n        _burn(msg.sender, amount);\n    }\n\n    /**\n     * @dev Blacklists the specified account (Disables transfers to and from the account).\n     */\n    function enableBlacklist(address account) public onlyOwner {\n        require(!blacklist[account], \"ERC20: Account is already blacklisted\");\n        blacklist[account] = true;\n    }\n\n\n\n    /**\n     * @dev Remove the specified account from the blacklist.\n     */\n    function disableBlacklist(address account) public onlyOwner {\n        require(blacklist[account], \"ERC20: Account is not blacklisted\");\n        blacklist[account] = false;\n    }\n\n\n\n    /**\n     * @dev Excludes the specified account from tax.\n     */\n    function exclude(address account) public onlyOwner {\n        require(!isExcluded(account), \"ERC20: Account is already excluded\");\n        excludeList[account] = true;\n    }\n\n\n    function removeExclude(address account) public onlyOwner {\n        require(isExcluded(account), \"ERC20: Account is not excluded\");\n        excludeList[account] = false;\n    }\n\n\n    function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {\n        buyTaxes[\"dev\"] = dev;\n        buyTaxes[\"liquidity\"] = liquidity;\n\n    }\n\n\n    function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {\n\n        sellTaxes[\"dev\"] = dev;\n        sellTaxes[\"liquidity\"] = liquidity;\n\n    }\n\n\n    function setTaxWallets(address dev) public onlyOwner {\n        taxWallets[\"dev\"] = dev;\n\n    }\n\n    function claimStuckTokens(address _token) external onlyOwner {\n\n        if (_token == address(0x0)) {\n            payable(owner()).transfer(address(this).balance);\n            return;\n        }\n        IERC20 erc20token = IERC20(_token);\n        uint256 balance = erc20token.balanceOf(address(this));\n        erc20token.transfer(owner(), balance);\n    }\n\n\n    function enableTax() public onlyOwner {\n        require(!taxStatus, \"ERC20: Tax is already enabled\");\n        taxStatus = true;\n    }\n\n\n    function disableTax() public onlyOwner {\n        require(taxStatus, \"ERC20: Tax is already disabled\");\n        taxStatus = false;\n    }\n\n\n    function isBlacklisted(address account) public view returns (bool) {\n        return blacklist[account];\n    }\n\n\n    function isExcluded(address account) public view returns (bool) {\n        return excludeList[account];\n    }\n\n    receive() external payable {}\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "evmVersion": "paris",
    "remappings": [],
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