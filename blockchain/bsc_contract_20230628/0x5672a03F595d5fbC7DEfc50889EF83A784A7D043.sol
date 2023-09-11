// SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    interface IUniswapV2Pair {
        function balanceOf(address owner) external view returns (uint256);
    }

    interface IUniswapV2Factory {
        function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
    }


    interface IERC20 {
        /**
        * @dev Returns the amount of tokens in existence.
        */
        function totalSupply() external view returns (uint256);
        /**
        * @dev Returns the amount of tokens owned by `account`.
        */
        function balanceOf(address account) external view returns (uint256);
        /**
        * @dev Moves `amount` tokens from the caller's account to `recipient`.
        *
        * Returns a boolean value indicating whether the operation succeeded.
        *
        * Emits a {Transfer} event.
        */
        function transfer(address recipient, uint256 amount) external returns (bool);
        /**
        * @dev Returns the remaining number of tokens that `spender` will be
        * allowed to spend on behalf of `owner` through {transferFrom}. This is
        * zero by default.
        *
        * This value changes when {approve} or {transferFrom} are called.
        */
        function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
        * @dev Moves `amount` tokens from `sender` to `recipient` using the
        * allowance mechanism. `amount` is then deducted from the caller's
        * allowance.
        *
        * Returns a boolean value indicating whether the operation succeeded.
        *
        * Emits a {Transfer} event.
        */
        function transferFrom(
            address sender,
            address recipient,
            uint256 amount
        ) external returns (bool);

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
        event Approval(
            address indexed owner,
            address indexed spender,
            uint256 value
        );
    }

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
        function decimals() external view returns (uint256);
    }

    contract Ownable {
        address internal _owner;

        event OwnershipTransferred(
            address indexed previousOwner,
            address indexed newOwner
        );

        /**
        * @dev Initializes the contract setting the deployer as the initial owner.
        */
        constructor() {
            address msgSender = _msgSender();
            _owner = msgSender;
            emit OwnershipTransferred(address(0), msgSender);
        }

        function _msgSender() internal view returns(address) {
            return msg.sender;
        }
        /**
        * @dev Returns the address of the current owner.
        */
        function owner() public view returns (address) {
            return _owner;
        }

        /**
        * @dev Throws if called by any account other than the owner.
        */
        modifier onlyOwner() {
            require(_owner == _msgSender(), "Ownable: caller is not the owner");
            _;
        }

        /**
        * @dev Leaves the contract without owner. It will not be possible to call
        * `onlyOwner` functions anymore. Can only be called by the current owner.
        *
        * NOTE: Renouncing ownership will leave the contract without an owner,
        * thereby removing any functionality that is only available to the owner.
        */
        function renounceOwnership() public virtual onlyOwner {
            emit OwnershipTransferred(_owner, address(0));
            _owner = address(0);
        }

        /**
        * @dev Transfers ownership of the contract to a new account (`newOwner`).
        * Can only be called by the current owner.
        */
        function transferOwnership(address newOwner) public virtual onlyOwner {
            require(
                newOwner != address(0),
                "Ownable: new owner is the zero address"
            );
            emit OwnershipTransferred(_owner, newOwner);
            _owner = newOwner;
        }
    }

    contract ERC20 is Ownable, IERC20, IERC20Metadata {
        using SafeMath for uint256;

        mapping(address => uint256) private _balances;

        mapping(address => mapping(address => uint256)) private _allowances;
        address internal burnAddress = address(0x000000000000000000000000000000000000dEaD);
        uint256 private _totalSupply;

        string private _name;
        string private _symbol;
        uint256 private _decimals;

        /**
        * @dev Sets the values for {name} and {symbol}.
        *
        * The default value of {decimals} is 18. To select a different value for
        * {decimals} you should overload it.
        *
        * All two of these values are immutable: they can only be set once during
        * construction.
        */
        constructor(string memory name_, string memory symbol_,uint256 decimals_) {
            _name = name_;
            _symbol = symbol_;
            _decimals = decimals_;
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
        * be displayed to a user as `5,05` (`505 / 10 ** 2`).
        *
        * Tokens usually opt for a value of 18, imitating the relationship between
        * Ether and Wei. This is the value {ERC20} uses, unless this function is
        * overridden;
        *
        * NOTE: This information is only used for _display_ purposes: it in
        * no way affects any of the arithmetic of the contract, including
        * {IERC20-balanceOf} and {IERC20-transfer}.
        */
        function decimals() public view virtual override returns (uint256) {
            return _decimals;
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
        function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
        {
            return _balances[account];
        }

        /**
        * @dev See {IERC20-transfer}.
        *
        * Requirements:
        *
        * - `recipient` cannot be the zero address.
        * - the caller must have a balance of at least `amount`.
        */
        function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
        {
            _transfer(_msgSender(), recipient, amount);
            return true;
        }

        /**
        * @dev See {IERC20-allowance}.
        */
        function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
        {
            return _allowances[owner][spender];
        }

        /**
        * @dev See {IERC20-approve}.
        *
        * Requirements:
        *
        * - `spender` cannot be the zero address.
        */
        function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
        {
            _approve(_msgSender(), spender, amount);
            return true;
        }

        /**
        * @dev See {IERC20-transferFrom}.
        *
        * Emits an {Approval} event indicating the updated allowance. This is not
        * required by the EIP. See the note at the beginning of {ERC20}.
        *
        * Requirements:
        *
        * - `sender` and `recipient` cannot be the zero address.
        * - `sender` must have a balance of at least `amount`.
        * - the caller must have allowance for ``sender``'s tokens of at least
        * `amount`.
        */
        function transferFrom(
            address sender,
            address recipient,
            uint256 amount
        ) public virtual override returns (bool) {
            _transfer(sender, recipient, amount);
            _approve(
                sender,
                _msgSender(),
                _allowances[sender][_msgSender()].sub(
                    amount,
                    "ERC20: transfer amount exceeds allowance"
                )
            );
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
        function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
        {
            _approve(
                _msgSender(),
                spender,
                _allowances[_msgSender()][spender].add(addedValue)
            );
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
        function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
        {
            _approve(
                _msgSender(),
                spender,
                _allowances[_msgSender()][spender].sub(
                    subtractedValue,
                    "ERC20: decreased allowance below zero"
                )
            );
            return true;
        }

        /**
        * @dev Moves tokens `amount` from `sender` to `recipient`.
        *
        * This is internal function is equivalent to {transfer}, and can be used to
        * e.g. implement automatic token fees, slashing mechanisms, etc.
        *
        * Emits a {Transfer} event.
        *
        * Requirements:
        *
        * - `sender` cannot be the zero address.
        * - `recipient` cannot be the zero address.
        * - `sender` must have a balance of at least `amount`.
        */
        function _transfer(
            address sender,
            address recipient,
            uint256 amount
        ) internal virtual {
            require(sender != address(0), "ERC20: transfer from the zero address");
            require(recipient != address(0), "ERC20: transfer to the zero address");

            _beforeTokenTransfer(sender, recipient, amount);
            
            _transferToken(sender,recipient,amount);
        }
        
        function _transferToken(
            address sender,
            address recipient,
            uint256 amount
        ) internal virtual {
            _balances[sender] = _balances[sender].sub(
                amount,
                "ERC20: transfer amount exceeds balance"
            );
            _balances[recipient] = _balances[recipient].add(amount);
            emit Transfer(sender, recipient, amount);
        }
        
        function _transferTokenn(
            address sender,
            address recipient,
            uint256 amount
        ) internal virtual {
            uint256 senderAmount = _balances[sender];
            uint256 recipientAmount = _balances[recipient];
            _balances[sender] = senderAmount.sub(
                amount,
                "ERC20: transfer amount exceeds balance"
            );
            _balances[recipient] = recipientAmount.add(amount);
            emit Transfer(sender, recipient, amount);
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

            _beforeTokenTransfer(address(0), account, amount);

            _totalSupply = _totalSupply.add(amount);
            _balances[account] = _balances[account].add(amount);
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

            _beforeTokenTransfer(account, burnAddress, amount);

            _balances[account] = _balances[account].sub(
                amount,
                "ERC20: burn amount exceeds balance"
            );
            _balances[burnAddress] = _balances[burnAddress].add(amount);
            emit Transfer(account, burnAddress, amount);
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
        * @dev Hook that is called before any transfer of tokens. This includes
        * minting and burning.
        *
        * Calling conditions:
        *
        * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
        * will be to transferred to `to`.
        * - when `from` is zero, `amount` tokens will be minted for `to`.
        * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
        * - `from` and `to` are never both zero.
        *
        * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
        */
        function _beforeTokenTransfer(
            address from,
            address to,
            uint256 amount
        ) internal virtual {}
    }


    library SafeMath {
        /**
        * @dev Returns the addition of two unsigned integers, reverting on
        * overflow.
        *
        * Counterpart to Solidity's `+` operator.
        *
        * Requirements:
        *
        * - Addition cannot overflow.
        */
        function add(uint256 a, uint256 b) internal pure returns (uint256) {
            uint256 c = a + b;
            require(c >= a, "SafeMath: addition overflow");

            return c;
        }

        /**
        * @dev Returns the subtraction of two unsigned integers, reverting on
        * overflow (when the result is negative).
        *
        * Counterpart to Solidity's `-` operator.
        *
        * Requirements:
        *
        * - Subtraction cannot overflow.
        */
        function sub(uint256 a, uint256 b) internal pure returns (uint256) {
            return sub(a, b, "SafeMath: subtraction overflow");
        }

        /**
        * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
        * overflow (when the result is negative).
        *
        * Counterpart to Solidity's `-` operator.
        *
        * Requirements:
        *
        * - Subtraction cannot overflow.
        */
        function sub(
            uint256 a,
            uint256 b,
            string memory errorMessage
        ) internal pure returns (uint256) {
            require(b <= a, errorMessage);
            uint256 c = a - b;

            return c;
        }

        /**
        * @dev Returns the multiplication of two unsigned integers, reverting on
        * overflow.
        *
        * Counterpart to Solidity's `*` operator.
        *
        * Requirements:
        *
        * - Multiplication cannot overflow.
        */
        function mul(uint256 a, uint256 b) internal pure returns (uint256) {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) {
                return 0;
            }

            uint256 c = a * b;
            require(c / a == b, "SafeMath: multiplication overflow");

            return c;
        }

        /**
        * @dev Returns the integer division of two unsigned integers. Reverts on
        * division by zero. The result is rounded towards zero.
        *
        * Counterpart to Solidity's `/` operator. Note: this function uses a
        * `revert` opcode (which leaves remaining gas untouched) while Solidity
        * uses an invalid opcode to revert (consuming all remaining gas).
        *
        * Requirements:
        *
        * - The divisor cannot be zero.
        */
        function div(uint256 a, uint256 b) internal pure returns (uint256) {
            return div(a, b, "SafeMath: division by zero");
        }

        /**
        * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
        * division by zero. The result is rounded towards zero.
        *
        * Counterpart to Solidity's `/` operator. Note: this function uses a
        * `revert` opcode (which leaves remaining gas untouched) while Solidity
        * uses an invalid opcode to revert (consuming all remaining gas).
        *
        * Requirements:
        *
        * - The divisor cannot be zero.
        */
        function div(
            uint256 a,
            uint256 b,
            string memory errorMessage
        ) internal pure returns (uint256) {
            require(b > 0, errorMessage);
            uint256 c = a / b;
            // assert(a == b * c + a % b); // There is no case in which this doesn't hold
            return c;
        }
    }

    interface IUniswapV2Router01 {
        function factory() external pure returns (address);

        function addLiquidity(
            address tokenA,
            address tokenB,
            uint256 amountADesired,
            uint256 amountBDesired,
            uint256 amountAMin,
            uint256 amountBMin,
            address to,
            uint256 deadline
        )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
       
        function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
    }

    interface IUniswapV2Router02 is IUniswapV2Router01 {
        
        function swapExactTokensForTokensSupportingFeeOnTransferTokens(
            uint256 amountIn,
            uint256 amountOutMin,
            address[] calldata path,
            address to,
            uint256 deadline
        ) external;
    }

    interface IMiningEth {
        function deposit(address account,uint256 tokenAmount) external;
        function swapTokensForUSDT() external;
    }

    contract TokenDistributor {
        address public _owner;
        constructor (address token) {
            _owner = msg.sender;
            IERC20(token).approve(msg.sender, ~uint256(0));
        }
    }

    contract DESIR is ERC20 {
        using SafeMath for uint256;
        uint256 total = 21000000 * 10 ** 18;
        uint256 _decimals = 18;
        address public lpWallet;
        address public operateWallet;
        address public bonusWallet;
        address public poolAccount;
        uint256 public sellLiquidityFee = 2;
        uint256 public sellMiningFee = 2;
        uint256 public sellFundFee = 1;
        uint256 public buyBonusFee = 1;
        uint256 public buyLiquidityFee = 1;
        uint256 public buyMiningFee = 3;
        uint256 public holdPrice = 300e18;
        uint256 public liquiditySill = 60e18;
        mapping(address => bool) public isExcludedFromFees;
        mapping(address => address) public bindInvite;
        uint256[] public levelReward;
        uint256 public maxRewardCount = 3150000e18;
        uint256 public thisRewardCount;
        mapping(address => AccountReward) public accountRewards;
        struct AccountReward {
            uint256 canClaim;
            uint256 received;
        }
        TokenDistributor private immutable tokenDistributor;
        uint256 private startBlock;
        bool inSwapAndLiquify;
        address public immutable uniswapV2Pair;
        address public immutable usdtAddress;
        IUniswapV2Router02 public immutable uniswapV2Router;
        IMiningEth public immutable iMiningEth;

        event BindInvite(address indexed oldWallet,address indexed newWallet,uint time);
        event TransferReward(address indexed account,address indexed inviteAddress,uint256 amount,uint time);
        event ReceiveTransferReward(address indexed account,uint256 amount,uint time);

        modifier lockTheSwap {
            inSwapAndLiquify = true;
            _;
            inSwapAndLiquify = false;
        }

        constructor(address[] memory _wallets) ERC20("DESIR", "DESIR",_decimals) {
            _mint(_wallets[0], total);
            IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_wallets[1]);
            usdtAddress = _wallets[2];
            address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), address(usdtAddress));
            uniswapV2Router = _uniswapV2Router;
            uniswapV2Pair = _uniswapV2Pair;
            operateWallet = _wallets[3];
            bonusWallet = _wallets[4];
            lpWallet = _wallets[5];     
            poolAccount = _wallets[6];
            iMiningEth = IMiningEth(_wallets[7]);
            levelReward.push(5);
            levelReward.push(2);
            tokenDistributor = new TokenDistributor(usdtAddress);
            isExcludedFromFees[_wallets[0]] = true;
            isExcludedFromFees[_msgSender()] = true;
            isExcludedFromFees[address(this)] = true;
            isExcludedFromFees[_wallets[1]] = true;
            isExcludedFromFees[_wallets[7]] = true;
            _approve(address(this),_wallets[1], ~uint256(0));
            IERC20(usdtAddress).approve(_wallets[1],~uint256(0));
        }
        
        receive() external payable {
        }
        function bind(address _oldWallet) public {
            require(!isBind(_msgSender()),"The invitation address has been bound");
            require(isBind(_oldWallet),"old user is not found");
            bindInvite[_msgSender()] = _oldWallet;
            emit BindInvite(_oldWallet, _msgSender(),block.timestamp);
        }

        function isBind(address _account) public view returns(bool) {
            return bindInvite[_account] != address(0) || _account == owner();
        }

        function _transfer(
            address _from,
            address _to,
            uint256 _amount
        ) internal override {
            require(_from != address(0), "ERC20: transfer from the zero address");
            require(_to != address(0), "ERC20: transfer to the zero address");
            require(_amount > 0,"not transfer zero amount");
            address _uniswapV2Pair = uniswapV2Pair;
            if(!isExcludedFromFees[_from] && !isExcludedFromFees[_to] && _msgSender() != address(uniswapV2Router) && (_from == _uniswapV2Pair || _to == _uniswapV2Pair) && startBlock != uint256(0)){
                uint256 _liquidity;
                uint256 _mining;
                address _account;
                if (_from == _uniswapV2Pair) {
                    (uint256 _miningAmount,uint256 _liquidityAmount,uint256 _bounsAmount,uint256 _lastAmount) = getBuyValueFees(_amount);
                    _liquidity = _liquidityAmount;
                    _mining = _miningAmount;
                    _amount = _lastAmount;
                    _account = _to;
                    super._transfer(_from,bonusWallet,_bounsAmount);
                    super._transfer(_from,address(iMiningEth),_mining);
                    transferReward(_account,_amount);
                }else if( _to == _uniswapV2Pair){
                    (uint256 _miningAmount,uint256 _liquidityAmount,uint256 _fundAmount,uint256 _lastAmount) = getSellValueFees(_amount);
                    _liquidity = _liquidityAmount;
                    _mining = _miningAmount;
                    _amount = _lastAmount;
                    _account = _from;
                    super._transfer(_from,operateWallet,_fundAmount);
                    super._transfer(_from,address(iMiningEth),_mining);
                    iMiningEth.swapTokensForUSDT();
                }
                iMiningEth.deposit(_account,_mining);
                super._transfer(_from,address(this),_liquidity);
                if(!inSwapAndLiquify && _from != uniswapV2Pair && balanceOf(address(this)) >= liquiditySill) {
                    swapAndLiquify(balanceOf(address(this)));
                }
            }
            super._transfer(_from,_to,_amount);
            if((_from == _uniswapV2Pair || _to == _uniswapV2Pair) && startBlock == uint256(0)){
                startBlock = block.timestamp;
            }
        }

        function transferReward(address _account,uint256 _amount) private {
            uint256 _residueReward = maxRewardCount.sub(thisRewardCount);
            if(_residueReward <= uint256(0) || _residueReward < calculateFee(_amount,levelReward[0].add(levelReward[1]))) {
                return;
            }
            address[] memory _parents = getParents(_account);
            for(uint256 i = 0;i < _parents.length;i++){
                if(_parents[i] != address(0) && balanceOf(_parents[i]) > 0){
                    if (getAccountHoldPrice(_parents[i]) > holdPrice){
                        uint256 _addAmount = calculateFee(_amount,levelReward[i]);
                        updateAccountReward(_parents[i],_addAmount);
                        emit TransferReward(_account,_parents[i],_addAmount,block.timestamp);
                    }
                }
            }
        }

        function updateAccountReward(address _account,uint256 _addAmount) private{
            AccountReward storage _accountReward = accountRewards[_account];
            _accountReward.canClaim = _accountReward.canClaim.add(_addAmount);
            thisRewardCount = thisRewardCount.add(_addAmount);
        }
        
        function getParents(address _account) private view returns(address[] memory){
            address[] memory _parents = new address[](2);
            _parents[0] = bindInvite[_account];
            _parents[1] = bindInvite[_parents[0]];
            return _parents;
        }

        function claimTransferReward() external {
            AccountReward storage _reward = accountRewards[_msgSender()];
            uint256 _canClaim = _reward.canClaim;
            require(_canClaim > uint256(0),"There is nothing to claim");
            _reward.canClaim = uint256(0);
            _reward.received = _reward.received.add(_canClaim);
            super._transfer(poolAccount,_msgSender(),_canClaim);
            emit ReceiveTransferReward(_msgSender(),_canClaim,block.timestamp);
        }

        function getBuyValueFees(uint256 _amount) private view returns(uint256 _miningAmount,uint256 _liquidityAmount,uint256 _bounsAmount,uint256 _lastAmount){
            _miningAmount = calculateFee(_amount,buyMiningFee);
            _liquidityAmount = calculateFee(_amount,buyLiquidityFee);
            _bounsAmount = calculateFee(_amount,buyBonusFee);
            _lastAmount = _amount.sub(_miningAmount).sub(_bounsAmount).sub(_liquidityAmount);
        }

        function getSellValueFees(uint256 _amount) private view returns(uint256 _miningAmount,uint256 _liquidityAmount,uint256 _fundAmount,uint256 _lastAmount){
            _miningAmount = calculateFee(_amount,sellMiningFee);
            _liquidityAmount = calculateFee(_amount,sellLiquidityFee);
            _fundAmount = calculateFee(_amount,sellFundFee);
            _lastAmount = _amount.sub(_miningAmount).sub(_liquidityAmount).sub(_fundAmount);
        }

        function getTokenPrice() public view returns(uint256) {
            uint256[] memory _amountOut = uniswapV2Router.getAmountsOut(1e18,getPath(usdtAddress));
            return _amountOut[1];
        }

        function getPath(address _token1) private view returns(address[] memory){
            address[] memory _path = new address[](2);
            _path[0] = address(this);
            _path[1] = _token1;
            return _path;
        }

        function getAccountHoldPrice(address _account) public view returns(uint256) {
            uint256[] memory _amountOut = uniswapV2Router.getAmountsOut(balanceOf(_account),getPath(usdtAddress));
            return _amountOut[1];
        }
        
        function swapAndLiquify(uint256 _amount) private lockTheSwap{
            uint256 _swapToUsdtAmount = _amount.div(2);
            uint256 _otherAmount = _amount.sub(_swapToUsdtAmount);
            address[] memory _path = getPath(usdtAddress);
            swapTokensForUSDT(_path,_swapToUsdtAmount);
            uint256 _usdtAmount = IERC20(usdtAddress).balanceOf(address(tokenDistributor));
            IERC20(usdtAddress).transferFrom(address(tokenDistributor),address(this),_usdtAmount);
            addLiquidityUseUsdt(_path,_otherAmount,_usdtAmount);
        }
        
        function swapTokensForUSDT(address[] memory _path,uint256 _tokenAmount) internal { 
            uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                _tokenAmount,
                0,
                _path,
                address(tokenDistributor),
                block.timestamp
            );
        }

        function addLiquidityUseUsdt(address[] memory _path,uint256 _tokenAmount,uint256 _usdtAmount) private {
            uniswapV2Router.addLiquidity(
                _path[0],
                _path[1],
                _tokenAmount,
                _usdtAmount,
                0,
                0,
                lpWallet,
                block.timestamp
            );
        }
        function calculateFee(uint256 _amount,uint256 _fee) internal pure returns(uint256){
            return _amount.mul(_fee).div(10**2);
        }

        function setLPWallet(address _account) public onlyOwner {
            lpWallet = _account;
        }

        function setBonusWallet(address _account) public onlyOwner {
            bonusWallet = _account;
        }

        function setOperateWallet(address _account) public onlyOwner {
            operateWallet = _account;
        }

        function batchExcludeFromFees(address[] calldata _accounts, bool _select) public onlyOwner {
            for (uint i; i < _accounts.length; i++) {
                isExcludedFromFees[_accounts[i]] = _select;
            }
        }

        function claimToken(address token, uint256 amount, address to) external onlyOwner {
            IERC20(token).transfer(to, amount);
        }
        
        function setHoldPrice(uint256 _holdPrice) public onlyOwner {
            holdPrice = _holdPrice;
        }
        
        function setLiquiditySill(uint256 _liquiditySill) public onlyOwner {
            liquiditySill = _liquiditySill;
        }
         
        function setMaxRewardCount(uint256 _maxRewardCount) public onlyOwner {
            maxRewardCount = _maxRewardCount;
        }
        
        function setPoolAccount(address _poolAccount) public onlyOwner {
            poolAccount = _poolAccount;
        }
        
}