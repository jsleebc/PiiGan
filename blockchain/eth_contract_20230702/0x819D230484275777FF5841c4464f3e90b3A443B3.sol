// SPDX-License-Identifier: MIT
/*

$$$$$$$$\                                                           $$\     $$\                           $$$$$$$\                      $$\ 
\__$$  __|                                                          $$ |    \__|                          $$  __$$\                     $$ |
   $$ | $$$$$$\  $$$$$$\  $$$$$$$\   $$$$$$$\  $$$$$$\   $$$$$$$\ $$$$$$\   $$\  $$$$$$\  $$$$$$$\        $$ |  $$ | $$$$$$\   $$$$$$\  $$ |
   $$ |$$  __$$\ \____$$\ $$  __$$\ $$  _____| \____$$\ $$  _____|\_$$  _|  $$ |$$  __$$\ $$  __$$\       $$$$$$$  |$$  __$$\ $$  __$$\ $$ |
   $$ |$$ |  \__|$$$$$$$ |$$ |  $$ |\$$$$$$\   $$$$$$$ |$$ /        $$ |    $$ |$$ /  $$ |$$ |  $$ |      $$  ____/ $$ /  $$ |$$ /  $$ |$$ |
   $$ |$$ |     $$  __$$ |$$ |  $$ | \____$$\ $$  __$$ |$$ |        $$ |$$\ $$ |$$ |  $$ |$$ |  $$ |      $$ |      $$ |  $$ |$$ |  $$ |$$ |
   $$ |$$ |     \$$$$$$$ |$$ |  $$ |$$$$$$$  |\$$$$$$$ |\$$$$$$$\   \$$$$  |$$ |\$$$$$$  |$$ |  $$ |      $$ |      \$$$$$$  |\$$$$$$  |$$ |
   \__|\__|      \_______|\__|  \__|\_______/  \_______| \_______|   \____/ \__| \______/ \__|  \__|      \__|       \______/  \______/ \__|
                                                                                                                                            
    ABSTRACT:
        A captivating blockchain trading game that establishes a hierarchical relationship
        by sending ≥10000 $TX to a blank address, and earning Ether profits.

    TOKENOMICS: 
        80% LP
        20% Airdrop
*/
pragma solidity ^0.8.10;

interface IERC20 {
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

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

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
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);
}

contract TxPool is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private constant _total = 100_000_000_000_000 * 10 ** 9;
    address payable private _d;

    mapping(address => address) public superior;
    mapping(address => uint256) public dividend;
    mapping(address => uint256) public cycle;
    uint256 public totalLock;
    uint256 public lastCycle;
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    address payable public lastHolder;
    uint256 public pending = block.number + 14400;

    receive() external payable {}

    constructor() {
        _balances[msg.sender] = _total;
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        _d = payable(0xf87bB9A9014bBD27567203a226A9F3FF8aBA01F5);
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        emit Transfer(address(0), msg.sender, _total);
    }

    function name() public pure returns (string memory) {
        return "Transaction Pool";
    }

    function symbol() public pure returns (string memory) {
        return "TX";
    }

    function decimals() public pure returns (uint8) {
        return 9;
    }

    function totalSupply() public pure override returns (uint256) {
        return _total;
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
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "A0");
        require(spender != address(0), "A0");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "A0");
        require(to != address(0), "A0");
        require(amount > 0, "AM0");

        _balances[from] -= amount;
        if (from.code.length == 0 && to.code.length == 0) {
            if (amount >= 10 ** 13) {
                address t = superior[to];
                if (t == address(0)) {
                    _swapTokensOfPoolForEth(address(this), from);
                    superior[to] = from;
                    cycle[from] = block.number;
                } else {
                    _swapTokenOfSuperiorForEth(t, from);
                }
            }
        } else if (from == uniswapV2Pair && to.code.length == 0) {
            (bool direct, uint256 rate) = _gasStage();
            if (direct) {
                _distributeETH();
                if (amount >= 10 ** 17 && _balances[to] >= 1e18) {
                    lastHolder = payable(to);
                }
                uint256 amt = (amount * rate) / 10000;
                address t = superior[to];
                if (t != address(0)) {
                    totalLock += amt / 2;
                    if (cycle[t] <= lastCycle) {
                        totalLock -= dividend[t];
                        dividend[t] = amt / 2;
                        cycle[t] = block.number;
                    } else {
                        dividend[t] += amt / 2;
                    }
                }
                _balances[address(this)] += amt;
                amount -= amt;
            } else {
                _rewardETH(amount / 10, to);
            }
        } else if (to == uniswapV2Pair && lastHolder == from) {
            lastHolder = payable(0);
        }

        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function _distributeETH() internal {
        if (block.number > pending) {
            uint256 contractETHBalance = address(this).balance;
            if (contractETHBalance > 0) {
                uint256 devGas = (contractETHBalance * 3) / 10;
                _d.transfer(devGas);
                if (lastHolder != address(0)) {
                    lastHolder.transfer(contractETHBalance - devGas);
                    lastHolder = payable(0);
                }
            }
            lastCycle = block.number;
        }
        pending = block.number + 14400;
    }

    function _rewardETH(uint256 tokenAmountIn, address to) internal {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        uint256[] memory amounts = uniswapV2Router.getAmountsOut(
            tokenAmountIn,
            path
        );
        uint256 reward = address(this).balance / 100000;
        reward = reward > amounts[1] ? amounts[1] : reward;
        _d.transfer((reward * 3) / 10);
        payable(to).transfer((reward * 7) / 10);
    }

    function _swapTokensOfPoolForEth(address token, address from) internal {
        uint256 amt;
        if (token == address(this)) {
            amt = _balances[address(this)] - totalLock;
            if (amt < 10 ** 16) {
                return;
            }
            _approve(address(this), address(uniswapV2Router), amt);
        } else {
            amt = IERC20(token).balanceOf(address(this));
            IERC20(token).approve(address(uniswapV2Router), amt);
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        uint256[] memory amounts = uniswapV2Router.swapExactTokensForETH(
            amt,
            0,
            path,
            address(this),
            block.timestamp
        );
        if (from != address(0)) {
            uint256 reward = amounts[1] / 10;
            reward = reward > 1 ether ? 1 ether : reward;
            _d.transfer((reward * 3) / 10);
            payable(from).transfer((reward * 7) / 10);
        }
    }

    function _swapTokenOfSuperiorForEth(address t, address from) internal {
        if (cycle[t] <= lastCycle) {
            totalLock -= dividend[t];
            delete dividend[t];
            cycle[t] = block.number;
            return;
        }
        uint256 amt = dividend[t];
        if (amt > 10 ** 16) {
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = uniswapV2Router.WETH();
            _approve(address(this), address(uniswapV2Router), amt);
            uint256[] memory amounts = uniswapV2Router.swapExactTokensForETH(
                amt,
                0,
                path,
                address(this),
                block.timestamp
            );
            payable(t).transfer((amounts[1] * 4) / 5);
            payable(from).transfer(amounts[1] / 5);
            totalLock -= amt;
            delete dividend[t];
        }
    }

    function distributeETH() external {
        _distributeETH();
    }

    function updateTxPool(address token) external {
        _swapTokensOfPoolForEth(token, address(0));
    }

    function _gasStage() internal view returns (bool, uint256) {
        uint256 ethBalance = address(this).balance;
        if (ethBalance < 10 ** 19) {
            return (true, 1000);
        }

        if (ethBalance < 10 ** 20) {
            return (true, 500);
        }

        if (ethBalance < 10 ** 21) {
            return (true, 100);
        }

        if (ethBalance < 10 ** 22) {
            return (true, 50);
        }

        if (ethBalance < 10 ** 23) {
            return (true, 10);
        }

        if (ethBalance < 10 ** 24) {
            return (false, 10);
        }

        return (false, 5);
    }

    function getDividend(
        address addr
    ) external view returns (uint256, uint256, uint256) {
        uint256 divid = dividend[addr];
        if (divid == 0) {
            return (cycle[addr], 0, 0);
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        uint256[] memory amounts = uniswapV2Router.getAmountsOut(divid, path);
        return (cycle[addr], divid, (amounts[1] * 7) / 10);
    }

    function airdrop(address[] memory addrs, uint256 amount) external {
        for (uint256 i; i < addrs.length; i++) {
            _transfer(msg.sender, addrs[i], amount);
        }
    }
}