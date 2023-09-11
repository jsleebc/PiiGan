{"Context.sol":{"content":"// SPDX-License-Identifier: MIT\r\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\r\n\r\npragma solidity ^0.8.0;\r\n\r\n/**\r\n * @dev Provides information about the current execution context, including the\r\n * sender of the transaction and its data. While these are generally available\r\n * via msg.sender and msg.data, they should not be accessed in such a direct\r\n * manner, since when dealing with meta-transactions the account sending and\r\n * paying for execution may not be the actual sender (as far as an application\r\n * is concerned).\r\n *\r\n * This contract is only required for intermediate, library-like contracts.\r\n */\r\nabstract contract Context {\r\n    function _msgSender() internal view virtual returns (address) {\r\n        return msg.sender;\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes calldata) {\r\n        return msg.data;\r\n    }\r\n}"},"ERC20.sol":{"content":"// SPDX-License-Identifier: MIT\r\n// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)\r\n\r\npragma solidity ^0.8.0;\r\n\r\nimport \"./IERC20.sol\";\r\nimport \"./IERC20Metadata.sol\";\r\nimport \"./Context.sol\";\r\n\r\n/**\r\n * @dev Implementation of the {IERC20} interface.\r\n *\r\n * This implementation is agnostic to the way tokens are created. This means\r\n * that a supply mechanism has to be added in a derived contract using {_mint}.\r\n * For a generic mechanism see {ERC20PresetMinterPauser}.\r\n *\r\n * TIP: For a detailed writeup see our guide\r\n * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How\r\n * to implement supply mechanisms].\r\n *\r\n * We have followed general OpenZeppelin Contracts guidelines: functions revert\r\n * instead returning `false` on failure. This behavior is nonetheless\r\n * conventional and does not conflict with the expectations of ERC20\r\n * applications.\r\n *\r\n * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\r\n * This allows applications to reconstruct the allowance for all accounts just\r\n * by listening to said events. Other implementations of the EIP may not emit\r\n * these events, as it isn\u0027t required by the specification.\r\n *\r\n * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\r\n * functions have been added to mitigate the well-known issues around setting\r\n * allowances. See {IERC20-approve}.\r\n */\r\ncontract ERC20 is Context, IERC20, IERC20Metadata {\r\n    mapping(address =\u003e uint256) private _balances;\r\n\r\n    mapping(address =\u003e mapping(address =\u003e uint256)) private _allowances;\r\n\r\n    uint256 private _totalSupply;\r\n\r\n    string private _name;\r\n    string private _symbol;\r\n\r\n    /**\r\n     * @dev Sets the values for {name} and {symbol}.\r\n     *\r\n     * The default value of {decimals} is 18. To select a different value for\r\n     * {decimals} you should overload it.\r\n     *\r\n     * All two of these values are immutable: they can only be set once during\r\n     * construction.\r\n     */\r\n    constructor(string memory name_, string memory symbol_) {\r\n        _name = name_;\r\n        _symbol = symbol_;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the name of the token.\r\n     */\r\n    function name() public view virtual override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the symbol of the token, usually a shorter version of the\r\n     * name.\r\n     */\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the number of decimals used to get its user representation.\r\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\r\n     * be displayed to a user as `5.05` (`505 / 10 ** 2`).\r\n     *\r\n     * Tokens usually opt for a value of 18, imitating the relationship between\r\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\r\n     * overridden;\r\n     *\r\n     * NOTE: This information is only used for _display_ purposes: it in\r\n     * no way affects any of the arithmetic of the contract, including\r\n     * {IERC20-balanceOf} and {IERC20-transfer}.\r\n     */\r\n    function decimals() public view virtual override returns (uint8) {\r\n        return 18;\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-totalSupply}.\r\n     */\r\n    function totalSupply() public view virtual override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-balanceOf}.\r\n     */\r\n    function balanceOf(address account) public view virtual override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-transfer}.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `to` cannot be the zero address.\r\n     * - the caller must have a balance of at least `amount`.\r\n     */\r\n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\r\n        address owner = _msgSender();\r\n        _transfer(owner, to, amount);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-allowance}.\r\n     */\r\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-approve}.\r\n     *\r\n     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on\r\n     * `transferFrom`. This is semantically equivalent to an infinite approval.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `spender` cannot be the zero address.\r\n     */\r\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\r\n        address owner = _msgSender();\r\n        _approve(owner, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev See {IERC20-transferFrom}.\r\n     *\r\n     * Emits an {Approval} event indicating the updated allowance. This is not\r\n     * required by the EIP. See the note at the beginning of {ERC20}.\r\n     *\r\n     * NOTE: Does not update the allowance if the current allowance\r\n     * is the maximum `uint256`.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `from` and `to` cannot be the zero address.\r\n     * - `from` must have a balance of at least `amount`.\r\n     * - the caller must have allowance for ``from``\u0027s tokens of at least\r\n     * `amount`.\r\n     */\r\n    function transferFrom(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        address spender = _msgSender();\r\n        _spendAllowance(from, spender, amount);\r\n        _transfer(from, to, amount);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\r\n     *\r\n     * This is an alternative to {approve} that can be used as a mitigation for\r\n     * problems described in {IERC20-approve}.\r\n     *\r\n     * Emits an {Approval} event indicating the updated allowance.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `spender` cannot be the zero address.\r\n     */\r\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\r\n        address owner = _msgSender();\r\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\r\n     *\r\n     * This is an alternative to {approve} that can be used as a mitigation for\r\n     * problems described in {IERC20-approve}.\r\n     *\r\n     * Emits an {Approval} event indicating the updated allowance.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `spender` cannot be the zero address.\r\n     * - `spender` must have allowance for the caller of at least\r\n     * `subtractedValue`.\r\n     */\r\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\r\n        address owner = _msgSender();\r\n        uint256 currentAllowance = allowance(owner, spender);\r\n        require(currentAllowance \u003e= subtractedValue, \"ERC20: decreased allowance below zero\");\r\n        unchecked {\r\n            _approve(owner, spender, currentAllowance - subtractedValue);\r\n        }\r\n\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Moves `amount` of tokens from `from` to `to`.\r\n     *\r\n     * This internal function is equivalent to {transfer}, and can be used to\r\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `from` cannot be the zero address.\r\n     * - `to` cannot be the zero address.\r\n     * - `from` must have a balance of at least `amount`.\r\n     */\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n\r\n        _beforeTokenTransfer(from, to, amount);\r\n\r\n        uint256 fromBalance = _balances[from];\r\n        require(fromBalance \u003e= amount, \"ERC20: transfer amount exceeds balance\");\r\n        unchecked {\r\n            _balances[from] = fromBalance - amount;\r\n            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by\r\n            // decrementing then incrementing.\r\n            _balances[to] += amount;\r\n        }\r\n\r\n        emit Transfer(from, to, amount);\r\n\r\n        _afterTokenTransfer(from, to, amount);\r\n    }\r\n\r\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\r\n     * the total supply.\r\n     *\r\n     * Emits a {Transfer} event with `from` set to the zero address.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `account` cannot be the zero address.\r\n     */\r\n    function _mint(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: mint to the zero address\");\r\n\r\n        _beforeTokenTransfer(address(0), account, amount);\r\n\r\n        _totalSupply += amount;\r\n        unchecked {\r\n            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.\r\n            _balances[account] += amount;\r\n        }\r\n        emit Transfer(address(0), account, amount);\r\n\r\n        _afterTokenTransfer(address(0), account, amount);\r\n    }\r\n\r\n    /**\r\n     * @dev Destroys `amount` tokens from `account`, reducing the\r\n     * total supply.\r\n     *\r\n     * Emits a {Transfer} event with `to` set to the zero address.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `account` cannot be the zero address.\r\n     * - `account` must have at least `amount` tokens.\r\n     */\r\n    function _burn(address account, uint256 amount) internal virtual {\r\n        require(account != address(0), \"ERC20: burn from the zero address\");\r\n\r\n        _beforeTokenTransfer(account, address(0), amount);\r\n\r\n        uint256 accountBalance = _balances[account];\r\n        require(accountBalance \u003e= amount, \"ERC20: burn amount exceeds balance\");\r\n        unchecked {\r\n            _balances[account] = accountBalance - amount;\r\n            // Overflow not possible: amount \u003c= accountBalance \u003c= totalSupply.\r\n            _totalSupply -= amount;\r\n        }\r\n\r\n        emit Transfer(account, address(0), amount);\r\n\r\n        _afterTokenTransfer(account, address(0), amount);\r\n    }\r\n\r\n    /**\r\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\r\n     *\r\n     * This internal function is equivalent to `approve`, and can be used to\r\n     * e.g. set automatic allowances for certain subsystems, etc.\r\n     *\r\n     * Emits an {Approval} event.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `owner` cannot be the zero address.\r\n     * - `spender` cannot be the zero address.\r\n     */\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    /**\r\n     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.\r\n     *\r\n     * Does not update the allowance amount in case of infinite allowance.\r\n     * Revert if not enough allowance is available.\r\n     *\r\n     * Might emit an {Approval} event.\r\n     */\r\n    function _spendAllowance(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        uint256 currentAllowance = allowance(owner, spender);\r\n        if (currentAllowance != type(uint256).max) {\r\n            require(currentAllowance \u003e= amount, \"ERC20: insufficient allowance\");\r\n            unchecked {\r\n                _approve(owner, spender, currentAllowance - amount);\r\n            }\r\n        }\r\n    }\r\n\r\n    /**\r\n     * @dev Hook that is called before any transfer of tokens. This includes\r\n     * minting and burning.\r\n     *\r\n     * Calling conditions:\r\n     *\r\n     * - when `from` and `to` are both non-zero, `amount` of ``from``\u0027s tokens\r\n     * will be transferred to `to`.\r\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\r\n     * - when `to` is zero, `amount` of ``from``\u0027s tokens will be burned.\r\n     * - `from` and `to` are never both zero.\r\n     *\r\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\r\n     */\r\n    function _beforeTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n\r\n    /**\r\n     * @dev Hook that is called after any transfer of tokens. This includes\r\n     * minting and burning.\r\n     *\r\n     * Calling conditions:\r\n     *\r\n     * - when `from` and `to` are both non-zero, `amount` of ``from``\u0027s tokens\r\n     * has been transferred to `to`.\r\n     * - when `from` is zero, `amount` tokens have been minted for `to`.\r\n     * - when `to` is zero, `amount` of ``from``\u0027s tokens have been burned.\r\n     * - `from` and `to` are never both zero.\r\n     *\r\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\r\n     */\r\n    function _afterTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n}"},"IERC20.sol":{"content":"// SPDX-License-Identifier: MIT\r\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\r\n\r\npragma solidity ^0.8.0;\r\n\r\n/**\r\n * @dev Interface of the ERC20 standard as defined in the EIP.\r\n */\r\ninterface IERC20 {\r\n    /**\r\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\r\n     * another (`to`).\r\n     *\r\n     * Note that `value` may be zero.\r\n     */\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    /**\r\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\r\n     * a call to {approve}. `value` is the new allowance.\r\n     */\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n\r\n    /**\r\n     * @dev Returns the amount of tokens in existence.\r\n     */\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Returns the amount of tokens owned by `account`.\r\n     */\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from the caller\u0027s account to `to`.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transfer(address to, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Returns the remaining number of tokens that `spender` will be\r\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\r\n     * zero by default.\r\n     *\r\n     * This value changes when {approve} or {transferFrom} are called.\r\n     */\r\n    function allowance(address owner, address spender) external view returns (uint256);\r\n\r\n    /**\r\n     * @dev Sets `amount` as the allowance of `spender` over the caller\u0027s tokens.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\r\n     * that someone may use both the old and the new allowance by unfortunate\r\n     * transaction ordering. One possible solution to mitigate this race\r\n     * condition is to first reduce the spender\u0027s allowance to 0 and set the\r\n     * desired value afterwards:\r\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\r\n     *\r\n     * Emits an {Approval} event.\r\n     */\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    /**\r\n     * @dev Moves `amount` tokens from `from` to `to` using the\r\n     * allowance mechanism. `amount` is then deducted from the caller\u0027s\r\n     * allowance.\r\n     *\r\n     * Returns a boolean value indicating whether the operation succeeded.\r\n     *\r\n     * Emits a {Transfer} event.\r\n     */\r\n    function transferFrom(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n}"},"IERC20Metadata.sol":{"content":"// SPDX-License-Identifier: MIT\r\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)\r\n\r\npragma solidity ^0.8.0;\r\n\r\nimport \"../IERC20.sol\";\r\n\r\n/**\r\n * @dev Interface for the optional metadata functions from the ERC20 standard.\r\n *\r\n * _Available since v4.1._\r\n */\r\ninterface IERC20Metadata is IERC20 {\r\n    /**\r\n     * @dev Returns the name of the token.\r\n     */\r\n    function name() external view returns (string memory);\r\n\r\n    /**\r\n     * @dev Returns the symbol of the token.\r\n     */\r\n    function symbol() external view returns (string memory);\r\n\r\n    /**\r\n     * @dev Returns the decimals places of the token.\r\n     */\r\n    function decimals() external view returns (uint8);\r\n}"},"Token.sol":{"content":"//SPDX-License-Identifier: Unlicense\r\npragma solidity ^0.8.0;\r\n\r\nimport \"./ERC20.sol\";\r\n\r\ncontract SCOOTtoken is ERC20 {\r\n    uint constant _initial_supply = 920690000000000 * (10**18);\r\n    constructor() ERC20(\"Scoot\", \"SCOOT\") {\r\n        _mint(msg.sender, _initial_supply);\r\n    }\r\n}"}}