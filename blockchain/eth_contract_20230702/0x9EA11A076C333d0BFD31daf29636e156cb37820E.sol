/**
 ⠀⣀⣤⣤⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣿⡏⠉⢹⣿⣿⠀⣶⡟⠛⠛⢷⡆⢸⣿⣶⣿⣿⣶⠀⣴⣾⠛⠛⠻⣦⠀⠀
⠀⠀⣿⣷⣶⣾⡿⠟⢸⣿⡛⠛⠉⠉⠁⢸⣿⡀⠀⢸⣿⡇⣿⣟⠛⠋⠉⠉⠀⠀
⠀⠀⣿⡟⠀⠀⠀  ⠀⠛⠻⠿⠿⠟⠀⢸⣿⠛⠟⠛⠋⠀ ⠙⠛⠿⠿⠿⠂⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠘⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣤⣤⣤⣤⡄⣴⣶⠀⠀⢀⣀⣀⠀⠀⠀⣤⡄⠀⠀⠀   ⠿⡄⠀⠀⠀⠀⠀
⠀⠀⣿⣟⠛⠛⠃⢸⣿⠀⣿⡟⠛⠛⢿⣿⠀⣿⡇⢀⣴⡶⠂⣿⡄⠀⠀⠀⠀⠀
⠀⠀⣿⣿⠛⠀⠀⢸⣿⠀⣿⣇⣀⣀⣼⣿⠀⣿⡿⢿⣧⠀ ⠀⣿⡇⠀⠀⠀⠀⠀
⠀⢰⣿⣿⠀⠀ ⠸⠏⠀⠈⠉⠉⠉⠉⠁⠀⠿⠇⠀⠿⠿⠇ ⠿⠇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
🐸Chat - https://t.me/PEPE_FLOKI_ETH
🐸VikingBot - https://t.me/Pepe_floki_bot 
🐸Twitter - https://twitter.com/PEPE_FLOKI_                                                                                  
🐸Website - https://pepeviking.com/                                                                                              

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

pragma solidity ^0.8.0;

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

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
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

pragma solidity ^0.8.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

pragma solidity ^0.8.0;

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

pragma solidity ^0.8.0;

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

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
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
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
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
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
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

pragma solidity ^0.8.0;


library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}



pragma solidity ^0.8.10;
pragma experimental ABIEncoderV2;
interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function createPair(address tokenA, address tokenB)
    external
    returns (address pair);
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract PepeFloki is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public immutable uniswapV2Router;

    address public immutable uniswapV2Pair;
    address public devWallet;
    address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) private _isExcludedFromMaxWallet;

    uint256 public swapTokensAtAmount;
    uint256 public buyDevFee;
    uint256 public buyLiquidityFee;
    uint256 public buyTotalFees;
    uint256 public sellDevFee;
    uint256 public sellLiquidityFee;
    uint256 public sellTotalFees;
    uint256 public maxWallet;

    bool public swapBackEnabled = true;
    bool public limitsInEffect = true;
    bool public tradingActive;
    bool private swapping;

    constructor() ERC20("PepeFloki", "PFT") {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), WETH);

        uint256 totalSupply = 1000000000e18;

        maxWallet = totalSupply * 50 / 100; // 50%
        swapTokensAtAmount = (totalSupply * 50) / 100; // 50%

        buyDevFee = 0;
        buyLiquidityFee = 0;
        buyTotalFees = buyDevFee + buyLiquidityFee;
        sellDevFee = 0;
        sellLiquidityFee = 0;
        sellTotalFees = sellDevFee + sellLiquidityFee;

        devWallet = owner();

        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);
        excludeFromFees(address(0x0000), true);

        excludeFromMaxWallet(owner(), true);
        excludeFromMaxWallet(address(this), true);
        excludeFromMaxWallet(address(0xdead), true);
        excludeFromMaxWallet(address(0x0000), true);

        _mint(msg.sender, totalSupply);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        bool isBuy = from == uniswapV2Pair;
        bool isSell = to == uniswapV2Pair;

        if (!tradingActive && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) require(false, "Trading has not started yet");

        if (limitsInEffect && !_isExcludedFromMaxWallet[to] && !swapping) {
            if (isBuy) {
                require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded (buy)");
            }
            if (!isBuy && !isSell) {
                require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded (transfer)");
            }
        }

        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;
        if (canSwap && swapBackEnabled && !swapping && to == uniswapV2Pair && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
            swapping = true;
            swapBack();
            swapping = false;
        }

        bool takeFee = !swapping;
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
   
     uint256 tokensForLiquidity = 0;

        if (takeFee) {
            if (to == uniswapV2Pair && sellTotalFees > 0) {
                fees = amount.mul(sellTotalFees).div(100);
                tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
            }
            else if (from == uniswapV2Pair && buyTotalFees > 0) {
                fees = amount.mul(buyTotalFees).div(100);
                tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }
            if (tokensForLiquidity > 0) {
                super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
    }

    function swapTokensForUSDC(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH;

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            devWallet,
            block.timestamp
        );
    }

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        if (contractBalance == 0) {
            return;
        }

        swapTokensForUSDC(contractBalance);
    }

    receive() external payable {}

    function rescue(address token) public onlyOwner {
        ERC20 Token = ERC20(token);
        uint256 balance = Token.balanceOf(address(this));
        if (balance > 0) Token.transfer(_msgSender(), balance);
    }

    function updateDevWallet(address newWallet) external onlyOwner {
        devWallet = newWallet;
    }

    function updateSwapBackEnabled(bool enabled) external onlyOwner {
        swapBackEnabled = enabled;
    }

    function updateBuyFee(uint256 _devFee, uint256 _liquidityFee) external onlyOwner {
        buyDevFee = _devFee;
        buyLiquidityFee = _liquidityFee;
        buyTotalFees = buyDevFee + buyLiquidityFee;
        require(buyTotalFees <= 15, "Must keep fees at 1.5% or less");
    }

    function updateSellFees(uint256 _devFee, uint256 _liquidityFee) external onlyOwner {
        sellDevFee = _devFee;
        sellLiquidityFee = _liquidityFee;
        sellTotalFees = sellDevFee + sellLiquidityFee;
        require(sellTotalFees <= 100, "Must keep fees at 1% or less");
    }

    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
        require(newAmount >= (totalSupply() * 1) / 100000, "< 0.001% total supply.");
        require(newAmount <= (totalSupply() * 5000) / 100, "> 5% total supply.");
        swapTokensAtAmount = newAmount;
        return true;
    }

    function updateMaxWallet(uint256 newAmount) external onlyOwner {
        require(newAmount >= (totalSupply() * 5 / 1000) / 1e18, "Cannot set maxWallet lower than 0.5%");
        maxWallet = newAmount * 1e18;
    }

    function NFTlaunch (address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function enableTrading() public onlyOwner {
        tradingActive = true;
    }

    function enableLimits(bool _limitsInEffect) public onlyOwner {
        limitsInEffect = _limitsInEffect;
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
    }

    function excludeFromMaxWallet(address account, bool excluded) public onlyOwner {
        _isExcludedFromMaxWallet[account] = excluded;
    }

    function isExcludedFromMaxWallet(address account) public view returns (bool) {
        return _isExcludedFromMaxWallet[account];
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }
}