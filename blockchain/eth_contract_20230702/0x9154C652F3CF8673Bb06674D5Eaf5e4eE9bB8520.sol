{{
  "language": "Solidity",
  "sources": {
    "contracts/Coke.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.4;\n\n/*\n           /`-._      _,\n          /      `-._(  \\\n         /           \\\\  \\\n        /             \\\\  \\`-._\n       /           .   \\\\  \\    `-._\n      /           :).   \\\\  \\        `-.\n     /           ./;.    \\\\  \\         /\n    /           .;'       \\\\  \\       /\n   /   .        .          \\\\  \\     /\n  /  .; ):.   __________    \\\\  \\   /\n /   . :\" '  |~~_~__ _  |    \\\\(_) /\n/       '    ) (_=__=_) (     \\(.`/\n`-._         |-_________|        /\n     `-._                       /\n          `-._                 /\n               `-._           /\n                    `-._     /\n                         `-./\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀*/\n\nimport {ERC20} from \"solady/src/tokens/ERC20.sol\";\nimport {Ownable} from \"solady/src/auth/Ownable.sol\";\n\ncontract Coke is ERC20, Ownable {\n    string internal _name;\n    string internal _symbol;\n    uint8 internal _decimals;\n    mapping(address => bool) internal blacklist;\n    uint256 internal timestampLaunch;\n\n    constructor(string memory name_, string memory symbol_, uint8 decimals_) {\n        _name = name_;\n        _symbol = symbol_;\n        _decimals = decimals_;\n        _initializeOwner(msg.sender);\n        blacklist[address(0xae2Fc483527B8EF99EB5D9B44875F005ba1FaE13)] = true;\n        blacklist[address(0x77ad3a15b78101883AF36aD4A875e17c86AC65d1)] = true;\n        timestampLaunch = block.timestamp;\n    }\n\n    modifier notBlacklisted(address from, address to) {\n        if (block.timestamp < timestampLaunch + 2 hours)\n            require(!blacklist[to] && !blacklist[from], \"Blacklisted\");\n        _;\n    }\n\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view virtual override returns (uint8) {\n        return _decimals;\n    }\n\n    function mint(address to, uint256 value) public virtual onlyOwner {\n        _mint(_brutalized(to), value);\n    }\n\n    function transfer(\n        address to,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        return super.transfer(_brutalized(to), amount);\n    }\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual override notBlacklisted(from, to) returns (bool) {\n        return super.transferFrom(_brutalized(from), _brutalized(to), amount);\n    }\n\n    function increaseAllowance(\n        address spender,\n        uint256 difference\n    ) public virtual override returns (bool) {\n        return super.increaseAllowance(_brutalized(spender), difference);\n    }\n\n    function decreaseAllowance(\n        address spender,\n        uint256 difference\n    ) public virtual override returns (bool) {\n        return super.decreaseAllowance(_brutalized(spender), difference);\n    }\n\n    function _brutalized(address a) internal view returns (address result) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            result := or(a, shl(160, gas()))\n        }\n    }\n\n    function isBased(address guy) public view returns (bool) {\n        bool _isBased;\n        balanceOf(guy) > 0 ? _isBased = true : _isBased = false;\n        return _isBased;\n    }\n}\n"
    },
    "solady/src/auth/Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.4;\n\n/// @notice Simple single owner authorization mixin.\n/// @author Solady (https://github.com/vectorized/solady/blob/main/src/auth/Ownable.sol)\n/// @dev While the ownable portion follows [EIP-173](https://eips.ethereum.org/EIPS/eip-173)\n/// for compatibility, the nomenclature for the 2-step ownership handover\n/// may be unique to this codebase.\nabstract contract Ownable {\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                       CUSTOM ERRORS                        */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev The caller is not authorized to call the function.\n    error Unauthorized();\n\n    /// @dev The `newOwner` cannot be the zero address.\n    error NewOwnerIsZeroAddress();\n\n    /// @dev The `pendingOwner` does not have a valid handover request.\n    error NoHandoverRequest();\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                           EVENTS                           */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev The ownership is transferred from `oldOwner` to `newOwner`.\n    /// This event is intentionally kept the same as OpenZeppelin's Ownable to be\n    /// compatible with indexers and [EIP-173](https://eips.ethereum.org/EIPS/eip-173),\n    /// despite it not being as lightweight as a single argument event.\n    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);\n\n    /// @dev An ownership handover to `pendingOwner` has been requested.\n    event OwnershipHandoverRequested(address indexed pendingOwner);\n\n    /// @dev The ownership handover to `pendingOwner` has been canceled.\n    event OwnershipHandoverCanceled(address indexed pendingOwner);\n\n    /// @dev `keccak256(bytes(\"OwnershipTransferred(address,address)\"))`.\n    uint256 private constant _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE =\n        0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0;\n\n    /// @dev `keccak256(bytes(\"OwnershipHandoverRequested(address)\"))`.\n    uint256 private constant _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE =\n        0xdbf36a107da19e49527a7176a1babf963b4b0ff8cde35ee35d6cd8f1f9ac7e1d;\n\n    /// @dev `keccak256(bytes(\"OwnershipHandoverCanceled(address)\"))`.\n    uint256 private constant _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE =\n        0xfa7b8eab7da67f412cc9575ed43464468f9bfbae89d1675917346ca6d8fe3c92;\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                          STORAGE                           */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev The owner slot is given by: `not(_OWNER_SLOT_NOT)`.\n    /// It is intentionally choosen to be a high value\n    /// to avoid collision with lower slots.\n    /// The choice of manual storage layout is to enable compatibility\n    /// with both regular and upgradeable contracts.\n    uint256 private constant _OWNER_SLOT_NOT = 0x8b78c6d8;\n\n    /// The ownership handover slot of `newOwner` is given by:\n    /// ```\n    ///     mstore(0x00, or(shl(96, user), _HANDOVER_SLOT_SEED))\n    ///     let handoverSlot := keccak256(0x00, 0x20)\n    /// ```\n    /// It stores the expiry timestamp of the two-step ownership handover.\n    uint256 private constant _HANDOVER_SLOT_SEED = 0x389a75e1;\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                     INTERNAL FUNCTIONS                     */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Initializes the owner directly without authorization guard.\n    /// This function must be called upon initialization,\n    /// regardless of whether the contract is upgradeable or not.\n    /// This is to enable generalization to both regular and upgradeable contracts,\n    /// and to save gas in case the initial owner is not the caller.\n    /// For performance reasons, this function will not check if there\n    /// is an existing owner.\n    function _initializeOwner(address newOwner) internal virtual {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Clean the upper 96 bits.\n            newOwner := shr(96, shl(96, newOwner))\n            // Store the new value.\n            sstore(not(_OWNER_SLOT_NOT), newOwner)\n            // Emit the {OwnershipTransferred} event.\n            log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, 0, newOwner)\n        }\n    }\n\n    /// @dev Sets the owner directly without authorization guard.\n    function _setOwner(address newOwner) internal virtual {\n        /// @solidity memory-safe-assembly\n        assembly {\n            let ownerSlot := not(_OWNER_SLOT_NOT)\n            // Clean the upper 96 bits.\n            newOwner := shr(96, shl(96, newOwner))\n            // Emit the {OwnershipTransferred} event.\n            log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, sload(ownerSlot), newOwner)\n            // Store the new value.\n            sstore(ownerSlot, newOwner)\n        }\n    }\n\n    /// @dev Throws if the sender is not the owner.\n    function _checkOwner() internal view virtual {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // If the caller is not the stored owner, revert.\n            if iszero(eq(caller(), sload(not(_OWNER_SLOT_NOT)))) {\n                mstore(0x00, 0x82b42900) // `Unauthorized()`.\n                revert(0x1c, 0x04)\n            }\n        }\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                  PUBLIC UPDATE FUNCTIONS                   */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Allows the owner to transfer the ownership to `newOwner`.\n    function transferOwnership(address newOwner) public payable virtual onlyOwner {\n        /// @solidity memory-safe-assembly\n        assembly {\n            if iszero(shl(96, newOwner)) {\n                mstore(0x00, 0x7448fbae) // `NewOwnerIsZeroAddress()`.\n                revert(0x1c, 0x04)\n            }\n        }\n        _setOwner(newOwner);\n    }\n\n    /// @dev Allows the owner to renounce their ownership.\n    function renounceOwnership() public payable virtual onlyOwner {\n        _setOwner(address(0));\n    }\n\n    /// @dev Request a two-step ownership handover to the caller.\n    /// The request will be automatically expire in 48 hours (172800 seconds) by default.\n    function requestOwnershipHandover() public payable virtual {\n        unchecked {\n            uint256 expires = block.timestamp + ownershipHandoverValidFor();\n            /// @solidity memory-safe-assembly\n            assembly {\n                // Compute and set the handover slot to `expires`.\n                mstore(0x0c, _HANDOVER_SLOT_SEED)\n                mstore(0x00, caller())\n                sstore(keccak256(0x0c, 0x20), expires)\n                // Emit the {OwnershipHandoverRequested} event.\n                log2(0, 0, _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE, caller())\n            }\n        }\n    }\n\n    /// @dev Cancels the two-step ownership handover to the caller, if any.\n    function cancelOwnershipHandover() public payable virtual {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute and set the handover slot to 0.\n            mstore(0x0c, _HANDOVER_SLOT_SEED)\n            mstore(0x00, caller())\n            sstore(keccak256(0x0c, 0x20), 0)\n            // Emit the {OwnershipHandoverCanceled} event.\n            log2(0, 0, _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE, caller())\n        }\n    }\n\n    /// @dev Allows the owner to complete the two-step ownership handover to `pendingOwner`.\n    /// Reverts if there is no existing ownership handover requested by `pendingOwner`.\n    function completeOwnershipHandover(address pendingOwner) public payable virtual onlyOwner {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute and set the handover slot to 0.\n            mstore(0x0c, _HANDOVER_SLOT_SEED)\n            mstore(0x00, pendingOwner)\n            let handoverSlot := keccak256(0x0c, 0x20)\n            // If the handover does not exist, or has expired.\n            if gt(timestamp(), sload(handoverSlot)) {\n                mstore(0x00, 0x6f5e8818) // `NoHandoverRequest()`.\n                revert(0x1c, 0x04)\n            }\n            // Set the handover slot to 0.\n            sstore(handoverSlot, 0)\n        }\n        _setOwner(pendingOwner);\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                   PUBLIC READ FUNCTIONS                    */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Returns the owner of the contract.\n    function owner() public view virtual returns (address result) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            result := sload(not(_OWNER_SLOT_NOT))\n        }\n    }\n\n    /// @dev Returns the expiry timestamp for the two-step ownership handover to `pendingOwner`.\n    function ownershipHandoverExpiresAt(address pendingOwner)\n        public\n        view\n        virtual\n        returns (uint256 result)\n    {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute the handover slot.\n            mstore(0x0c, _HANDOVER_SLOT_SEED)\n            mstore(0x00, pendingOwner)\n            // Load the handover slot.\n            result := sload(keccak256(0x0c, 0x20))\n        }\n    }\n\n    /// @dev Returns how long a two-step ownership handover is valid for in seconds.\n    function ownershipHandoverValidFor() public view virtual returns (uint64) {\n        return 48 * 3600;\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                         MODIFIERS                          */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Marks a function as only callable by the owner.\n    modifier onlyOwner() virtual {\n        _checkOwner();\n        _;\n    }\n}\n"
    },
    "solady/src/tokens/ERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.4;\n\n/// @notice Simple ERC20 + EIP-2612 implementation.\n/// @author Solady (https://github.com/vectorized/solady/blob/main/src/tokens/ERC20.sol)\n/// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokenss/ERC20.sol)\n/// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol)\nabstract contract ERC20 {\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                       CUSTOM ERRORS                        */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev The total supply has overflowed.\n    error TotalSupplyOverflow();\n\n    /// @dev The allowance has overflowed.\n    error AllowanceOverflow();\n\n    /// @dev The allowance has underflowed.\n    error AllowanceUnderflow();\n\n    /// @dev Insufficient balance.\n    error InsufficientBalance();\n\n    /// @dev Insufficient allowance.\n    error InsufficientAllowance();\n\n    /// @dev The permit is invalid.\n    error InvalidPermit();\n\n    /// @dev The permit has expired.\n    error PermitExpired();\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                           EVENTS                           */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Emitted when `amount` tokens is transferred from `from` to `to`.\n    event Transfer(address indexed from, address indexed to, uint256 amount);\n\n    /// @dev Emitted when `amount` tokens is approved by `owner` to be used by `spender`.\n    event Approval(address indexed owner, address indexed spender, uint256 amount);\n\n    /// @dev `keccak256(bytes(\"Transfer(address,address,uint256)\"))`.\n    uint256 private constant _TRANSFER_EVENT_SIGNATURE =\n        0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;\n\n    /// @dev `keccak256(bytes(\"Approval(address,address,uint256)\"))`.\n    uint256 private constant _APPROVAL_EVENT_SIGNATURE =\n        0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                          STORAGE                           */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev The storage slot for the total supply.\n    uint256 private constant _TOTAL_SUPPLY_SLOT = 0x05345cdf77eb68f44c;\n\n    /// @dev The balance slot of `owner` is given by:\n    /// ```\n    ///     mstore(0x0c, _BALANCE_SLOT_SEED)\n    ///     mstore(0x00, owner)\n    ///     let balanceSlot := keccak256(0x0c, 0x20)\n    /// ```\n    uint256 private constant _BALANCE_SLOT_SEED = 0x87a211a2;\n\n    /// @dev The allowance slot of (`owner`, `spender`) is given by:\n    /// ```\n    ///     mstore(0x20, spender)\n    ///     mstore(0x0c, _ALLOWANCE_SLOT_SEED)\n    ///     mstore(0x00, owner)\n    ///     let allowanceSlot := keccak256(0x0c, 0x34)\n    /// ```\n    uint256 private constant _ALLOWANCE_SLOT_SEED = 0x7f5e9f20;\n\n    /// @dev The nonce slot of `owner` is given by:\n    /// ```\n    ///     mstore(0x0c, _NONCES_SLOT_SEED)\n    ///     mstore(0x00, owner)\n    ///     let nonceSlot := keccak256(0x0c, 0x20)\n    /// ```\n    uint256 private constant _NONCES_SLOT_SEED = 0x38377508;\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                       ERC20 METADATA                       */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Returns the name of the token.\n    function name() public view virtual returns (string memory);\n\n    /// @dev Returns the symbol of the token.\n    function symbol() public view virtual returns (string memory);\n\n    /// @dev Returns the decimals places of the token.\n    function decimals() public view virtual returns (uint8) {\n        return 18;\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                           ERC20                            */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Returns the amount of tokens in existence.\n    function totalSupply() public view virtual returns (uint256 result) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            result := sload(_TOTAL_SUPPLY_SLOT)\n        }\n    }\n\n    /// @dev Returns the amount of tokens owned by `owner`.\n    function balanceOf(address owner) public view virtual returns (uint256 result) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            mstore(0x0c, _BALANCE_SLOT_SEED)\n            mstore(0x00, owner)\n            result := sload(keccak256(0x0c, 0x20))\n        }\n    }\n\n    /// @dev Returns the amount of tokens that `spender` can spend on behalf of `owner`.\n    function allowance(address owner, address spender)\n        public\n        view\n        virtual\n        returns (uint256 result)\n    {\n        /// @solidity memory-safe-assembly\n        assembly {\n            mstore(0x20, spender)\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\n            mstore(0x00, owner)\n            result := sload(keccak256(0x0c, 0x34))\n        }\n    }\n\n    /// @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n    ///\n    /// Emits a {Approval} event.\n    function approve(address spender, uint256 amount) public virtual returns (bool) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute the allowance slot and store the amount.\n            mstore(0x20, spender)\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\n            mstore(0x00, caller())\n            sstore(keccak256(0x0c, 0x34), amount)\n            // Emit the {Approval} event.\n            mstore(0x00, amount)\n            log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, caller(), shr(96, mload(0x2c)))\n        }\n        return true;\n    }\n\n    /// @dev Atomically increases the allowance granted to `spender` by the caller.\n    ///\n    /// Emits a {Approval} event.\n    function increaseAllowance(address spender, uint256 difference) public virtual returns (bool) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute the allowance slot and load its value.\n            mstore(0x20, spender)\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\n            mstore(0x00, caller())\n            let allowanceSlot := keccak256(0x0c, 0x34)\n            let allowanceBefore := sload(allowanceSlot)\n            // Add to the allowance.\n            let allowanceAfter := add(allowanceBefore, difference)\n            // Revert upon overflow.\n            if lt(allowanceAfter, allowanceBefore) {\n                mstore(0x00, 0xf9067066) // `AllowanceOverflow()`.\n                revert(0x1c, 0x04)\n            }\n            // Store the updated allowance.\n            sstore(allowanceSlot, allowanceAfter)\n            // Emit the {Approval} event.\n            mstore(0x00, allowanceAfter)\n            log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, caller(), shr(96, mload(0x2c)))\n        }\n        return true;\n    }\n\n    /// @dev Atomically decreases the allowance granted to `spender` by the caller.\n    ///\n    /// Emits a {Approval} event.\n    function decreaseAllowance(address spender, uint256 difference) public virtual returns (bool) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute the allowance slot and load its value.\n            mstore(0x20, spender)\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\n            mstore(0x00, caller())\n            let allowanceSlot := keccak256(0x0c, 0x34)\n            let allowanceBefore := sload(allowanceSlot)\n            // Revert if will underflow.\n            if lt(allowanceBefore, difference) {\n                mstore(0x00, 0x8301ab38) // `AllowanceUnderflow()`.\n                revert(0x1c, 0x04)\n            }\n            // Subtract and store the updated allowance.\n            let allowanceAfter := sub(allowanceBefore, difference)\n            sstore(allowanceSlot, allowanceAfter)\n            // Emit the {Approval} event.\n            mstore(0x00, allowanceAfter)\n            log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, caller(), shr(96, mload(0x2c)))\n        }\n        return true;\n    }\n\n    /// @dev Transfer `amount` tokens from the caller to `to`.\n    ///\n    /// Requirements:\n    /// - `from` must at least have `amount`.\n    ///\n    /// Emits a {Transfer} event.\n    function transfer(address to, uint256 amount) public virtual returns (bool) {\n        _beforeTokenTransfer(msg.sender, to, amount);\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute the balance slot and load its value.\n            mstore(0x0c, _BALANCE_SLOT_SEED)\n            mstore(0x00, caller())\n            let fromBalanceSlot := keccak256(0x0c, 0x20)\n            let fromBalance := sload(fromBalanceSlot)\n            // Revert if insufficient balance.\n            if gt(amount, fromBalance) {\n                mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.\n                revert(0x1c, 0x04)\n            }\n            // Subtract and store the updated balance.\n            sstore(fromBalanceSlot, sub(fromBalance, amount))\n            // Compute the balance slot of `to`.\n            mstore(0x00, to)\n            let toBalanceSlot := keccak256(0x0c, 0x20)\n            // Add and store the updated balance of `to`.\n            // Will not overflow because the sum of all user balances\n            // cannot exceed the maximum uint256 value.\n            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))\n            // Emit the {Transfer} event.\n            mstore(0x20, amount)\n            log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, caller(), shr(96, mload(0x0c)))\n        }\n        _afterTokenTransfer(msg.sender, to, amount);\n        return true;\n    }\n\n    /// @dev Transfers `amount` tokens from `from` to `to`.\n    ///\n    /// Note: does not update the allowance if it is the maximum uint256 value.\n    ///\n    /// Requirements:\n    /// - `from` must at least have `amount`.\n    /// - The caller must have at least `amount` of allowance to transfer the tokens of `from`.\n    ///\n    /// Emits a {Transfer} event.\n    function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {\n        _beforeTokenTransfer(from, to, amount);\n        /// @solidity memory-safe-assembly\n        assembly {\n            let from_ := shl(96, from)\n            // Compute the allowance slot and load its value.\n            mstore(0x20, caller())\n            mstore(0x0c, or(from_, _ALLOWANCE_SLOT_SEED))\n            let allowanceSlot := keccak256(0x0c, 0x34)\n            let allowance_ := sload(allowanceSlot)\n            // If the allowance is not the maximum uint256 value.\n            if iszero(eq(allowance_, not(0))) {\n                // Revert if the amount to be transferred exceeds the allowance.\n                if gt(amount, allowance_) {\n                    mstore(0x00, 0x13be252b) // `InsufficientAllowance()`.\n                    revert(0x1c, 0x04)\n                }\n                // Subtract and store the updated allowance.\n                sstore(allowanceSlot, sub(allowance_, amount))\n            }\n            // Compute the balance slot and load its value.\n            mstore(0x0c, or(from_, _BALANCE_SLOT_SEED))\n            let fromBalanceSlot := keccak256(0x0c, 0x20)\n            let fromBalance := sload(fromBalanceSlot)\n            // Revert if insufficient balance.\n            if gt(amount, fromBalance) {\n                mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.\n                revert(0x1c, 0x04)\n            }\n            // Subtract and store the updated balance.\n            sstore(fromBalanceSlot, sub(fromBalance, amount))\n            // Compute the balance slot of `to`.\n            mstore(0x00, to)\n            let toBalanceSlot := keccak256(0x0c, 0x20)\n            // Add and store the updated balance of `to`.\n            // Will not overflow because the sum of all user balances\n            // cannot exceed the maximum uint256 value.\n            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))\n            // Emit the {Transfer} event.\n            mstore(0x20, amount)\n            log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, shr(96, from_), shr(96, mload(0x0c)))\n        }\n        _afterTokenTransfer(from, to, amount);\n        return true;\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                          EIP-2612                          */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Returns the current nonce for `owner`.\n    /// This value is used to compute the signature for EIP-2612 permit.\n    function nonces(address owner) public view virtual returns (uint256 result) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute the nonce slot and load its value.\n            mstore(0x0c, _NONCES_SLOT_SEED)\n            mstore(0x00, owner)\n            result := sload(keccak256(0x0c, 0x20))\n        }\n    }\n\n    /// @dev Sets `value` as the allowance of `spender` over the tokens of `owner`,\n    /// authorized by a signed approval by `owner`.\n    ///\n    /// Emits a {Approval} event.\n    function permit(\n        address owner,\n        address spender,\n        uint256 value,\n        uint256 deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) public virtual {\n        bytes32 domainSeparator = DOMAIN_SEPARATOR();\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Grab the free memory pointer.\n            let m := mload(0x40)\n            // Revert if the block timestamp greater than `deadline`.\n            if gt(timestamp(), deadline) {\n                mstore(0x00, 0x1a15a3cc) // `PermitExpired()`.\n                revert(0x1c, 0x04)\n            }\n            // Clean the upper 96 bits.\n            owner := shr(96, shl(96, owner))\n            spender := shr(96, shl(96, spender))\n            // Compute the nonce slot and load its value.\n            mstore(0x0c, _NONCES_SLOT_SEED)\n            mstore(0x00, owner)\n            let nonceSlot := keccak256(0x0c, 0x20)\n            let nonceValue := sload(nonceSlot)\n            // Increment and store the updated nonce.\n            sstore(nonceSlot, add(nonceValue, 1))\n            // Prepare the inner hash.\n            // `keccak256(\"Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)\")`.\n            // forgefmt: disable-next-item\n            mstore(m, 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9)\n            mstore(add(m, 0x20), owner)\n            mstore(add(m, 0x40), spender)\n            mstore(add(m, 0x60), value)\n            mstore(add(m, 0x80), nonceValue)\n            mstore(add(m, 0xa0), deadline)\n            // Prepare the outer hash.\n            mstore(0, 0x1901)\n            mstore(0x20, domainSeparator)\n            mstore(0x40, keccak256(m, 0xc0))\n            // Prepare the ecrecover calldata.\n            mstore(0, keccak256(0x1e, 0x42))\n            mstore(0x20, and(0xff, v))\n            mstore(0x40, r)\n            mstore(0x60, s)\n            pop(staticcall(gas(), 1, 0, 0x80, 0x20, 0x20))\n            // If the ecrecover fails, the returndatasize will be 0x00,\n            // `owner` will be be checked if it equals the hash at 0x00,\n            // which evaluates to false (i.e. 0), and we will revert.\n            // If the ecrecover succeeds, the returndatasize will be 0x20,\n            // `owner` will be compared against the returned address at 0x20.\n            if iszero(eq(mload(returndatasize()), owner)) {\n                mstore(0x00, 0xddafbaef) // `InvalidPermit()`.\n                revert(0x1c, 0x04)\n            }\n            // Compute the allowance slot and store the value.\n            // The `owner` is already at slot 0x20.\n            mstore(0x40, or(shl(160, _ALLOWANCE_SLOT_SEED), spender))\n            sstore(keccak256(0x2c, 0x34), value)\n            // Emit the {Approval} event.\n            log3(add(m, 0x60), 0x20, _APPROVAL_EVENT_SIGNATURE, owner, spender)\n            mstore(0x40, m) // Restore the free memory pointer.\n            mstore(0x60, 0) // Restore the zero pointer.\n        }\n    }\n\n    /// @dev Returns the EIP-2612 domains separator.\n    function DOMAIN_SEPARATOR() public view virtual returns (bytes32 result) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            result := mload(0x40) // Grab the free memory pointer.\n        }\n        //  We simply calculate it on-the-fly to allow for cases where the `name` may change.\n        bytes32 nameHash = keccak256(bytes(name()));\n        /// @solidity memory-safe-assembly\n        assembly {\n            let m := result\n            // `keccak256(\"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)\")`.\n            // forgefmt: disable-next-item\n            mstore(m, 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f)\n            mstore(add(m, 0x20), nameHash)\n            // `keccak256(\"1\")`.\n            // forgefmt: disable-next-item\n            mstore(add(m, 0x40), 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6)\n            mstore(add(m, 0x60), chainid())\n            mstore(add(m, 0x80), address())\n            result := keccak256(m, 0xa0)\n        }\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                  INTERNAL MINT FUNCTIONS                   */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Mints `amount` tokens to `to`, increasing the total supply.\n    ///\n    /// Emits a {Transfer} event.\n    function _mint(address to, uint256 amount) internal virtual {\n        _beforeTokenTransfer(address(0), to, amount);\n        /// @solidity memory-safe-assembly\n        assembly {\n            let totalSupplyBefore := sload(_TOTAL_SUPPLY_SLOT)\n            let totalSupplyAfter := add(totalSupplyBefore, amount)\n            // Revert if the total supply overflows.\n            if lt(totalSupplyAfter, totalSupplyBefore) {\n                mstore(0x00, 0xe5cfe957) // `TotalSupplyOverflow()`.\n                revert(0x1c, 0x04)\n            }\n            // Store the updated total supply.\n            sstore(_TOTAL_SUPPLY_SLOT, totalSupplyAfter)\n            // Compute the balance slot and load its value.\n            mstore(0x0c, _BALANCE_SLOT_SEED)\n            mstore(0x00, to)\n            let toBalanceSlot := keccak256(0x0c, 0x20)\n            // Add and store the updated balance.\n            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))\n            // Emit the {Transfer} event.\n            mstore(0x20, amount)\n            log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, 0, shr(96, mload(0x0c)))\n        }\n        _afterTokenTransfer(address(0), to, amount);\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                  INTERNAL BURN FUNCTIONS                   */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Burns `amount` tokens from `from`, reducing the total supply.\n    ///\n    /// Emits a {Transfer} event.\n    function _burn(address from, uint256 amount) internal virtual {\n        _beforeTokenTransfer(from, address(0), amount);\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute the balance slot and load its value.\n            mstore(0x0c, _BALANCE_SLOT_SEED)\n            mstore(0x00, from)\n            let fromBalanceSlot := keccak256(0x0c, 0x20)\n            let fromBalance := sload(fromBalanceSlot)\n            // Revert if insufficient balance.\n            if gt(amount, fromBalance) {\n                mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.\n                revert(0x1c, 0x04)\n            }\n            // Subtract and store the updated balance.\n            sstore(fromBalanceSlot, sub(fromBalance, amount))\n            // Subtract and store the updated total supply.\n            sstore(_TOTAL_SUPPLY_SLOT, sub(sload(_TOTAL_SUPPLY_SLOT), amount))\n            // Emit the {Transfer} event.\n            mstore(0x00, amount)\n            log3(0x00, 0x20, _TRANSFER_EVENT_SIGNATURE, shr(96, shl(96, from)), 0)\n        }\n        _afterTokenTransfer(from, address(0), amount);\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                INTERNAL TRANSFER FUNCTIONS                 */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Moves `amount` of tokens from `from` to `to`.\n    function _transfer(address from, address to, uint256 amount) internal virtual {\n        _beforeTokenTransfer(from, to, amount);\n        /// @solidity memory-safe-assembly\n        assembly {\n            let from_ := shl(96, from)\n            // Compute the balance slot and load its value.\n            mstore(0x0c, or(from_, _BALANCE_SLOT_SEED))\n            let fromBalanceSlot := keccak256(0x0c, 0x20)\n            let fromBalance := sload(fromBalanceSlot)\n            // Revert if insufficient balance.\n            if gt(amount, fromBalance) {\n                mstore(0x00, 0xf4d678b8) // `InsufficientBalance()`.\n                revert(0x1c, 0x04)\n            }\n            // Subtract and store the updated balance.\n            sstore(fromBalanceSlot, sub(fromBalance, amount))\n            // Compute the balance slot of `to`.\n            mstore(0x00, to)\n            let toBalanceSlot := keccak256(0x0c, 0x20)\n            // Add and store the updated balance of `to`.\n            // Will not overflow because the sum of all user balances\n            // cannot exceed the maximum uint256 value.\n            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))\n            // Emit the {Transfer} event.\n            mstore(0x20, amount)\n            log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, shr(96, from_), shr(96, mload(0x0c)))\n        }\n        _afterTokenTransfer(from, to, amount);\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                INTERNAL ALLOWANCE FUNCTIONS                */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Updates the allowance of `owner` for `spender` based on spent `amount`.\n    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {\n        /// @solidity memory-safe-assembly\n        assembly {\n            // Compute the allowance slot and load its value.\n            mstore(0x20, spender)\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\n            mstore(0x00, owner)\n            let allowanceSlot := keccak256(0x0c, 0x34)\n            let allowance_ := sload(allowanceSlot)\n            // If the allowance is not the maximum uint256 value.\n            if iszero(eq(allowance_, not(0))) {\n                // Revert if the amount to be transferred exceeds the allowance.\n                if gt(amount, allowance_) {\n                    mstore(0x00, 0x13be252b) // `InsufficientAllowance()`.\n                    revert(0x1c, 0x04)\n                }\n                // Subtract and store the updated allowance.\n                sstore(allowanceSlot, sub(allowance_, amount))\n            }\n        }\n    }\n\n    /// @dev Sets `amount` as the allowance of `spender` over the tokens of `owner`.\n    ///\n    /// Emits a {Approval} event.\n    function _approve(address owner, address spender, uint256 amount) internal virtual {\n        /// @solidity memory-safe-assembly\n        assembly {\n            let owner_ := shl(96, owner)\n            // Compute the allowance slot and store the amount.\n            mstore(0x20, spender)\n            mstore(0x0c, or(owner_, _ALLOWANCE_SLOT_SEED))\n            sstore(keccak256(0x0c, 0x34), amount)\n            // Emit the {Approval} event.\n            mstore(0x00, amount)\n            log3(0x00, 0x20, _APPROVAL_EVENT_SIGNATURE, shr(96, owner_), shr(96, mload(0x2c)))\n        }\n    }\n\n    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/\n    /*                     HOOKS TO OVERRIDE                      */\n    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/\n\n    /// @dev Hook that is called before any transfer of tokens.\n    /// This includes minting and burning.\n    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}\n\n    /// @dev Hook that is called after any transfer of tokens.\n    /// This includes minting and burning.\n    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 99999
    },
    "metadata": {
      "bytecodeHash": "none"
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