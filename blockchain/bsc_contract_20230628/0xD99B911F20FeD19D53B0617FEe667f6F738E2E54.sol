/**
 *Submitted for verification at BscScan.com on 2022-04-19
*/

pragma solidity ^0.8.6;

// SPDX-License-Identifier: Unlicensed
interface IERC20 {
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
     * Emits a {Transfer} event.
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

abstract contract Ownable {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor ()  {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }   
    
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
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
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
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
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
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
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

interface ERC721  {
   function balanceOf(address owner) external view   returns (uint256) ;
}

contract GPLToken is IERC20, Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    string private _name = "GPL";
    string private _symbol =  "GPL";
    uint8 private _decimals = 18;
    uint256 private _tTotal = 10000000000 * 10**18;

    uint256 private _medicalFee = 500;
    uint256 private _consumeFee = 1000;

    
    
    address private _medicalAddress;
    address private _consumeAddress;

    address private _businessNft = address(0x0);

    function setBusinessNft(address businessNft) public onlyOwner {
        _businessNft = businessNft;
    }

    function  getBusinessNft() public view returns(address) {
        return _businessNft;
    }


    function setMedicalAddress(address medicalAddress) public onlyOwner {
        _medicalAddress = medicalAddress;
    }

    function  getMedicalAddress() public view returns(address) {
        return _medicalAddress;
    }

    function setConsumeAddress(address consumeAddress) public onlyOwner {
        _consumeAddress = consumeAddress;
    }

    function  getConsumeAddress() public view returns(address) {
        return _consumeAddress;
    }

    constructor(address recv,address medicalAddress ,address consumeAddress) {
        _tOwned[recv] = _tTotal;
        _medicalAddress = medicalAddress ;
        _consumeAddress = consumeAddress;
        emit Transfer(address(0),msg.sender, _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
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




    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

 
    function isBusiness( address _addr ) internal view returns (bool addressCheck) { 
       return _businessNft!=address(0x0) && ERC721(_businessNft).balanceOf(_addr) > 0;
    }

    event TransforLog(address indexed from,address indexed to,uint256 indexed value); 
    function _transfer(  
        address from,
        address to,
        uint256 amount
        ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount <= _tOwned[from]);
        if(!isBusiness(to)){
            _bacistransfer(from,to,amount);    
        }
        else{
            _maintransfer(from,to,amount);
            emit TransforLog(from, to, amount);
        }      
    }
    function _bacistransfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        _tOwned[sender] = _tOwned[sender].sub(amount);    
        _tOwned[recipient] = _tOwned[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }


    function _maintransfer(
        address from,
        address to,
        uint256 amount
        ) private {        
        _transferStandard(from, to, amount);
    }  

    function _burntransfer(
        address from,
        uint256 amount
        ) private {
        _tOwned[from] = _tOwned[from].sub(amount);          
        _tOwned[address(0)] = _tOwned[address(0)].add(amount);   
        emit Transfer(from, address(0),amount);    
    }


   
	event BuyLog(uint256 indexed burn,uint256 indexed medical,uint256 indexed consumeFee); 
    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
        ) private {
        uint256 recipientRate = 10000 -
            _medicalFee -
            _consumeFee ;
        _bacistransfer(sender,recipient,tAmount.mul(recipientRate).div(10000));
         _bacistransfer(sender,_medicalAddress, tAmount.mul(_medicalFee).div(10000));
        _bacistransfer(sender, _consumeAddress,tAmount.mul(_consumeFee).div(10000));
        
        emit BuyLog(tAmount.mul(recipientRate).div(10000), tAmount.mul(_medicalFee).div(10000), tAmount.mul(_consumeFee).div(10000));
        
    }  
    address private USDT = address(0x55d398326f99059fF775485246999027B3197955);
    address private router = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    function getPrice() public view returns(uint256){
        address[] memory routerAddress = new address[](2);
        routerAddress[0] = USDT;
        routerAddress[1] = address(this);
        uint[] memory amounts = IUniswapV2Router01(router).getAmountsIn(1*10**18,routerAddress);
        return amounts[0];
    }
    address private _uniswapV2Pair;
    function changeUniswapV2Pair(address uniswapV2Pair)  public onlyOwner {
        _uniswapV2Pair = uniswapV2Pair;
    }

    function getUniswapV2Pair() external view returns (address) {
        return _uniswapV2Pair;
    }

    function getLiquidity(address owner,address token) public view returns(uint256){
        uint256 _totalSupply = IERC20(_uniswapV2Pair).totalSupply();
        uint256 _balance = IERC20(token).balanceOf(_uniswapV2Pair);
        return _balance * IERC20(_uniswapV2Pair).balanceOf(owner)/_totalSupply;
    }
}
interface IUniswapV2Router01 {
    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}