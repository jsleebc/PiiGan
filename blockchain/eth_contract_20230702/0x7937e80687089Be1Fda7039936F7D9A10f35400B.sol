{{
  "language": "Solidity",
  "sources": {
    "lib/solmate/src/auth/Owned.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity >=0.8.0;\n\n/// @notice Simple single owner authorization mixin.\n/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)\nabstract contract Owned {\n    /*//////////////////////////////////////////////////////////////\n                                 EVENTS\n    //////////////////////////////////////////////////////////////*/\n\n    event OwnershipTransferred(address indexed user, address indexed newOwner);\n\n    /*//////////////////////////////////////////////////////////////\n                            OWNERSHIP STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    address public owner;\n\n    modifier onlyOwner() virtual {\n        require(msg.sender == owner, \"UNAUTHORIZED\");\n\n        _;\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                               CONSTRUCTOR\n    //////////////////////////////////////////////////////////////*/\n\n    constructor(address _owner) {\n        owner = _owner;\n\n        emit OwnershipTransferred(address(0), _owner);\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                             OWNERSHIP LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        owner = newOwner;\n\n        emit OwnershipTransferred(msg.sender, newOwner);\n    }\n}\n"
    },
    "lib/solmate/src/tokens/ERC20.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity >=0.8.0;\n\n/// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.\n/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)\n/// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)\n/// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.\nabstract contract ERC20 {\n    /*//////////////////////////////////////////////////////////////\n                                 EVENTS\n    //////////////////////////////////////////////////////////////*/\n\n    event Transfer(address indexed from, address indexed to, uint256 amount);\n\n    event Approval(address indexed owner, address indexed spender, uint256 amount);\n\n    /*//////////////////////////////////////////////////////////////\n                            METADATA STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    string public name;\n\n    string public symbol;\n\n    uint8 public immutable decimals;\n\n    /*//////////////////////////////////////////////////////////////\n                              ERC20 STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    uint256 public totalSupply;\n\n    mapping(address => uint256) public balanceOf;\n\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    /*//////////////////////////////////////////////////////////////\n                            EIP-2612 STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    uint256 internal immutable INITIAL_CHAIN_ID;\n\n    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;\n\n    mapping(address => uint256) public nonces;\n\n    /*//////////////////////////////////////////////////////////////\n                               CONSTRUCTOR\n    //////////////////////////////////////////////////////////////*/\n\n    constructor(\n        string memory _name,\n        string memory _symbol,\n        uint8 _decimals\n    ) {\n        name = _name;\n        symbol = _symbol;\n        decimals = _decimals;\n\n        INITIAL_CHAIN_ID = block.chainid;\n        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                               ERC20 LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function approve(address spender, uint256 amount) public virtual returns (bool) {\n        allowance[msg.sender][spender] = amount;\n\n        emit Approval(msg.sender, spender, amount);\n\n        return true;\n    }\n\n    function _checkTransferAmount(uint256 amount) internal view virtual;\n\n    function transfer(address to, uint256 amount) public virtual returns (bool) {\n        _checkTransferAmount(amount);\n\n        balanceOf[msg.sender] -= amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(msg.sender, to, amount);\n\n        return true;\n    }\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual returns (bool) {\n        _checkTransferAmount(amount);\n\n        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.\n\n        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;\n\n        balanceOf[from] -= amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(from, to, amount);\n\n        return true;\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                             EIP-2612 LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function permit(\n        address owner,\n        address spender,\n        uint256 value,\n        uint256 deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) public virtual {\n        require(deadline >= block.timestamp, \"PERMIT_DEADLINE_EXPIRED\");\n\n        // Unchecked because the only math done is incrementing\n        // the owner's nonce which cannot realistically overflow.\n        unchecked {\n            address recoveredAddress = ecrecover(\n                keccak256(\n                    abi.encodePacked(\n                        \"\\x19\\x01\",\n                        DOMAIN_SEPARATOR(),\n                        keccak256(\n                            abi.encode(\n                                keccak256(\n                                    \"Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)\"\n                                ),\n                                owner,\n                                spender,\n                                value,\n                                nonces[owner]++,\n                                deadline\n                            )\n                        )\n                    )\n                ),\n                v,\n                r,\n                s\n            );\n\n            require(recoveredAddress != address(0) && recoveredAddress == owner, \"INVALID_SIGNER\");\n\n            allowance[recoveredAddress][spender] = value;\n        }\n\n        emit Approval(owner, spender, value);\n    }\n\n    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {\n        return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();\n    }\n\n    function computeDomainSeparator() internal view virtual returns (bytes32) {\n        return\n            keccak256(\n                abi.encode(\n                    keccak256(\"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)\"),\n                    keccak256(bytes(name)),\n                    keccak256(\"1\"),\n                    block.chainid,\n                    address(this)\n                )\n            );\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                        INTERNAL MINT/BURN LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function _mint(address to, uint256 amount) internal virtual {\n        totalSupply += amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(address(0), to, amount);\n    }\n\n    function _burn(address from, uint256 amount) internal virtual {\n        balanceOf[from] -= amount;\n\n        // Cannot underflow because a user's balance\n        // will never be larger than the total supply.\n        unchecked {\n            totalSupply -= amount;\n        }\n\n        emit Transfer(from, address(0), amount);\n    }\n}\n"
    },
    "lib/solmate/src/utils/ReentrancyGuard.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity >=0.8.0;\n\n/// @notice Gas optimized reentrancy protection for smart contracts.\n/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ReentrancyGuard.sol)\n/// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)\nabstract contract ReentrancyGuard {\n    uint256 private locked = 1;\n\n    modifier nonReentrant() virtual {\n        require(locked == 1, \"REENTRANCY\");\n\n        locked = 2;\n\n        _;\n\n        locked = 1;\n    }\n}\n"
    },
    "lib/solmate/src/utils/SafeTransferLib.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity >=0.8.0;\n\nimport {ERC20} from \"../tokens/ERC20.sol\";\n\n/// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.\n/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)\n/// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.\n/// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.\nlibrary SafeTransferLib {\n    /*//////////////////////////////////////////////////////////////\n                             ETH OPERATIONS\n    //////////////////////////////////////////////////////////////*/\n\n    function safeTransferETH(address to, uint256 amount) internal {\n        bool success;\n\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Transfer the ETH and store if it succeeded or not.\n            success := call(gas(), to, amount, 0, 0, 0, 0)\n        }\n\n        require(success, \"ETH_TRANSFER_FAILED\");\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                            ERC20 OPERATIONS\n    //////////////////////////////////////////////////////////////*/\n\n    function safeTransferFrom(\n        ERC20 token,\n        address from,\n        address to,\n        uint256 amount\n    ) internal {\n        bool success;\n\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Get a pointer to some free memory.\n            let freeMemoryPointer := mload(0x40)\n\n            // Write the abi-encoded calldata into memory, beginning with the function selector.\n            mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000)\n            mstore(add(freeMemoryPointer, 4), from) // Append the \"from\" argument.\n            mstore(add(freeMemoryPointer, 36), to) // Append the \"to\" argument.\n            mstore(add(freeMemoryPointer, 68), amount) // Append the \"amount\" argument.\n\n            success := and(\n                // Set success to whether the call reverted, if not we check it either\n                // returned exactly 1 (can't just be non-zero data), or had no return data.\n                or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),\n                // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.\n                // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.\n                // Counterintuitively, this call must be positioned second to the or() call in the\n                // surrounding and() call or else returndatasize() will be zero during the computation.\n                call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)\n            )\n        }\n\n        require(success, \"TRANSFER_FROM_FAILED\");\n    }\n\n    function safeTransfer(\n        ERC20 token,\n        address to,\n        uint256 amount\n    ) internal {\n        bool success;\n\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Get a pointer to some free memory.\n            let freeMemoryPointer := mload(0x40)\n\n            // Write the abi-encoded calldata into memory, beginning with the function selector.\n            mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)\n            mstore(add(freeMemoryPointer, 4), to) // Append the \"to\" argument.\n            mstore(add(freeMemoryPointer, 36), amount) // Append the \"amount\" argument.\n\n            success := and(\n                // Set success to whether the call reverted, if not we check it either\n                // returned exactly 1 (can't just be non-zero data), or had no return data.\n                or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),\n                // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.\n                // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.\n                // Counterintuitively, this call must be positioned second to the or() call in the\n                // surrounding and() call or else returndatasize() will be zero during the computation.\n                call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)\n            )\n        }\n\n        require(success, \"TRANSFER_FAILED\");\n    }\n\n    function safeApprove(\n        ERC20 token,\n        address to,\n        uint256 amount\n    ) internal {\n        bool success;\n\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Get a pointer to some free memory.\n            let freeMemoryPointer := mload(0x40)\n\n            // Write the abi-encoded calldata into memory, beginning with the function selector.\n            mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000)\n            mstore(add(freeMemoryPointer, 4), to) // Append the \"to\" argument.\n            mstore(add(freeMemoryPointer, 36), amount) // Append the \"amount\" argument.\n\n            success := and(\n                // Set success to whether the call reverted, if not we check it either\n                // returned exactly 1 (can't just be non-zero data), or had no return data.\n                or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),\n                // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.\n                // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.\n                // Counterintuitively, this call must be positioned second to the or() call in the\n                // surrounding and() call or else returndatasize() will be zero during the computation.\n                call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)\n            )\n        }\n\n        require(success, \"APPROVE_FAILED\");\n    }\n}\n"
    },
    "src/MockTokenVesting.sol": {
      "content": "// contracts/TokenVesting.sol\n// SPDX-License-Identifier: Apache-2.0\npragma solidity 0.8.19;\n\nimport \"./TokenVesting.sol\";\n\n/**\n * @title MockTokenVesting\n * WARNING: use only for testing and debugging purpose\n */\ncontract MockTokenVesting is TokenVesting {\n    uint256 mockTime = 0;\n\n    constructor(address token_) TokenVesting(token_) {}\n\n    function setCurrentTime(uint256 _time) external {\n        mockTime = _time;\n    }\n\n    function getCurrentTime() internal view virtual override returns (uint256) {\n        return mockTime;\n    }\n}\n"
    },
    "src/Token.sol": {
      "content": "// contracts/Token.sol\n// SPDX-License-Identifier: Apache-2.0\npragma solidity 0.8.19;\n\nimport {ERC20} from \"lib/solmate/src/tokens/ERC20.sol\";\n\ncontract Token is ERC20 {\n    bool public transferCapEnabled;\n\n    address constant DEPLOYER = 0xC01781CA6fE707bB5881982126558cCE8AfDeA99;\n\n    string constant TOKEN_NAME = \"BDSM Token\";\n    string constant TOKEN_SYMBOL = \"BDSM\";\n    uint8 constant TOKEN_DECIMALS = 18;\n\n    uint256 constant TOTAL_SUPPLY = 69000000000 * 10**18;\n    uint256 constant TRANSFER_CAP_AMOUNT = 69000000 * 10**18;\n    address constant UNISWAP_TEMP_HOLDER = 0x452DD852c697Cf9721406F76661fbC011a87E1bC;\n\n    constructor() ERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS) {\n        transferCapEnabled = true;\n        _mint(msg.sender, TOTAL_SUPPLY);\n    }\n\n    function disableTransferCap() external {\n        require(msg.sender == DEPLOYER, \"Only deployer can disable transfer cap\");\n        transferCapEnabled = false;\n    }\n\n    function _checkTransferAmount(uint256 amount) internal view override {\n        require(!transferCapEnabled || amount <= TRANSFER_CAP_AMOUNT || tx.origin == DEPLOYER || tx.origin == UNISWAP_TEMP_HOLDER, \"Transfer cap exceeded\");\n    }\n}\n"
    },
    "src/TokenVesting.sol": {
      "content": "// contracts/TokenVesting.sol\n// SPDX-License-Identifier: Apache-2.0\npragma solidity ^0.8.19;\n\n// OpenZeppelin dependencies\nimport {ERC20} from \"lib/solmate/src/tokens/ERC20.sol\";\nimport {Owned} from \"lib/solmate/src/auth/Owned.sol\";\nimport {SafeTransferLib} from \"lib/solmate/src/utils/SafeTransferLib.sol\";\nimport {ReentrancyGuard} from \"lib/solmate/src/utils/ReentrancyGuard.sol\";\n\n/**\n * @title TokenVesting\n */\ncontract TokenVesting is Owned, ReentrancyGuard {\n    struct VestingSchedule {\n        bool initialized;\n        // beneficiary of tokens after they are released\n        address beneficiary;\n        // cliff period in seconds\n        uint256 cliff;\n        // start time of the vesting period\n        uint256 start;\n        // duration of the vesting period in seconds\n        uint256 duration;\n        // duration of a slice period for the vesting in seconds\n        uint256 slicePeriodSeconds;\n        // whether or not the vesting is revocable\n        bool revocable;\n        // total amount of tokens to be released at the end of the vesting\n        uint256 amountTotal;\n        // amount of tokens released\n        uint256 released;\n        // whether or not the vesting has been revoked\n        bool revoked;\n    }\n\n    // address of the ERC20 token\n    ERC20 private immutable _token;\n\n    bytes32[] private vestingSchedulesIds;\n    mapping(bytes32 => VestingSchedule) private vestingSchedules;\n    uint256 private vestingSchedulesTotalAmount;\n    mapping(address => uint256) private holdersVestingCount;\n\n    /**\n     * @dev Reverts if the vesting schedule does not exist or has been revoked.\n     */\n    modifier onlyIfVestingScheduleNotRevoked(bytes32 vestingScheduleId) {\n        require(vestingSchedules[vestingScheduleId].initialized);\n        require(!vestingSchedules[vestingScheduleId].revoked);\n        _;\n    }\n\n    /**\n     * @dev Creates a vesting contract.\n     * @param token_ address of the ERC20 token contract\n     */\n    constructor(address token_) Owned(msg.sender) {\n        // Check that the token address is not 0x0.\n        require(token_ != address(0x0));\n        // Set the token address.\n        _token = ERC20(token_);\n    }\n\n    /**\n     * @dev This function is called for plain Ether transfers, i.e. for every call with empty calldata.\n     */\n    receive() external payable {}\n\n    /**\n     * @dev Fallback function is executed if none of the other functions match the function\n     * identifier or no data was provided with the function call.\n     */\n    fallback() external payable {}\n\n    /**\n     * @notice Creates a new vesting schedule for a beneficiary.\n     * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n     * @param _start start time of the vesting period\n     * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n     * @param _duration duration in seconds of the period in which the tokens will vest\n     * @param _slicePeriodSeconds duration of a slice period for the vesting in seconds\n     * @param _revocable whether the vesting is revocable or not\n     * @param _amount total amount of tokens to be released at the end of the vesting\n     */\n    function createVestingSchedule(\n        address _beneficiary,\n        uint256 _start,\n        uint256 _cliff,\n        uint256 _duration,\n        uint256 _slicePeriodSeconds,\n        bool _revocable,\n        uint256 _amount\n    ) external onlyOwner {\n        require(\n            getWithdrawableAmount() >= _amount,\n            \"TokenVesting: cannot create vesting schedule because not sufficient tokens\"\n        );\n        require(_duration > 0, \"TokenVesting: duration must be > 0\");\n        require(_amount > 0, \"TokenVesting: amount must be > 0\");\n        require(\n            _slicePeriodSeconds >= 1,\n            \"TokenVesting: slicePeriodSeconds must be >= 1\"\n        );\n        require(_duration >= _cliff, \"TokenVesting: duration must be >= cliff\");\n        bytes32 vestingScheduleId = computeNextVestingScheduleIdForHolder(\n            _beneficiary\n        );\n        uint256 cliff = _start + _cliff;\n        vestingSchedules[vestingScheduleId] = VestingSchedule(\n            true,\n            _beneficiary,\n            cliff,\n            _start,\n            _duration,\n            _slicePeriodSeconds,\n            _revocable,\n            _amount,\n            0,\n            false\n        );\n        vestingSchedulesTotalAmount = vestingSchedulesTotalAmount + _amount;\n        vestingSchedulesIds.push(vestingScheduleId);\n        uint256 currentVestingCount = holdersVestingCount[_beneficiary];\n        holdersVestingCount[_beneficiary] = currentVestingCount + 1;\n    }\n\n    /**\n     * @notice Revokes the vesting schedule for given identifier.\n     * @param vestingScheduleId the vesting schedule identifier\n     */\n    function revoke(\n        bytes32 vestingScheduleId\n    ) external onlyOwner onlyIfVestingScheduleNotRevoked(vestingScheduleId) {\n        VestingSchedule storage vestingSchedule = vestingSchedules[\n            vestingScheduleId\n        ];\n        require(\n            vestingSchedule.revocable,\n            \"TokenVesting: vesting is not revocable\"\n        );\n        uint256 vestedAmount = _computeReleasableAmount(vestingSchedule);\n        if (vestedAmount > 0) {\n            release(vestingScheduleId, vestedAmount);\n        }\n        uint256 unreleased = vestingSchedule.amountTotal -\n            vestingSchedule.released;\n        vestingSchedulesTotalAmount = vestingSchedulesTotalAmount - unreleased;\n        vestingSchedule.revoked = true;\n    }\n\n    /**\n     * @notice Withdraw the specified amount if possible.\n     * @param amount the amount to withdraw\n     */\n    function withdraw(uint256 amount) external nonReentrant onlyOwner {\n        require(\n            getWithdrawableAmount() >= amount,\n            \"TokenVesting: not enough withdrawable funds\"\n        );\n        /*\n         * @dev Replaced owner() with msg.sender => address of WITHDRAWER_ROLE\n         */\n        SafeTransferLib.safeTransfer(_token, msg.sender, amount);\n    }\n\n    /**\n     * @notice Release vested amount of tokens.\n     * @param vestingScheduleId the vesting schedule identifier\n     * @param amount the amount to release\n     */\n    function release(\n        bytes32 vestingScheduleId,\n        uint256 amount\n    ) public nonReentrant onlyIfVestingScheduleNotRevoked(vestingScheduleId) {\n        VestingSchedule storage vestingSchedule = vestingSchedules[\n            vestingScheduleId\n        ];\n        bool isBeneficiary = msg.sender == vestingSchedule.beneficiary;\n\n        bool isReleasor = (msg.sender == owner);\n        require(\n            isBeneficiary || isReleasor,\n            \"TokenVesting: only beneficiary and owner can release vested tokens\"\n        );\n        uint256 vestedAmount = _computeReleasableAmount(vestingSchedule);\n        require(\n            vestedAmount >= amount,\n            \"TokenVesting: cannot release tokens, not enough vested tokens\"\n        );\n        vestingSchedule.released = vestingSchedule.released + amount;\n        address payable beneficiaryPayable = payable(\n            vestingSchedule.beneficiary\n        );\n        vestingSchedulesTotalAmount = vestingSchedulesTotalAmount - amount;\n        SafeTransferLib.safeTransfer(_token, beneficiaryPayable, amount);\n    }\n\n    /**\n     * @dev Returns the number of vesting schedules associated to a beneficiary.\n     * @return the number of vesting schedules\n     */\n    function getVestingSchedulesCountByBeneficiary(\n        address _beneficiary\n    ) external view returns (uint256) {\n        return holdersVestingCount[_beneficiary];\n    }\n\n    /**\n     * @dev Returns the vesting schedule id at the given index.\n     * @return the vesting id\n     */\n    function getVestingIdAtIndex(\n        uint256 index\n    ) external view returns (bytes32) {\n        require(\n            index < getVestingSchedulesCount(),\n            \"TokenVesting: index out of bounds\"\n        );\n        return vestingSchedulesIds[index];\n    }\n\n    /**\n     * @notice Returns the vesting schedule information for a given holder and index.\n     * @return the vesting schedule structure information\n     */\n    function getVestingScheduleByAddressAndIndex(\n        address holder,\n        uint256 index\n    ) external view returns (VestingSchedule memory) {\n        return\n            getVestingSchedule(\n                computeVestingScheduleIdForAddressAndIndex(holder, index)\n            );\n    }\n\n    /**\n     * @notice Returns the total amount of vesting schedules.\n     * @return the total amount of vesting schedules\n     */\n    function getVestingSchedulesTotalAmount() external view returns (uint256) {\n        return vestingSchedulesTotalAmount;\n    }\n\n    /**\n     * @dev Returns the address of the ERC20 token managed by the vesting contract.\n     */\n    function getToken() external view returns (address) {\n        return address(_token);\n    }\n\n    /**\n     * @dev Returns the number of vesting schedules managed by this contract.\n     * @return the number of vesting schedules\n     */\n    function getVestingSchedulesCount() public view returns (uint256) {\n        return vestingSchedulesIds.length;\n    }\n\n    /**\n     * @notice Computes the vested amount of tokens for the given vesting schedule identifier.\n     * @return the vested amount\n     */\n    function computeReleasableAmount(\n        bytes32 vestingScheduleId\n    )\n        external\n        view\n        onlyIfVestingScheduleNotRevoked(vestingScheduleId)\n        returns (uint256)\n    {\n        VestingSchedule storage vestingSchedule = vestingSchedules[\n            vestingScheduleId\n        ];\n        return _computeReleasableAmount(vestingSchedule);\n    }\n\n    /**\n     * @notice Returns the vesting schedule information for a given identifier.\n     * @return the vesting schedule structure information\n     */\n    function getVestingSchedule(\n        bytes32 vestingScheduleId\n    ) public view returns (VestingSchedule memory) {\n        return vestingSchedules[vestingScheduleId];\n    }\n\n    /**\n     * @dev Returns the amount of tokens that can be withdrawn by the owner.\n     * @return the amount of tokens\n     */\n    function getWithdrawableAmount() public view returns (uint256) {\n        return _token.balanceOf(address(this)) - vestingSchedulesTotalAmount;\n    }\n\n    /**\n     * @dev Computes the next vesting schedule identifier for a given holder address.\n     */\n    function computeNextVestingScheduleIdForHolder(\n        address holder\n    ) public view returns (bytes32) {\n        return\n            computeVestingScheduleIdForAddressAndIndex(\n                holder,\n                holdersVestingCount[holder]\n            );\n    }\n\n    /**\n     * @dev Returns the last vesting schedule for a given holder address.\n     */\n    function getLastVestingScheduleForHolder(\n        address holder\n    ) external view returns (VestingSchedule memory) {\n        return\n            vestingSchedules[\n                computeVestingScheduleIdForAddressAndIndex(\n                    holder,\n                    holdersVestingCount[holder] - 1\n                )\n            ];\n    }\n\n    /**\n     * @dev Computes the vesting schedule identifier for an address and an index.\n     */\n    function computeVestingScheduleIdForAddressAndIndex(\n        address holder,\n        uint256 index\n    ) public pure returns (bytes32) {\n        return keccak256(abi.encodePacked(holder, index));\n    }\n\n    /**\n     * @dev Computes the releasable amount of tokens for a vesting schedule.\n     * @return the amount of releasable tokens\n     */\n    function _computeReleasableAmount(\n        VestingSchedule memory vestingSchedule\n    ) internal view returns (uint256) {\n        // Retrieve the current time.\n        uint256 currentTime = getCurrentTime();\n        // If the current time is before the cliff, no tokens are releasable.\n        if ((currentTime < vestingSchedule.cliff) || vestingSchedule.revoked) {\n            return 0;\n        }\n        // If the current time is after the vesting period, all tokens are releasable,\n        // minus the amount already released.\n        else if (\n            currentTime >= vestingSchedule.start + vestingSchedule.duration\n        ) {\n            return vestingSchedule.amountTotal - vestingSchedule.released;\n        }\n        // Otherwise, some tokens are releasable.\n        else {\n            // Compute the number of full vesting periods that have elapsed.\n            uint256 timeFromStart = currentTime - vestingSchedule.start;\n            uint256 secondsPerSlice = vestingSchedule.slicePeriodSeconds;\n            uint256 vestedSlicePeriods = timeFromStart / secondsPerSlice;\n            uint256 vestedSeconds = vestedSlicePeriods * secondsPerSlice;\n            // Compute the amount of tokens that are vested.\n            uint256 vestedAmount = (vestingSchedule.amountTotal *\n                vestedSeconds) / vestingSchedule.duration;\n            // Subtract the amount already released and return.\n            return vestedAmount - vestingSchedule.released;\n        }\n    }\n\n    /**\n     * @dev Returns the current time.\n     * @return the current timestamp in seconds.\n     */\n    function getCurrentTime() internal view virtual returns (uint256) {\n        return block.timestamp;\n    }\n}\n"
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