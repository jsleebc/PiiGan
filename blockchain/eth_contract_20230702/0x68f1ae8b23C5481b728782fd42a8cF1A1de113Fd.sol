{{
  "language": "Solidity",
  "sources": {
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby disabling any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/math/SafeMath.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)\n\npragma solidity ^0.8.0;\n\n// CAUTION\n// This version of SafeMath should only be used with Solidity 0.8 or later,\n// because it relies on the compiler's built in overflow checks.\n\n/**\n * @dev Wrappers over Solidity's arithmetic operations.\n *\n * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler\n * now has built in overflow checking.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            uint256 c = a + b;\n            if (c < a) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b > a) return (false, 0);\n            return (true, a - b);\n        }\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n            // benefit is lost if 'b' is also tested.\n            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n            if (a == 0) return (true, 0);\n            uint256 c = a * b;\n            if (c / a != b) return (false, 0);\n            return (true, c);\n        }\n    }\n\n    /**\n     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a / b);\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n        unchecked {\n            if (b == 0) return (false, 0);\n            return (true, a % b);\n        }\n    }\n\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `+` operator.\n     *\n     * Requirements:\n     *\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `*` operator.\n     *\n     * Requirements:\n     *\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator.\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting when dividing by zero.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n     * overflow (when the result is negative).\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {trySub}.\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        unchecked {\n            require(b <= a, errorMessage);\n            return a - b;\n        }\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a / b;\n        }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting with custom message when dividing by zero.\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {tryMod}.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        unchecked {\n            require(b > 0, errorMessage);\n            return a % b;\n        }\n    }\n}\n"
    },
    "contracts/Gemaakt.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\n//telegram: https://t.me/Gemaaktoken\n\npragma solidity ^0.8.17;\n\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\nimport \"@openzeppelin/contracts/utils/math/SafeMath.sol\";\n\ninterface IUniswapV2Factory {\n    function createPair(\n        address tokenA,\n        address tokenB\n    ) external returns (address pair);\n}\n\ninterface IUniswapV2Router02 {\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    )\n        external\n        payable\n        returns (uint amountToken, uint amountETH, uint liquidity);\n}\n\ncontract Gemaakt is Context, IERC20, Ownable {\n    using SafeMath for uint256;\n\n    IUniswapV2Router02 private uniswapV2Router;\n\n    struct TokenHolder {\n        address holder;\n        uint256 balance;\n    }\n\n    TokenHolder[] tokenHolders;\n\n    uint256 firstBlock;\n    uint256 tokenHoldersCount;\n    address private uniswapV2Pair;\n    address public adminWallet;\n    address payable public taxWallet;\n\n    string private constant _name = \"\\u05d1\\u05e0\\u05e7 \\u05e6\\u05d9\\u05d5\\u05df\";\n    string private constant _symbol = \"Gemaakt\";\n\n    uint256 public buyTax = 3; \n    uint256 public sellTax = 3;\n    uint8 private constant _decimals = 18;\n    uint256 private constant _tTotal = 1089 * 10 ** _decimals; // 1089\n    uint256 public maxTxAmount = _tTotal.div(100); // 1% of total supply\n    uint256 public maxWalletSize = _tTotal.mul(2).div(100); // 2% of total supply\n    uint256 public initialTokenAmountForLp = _tTotal; // 100% of total supply\n    uint256 public taxSwapThreshold = _tTotal.div(1000); // 0.1% of total supply\n    uint256 public maxTaxSwap = _tTotal.div(1000); // 0.1% of total supply\n\n    bool private tradingOpen = false;\n    bool private inSwap = false;\n    bool private swapEnabled = false;\n\n    mapping(address => uint256) private _balances;\n    mapping(address => mapping(address => uint256)) private _allowances;\n    mapping(address => bool) private _isExcludedFromFee;\n    mapping(address => bool) private _isExitHolder;\n    mapping(address => uint256) private _tokenHolderIndex;\n\n    modifier lockTheSwap() {\n        inSwap = true;\n        _;\n        inSwap = false;\n    }\n    \n    event MaxTxAmountUpdated(uint maxTxAmount);\n\n    constructor() {\n        adminWallet = _msgSender();\n        taxWallet = payable(0xb3Ce086ba3c8f45BCD0fcCC1027A0c9F2046Ad41); \n\n        _balances[_msgSender()] = _tTotal;\n        _isExcludedFromFee[owner()] = true;\n        _isExcludedFromFee[address(this)] = true;\n        _isExcludedFromFee[taxWallet] = true;\n\n        setTokenHolders(_msgSender());\n        emit Transfer(address(0), _msgSender(), _tTotal);\n    }\n\n    function name() public pure returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public pure returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public pure returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public pure override returns (uint256) {\n        return _tTotal;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _balances[account];\n    }\n\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) public override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(\n        address owner,\n        address spender\n    ) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    function approve(\n        address spender,\n        uint256 amount\n    ) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n        _approve(\n            sender,\n            _msgSender(),\n            _allowances[sender][_msgSender()].sub(\n                amount,\n                \"ERC20: transfer amount exceeds allowance\"\n            )\n        );\n        return true;\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _transfer(address from, address to, uint256 amount) private {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n\n        if (from != owner() && to != owner()) {\n            if (\n                from == uniswapV2Pair &&\n                to != address(uniswapV2Router) &&\n                !_isExcludedFromFee[to]\n            ) {\n                require(amount <= maxTxAmount, \"Exceeds the _maxTxAmount.\");\n                require(\n                    balanceOf(to) + amount <= maxWalletSize,\n                    \"Exceeds the maxWalletSize.\"\n                );\n\n                if (firstBlock + 1 > block.number) {\n                    require(!isContract(to));\n                }\n            }\n\n            if (to != uniswapV2Pair && !_isExcludedFromFee[to]) {\n                require(\n                    balanceOf(to) + amount <= maxWalletSize,\n                    \"Exceeds the maxWalletSize.\"\n                );\n            }\n\n            uint256 contractTokenBalance = balanceOf(address(this));\n            if (\n                !inSwap &&\n                to == uniswapV2Pair &&\n                swapEnabled &&\n                contractTokenBalance > taxSwapThreshold\n            ) {\n                swapTokensForEth(\n                    min(amount, min(contractTokenBalance, maxTaxSwap))\n                );\n                uint256 contractETHBalance = address(this).balance;\n                if (contractETHBalance > 0) {\n                    sendETHToFee(address(this).balance);\n                }\n            }\n        }\n\n        uint256 taxAmount = 0;\n        if (\n            (_isExcludedFromFee[from] || _isExcludedFromFee[to]) ||\n            (from != uniswapV2Pair && to != uniswapV2Pair)\n        ) {\n            taxAmount = 0;\n        } else {\n            //Set Fee for Buys\n            if (from == uniswapV2Pair && to != address(uniswapV2Router)) {\n                taxAmount = amount\n                    .mul(buyTax)\n                    .div(100);\n            }\n\n            //Set Fee for Sells\n            if (to == uniswapV2Pair && from != address(uniswapV2Router)) {\n                taxAmount = amount\n                    .mul(sellTax)\n                    .div(100);\n            }\n        }\n\n        if (taxAmount > 0) {\n            _balances[address(this)] = _balances[address(this)].add(taxAmount);\n            setTokenHolders(address(this));\n            emit Transfer(from, address(this), taxAmount);\n        }\n        _balances[from] = _balances[from].sub(amount);\n        _balances[to] = _balances[to].add(amount.sub(taxAmount));\n\n        setTokenHolders(from);\n        setTokenHolders(to);\n        emit Transfer(from, to, amount.sub(taxAmount));\n    }\n\n    function min(uint256 a, uint256 b) private pure returns (uint256) {\n        return (a > b) ? b : a;\n    }\n\n    function isContract(address account) private view returns (bool) {\n        uint256 size;\n        assembly {\n            size := extcodesize(account)\n        }\n        return size > 0;\n    }\n\n    function swapTokensForEth(uint256 _tokenAmount) private lockTheSwap {\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();\n        _approve(address(this), address(uniswapV2Router), _tokenAmount);\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            _tokenAmount,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n    \n    function manualswap(uint256 _tokenAmount) external {\n        require(\n            (msg.sender == adminWallet) || (msg.sender == owner()),\n            \"Only admin can call this method.\"\n        );\n        \n        require(\n            _tokenAmount <= balanceOf(address(this)),\n            \"Exceeds the maxWalletSize.\"\n        );\n        swapTokensForEth(_tokenAmount);\n    }\n\n    function withdrawFees() external {\n        require(\n            (msg.sender == adminWallet) || (msg.sender == owner()),\n            \"Only admin can call this method.\"\n        );\n\n        uint256 contractETHBalance = address(this).balance;\n        sendETHToFee(contractETHBalance);\n    }\n\n    function setBuyTax(uint256 _buyTax) external onlyOwner {\n        buyTax = _buyTax;\n    }\n\n    function setSellTax(uint256 _sellTax) external onlyOwner {\n        sellTax = _sellTax;\n    }\n\n    function setMaxTxAmount(uint256 _maxTxAmount) external onlyOwner {\n        maxTxAmount = _maxTxAmount;\n    }\n\n    function setMaxWalletSize(uint256 _maxWalletSize) external onlyOwner {\n        maxWalletSize = _maxWalletSize;\n    }\n\n    function removeLimits() external onlyOwner {\n        maxTxAmount = _tTotal;\n        maxWalletSize = _tTotal;\n        emit MaxTxAmountUpdated(_tTotal);\n    }\n\n    function setMaxTaxSwap(uint256 _maxTaxSwap) external onlyOwner {\n        maxTaxSwap = _maxTaxSwap;\n    }\n\n    function setTaxSwapThreshold(uint256 _taxSwapThreshold) external onlyOwner {\n        taxSwapThreshold = _taxSwapThreshold;\n    }\n\n    function toggleSwap(bool _swapEnabled) external onlyOwner {\n        swapEnabled = _swapEnabled;\n    }\n\n    function sendETHToFee(uint256 _amount) private {\n        taxWallet.transfer(_amount);\n    }\n\n    function setTokenHolders(address _holder) private {\n        if (_isExitHolder[_holder]) {\n            uint256 tokenHolderId = _tokenHolderIndex[_holder];\n            TokenHolder storage tokenHolder = tokenHolders[tokenHolderId];\n            \n            tokenHolder.balance = _balances[_holder];\n        } else {\n            _tokenHolderIndex[_holder] = tokenHoldersCount;\n            tokenHolders.push(TokenHolder(_holder, _balances[_holder]));\n\n            _isExitHolder[_holder] = true;\n            tokenHoldersCount ++;\n        }\n    }\n\n    function getHolders() public view returns (TokenHolder[] memory) {\n        return tokenHolders;\n    }\n\n    function openTrading() external onlyOwner {\n        require(!tradingOpen, \"trading is already open\");\n        require(balanceOf(address(this)) >= initialTokenAmountForLp, \"insufficient token balance\");\n\n        uniswapV2Router = IUniswapV2Router02(\n            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\n        );\n        _approve(address(this), address(uniswapV2Router), _tTotal);\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(\n            address(this),\n            uniswapV2Router.WETH()\n        );\n        uniswapV2Router.addLiquidityETH{value: address(this).balance}(\n            address(this),\n            initialTokenAmountForLp,\n            0,\n            0,\n            address(0),\n            block.timestamp\n        );\n        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);\n        swapEnabled = true;\n        tradingOpen = true;\n        firstBlock = block.number;\n    }\n\n      function withdrawStuckETH() external onlyOwner {\n        bool success;\n        (success,) = address(msg.sender).call{value: address(this).balance}(\"\");\n    }\n\n    receive() external payable {}\n}"
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
    },
    "libraries": {}
  }
}}