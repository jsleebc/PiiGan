// SPDX-License-Identifier: MIT

/*
    Just a cheeseburger on the floor
    Taxes will drop gradually to 0%
    fourTwenty()
    blazeit()
*/

pragma solidity ^0.8.19;

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function decimals() external view returns (uint8);
  function symbol() external view returns (string memory);
  function name() external view returns (string memory);
  function getOwner() external view returns (address);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address _owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface ISwapERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
}


interface ISwapFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


interface ISwapRouter01 {
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
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


interface ISwapRouter02 is ISwapRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);
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


abstract contract Ownable {
    address private _owner;

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
        require(owner() == msg.sender, "Caller must be owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "newOwner must not be zero");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


library Address {   
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
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
        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;
            bytes32 lastvalue = set._values[lastIndex];
            set._values[toDeleteIndex] = lastvalue;
            set._indexes[lastvalue] = valueIndex;
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


contract FloorCheeseburger is IERC20, Ownable {
    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;

    mapping(address => uint256) private _balances;
    mapping(address => mapping (address => uint256)) private _allowances;

    EnumerableSet.AddressSet private _excluded;  
    
    string private constant TOKEN_NAME = "Floor Cheeseburger";
    string private constant TOKEN_SYMBOL = "$FLRBRG";
    uint256 private constant TOTAL_SUPPLY = 420_000_000 * 10**TOKEN_DECIMALS;       
    uint8 private constant TOKEN_DECIMALS = 18;
    address private constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
    
    struct Taxes {
       uint8 buyTax;
       uint8 sellTax;
       uint8 transferTax;
    }

    struct TaxRatios {           
        uint8 liquidity;
        uint8 marketing;
    }

    struct TaxWallets {
        address marketing;
    }

    struct MaxLimits {
        uint256 maxWallet;
        uint256 maxSell;
        uint256 maxBuy;
    }

    struct LimitRatios {
        uint16 wallet;
        uint16 sell;
        uint16 buy;
        uint16 divisor;
    }

    Taxes public _taxRates = Taxes({
        buyTax: 10,
        sellTax: 25,
        transferTax: 0
    });

    TaxRatios public _taxRatios = TaxRatios({
        liquidity: 0,
        marketing: 1
        //@dev. These are ratios and the divisor will  be set automatically
    });

    TaxWallets public _taxWallet = TaxWallets ({
        marketing: 0x986BA6D8Bf1ba7d86cAbAB41e969E7e77ee55695
    });

    MaxLimits public _limits;

    LimitRatios public _limitRatios = LimitRatios({
        wallet: 2,
        sell: 2,
        buy: 2,
        divisor: 100
    });

    uint8 private totalTaxRatio;
    uint8 private distributeRatio;

    uint256 private _liquidityUnlockTime;

    uint16 public swapThreshold = 1; //threshold that contract will swap. out of 1000
    bool public manualSwap;

    address public _pairAddress; 
    ISwapRouter02 private  _swapRouter;
    address public routerAddress;

/////////////////////////////   EVENTS  /////////////////////////////////////////
    event EnableManualSwap(bool enabled);
    event ExcludedAccountFromFees(address account, bool exclude);   
    event ExtendLiquidityLock(uint256 extendedLockTime);
    event UpdateTaxes(uint8 buyTax, uint8 sellTax, uint8 transferTax);    
    event RatiosChanged(uint8 newLiquidity, uint8 newMarketing);       
    event UpdateMarketingWallet(address newMarketingWallet);      
    event UpdateSwapThreshold(uint16 newThreshold);

/////////////////////////////   MODIFIERS  /////////////////////////////////////////

    modifier authorized() {
        require(_authorized(msg.sender), "Caller not authorized");
        _;
    }

    modifier lockTheSwap {
        _isSwappingContractModifier = true;
        _;
        _isSwappingContractModifier = false;
    }

/////////////////////////////   CONSTRUCTOR  /////////////////////////////////////////

    constructor () {
        if (block.chainid == 1) 
            routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        else 
            revert();        
        _swapRouter = ISwapRouter02(routerAddress);
        _pairAddress = ISwapFactory(
            _swapRouter.factory()).createPair(address(this), _swapRouter.WETH()
        );

        _addToken(msg.sender,TOTAL_SUPPLY);
        emit Transfer(address(0), msg.sender, TOTAL_SUPPLY);

        _allowances[address(this)][address(_swapRouter)] = type(uint256).max;         
        
        //setup ratio divisors based on dev's chosen ratios
        totalTaxRatio =  _taxRatios.liquidity + _taxRatios.marketing;

        distributeRatio = totalTaxRatio - _taxRatios.liquidity;
        
        //setup _limits
        _limits = MaxLimits({
            maxWallet: TOTAL_SUPPLY * _limitRatios.wallet / _limitRatios.divisor,
            maxSell: TOTAL_SUPPLY * _limitRatios.sell / _limitRatios.divisor,
            maxBuy: TOTAL_SUPPLY * _limitRatios.buy / _limitRatios.divisor
        });
        
        _excluded.add(msg.sender);
        _excluded.add(_taxWallet.marketing);
        _excluded.add(address(this));
        _excluded.add(BURN_ADDRESS);

        _approve(address(this), address(_swapRouter), type(uint256).max);        
    }

    receive() external payable {}

    function decimals() external pure override returns (uint8) { return TOKEN_DECIMALS; }
    function getOwner() external view override returns (address) { return owner(); }
    function name() external pure override returns (string memory) { return TOKEN_NAME; }
    function symbol() external pure override returns (string memory) { return TOKEN_SYMBOL; }
    function totalSupply() external pure override returns (uint256) { return TOTAL_SUPPLY; }

    function _authorized(address addr) private view returns (bool) {
        return addr == owner() || addr == _taxWallet.marketing; 
    }

    function allowance(address _owner, address spender) external view override returns (uint256) {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "Approve from zero");
        require(spender != address(0), "Approve to zero");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "<0 allowance");

        _approve(msg.sender, spender, currentAllowance - subtractedValue);
        return true;
    } 

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }  
      
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "Transfer > allowance");

        _approve(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    //Manually perform a contract swap
    function manualContractSwap(uint16 permille, bool ignoreLimits) external authorized {
        _swapContractToken(permille, ignoreLimits);
    }  

    //Mainly used for addresses such as CEX, presale, etc
    function excludeAccountFromFees(address account, bool exclude) external authorized {
        if(exclude == true)
            _excluded.add(account);
        else
            _excluded.remove(account);
        emit ExcludedAccountFromFees(account, exclude);
    }

    //Toggle manual swap on and off
    function enableManualSwap(bool enabled) external authorized { 
        manualSwap = enabled; 
        emit EnableManualSwap(enabled);
    } 

    function removeLimits() external authorized {
        _limits = MaxLimits(TOTAL_SUPPLY, TOTAL_SUPPLY, TOTAL_SUPPLY);
        _limitRatios = LimitRatios(100, 100, 100, 100);
    }

    function blazeIt() external authorized {
        _taxRates = Taxes(0, 0, 0);
        emit UpdateTaxes(0, 0, 0);
    }

    function fourTwenty() external authorized {
        _taxRates = Taxes(4, 20, 0);
        emit UpdateTaxes(4, 20, 0);
    }

    //Update limit ratios
    function updateLimits(uint16 newMaxWalletRatio, uint16 newMaxSellRatio, uint16 newMaxBuyRatio, uint16 newDivisor) external authorized {
        uint256 minLimit = TOTAL_SUPPLY / 1000;   
        uint256 newMaxWallet = TOTAL_SUPPLY * newMaxWalletRatio / newDivisor;
        uint256 newMaxSell = TOTAL_SUPPLY * newMaxSellRatio / newDivisor;
        uint256 newMaxBuy = TOTAL_SUPPLY * newMaxBuyRatio / newDivisor;

        //dev can never set sells below 0.1% of circulating/initial supply
        require((newMaxWallet >= minLimit && newMaxSell >= minLimit), 
            "limits cannot be <0.1% of supply");

        _limits = MaxLimits(newMaxWallet, newMaxSell, newMaxBuy);
        
        _limitRatios = LimitRatios(newMaxWalletRatio, newMaxSellRatio, newMaxBuyRatio, newDivisor);
    }

    //update tax ratios
    function updateRatios(uint8 newLiquidity, uint8 newMarketing) external authorized {
        _taxRatios = TaxRatios(newLiquidity, newMarketing);

        totalTaxRatio = newLiquidity + newMarketing;
        distributeRatio = totalTaxRatio - newLiquidity;

        emit RatiosChanged (newLiquidity,newMarketing);
    }

    //update threshold that triggers contract swaps
    function updateSwapThreshold(uint16 threshold) external authorized {
        require(threshold > 0,"Threshold needs to be more than 0");
        require(threshold <= 50,"Threshold needs to be below 50");
        swapThreshold = threshold;
        emit UpdateSwapThreshold(threshold);
    }

    function updateTax(uint8 newBuy, uint8 newSell, uint8 newTransfer) external authorized {
        _taxRates = Taxes(newBuy, newSell, newTransfer);
        emit UpdateTaxes(newBuy, newSell, newTransfer);
    }

    //liquidity can only be extended. To lock liquidity, send LP tokens to contract.
    function lockLiquidityTokens(uint256 lockTimeInSeconds) external authorized {
        setUnlockTime(lockTimeInSeconds + block.timestamp);
        emit ExtendLiquidityLock(lockTimeInSeconds);
    }

    //recovers stuck ETH to make sure it isnt burnt/lost
    //only callable when liquidity is unlocked
    function recoverETH() external authorized {
        require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
        _liquidityUnlockTime=block.timestamp;
        _sendEth(msg.sender, address(this).balance);
    }

    //Can only be used to recover miscellaneous tokens accidentally sent to contract
    //Can't pull liquidity or native token using this function
    function recoverMiscToken(address tokenAddress) external authorized {
        require(tokenAddress != _pairAddress && tokenAddress != address(this),
        "can't recover LP token or this token");
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender,token.balanceOf(address(this)));
    } 

    //Impossible to release LP unless LP lock time is zero
    function releaseLP() external authorized {
        require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
        ISwapERC20 liquidityToken = ISwapERC20(_pairAddress);
        uint256 amount = liquidityToken.balanceOf(address(this));
            liquidityToken.transfer(msg.sender, amount);
    }

    //Impossible to remove LP unless lock time is zero
    function removeLP() external authorized {
        require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
        _liquidityUnlockTime = block.timestamp;
        ISwapERC20 liquidityToken = ISwapERC20(_pairAddress);
        uint256 amount = liquidityToken.balanceOf(address(this));
        liquidityToken.approve(address(_swapRouter),amount);
        _swapRouter.removeLiquidityETHSupportingFeeOnTransferTokens(
            address(this),
            amount,
            0,
            0,
            address(this),
            block.timestamp
            );
        _sendEth(msg.sender, address(this).balance);           
    }


    function setMarketingWallet(address payable addr) external authorized {
        address prevMarketing = _taxWallet.marketing;
        _excluded.remove(prevMarketing);
        _taxWallet.marketing = addr;
        _excluded.add(_taxWallet.marketing);
        emit UpdateMarketingWallet(addr);
    }

////// VIEW FUNCTIONS /////

    function getLiquidityUnlockInSeconds() external view returns (uint256) {
        if (block.timestamp < _liquidityUnlockTime){
            return _liquidityUnlockTime - block.timestamp;
        }
        return 0;
    }

/////////////////////////////   PRIVATE FUNCTIONS  /////////////////////////////////////////
 
    bool private _isSwappingContractModifier;
    bool private _isWithdrawing;

    function _addLiquidity(uint256 tokenamount, uint256 ethAmount) private {
        _approve(address(this), address(_swapRouter), tokenamount);        
        _swapRouter.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenamount,
            0,
            0,
            address(this),
            block.timestamp
        );
    }
 
    function _addToken(address addr, uint256 amount) private {
        uint256 newAmount = _balances[addr] + amount;
        _balances[addr] = newAmount;
    }

    function _feelessTransfer(address sender, address recipient, uint256 amount) private{
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer exceeds balance");
        _removeToken(sender,amount);
        _addToken(recipient, amount);
        emit Transfer(sender, recipient, amount);
    } 
    
    function _removeToken(address addr, uint256 amount) private {
        uint256 newAmount = _balances[addr] - amount;
        _balances[addr] = newAmount;
    }

    function _sendEth(address account, uint256 amount) private {
        (bool sent,) = account.call{value: (amount)}("");
        require(sent, "withdraw failed");        
    }

    function _swapContractToken(uint16 permille, bool ignoreLimits) private lockTheSwap {
        require(permille <= 500);
        if (totalTaxRatio == 0) return;
        uint256 contractBalance = _balances[address(this)];


        uint256 tokenToSwap = _balances[_pairAddress] * permille / 1000;
        if (tokenToSwap > _limits.maxSell && !ignoreLimits) 
            tokenToSwap = _limits.maxSell;
        
        bool notEnoughToken = contractBalance < tokenToSwap;
        if (notEnoughToken) {
            if (ignoreLimits)
                tokenToSwap = contractBalance;
            else 
                return;
        }
        if (_allowances[address(this)][address(_swapRouter)] < tokenToSwap)
            _approve(address(this), address(_swapRouter), type(uint256).max);

        uint256 tokenForLiquidity = (tokenToSwap*_taxRatios.liquidity) / totalTaxRatio;
        uint256 remainingToken = tokenToSwap - tokenForLiquidity;
        uint256 liqToken = tokenForLiquidity / 2;
        uint256 liqEthToken = tokenForLiquidity - liqToken;
        uint256 swapToken = liqEthToken + remainingToken;
        uint256 initialEthBalance = address(this).balance;
        _swapTokenForETH(swapToken);
        uint256 newEth = (address(this).balance - initialEthBalance);
        uint256 liqEth = (newEth*liqEthToken) / swapToken;
        if (liqToken > 0) 
            _addLiquidity(liqToken, liqEth); 
        _sendEth(_taxWallet.marketing, address(this).balance);
    }

    function _swapTokenForETH(uint256 amount) private {
        _approve(address(this), address(_swapRouter), amount);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _swapRouter.WETH();
        _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    } 

    function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
        uint256 recipientBalance = _balances[recipient];
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer exceeds balance");

        uint8 tax;
        if (isSell) {

            require(amount <= _limits.maxSell, "Amount exceeds max sell");
            tax = _taxRates.sellTax;

        } else if (isBuy) { 

            require(recipientBalance+amount <= _limits.maxWallet, "Amount will exceed max wallet");
            require(amount <= _limits.maxBuy, "Amount exceed max buy");
            tax = _taxRates.buyTax;

        } else {
            require(recipientBalance + amount <= _limits.maxWallet, "whale protection");            
            tax = _taxRates.transferTax;
        }    

        if ((sender != _pairAddress) && (!manualSwap) && (!_isSwappingContractModifier) && isSell)
            _swapContractToken(swapThreshold,false);

        uint256 taxedAmount;

        if(tax > 0) {
        taxedAmount = amount * tax / 100;          
        }

        uint256 receiveAmount = amount - taxedAmount;
        _removeToken(sender,amount);
        _addToken(address(this), taxedAmount);
        _addToken(recipient, receiveAmount);
        emit Transfer(sender, recipient, receiveAmount);
    }
    
    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "Transfer from zero");
        require(recipient != address(0), "Transfer to zero");

        bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient));

        bool isContractTransfer = (sender == address(this) || recipient == address(this));
        address _routerAddress = address(_swapRouter);
        bool isLiquidityTransfer = (
            (sender == _pairAddress && recipient == _routerAddress) 
            || (recipient == _pairAddress && sender == _routerAddress)
        );

        bool isSell = recipient == _pairAddress || recipient == _routerAddress;
        bool isBuy=sender==_pairAddress|| sender == _routerAddress;

        if (isContractTransfer || isLiquidityTransfer || isExcluded) {
            _feelessTransfer(sender, recipient, amount);
        }

        else { 
            _taxedTransfer(sender, recipient, amount, isBuy, isSell);                  
        }
    }

     function setUnlockTime(uint256 newUnlockTime) private {
        // require new unlock time to be longer than old one
        require(newUnlockTime > _liquidityUnlockTime);
        _liquidityUnlockTime = newUnlockTime;
    }
}