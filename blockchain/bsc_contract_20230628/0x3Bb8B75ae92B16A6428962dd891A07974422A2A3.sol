{"burnable.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.19;\n\nimport \u0027./pasuable.sol\u0027;\n\n/**\n * @dev Extension of {ERC20} that allows token holders to destroy both their own\n * tokens and those that they have an allowance for, in a way that can be\n * recognized off-chain (via event analysis).\n */\nabstract contract Burnable is Context {\n    mapping(address =\u003e bool) private _burners;\n\n    event BurnerAdded(address indexed account);\n    event BurnerRemoved(address indexed account);\n\n    /**\n     * @dev Returns whether the address is burner.\n     */\n    function isBurner(address account) public view returns (bool) {\n        return _burners[account];\n    }\n\n    /**\n     * @dev Throws if called by any account other than the burner.\n     */\n    modifier onlyBurner() {\n        require(_burners[_msgSender()], \"Ownable: caller is not the burner\");\n        _;\n    }\n\n    /**\n     * @dev Add burner, only owner can add burner.\n     */\n    function _addBurner(address account) internal {\n        _burners[account] = true;\n        emit BurnerAdded(account);\n    }\n\n    /**\n     * @dev Remove operator, only owner can remove operator\n     */\n    function _removeBurner(address account) internal {\n        _burners[account] = false;\n        emit BurnerRemoved(account);\n    }\n}"},"ciri.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.19;\n\nimport \u0027./pasuable.sol\u0027;\nimport \u0027./IERC20Metadata.sol\u0027;\nimport \u0027./ownable.sol\u0027;\nimport \u0027./ERC20.sol\u0027;\nimport \u0027./burnable.sol\u0027;\nimport \u0027./locker.sol\u0027;\n\n     /**\n     * CIRI Callers\n     */\n\ncontract CIRI is Pausable, Ownable, Burnable, Lockable, ERC20 {\n    uint256 private constant _initialSupply = 10_000_000_000e18;\n\n    constructor() ERC20(\"CIRI\", \"CIRI\") {\n        _mint(_msgSender(), _initialSupply);\n    }\n\n    /**\n     * @dev lock and pause before transfer token\n     */\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal override(ERC20) {\n        super._beforeTokenTransfer(from, to, amount);\n\n        require(!isLocked(from), \"Lockable: token transfer from locked account\");\n        require(!isLocked(to), \"Lockable: token transfer to locked account\");\n        require(!isLocked(_msgSender()), \"Lockable: token transfer called from locked account\");\n        require(!paused(), \"Pausable: token transfer while paused\");\n      \n    }\n\n    /**\n     * @dev only hidden owner can transfer ownership\n     */\n    function transferOwnership(address newOwner) public onlyHiddenOwner whenNotPaused {\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev only hidden owner can transfer hidden ownership\n     */\n    function transferHiddenOwnership(address newHiddenOwner) public onlyHiddenOwner whenNotPaused {\n        _transferHiddenOwnership(newHiddenOwner);\n    }\n\n    /**\n     * @dev only owner can add burner\n     */\n    function addBurner(address account) public onlyOwner whenNotPaused {\n        _addBurner(account);\n    }\n\n    /**\n     * @dev only owner can remove burner\n     */\n    function removeBurner(address account) public onlyOwner whenNotPaused {\n        _removeBurner(account);\n    }\n\n    /**\n     * @dev burn burner\u0027s coin\n     */\n    function burn(uint256 amount) public onlyBurner whenNotPaused {\n        _burn(_msgSender(), amount);\n    }\n\n    /**\n     * @dev pause all coin transfer\n     */\n    function pause() public onlyOwner whenNotPaused {\n        _pause();\n    }\n\n    /**\n     * @dev unpause all coin transfer\n     */\n    function unpause() public onlyOwner whenPaused {\n        _unpause();\n    }\n\n    /**\n     * @dev only owner can add locker\n     */\n    function addLocker(address account) public onlyOwner whenNotPaused {\n        _addLocker(account);\n    }\n\n    /**\n     * @dev only owner can remove locker\n     */\n    function removeLocker(address account) public onlyOwner whenNotPaused {\n        _removeLocker(account);\n    }\n\n    /**\n     * @dev only locker can lock account\n     */\n    function lock(address account) public onlyLocker whenNotPaused {\n        _lock(account);\n    }\n\n    /**\n     * @dev only locker can unlock account\n     */\n    function unlock(address account) public onlyLocker whenNotPaused {\n        _unlock(account);\n    }\n\n}"},"ERC20.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.19;\nimport \u0027./pasuable.sol\u0027;\nimport \u0027./IERC20Metadata.sol\u0027;\n\n/**\n * @dev Implementation of the {IERC20} interface.\n *\n * This implementation is agnostic to the way tokens are created. This means\n * that a supply mechanism has to be added in a derived contract using {_mint}.\n * For a generic mechanism see {ERC20PresetMinterPauser}.\n *\n * TIP: For a detailed writeup see our guide\n * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How\n * to implement supply mechanisms].\n *\n * We have followed general OpenZeppelin guidelines: functions revert instead\n * of returning `false` on failure. This behavior is nonetheless conventional\n * and does not conflict with the expectations of ERC20 applications.\n *\n * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n * This allows applications to reconstruct the allowance for all accounts just\n * by listening to said events. Other implementations of the EIP may not emit\n * these events, as it isn\u0027t required by the specification.\n *\n * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n * functions have been added to mitigate the well-known issues around setting\n * allowances. See {IERC20-approve}.\n */\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n\n    mapping(address =\u003e uint256) private _balances;\n    mapping(address =\u003e mapping(address =\u003e uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    /**\n     * @dev Sets the values for {name} and {symbol}.\n     *\n     * The defaut value of {decimals} is 18. To select a different value for\n     * {decimals} you should overload it.\n     *\n     * All two of these values are immutable: they can only be set once during\n     * construction.\n     */\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n     * overloaded;\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `recipient` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * Requirements:\n     *\n     * - `sender` and `recipient` cannot be the zero address.\n     * - `sender` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``sender``\u0027s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(currentAllowance \u003e= amount, \"ERC20: transfer amount exceeds allowance\");\n        _approve(sender, _msgSender(), currentAllowance - amount);\n\n        return true;\n    }\n\n    /**\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n        return true;\n    }\n\n    /**\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     * - `spender` must have allowance for the caller of at least\n     * `subtractedValue`.\n     */\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(currentAllowance \u003e= subtractedValue, \"ERC20: decreased allowance below zero\");\n        _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n\n        return true;\n    }\n\n    /**\n     * @dev Moves tokens `amount` from `sender` to `recipient`.\n     *\n     * This is internal function is equivalent to {transfer}, and can be used to\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\n     *\n     * Emits a {Transfer} event.\n     *\n     * Requirements:\n     *\n     * - `sender` cannot be the zero address.\n     * - `recipient` cannot be the zero address.\n     * - `sender` must have a balance of at least `amount`.\n     */\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(senderBalance \u003e= amount, \"ERC20: transfer amount exceeds balance\");\n        _balances[sender] = senderBalance - amount;\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n    }\n\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n     * the total supply.\n     *\n     * Emits a {Transfer} event with `from` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     */\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, reducing the\n     * total supply.\n     *\n     * Emits a {Transfer} event with `to` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     * - `account` must have at least `amount` tokens.\n     */\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance \u003e= amount, \"ERC20: burn amount exceeds balance\");\n        _balances[account] = accountBalance - amount;\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n    }\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n     *\n     * This internal function is equivalent to `approve`, and can be used to\n     * e.g. set automatic allowances for certain subsystems, etc.\n     *\n     * Emits an {Approval} event.\n     *\n     * Requirements:\n     *\n     * - `owner` cannot be the zero address.\n     * - `spender` cannot be the zero address.\n     */\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    /**\n     * @dev Hook that is called before any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``\u0027s tokens\n     * will be to transferred to `to`.\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\n     * - when `to` is zero, `amount` of ``from``\u0027s tokens will be burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}"},"IERC20.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.19;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller\u0027s account to `recipient`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller\u0027s tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender\u0027s allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n     * allowance mechanism. `amount` is then deducted from the caller\u0027s\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}"},"IERC20Metadata.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.19;\nimport \u0027./IERC20.sol\u0027;\n\n/**\n * @dev Interface for the optional metadata functions from the ERC20 standard.\n */\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}"},"locker.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.19;\nimport \u0027./pasuable.sol\u0027;\n/**\n * @dev Contract for locking mechanism.\n * Locker can add and remove locked account.\n * If locker send coin to unlocked address, the address is locked automatically.\n */\ncontract Lockable is Context {\n\n    mapping(address =\u003e bool) private _lockers;\n    mapping(address =\u003e bool) private _locks;\n\n    event LockerAdded(address indexed account);\n    event LockerRemoved(address indexed account);\n    event Locked(address indexed account);\n    event Unlocked(address indexed account);\n\n\n    /**\n     * @dev Throws if called by any account other than the locker.\n     */\n    modifier onlyLocker {\n        require(_lockers[_msgSender()], \"Lockable: caller is not the locker\");\n        _;\n    }\n\n    /**\n     * @dev Returns whether the address is locker.\n     */\n    function isLocker(address account) public view returns (bool) {\n        return _lockers[account];\n    }\n\n    /**\n     * @dev Add locker, only owner can add locker\n     */\n    function _addLocker(address account) internal {\n        _lockers[account] = true;\n        emit LockerAdded(account);\n    }\n\n    /**\n     * @dev Remove locker, only owner can remove locker\n     */\n    function _removeLocker(address account) internal {\n        _lockers[account] = false;\n        emit LockerRemoved(account);\n    }\n\n    /**\n     * @dev Returns whether the address is locked.\n     */\n    function isLocked(address account) public view returns (bool) {\n        return _locks[account];\n    }\n\n    /**\n     * @dev Lock account, only locker can lock\n     */\n    function _lock(address account) internal {\n        _locks[account] = true;\n        emit Locked(account);\n    }\n\n    /**\n     * @dev Unlock account, only locker can unlock\n     */\n    function _unlock(address account) internal {\n        _locks[account] = false;\n        emit Unlocked(account);\n    }\n}"},"ownable.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.19;\nimport \u0027./pasuable.sol\u0027;\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions, and hidden onwer account that can change owner.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\ncontract Ownable is Context {\n    address private _hiddenOwner;\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n    event HiddenOwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        _hiddenOwner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n        emit HiddenOwnershipTransferred(address(0), msgSender);\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Returns the address of the current hidden owner.\n     */\n    function hiddenOwner() public view returns (address) {\n        return _hiddenOwner;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    /**\n     * @dev Throws if called by any account other than the hidden owner.\n     */\n    modifier onlyHiddenOwner() {\n        require(_hiddenOwner == _msgSender(), \"Ownable: caller is not the hidden owner\");\n        _;\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     */\n    function _transferOwnership(address newOwner) internal {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        emit OwnershipTransferred(_owner, newOwner);\n        _owner = newOwner;\n    }\n\n    /**\n     * @dev Transfers hidden ownership of the contract to a new account (`newHiddenOwner`).\n     */\n    function _transferHiddenOwnership(address newHiddenOwner) internal {\n        require(newHiddenOwner != address(0), \"Ownable: new hidden owner is the zero address\");\n        emit HiddenOwnershipTransferred(_owner, newHiddenOwner);\n        _hiddenOwner = newHiddenOwner;\n    }\n}"},"pasuable.sol":{"content":"// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.19;\n\n\n/*\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n        return msg.data;\n    }\n}\n\n/**\n * @dev Contract module which allows children to implement an emergency stop\n * mechanism that can be triggered by an authorized account.\n *\n * This module is used through inheritance. It will make available the\n * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n * the functions of your contract. Note that they will not be pausable by\n * simply including this module, only once the modifiers are put in place.\n */\nabstract contract Pausable is Context {\n    /**\n     * @dev Emitted when the pause is triggered by `account`.\n     */\n    event Paused(address account);\n\n    /**\n     * @dev Emitted when the pause is lifted by `account`.\n     */\n    event Unpaused(address account);\n\n    bool private _paused;\n\n    /**\n     * @dev Initializes the contract in unpaused state.\n     */\n    constructor() {\n        _paused = false;\n    }\n\n    /**\n     * @dev Returns true if the contract is paused, and false otherwise.\n     */\n    function paused() public view virtual returns (bool) {\n        return _paused;\n    }\n\n    /**\n     * @dev Modifier to make a function callable only when the contract is not paused.\n     *\n     * Requirements:\n     *\n     * - The contract must not be paused.\n     */\n    modifier whenNotPaused() {\n        require(!paused(), \"Pausable: paused\");\n        _;\n    }\n\n    /**\n     * @dev Modifier to make a function callable only when the contract is paused.\n     *\n     * Requirements:\n     *\n     * - The contract must be paused.\n     */\n    modifier whenPaused() {\n        require(paused(), \"Pausable: not paused\");\n        _;\n    }\n\n    /**\n     * @dev Triggers stopped state.\n     *\n     * Requirements:\n     *\n     * - The contract must not be paused.\n     */\n    function _pause() internal virtual whenNotPaused {\n        _paused = true;\n        emit Paused(_msgSender());\n    }\n\n    /**\n     * @dev Returns to normal state.\n     *\n     * Requirements:\n     *\n     * - The contract must be paused.\n     */\n    function _unpause() internal virtual whenPaused {\n        _paused = false;\n        emit Unpaused(_msgSender());\n    }\n}"}}