// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IPancakeswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface IPancakeswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IBEP20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function balanceOf(address account) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface IBEP20Metadata is IBEP20 {
    function name() external view returns (string memory);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
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

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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

contract BEP20 is Context, IBEP20, IBEP20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string constant private _name = "SAFUPEPE";
    string constant private _symbol = "SAFUPEPE";

    constructor() {
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

    function balanceOf(
        address account
    ) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

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

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "BEP20: decreased allowance below zero"
        );
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");

        uint256 fromBalance = _balances[from];
        require(
            fromBalance >= amount,
            "BEP20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "BEP20: mint to the zero address");

        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "BEP20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}

contract SAFUPEPE is BEP20, Ownable {
    address public marketingWallet = 0x3b945361B3111a3a8C3464e2EEd3b04c38562Eb0;

    uint256 private immutable _numTokensSellToAddToETH = 100000000 * (10 ** decimals());

    bool private _liquidityAdded = false;

    bool private inSwapAndLiquify;

    IPancakeswapV2Router02 public immutable pancakeswapV2Router;
    address public immutable pancakeswapV2Pair;

    uint8 public buyMarketingTaxPercentage = 5;
    uint8 public sellMarketingTaxPercentage = 10;

    mapping(address => bool) private _isExcludedFromFee;

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    event BuyMarketingTaxPercentageChanged(uint8 oldTax, uint8 newTax);
    event SellMarketingTaxPercentageChanged(uint8 oldTax, uint8 newTax);
    event SwapTokensForETH(uint256 amountIn, address[] path, address recipient);

    constructor(address ownerWallet) BEP20() {
        _mint(ownerWallet, (100000000000 * 10 ** decimals()));

        IPancakeswapV2Router02 _pancakeswapV2Router = IPancakeswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

        pancakeswapV2Pair = IPancakeswapV2Factory(_pancakeswapV2Router.factory()).createPair(address(this), _pancakeswapV2Router.WETH());

        pancakeswapV2Router = _pancakeswapV2Router;
        _transferOwnership(ownerWallet);

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[marketingWallet] = true;
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");

        _isExcludedFromFee[owner()] = false;
        _isExcludedFromFee[newOwner] = true;
        _transferOwnership(newOwner);
    }

    function changeBuyMarketingTax(uint8 _buyMarketingTaxPercentage) external onlyOwner returns (bool) {
        uint8 oldTax = buyMarketingTaxPercentage;

        buyMarketingTaxPercentage = _buyMarketingTaxPercentage;
        emit BuyMarketingTaxPercentageChanged(oldTax, buyMarketingTaxPercentage);

        return true;
    }

    function changeSellMarketingTax(uint8 _sellMarketingTaxPercentage) external onlyOwner returns (bool) {
        uint8 oldTax = sellMarketingTaxPercentage;

        sellMarketingTaxPercentage = _sellMarketingTaxPercentage;
        emit SellMarketingTaxPercentageChanged(oldTax, sellMarketingTaxPercentage);

        return true;
    }

    function changeMarketingWallet(address _marketingWallet) external onlyOwner returns (bool) {
        marketingWallet = _marketingWallet;

        return true;
    }

    function _swapTokensForEth(uint256 tokenAmount, address recipient) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = pancakeswapV2Router.WETH();

        _approve(address(this), address(pancakeswapV2Router), tokenAmount);

        pancakeswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            recipient,
            block.timestamp
        );

        emit SwapTokensForETH(tokenAmount, path, recipient);
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");
        require(balanceOf(from) >= amount, "BEP20: transfer amount exceeds balance");

        if ((from == pancakeswapV2Pair || to == pancakeswapV2Pair) && _liquidityAdded && !inSwapAndLiquify && (!_isExcludedFromFee[from] && !_isExcludedFromFee[to])) 
        {
            uint8 marketingTaxPercentage = 0;
            if (from != pancakeswapV2Pair) { // sell tx
                 uint256 contractTokenBalance = balanceOf(address(this));
                if (contractTokenBalance >= _numTokensSellToAddToETH) {
                    _swapTokensForEth(contractTokenBalance, marketingWallet);
                }
                marketingTaxPercentage = sellMarketingTaxPercentage;
            }
            else // buy tx
            {
                marketingTaxPercentage = buyMarketingTaxPercentage;
            }

            uint256 marketingAmount = ((amount * marketingTaxPercentage) / 100);
            super._transfer(from, address(this), marketingAmount);
            super._transfer(from, to, (amount - marketingAmount));
        }
        else {
            if (!_liquidityAdded && to == pancakeswapV2Pair && from == owner()) {
                _liquidityAdded = true;
            }
            super._transfer(from, to, amount);
        }
    }

    function excludeFromFee(address account, bool flag) external onlyOwner returns (bool) {
        _isExcludedFromFee[account] = flag;
        return true;
    }

    function isExcludedFromFee(address account) external view returns (bool) {
        return _isExcludedFromFee[account];
    }
}