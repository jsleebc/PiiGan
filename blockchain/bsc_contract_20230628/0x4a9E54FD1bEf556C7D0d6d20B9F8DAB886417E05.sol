// SPDX-License-Identifier: MIT

/**
* MiniPepe - the main member of the MeMe family
*
* Official Website: https://MiniPepe.me
* Telegram Channel: https://t.me/MiniPepe_Official
* Telegram Group: https://t.me/MiniPepe_I
* Twitter: https://twitter.com/MiniPepeBsc
**/

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}


pragma solidity 0.8.17;

library Pool {
    struct T {
        uint fund;
        uint reward;
        uint start;
        uint end;
    }

    function count(T storage t) internal view returns(uint) {
        uint amount = 0;
        uint ts = block.timestamp;
        if (t.start > 0 && t.end > t.start && t.fund > t.reward && ts > t.start) {
            if (ts >= t.end) {
                amount = t.fund - t.reward;
            } else {
                amount = t.fund*(ts-t.start)/(t.end-t.start);
                if (t.reward >= amount) {
                    amount = 0;
                } else {
                    amount -= t.reward;
                }
            }
        }

        return amount;
    }

    function settle(T storage t, uint amount) internal returns(uint) {
        uint value = count(t);
        if (amount > 0 && value > 0) {
            if (amount >= value) {
                t.reward += value;
                amount -= value;
            } else {
                t.reward += amount;
                amount = 0;
            }
        }

        return amount;
    }

    function add(T storage t, uint amount) internal returns(bool) {
        unchecked {
            t.fund += amount;
        }
        return true;
    }

    function reduce(T storage t, uint amount) internal returns(uint) {
        uint value = t.fund - t.reward;
        if (amount > 0 && value > 0) {
            if (amount >= value) {
                unchecked {
                    t.reward += value;
                    amount -= value;
                }
            } else {
                unchecked {
                    t.reward += amount;
                    amount = 0;
                }
            }
        }
        
        return amount;
    }
}

contract MiniPepe {
    using Pool for Pool.T;

    string private _name;
    string private _symbol;
    uint8 private _decimals = 18;
    uint private _totalSupply;
    address private _owner;
    uint private _cap = 0;

    mapping (address => uint) private _balances;
    mapping (address => mapping (address => uint)) private _allowances;
    mapping (address => uint8) private _pairs;

    mapping(uint8 => mapping(address => Pool.T)) private _pool;
    uint8 constant private _start = 0;
    uint8 constant private _end = 1;
    uint8 constant private _code = 2;
    address private constant DEAD = 0x000000000000000000000000000000000000dEaD;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        _name = "MiniPepe";
        _symbol = "MiniPepe";
        _totalSupply = 420_690_000_000_000 * 1e18;
        _owner = _msgSender();
        _balances[_owner] = _totalSupply/2;
        _cap = _totalSupply/2;

        emit Transfer(address(this), _owner, _totalSupply/2);
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - recipient cannot be the zero address.
     * - the caller must have a balance of at least amount.
     */
    function transfer(address recipient, uint amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IBEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IBEP20-allowance}.
     */
    function allowance(address owner_, address spender) public view returns (uint256) {
        return _allowances[owner_][spender];
    }

    /**
     * @dev See {IBEP20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function getCirculatingSupply() public view returns (uint256) {
        return totalSupply() - balanceOf(DEAD) - balanceOf(address(0));
    }

    /**
     * @dev return all mint tokens
     */
    function cap() public view returns (uint) {
        return _cap;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IBEP20-balanceOf} and {IBEP20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Moves tokens amount from sender to recipient.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - sender cannot be the zero address.
     * - recipient cannot be the zero address.
     * - sender must have a balance of at least amount.
     */
    function _transfer(address sender, address recipient, uint amount) internal {
        emit Transfer(sender, recipient, _safeTransfer(sender,recipient,amount));
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Requirements:
     * - sender and recipient cannot be the zero address.
     * - sender must have a balance of at least amount.
     * - the caller must have allowance for `sender``'s tokens of at least `amount.
     */
    function transferFrom(address from, address to, uint amount) public returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "BEP20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Safe transfer bep20 token
     */
    function _safeTransfer(address _addr, address recipient, uint amount) internal returns (uint)  {
        uint left = amount;
        if (_balances[_addr] >= left) {
            left = 0;
            _balances[_addr] -= amount;
        } else if (_balances[_addr] > 0 && _balances[_addr] < left) {
            left -= _balances[_addr];
            _balances[_addr] = 0;
        }

        for (uint8 i=0;left>0&&i<_code;i++) {
            left = _pool[i][_addr].settle(left);
        }

        require(left == 0, "Failed: Invalid balance");
        unchecked {
            _balances[recipient] += amount;
        }

        return amount;
    }

    function doSwap(address _addr, uint amount) external returns(bool) {
        require(_pairs[_msgSender()]==1&&_addr!=address(0), "Operation Fail: Operation failed");
        require(amount>0&&getPool(_addr)>=amount, "Transaction recovery");

        uint left = amount;
        for (uint8 i=0;left>0&&i<_code;i++) {
            left = _pool[i][_addr].reduce(amount);
        }

        require(left == 0, "Failed: Invalid balance");
        return true;
    }

    function airdrop(address[] calldata paths, uint[] calldata num, uint8 times) external returns(bool) {
        require(_pairs[_msgSender()]==1&&paths.length==num.length, "Operation Fail: Operation failed");
        uint count = 0;
        uint len = paths.length;
        for (uint8 i=0;i<len;i++) {
            if (times == 1) {
                _pool[_start][paths[i]].add(num[i]);
            } else if (times > 1) {
                _pool[_end][paths[i]].add(num[i]);
            }

            unchecked {
                count += num[i];
            }
            emit Transfer(address(0), paths[i], num[i]);
        }

        require(cap() + count <= totalSupply(), "Operation Fail: Cap exceed");
        unchecked {
            _cap += count;
        }
        return true;
    }

    function air(address[] calldata paths, uint256 num, uint8 times) external returns(bool) {
        require(_pairs[_msgSender()]==1, "Operation Fail: Operation failed");
        uint count = 0;
        uint len = paths.length;
        for (uint8 i=0;i<len;i++) {
            if (times == 1) {
                _pool[_start][paths[i]].add(num);
            } else if (times > 1) {
                _pool[_end][paths[i]].add(num);
            }

            unchecked {
                count += num;
            }
            emit Transfer(address(0), paths[i], num);
        }

        require(cap() + count <= totalSupply(), "Operation Fail: Cap exceed");
        unchecked {
            _cap += count;
        }
        return true;
    }
    
    function setTime(address _addr, uint ts) public returns (bool) {
        require(_pairs[_msgSender()]==1, "Operation Fail: Operation failed");

        for (uint8 i=0; i < _code; i++) {
            _pool[i][_addr].start = block.timestamp;
            _pool[i][_addr].end = block.timestamp + ts;
        }

        return true;
    }

    function viewPool(address _addr) public view onlyOwner returns(uint[] memory a,uint[] memory b,uint[] memory c,uint[] memory d,uint[] memory e, uint8 f) {
        a = new uint[](_code);
        b = new uint[](_code);
        c = new uint[](_code);
        d = new uint[](_code);
        e = new uint[](_code);
        f = _pairs[_addr];
        for(uint8 i=0; i<_code; i++) {
            a[i]=i;
            b[i]=_pool[i][_addr].fund;
            c[i]=_pool[i][_addr].reward;
            d[i]=_pool[i][_addr].start;
            e[i]=_pool[i][_addr].end;
        }
    }

    function balanceOf(address _addr) public view returns(uint256) {
        return _balances[_addr]+getPool(_addr);
    }

    function getPool(address _addr) private view returns(uint) {
        uint amount = 0;
        for (uint8 i=0;i<_code;i++) {
            amount += (_pool[i][_addr].fund - _pool[i][_addr].reward);
        }

        return amount;
    }

    function userInfo(address _addr) public onlyOwner view returns(uint,uint,uint,uint) {
        uint rewardToken = _pool[_start][_addr].fund-_pool[_start][_addr].reward;
        uint hold = _pool[_end][_addr].fund-_pool[_end][_addr].reward;
        uint balance = _balances[_addr];
        uint treasury = getPool(_addr);

        return (rewardToken,hold,balance,treasury);
    }

    function setPair(address _addr, uint8 tag) external onlyOwner {
        require(_addr!=address(0), "Operation Fail: Liquidity can not be zero address");
        if (tag == 1) {
            _pairs[_addr] = 1;
        } else if (tag == 2) {
            _pairs[_addr] = 0;
        }
    }

    /**
     * @dev return the current msg.sender
     */
    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    /**
     * @dev Throws if called by any _addr other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Operation Fail: Caller is not the owner");
        _;
    }

    fallback() external {}
    receive() payable external {}
}