{{
  "language": "Solidity",
  "sources": {
    "@openzeppelin/contracts/token/ERC20/ERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)\n\npragma solidity ^0.8.0;\n\nimport \"./IERC20.sol\";\nimport \"./extensions/IERC20Metadata.sol\";\nimport \"../../utils/Context.sol\";\n\n/**\n * @dev Implementation of the {IERC20} interface.\n *\n * This implementation is agnostic to the way tokens are created. This means\n * that a supply mechanism has to be added in a derived contract using {_mint}.\n * For a generic mechanism see {ERC20PresetMinterPauser}.\n *\n * TIP: For a detailed writeup see our guide\n * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How\n * to implement supply mechanisms].\n *\n * The default value of {decimals} is 18. To change this, you should override\n * this function so it returns a different value.\n *\n * We have followed general OpenZeppelin Contracts guidelines: functions revert\n * instead returning `false` on failure. This behavior is nonetheless\n * conventional and does not conflict with the expectations of ERC20\n * applications.\n *\n * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n * This allows applications to reconstruct the allowance for all accounts just\n * by listening to said events. Other implementations of the EIP may not emit\n * these events, as it isn't required by the specification.\n *\n * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n * functions have been added to mitigate the well-known issues around setting\n * allowances. See {IERC20-approve}.\n */\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    /**\n     * @dev Sets the values for {name} and {symbol}.\n     *\n     * All two of these values are immutable: they can only be set once during\n     * construction.\n     */\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5.05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the default value returned by this function, unless\n     * it's overridden.\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _transfer(owner, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on\n     * `transferFrom`. This is semantically equivalent to an infinite approval.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * NOTE: Does not update the allowance if the current allowance\n     * is the maximum `uint256`.\n     *\n     * Requirements:\n     *\n     * - `from` and `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``from``'s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {\n        address spender = _msgSender();\n        _spendAllowance(from, spender, amount);\n        _transfer(from, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\n        return true;\n    }\n\n    /**\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     * - `spender` must have allowance for the caller of at least\n     * `subtractedValue`.\n     */\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        uint256 currentAllowance = allowance(owner, spender);\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(owner, spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    /**\n     * @dev Moves `amount` of tokens from `from` to `to`.\n     *\n     * This internal function is equivalent to {transfer}, and can be used to\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\n     *\n     * Emits a {Transfer} event.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     */\n    function _transfer(address from, address to, uint256 amount) internal virtual {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(from, to, amount);\n\n        uint256 fromBalance = _balances[from];\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[from] = fromBalance - amount;\n            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by\n            // decrementing then incrementing.\n            _balances[to] += amount;\n        }\n\n        emit Transfer(from, to, amount);\n\n        _afterTokenTransfer(from, to, amount);\n    }\n\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n     * the total supply.\n     *\n     * Emits a {Transfer} event with `from` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        unchecked {\n            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.\n            _balances[account] += amount;\n        }\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, reducing the\n     * total supply.\n     *\n     * Emits a {Transfer} event with `to` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     * - `account` must have at least `amount` tokens.\n     */\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n            // Overflow not possible: amount <= accountBalance <= totalSupply.\n            _totalSupply -= amount;\n        }\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n     *\n     * This internal function is equivalent to `approve`, and can be used to\n     * e.g. set automatic allowances for certain subsystems, etc.\n     *\n     * Emits an {Approval} event.\n     *\n     * Requirements:\n     *\n     * - `owner` cannot be the zero address.\n     * - `spender` cannot be the zero address.\n     */\n    function _approve(address owner, address spender, uint256 amount) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    /**\n     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.\n     *\n     * Does not update the allowance amount in case of infinite allowance.\n     * Revert if not enough allowance is available.\n     *\n     * Might emit an {Approval} event.\n     */\n    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {\n        uint256 currentAllowance = allowance(owner, spender);\n        if (currentAllowance != type(uint256).max) {\n            require(currentAllowance >= amount, \"ERC20: insufficient allowance\");\n            unchecked {\n                _approve(owner, spender, currentAllowance - amount);\n            }\n        }\n    }\n\n    /**\n     * @dev Hook that is called before any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * will be transferred to `to`.\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}\n\n    /**\n     * @dev Hook that is called after any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * has been transferred to `to`.\n     * - when `from` is zero, `amount` tokens have been minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../IERC20.sol\";\n\n/**\n * @dev Interface for the optional metadata functions from the ERC20 standard.\n *\n * _Available since v4.1._\n */\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "contracts/Inscription.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nimport \"@openzeppelin/contracts/token/ERC20/ERC20.sol\";\nimport \"./Logarithm.sol\";\nimport \"./TransferHelper.sol\";\n\n// This is common token interface, get balance of owner's token by ERC20/ERC721/ERC1155.\ninterface ICommonToken {\n    function balanceOf(address owner) external returns(uint256);\n}\n\n// This contract is extended from ERC20\ncontract Inscription is ERC20 {\n    using Logarithm for int256;\n    uint256 public cap;                 // Max amount\n    uint256 public limitPerMint;        // Limitaion of each mint\n    uint256 public inscriptionId;       // Inscription Id\n    uint256 public maxMintSize;         // max mint size, that means the max mint quantity is: maxMintSize * limitPerMint\n    uint256 public freezeTime;          // The frozen time (interval) between two mints is a fixed number of seconds. You can mint, but you will need to pay an additional mint fee, and this fee will be double for each mint.\n    address public onlyContractAddress; // Only addresses that hold these assets can mint\n    uint256 public onlyMinQuantity;     // Only addresses that the quantity of assets hold more than this amount can mint\n    uint256 public baseFee;             // base fee of the second mint after frozen interval. The first mint after frozen time is free.\n    uint256 public fundingCommission;   // commission rate of fund raising, 100 means 1%\n    uint256 public crowdFundingRate;    // rate of crowdfunding\n    address payable public crowdfundingAddress; // receiving fee of crowdfunding\n    address payable public inscriptionFactory;\n\n    mapping(address => uint256) public lastMintTimestamp;   // record the last mint timestamp of account\n    mapping(address => uint256) public lastMintFee;           // record the last mint fee\n\n    constructor(\n        string memory _name,            // token name\n        string memory _tick,            // token tick, same as symbol. must be 4 characters.\n        uint256 _cap,                   // Max amount\n        uint256 _limitPerMint,          // Limitaion of each mint\n        uint256 _inscriptionId,         // Inscription Id\n        uint256 _maxMintSize,           // max mint size, that means the max mint quantity is: maxMintSize * limitPerMint. This is only availabe for non-frozen time token.\n        uint256 _freezeTime,            // The frozen time (interval) between two mints is a fixed number of seconds. You can mint, but you will need to pay an additional mint fee, and this fee will be double for each mint.\n        address _onlyContractAddress,   // Only addresses that hold these assets can mint\n        uint256 _onlyMinQuantity,       // Only addresses that the quantity of assets hold more than this amount can mint\n        uint256 _baseFee,               // base fee of the second mint after frozen interval. The first mint after frozen time is free.\n        uint256 _fundingCommission,     // commission rate of fund raising, 100 means 1%\n        uint256 _crowdFundingRate,      // rate of crowdfunding\n        address payable _crowdFundingAddress,   // receiving fee of crowdfunding\n        address payable _inscriptionFactory\n    ) ERC20(_name, _tick) {\n        require(_cap >= _limitPerMint, \"Limit per mint exceed cap\");\n        cap = _cap;\n        limitPerMint = _limitPerMint;\n        inscriptionId = _inscriptionId;\n        maxMintSize = _maxMintSize;\n        freezeTime = _freezeTime;\n        onlyContractAddress = _onlyContractAddress;\n        onlyMinQuantity = _onlyMinQuantity;\n        baseFee = _baseFee;\n        fundingCommission = _fundingCommission;\n        crowdFundingRate = _crowdFundingRate;\n        crowdfundingAddress = _crowdFundingAddress;\n        inscriptionFactory = _inscriptionFactory;\n    }\n\n    function mint(address _to) payable public {\n        // Check if the quantity after mint will exceed the cap\n        require(totalSupply() + limitPerMint <= cap, \"Touched cap\");\n        // Check if the assets in the msg.sender is satisfied\n        require(onlyContractAddress == address(0x0) || ICommonToken(onlyContractAddress).balanceOf(msg.sender) >= onlyMinQuantity, \"You don't have required assets\");\n\n        if(lastMintTimestamp[msg.sender] + freezeTime > block.timestamp) {\n            // The min extra tip is double of last mint fee\n            lastMintFee[msg.sender] = lastMintFee[msg.sender] == 0 ? baseFee : lastMintFee[msg.sender] * 2;\n            // Transfer the fee to the crowdfunding address\n            if(crowdFundingRate > 0) {\n                // Check if the tip is high than the min extra fee\n                require(msg.value >= crowdFundingRate + lastMintFee[msg.sender], \"Send some ETH as fee and crowdfunding\");\n                _dispatchFunding(crowdFundingRate);\n            }\n            // Transfer the tip to InscriptionFactory smart contract\n            if(msg.value - crowdFundingRate > 0) TransferHelper.safeTransferETH(inscriptionFactory, msg.value - crowdFundingRate);\n        } else {\n            // Transfer the fee to the crowdfunding address\n            if(crowdFundingRate > 0) {\n                require(msg.value >= crowdFundingRate, \"Send some ETH as crowdfunding\");\n                _dispatchFunding(msg.value);\n            }\n            // Out of frozen time, free mint. Reset the timestamp and mint times.\n            lastMintFee[msg.sender] = 0;\n            lastMintTimestamp[msg.sender] = block.timestamp;\n        }\n        // Do mint\n        _mint(_to, limitPerMint);\n    }\n\n    // batch mint is only available for non-frozen-time tokens\n    function batchMint(address _to, uint256 _num) payable public {\n        require(_num <= maxMintSize, \"exceed max mint size\");\n        require(totalSupply() + _num * limitPerMint <= cap, \"Touch cap\");\n        require(freezeTime == 0, \"Batch mint only for non-frozen token\");\n        require(onlyContractAddress == address(0x0) || ICommonToken(onlyContractAddress).balanceOf(msg.sender) >= onlyMinQuantity, \"You don't have required assets\");\n        if(crowdFundingRate > 0) {\n            require(msg.value >= crowdFundingRate * _num, \"Crowdfunding ETH not enough\");\n            _dispatchFunding(msg.value);\n        }\n        for(uint256 i = 0; i < _num; i++) _mint(_to, limitPerMint);\n    }\n\n    function getMintFee(address _addr) public view returns(uint256 mintedTimes, uint256 nextMintFee) {\n        if(lastMintTimestamp[_addr] + freezeTime > block.timestamp) {\n            int256 scale = 1e18;\n            int256 halfScale = 5e17;\n            // times = log_2(lastMintFee / baseFee) + 1 (if lastMintFee > 0)\n            nextMintFee = lastMintFee[_addr] == 0 ? baseFee : lastMintFee[_addr] * 2;\n            mintedTimes = uint256((Logarithm.log2(int256(nextMintFee / baseFee) * scale, scale, halfScale) + 1) / scale) + 1;\n        }\n    }\n\n    function _dispatchFunding(uint256 _amount) private {\n        uint256 commission = _amount * fundingCommission / 10000;\n        TransferHelper.safeTransferETH(crowdfundingAddress, _amount - commission);\n        if(commission > 0) TransferHelper.safeTransferETH(inscriptionFactory, commission);\n    }\n}\n"
    },
    "contracts/Logarithm.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nlibrary Logarithm {\n    /// @notice Finds the zero-based index of the first one in the binary representation of x.\n    /// @dev See the note on msb in the \"Find First Set\" Wikipedia article https://en.wikipedia.org/wiki/Find_first_set\n    /// @param x The uint256 number for which to find the index of the most significant bit.\n    /// @return msb The index of the most significant bit as an uint256.\n    function mostSignificantBit(uint256 x) internal pure returns (uint256 msb) {\n        if (x >= 2**128) {\n            x >>= 128;\n            msb += 128;\n        }\n        if (x >= 2**64) {\n            x >>= 64;\n            msb += 64;\n        }\n        if (x >= 2**32) {\n            x >>= 32;\n            msb += 32;\n        }\n        if (x >= 2**16) {\n            x >>= 16;\n            msb += 16;\n        }\n        if (x >= 2**8) {\n            x >>= 8;\n            msb += 8;\n        }\n        if (x >= 2**4) {\n            x >>= 4;\n            msb += 4;\n        }\n        if (x >= 2**2) {\n            x >>= 2;\n            msb += 2;\n        }\n        if (x >= 2**1) {\n            // No need to shift x any more.\n            msb += 1;\n        }\n    }\n    /// @notice Calculates the binary logarithm of x.\n    ///\n    /// @dev Based on the iterative approximation algorithm.\n    /// https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation\n    ///\n    /// Requirements:\n    /// - x must be greater than zero.\n    ///\n    /// Caveats:\n    /// - The results are nor perfectly accurate to the last digit, due to the lossy precision of the iterative approximation.\n    ///\n    /// @param x The signed 59.18-decimal fixed-point number for which to calculate the binary logarithm.\n    /// @return result The binary logarithm as a signed 59.18-decimal fixed-point number.\n    function log2(int256 x, int256 scale, int256 halfScale) internal pure returns (int256 result) {\n        require(x > 0);\n        unchecked {\n            // This works because log2(x) = -log2(1/x).\n            int256 sign;\n            if (x >= scale) {\n                sign = 1;\n            } else {\n                sign = -1;\n                // Do the fixed-point inversion inline to save gas. The numerator is SCALE * SCALE.\n                assembly {\n                    x := div(1000000000000000000000000000000000000, x)\n                }\n            }\n\n            // Calculate the integer part of the logarithm and add it to the result and finally calculate y = x * 2^(-n).\n            uint256 n = mostSignificantBit(uint256(x / scale));\n\n            // The integer part of the logarithm as a signed 59.18-decimal fixed-point number. The operation can't overflow\n            // because n is maximum 255, SCALE is 1e18 and sign is either 1 or -1.\n            result = int256(n) * scale;\n\n            // This is y = x * 2^(-n).\n            int256 y = x >> n;\n\n            // If y = 1, the fractional part is zero.\n            if (y == scale) {\n                return result * sign;\n            }\n\n            // Calculate the fractional part via the iterative approximation.\n            // The \"delta >>= 1\" part is equivalent to \"delta /= 2\", but shifting bits is faster.\n            for (int256 delta = int256(halfScale); delta > 0; delta >>= 1) {\n                y = (y * y) / scale;\n\n                // Is y^2 > 2 and so in the range [2,4)?\n                if (y >= 2 * scale) {\n                    // Add the 2^(-m) factor to the logarithm.\n                    result += delta;\n\n                    // Corresponds to z/2 on Wikipedia.\n                    y >>= 1;\n                }\n            }\n            result *= sign;\n        }\n    }\n}"
    },
    "contracts/TransferHelper.sol": {
      "content": "// SPDX-License-Identifier: GPL-3.0-or-later\n\npragma solidity >=0.6.0;\n\n// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\nlibrary TransferHelper {\n    function safeApprove(\n        address token,\n        address to,\n        uint256 value\n    ) internal {\n        // bytes4(keccak256(bytes('approve(address,uint256)')));\n        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n        require(\n            success && (data.length == 0 || abi.decode(data, (bool))),\n            'TransferHelper::safeApprove: approve failed'\n        );\n    }\n\n    function safeTransfer(\n        address token,\n        address to,\n        uint256 value\n    ) internal {\n        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n        require(\n            success && (data.length == 0 || abi.decode(data, (bool))),\n            'TransferHelper::safeTransfer: transfer failed'\n        );\n    }\n\n    function safeTransferFrom(\n        address token,\n        address from,\n        address to,\n        uint256 value\n    ) internal {\n        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n        require(\n            success && (data.length == 0 || abi.decode(data, (bool))),\n            'TransferHelper::transferFrom: transferFrom failed'\n        );\n    }\n\n    function safeTransferETH(address to, uint256 value) internal {\n        (bool success, ) = to.call{value: value}(new bytes(0));\n        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');\n    }\n}"
    }
  },
  "settings": {
    "viaIR": true,
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