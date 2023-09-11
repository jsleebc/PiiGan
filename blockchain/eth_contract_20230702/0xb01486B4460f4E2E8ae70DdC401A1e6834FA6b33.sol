{"AddressLibrary.sol":{"content":"// SPDX-License-Identifier: MIT\r\n// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)\r\n\r\npragma solidity 0.8.7;\r\n\r\n/**\r\n * @dev Collection of functions related to the address type\r\n */\r\nlibrary Address {\r\n    /**\r\n     * @dev Returns true if `account` is a contract.\r\n     *\r\n     * [IMPORTANT]\r\n     * ====\r\n     * It is unsafe to assume that an address for which this function returns\r\n     * false is an externally-owned account (EOA) and not a contract.\r\n     *\r\n     * Among others, `isContract` will return false for the following\r\n     * types of addresses:\r\n     *\r\n     *  - an externally-owned account\r\n     *  - a contract in construction\r\n     *  - an address where a contract will be created\r\n     *  - an address where a contract lived, but was destroyed\r\n     *\r\n     * Furthermore, `isContract` will also return true if the target contract within\r\n     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,\r\n     * which only has an effect at the end of a transaction.\r\n     * ====\r\n     *\r\n     * [IMPORTANT]\r\n     * ====\r\n     * You shouldn\u0027t rely on `isContract` to protect against flash loan attacks!\r\n     *\r\n     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets\r\n     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract\r\n     * constructor.\r\n     * ====\r\n     */\r\n    function isContract(address account) internal view returns (bool) {\r\n        // This method relies on extcodesize/address.code.length, which returns 0\r\n        // for contracts in construction, since the code is only stored at the end\r\n        // of the constructor execution.\r\n\r\n        return account.code.length \u003e 0;\r\n    }\r\n\r\n    /**\r\n     * @dev Replacement for Solidity\u0027s `transfer`: sends `amount` wei to\r\n     * `recipient`, forwarding all available gas and reverting on errors.\r\n     *\r\n     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\r\n     * of certain opcodes, possibly making contracts go over the 2300 gas limit\r\n     * imposed by `transfer`, making them unable to receive funds via\r\n     * `transfer`. {sendValue} removes this limitation.\r\n     *\r\n     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].\r\n     *\r\n     * IMPORTANT: because control is transferred to `recipient`, care must be\r\n     * taken to not create reentrancy vulnerabilities. Consider using\r\n     * {ReentrancyGuard} or the\r\n     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\r\n     */\r\n    function sendValue(address payable recipient, uint256 amount) internal {\r\n        require(address(this).balance \u003e= amount, \"Address: insufficient balance\");\r\n\r\n        (bool success, ) = recipient.call{value: amount}(\"\");\r\n        require(success, \"Address: unable to send value, recipient may have reverted\");\r\n    }\r\n\r\n    /**\r\n     * @dev Performs a Solidity function call using a low level `call`. A\r\n     * plain `call` is an unsafe replacement for a function call: use this\r\n     * function instead.\r\n     *\r\n     * If `target` reverts with a revert reason, it is bubbled up by this\r\n     * function (like regular Solidity function calls).\r\n     *\r\n     * Returns the raw returned data. To convert to the expected return value,\r\n     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - `target` must be a contract.\r\n     * - calling `target` with `data` must not revert.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\r\n        return functionCallWithValue(target, data, 0, \"Address: low-level call failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\r\n     * `errorMessage` as a fallback revert reason when `target` reverts.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCall(\r\n        address target,\r\n        bytes memory data,\r\n        string memory errorMessage\r\n    ) internal returns (bytes memory) {\r\n        return functionCallWithValue(target, data, 0, errorMessage);\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\r\n     * but also transferring `value` wei to `target`.\r\n     *\r\n     * Requirements:\r\n     *\r\n     * - the calling contract must have an ETH balance of at least `value`.\r\n     * - the called Solidity function must be `payable`.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\r\n        return functionCallWithValue(target, data, value, \"Address: low-level call with value failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\r\n     * with `errorMessage` as a fallback revert reason when `target` reverts.\r\n     *\r\n     * _Available since v3.1._\r\n     */\r\n    function functionCallWithValue(\r\n        address target,\r\n        bytes memory data,\r\n        uint256 value,\r\n        string memory errorMessage\r\n    ) internal returns (bytes memory) {\r\n        require(address(this).balance \u003e= value, \"Address: insufficient balance for call\");\r\n        (bool success, bytes memory returndata) = target.call{value: value}(data);\r\n        return verifyCallResultFromTarget(target, success, returndata, errorMessage);\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\r\n     * but performing a static call.\r\n     *\r\n     * _Available since v3.3._\r\n     */\r\n    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\r\n        return functionStaticCall(target, data, \"Address: low-level static call failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\r\n     * but performing a static call.\r\n     *\r\n     * _Available since v3.3._\r\n     */\r\n    function functionStaticCall(\r\n        address target,\r\n        bytes memory data,\r\n        string memory errorMessage\r\n    ) internal view returns (bytes memory) {\r\n        (bool success, bytes memory returndata) = target.staticcall(data);\r\n        return verifyCallResultFromTarget(target, success, returndata, errorMessage);\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\r\n     * but performing a delegate call.\r\n     *\r\n     * _Available since v3.4._\r\n     */\r\n    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\r\n        return functionDelegateCall(target, data, \"Address: low-level delegate call failed\");\r\n    }\r\n\r\n    /**\r\n     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\r\n     * but performing a delegate call.\r\n     *\r\n     * _Available since v3.4._\r\n     */\r\n    function functionDelegateCall(\r\n        address target,\r\n        bytes memory data,\r\n        string memory errorMessage\r\n    ) internal returns (bytes memory) {\r\n        (bool success, bytes memory returndata) = target.delegatecall(data);\r\n        return verifyCallResultFromTarget(target, success, returndata, errorMessage);\r\n    }\r\n\r\n    /**\r\n     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling\r\n     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.\r\n     *\r\n     * _Available since v4.8._\r\n     */\r\n    function verifyCallResultFromTarget(\r\n        address target,\r\n        bool success,\r\n        bytes memory returndata,\r\n        string memory errorMessage\r\n    ) internal view returns (bytes memory) {\r\n        if (success) {\r\n            if (returndata.length == 0) {\r\n                // only check isContract if the call was successful and the return data is empty\r\n                // otherwise we already know that it was a contract\r\n                require(isContract(target), \"Address: call to non-contract\");\r\n            }\r\n            return returndata;\r\n        } else {\r\n            _revert(returndata, errorMessage);\r\n        }\r\n    }\r\n\r\n    /**\r\n     * @dev Tool to verify that a low level call was successful, and revert if it wasn\u0027t, either by bubbling the\r\n     * revert reason or using the provided one.\r\n     *\r\n     * _Available since v4.3._\r\n     */\r\n    function verifyCallResult(\r\n        bool success,\r\n        bytes memory returndata,\r\n        string memory errorMessage\r\n    ) internal pure returns (bytes memory) {\r\n        if (success) {\r\n            return returndata;\r\n        } else {\r\n            _revert(returndata, errorMessage);\r\n        }\r\n    }\r\n\r\n    function _revert(bytes memory returndata, string memory errorMessage) private pure {\r\n        // Look for revert reason and bubble it up if present\r\n        if (returndata.length \u003e 0) {\r\n            // The easiest way to bubble the revert reason is using memory via assembly\r\n            /// @solidity memory-safe-assembly\r\n            assembly {\r\n                let returndata_size := mload(returndata)\r\n                revert(add(32, returndata), returndata_size)\r\n            }\r\n        } else {\r\n            revert(errorMessage);\r\n        }\r\n    }\r\n}"},"BaseErc20Min.sol":{"content":"//SPDX-License-Identifier: UNLICENSED\r\n\r\npragma solidity 0.8.7;\r\n\r\nimport \"./Interfaces.sol\";\r\n\r\nabstract contract BaseErc20 is IERC20, IOwnable {\r\n    mapping (address =\u003e uint256) internal _balances;\r\n    mapping (address =\u003e mapping (address =\u003e uint256)) internal _allowed;\r\n    uint256 internal _totalSupply;\r\n    \r\n    string public symbol;\r\n    string public name;\r\n    uint8 public decimals;\r\n    \r\n    address public override owner;\r\n    bool public launched;\r\n    \r\n    mapping (address =\u003e bool) internal exchanges;\r\n\r\n    modifier onlyOwner() {\r\n        require(msg.sender == owner, \"can only be called by the contract owner\");\r\n        _;\r\n    }\r\n    \r\n    modifier isLaunched() {\r\n        require(launched, \"can only be called once token is launched\");\r\n        _;\r\n    }\r\n\r\n    // @dev Trading is allowed before launch if the sender is the owner, we are transferring from the owner, or in canAlwaysTrade list\r\n    modifier tradingEnabled(address from) {\r\n        require(launched || from == owner, \"trading not enabled\");\r\n        _;\r\n    }\r\n    \r\n    function configure(address _owner) internal virtual {\r\n        owner = _owner;\r\n    }\r\n\r\n    /**\r\n    * @dev Total number of tokens in existence\r\n    */\r\n    function totalSupply() external override view returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    /**\r\n    * @dev Gets the balance of the specified address.\r\n    * @param _owner The address to query the balance of.\r\n    * @return An uint256 representing the amount owned by the passed address.\r\n    */\r\n    function balanceOf(address _owner) external override view returns (uint256) {\r\n        return _balances[_owner];\r\n    }\r\n\r\n    /**\r\n     * @dev Function to check the amount of tokens that an owner allowed to a spender.\r\n     * @param _owner address The address which owns the funds.\r\n     * @param spender address The address which will spend the funds.\r\n     * @return A uint256 specifying the amount of tokens still available for the spender.\r\n     */\r\n    function allowance(address _owner, address spender) external override view returns (uint256) {\r\n        return _allowed[_owner][spender];\r\n    }\r\n\r\n    /**\r\n    * @dev Transfer token for a specified address\r\n    * @param to The address to transfer to.\r\n    * @param value The amount to be transferred.\r\n    */\r\n    function transfer(address to, uint256 value) external override tradingEnabled(msg.sender) returns (bool) {\r\n        _transfer(msg.sender, to, value);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\r\n     * Beware that changing an allowance with this method brings the risk that someone may use both the old\r\n     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\r\n     * race condition is to first reduce the spender\u0027s allowance to 0 and set the desired value afterwards:\r\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\r\n     * @param spender The address which will spend the funds.\r\n     * @param value The amount of tokens to be spent.\r\n     */\r\n    function approve(address spender, uint256 value) external override tradingEnabled(msg.sender) returns (bool) {\r\n        require(spender != address(0), \"cannot approve the 0 address\");\r\n\r\n        _allowed[msg.sender][spender] = value;\r\n        emit Approval(msg.sender, spender, value);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n     * @dev Transfer tokens from one address to another.\r\n     * Note that while this function emits an Approval event, this is not required as per the specification,\r\n     * and other compliant implementations may not emit the event.\r\n     * @param from address The address which you want to send tokens from\r\n     * @param to address The address which you want to transfer to\r\n     * @param value uint256 the amount of tokens to be transferred\r\n     */\r\n    function transferFrom(address from, address to, uint256 value) external override tradingEnabled(from) returns (bool) {\r\n        _allowed[from][msg.sender] = _allowed[from][msg.sender] - value;\r\n        _transfer(from, to, value);\r\n        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\r\n        return true;\r\n    }\r\n\r\n    // Virtual methods\r\n    function launch() virtual external onlyOwner {\r\n        require(launched == false, \"contract already launched\");\r\n        launched = true;\r\n    }\r\n\r\n    function calculateTransferAmount(address from, address to, uint256 value) virtual internal returns (uint256) {\r\n        require(from != to, \"you cannot transfer to yourself\");\r\n        return value;\r\n    }\r\n    \r\n    function preTransfer(address from, address to, uint256 value) virtual internal { }\r\n\r\n    // Admin methods\r\n    function changeOwner(address who) external onlyOwner {\r\n        owner = who;\r\n    }\r\n\r\n    function setExchange(address who, bool on) external onlyOwner {\r\n        require(exchanges[who] != on, \"already set\");\r\n        exchanges[who] = on;\r\n    }\r\n\r\n    // Private methods\r\n\r\n    function getRouterAddress() internal view returns (address routerAddress) {\r\n        if (block.chainid == 1 || block.chainid == 3 || block.chainid == 4  || block.chainid == 5) {\r\n            routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D ; // ETHEREUM\r\n        } else if (block.chainid == 56) {\r\n            routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC MAINNET\r\n        } else if (block.chainid == 97) {\r\n            routerAddress = 0xc99f3718dB7c90b020cBBbb47eD26b0BA0C6512B; // BSC TESTNET - https://pancakeswap.rainbit.me/\r\n        } else {\r\n            revert(\"Unknown Chain ID\");\r\n        }\r\n    }\r\n\r\n    /**\r\n    * @dev Transfer token for a specified addresses\r\n    * @param from The address to transfer from.\r\n    * @param to The address to transfer to.\r\n    * @param value The amount to be transferred.\r\n    */\r\n    function _transfer(address from, address to, uint256 value) private {\r\n        require(to != address(0), \"cannot be zero address\");\r\n\r\n        preTransfer(from, to, value);\r\n\r\n        uint256 modifiedAmount = calculateTransferAmount(from, to, value);\r\n        _balances[from] = _balances[from] - value;\r\n        _balances[to] = _balances[to] + modifiedAmount;\r\n\r\n        emit Transfer(from, to, modifiedAmount);\r\n    }\r\n}"},"BasicTaxableMin.sol":{"content":"//SPDX-License-Identifier: UNLICENSED\r\n\r\npragma solidity 0.8.7;\r\n\r\nimport \"./BaseErc20Min.sol\";\r\nimport \"./AddressLibrary.sol\";\r\nimport \"./Interfaces.sol\";\r\n\r\ninterface IBasicTaxDistributor {\r\n    receive() external payable;\r\n    function lastSwapTime() external view returns (uint256);\r\n    function inSwap() external view returns (bool);\r\n    function createWalletTax(string memory name, uint256 buyTax, uint256 sellTax, address wallet, bool convertToNative) external;\r\n    function distribute() external payable;\r\n    function getSellTax() external view returns (uint256);\r\n    function getBuyTax() external view returns (uint256);\r\n    function getTaxWallet(string memory taxName) external view returns(address);\r\n    function setTaxWallet(string memory taxName, address wallet) external;\r\n    function setSellTax(string memory taxName, uint256 taxPercentage) external;\r\n    function setBuyTax(string memory taxName, uint256 taxPercentage) external;\r\n    function takeSellTax(uint256 value) external returns (uint256);\r\n    function takeBuyTax(uint256 value) external returns (uint256);\r\n}\r\n\r\nabstract contract Taxable is BaseErc20 {\r\n    \r\n    IBasicTaxDistributor internal taxDistributor;\r\n\r\n    bool internal autoSwapTax;\r\n    uint256 internal minimumTimeBetweenSwaps;\r\n    uint256 internal minimumTokensBeforeSwap;\r\n    mapping (address =\u003e bool) internal excludedFromTax;\r\n    uint256 private swapStartTime;\r\n    \r\n    // Overrides\r\n    \r\n    function configure(address _owner) internal virtual override {\r\n        excludedFromTax[owner] = true;\r\n        super.configure(_owner);\r\n    }\r\n\r\n    function calculateTransferAmount(address from, address to, uint256 value) internal virtual override returns (uint256) {\r\n        \r\n        uint256 amountAfterTax = value;\r\n\r\n        if (excludedFromTax[from] == false \u0026\u0026 excludedFromTax[to] == false \u0026\u0026 launched) {\r\n            if (exchanges[from]) {\r\n                // we are BUYING\r\n                amountAfterTax = taxDistributor.takeBuyTax(value);\r\n            } else if (exchanges[to]) {\r\n                // we are SELLING\r\n                amountAfterTax = taxDistributor.takeSellTax(value);\r\n            }\r\n        }\r\n\r\n        uint256 taxAmount = value - amountAfterTax;\r\n        if (taxAmount \u003e 0) {\r\n            _balances[address(taxDistributor)] = _balances[address(taxDistributor)] + taxAmount;\r\n            emit Transfer(from, address(taxDistributor), taxAmount);\r\n        }\r\n        return super.calculateTransferAmount(from, to, amountAfterTax);\r\n    }\r\n\r\n\r\n    function preTransfer(address from, address to, uint256 value) override virtual internal {\r\n        uint256 timeSinceLastSwap = block.timestamp - taxDistributor.lastSwapTime();\r\n        if (\r\n            launched \u0026\u0026 \r\n            autoSwapTax \u0026\u0026 \r\n            exchanges[to] \u0026\u0026 \r\n            swapStartTime + 60 \u003c= block.timestamp \u0026\u0026\r\n            timeSinceLastSwap \u003e= minimumTimeBetweenSwaps \u0026\u0026\r\n            _balances[address(taxDistributor)] \u003e= minimumTokensBeforeSwap \u0026\u0026\r\n            taxDistributor.inSwap() == false\r\n        ) {\r\n            swapStartTime = block.timestamp;\r\n            try taxDistributor.distribute() {} catch {}\r\n        }\r\n        super.preTransfer(from, to, value);\r\n    }\r\n    \r\n    \r\n    // Public methods\r\n    \r\n    /**\r\n     * @dev Return the current total sell tax from the tax distributor\r\n     */\r\n    function sellTax() external view returns (uint256) {\r\n        return taxDistributor.getSellTax();\r\n    }\r\n\r\n    /**\r\n     * @dev Return the current total sell tax from the tax distributor\r\n     */\r\n    function buyTax() external view returns (uint256) {\r\n        return taxDistributor.getBuyTax();\r\n    }\r\n\r\n    /**\r\n     * @dev Return the address of the tax distributor contract\r\n     */\r\n    function taxDistributorAddress() external view returns (address) {\r\n        return address(taxDistributor);\r\n    }    \r\n    \r\n    \r\n    // Admin methods\r\n\r\n    function setAutoSwaptax(bool enabled) external onlyOwner {\r\n        autoSwapTax = enabled;\r\n    }\r\n\r\n    function setExcludedFromTax(address who, bool enabled) external onlyOwner {\r\n        require(exchanges[who] == false || enabled == false, \"Cannot exclude an exchange from tax\");\r\n        excludedFromTax[who] = enabled;\r\n    }\r\n\r\n    function setTaxDistributionThresholds(uint256 minAmount, uint256 minTime) external onlyOwner {\r\n        minimumTokensBeforeSwap = minAmount;\r\n        minimumTimeBetweenSwaps = minTime;\r\n    }\r\n    \r\n    function setSellTax(string memory taxName, uint256 taxAmount) external onlyOwner {\r\n        taxDistributor.setSellTax(taxName, taxAmount);\r\n    }\r\n\r\n    function setBuyTax(string memory taxName, uint256 taxAmount) external onlyOwner {\r\n        taxDistributor.setBuyTax(taxName, taxAmount);\r\n    }\r\n    \r\n    function setTaxWallet(string memory taxName, address wallet) external onlyOwner {\r\n        taxDistributor.setTaxWallet(taxName, wallet);\r\n    }\r\n    \r\n    function runSwapManually() external isLaunched {\r\n        taxDistributor.distribute();\r\n    }\r\n}\r\n\r\ncontract BasicTaxDistributor is IBasicTaxDistributor {\r\n    using Address for address;\r\n\r\n    address immutable private tokenPair;\r\n    address immutable private routerAddress;\r\n    address immutable private _token;\r\n    address immutable private _wbnb;\r\n\r\n    IDEXRouter private _router;\r\n\r\n    bool public override inSwap;\r\n    uint256 public override lastSwapTime;\r\n\r\n    uint256 immutable private maxSellTax;\r\n    uint256 immutable private maxBuyTax;\r\n\r\n    struct Tax {\r\n        string taxName;\r\n        uint256 buyTaxPercentage;\r\n        uint256 sellTaxPercentage;\r\n        uint256 taxPool;\r\n        address location;\r\n        uint256 share;\r\n        bool convertToNative;\r\n    }\r\n    Tax[] internal taxes;\r\n\r\n    event TaxesDistributed(uint256 tokensSwapped, uint256 ethReceived);\r\n    event DistributionError(string text);\r\n\r\n    modifier onlyToken() {\r\n        require(msg.sender == _token, \"no permissions\");\r\n        _;\r\n    }\r\n\r\n    modifier swapLock() {\r\n        require(inSwap == false, \"already swapping\");\r\n        inSwap = true;\r\n        _;\r\n        inSwap = false;\r\n    }\r\n\r\n    constructor (address router, address pair, address wbnb, uint256 _maxSellTax, uint256 _maxBuyTax) {\r\n        require(wbnb != address(0), \"pairedToken cannot be 0 address\");\r\n        require(pair != address(0), \"pair cannot be 0 address\");\r\n        require(router != address(0), \"router cannot be 0 address\");\r\n        _token = msg.sender;\r\n        _wbnb = wbnb;\r\n        _router = IDEXRouter(router);\r\n        maxSellTax = _maxSellTax;\r\n        maxBuyTax = _maxBuyTax;\r\n        tokenPair = pair;\r\n        routerAddress = router;\r\n    }\r\n\r\n    receive() external override payable {}\r\n\r\n    function createWalletTax(string memory name, uint256 buyTax, uint256 sellTax, address wallet, bool convertToNative) external override onlyToken {\r\n        require(checkTaxExists(name) == false, \"This tax already exists\");\r\n        taxes.push(Tax(name, buyTax, sellTax, 0, wallet, 0, convertToNative));\r\n    }\r\n\r\n    function checkTaxExists(string memory taxName) private view returns(bool) {\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            if (compareStrings(taxes[i].taxName, taxName)) {\r\n                return true;\r\n            }\r\n        }\r\n        return false;\r\n    }\r\n\r\n    function distribute() external payable override onlyToken swapLock {\r\n        address[] memory path = new address[](2);\r\n        path[0] = _token;\r\n        path[1] = _wbnb;\r\n        IERC20 token = IERC20(_token);\r\n\r\n        uint256 totalTokens;\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            if (taxes[i].convertToNative) {\r\n                totalTokens += taxes[i].taxPool;\r\n            }\r\n        }\r\n        totalTokens = checkTokenAmount(token, totalTokens);\r\n\r\n        uint256[] memory amts = _router.swapExactTokensForETH(\r\n            totalTokens,\r\n            0,\r\n            path,\r\n            address(this),\r\n            block.timestamp + 300\r\n        );\r\n        uint256 amountBNB = address(this).balance;\r\n\r\n        if (totalTokens != amts[0] || amountBNB != amts[1] ) {\r\n            emit DistributionError(\"Unexpected amounts returned from swap\");\r\n        }\r\n\r\n        // Calculate the distribution\r\n        uint256 toDistribute = amountBNB;\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n\r\n            if (taxes[i].convertToNative) {\r\n                if (i == taxes.length - 1) {\r\n                    taxes[i].share = toDistribute;\r\n                } else {\r\n                    uint256 share = (amountBNB * taxes[i].taxPool) / totalTokens;\r\n                    taxes[i].share = share;\r\n                    toDistribute = toDistribute - share;\r\n                }\r\n            }\r\n        }\r\n\r\n        // Distribute the coins\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {        \r\n                if (taxes[i].convertToNative) {\r\n                    Address.sendValue(payable(taxes[i].location), taxes[i].share);\r\n                } else {\r\n                    require(token.transfer(taxes[i].location, checkTokenAmount(token, taxes[i].taxPool)), \"could not transfer tokens\");\r\n                }\r\n\r\n            taxes[i].taxPool = 0;\r\n            taxes[i].share = 0;\r\n        }\r\n\r\n        // Remove any leftoever tokens\r\n        if (address(this).balance \u003e 0) {\r\n            Address.sendValue(payable(_token), address(this).balance);\r\n        }\r\n\r\n        if (token.balanceOf(address(this)) \u003e 0) {\r\n            token.transfer(_token, token.balanceOf(address(this)));\r\n        }\r\n\r\n        emit TaxesDistributed(totalTokens, amountBNB);\r\n\r\n        lastSwapTime = block.timestamp;\r\n    }\r\n\r\n    function getSellTax() public override onlyToken view returns (uint256) {\r\n        uint256 taxAmount;\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            taxAmount += taxes[i].sellTaxPercentage;\r\n        }\r\n        return taxAmount;\r\n    }\r\n\r\n    function getBuyTax() public override onlyToken view returns (uint256) {\r\n        uint256 taxAmount;\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            taxAmount += taxes[i].buyTaxPercentage;\r\n        }\r\n        return taxAmount;\r\n    }\r\n\r\n    function getTaxWallet(string memory taxName)external override view onlyToken returns (address)  {\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            if (compareStrings(taxes[i].taxName, taxName)) {\r\n                return taxes[i].location;\r\n            }\r\n        }\r\n        revert(\"could not find tax\");\r\n    }\r\n    \r\n    function setTaxWallet(string memory taxName, address wallet) external override onlyToken {\r\n        bool updated;\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            if (compareStrings(taxes[i].taxName, taxName)) {\r\n                taxes[i].location = wallet;\r\n                updated = true;\r\n            }\r\n        }\r\n        require(updated, \"could not find tax to update\");\r\n    }\r\n\r\n    function setSellTax(string memory taxName, uint256 taxPercentage) external override onlyToken {\r\n        bool updated;\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            if (compareStrings(taxes[i].taxName, taxName)) {\r\n                taxes[i].sellTaxPercentage = taxPercentage;\r\n                updated = true;\r\n            }\r\n        }\r\n        require(updated, \"could not find tax to update\");\r\n        require(getSellTax() \u003c= maxSellTax, \"tax cannot be set this high\");\r\n    }\r\n\r\n    function setBuyTax(string memory taxName, uint256 taxPercentage) external override onlyToken {\r\n        bool updated;\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            //if (taxes[i].taxName == taxName) {\r\n            if (compareStrings(taxes[i].taxName, taxName)) {\r\n                taxes[i].buyTaxPercentage = taxPercentage;\r\n                updated = true;\r\n            }\r\n        }\r\n        require(updated, \"could not find tax to update\");\r\n        require(getBuyTax() \u003c= maxBuyTax, \"tax cannot be set this high\");\r\n    }\r\n\r\n    function takeSellTax(uint256 value) external override onlyToken returns (uint256) {\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            if (taxes[i].sellTaxPercentage \u003e 0) {\r\n                uint256 taxAmount = (value * taxes[i].sellTaxPercentage) / 10000;\r\n                taxes[i].taxPool += taxAmount;\r\n                value = value - taxAmount;\r\n            }\r\n        }\r\n        return value;\r\n    }\r\n\r\n    function takeBuyTax(uint256 value) external override onlyToken returns (uint256) {\r\n        for (uint256 i = 0; i \u003c taxes.length; i++) {\r\n            if (taxes[i].buyTaxPercentage \u003e 0) {\r\n                uint256 taxAmount = (value * taxes[i].buyTaxPercentage) / 10000;\r\n                taxes[i].taxPool += taxAmount;\r\n                value = value - taxAmount;\r\n            }\r\n        }\r\n        return value;\r\n    }\r\n    \r\n    \r\n    // Private methods\r\n    function compareStrings(string memory a, string memory b) private pure returns (bool) {\r\n        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));\r\n    }\r\n\r\n    function checkTokenAmount(IERC20 token, uint256 amount) private view returns (uint256) {\r\n        uint256 balance = token.balanceOf(address(this));\r\n        if (balance \u003e amount) {\r\n            return amount;\r\n        }\r\n        return balance;\r\n    }\r\n}\r\n"},"Interfaces.sol":{"content":"//SPDX-License-Identifier: UNLICENSED\r\n\r\npragma solidity 0.8.7;\r\n\r\ninterface IOwnable {\r\n    function owner() external view returns (address);\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address who) external view returns (uint256);\r\n    function allowance(address _owner, address spender) external view returns (uint256);\r\n    function transfer(address to, uint256 value) external returns (bool);\r\n    function approve(address spender, uint256 value) external returns (bool);\r\n    function transferFrom(address from, address to, uint256 value) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n}\r\n\r\ninterface IBurnable {\r\n    function burn(uint256 value) external;\r\n    function burnFrom(address account, uint256 value) external;\r\n}\r\n\r\ninterface IDEXFactory {\r\n    function createPair(address tokenA, address tokenB) external returns (address pair);\r\n}\r\n\r\ninterface IDEXRouter {\r\n    function factory() external pure returns (address);\r\n    function WETH() external pure returns (address);\r\n    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);\r\n    function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);    \r\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);\r\n    function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);\r\n}\r\n\r\ninterface IDividendDistributor {\r\n    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;\r\n    function setShare(address shareholder, uint256 amount) external;\r\n    function depositNative() external payable;\r\n    function depositToken(address from, uint256 amount) external;\r\n    function process(uint256 gas) external;\r\n    function inSwap() external view returns (bool);\r\n}\r\n\r\ninterface ITaxDistributorLight {\r\n    receive() external payable;\r\n    function lastSwapTime() external view returns (uint256);\r\n    function inSwap() external view returns (bool);\r\n    function createWalletTax(string memory name, uint256 buyTax, uint256 sellTax, address wallet, bool convertToNative) external;\r\n    function distribute() external payable;\r\n    function getSellTax() external view returns (uint256);\r\n    function getBuyTax() external view returns (uint256);\r\n    function getTaxWallet(string memory taxName) external view returns(address);\r\n    function setTaxWallet(string memory taxName, address wallet) external;\r\n    function setSellTax(string memory taxName, uint256 taxPercentage) external;\r\n    function setBuyTax(string memory taxName, uint256 taxPercentage) external;\r\n    function takeSellTax(uint256 value) external returns (uint256);\r\n    function takeBuyTax(uint256 value) external returns (uint256);\r\n}\r\n\r\ninterface ITaxDistributor {\r\n    function createDistributorTax(string memory name, uint256 buyTax, uint256 sellTax, address wallet, bool convertToNative) external;\r\n    function createDividendTax(string memory name, uint256 buyTax, uint256 sellTax, address dividendDistributor, bool convertToNative) external;\r\n    function createBurnTax(string memory name, uint256 buyTax, uint256 sellTax) external;\r\n    function createLiquidityTax(string memory name, uint256 buyTax, uint256 sellTax, address holder) external; \r\n}\r\n\r\n\r\ninterface IWalletDistributor {\r\n    function receiveToken(address token, address from, uint256 amount) external;\r\n}\r\n"},"_JaredCoin.sol":{"content":"//SPDX-License-Identifier: UNLICENSED\r\n\r\npragma solidity 0.8.7;\r\n\r\nimport \"./Interfaces.sol\";\r\nimport \"./BaseErc20Min.sol\";\r\nimport \"./BasicTaxableMin.sol\";\r\n\r\ncontract Jared is BaseErc20, Taxable {\r\n\r\n    uint256 immutable public mhAmount;\r\n\r\n    constructor () {\r\n        configure(0xE167B3654fA47F5b14a3120afF2747bb9Bd3C73c);\r\n\r\n        symbol = \"JARED\";\r\n        name = \"Jared Coin\";\r\n        decimals = 18;\r\n\r\n        // Swap\r\n        address routerAddress = getRouterAddress();\r\n        IDEXRouter router = IDEXRouter(routerAddress);\r\n        address native = router.WETH();\r\n        address pair = IDEXFactory(router.factory()).createPair(native, address(this));\r\n        exchanges[pair] = true;\r\n        taxDistributor = new BasicTaxDistributor(routerAddress, pair, native, 3000, 2000);\r\n\r\n        // Tax\r\n        minimumTimeBetweenSwaps = 30 seconds;\r\n        minimumTokensBeforeSwap = 1 * 10 ** decimals;\r\n        excludedFromTax[address(taxDistributor)] = true;\r\n        taxDistributor.createWalletTax(\"Marketing\", 2000, 3000, 0x55a57dE02C3cD913B846B3Ffcc17110D63625bFa, true);\r\n        autoSwapTax = true;\r\n\r\n        // Max Hold\r\n        mhAmount = 8_413_800_005  * 10 ** decimals;\r\n\r\n        // Finalise\r\n        _allowed[address(taxDistributor)][routerAddress] = 2**256 - 1;\r\n        _totalSupply = _totalSupply + (420_690_000_000 * 10 ** decimals);\r\n        _balances[owner] = _balances[owner] + _totalSupply;\r\n        emit Transfer(address(0), owner, _totalSupply);\r\n    }\r\n\r\n    // Overrides\r\n\r\n    function configure(address _owner) internal override(Taxable, BaseErc20) {\r\n        super.configure(_owner);\r\n    }\r\n    \r\n    function preTransfer(address from, address to, uint256 value) override(Taxable, BaseErc20) internal {      \r\n        if (launched \u0026\u0026 \r\n            from != owner \u0026\u0026 to != owner \u0026\u0026 \r\n            exchanges[to] == false \u0026\u0026 \r\n            to != getRouterAddress()\r\n        ) {\r\n            require (_balances[to] + value \u003c= mhAmount, \"this is over the max hold amount\");\r\n        }\r\n        \r\n        super.preTransfer(from, to, value);\r\n    }\r\n    \r\n    function calculateTransferAmount(address from, address to, uint256 value) override(Taxable, BaseErc20) internal returns (uint256) {\r\n        return super.calculateTransferAmount(from, to, value);\r\n    }\r\n\r\n} "}}