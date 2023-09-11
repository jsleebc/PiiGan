// SPDX-License-Identifier: Unlicensed

/**
Telegram: https://t.me/DogeWar_Room
Web: https://dogewar.io/
Twitter: https://twitter.com/DogeWarRoom
*/

pragma solidity ^0.8.19;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

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

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
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

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
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

contract DogeWar is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    string private _name = unicode"Doge War";
    string private _symbol = unicode"DOGW";

    bool private swapping;
    uint256 public swapTokensAtAmount;

    bool public tradingEnabled = false;
    bool public limitsInEffect = true;

    address public marketingWallet;

    uint256 public buyFee;
    uint256 public sellFee;

    uint256 public maxTransactionAmount;
    uint256 public maxWallet;

    mapping(address => bool) private isExcludedFromFees;
    mapping(address => bool) private isExcludedMaxTransactionAmount;
    mapping(address => bool) private pairs;

    constructor(uint256 _buyFee, uint256 _sellFee) ERC20(_name, _symbol) {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Router = _uniswapV2Router;
        excludeFromMaxTransactionAmount(address(_uniswapV2Router), true);

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        pairs[address(uniswapV2Pair)] = true;
        excludeFromMaxTransactionAmount(address(uniswapV2Pair), true);

        uint256 totalSupply = 1000000000 * 10**decimals();
        maxTransactionAmount = totalSupply.mul(2).div(100);
        maxWallet = totalSupply.mul(2).div(100);
        swapTokensAtAmount = totalSupply.mul(1).div(1000);

        marketingWallet = address(0xf97b05c16B9AFCaEB6Fa036193622C720F8916C2);

        buyFee = _buyFee;
        sellFee = _sellFee;

        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(marketingWallet, true);

        excludeFromMaxTransactionAmount(owner(), true);
        excludeFromMaxTransactionAmount(address(this), true);
        excludeFromMaxTransactionAmount(address(0xdead), true);
        excludeFromMaxTransactionAmount(marketingWallet, true);

        _mint(marketingWallet, totalSupply.mul(125).div(1000));
        _mint(_msgSender(), totalSupply.mul(875).div(1000));
    }

    receive() external payable {}

    function openTrading() external onlyOwner {
        require(!tradingEnabled, "Trading is already open");
        tradingEnabled = true;
    }

    function removeLimits() external onlyOwner {
        require(limitsInEffect == true, "The limits has been removed.");
        limitsInEffect = false;
    }

    function setFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
        require((_buyFee + _sellFee) <= 20, "Must keep fees at 20% or less");
        buyFee = _buyFee;
        sellFee = _sellFee;
    }

    function excludeFromMaxTransactionAmount(address _address, bool excluded) public onlyOwner {
        isExcludedMaxTransactionAmount[_address] = excluded;
    }

    function excludeFromFees(address _address, bool excluded) public onlyOwner {
        isExcludedFromFees[_address] = excluded;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(from != address(0), "ERC20: transfer from the zero address.");
        require(to != address(0), "ERC20: transfer to the zero address.");
        require(amount > 0, "ERC20: transfer amount must be greater than zero.");

        if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
            if (!tradingEnabled) {
                require(isExcludedFromFees[from] || isExcludedFromFees[to], "Trading is not active.");
            }

            if (limitsInEffect) {
                if (pairs[from] && !isExcludedMaxTransactionAmount[to]) {
                    require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the max transaction amount.");
                    require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded.");
                } else if (pairs[to] && !isExcludedMaxTransactionAmount[from]) {
                    require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the max transaction amount.");
                } else if (!isExcludedMaxTransactionAmount[to]) {
                    require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded.");
                }
            }
        }

        bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
        if (
            canSwap &&
            !swapping &&
            !pairs[from] &&
            !isExcludedFromFees[from] &&
            !isExcludedFromFees[to]
        ) {
            swapping = true;
            swapBack();
            swapping = false;
        }

        bool takeFee = !swapping;

        if (isExcludedFromFees[from] || isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        if (takeFee) {
            if (pairs[to] && sellFee > 0) {
                fees = amount.mul(sellFee).div(100);
            } else if (pairs[from] && buyFee > 0) {
                fees = amount.mul(buyFee).div(100);
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }
            amount -= fees;
        }
        super._transfer(from, to, amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        bool success;

        if (contractBalance == 0) {
            return;
        }

        if (contractBalance > swapTokensAtAmount * 10) {
            contractBalance = swapTokensAtAmount * 10;
        }

        swapTokensForEth(contractBalance);
        (success, ) = address(marketingWallet).call{value: address(this).balance}("");
    }

    function manualSwap() external onlyOwner {
        swapping = true;
        uint256 contractBalance = balanceOf(address(this));
        bool success;

        if (contractBalance == 0) {
            return;
        }

        swapTokensForEth(contractBalance);
        (success, ) = address(marketingWallet).call{value: address(this).balance}("");
        swapping = false;
    }
}