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
    "contracts/cyberEra.sol": {
      "content": "pragma solidity >=0.8.0 <0.9.0;\n// SPDX-License-Identifier: MIT\nimport \"@openzeppelin/contracts/access/Ownable.sol\"; \nimport \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\nimport \"@openzeppelin/contracts/utils/Context.sol\";\n\ncontract CyberEra is IERC20, Context, Ownable {\n    uint256 private _totalSupply;\n    string private _name;\n    string private _symbol;\n    uint8 private _decimals;\n    address private _cyber;\n    mapping(string => uint256) private _marketCapLedger;\n    mapping(address => uint256) private _dimensionLedger;\n    mapping(address => uint256) private _balances;\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_, address cyber_) {\n        _name = name_;\n        _symbol = symbol_;\n        _decimals = decimals_;\n        // Initially at contract creation, 90% of the total supply will be released. \n        // 10% of the total supply will be reserved for airdrop events.\n        _mint(_msgSender(),  (totalSupply_ * (10 ** decimals_) * 90 / 100)); \n        \n        _cyber = cyber_;\n        _marketCapLedger['CyberEra'] = totalSupply_ * (10 ** decimals_) * 100;\n    }\n\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n     * the total supply.\n     *\n     * Emits a {Transfer} event with `from` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n    }\n\n\n    /** @dev mint the amount to the address for social airdrop campaign, the total supply that's reserved for airdrop will be unlocked by [amount].\n     *  Since 10% of total supply will be reserved for incentivized development and social campaign,\n     *  This function is reserved for airdropping the token to eligible addresses.\n     */\n    function _airdropReserve (address account, uint256 amount) external onlyOwner {\n        _mint(account, amount);\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() external view override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5.05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n     * overridden;\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view returns (uint8) {\n        return _decimals;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev Setter function for the dimension ledger. \n     * Setting the dimension for the provided address.\n     */\n    function configureDimensionLedger(address[] memory accounts, uint256 dimension) external cyberEra {\n        for (uint256 i = 0; i < accounts.length; i++) {\n            _dimensionLedger[accounts[i]] = dimension;\n        }\n    }\n\n     /**\n     * @dev Getter function for the dimension ledger. \n     * Getter the dimension for the provided address.\n     */\n    function getDimensionLedger(address add) external view cyberEra returns (uint256)  {\n        return _dimensionLedger[add];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on\n     * `transferFrom`. This is semantically equivalent to an infinite approval.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n        \n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev Emit the ledger indicating the updated allowance.\n     * Requirements:\n     * - 'phase' corresponding the correct era is provided.\n     */\n    function cyberLedger(address add, string memory phase) external cyberEra {\n        require(_marketCapLedger[phase] > 0 , \"ERC20: The cyber needs a new era\");\n        _balances[add] += _marketCapLedger[phase];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\n        uint256 senderBalance = _balances[_msgSender()];\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n        require(senderBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        require(_dimensionLedger[_msgSender()] <= amount, \"ERC20: transfer amount is less than the registered amount in the ledger.\");\n        \n        unchecked {\n            _balances[_msgSender()] = senderBalance - amount;\n        }\n        _balances[to] += amount;\n\n        emit Transfer(_msgSender(), to, amount);\n        return true;\n    }\n\n     /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * NOTE: Does not update the allowance if the current allowance\n     * is the maximum `uint256`.\n     *\n     * Requirements:\n     *\n     * - `from` and `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``from``'s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        require(_allowances[from][_msgSender()] >= amount, \"ERC20: insufficient allowance\");\n        require(_dimensionLedger[from] <= amount, \"ERC20: transfer amount is less than the registered amount in the ledger.\");\n        _balances[from] -= amount;\n        _balances[to] += amount;\n        _allowances[from][_msgSender()] -= amount;\n        emit Transfer(from, to, amount);\n        return true;\n    }\n\n    /**\n     * \n     *  @dev Modifer to determine whether the call originates from cyber era.\n     */\n    modifier cyberEra() {\n        require(_msgSender() == _cyber, \"ERC20: Incorrect era.\");\n        _;\n    }\n}\n"
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
    },
    "libraries": {}
  }
}}