{{
  "language": "Solidity",
  "sources": {
    "src/Prank.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.4;\r\n\r\nabstract contract ERC20 {\r\n    error TotalSupplyOverflow();\r\n\r\n    error AllowanceOverflow();\r\n\r\n    error AllowanceUnderflow();\r\n\r\n    error InsufficientBalance();\r\n\r\n    error InsufficientAllowance();\r\n\r\n    error InvalidPermit();\r\n\r\n    error PermitExpired();\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 amount);\r\n\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 amount\r\n    );\r\n\r\n    uint256 private constant _TRANSFER_EVENT_SIGNATURE =\r\n        0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;\r\n\r\n    uint256 private constant _APPROVAL_EVENT_SIGNATURE =\r\n        0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;\r\n\r\n    uint256 private constant _TOTAL_SUPPLY_SLOT = 0x05345cdf77eb68f44c;\r\n\r\n    uint256 private constant _BALANCE_SLOT_SEED = 0x87a211a2;\r\n\r\n    uint256 private constant _ALLOWANCE_SLOT_SEED = 0x7f5e9f20;\r\n\r\n    uint256 private constant _NONCES_SLOT_SEED = 0x38377508;\r\n\r\n    function name() public view virtual returns (string memory);\r\n\r\n    function symbol() public view virtual returns (string memory);\r\n\r\n    function decimals() public view virtual returns (uint8) {\r\n        return 18;\r\n    }\r\n\r\n    function totalSupply() public view virtual returns (uint256 result) {\r\n        assembly {\r\n            result := sload(_TOTAL_SUPPLY_SLOT)\r\n        }\r\n    }\r\n\r\n    function balanceOf(\r\n        address owner\r\n    ) public view virtual returns (uint256 result) {\r\n        assembly {\r\n            mstore(0x0c, _BALANCE_SLOT_SEED)\r\n            mstore(0x00, owner)\r\n            result := sload(keccak256(0x0c, 0x20))\r\n        }\r\n    }\r\n\r\n    function allowance(\r\n        address owner,\r\n        address spender\r\n    ) public view virtual returns (uint256 result) {\r\n        assembly {\r\n            mstore(0x20, spender)\r\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\r\n            mstore(0x00, owner)\r\n            result := sload(keccak256(0x0c, 0x34))\r\n        }\r\n    }\r\n\r\n    function approve(\r\n        address spender,\r\n        uint256 amount\r\n    ) public virtual returns (bool) {\r\n        assembly {\r\n            mstore(0x20, spender)\r\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\r\n            mstore(0x00, caller())\r\n            sstore(keccak256(0x0c, 0x34), amount)\r\n\r\n            mstore(0x00, amount)\r\n            log3(\r\n                0x00,\r\n                0x20,\r\n                _APPROVAL_EVENT_SIGNATURE,\r\n                caller(),\r\n                shr(96, mload(0x2c))\r\n            )\r\n        }\r\n        return true;\r\n    }\r\n\r\n    function increaseAllowance(\r\n        address spender,\r\n        uint256 difference\r\n    ) public virtual returns (bool) {\r\n        assembly {\r\n            mstore(0x20, spender)\r\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\r\n            mstore(0x00, caller())\r\n            let allowanceSlot := keccak256(0x0c, 0x34)\r\n            let allowanceBefore := sload(allowanceSlot)\r\n\r\n            let allowanceAfter := add(allowanceBefore, difference)\r\n\r\n            if lt(allowanceAfter, allowanceBefore) {\r\n                mstore(0x00, 0xf9067066)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            sstore(allowanceSlot, allowanceAfter)\r\n\r\n            mstore(0x00, allowanceAfter)\r\n            log3(\r\n                0x00,\r\n                0x20,\r\n                _APPROVAL_EVENT_SIGNATURE,\r\n                caller(),\r\n                shr(96, mload(0x2c))\r\n            )\r\n        }\r\n        return true;\r\n    }\r\n\r\n    function decreaseAllowance(\r\n        address spender,\r\n        uint256 difference\r\n    ) public virtual returns (bool) {\r\n        assembly {\r\n            mstore(0x20, spender)\r\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\r\n            mstore(0x00, caller())\r\n            let allowanceSlot := keccak256(0x0c, 0x34)\r\n            let allowanceBefore := sload(allowanceSlot)\r\n\r\n            if lt(allowanceBefore, difference) {\r\n                mstore(0x00, 0x8301ab38)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            let allowanceAfter := sub(allowanceBefore, difference)\r\n            sstore(allowanceSlot, allowanceAfter)\r\n\r\n            mstore(0x00, allowanceAfter)\r\n            log3(\r\n                0x00,\r\n                0x20,\r\n                _APPROVAL_EVENT_SIGNATURE,\r\n                caller(),\r\n                shr(96, mload(0x2c))\r\n            )\r\n        }\r\n        return true;\r\n    }\r\n\r\n    function transfer(\r\n        address to,\r\n        uint256 amount\r\n    ) public virtual returns (bool) {\r\n        _beforeTokenTransfer(msg.sender, to, amount);\r\n\r\n        assembly {\r\n            mstore(0x0c, _BALANCE_SLOT_SEED)\r\n            mstore(0x00, caller())\r\n            let fromBalanceSlot := keccak256(0x0c, 0x20)\r\n            let fromBalance := sload(fromBalanceSlot)\r\n\r\n            if gt(amount, fromBalance) {\r\n                mstore(0x00, 0xf4d678b8)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            sstore(fromBalanceSlot, sub(fromBalance, amount))\r\n\r\n            mstore(0x00, to)\r\n            let toBalanceSlot := keccak256(0x0c, 0x20)\r\n\r\n            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))\r\n\r\n            mstore(0x20, amount)\r\n            log3(\r\n                0x20,\r\n                0x20,\r\n                _TRANSFER_EVENT_SIGNATURE,\r\n                caller(),\r\n                shr(96, mload(0x0c))\r\n            )\r\n        }\r\n        _afterTokenTransfer(msg.sender, to, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) public virtual returns (bool) {\r\n        _beforeTokenTransfer(from, to, amount);\r\n\r\n        assembly {\r\n            let from_ := shl(96, from)\r\n\r\n            mstore(0x20, caller())\r\n            mstore(0x0c, or(from_, _ALLOWANCE_SLOT_SEED))\r\n            let allowanceSlot := keccak256(0x0c, 0x34)\r\n            let allowance_ := sload(allowanceSlot)\r\n\r\n            if iszero(eq(allowance_, not(0))) {\r\n                if gt(amount, allowance_) {\r\n                    mstore(0x00, 0x13be252b)\r\n                    revert(0x1c, 0x04)\r\n                }\r\n\r\n                sstore(allowanceSlot, sub(allowance_, amount))\r\n            }\r\n\r\n            mstore(0x0c, or(from_, _BALANCE_SLOT_SEED))\r\n            let fromBalanceSlot := keccak256(0x0c, 0x20)\r\n            let fromBalance := sload(fromBalanceSlot)\r\n\r\n            if gt(amount, fromBalance) {\r\n                mstore(0x00, 0xf4d678b8)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            sstore(fromBalanceSlot, sub(fromBalance, amount))\r\n\r\n            mstore(0x00, to)\r\n            let toBalanceSlot := keccak256(0x0c, 0x20)\r\n\r\n            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))\r\n\r\n            mstore(0x20, amount)\r\n            log3(\r\n                0x20,\r\n                0x20,\r\n                _TRANSFER_EVENT_SIGNATURE,\r\n                shr(96, from_),\r\n                shr(96, mload(0x0c))\r\n            )\r\n        }\r\n        _afterTokenTransfer(from, to, amount);\r\n        return true;\r\n    }\r\n\r\n    function nonces(\r\n        address owner\r\n    ) public view virtual returns (uint256 result) {\r\n        assembly {\r\n            mstore(0x0c, _NONCES_SLOT_SEED)\r\n            mstore(0x00, owner)\r\n            result := sload(keccak256(0x0c, 0x20))\r\n        }\r\n    }\r\n\r\n    function permit(\r\n        address owner,\r\n        address spender,\r\n        uint256 value,\r\n        uint256 deadline,\r\n        uint8 v,\r\n        bytes32 r,\r\n        bytes32 s\r\n    ) public virtual {\r\n        bytes32 domainSeparator = DOMAIN_SEPARATOR();\r\n\r\n        assembly {\r\n            let m := mload(0x40)\r\n\r\n            if gt(timestamp(), deadline) {\r\n                mstore(0x00, 0x1a15a3cc)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            owner := shr(96, shl(96, owner))\r\n            spender := shr(96, shl(96, spender))\r\n\r\n            mstore(0x0c, _NONCES_SLOT_SEED)\r\n            mstore(0x00, owner)\r\n            let nonceSlot := keccak256(0x0c, 0x20)\r\n            let nonceValue := sload(nonceSlot)\r\n\r\n            sstore(nonceSlot, add(nonceValue, 1))\r\n\r\n            mstore(\r\n                m,\r\n                0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9\r\n            )\r\n            mstore(add(m, 0x20), owner)\r\n            mstore(add(m, 0x40), spender)\r\n            mstore(add(m, 0x60), value)\r\n            mstore(add(m, 0x80), nonceValue)\r\n            mstore(add(m, 0xa0), deadline)\r\n\r\n            mstore(0, 0x1901)\r\n            mstore(0x20, domainSeparator)\r\n            mstore(0x40, keccak256(m, 0xc0))\r\n\r\n            mstore(0, keccak256(0x1e, 0x42))\r\n            mstore(0x20, and(0xff, v))\r\n            mstore(0x40, r)\r\n            mstore(0x60, s)\r\n            pop(staticcall(gas(), 1, 0, 0x80, 0x20, 0x20))\r\n\r\n            if iszero(eq(mload(returndatasize()), owner)) {\r\n                mstore(0x00, 0xddafbaef)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            mstore(0x40, or(shl(160, _ALLOWANCE_SLOT_SEED), spender))\r\n            sstore(keccak256(0x2c, 0x34), value)\r\n\r\n            log3(add(m, 0x60), 0x20, _APPROVAL_EVENT_SIGNATURE, owner, spender)\r\n            mstore(0x40, m)\r\n            mstore(0x60, 0)\r\n        }\r\n    }\r\n\r\n    function DOMAIN_SEPARATOR() public view virtual returns (bytes32 result) {\r\n        assembly {\r\n            result := mload(0x40)\r\n        }\r\n\r\n        bytes32 nameHash = keccak256(bytes(name()));\r\n\r\n        assembly {\r\n            let m := result\r\n\r\n            mstore(\r\n                m,\r\n                0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f\r\n            )\r\n            mstore(add(m, 0x20), nameHash)\r\n\r\n            mstore(\r\n                add(m, 0x40),\r\n                0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6\r\n            )\r\n            mstore(add(m, 0x60), chainid())\r\n            mstore(add(m, 0x80), address())\r\n            result := keccak256(m, 0xa0)\r\n        }\r\n    }\r\n\r\n    function _mint(address to, uint256 amount) internal virtual {\r\n        _beforeTokenTransfer(address(0), to, amount);\r\n\r\n        assembly {\r\n            let totalSupplyBefore := sload(_TOTAL_SUPPLY_SLOT)\r\n            let totalSupplyAfter := add(totalSupplyBefore, amount)\r\n\r\n            if lt(totalSupplyAfter, totalSupplyBefore) {\r\n                mstore(0x00, 0xe5cfe957)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            sstore(_TOTAL_SUPPLY_SLOT, totalSupplyAfter)\r\n\r\n            mstore(0x0c, _BALANCE_SLOT_SEED)\r\n            mstore(0x00, to)\r\n            let toBalanceSlot := keccak256(0x0c, 0x20)\r\n\r\n            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))\r\n\r\n            mstore(0x20, amount)\r\n            log3(0x20, 0x20, _TRANSFER_EVENT_SIGNATURE, 0, shr(96, mload(0x0c)))\r\n        }\r\n        _afterTokenTransfer(address(0), to, amount);\r\n    }\r\n\r\n    function _burn(address from, uint256 amount) internal virtual {\r\n        _beforeTokenTransfer(from, address(0), amount);\r\n\r\n        assembly {\r\n            mstore(0x0c, _BALANCE_SLOT_SEED)\r\n            mstore(0x00, from)\r\n            let fromBalanceSlot := keccak256(0x0c, 0x20)\r\n            let fromBalance := sload(fromBalanceSlot)\r\n\r\n            if gt(amount, fromBalance) {\r\n                mstore(0x00, 0xf4d678b8)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            sstore(fromBalanceSlot, sub(fromBalance, amount))\r\n\r\n            sstore(_TOTAL_SUPPLY_SLOT, sub(sload(_TOTAL_SUPPLY_SLOT), amount))\r\n\r\n            mstore(0x00, amount)\r\n            log3(\r\n                0x00,\r\n                0x20,\r\n                _TRANSFER_EVENT_SIGNATURE,\r\n                shr(96, shl(96, from)),\r\n                0\r\n            )\r\n        }\r\n        _afterTokenTransfer(from, address(0), amount);\r\n    }\r\n\r\n    function _transfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        _beforeTokenTransfer(from, to, amount);\r\n\r\n        assembly {\r\n            let from_ := shl(96, from)\r\n\r\n            mstore(0x0c, or(from_, _BALANCE_SLOT_SEED))\r\n            let fromBalanceSlot := keccak256(0x0c, 0x20)\r\n            let fromBalance := sload(fromBalanceSlot)\r\n\r\n            if gt(amount, fromBalance) {\r\n                mstore(0x00, 0xf4d678b8)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            sstore(fromBalanceSlot, sub(fromBalance, amount))\r\n\r\n            mstore(0x00, to)\r\n            let toBalanceSlot := keccak256(0x0c, 0x20)\r\n\r\n            sstore(toBalanceSlot, add(sload(toBalanceSlot), amount))\r\n\r\n            mstore(0x20, amount)\r\n            log3(\r\n                0x20,\r\n                0x20,\r\n                _TRANSFER_EVENT_SIGNATURE,\r\n                shr(96, from_),\r\n                shr(96, mload(0x0c))\r\n            )\r\n        }\r\n        _afterTokenTransfer(from, to, amount);\r\n    }\r\n\r\n    function _spendAllowance(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        assembly {\r\n            mstore(0x20, spender)\r\n            mstore(0x0c, _ALLOWANCE_SLOT_SEED)\r\n            mstore(0x00, owner)\r\n            let allowanceSlot := keccak256(0x0c, 0x34)\r\n            let allowance_ := sload(allowanceSlot)\r\n\r\n            if iszero(eq(allowance_, not(0))) {\r\n                if gt(amount, allowance_) {\r\n                    mstore(0x00, 0x13be252b)\r\n                    revert(0x1c, 0x04)\r\n                }\r\n\r\n                sstore(allowanceSlot, sub(allowance_, amount))\r\n            }\r\n        }\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        assembly {\r\n            let owner_ := shl(96, owner)\r\n\r\n            mstore(0x20, spender)\r\n            mstore(0x0c, or(owner_, _ALLOWANCE_SLOT_SEED))\r\n            sstore(keccak256(0x0c, 0x34), amount)\r\n\r\n            mstore(0x00, amount)\r\n            log3(\r\n                0x00,\r\n                0x20,\r\n                _APPROVAL_EVENT_SIGNATURE,\r\n                shr(96, owner_),\r\n                shr(96, mload(0x2c))\r\n            )\r\n        }\r\n    }\r\n\r\n    function _beforeTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n\r\n    function _afterTokenTransfer(\r\n        address from,\r\n        address to,\r\n        uint256 amount\r\n    ) internal virtual {}\r\n}\r\n\r\nabstract contract Ownable {\r\n    error Unauthorized();\r\n\r\n    error NewOwnerIsZeroAddress();\r\n\r\n    error NoHandoverRequest();\r\n\r\n    event OwnershipTransferred(\r\n        address indexed oldOwner,\r\n        address indexed newOwner\r\n    );\r\n\r\n    event OwnershipHandoverRequested(address indexed pendingOwner);\r\n\r\n    event OwnershipHandoverCanceled(address indexed pendingOwner);\r\n\r\n    uint256 private constant _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE =\r\n        0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0;\r\n\r\n    uint256 private constant _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE =\r\n        0xdbf36a107da19e49527a7176a1babf963b4b0ff8cde35ee35d6cd8f1f9ac7e1d;\r\n\r\n    uint256 private constant _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE =\r\n        0xfa7b8eab7da67f412cc9575ed43464468f9bfbae89d1675917346ca6d8fe3c92;\r\n\r\n    uint256 private constant _OWNER_SLOT_NOT = 0x8b78c6d8;\r\n\r\n    uint256 private constant _HANDOVER_SLOT_SEED = 0x389a75e1;\r\n\r\n    function _initializeOwner(address newOwner) internal virtual {\r\n        assembly {\r\n            newOwner := shr(96, shl(96, newOwner))\r\n\r\n            sstore(not(_OWNER_SLOT_NOT), newOwner)\r\n\r\n            log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, 0, newOwner)\r\n        }\r\n    }\r\n\r\n    function _setOwner(address newOwner) internal virtual {\r\n        assembly {\r\n            let ownerSlot := not(_OWNER_SLOT_NOT)\r\n\r\n            newOwner := shr(96, shl(96, newOwner))\r\n\r\n            log3(\r\n                0,\r\n                0,\r\n                _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE,\r\n                sload(ownerSlot),\r\n                newOwner\r\n            )\r\n\r\n            sstore(ownerSlot, newOwner)\r\n        }\r\n    }\r\n\r\n    function _checkOwner() internal view virtual {\r\n        assembly {\r\n            if iszero(eq(caller(), sload(not(_OWNER_SLOT_NOT)))) {\r\n                mstore(0x00, 0x82b42900)\r\n                revert(0x1c, 0x04)\r\n            }\r\n        }\r\n    }\r\n\r\n    function transferOwnership(\r\n        address newOwner\r\n    ) public payable virtual onlyOwner {\r\n        assembly {\r\n            if iszero(shl(96, newOwner)) {\r\n                mstore(0x00, 0x7448fbae)\r\n                revert(0x1c, 0x04)\r\n            }\r\n        }\r\n        _setOwner(newOwner);\r\n    }\r\n\r\n    function renounceOwnership() public payable virtual onlyOwner {\r\n        _setOwner(address(0));\r\n    }\r\n\r\n    function requestOwnershipHandover() public payable virtual {\r\n        unchecked {\r\n            uint256 expires = block.timestamp + ownershipHandoverValidFor();\r\n\r\n            assembly {\r\n                mstore(0x0c, _HANDOVER_SLOT_SEED)\r\n                mstore(0x00, caller())\r\n                sstore(keccak256(0x0c, 0x20), expires)\r\n\r\n                log2(\r\n                    0,\r\n                    0,\r\n                    _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE,\r\n                    caller()\r\n                )\r\n            }\r\n        }\r\n    }\r\n\r\n    function cancelOwnershipHandover() public payable virtual {\r\n        assembly {\r\n            mstore(0x0c, _HANDOVER_SLOT_SEED)\r\n            mstore(0x00, caller())\r\n            sstore(keccak256(0x0c, 0x20), 0)\r\n\r\n            log2(0, 0, _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE, caller())\r\n        }\r\n    }\r\n\r\n    function completeOwnershipHandover(\r\n        address pendingOwner\r\n    ) public payable virtual onlyOwner {\r\n        assembly {\r\n            mstore(0x0c, _HANDOVER_SLOT_SEED)\r\n            mstore(0x00, pendingOwner)\r\n            let handoverSlot := keccak256(0x0c, 0x20)\r\n\r\n            if gt(timestamp(), sload(handoverSlot)) {\r\n                mstore(0x00, 0x6f5e8818)\r\n                revert(0x1c, 0x04)\r\n            }\r\n\r\n            sstore(handoverSlot, 0)\r\n        }\r\n        _setOwner(pendingOwner);\r\n    }\r\n\r\n    function owner() public view virtual returns (address result) {\r\n        assembly {\r\n            result := sload(not(_OWNER_SLOT_NOT))\r\n        }\r\n    }\r\n\r\n    function ownershipHandoverExpiresAt(\r\n        address pendingOwner\r\n    ) public view virtual returns (uint256 result) {\r\n        assembly {\r\n            mstore(0x0c, _HANDOVER_SLOT_SEED)\r\n            mstore(0x00, pendingOwner)\r\n\r\n            result := sload(keccak256(0x0c, 0x20))\r\n        }\r\n    }\r\n\r\n    function ownershipHandoverValidFor() public view virtual returns (uint64) {\r\n        return 48 * 3600;\r\n    }\r\n\r\n    modifier onlyOwner() virtual {\r\n        _checkOwner();\r\n        _;\r\n    }\r\n}\r\n\r\ncontract Prank is ERC20, Ownable {\r\n    uint private constant _numTokens = 1_000_000_000_000_000;\r\n\r\n    constructor() {\r\n        _initializeOwner(msg.sender);\r\n        _mint(msg.sender, _numTokens * (10 ** 18));\r\n    }\r\n\r\n    function name() public view virtual override returns (string memory) {\r\n        return \"ITS JUST A PRANK BRO\";\r\n    }\r\n\r\n    function symbol() public view virtual override returns (string memory) {\r\n        return \"PRANK\";\r\n    }\r\n\r\n    function burn(uint256 amount) public {\r\n        _burn(msg.sender, amount);\r\n    }\r\n}\r\n"
    }
  },
  "settings": {
    "remappings": [
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/",
      "openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/",
      "solady/=lib/solady/src/",
      "solmate/=lib/solady/lib/solmate/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 1000000
    },
    "metadata": {
      "bytecodeHash": "none",
      "appendCBOR": true
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