{{
  "language": "Solidity",
  "sources": {
    "contracts/RewardTokens.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\nimport \"./NonTransferableToken.sol\";\r\nimport \"./BRRRToken.sol\";\r\nimport \"./sBRRRToken.sol\";\r\n\r\ncontract BANKToken is NonTransferableToken {\r\n    uint256 public constant MINT_COST_BRRR = 200_000 * (10 ** 18);\r\n    uint256 public constant DAILY_AMOUNT = 50000 * (10 ** 18);\r\n    uint256 public constant MAX_REWARDS = 395971 * (10 ** 18);\r\n\r\n    BRRRToken private _brrrToken;\r\n    sBRRRToken private _sBrrrToken;\r\n    address private _w1;\r\n\r\n    mapping(address => uint256[]) public _userStartTime;\r\n    mapping(address => uint256) private _claimedRewards;\r\n\r\n    constructor(BRRRToken brrrToken, sBRRRToken sBrrrToken, address w1) NonTransferableToken(\"BANK Token\", \"BANK\") {\r\n        _brrrToken = brrrToken;\r\n        _sBrrrToken = sBrrrToken;\r\n        _w1 = w1;\r\n    }\r\n\r\n    function mint() external {\r\n        _brrrToken.transferFrom(msg.sender, _w1, MINT_COST_BRRR);\r\n        _mint(msg.sender, 1);\r\n        _userStartTime[msg.sender].push(block.timestamp);\r\n    }\r\n\r\n    function getUserStartTimes(address user) public view returns (uint256[] memory) {\r\n        return _userStartTime[user];\r\n    }\r\n\r\n\r\n    function CalculateRewards(uint256 userStartTime) public view returns (uint256) {\r\n        uint256 timePassed = block.timestamp - userStartTime;\r\n        uint256 daysPassed = timePassed / 1 days;\r\n\r\n        uint256 rewards = 0;\r\n        uint256 dailyReward = DAILY_AMOUNT;\r\n\r\n        for (uint256 i = 0; i < daysPassed; i++) {\r\n            rewards += dailyReward;\r\n            dailyReward = dailyReward * 9 / 10; // Decrease dailyReward by 10%\r\n        }\r\n\r\n        uint256 remainingSeconds = timePassed % 1 days;\r\n        uint256 currentDayReward = dailyReward * remainingSeconds / 86400;\r\n        rewards += currentDayReward;\r\n\r\n        if (rewards > MAX_REWARDS) {\r\n            rewards = MAX_REWARDS;\r\n        }\r\n\r\n        return rewards;\r\n    }\r\n\r\n    function calculateTotalRewards(address user) public view returns (uint256) {\r\n        uint256[] memory userStartTimes = _userStartTime[user];\r\n        uint256 totalRewards = 0;\r\n\r\n        for (uint256 i = 0; i < userStartTimes.length; i++) {\r\n            totalRewards += CalculateRewards(userStartTimes[i]);\r\n        }\r\n\r\n        return totalRewards;\r\n    }\r\n\r\n    function calculateUnclaimedRewards(address user) public view returns (uint256) {\r\n        uint256 totalRewards = calculateTotalRewards(user);\r\n        uint256 unclaimedRewards = totalRewards - _claimedRewards[user];\r\n\r\n        return unclaimedRewards;\r\n    }\r\n\r\n    function claimRewards() external {\r\n        uint256 unclaimedRewards = calculateUnclaimedRewards(msg.sender);\r\n        require(unclaimedRewards > 0, \"No rewards to claim\");\r\n\r\n        _claimedRewards[msg.sender] += unclaimedRewards;\r\n        _sBrrrToken.mint(msg.sender, unclaimedRewards);\r\n    }\r\n}\r\n\r\ncontract CBANKToken is NonTransferableToken {\r\n    uint256 public constant MINT_COST_BRRR = 1_000_000 * (10 ** 18);\r\n    uint256 public constant MINT_COST_SBRRR = 1_000_000 * (10 ** 18);\r\n    uint256 public constant DAILY_AMOUNT = 500_000 * (10 ** 18);\r\n    uint256 public constant MAX_REWARDS = 7_563_386 * (10 ** 18);\r\n\r\n    BRRRToken private _brrrToken;\r\n    sBRRRToken private _sBrrrToken;\r\n    address private _w1;\r\n\r\n    mapping(address => uint256[]) public _userStartTime;\r\n    mapping(address => uint256) private _claimedRewards;\r\n\r\n    constructor(BRRRToken brrrToken, sBRRRToken sBrrrToken, address w1) NonTransferableToken(\"BANK Token\", \"BANK\") {\r\n        _brrrToken = brrrToken;\r\n        _sBrrrToken = sBrrrToken;\r\n        _w1 = w1;\r\n    }\r\n\r\n    function mint() external {\r\n        _brrrToken.transferFrom(msg.sender, _w1, MINT_COST_BRRR);\r\n        _sBrrrToken.transferFrom(msg.sender, _w1, MINT_COST_SBRRR);\r\n        _mint(msg.sender, 1);\r\n        _userStartTime[msg.sender].push(block.timestamp);\r\n    }\r\n\r\n    function getUserStartTimes(address user) public view returns (uint256[] memory) {\r\n        return _userStartTime[user];\r\n    }\r\n\r\n    function CalculateRewards(uint256 userStartTime) public view returns (uint256) {\r\n        uint256 timePassed = block.timestamp - userStartTime;\r\n        uint256 daysPassed = timePassed / 1 days;\r\n\r\n        uint256 rewards = 0;\r\n        uint256 dailyReward = DAILY_AMOUNT;\r\n\r\n        for (uint256 i = 0; i < daysPassed; i++) {\r\n            rewards += dailyReward;\r\n            dailyReward = dailyReward * 95 / 100; // Decrease dailyReward by 5%\r\n        }\r\n\r\n        uint256 remainingSeconds = timePassed % 1 days;\r\n        uint256 currentDayReward = dailyReward * remainingSeconds / 86400;\r\n        rewards += currentDayReward;\r\n\r\n        if (rewards > MAX_REWARDS) {\r\n            rewards = MAX_REWARDS;\r\n        }\r\n\r\n        return rewards;\r\n    }\r\n\r\n    function calculateTotalRewards(address user) public view returns (uint256) {\r\n        uint256[] memory userStartTimes = _userStartTime[user];\r\n        uint256 totalRewards = 0;\r\n\r\n        for (uint256 i = 0; i < userStartTimes.length; i++) {\r\n            totalRewards += CalculateRewards(userStartTimes[i]);\r\n        }\r\n\r\n        return totalRewards;\r\n    }\r\n\r\n    function calculateUnclaimedRewards(address user) public view returns (uint256) {\r\n        uint256 totalRewards = calculateTotalRewards(user);\r\n        uint256 unclaimedRewards = totalRewards - _claimedRewards[user];\r\n\r\n        return unclaimedRewards;\r\n    }\r\n\r\n    function claimRewards() external {\r\n        uint256 unclaimedRewards = calculateUnclaimedRewards(msg.sender);\r\n        require(unclaimedRewards > 0, \"No rewards to claim\");\r\n\r\n        _claimedRewards[msg.sender] += unclaimedRewards;\r\n        _sBrrrToken.mint(msg.sender, unclaimedRewards);\r\n    }\r\n}\r\n\r\ncontract PRINTERToken is NonTransferableToken {\r\n    uint256 public constant MINT_COST_BRRR = 10_000_000 * (10 ** 18);\r\n    uint256 public constant MINT_COST_SBRRR = 10_000_000 * (10 ** 18);\r\n    uint256 public constant DAILY_AMOUNT = 1_111_111 * (10 ** 18);\r\n    uint256 public constant MAX_REWARDS = 100_000_000 * (10 ** 18);\r\n    uint256 public constant MAX_TOKENS_PER_WALLET = 1;\r\n\r\n    BRRRToken private _brrrToken;\r\n    sBRRRToken private _sBrrrToken;\r\n    address private _w1;\r\n\r\n    mapping(address => uint256[]) public _userStartTime;\r\n    mapping(address => uint256) private _claimedRewards;\r\n    mapping(address => uint256) private _tokensMinted;\r\n\r\n    constructor(BRRRToken brrrToken, sBRRRToken sBrrrToken, address w1) NonTransferableToken(\"BANK Token\", \"BANK\") {\r\n        _brrrToken = brrrToken;\r\n        _sBrrrToken = sBrrrToken;\r\n        _w1 = w1;\r\n    }\r\n\r\n    function mint() external {\r\n        require(_tokensMinted[msg.sender] < MAX_TOKENS_PER_WALLET, \"Max tokens per wallet reached\");\r\n        _brrrToken.transferFrom(msg.sender, _w1, MINT_COST_BRRR);\r\n        _sBrrrToken.transferFrom(msg.sender, _w1, MINT_COST_SBRRR);\r\n        _mint(msg.sender, 1);\r\n        _userStartTime[msg.sender].push(block.timestamp);\r\n        _tokensMinted[msg.sender] += 1;\r\n    }\r\n\r\n    function getUserStartTimes(address user) public view returns (uint256[] memory) {\r\n        return _userStartTime[user];\r\n    }\r\n\r\n    function CalculateRewards(uint256 userStartTime) public view returns (uint256) {\r\n        uint256 timePassed = block.timestamp - userStartTime;\r\n        uint256 daysPassed = timePassed / 1 days;\r\n\r\n        uint256 rewards = 0;\r\n        uint256 dailyReward = DAILY_AMOUNT;\r\n\r\n        for (uint256 i = 0; i < daysPassed; i++) {\r\n            rewards += dailyReward;\r\n        }\r\n\r\n        uint256 remainingSeconds = timePassed % 1 days;\r\n        uint256 currentDayReward = dailyReward * remainingSeconds / 86400;\r\n        rewards += currentDayReward;\r\n\r\n        if (rewards > MAX_REWARDS) {\r\n            rewards = MAX_REWARDS;\r\n        }\r\n\r\n        return rewards;\r\n    }\r\n\r\n    function calculateTotalRewards(address user) public view returns (uint256) {\r\n        uint256[] memory userStartTimes = _userStartTime[user];\r\n        uint256 totalRewards = 0;\r\n\r\n        for (uint256 i = 0; i < userStartTimes.length; i++) {\r\n            totalRewards += CalculateRewards(userStartTimes[i]);\r\n        }\r\n\r\n        return totalRewards;\r\n    }\r\n\r\n    function calculateUnclaimedRewards(address user) public view returns (uint256) {\r\n        uint256 totalRewards = calculateTotalRewards(user);\r\n        uint256 unclaimedRewards = totalRewards - _claimedRewards[user];\r\n\r\n        return unclaimedRewards;\r\n    }\r\n\r\n    function claimRewards() external {\r\n        uint256 unclaimedRewards = calculateUnclaimedRewards(msg.sender);\r\n        require(unclaimedRewards > 0, \"No rewards to claim\");\r\n\r\n        _claimedRewards[msg.sender] += unclaimedRewards;\r\n        _sBrrrToken.mint(msg.sender, unclaimedRewards);\r\n    }\r\n}"
    },
    "contracts/sBRRRToken.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\nimport \"@openzeppelin/contracts/token/ERC20/ERC20.sol\";\r\nimport \"./BRRRToken.sol\";\r\n\r\ncontract sBRRRToken is ERC20 {\r\n    uint256 private constant BURN_RATE = 25; // 25% burn rate\r\n    uint256 private constant CONVERSION_MAX_PERIOD = 24 * 60 * 60; // 24 hours in seconds\r\n\r\n    BRRRToken private _brrrToken;\r\n    mapping(address => bool) private _minters;\r\n\r\n    address private _bankAddress;\r\n    address private _cbankAddress;\r\n    address private _printerAddress;\r\n\r\n    struct Conversion {\r\n        uint256 amount;\r\n        uint256 timestamp;\r\n    }\r\n\r\n    mapping(address => Conversion[]) public conversionRecords;\r\n\r\n    constructor(BRRRToken brrrToken) ERC20(\"Staked BRRR Token\", \"sBRRR\") { //TEMPORARY PARAM ADDRESS\r\n        _brrrToken = brrrToken;\r\n        _minters[msg.sender] = true; // Grant minting permission to the contract deployer\r\n    }\r\n\r\n    function setTokenAddresses(address bankAddress, address cbankAddress, address printerAddress) external onlyMinter {\r\n        _bankAddress = bankAddress;\r\n        _cbankAddress = cbankAddress;\r\n        _printerAddress = printerAddress;\r\n        _minters[bankAddress] = true;\r\n        _minters[cbankAddress] = true;\r\n        _minters[printerAddress] = true;\r\n    }\r\n\r\n    modifier onlyMinter() {\r\n        require(_minters[msg.sender], \"Only minters can call this function\");\r\n        _;\r\n    }\r\n\r\n    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {\r\n        uint256 burnAmount = (amount * BURN_RATE) / 100;\r\n        uint256 transferAmount = amount - burnAmount;\r\n\r\n        super._transfer(sender, recipient, transferAmount);\r\n        super._burn(sender, burnAmount);\r\n    }\r\n\r\n    function _eraseExpiredConversions(address account) private {\r\n        uint256 i = 0;\r\n        while (i < conversionRecords[account].length) {\r\n            if (block.timestamp - conversionRecords[account][i].timestamp > CONVERSION_MAX_PERIOD) {\r\n                // Remove expired conversion record by shifting all elements to the left\r\n                for (uint256 j = i; j < conversionRecords[account].length - 1; j++) {\r\n                    conversionRecords[account][j] = conversionRecords[account][j + 1];\r\n                }\r\n                conversionRecords[account].pop(); // Remove last element after shifting\r\n            } else {\r\n                i++; // Only increment if the current record is not expired\r\n            }\r\n        }\r\n    }\r\n\r\n    function convertToBRRR(uint256 sBRRRAmount) external {\r\n        require(sBRRRAmount <= getCurrentConversionMax(msg.sender), \"Conversion exceeds maximum allowed in 24-hour period\");\r\n\r\n        uint256 brrrAmount = (sBRRRAmount * (100 - BURN_RATE)) / 100;\r\n        _burn(msg.sender, sBRRRAmount);\r\n        _brrrToken.mint(msg.sender, brrrAmount);\r\n\r\n        Conversion memory newConversion = Conversion({\r\n            amount: sBRRRAmount,\r\n            timestamp: block.timestamp\r\n        });\r\n\r\n        conversionRecords[msg.sender].push(newConversion);\r\n        _eraseExpiredConversions(msg.sender); // Erase expired conversions for the user\r\n    }\r\n\r\n    function getConversionMax(address account) public view returns (uint256) {\r\n        uint256 bankBalance = ERC20(_bankAddress).balanceOf(account);\r\n        uint256 cbankBalance = ERC20(_cbankAddress).balanceOf(account);\r\n        uint256 printerBalance = ERC20(_printerAddress).balanceOf(account);\r\n        return (50000 * 10**18 * bankBalance) + (500000 * 10**18 * cbankBalance) + (1000000 * 10**18 * printerBalance);\r\n    }\r\n\r\n    function getCurrentConversionMax(address account) public view returns (uint256) {\r\n        uint256 conversionMax = getConversionMax(account);\r\n        uint256 sumOfConversions = 0;\r\n\r\n        for (uint256 i = 0; i < conversionRecords[account].length; i++) {\r\n            if ((block.timestamp - conversionRecords[account][i].timestamp) <= CONVERSION_MAX_PERIOD) {\r\n                sumOfConversions += conversionRecords[account][i].amount;\r\n            }\r\n        }\r\n        if (sumOfConversions >= conversionMax) {\r\n            return 0;\r\n        } else {\r\n            return conversionMax - sumOfConversions;\r\n        }\r\n    }\r\n\r\n    function mint(address account, uint256 amount) external onlyMinter {\r\n        _mint(account, amount);\r\n    }\r\n}"
    },
    "contracts/BRRRToken.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nimport \"@openzeppelin/contracts/token/ERC20/ERC20.sol\";\n\ncontract BRRRToken is ERC20 {\n    uint256 private constant INITIAL_SUPPLY = 100_000_000 * (10 ** 18); // 100 million tokens\n    uint256 private constant SPECIAL_RULE_DURATION = 24 hours;\n    uint256 private constant MAX_BALANCE_PERCENT = 5; // 0.5% of total supply\n    uint256 private constant MAX_TX_AMOUNT_PERCENT = 1; // 0.1% of total supply\n\n    uint256 private _deploymentTimestamp;\n    address private _sBRRRContract;\n    address private _w1;\n\n    constructor(address wallet) ERC20(\"BRRR Token\", \"BRRR\") {\n        _deploymentTimestamp = block.timestamp;\n        _w1 = wallet;\n        _mint(wallet, INITIAL_SUPPLY);\n    }\n\n    modifier onlySBRRR() {\n        require(msg.sender == _sBRRRContract, \"Only the sBRRR contract can call this function\");\n        _;\n    }\n\n    function setSBRRRContract(address sBRRRContract) external {\n        require(_sBRRRContract == address(0), \"sBRRR contract address has already been set\");\n        _sBRRRContract = sBRRRContract;\n    }\n\n    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {\n        if (block.timestamp < _deploymentTimestamp + SPECIAL_RULE_DURATION && sender != _w1 && recipient != _w1) {\n            require(\n                balanceOf(recipient) + amount <= (INITIAL_SUPPLY * MAX_BALANCE_PERCENT) / 1000,\n                \"New balance cannot exceed 0.5% of the total supply during the first 24 hours\"\n            );\n\n            require(\n                amount <= (INITIAL_SUPPLY * MAX_TX_AMOUNT_PERCENT) / 1000,\n                \"Transaction amount cannot exceed 0.1% of the total supply during the first 24 hours\"\n            );\n        }\n\n        super._transfer(sender, recipient, amount);\n    }\n\n    function mint(address account, uint256 amount) external onlySBRRR {\n        _mint(account, amount);\n    }\n}\n"
    },
    "contracts/NonTransferableToken.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.0;\r\n\r\nimport \"@openzeppelin/contracts/token/ERC20/ERC20.sol\";\r\n\r\ncontract NonTransferableToken is ERC20 {\r\n    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}\r\n\r\n    function transfer(address, uint256) public pure override returns (bool) {\r\n        revert(\"NonTransferableToken: transfer not allowed\");\r\n    }\r\n\r\n    function transferFrom(address, address, uint256) public pure override returns (bool) {\r\n        revert(\"NonTransferableToken: transferFrom not allowed\");\r\n    }\r\n\r\n    function approve(address, uint256) public pure override returns (bool) {\r\n        revert(\"NonTransferableToken: approve not allowed\");\r\n    }\r\n}"
    },
    "@openzeppelin/contracts/token/ERC20/ERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)\n\npragma solidity ^0.8.0;\n\nimport \"./IERC20.sol\";\nimport \"./extensions/IERC20Metadata.sol\";\nimport \"../../utils/Context.sol\";\n\n/**\n * @dev Implementation of the {IERC20} interface.\n *\n * This implementation is agnostic to the way tokens are created. This means\n * that a supply mechanism has to be added in a derived contract using {_mint}.\n * For a generic mechanism see {ERC20PresetMinterPauser}.\n *\n * TIP: For a detailed writeup see our guide\n * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How\n * to implement supply mechanisms].\n *\n * We have followed general OpenZeppelin Contracts guidelines: functions revert\n * instead returning `false` on failure. This behavior is nonetheless\n * conventional and does not conflict with the expectations of ERC20\n * applications.\n *\n * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n * This allows applications to reconstruct the allowance for all accounts just\n * by listening to said events. Other implementations of the EIP may not emit\n * these events, as it isn't required by the specification.\n *\n * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n * functions have been added to mitigate the well-known issues around setting\n * allowances. See {IERC20-approve}.\n */\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) private _balances;\n\n    mapping(address => mapping(address => uint256)) private _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    /**\n     * @dev Sets the values for {name} and {symbol}.\n     *\n     * The default value of {decimals} is 18. To select a different value for\n     * {decimals} you should overload it.\n     *\n     * All two of these values are immutable: they can only be set once during\n     * construction.\n     */\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    /**\n     * @dev Returns the symbol of the token, usually a shorter version of the\n     * name.\n     */\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    /**\n     * @dev Returns the number of decimals used to get its user representation.\n     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n     * be displayed to a user as `5.05` (`505 / 10 ** 2`).\n     *\n     * Tokens usually opt for a value of 18, imitating the relationship between\n     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n     * overridden;\n     *\n     * NOTE: This information is only used for _display_ purposes: it in\n     * no way affects any of the arithmetic of the contract, including\n     * {IERC20-balanceOf} and {IERC20-transfer}.\n     */\n    function decimals() public view virtual override returns (uint8) {\n        return 18;\n    }\n\n    /**\n     * @dev See {IERC20-totalSupply}.\n     */\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    /**\n     * @dev See {IERC20-balanceOf}.\n     */\n    function balanceOf(address account) public view virtual override returns (uint256) {\n        return _balances[account];\n    }\n\n    /**\n     * @dev See {IERC20-transfer}.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     * - the caller must have a balance of at least `amount`.\n     */\n    function transfer(address to, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _transfer(owner, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-allowance}.\n     */\n    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n\n    /**\n     * @dev See {IERC20-approve}.\n     *\n     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on\n     * `transferFrom`. This is semantically equivalent to an infinite approval.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, amount);\n        return true;\n    }\n\n    /**\n     * @dev See {IERC20-transferFrom}.\n     *\n     * Emits an {Approval} event indicating the updated allowance. This is not\n     * required by the EIP. See the note at the beginning of {ERC20}.\n     *\n     * NOTE: Does not update the allowance if the current allowance\n     * is the maximum `uint256`.\n     *\n     * Requirements:\n     *\n     * - `from` and `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     * - the caller must have allowance for ``from``'s tokens of at least\n     * `amount`.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        address spender = _msgSender();\n        _spendAllowance(from, spender, amount);\n        _transfer(from, to, amount);\n        return true;\n    }\n\n    /**\n     * @dev Atomically increases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     */\n    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        _approve(owner, spender, allowance(owner, spender) + addedValue);\n        return true;\n    }\n\n    /**\n     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n     *\n     * This is an alternative to {approve} that can be used as a mitigation for\n     * problems described in {IERC20-approve}.\n     *\n     * Emits an {Approval} event indicating the updated allowance.\n     *\n     * Requirements:\n     *\n     * - `spender` cannot be the zero address.\n     * - `spender` must have allowance for the caller of at least\n     * `subtractedValue`.\n     */\n    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n        address owner = _msgSender();\n        uint256 currentAllowance = allowance(owner, spender);\n        require(currentAllowance >= subtractedValue, \"ERC20: decreased allowance below zero\");\n        unchecked {\n            _approve(owner, spender, currentAllowance - subtractedValue);\n        }\n\n        return true;\n    }\n\n    /**\n     * @dev Moves `amount` of tokens from `from` to `to`.\n     *\n     * This internal function is equivalent to {transfer}, and can be used to\n     * e.g. implement automatic token fees, slashing mechanisms, etc.\n     *\n     * Emits a {Transfer} event.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `from` must have a balance of at least `amount`.\n     */\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {\n        require(from != address(0), \"ERC20: transfer from the zero address\");\n        require(to != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(from, to, amount);\n\n        uint256 fromBalance = _balances[from];\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\n        unchecked {\n            _balances[from] = fromBalance - amount;\n            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by\n            // decrementing then incrementing.\n            _balances[to] += amount;\n        }\n\n        emit Transfer(from, to, amount);\n\n        _afterTokenTransfer(from, to, amount);\n    }\n\n    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n     * the total supply.\n     *\n     * Emits a {Transfer} event with `from` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(address(0), account, amount);\n\n        _totalSupply += amount;\n        unchecked {\n            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.\n            _balances[account] += amount;\n        }\n        emit Transfer(address(0), account, amount);\n\n        _afterTokenTransfer(address(0), account, amount);\n    }\n\n    /**\n     * @dev Destroys `amount` tokens from `account`, reducing the\n     * total supply.\n     *\n     * Emits a {Transfer} event with `to` set to the zero address.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     * - `account` must have at least `amount` tokens.\n     */\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        unchecked {\n            _balances[account] = accountBalance - amount;\n            // Overflow not possible: amount <= accountBalance <= totalSupply.\n            _totalSupply -= amount;\n        }\n\n        emit Transfer(account, address(0), amount);\n\n        _afterTokenTransfer(account, address(0), amount);\n    }\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n     *\n     * This internal function is equivalent to `approve`, and can be used to\n     * e.g. set automatic allowances for certain subsystems, etc.\n     *\n     * Emits an {Approval} event.\n     *\n     * Requirements:\n     *\n     * - `owner` cannot be the zero address.\n     * - `spender` cannot be the zero address.\n     */\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    /**\n     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.\n     *\n     * Does not update the allowance amount in case of infinite allowance.\n     * Revert if not enough allowance is available.\n     *\n     * Might emit an {Approval} event.\n     */\n    function _spendAllowance(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        uint256 currentAllowance = allowance(owner, spender);\n        if (currentAllowance != type(uint256).max) {\n            require(currentAllowance >= amount, \"ERC20: insufficient allowance\");\n            unchecked {\n                _approve(owner, spender, currentAllowance - amount);\n            }\n        }\n    }\n\n    /**\n     * @dev Hook that is called before any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * will be transferred to `to`.\n     * - when `from` is zero, `amount` tokens will be minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n\n    /**\n     * @dev Hook that is called after any transfer of tokens. This includes\n     * minting and burning.\n     *\n     * Calling conditions:\n     *\n     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n     * has been transferred to `to`.\n     * - when `from` is zero, `amount` tokens have been minted for `to`.\n     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.\n     * - `from` and `to` are never both zero.\n     *\n     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n     */\n    function _afterTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n"
    },
    "@openzeppelin/contracts/utils/Context.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Provides information about the current execution context, including the\n * sender of the transaction and its data. While these are generally available\n * via msg.sender and msg.data, they should not be accessed in such a direct\n * manner, since when dealing with meta-transactions the account sending and\n * paying for execution may not be the actual sender (as far as an application\n * is concerned).\n *\n * This contract is only required for intermediate, library-like contracts.\n */\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../IERC20.sol\";\n\n/**\n * @dev Interface for the optional metadata functions from the ERC20 standard.\n *\n * _Available since v4.1._\n */\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) external returns (bool);\n}\n"
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
    }
  }
}}