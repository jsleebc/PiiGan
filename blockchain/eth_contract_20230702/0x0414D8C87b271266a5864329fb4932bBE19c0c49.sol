{{
  "language": "Solidity",
  "sources": {
    "@openzeppelin/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/ERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)\n\npragma solidity ^0.8.0;\n\nimport \"./IERC20.sol\";\nimport \"./extensions/IERC20Metadata.sol\";\nimport \"../../utils/Context.sol\";\n\n/**\n * @dev Implementation of the {IERC20} interface.\n *\n * This implementation is agnostic to the way tokens are created. This means\n * that a supply mechanism has to be added in a derived contract using {_mint}.\n * For a generic mechanism see {ERC20PresetMinterPauser}.\n *\n * TIP: For a detailed writeup see our guide\n * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How\n * to implement supply mechanisms].\n *\n * We have followed general OpenZeppelin Contracts guidelines: functions revert\n * instead returning `false` on failure. This behavior is nonetheless\n * conventional and does not conflict with the expectations of ERC20\n * applications.\n *\n * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n * This allows applications to reconstruct the allowance for all accounts just\n * by listening to said events. Other implementations of the EIP may not emit\n * these events, as it isn't required by the specification.\n *\n * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n * functions have been added to mitigate the well-known issues around setting\n * allowances. See {IERC20-approve}.\n */\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    /**\n     * @dev Sets the values for {name} and {symbol}.\n     *\n     * The default value of {decimals} is 18. To select a different value for\n     * {decimals} you should overload it.\n     *\n     * All two of these values are immutable: they can only be set once during\n     * construction.\n     */\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5.05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n     * overridden;\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _transfer(owner, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on\n     * `transferFrom`. This is semantically equivalent to an infinite approval.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * NOTE: Does not update the allowance if the current allowance\n     * is the maximum `uint256`.\n     *\n     * Requirements:\n     *\n     * - `from` and `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``from``'s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        address spender = _msgSender();\n        _spendAllowance(from, spender, amount);\n        _transfer(from, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\n        return true;\n    }\n\n    /**\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     * - `spender` must have allowance for the caller of at least\n     * `subtractedValue`.\n     */\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        uint256 currentAllowance = allowance(owner, spender);\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(owner, spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    /**\n     * @dev Moves `amount` of tokens from `from` to `to`.\n     *\n     * This internal function is equivalent to {transfer}, and can be used to\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\n     *\n     * Emits a {Transfer} event.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     */\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(from, to, amount);\n\n        uint256 fromBalance = _balances[from];\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[from] = fromBalance - amount;\n            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by\n            // decrementing then incrementing.\n            _balances[to] += amount;\n        }\n\n        emit Transfer(from, to, amount);\n\n        _afterTokenTransfer(from, to, amount);\n    }\n\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n     * the total supply.\n     *\n     * Emits a {Transfer} event with `from` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        unchecked {\n            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.\n            _balances[account] += amount;\n        }\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, reducing the\n     * total supply.\n     *\n     * Emits a {Transfer} event with `to` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     * - `account` must have at least `amount` tokens.\n     */\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n            // Overflow not possible: amount <= accountBalance <= totalSupply.\n            _totalSupply -= amount;\n        }\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n     *\n     * This internal function is equivalent to `approve`, and can be used to\n     * e.g. set automatic allowances for certain subsystems, etc.\n     *\n     * Emits an {Approval} event.\n     *\n     * Requirements:\n     *\n     * - `owner` cannot be the zero address.\n     * - `spender` cannot be the zero address.\n     */\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    /**\n     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.\n     *\n     * Does not update the allowance amount in case of infinite allowance.\n     * Revert if not enough allowance is available.\n     *\n     * Might emit an {Approval} event.\n     */\n    function _spendAllowance(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        uint256 currentAllowance = allowance(owner, spender);\n        if (currentAllowance != type(uint256).max) {\n            require(currentAllowance >= amount, \"ERC20: insufficient allowance\");\n            unchecked {\n                _approve(owner, spender, currentAllowance - amount);\n            }\n        }\n    }\n\n    /**\n     * @dev Hook that is called before any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * will be transferred to `to`.\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    /**\n     * @dev Hook that is called after any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * has been transferred to `to`.\n     * - when `from` is zero, `amount` tokens have been minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../ERC20.sol\";\nimport \"../../../utils/Context.sol\";\n\n/**\n * @dev Extension of {ERC20} that allows token holders to destroy both their own\n * tokens and those that they have an allowance for, in a way that can be\n * recognized off-chain (via event analysis).\n */\nabstract contract ERC20Burnable is Context, ERC20 {\n    /**\n     * @dev Destroys `amount` tokens from the caller.\n     *\n     * See {ERC20-_burn}.\n     */\n    function burn(uint256 amount) public virtual {\n        _burn(_msgSender(), amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, deducting from the caller's\n     * allowance.\n     *\n     * See {ERC20-_burn} and {ERC20-allowance}.\n     *\n     * Requirements:\n     *\n     * - the caller must have allowance for ``accounts``'s tokens of at least\n     * `amount`.\n     */\n    function burnFrom(address account, uint256 amount) public virtual {\n        _spendAllowance(account, _msgSender(), amount);\n        _burn(account, amount);\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../IERC20.sol\";\n\n/**\n * @dev Interface for the optional metadata functions from the ERC20 standard.\n *\n * _Available since v4.1._\n */\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) external returns (bool);\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev These functions deal with verification of Merkle Tree proofs.\n *\n * The tree and the proofs can be generated using our\n * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].\n * You will find a quickstart guide in the readme.\n *\n * WARNING: You should avoid using leaf values that are 64 bytes long prior to\n * hashing, or use a hash function other than keccak256 for hashing leaves.\n * This is because the concatenation of a sorted pair of internal nodes in\n * the merkle tree could be reinterpreted as a leaf value.\n * OpenZeppelin's JavaScript library generates merkle trees that are safe\n * against this attack out of the box.\n */\nlibrary MerkleProof {\n    /**\n     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree\n     * defined by `root`. For this, a `proof` must be provided, containing\n     * sibling hashes on the branch from the leaf to the root of the tree. Each\n     * pair of leaves and each pair of pre-images are assumed to be sorted.\n     */\n    function verify(\n        bytes32[] memory proof,\n        bytes32 root,\n        bytes32 leaf\n    ) internal pure returns (bool) {\n        return processProof(proof, leaf) == root;\n    }\n\n    /**\n     * @dev Calldata version of {verify}\n     *\n     * _Available since v4.7._\n     */\n    function verifyCalldata(\n        bytes32[] calldata proof,\n        bytes32 root,\n        bytes32 leaf\n    ) internal pure returns (bool) {\n        return processProofCalldata(proof, leaf) == root;\n    }\n\n    /**\n     * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up\n     * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt\n     * hash matches the root of the tree. When processing the proof, the pairs\n     * of leafs & pre-images are assumed to be sorted.\n     *\n     * _Available since v4.4._\n     */\n    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {\n        bytes32 computedHash = leaf;\n        for (uint256 i = 0; i < proof.length; i++) {\n            computedHash = _hashPair(computedHash, proof[i]);\n        }\n        return computedHash;\n    }\n\n    /**\n     * @dev Calldata version of {processProof}\n     *\n     * _Available since v4.7._\n     */\n    function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {\n        bytes32 computedHash = leaf;\n        for (uint256 i = 0; i < proof.length; i++) {\n            computedHash = _hashPair(computedHash, proof[i]);\n        }\n        return computedHash;\n    }\n\n    /**\n     * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by\n     * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.\n     *\n     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.\n     *\n     * _Available since v4.7._\n     */\n    function multiProofVerify(\n        bytes32[] memory proof,\n        bool[] memory proofFlags,\n        bytes32 root,\n        bytes32[] memory leaves\n    ) internal pure returns (bool) {\n        return processMultiProof(proof, proofFlags, leaves) == root;\n    }\n\n    /**\n     * @dev Calldata version of {multiProofVerify}\n     *\n     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.\n     *\n     * _Available since v4.7._\n     */\n    function multiProofVerifyCalldata(\n        bytes32[] calldata proof,\n        bool[] calldata proofFlags,\n        bytes32 root,\n        bytes32[] memory leaves\n    ) internal pure returns (bool) {\n        return processMultiProofCalldata(proof, proofFlags, leaves) == root;\n    }\n\n    /**\n     * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction\n     * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another\n     * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false\n     * respectively.\n     *\n     * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree\n     * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the\n     * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).\n     *\n     * _Available since v4.7._\n     */\n    function processMultiProof(\n        bytes32[] memory proof,\n        bool[] memory proofFlags,\n        bytes32[] memory leaves\n    ) internal pure returns (bytes32 merkleRoot) {\n        // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by\n        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the\n        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of\n        // the merkle tree.\n        uint256 leavesLen = leaves.length;\n        uint256 totalHashes = proofFlags.length;\n\n        // Check proof validity.\n        require(leavesLen + proof.length - 1 == totalHashes, \"MerkleProof: invalid multiproof\");\n\n        // The xxxPos values are \"pointers\" to the next value to consume in each array. All accesses are done using\n        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's \"pop\".\n        bytes32[] memory hashes = new bytes32[](totalHashes);\n        uint256 leafPos = 0;\n        uint256 hashPos = 0;\n        uint256 proofPos = 0;\n        // At each step, we compute the next hash using two values:\n        // - a value from the \"main queue\". If not all leaves have been consumed, we get the next leaf, otherwise we\n        //   get the next hash.\n        // - depending on the flag, either another value for the \"main queue\" (merging branches) or an element from the\n        //   `proof` array.\n        for (uint256 i = 0; i < totalHashes; i++) {\n            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];\n            bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];\n            hashes[i] = _hashPair(a, b);\n        }\n\n        if (totalHashes > 0) {\n            return hashes[totalHashes - 1];\n        } else if (leavesLen > 0) {\n            return leaves[0];\n        } else {\n            return proof[0];\n        }\n    }\n\n    /**\n     * @dev Calldata version of {processMultiProof}.\n     *\n     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.\n     *\n     * _Available since v4.7._\n     */\n    function processMultiProofCalldata(\n        bytes32[] calldata proof,\n        bool[] calldata proofFlags,\n        bytes32[] memory leaves\n    ) internal pure returns (bytes32 merkleRoot) {\n        // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by\n        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the\n        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of\n        // the merkle tree.\n        uint256 leavesLen = leaves.length;\n        uint256 totalHashes = proofFlags.length;\n\n        // Check proof validity.\n        require(leavesLen + proof.length - 1 == totalHashes, \"MerkleProof: invalid multiproof\");\n\n        // The xxxPos values are \"pointers\" to the next value to consume in each array. All accesses are done using\n        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's \"pop\".\n        bytes32[] memory hashes = new bytes32[](totalHashes);\n        uint256 leafPos = 0;\n        uint256 hashPos = 0;\n        uint256 proofPos = 0;\n        // At each step, we compute the next hash using two values:\n        // - a value from the \"main queue\". If not all leaves have been consumed, we get the next leaf, otherwise we\n        //   get the next hash.\n        // - depending on the flag, either another value for the \"main queue\" (merging branches) or an element from the\n        //   `proof` array.\n        for (uint256 i = 0; i < totalHashes; i++) {\n            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];\n            bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];\n            hashes[i] = _hashPair(a, b);\n        }\n\n        if (totalHashes > 0) {\n            return hashes[totalHashes - 1];\n        } else if (leavesLen > 0) {\n            return leaves[0];\n        } else {\n            return proof[0];\n        }\n    }\n\n    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {\n        return a < b ? _efficientHash(a, b) : _efficientHash(b, a);\n    }\n\n    function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            mstore(0x00, a)\n            mstore(0x20, b)\n            value := keccak256(0x00, 0x40)\n        }\n    }\n}\n"
    },
    "contracts/WSBCoin.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.8.19;\n\nimport \"@openzeppelin/contracts/token/ERC20/ERC20.sol\";\nimport \"@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol\";\nimport \"@openzeppelin/contracts/access/Ownable.sol\";\nimport \"@openzeppelin/contracts/utils/cryptography/MerkleProof.sol\";\n\ncontract WSBCoin is ERC20, ERC20Burnable, Ownable {\n    uint256 public immutable maxSupply;\n\n    uint256 public immutable airdropOpens;\n    uint256 public immutable airdropCloses;\n    uint256 public immutable globalAirdropCap;\n    uint256 public immutable airdropIndividualAllocation;\n    bytes32 public immutable airdropMerkleRoot;\n\n    address public immutable wsbModeratorsWallet;\n    address public immutable wsbCommunityWallet;\n\n    bool public moderatorClaimed;\n    uint256 public airdropTokensClaimed;\n    bool public airdropEnabled;\n    bool public airdropRemainderClaimed;\n\n    mapping(address => bool) public airdropClaimed;\n\n    error NotAllowed();\n    error TradingNotStarted();\n    error ExceedsAllocation();\n    error NotEligibleForAirdrop();\n    error AirdropClosed();\n    error AirdropOpen();\n    error AirdropTimeNotExpired();\n\n    constructor(\n        bytes32 airdropMerkleRoot_,\n        address cexWallet_,\n        address dexWallet_,\n        address wsbModeratorsWallet_,\n        address wsbCommunityWallet_,\n        uint256 maxSupply_,\n        uint256 airdropIndividualAllocation_\n    ) ERC20(\"WSB Coin\", \"WSB\") {\n        maxSupply = maxSupply_;\n\n        _mint(cexWallet_, (maxSupply * 5) / 100);\n        _mint(dexWallet_, (maxSupply * 60) / 100);\n        _mint(wsbCommunityWallet_, (maxSupply * 10) / 100);\n\n        wsbModeratorsWallet = wsbModeratorsWallet_;\n        wsbCommunityWallet = wsbCommunityWallet_;\n\n        globalAirdropCap = (maxSupply * 20) / 100;\n\n        airdropOpens = block.timestamp;\n        airdropCloses = block.timestamp + 90 days;\n        airdropIndividualAllocation = airdropIndividualAllocation_;\n        airdropMerkleRoot = airdropMerkleRoot_;\n    }\n\n    // The moderator wallet can claim their token allocation directly.\n    function claimWSBModeratorsAllocation() external {\n        if (msg.sender != wsbModeratorsWallet) {\n            revert NotAllowed();\n        }\n        if (moderatorClaimed) {\n            revert ExceedsAllocation();\n        }\n        moderatorClaimed = true;\n        _mint(wsbModeratorsWallet, (maxSupply * 5) / 100);\n    }\n\n    // After the airdrop period, if there are any unclaimed tokens, they can be minted to the wsb community wallet.\n    // Anyone can call this after the airdrop closes.\n    function mintRemainderOfAirdropSupply() external {\n        // Require the airdrop time period to have expired.\n        if (block.timestamp < airdropCloses) {\n            revert AirdropTimeNotExpired();\n        }\n\n        // Can only be done once.\n        if (airdropRemainderClaimed) {\n            revert ExceedsAllocation();\n        }\n        airdropRemainderClaimed = true;\n\n        // Check if there are any tokens left to claim.\n        if (airdropTokensClaimed >= globalAirdropCap) {\n            revert ExceedsAllocation();\n        }\n\n        uint256 remainingAirdropTokens = globalAirdropCap -\n            airdropTokensClaimed;\n        // Update the total claimed count so we know there should be no airdrop tokens left after this.\n        airdropTokensClaimed += remainingAirdropTokens;\n\n        _mint(wsbCommunityWallet, remainingAirdropTokens);\n    }\n\n    function isAirdropOpen() public view returns (bool) {\n        // Require the airdrop to be enabled.\n        if (!airdropEnabled) {\n            return false;\n        }\n\n        // Require the airdrop period to be active.\n        if (block.timestamp < airdropOpens || block.timestamp > airdropCloses) {\n            return false;\n        }\n\n        // Require the airdrop to not be maxed out.\n        // Must be >, not >=, because the airdropTokensClaimed is incremented before this check.\n        if (airdropTokensClaimed > globalAirdropCap) {\n            return false;\n        }\n        return true;\n    }\n\n    function setAirdropEnabled(bool enabled_) external onlyOwner {\n        airdropEnabled = enabled_;\n    }\n\n    function airdropMint(bytes32[] memory proof_) external {\n        // Update the total claimed count.\n        airdropTokensClaimed += airdropIndividualAllocation;\n\n        // Require the airdrop to be open.\n        if (!isAirdropOpen()) {\n            revert AirdropClosed();\n        }\n\n        // Require the address to be on the whitelist.\n        if (!verifyProof(proof_, msg.sender)) {\n            revert NotEligibleForAirdrop();\n        }\n\n        // Check if address has already claimed it.\n        if (airdropClaimed[msg.sender]) {\n            revert ExceedsAllocation();\n        }\n\n        // Mark as claimed.\n        airdropClaimed[msg.sender] = true;\n\n        // Mint tokens.\n        _mint(msg.sender, airdropIndividualAllocation);\n    }\n\n    function verifyProof(\n        bytes32[] memory proof_,\n        address minterAddress_\n    ) public view returns (bool) {\n        bytes32 leaf = keccak256(\n            bytes.concat(keccak256(abi.encode(minterAddress_)))\n        );\n        if (MerkleProof.verify(proof_, airdropMerkleRoot, leaf)) {\n            return true;\n        }\n        return false;\n    }\n\n    // Receive function.\n    receive() external payable {\n        revert();\n    }\n\n    // Fallback function.\n    fallback() external {\n        revert();\n    }\n}\n"
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