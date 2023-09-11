//             / \__
//            (    @\___
//             /         O
//            /   (_____/
//   /\___/\  /_____/   U
//  / / /\ \ \        /
//  \ \/  \/ /       (
//   \_\_\/_/__ 0___/

// Twitter: https://twitter.com/sundogecoin
// Telegram: https://t.me/sun_doge

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;
pragma experimental ABIEncoderV2;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

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

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Auth {
    address public owner;
    mapping (address => bool) internal authorizations;

    constructor(address _owner) {
        owner = _owner;
        authorizations[_owner] = true;
    }

    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER"); _;
    }

    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    function authorize(address adr) public onlyOwner {
        authorizations[adr] = true;
    }

    function unauthorize(address adr) public onlyOwner {
        authorizations[adr] = false;
    }

    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    function transferOwnership(address payable adr) public onlyOwner {
        owner = adr;
        authorizations[adr] = true;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

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
    function swapETHForExactTokens(
        uint amountOut, 
        address[] calldata path, 
        address to, 
        uint deadline
    ) external payable returns (uint[] memory amounts);
    function swapExactETHForTokens(
        uint amountOutMin, 
        address[] calldata path, 
        address to, 
        uint deadline
    ) external payable returns (uint[] memory amounts);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapTokensForExactETH(
        uint amountOut, 
        uint amountInMax, 
        address[] calldata path, 
        address to, 
        uint deadline
    ) external returns (uint[] memory amounts);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
     function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
        ) external returns (uint amountA, uint amountB);
}

library EnumerableSet {
   
    struct Set {
        bytes32[] _values;
        mapping (bytes32 => uint256) _indexes;
    }

    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function _remove(Set storage set, bytes32 value) private returns (bool) {
        
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

    
            bytes32 lastvalue = set._values[lastIndex];

            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            set._values.pop();

            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    struct Bytes32Set {
        Set _inner;
    }

    
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }


    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

   
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    struct AddressSet {
        Set _inner;
    }

    
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }


    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

   
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

   
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    struct UintSet {
        Set _inner;
    }

    
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}


contract SunDoge is Context, IERC20, Auth {
    using SafeMath for uint256;
    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;

    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;

    mapping(address => bool) private _updated;
    mapping (address => uint256) public _shareTime;
   
    uint8 private _decimals = 18;
    uint256 private _tTotal;
    uint256 public supply = 1000000 * (10 ** 8) * (10 ** 18);

    string private _name = "SunDoge";
    string private _symbol = "SDoge";

    uint256 public _nftFee = 1;
    uint256 public _marketFee = 1;
    uint256 public _sunFee = 1;

    uint256 public totalFee = 3;

    address router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address usdt = 0x55d398326f99059fF775485246999027B3197955;
    address public marketAddress = 0x17532057d85A43383b4a28094CD2F5D01ED9e3fd;
    address public sunAddress = 0x09e9C7a121c8080d54A25B3F7deba71E40f46E77;

    address public initPoolAddress;

    IUniswapV2Router02 public uniswapV2Router;

    mapping(address => bool) public ammPairs;
    mapping(address => bool) public otherPairs;

    IERC20 public uniswapV2Pair;
    address public wbnb;

    mapping(address => bool) isBlackList;

    address constant rootAddress = address(0x000000000000000000000000000000000000dEaD);
    address bnbPair;

    uint256 currentIndex;
    uint256 distributorGas = 500000;

    mapping (uint256 => uint256) public tradingCount;
    uint256 tradingAmountLimit = 100 * (10 ** 8) * (10 ** 18);
    uint256 tradingCountLimit = 8;
    uint256 addTradingLimit = 200 * (10 ** 8) * (10 ** 18);

    uint256 launchedBlock;
    bool openTransaction;
    uint256 private firstTime;
    uint256 private secondTime;
    uint256 private thirdTime;

    mapping(address => bool) public nftHad;
    EnumerableSet.AddressSet nftProviders;
    uint256 public nftCondition = 1 * 10 ** 14;

    bool public swapEnabled = true;
    uint256 public swapThreshold = supply / 10000;
    bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }
    
    constructor () Auth(msg.sender) {
        initPoolAddress = owner;
        _tOwned[initPoolAddress] = supply;
        _tTotal = supply;
        
        _isExcludedFromFee[owner] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[rootAddress] = true;
        _isExcludedFromFee[initPoolAddress] = true;
        _isExcludedFromFee[marketAddress] = true;
        _isExcludedFromFee[sunAddress] = true;

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
        uniswapV2Router = _uniswapV2Router;

        bnbPair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        wbnb = _uniswapV2Router.WETH();

        uniswapV2Pair = IERC20(bnbPair);
        ammPairs[bnbPair] = true;

        emit Transfer(address(0), initPoolAddress, _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _take(uint256 tValue,address from,address to) private {
        _tOwned[to] = _tOwned[to].add(tValue);
        emit Transfer(from, to, tValue);
    }

    receive() external payable {}

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    struct Param{
        bool takeFee;
        uint tTransferAmount;
        uint tContract;
    }

    function _initParam(uint256 tAmount,Param memory param) private view  {
        uint tFee;
        
        if (block.number - launchedBlock > firstTime) {
            tFee = tAmount * totalFee / 100;
            param.tContract = tAmount * (_marketFee.add(_sunFee).add(_nftFee)) / 100;
        } else {
            tFee = tAmount * 90 / 100;
            param.tContract = tFee;
        }

        param.tTransferAmount = tAmount.sub(tFee);
    }

    function _takeFee(Param memory param,address from)private {
        if( param.tContract > 0 ){
            _take(param.tContract, from, address(this));
        }
    }

    function shouldSwapBack(address to) internal view returns (bool) {
        return (ammPairs[to] || otherPairs[to]) 
        && !inSwap
        && swapEnabled
        && balanceOf(address(this)) >= swapThreshold;
    }

    function swapBack() internal swapping {
        _allowances[address(this)][address(uniswapV2Router)] = swapThreshold;
        
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = wbnb;
        uint256 balanceBefore = address(this).balance;

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            swapThreshold,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountBNB = address(this).balance.sub(balanceBefore);
        uint256 amountToMarket = amountBNB.mul(_marketFee).div(totalFee);
        uint256 amountToSun = amountBNB.mul(_sunFee).div(totalFee);

        payable(marketAddress).transfer(amountToMarket);
        payable(sunAddress).transfer(amountToSun);  
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 0, "ERC20: transfer amount must be greater than zero");

        if (!_isExcludedFromFee[from] && ammPairs[to] && !inSwap) {
            uint256 fromBalance = balanceOf(from).mul(99).div(100);
            if (fromBalance < amount) {
                amount = fromBalance;
            }
        }

        bool takeFee;
        Param memory param;
        param.tTransferAmount = amount;

        if( ammPairs[to] && IERC20(to).totalSupply() == 0  ){
            require(from == initPoolAddress || from == address(this),"Not allow init");
        }

        if(inSwap || _isExcludedFromFee[from] || _isExcludedFromFee[to]){
            return _tokenTransfer(from,to,amount,param); 
        }

        require(openTransaction && !isBlackList[from],"Not allow");

        uint256 currentBlock = block.number;

        if (currentBlock - launchedBlock < firstTime && ammPairs[from]) {
            isBlackList[to] = true;
        }

        if (currentBlock - launchedBlock < secondTime) {
            if (ammPairs[from]) {
                require(isContract(to) == false, "Contract limit");
                // require(amount <= tradingAmountLimit, "Trading amount limit exceeded");
                tradingCount[currentBlock] = tradingCount[currentBlock] + 1;
                require(tradingCount[currentBlock] <= tradingCountLimit, "Trading frequency limit exceeded");
                require(IERC20(usdt).balanceOf(to) > 0 , "Insufficient USDT");
            }
        }

        if (currentBlock - launchedBlock < thirdTime) {
            if (ammPairs[from]) {
                require(amount <= tradingAmountLimit.add((currentBlock - launchedBlock).mul(addTradingLimit)), "Trading amount limit exceeded");
            }
        }    

        if(ammPairs[to] || ammPairs[from]){
            takeFee = true;
        }

        if(shouldSwapBack(to)){ swapBack(); }

        param.takeFee = takeFee;
        if( takeFee ){
            _initParam(amount,param);
        }
        
        _tokenTransfer(from,to,amount,param);

        if( address(uniswapV2Pair) != address(0) ){
            if (
                from != address(this) 
                && address(this).balance > 0) {

                process(distributorGas);
            }
        }
    }

    function _tokenTransfer(address sender, address recipient, uint256 tAmount,Param memory param) private {
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _tOwned[recipient] = _tOwned[recipient].add(param.tTransferAmount);
        emit Transfer(sender, recipient, param.tTransferAmount);
        if(param.takeFee){
            _takeFee(param,sender);
        }
    }
    
     function process(uint256 gas) private {
        uint256 shareholderCount = nftProviders.length();

        if (shareholderCount == 0) return;

        uint256 nowbanance = address(this).balance;
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();
        uint256 iterations = 0;
        
        uint256 _nftAmount;
        if (nftProviders.length()>0){ _nftAmount = nowbanance.div(nftProviders.length()); }
        
        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }

            if (address(this).balance < _nftAmount) return;

            if (_nftAmount >= nftCondition && isContract(nftProviders.at(currentIndex)) == false) {
                payable(nftProviders.at(currentIndex)).transfer(_nftAmount);
            }
            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }

    function setOpenTransaction() external authorized {
        require(openTransaction == false, "Already opened");
        openTransaction = true;
        launchedBlock = block.number;
    }

    function addLiquidity() external authorized payable {
        require(IERC20(bnbPair).totalSupply() == 0,"Liquidity is already add");
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Router.addLiquidityETH{value: msg.value}(address(this),balanceOf(address(this)),0,0,owner,block.timestamp);
        IERC20(bnbPair).approve(address(uniswapV2Router), type(uint).max);
    }

    function withDraw(address _to) external authorized {
        uint balance = address(this).balance;
        require(balance > 0, "Balance should be more then zero");
        payable(_to).transfer(balance);
    }
    
    function setExcludeFromFee(address account, bool _isExclude) public authorized {
        _isExcludedFromFee[account] = _isExclude;
    }

    function setAddress(address _marketAddress, address _sunAddress)external authorized{
        marketAddress = _marketAddress;
        sunAddress = _sunAddress;
    }

    function setTradingLimit(uint256 _tradingAmountLimit, uint256 _tradingCountLimit, uint256 _addTradingLimit)external authorized{
        tradingAmountLimit = _tradingAmountLimit;
        tradingCountLimit = _tradingCountLimit;
        addTradingLimit = _addTradingLimit;
    }

    function setTimes(uint256 _firstTime, uint256 _secondTime, uint256 _thirdTime)external authorized{
        firstTime = _firstTime;
        secondTime = _secondTime;
        thirdTime = _thirdTime;
    }

    function addToBlackList(address user) external authorized {
        isBlackList[user] = true;
    }

    function removeFromBlackList(address user) external authorized {
        isBlackList[user] = false;
    }

    function setAmmPair(address pair,bool hasPair)external authorized{
        ammPairs[pair] = hasPair;
    }

    function setOtherPair(address pair,bool hasPair)external authorized{
        otherPairs[pair] = hasPair;
    }

    function setSwapBackSettings(bool _enabled, uint256 _amount)external authorized{
        swapEnabled = _enabled;
        swapThreshold = _amount;
    }

    function setNftCondition(uint256 _nftCondition)external authorized{
        nftCondition = _nftCondition;
    }

    function setFees(uint256 marketFee, uint256 lpFee,uint256 sunFee) external authorized {
        _marketFee = marketFee;
        _nftFee = lpFee;
        _sunFee = sunFee;
        totalFee = _marketFee.add(_nftFee).add(_sunFee);
    }

    function addShareholder(address shareholder) public authorized {
        require(nftHad[shareholder] == false, "Already in holders");
        nftProviders.add(shareholder);
        nftHad[shareholder] = true;
    }

    function removeShareholder(address shareholder) public authorized {
        require(nftHad[shareholder] == true, "Not in holders");
        nftProviders.remove(shareholder);
        nftHad[shareholder] = false;
    }

    function transferNft(address shareholder, address newShareholder, bool isHas) public authorized {
        if(isHas == false){
            if (nftHad[shareholder] == true){
                removeShareholder(shareholder);
            }  
        }
        if (nftHad[newShareholder] == false){
            addShareholder(newShareholder); 
        }
    }

}