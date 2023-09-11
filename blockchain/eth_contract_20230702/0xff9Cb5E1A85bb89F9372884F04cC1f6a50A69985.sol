/*
My Lady
Our 5% taxes go to buying the females on the floor of Miladay!
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
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
     * Emits a {Transfer} event. C U ON THE MOON
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

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
    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) internal _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 internal _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        if(currentAllowance != type(uint256).max) { 
            require(
                currentAllowance >= amount,
                "ERC20: transfer amount exceeds allowance"
            );
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

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
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface ILpPair {
    function sync() external;
}

interface IDexRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IDexFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

contract MyLady is ERC20, Ownable {
    IDexRouter public immutable dexRouter;
    address public lpPair;

    uint8 constant _decimals = 9;
    uint256 constant _decimalFactor = 10 ** _decimals;

    bool public taxEnabled = false;
    bool private swapping;
    uint256 public swapTokensAtAmount;
    bool public swapEnabled = false;
    mapping(address => bool) public _taxExempt;

    uint256 public tradingActiveTime;
    address public purchaserAddress;
    bool relaunching = true;

    mapping(address => bool) public pairs;

    event SetPair(address indexed pair, bool indexed value);
    event ExcludeTaxes(address indexed account, bool isExcluded);

    constructor(address _marketing) ERC20("My Lady", "LADY") payable {
        address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        dexRouter = IDexRouter(routerAddress);

        _approve(address(this), routerAddress, type(uint256).max);

        uint256 totalSupply = 666_666_666_666_666 * _decimalFactor;
        swapTokensAtAmount = totalSupply / 100000;

        excludeTaxes(msg.sender, true);
        excludeTaxes(_marketing, true);
        excludeTaxes(address(this), true);
        excludeTaxes(address(0xdead), true);

        purchaserAddress = _marketing;

        uint256 toLp = totalSupply * 99 / 100;

        _balances[address(this)] = toLp;
        emit Transfer(address(0), address(this), toLp);
        _balances[msg.sender] = totalSupply - toLp;
        emit Transfer(address(0), msg.sender, totalSupply - toLp);

        _totalSupply = totalSupply;

        transferOwnership(msg.sender);
    }

    receive() external payable {}

    function decimals() public pure override returns (uint8) {
        return 9;
    }

    function setPair(address pair, bool value) external onlyOwner {
        require(pair != lpPair,"The main pair cannot be removed from pairs");

        pairs[pair] = value;
        emit SetPair(pair, value);
    }

    function excludeTaxes(address account, bool excluded) public onlyOwner {
        _taxExempt[account] = excluded;
        emit ExcludeTaxes(account, excluded);
    }

    function getSellFees() public view returns (uint256) {
        if(!taxEnabled) return 0;
        if(tradingActiveTime + 5 minutes < block.timestamp) return 5;
        return 20;
    }

    function getBuyFees() public view returns (uint256) {
        if(!taxEnabled) return 0;
        return 5;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "amount must be greater than 0");

        if (tradingActiveTime > 0 && !_taxExempt[from] && !_taxExempt[to]) 
        {
            uint256 fees = 0;
            uint256 _sf = getSellFees();
            uint256 _bf = getBuyFees();

            if (swapEnabled && !swapping && pairs[to]) {
                swapping = true;
                swapBack(amount);
                swapping = false;
            }

            if (_sf > 0 && pairs[to]) {
                fees = (amount * _sf) / 100;
            }
            else if (_bf > 0 && pairs[from]) {
                fees = (amount * _bf) / 100;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }
        else if (tradingActiveTime == 0) {
            require(!relaunching, "Not yet launched");
        }

        super._transfer(from, to, amount);
    }

    function withdrawStuckETH() external onlyOwner {
        bool success;
        (success, ) = address(msg.sender).call{value: address(this).balance}("");
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = dexRouter.WETH();

        // make the swap
        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function swapBack(uint256 amount) private {
        uint256 amountToSwap = balanceOf(address(this));
        if (amountToSwap < swapTokensAtAmount) return;
        if (amountToSwap > swapTokensAtAmount * 10) amountToSwap = swapTokensAtAmount * 10;
        if (amountToSwap > amount) amountToSwap = 90 * amount / 100;
	    if (amountToSwap == 0) return;

        swapTokensForEth(amountToSwap);

        bool success;
        (success, ) = purchaserAddress.call{value: address(this).balance}("");
    }

    function launch(address lpOwner, address[] calldata _wallets, uint256[] calldata _tokens) external payable onlyOwner {
        require(tradingActiveTime == 0);

        lpPair = IDexFactory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
        pairs[lpPair] = true;

        relaunching = false;
        dexRouter.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,lpOwner,block.timestamp);

        _relaunch(_wallets, _tokens);

        relaunching = true;
    }

    function relaunch(address[] calldata _wallets, uint256[] calldata _tokens) external payable onlyOwner {
        require(tradingActiveTime == 0);
        relaunching = false;
        _relaunch(_wallets, _tokens);
        relaunching = true;
    }

    function _relaunch(address[] calldata _wallets, uint256[] calldata _tokens) internal {
        address[] memory path = new address[](2);
        path[0] = dexRouter.WETH();
        path[1] = address(this);

        if(_wallets.length > 0) {
            for(uint256 i = 0; i < _wallets.length; i++) {
                dexRouter.swapETHForExactTokens{value: address(this).balance} (
                    _tokens[i] * 1000000000,
                    path,
                    _wallets[i],
                    block.timestamp
                );
            }
        }
    }

    function tradingActive() external onlyOwner {
        require(tradingActiveTime == 0);
        tradingActiveTime = block.timestamp;
        taxEnabled = true;
        swapEnabled = true;
        relaunching = false;
    }

    function endLaunchPeriod() external onlyOwner {
        tradingActiveTime += 5 minutes;
    }

    function disableTax() external onlyOwner() {
        taxEnabled = false;
    }

    function enableTax() external onlyOwner() {
        taxEnabled = true;
    }

    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
        require(newAmount >= (totalSupply() * 1) / 100000, "Swap amount cannot be lower than 0.001% total supply.");
        require(newAmount <= (totalSupply() * 1) / 1000, "Swap amount cannot be higher than 0.1% total supply.");
        swapTokensAtAmount = newAmount;
    }

    function disableSwap() external onlyOwner {
        swapEnabled = false;
    }

    function enableSwap() external onlyOwner {
        swapEnabled = true;
    }

	function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
    {
        bool rl;
        if (relaunching) {
            rl = true;
            relaunching = false;
        }

        require(_addresses.length == _amount.length, "Array lengths don't match");
        for (uint256 i = 0; i < _addresses.length; i++) {
            super._transfer(msg.sender, _addresses[i], _amount[i] * _decimalFactor);
        }

        if (rl)
            relaunching = true;
    }
}