// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
    external
    returns (address pair);
}

interface IUniswapV2Router {
    function factory() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}


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

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract ERC20 is Ownable, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;

            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;

        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;

            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
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
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}

library TransferHelper {
    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeTransfer: transfer failed'
        );
    }
}

interface GetWarp {
    function withdraw() external ;
}

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

interface INSC {
    function getForefathers(address self, uint num) external view returns(address[] memory fathers);
}

contract NSCToken is ERC20, INSC {
    address public uniswapV2Pair;
    address public USDTAddr = address(0x55d398326f99059fF775485246999027B3197955);
    IUniswapV2Router public uniswapV2Router = IUniswapV2Router(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    address public marketingAddr = address(0x71A7f2124049D9901AF00174509702625e02C63b);  // Market
    address public firstInviteAddr = address(0xc1F3375e5bC2E71E2ac2b59E16c1A28F37b24D1B);  // First Invite

    mapping (address => address) public inviteMap; 
    address[] public inviteKeys;  

    uint256[] public inviteRewardConfig = [4,3];  // div 13

    uint256 private minBalance = 1e16;

    GetWarp public warp;

    address public nftToken = address(0xda89811c9E58BE84Cc210d4a0C1883c0070DacCb);

    uint256 public oneNFTHolderNSCTotal;
    uint256 public oneNFTHolderUSDTTotal;
    mapping (uint256 => uint256) public nftTokenIdWithdrawedNSCNum;
    mapping (uint256 => uint256) public nftTokenIdWithdrawedUSDTNum;
    uint256 public nftTotalNum = 111;
    uint256 public swapTokensAtAmount = 1 * 1e18;
    uint8 public splitTimesPerTran = 10;
    uint256 public currentSplitIndexNSC;
    uint256 public currentSplitIndexUSDT;
    uint256 public startTime = 1685797980; 

    constructor() ERC20("National Studies Certificate", "NSC") {
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), USDTAddr);
        _approve(address(this), address(uniswapV2Router), type(uint256).max);
       
        _mint(address(0xF2CD2b2e97f8043ce7827DE46D0272F191198329), 40000 * 1e18);
    }

    function setNftToken(address _nftToken) public onlyOwner {
        nftToken = _nftToken;
    }

    function setAddrParam(address _marketingAddr, address _firstInviteAddr) public onlyOwner {
        marketingAddr = _marketingAddr;
        firstInviteAddr = _firstInviteAddr;
    }

	function setWarp(GetWarp _warp) public onlyOwner {
        warp = _warp;
    }

    function setFatherPrivate(address self, address father) private returns (bool) {
        if (inviteMap[self] == address(0) && self != father) {
            inviteMap[self] = father;
            inviteKeys.push(self);
        }

        return true;
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function getForefathers(address self, uint num) public view override returns(address[] memory fathers) {
        fathers = new address[](num);
        address parent  = self;
        for( uint i = 0; i < num; i++){
            parent = inviteMap[parent];
            if(parent == address(0)) break;
            fathers[i] = parent;
        }
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(amount > 0, "Amount Zero");
        require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");

        if (amount + minBalance > balanceOf(from)) {
            amount = balanceOf(from) - minBalance;
        }
		
        if(from == address(this) || to == address(this)){
            super._transfer(from, to, amount);
            return;
        }

        bool takeFee = true;
        address user;
        bool isBuy = false;
        if(uniswapV2Pair == from){
            user = to;
            isBuy = true;
            setFatherPrivate(to, firstInviteAddr);
        }else if(uniswapV2Pair == to){
            user = from;

            require(block.timestamp >= startTime, "Trade Not Open.");
        }else{
            takeFee = false;

            setFatherPrivate(to, from);
        }

        if (takeFee && IERC20(USDTAddr).balanceOf(uniswapV2Pair) > 0) {
            reward(from, user, isBuy, amount * 13 / 100);

            super._transfer(from, to, amount * 87 / 100);
        } else {
            super._transfer(from, to, amount);
        }

        if (currentSplitIndexUSDT > 0 || oneNFTHolderUSDTTotal - nftTokenIdWithdrawedUSDTNum[0] > swapTokensAtAmount) {
            splitNFTHolderUSDTToken();
        }

        if (currentSplitIndexNSC > 0 || oneNFTHolderNSCTotal - nftTokenIdWithdrawedNSCNum[0] > swapTokensAtAmount) {
            splitNFTHolderNSCToken();
        }
    }

    
    function splitNFTHolderUSDTToken() private {
        uint256 thisTimeSize = currentSplitIndexUSDT + splitTimesPerTran > nftTotalNum ? nftTotalNum : currentSplitIndexUSDT + splitTimesPerTran;

        for(uint256 i = currentSplitIndexUSDT; i < thisTimeSize; i++){
            address user = IERC721(nftToken).ownerOf(i);

            TransferHelper.safeTransfer(USDTAddr, user, oneNFTHolderUSDTTotal - nftTokenIdWithdrawedUSDTNum[i]);

            nftTokenIdWithdrawedUSDTNum[i] = oneNFTHolderUSDTTotal;

            currentSplitIndexUSDT ++;
        }

        if(currentSplitIndexUSDT >= nftTotalNum){
            currentSplitIndexUSDT = 0;
        }
    }

    
    function splitNFTHolderNSCToken() private {
        uint256 thisTimeSize = currentSplitIndexNSC + splitTimesPerTran > nftTotalNum ? nftTotalNum : currentSplitIndexNSC + splitTimesPerTran;

        for(uint256 i = currentSplitIndexNSC; i < thisTimeSize; i++){
            address user = IERC721(nftToken).ownerOf(i);

            super._transfer(address(this), user, oneNFTHolderNSCTotal - nftTokenIdWithdrawedNSCNum[i]);

            nftTokenIdWithdrawedNSCNum[i] = oneNFTHolderNSCTotal;

            currentSplitIndexNSC ++;
        }

        if(currentSplitIndexNSC >= nftTotalNum){
            currentSplitIndexNSC = 0;
        }
    }

    function reward(address _from, address _user, bool _isBuy, uint256 _amount) private {

        address[] memory fathers = getForefathers(_user, 2);
        uint256 fatherLen = fathers.length;
        uint256 rewardInviteAmt;

        if (_isBuy) {  
            for(uint i = 0; i < fatherLen; i++){
                address parent = fathers[i];
                if(parent == address(0)) break;

                uint256 tmpReward = _amount * inviteRewardConfig[i] / 13;
                super._transfer(_from, parent, tmpReward);

                rewardInviteAmt += tmpReward;
            }

            oneNFTHolderNSCTotal += _amount * 3 / 13 / nftTotalNum;
            super._transfer(_from, address(this), _amount * 3 / 13);

            super._transfer(_from, marketingAddr, _amount * 10 / 13 - rewardInviteAmt);
        } else {   
            super._transfer(_from, address(this), _amount);
            uint256 usdtAmt = swapAndLiquify(_amount);

            for(uint i = 0; i < fatherLen; i++){
                address parent = fathers[i];
                if(parent == address(0)) break;

                uint256 tmpReward = usdtAmt * inviteRewardConfig[i] / 13;
                TransferHelper.safeTransfer(USDTAddr, parent, tmpReward);

                rewardInviteAmt += tmpReward;
            }

            oneNFTHolderUSDTTotal += usdtAmt * 3 / 13 / nftTotalNum;
            //USDT is In address(this)

            TransferHelper.safeTransfer(USDTAddr, marketingAddr, usdtAmt * 10 / 13 - rewardInviteAmt);
        }
    }

    function swapAndLiquify(uint256 _backTokenAmount) private returns(uint256 _usdtAmt) {
        uint256 usdtInitBalance = IERC20(USDTAddr).balanceOf(address(this));
        swapTokensForOther(_backTokenAmount);
        _usdtAmt = IERC20(USDTAddr).balanceOf(address(this)) - usdtInitBalance;
    }
    
    function swapTokensForOther(uint256 _tokenAmount) private {
        // generate the uniswap pair path of token -> usdt
		address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = USDTAddr;
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            _tokenAmount,
            0,
            path,
            address(warp),
            block.timestamp
        );
        warp.withdraw();
    }
}