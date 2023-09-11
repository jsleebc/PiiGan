{{
  "language": "Solidity",
  "sources": {
    "1.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\n\r\n\r\n/**\r\n\r\nTwitter: https://twitter.com/speech_token\r\nTelegram: https://t.me/+iFwuCtbyjEFiNzNh\r\nMedium:  https://tinyurl.com/sdwqwdasd\r\nWeb: https://speech-matters.org/\r\n\r\n\r\nThe first creative writing/learning bot/technology to help young kids with speech problems have a better way of practicing to engage in dialogues\r\n\r\nenabling them to practice their language skills in a conversational manner. Based on their responses they will be able to mold and change the adaptive\r\n\r\nlearning model via AI to better understand and speak.\r\n\r\n*/\r\npragma solidity >=0.5.0;\r\n\r\ninterface IUniswapV2Factory {\r\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\r\n\r\n    function feeTo() external view returns (address);\r\n    function feeToSetter() external view returns (address);\r\n\r\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\r\n    function allPairs(uint) external view returns (address pair);\r\n    function allPairsLength() external view returns (uint);\r\n\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n\r\n    function setFeeTo(address) external;\r\n    function setFeeToSetter(address) external;\r\n}\r\n\r\n// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol\r\npragma solidity >=0.6.2;\r\n\r\ninterface IUniswapV2Router01 {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint amountADesired,\r\n        uint amountBDesired,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB, uint liquidity);\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint amountTokenDesired,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n    function removeLiquidity(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountA, uint amountB);\r\n    function removeLiquidityETH(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountToken, uint amountETH);\r\n    function removeLiquidityWithPermit(\r\n        address tokenA,\r\n        address tokenB,\r\n        uint liquidity,\r\n        uint amountAMin,\r\n        uint amountBMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountA, uint amountB);\r\n    function removeLiquidityETHWithPermit(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountToken, uint amountETH);\r\n    function swapExactTokensForTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n    function swapTokensForExactTokens(\r\n        uint amountOut,\r\n        uint amountInMax,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint[] memory amounts);\r\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\r\n        external\r\n        payable\r\n        returns (uint[] memory amounts);\r\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\r\n        external\r\n        returns (uint[] memory amounts);\r\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\r\n        external\r\n        returns (uint[] memory amounts);\r\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\r\n        external\r\n        payable\r\n        returns (uint[] memory amounts);\r\n\r\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\r\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\r\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\r\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\r\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\r\n}\r\n\r\n// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol\r\npragma solidity >=0.6.2;\r\n\r\n\r\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\r\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline\r\n    ) external returns (uint amountETH);\r\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\r\n        address token,\r\n        uint liquidity,\r\n        uint amountTokenMin,\r\n        uint amountETHMin,\r\n        address to,\r\n        uint deadline,\r\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\r\n    ) external returns (uint amountETH);\r\n\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external payable;\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n\r\n// File: @openzeppelin/contracts/utils/Context.sol\r\n\r\n\r\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\r\n\r\npragma solidity ^0.8.0;\r\n\r\n/**\r\n * @dev Provides information about the current execution context, including the\r\n * sender of the transaction and its data. While these are generally available\r\n * via msg.sender and msg.data, they should not be accessed in such a direct\r\n * manner, since when dealing with meta-transactions the account sending and\r\n * paying for execution may not be the actual sender (as far as an application\r\n * is concerned).\r\n *\r\n * This contract is only required for intermediate, library-like contracts.\r\n */\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n\r\n// File: @openzeppelin/contracts/access/Ownable.sol\r\n\r\n\r\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\r\n\r\npragma solidity ^0.8.0;\r\n\r\n\r\n/**\r\n * @dev Contract module which provides a basic access control mechanism, where\r\n * there is an account (an owner) that can be granted exclusive access to\r\n * specific functions.\r\n *\r\n * By default, the owner account will be the one that deploys the contract. This\r\n * can later be changed with {transferOwnership}.\r\n *\r\n * This module is used through inheritance. It will make available the modifier\r\n * `onlyOwner`, which can be applied to your functions to restrict their use to\r\n * the owner.\r\n */\r\nabstract contract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        _transferOwnership(_msgSender());\r\n    }\r\n\r\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        _checkOwner();\r\n        _;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    /**\r\n     * @dev Throws if the sender is not the owner.\r\n     */\r\n    function _checkOwner() internal view virtual {\r\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\r\n    }\r\n\r\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        _transferOwnership(address(0));\r\n    }\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        _transferOwnership(newOwner);\r\n    }\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Internal function without access restriction.\r\n     */\r\n    function _transferOwnership(address newOwner) internal virtual {\r\n        address oldOwner = _owner;\r\n        _owner = newOwner;\r\n        emit OwnershipTransferred(oldOwner, newOwner);\r\n    }\r\n}\r\n\r\n// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\r\n\r\n\r\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\r\n\r\npragma solidity ^0.8.0;\r\n\r\n/**\r\n * @dev Interface of the ERC20 standard as defined in the EIP.\r\n */\r\ninterface IERC20 {\r\n    /**\r\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\r\n     * another (`to`).\r\n     *\r\n     * Note that `value` may be zero.\r\n     */\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    /**\r\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\r\n     * a call to {approve}. `value` is the new allowance.\r\n     */\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n\r\n    /**\r\n     * @dev Returns the amount of tokens in existence.\r\n     */\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Returns the amount of tokens owned by `account`.\r\n     */\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from the caller's account to `to`.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transfer(address to, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Returns the remaining number of tokens that `spender` will be\r\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\r\n     * zero by default.\r\n     *\r\n     * This value changes when {approve} or {transferFrom} are called.\r\n     */\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\r\n     * that someone may use both the old and the new allowance by unfortunate\r\n     * transaction ordering. One possible solution to mitigate this race\r\n     * condition is to first reduce the spender's allowance to 0 and set the\r\n     * desired value afterwards:\r\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\r\n     *\r\n     * Emits an {Approval} event.\r\n     */\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from `from` to `to` using the\r\n     * allowance mechanism. `amount` is then deducted from the caller's\r\n     * allowance.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transferFrom(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n}\r\n\r\n\r\n\r\n\r\n\r\n\r\npragma solidity ^0.8.18;\r\n\r\n\r\n\r\n\r\n\r\ncontract SPEECH is IERC20, Ownable {\r\n    string public name = \"SPEECH\";\r\n    string public symbol = \"SPEECH\";\r\n    uint8 public decimals = 18;\r\n    uint256 private constant _totalSupply = 420_000_000_000_000 * 10**18;\r\n    mapping(address => uint256) private _balances;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n    IUniswapV2Router02 public uniswapV2Router;\r\n    address public uniswapV2Pair;\r\n    bool private inSwapAndLiquify;\r\n\r\n    event LiquidityAdded(uint256 tokenAmount, uint256 ethAmount);\r\n\r\n    constructor() {\r\n        _balances[msg.sender] = _totalSupply;\r\n        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\r\n        uniswapV2Router = _uniswapV2Router;\r\n\r\n        emit Transfer(address(0), msg.sender, _totalSupply);\r\n    }\r\n\r\n    function totalSupply() public pure override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(msg.sender, recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender) public view override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount) public override returns (bool) {\r\n        _approve(msg.sender, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\r\n        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\r\n        uint256 currentAllowance = _allowances[msg.sender][spender];\r\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\r\n        _approve(msg.sender, spender, currentAllowance - subtractedValue);\r\n        return true;\r\n    }\r\n\r\n        function _transfer(address sender, address recipient, uint256 amount) internal {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n        require(amount > 0, \"ERC20: transfer amount must be greater than zero\");\r\n        require(_balances[sender] >= amount, \"ERC20: transfer amount exceeds balance\");\r\n\r\n        _balances[sender] -= amount;\r\n        _balances[recipient] += amount;\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _approve(address owner, address spender, uint256 amount) internal {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) external onlyOwner {\r\n        _approve(address(this), address(uniswapV2Router), tokenAmount);\r\n        uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this), tokenAmount,\r\n            0, // slippage is unavoidable\r\n           0, // slippage is unavoidable\r\n            address(this),\r\n           block.timestamp\r\n       );\r\n        inSwapAndLiquify = false;\r\n        emit LiquidityAdded(tokenAmount, ethAmount);\r\n    }\r\n\r\n    function withdrawETH(uint256 amount) external onlyOwner {\r\n      require(amount <= address(this).balance, \"Not enough ETH in the contract\");\r\n        (bool success,) = payable(msg.sender).call{value: amount}(\"\");\r\n       require(success, \"Withdrawal failed\");\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    fallback() external payable {}\r\n\r\n}"
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