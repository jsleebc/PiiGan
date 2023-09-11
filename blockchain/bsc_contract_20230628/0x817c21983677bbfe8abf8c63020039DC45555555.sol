// SPDX-License-Identifier: MIT


pragma solidity 0.8.17;

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
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IUniswapV2Pair {
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function sync() external;
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


abstract contract BaseToken is IERC20, Ownable {
    uint8 private _decimals;  

    uint256 private _totalSupply;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _addPriceTokenAmount;   

    ISwapRouter private _swapRouter;
    address private _marketAddress;
    address private _usdtAddress;
    address private _usdtPairAddress;
    uint256 public waitForBackAmount;

    string private _name;
    string private _symbol;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _swapPairMap;
    

    constructor (string memory Name, string memory Symbol, uint256 Supply, address RouterAddress, address UsdtAddress, address marketAddress){
        _name = Name;
        _symbol = Symbol;
        _decimals = 18;
        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        _usdtAddress = UsdtAddress;
        _swapRouter = swapRouter;
        _allowances[address(this)][RouterAddress] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        _usdtPairAddress = swapFactory.createPair(UsdtAddress,address(this));
        _swapPairMap[_usdtPairAddress] = true;

        uint256 total = Supply * 1e18;
        _totalSupply = total;
        
        _marketAddress = marketAddress;
        
        _addPriceTokenAmount = 1e14;

        _balances[msg.sender] = total; 
        emit Transfer(address(0), msg.sender, total);
    }

    function getParam() external view  returns(address pairAddress, address routerAddress, address usdtAddress, address marketAddress, uint addPriceTokenAmount){
        pairAddress = _usdtPairAddress;
        routerAddress = address(_swapRouter);
        usdtAddress = _usdtAddress;
        marketAddress = _marketAddress;
        addPriceTokenAmount = _addPriceTokenAmount;
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

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
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

    function _isLiquidity(address from,address to) internal view returns(bool isAdd, bool isDel){        
        (uint r0,uint r1,) = IUniswapV2Pair(_usdtPairAddress).getReserves();
        uint rUsdt = r0;  
        uint bUsdt = IERC20(_usdtAddress).balanceOf(_usdtPairAddress);      
        if(address(this)<_usdtAddress){   
            rUsdt = r1; 
        }
        if( _swapPairMap[to] ){ 
            if( bUsdt >= rUsdt ){
                isAdd = bUsdt - rUsdt >= _addPriceTokenAmount; 
            }
        }
        if( _swapPairMap[from] ){   
            isDel = bUsdt <= rUsdt;  
        }
    }
    
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {       
        require(amount > 0, "transfer amount must be >0");
        bool isAddLiquidity;
        bool isDelLiquidity;
        ( isAddLiquidity, isDelLiquidity) = _isLiquidity(from, to);
        
        if (isAddLiquidity || isDelLiquidity){            
            _tokenTransfer(from, to, amount);
        }else if(_swapPairMap[from] || _swapPairMap[to]){
            _tokenTransfer(from, _marketAddress, amount/100); 
            _tokenTransfer(from, address(this), amount/50);   
            _tokenTransfer(from, to, amount*97/100);    
            waitForBackAmount+=amount/50;           
        }else{
             _tokenTransfer(from, to, amount);
             if(waitForBackAmount>=1e19){
                 _tokenTransfer(address(this), _usdtPairAddress, waitForBackAmount); 
                 waitForBackAmount=0;
                 IUniswapV2Pair(_usdtPairAddress).sync();
             }
        }
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

    function setMarketAddress(address addr) external onlyOwner {
        _marketAddress = addr;
    }
    
    function setSwapPairMap(address addr, bool enable) external onlyOwner {
        _swapPairMap[addr] = enable;
    }

    function setAddPriceTokenAmount(uint amount) external onlyOwner{
        _addPriceTokenAmount = amount;
    }
}

contract TURT is BaseToken {
    constructor() BaseToken(
        "Turtle",
        "TURT",
        1000000000000000,
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E), 
        address(0x55d398326f99059fF775485246999027B3197955), 
        address(0x813FE516FeA0B83133EE2722cE2ED041e6693210) 
    ){

    }
}