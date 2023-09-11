{{
  "language": "Solidity",
  "sources": {
    "lib/openzeppelin-contracts/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) external returns (bool);\n}\n"
    },
    "lib/openzeppelin-contracts/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "src/EverMoon.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.8.19;\n\n// https://twitter.com/EverMoonERC\n// https://t.me/EverMoonERC\n\nimport {IERC20} from \"openzeppelin/token/ERC20/IERC20.sol\";\nimport {Ownable} from \"openzeppelin/access/Ownable.sol\";\n\ninterface IUniswapV2Router02 {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n}\n\ninterface IUniswapV2Factory {\n    function createPair(address tokenA, address tokenB) external returns (address UNISWAP_V2_PAIR);\n}\n\ncontract EverMoon is IERC20, Ownable {\n    /* -------------------------------------------------------------------------- */\n    /*                                   events                                   */\n    /* -------------------------------------------------------------------------- */\n    event Reflect(uint256 amountReflected, uint256 newTotalProportion);\n\n    /* -------------------------------------------------------------------------- */\n    /*                                  constants                                 */\n    /* -------------------------------------------------------------------------- */\n    address constant DEAD = 0x000000000000000000000000000000000000dEaD;\n    address constant ZERO = 0x0000000000000000000000000000000000000000;\n\n    uint256 constant MAX_FEE = 10;\n\n    /* -------------------------------------------------------------------------- */\n    /*                                   states                                   */\n    /* -------------------------------------------------------------------------- */\n    IUniswapV2Router02 public constant UNISWAP_V2_ROUTER =\n        IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n    address public immutable UNISWAP_V2_PAIR;\n\n    struct Fee {\n        uint8 reflection;\n        uint8 marketing;\n        uint8 lp;\n        uint8 buyback;\n        uint8 burn;\n        uint128 total;\n    }\n\n    string _name = \"EverMoon\";\n    string _symbol = \"EVERMOON\";\n\n    uint256 _totalSupply = 1_000_000_000 ether;\n    uint256 public _maxTxAmount = _totalSupply * 2 / 100;\n\n    /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */\n    mapping(address => uint256) public _rOwned;\n    uint256 public _totalProportion = _totalSupply;\n\n    mapping(address => mapping(address => uint256)) _allowances;\n\n    bool public limitsEnabled = true;\n    mapping(address => bool) isFeeExempt;\n    mapping(address => bool) isTxLimitExempt;\n\n    Fee public buyFee = Fee({reflection: 1, marketing: 1, lp: 1, buyback: 1, burn: 1, total: 5});\n    Fee public sellFee = Fee({reflection: 1, marketing: 1, lp: 1, buyback: 1, burn: 1, total: 5});\n\n    address private marketingFeeReceiver;\n    address private lpFeeReceiver;\n    address private buybackFeeReceiver;\n\n    bool public claimingFees = true;\n    uint256 public swapThreshold = (_totalSupply * 2) / 1000;\n    bool inSwap;\n    mapping(address => bool) public blacklists;\n\n    /* -------------------------------------------------------------------------- */\n    /*                                  modifiers                                 */\n    /* -------------------------------------------------------------------------- */\n    modifier swapping() {\n        inSwap = true;\n        _;\n        inSwap = false;\n    }\n\n    /* -------------------------------------------------------------------------- */\n    /*                                 constructor                                */\n    /* -------------------------------------------------------------------------- */\n    constructor() {\n        // create uniswap pair\n        address _uniswapPair =\n            IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());\n        UNISWAP_V2_PAIR = _uniswapPair;\n\n        _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = type(uint256).max;\n        _allowances[address(this)][tx.origin] = type(uint256).max;\n\n        isTxLimitExempt[address(this)] = true;\n        isTxLimitExempt[address(UNISWAP_V2_ROUTER)] = true;\n        isTxLimitExempt[_uniswapPair] = true;\n        isTxLimitExempt[tx.origin] = true;\n        isFeeExempt[tx.origin] = true;\n\n        marketingFeeReceiver = 0xeEA122Ad5f9c02fa3Bec08115E7CDb4D65142C81;\n        lpFeeReceiver = 0x31D650bdE669fFcd5A7E1745D6E8306c8100E520;\n        buybackFeeReceiver = 0xF07B6322A5eF6297F10eDE3dbc6ce0612dA9875D;\n\n        _rOwned[tx.origin] = _totalSupply;\n        emit Transfer(address(0), tx.origin, _totalSupply);\n    }\n\n    receive() external payable {}\n\n    /* -------------------------------------------------------------------------- */\n    /*                                    ERC20                                   */\n    /* -------------------------------------------------------------------------- */\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _allowances[msg.sender][spender] = amount;\n        emit Approval(msg.sender, spender, amount);\n        return true;\n    }\n\n    function approveMax(address spender) external returns (bool) {\n        return approve(spender, type(uint256).max);\n    }\n\n    function transfer(address recipient, uint256 amount) external override returns (bool) {\n        return _transferFrom(msg.sender, recipient, amount);\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\n        if (_allowances[sender][msg.sender] != type(uint256).max) {\n            require(_allowances[sender][msg.sender] >= amount, \"ERC20: insufficient allowance\");\n            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;\n        }\n\n        return _transferFrom(sender, recipient, amount);\n    }\n\n    /* -------------------------------------------------------------------------- */\n    /*                                    views                                   */\n    /* -------------------------------------------------------------------------- */\n    function totalSupply() external view override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function decimals() external pure returns (uint8) {\n        return 18;\n    }\n\n    function name() external view returns (string memory) {\n        return _name;\n    }\n\n    function symbol() external view returns (string memory) {\n        return _symbol;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return tokenFromReflection(_rOwned[account]);\n    }\n\n    function allowance(address holder, address spender) external view override returns (uint256) {\n        return _allowances[holder][spender];\n    }\n\n    function tokensToProportion(uint256 tokens) public view returns (uint256) {\n        return tokens * _totalProportion / _totalSupply;\n    }\n\n    function tokenFromReflection(uint256 proportion) public view returns (uint256) {\n        return proportion * _totalSupply / _totalProportion;\n    }\n\n    function getCirculatingSupply() public view returns (uint256) {\n        return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);\n    }\n\n    /* -------------------------------------------------------------------------- */\n    /*                                   owners                                   */\n    /* -------------------------------------------------------------------------- */\n    function clearStuckBalance() external onlyOwner {\n        (bool success,) = payable(msg.sender).call{value: address(this).balance}(\"\");\n        require(success);\n    }\n\n    function clearStuckToken() external onlyOwner {\n        _transferFrom(address(this), msg.sender, balanceOf(address(this)));\n    }\n\n    function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {\n        claimingFees = _enabled;\n        swapThreshold = _amount;\n    }\n\n    function changeFees(\n        uint8 reflectionFeeBuy,\n        uint8 marketingFeeBuy,\n        uint8 lpFeeBuy,\n        uint8 buybackFeeBuy,\n        uint8 burnFeeBuy,\n        uint8 reflectionFeeSell,\n        uint8 marketingFeeSell,\n        uint8 lpFeeSell,\n        uint8 buybackFeeSell,\n        uint8 burnFeeSell\n    ) external onlyOwner {\n        uint128 __totalBuyFee = reflectionFeeBuy + marketingFeeBuy + lpFeeBuy + buybackFeeBuy + burnFeeBuy;\n        uint128 __totalSellFee = reflectionFeeSell + marketingFeeSell + lpFeeSell + buybackFeeSell + burnFeeSell;\n\n        require(__totalBuyFee <= MAX_FEE, \"Buy fees too high\");\n        require(__totalSellFee <= MAX_FEE, \"Sell fees too high\");\n\n        buyFee = Fee({\n            reflection: reflectionFeeBuy,\n            marketing: reflectionFeeBuy,\n            lp: reflectionFeeBuy,\n            buyback: reflectionFeeBuy,\n            burn: burnFeeBuy,\n            total: __totalBuyFee\n        });\n\n        sellFee = Fee({\n            reflection: reflectionFeeSell,\n            marketing: reflectionFeeSell,\n            lp: reflectionFeeSell,\n            buyback: reflectionFeeSell,\n            burn: burnFeeSell,\n            total: __totalSellFee\n        });\n    }\n\n    function setIsFeeExempt(address holder, bool exempt) external onlyOwner {\n        isFeeExempt[holder] = exempt;\n    }\n\n    function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {\n        isTxLimitExempt[holder] = exempt;\n    }\n\n    function setFeeReceivers(address m_, address lp_, address b_) external onlyOwner {\n        marketingFeeReceiver = m_;\n        lpFeeReceiver = lp_;\n        buybackFeeReceiver = b_;\n    }\n\n    function setMaxTxBasisPoint(uint256 p_) external onlyOwner {\n        _maxTxAmount = _totalSupply * p_ / 10000;\n    }\n\n    function setLimitsEnabled(bool e_) external onlyOwner {\n        limitsEnabled = e_;\n    }\n\n    function blacklist(address _address, bool _isBlacklisting) external onlyOwner {\n        blacklists[_address] = _isBlacklisting;\n    }\n\n    /* -------------------------------------------------------------------------- */\n    /*                                   private                                  */\n    /* -------------------------------------------------------------------------- */\n    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {\n        require(!blacklists[recipient] && !blacklists[sender], \"Blacklisted\");\n\n        if (inSwap) {\n            return _basicTransfer(sender, recipient, amount);\n        }\n\n        if (limitsEnabled && !isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {\n            require(amount <= _maxTxAmount, \"Transfer amount exceeds the maxTxAmount.\");\n        }\n\n        if (_shouldSwapBack()) {\n            _swapBack();\n        }\n\n        uint256 proportionAmount = tokensToProportion(amount);\n        require(_rOwned[sender] >= proportionAmount, \"Insufficient Balance\");\n        _rOwned[sender] = _rOwned[sender] - proportionAmount;\n\n        uint256 proportionReceived = _shouldTakeFee(sender, recipient)\n            ? _takeFeeInProportions(sender == UNISWAP_V2_PAIR ? true : false, sender, proportionAmount)\n            : proportionAmount;\n        _rOwned[recipient] = _rOwned[recipient] + proportionReceived;\n\n        emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));\n        return true;\n    }\n\n    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\n        uint256 proportionAmount = tokensToProportion(amount);\n        require(_rOwned[sender] >= proportionAmount, \"Insufficient Balance\");\n        _rOwned[sender] = _rOwned[sender] - proportionAmount;\n        _rOwned[recipient] = _rOwned[recipient] + proportionAmount;\n        emit Transfer(sender, recipient, amount);\n        return true;\n    }\n\n    function _takeFeeInProportions(bool buying, address sender, uint256 proportionAmount) internal returns (uint256) {\n        Fee memory __buyFee = buyFee;\n        Fee memory __sellFee = sellFee;\n\n        uint256 proportionFeeAmount =\n            buying == true ? proportionAmount * __buyFee.total / 100 : proportionAmount * __sellFee.total / 100;\n\n        // reflect\n        uint256 proportionReflected = buying == true\n            ? proportionFeeAmount * __buyFee.reflection / __buyFee.total\n            : proportionFeeAmount * __sellFee.reflection / __sellFee.total;\n\n        _totalProportion = _totalProportion - proportionReflected;\n\n        // take fees\n        uint256 _proportionToContract = proportionFeeAmount - proportionReflected;\n        if (_proportionToContract > 0) {\n            _rOwned[address(this)] = _rOwned[address(this)] + _proportionToContract;\n\n            emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));\n        }\n        emit Reflect(proportionReflected, _totalProportion);\n        return proportionAmount - proportionFeeAmount;\n    }\n\n    function _shouldSwapBack() internal view returns (bool) {\n        return msg.sender != UNISWAP_V2_PAIR && !inSwap && claimingFees && balanceOf(address(this)) >= swapThreshold;\n    }\n\n    function _swapBack() internal swapping {\n        Fee memory __sellFee = sellFee;\n\n        uint256 __swapThreshold = swapThreshold;\n        uint256 amountToBurn = __swapThreshold * __sellFee.burn / __sellFee.total;\n        uint256 amountToSwap = __swapThreshold - amountToBurn;\n        approve(address(UNISWAP_V2_ROUTER), amountToSwap);\n\n        // burn\n        _transferFrom(address(this), DEAD, amountToBurn);\n\n        // swap\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = UNISWAP_V2_ROUTER.WETH();\n\n        UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            amountToSwap, 0, path, address(this), block.timestamp\n        );\n\n        uint256 amountETH = address(this).balance;\n\n        uint256 totalSwapFee = __sellFee.total - __sellFee.reflection - __sellFee.burn;\n        uint256 amountETHMarketing = amountETH * __sellFee.marketing / totalSwapFee;\n        uint256 amountETHLP = amountETH * __sellFee.lp / totalSwapFee;\n        uint256 amountETHBuyback = amountETH * __sellFee.buyback / totalSwapFee;\n\n        // send\n        (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}(\"\");\n        (tmpSuccess,) = payable(lpFeeReceiver).call{value: amountETHLP}(\"\");\n        (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHBuyback}(\"\");\n    }\n\n    function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {\n        return !isFeeExempt[sender] && !isFeeExempt[recipient];\n    }\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/",
      "openzeppelin-contracts/=lib/openzeppelin-contracts/",
      "openzeppelin/=lib/openzeppelin-contracts/contracts/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "metadata": {
      "bytecodeHash": "ipfs",
      "appendCBOR": true
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
    "evmVersion": "london",
    "libraries": {}
  }
}}