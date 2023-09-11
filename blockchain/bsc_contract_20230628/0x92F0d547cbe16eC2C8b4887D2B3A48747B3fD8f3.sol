// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ISwapRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

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

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);


    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);


    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

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

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface ISwapPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!o");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "n0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

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
        return a + b;
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
        return a - b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
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
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
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


abstract contract AbsToken is IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _tTotal;

    mapping(address => bool) public feeWhiteList;
    mapping(address => bool) public botBlackLists;

    address public fundAddr;
    address public marketAddr1;
    address public marketAddr2;
    address public teckAddr;
    address public LPRewardAddr;
    address public nodeRewardAddr;

    address public operator;

    ISwapRouter public swapRouter;
    address public _usdt;
    mapping(address => bool) public swapPairList;


    uint256 private constant MAX = ~uint256(0);

    uint256 public buyFee = 100;
    uint256 public sellFee = 600;
    uint256 public normalTransFee = 500;
    uint256 public addLiquidityFee = 100;

    uint256 public lpRewardCondition;

    uint256 public startTradeBlock;
    uint256 public startAddLPBlock;
    address public _mainPair;

    mapping(address => bool) public isLPHolder;
    address[] public LPHolders;

    constructor (
        address RouterAddress,
        address USDTAddress,
        string memory Name,
        string memory Symbol,
        uint8 Decimals,
        uint256 Supply,
        address FundAddress,
        address ReceiveAddress
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        uint256 total = Supply * 10 ** Decimals;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);

        _usdt = USDTAddress;

        ISwapRouter _swapRouter = ISwapRouter(RouterAddress);
        swapRouter = _swapRouter;

        IERC20(USDTAddress).approve(address(_swapRouter), MAX);
        _allowances[address(this)][address(_swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(_swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), USDTAddress);
        _mainPair = swapPair;
        swapPairList[swapPair] = true;

        fundAddr = FundAddress;

        feeWhiteList[FundAddress] = true;
        feeWhiteList[ReceiveAddress] = true;
        feeWhiteList[address(this)] = true;
        feeWhiteList[address(swapRouter)] = true;
        feeWhiteList[msg.sender] = true;
        feeWhiteList[address(0)] = true;
        feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;
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
        uint256 balance = _balances[account];
        return balance;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function _transfer(address from,address to,uint256 amount) private {
        uint256 balance = balanceOf(from);
        require(balance >= amount, "BNE");

        bool takeFee = false;

        if (!feeWhiteList[from] && !feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
        }

        if (swapPairList[from] || swapPairList[to]) {
            if (startAddLPBlock == 0 && _mainPair == to && feeWhiteList[from] && IERC20(to).totalSupply() == 0) {
                startAddLPBlock = block.number;
            }

            if (!feeWhiteList[from] && !feeWhiteList[to]) {
                require(0 < startTradeBlock, "!!!T");
                takeFee = true;

                if (block.number < startTradeBlock + 4) {
                    _killTransfer(from, to, amount);
                    return;
                }

                if(botBlackLists[from] || botBlackLists[to]){
                    _killTransfer(from, to, amount);
                    return;
                }
            }
        }

        if (swapPairList[to] && feeWhiteList[from]) {
            takeFee = false;
        }

        _tokenTransfer(from, to, amount, takeFee);

        if (from != address(this) && swapPairList[to]) {
            if (!isLPHolder[from]) {
                isLPHolder[from] = true;
                LPHolders.push(from);
            }
        }
    }

    function _killTransfer(address sender,address recipient,uint256 tAmount) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount = tAmount * 99 / 100;
        _takeTransfer(sender,address(0x000000000000000000000000000000000000dEaD),feeAmount);
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function _tokenTransfer(address sender,address recipient,uint256 tAmount,bool takeFee) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 fundAmount;
        bool isAddLP;

        if (takeFee) {
            if (swapPairList[sender]) {//Buy && remove Liquidity
                fundAmount = tAmount * buyFee / 10000;
                _takeTransfer(sender, fundAddr, fundAmount);
            } else if (swapPairList[recipient]) {//sell && add liquidity
                isAddLP = _isAddLiquidity(tAmount);
                if(isAddLP){
                    fundAmount =  tAmount * addLiquidityFee / 10000;
                    _takeTransfer(sender, fundAddr, fundAmount);
                }else{
                    fundAmount = tAmount * sellFee / 10000;
                    uint256 tmpAmount = fundAmount.div(5);
                    _takeTransfer(sender, marketAddr1, tmpAmount);
                    _takeTransfer(sender, marketAddr2, tmpAmount);
                    _takeTransfer(sender, teckAddr, tmpAmount);
                    _takeTransfer(sender, LPRewardAddr, tmpAmount);
                    _takeTransfer(sender, nodeRewardAddr, tmpAmount);
                }
            }
        }

        uint256 burnFee =   0;
        if(!feeWhiteList[sender] &&!(swapPairList[sender]||swapPairList[recipient])&&recipient!=address(0x000000000000000000000000000000000000dEaD)&&recipient!=address(this)){
            burnFee =   tAmount * normalTransFee / 10000;
            _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), burnFee);
        }

        _takeTransfer(sender, recipient, tAmount - fundAmount - burnFee);
    }

    function _takeTransfer(address sender,address to,uint256 tAmount) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function setBotBlack(address target,bool _status) public onlyOwner {
        botBlackLists[target] = _status;
    }

    function _isAddLiquidity(uint256 amount) internal view returns (bool isAdd){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0, uint256 r1,) = mainPair.getReserves();

        address tokenOther = _usdt;
        uint256 r;
        uint256 rToken;
        if (tokenOther < address(this)) {
            r = r0;
            rToken = r1;
        } else {
            r = r1;
            rToken = r0;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        if (rToken == 0) {
            isAdd = bal > r;
        } else {
            isAdd = bal > r + r * amount / rToken / 2;
        }
    }

    modifier onlyOperator() {
        require(msg.sender == operator, "Only operator");
        _;
    }

    function setOperator(address newOperator) public onlyOwner {
        operator = newOperator;
    }

    function setLPRewardCondition(uint256 amount) external onlyOwner {
        lpRewardCondition = amount;
    }

    function setFundAddress(address _fundAddr,address _marketAddr1,address _marketAddr2,address _LPRewardAddr,address _teckAddr,address _nodeRewardAddr) external onlyOperator {
        fundAddr = _fundAddr;
        feeWhiteList[_fundAddr] = true;
        marketAddr1 = _marketAddr1;
        marketAddr2 = _marketAddr2;
        teckAddr = _teckAddr;
        LPRewardAddr = _LPRewardAddr;
        nodeRewardAddr = _nodeRewardAddr;
    }

    function setFee(uint256 _buyFee,uint256 _sellFee,uint256 _normalTransFee) external  onlyOwner {
        buyFee = _buyFee;
        sellFee = _sellFee;
        normalTransFee = _normalTransFee;
    }

    function startTrade() external onlyOwner {
        require(0 == startTradeBlock, "!trading");
        startTradeBlock = block.number;
        sellFee = 9000;
        normalTransFee = 9000;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyOwner {
        feeWhiteList[addr] = enable;
    }

    function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            feeWhiteList[addr[i]] = enable;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        swapPairList[addr] = enable;
    }

    function claimBalance() external onlyOperator{
        payable(fundAddr).transfer(address(this).balance);
    }

    function claimToken(address token, uint256 amount) external onlyOperator{
        IERC20(token).transfer(fundAddr, amount);
    }

    receive() external payable {}
}

contract T1 is AbsToken {
    constructor() AbsToken(
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
        address(0x55d398326f99059fF775485246999027B3197955),
        "T1",
        "T1",
        18,
        10000000,
        address(0x09eAD65f2Aa918b4F276A80BD9406CD9001b72c8),//fundAddress
        address(0xF5cb8bbDE2cb681a115d356B6aB5B500EAFABb41) //receiveAddress
    ){

    }
}