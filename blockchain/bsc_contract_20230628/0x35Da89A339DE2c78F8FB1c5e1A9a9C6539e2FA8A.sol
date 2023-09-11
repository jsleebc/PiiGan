// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

interface IERC20  {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Context {
    constructor ()  { }

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract UtilityNet is Context, IERC20, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint8 private _decimals;
    string private _symbol;
    string private _name;
    address private _creator;

    uint256 public dailyMint = 2500000*(10**18); // 250w per day = 10yi/200day
    uint256 public roundDays = 200;
    uint256 public perDay = 86400;
    mapping(uint => bool) public roundMap;

    uint256 public mineStartTime = block.timestamp;
    uint256 public mineLastTime = block.timestamp;

    uint256 public totalMined;
    address public walletMiner = 0x0e67E526d66d0C04e9bfb40e6E52837BdebAa0fb;
    address public walletRecipient = 0x613fF0a7CbA8F3757e9A8Aa0B36e29c5c488BBb5;
    address public walletDao = 0x65a6F597a67440270172B5F559CE8791aE2b7121;

    uint256 public rateDao = 5;
    uint256 public stopDao;

    mapping (address => uint256) public userBurnAmount;

    constructor()  {
        _name = "Utility Net Coin";
        _symbol = "UNC";
        _decimals = 18;
        _creator = msg.sender;

        _totalSupply = 10000000000 * (10**_decimals);
        stopDao = _totalSupply.mul(5).div(100);

        _balances[owner()] = _totalSupply.mul(3).div(100);
        emit Transfer(address(0), owner(), _totalSupply.mul(3).div(100));
        _balances[address(this)] = _totalSupply.mul(97).div(100);
        emit Transfer(address(0), address(this), _totalSupply.mul(97).div(100));
    }
    receive() external payable {}

    function mint() public {
        require(msg.sender == walletMiner, "Only miner can mint");

        if(totalMined >= 9700000000*(10**18)){
            return ;
        }

        //each 200 days deduct 5%
        uint256 termtimes = (block.timestamp.sub(mineStartTime)).div(perDay * roundDays);
        if(termtimes > 0 && roundMap[termtimes] != true){
            dailyMint = dailyMint.mul(95).div(100);
            roundMap[termtimes] = true;
        }

        uint256 expectTotal =0;
        uint256 dayss = (block.timestamp.sub(mineLastTime)).div(perDay);
        expectTotal = dayss.mul(dailyMint);
        require(expectTotal > 0, "no coins to mint recently");
        _transfer(address(this), walletRecipient, expectTotal);

        totalMined += expectTotal;
        mineLastTime = block.timestamp;
    }

    function burn(uint256 amount) external {
        require(amount>0,"GRC20: what are you going to burn");

        uint256 amountdao = amount.mul(rateDao).div(100);
        uint256 amountburn = amount.sub(amountdao);
        if (_totalSupply < stopDao) {
            _burn(msg.sender, amount);
        } else {
            _transfer(msg.sender, walletDao, amountdao);
            _burn(msg.sender, amountburn);
        }
        userBurnAmount[msg.sender] += amount;
    }

    function burnAmount(address user) public view returns(uint256){
        return userBurnAmount[user];
    }
    function setWalletMiner(address wallet)public onlyOwner{
        walletMiner = wallet;
    }
    function setWalletRecipient(address wallet)public onlyOwner{
        walletRecipient = wallet;
    }
    function setWalletDao(address wallet)public onlyOwner{
        walletDao = wallet;
    }
    function setPerDay(uint256 number)public onlyOwner{
        perDay = number;
    }
    function setDailyMint(uint256 number)public onlyOwner{
        dailyMint = number;
    }
    function setRoundDays(uint256 number)public onlyOwner{
        roundDays = number;
    }
    function setRateDao(uint256 number)public onlyOwner{
        rateDao = number;
    }
    function getOwner() external view returns (address) {
        return owner();
    }
    function decimals() external view returns (uint8) {
        return _decimals;
    }
    function symbol() external view returns (string memory) {
        return _symbol;
    }
    function name() external view returns (string memory) {
        return _name;
    }
    function totalSupply() external override view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) external override view returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) external override view returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "GRC20: decreased allowance below zero"));
        return true;
    }
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "GRC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "GRC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "GRC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "GRC20: approve from the zero address");
        require(spender != address(0), "GRC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "GRC20: burn amount exceeds allowance"));
    }
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transferFrom( sender,  recipient,  amount);
        return true;
    }
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "GRC20: transfer amount exceeds allowance"));
        return true;
    }
    function _transfer(address sender, address recipient, uint256 amount) internal {
        _balances[sender] = _balances[sender].sub(amount, "GRC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
    }

}