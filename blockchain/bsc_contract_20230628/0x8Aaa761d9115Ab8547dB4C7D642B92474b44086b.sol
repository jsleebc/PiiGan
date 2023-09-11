// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
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

interface ISwapRouter {
    function factory() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
}

interface ISwapFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TokenDistributor {
    constructor(address token) {
        IERC20(token).approve(msg.sender, uint256(~uint256(0)));
    }
}

abstract contract AbsToken is IERC20, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _whitelist;

    address public fundAddress;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    uint256 private _tTotal;
    ISwapRouter public _swapRouter;
    address public _usdt;
    mapping(address => bool) public _swapPairList;

    TokenDistributor public _tokenDistributor;

    uint256 private constant MAX = ~uint256(0);

    address public _mainPair;

    uint256 public maxTXAmount = 100000 ether;

    uint256 public unlocktimestamp;

    bool public limit = true;

    uint256 public totalLP;

    constructor(
        address RouterAddress,
        address USDTAddress,
        string memory Name,
        string memory Symbol,
        uint8 Decimals,
        uint256 Supply,
        address FundAddress
    ) {
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        IERC20(USDTAddress).approve(address(swapRouter), MAX);

        _usdt = USDTAddress;
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), USDTAddress);
        IERC20(swapPair).approve(address(swapRouter), MAX);
        _mainPair = swapPair;
        _swapPairList[swapPair] = true;

        uint256 total = Supply * 10 ** Decimals;

        _tTotal = total;

        _balances[FundAddress] = total;

        _whitelist[address(this)] = true;
        _whitelist[FundAddress] = true;
        _whitelist[msg.sender] = true;

        emit Transfer(address(0), FundAddress, total);

        fundAddress = FundAddress;

        _tokenDistributor = new TokenDistributor(_usdt);
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
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

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] =
                _allowances[sender][msg.sender] -
                amount;
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");
        uint256 fee = 0;
        if (!_whitelist[from] && !_whitelist[to]) {
            fee = amount / 10;
            if (limit && IERC20(_usdt).balanceOf(_mainPair) <= 10000 ether) {
                if (_swapPairList[from]) {
                    require(balanceOf(to) + amount <= maxTXAmount, "error");
                }
            }

            if (limit && IERC20(_usdt).balanceOf(_mainPair) > 10000 ether) {
                limit = false;
            }

            uint256 totalLPAmount = IERC20(_mainPair).totalSupply();

            if (_swapPairList[to]) {
                uint256 tokenFeeAmount = balanceOf(address(this));
                if (tokenFeeAmount > _tTotal / 10000) {
                    swapAndSendDividends(tokenFeeAmount);
                }
                uint256 burnAmount = amount / 2;
                if (
                    totalLPAmount > 0 &&
                    IERC20(_mainPair).balanceOf(address(this)) > totalLP / 2
                ) {
                    uint256 pairAmount = balanceOf(_mainPair);
                    uint256 liquidity = (totalLPAmount * burnAmount) /
                        2 /
                        pairAmount;
                    uint256 before = balanceOf(address(this));
                    try
                        _swapRouter.removeLiquidity(
                            _usdt,
                            address(this),
                            liquidity,
                            0,
                            0,
                            address(this),
                            block.timestamp
                        )
                    {
                        _tokenTransfer(
                            address(this),
                            address(0xdead),
                            balanceOf(address(this)) - before
                        );
                        uint256 totalUSDT = IERC20(_usdt).balanceOf(
                            address(this)
                        );
                        address[] memory path = new address[](2);
                        path[0] = _usdt;
                        path[1] = address(this);
                        _swapRouter
                            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                                totalUSDT,
                                0,
                                path,
                                address(0xdead),
                                block.timestamp
                            );
                    } catch {}
                }
            }
        }

        if (fee > 0) {
            _tokenTransfer(from, address(this), fee);
            amount = amount - fee;
        }
        _tokenTransfer(from, to, amount);
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        _balances[recipient] = _balances[recipient] + tAmount;
        emit Transfer(sender, recipient, tAmount);
    }

    function swapAndSendDividends(uint256 tokenAmount) private {
        _approve(address(this), address(_swapRouter), tokenAmount);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount / 2,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );

        uint256 usdtBalance = IERC20(_usdt).balanceOf(
            address(_tokenDistributor)
        );

        IERC20(_usdt).transferFrom(
            address(_tokenDistributor),
            address(this),
            usdtBalance
        );

        _swapRouter.addLiquidity(
            address(this),
            _usdt,
            tokenAmount / 2,
            usdtBalance,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
    }

    function setMaxTXAmount(uint256 _maxTXAmount) public onlyOwner {
        maxTXAmount = _maxTXAmount;
    }

    function setTotalLP(uint256 _totalLP) public onlyOwner {
        totalLP = _totalLP;
    }

    function lockLP() public onlyOwner {
        unlocktimestamp = block.timestamp + 30 days;
    }

    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
    }

    function claimToken(address token, address to) external {
        require(msg.sender == fundAddress, "error");
        require(token != address(this), "error");
        if (token == _mainPair) {
            require(block.timestamp >= unlocktimestamp, "error");
        }
        IERC20(token).transfer(to, IERC20(token).balanceOf(address(this)));
    }

    receive() external payable {}
}

contract AutoBurnCoin is AbsToken {
    constructor()
        AbsToken(
            address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
            address(0x55d398326f99059fF775485246999027B3197955),
            "AutoBurnCoin",
            "ABC",
            18,
            100000000,
            address(0x2A7C908011BF91A9a9b86ed25D113e7B5B999999)
        )
    {}
}