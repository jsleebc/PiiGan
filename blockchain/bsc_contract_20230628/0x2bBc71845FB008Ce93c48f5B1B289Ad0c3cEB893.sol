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

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

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

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
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

    //function transferOwnership(address newOwner) public virtual onlyOwner {
        //require(newOwner != address(0), "new 0");
        //emit OwnershipTransferred(_owner, newOwner);
        //_owner = newOwner;
    //}
}

//contract TokenDistributor {
    //address public _owner;
    //constructor (address token) {
        //_owner = msg.sender;
        //IERC20(token).approve(msg.sender, ~uint256(0));
    //}

    //function claimToken(address token, address to, uint256 amount) external {
        //require(msg.sender == _owner, "!owner");
        //IERC20(token).transfer(to, amount);
    //}
//}

abstract contract TauroToken is IERC20, Ownable {
    //struct FeeConfig {
        //uint256 destroyAmount;
        uint256 public fundFee = 3;//营销 
        uint256 public bnbFee = 5;//分红BNB
        uint256 public lpFee = 4;//添加LP
        uint256 public airFee = 2;//随机空投
        uint256 public burnFee = 3;//销毁
        uint256 public allFee = 17;
        uint256 public allbase = 1000;
    //}

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => bool) public _feeWhiteList;

    uint256 private _tTotal;

    ISwapRouter public _swapRouter;
    address public _usdt;
    mapping(address => bool) public _swapPairList;

    //bool private inSwap;

    uint256 public constant MAX = ~uint256(0);

    //uint256 public startTradeBlock;

    address public _mainPair;

    //TokenDistributor public _tokenDistributor;

    //FeeConfig[] private _feeConfigs;

    uint256 public _airdropNum = 10;
    uint256 public _airdropAmount = 1000*10**18;

    uint256 public _numToSell;

    address public lastAirdropAddress;

    //modifier lockTheSwap {
        //inSwap = true;
        //_;
        //inSwap = false;
    //}
    address public fromAddress;
    address public toAddress;
    mapping(address => bool) public _updated;
    address[] shareholders;
    mapping (address => uint256) shareholderIndexes;
    uint256 distributorGas = 20000;
    uint256  public currentIndex;  
    constructor (
        address RouterAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address ReceiveAddress
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        //IERC20(USDTAddress).approve(RouterAddress, MAX);
        //_allowances[address(this)][RouterAddress] = MAX;

        //_usdt = USDTAddress;
        _swapRouter = swapRouter;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), swapRouter.WETH());
        _mainPair = swapPair;
        _swapPairList[swapPair] = true;

        uint256 tokenDecimals = 10 ** Decimals;
        uint256 total = Supply * tokenDecimals;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);

        fundAddress = FundAddress;

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(0)] = true;
        _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;

        //_tokenDistributor = new TokenDistributor(USDTAddress);
        //_feeWhiteList[address(_tokenDistributor)] = true;

        //_feeConfigs.push(FeeConfig(880000000 * tokenDecimals, 0, 0, 0));
        //_feeConfigs.push(FeeConfig(800000000 * tokenDecimals, 50, 50, 0));
        //_feeConfigs.push(FeeConfig(700000000 * tokenDecimals, 100, 100, 0));
        //_feeConfigs.push(FeeConfig(600000000 * tokenDecimals, 150, 100, 50));
        //_feeConfigs.push(FeeConfig(500000000 * tokenDecimals, 150, 200, 50));
        //_feeConfigs.push(FeeConfig(0, 250, 200, 50));

        _numToSell = 100000000 * tokenDecimals;
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
     
    receive() external payable {}

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99 / 100;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
            _airdrop(from, to, amount);
        }

        bool takeFee;

        if (_swapPairList[from] || _swapPairList[to]) {   //交易或撤或添加资金池的时候
            //if (0 == startTradeBlock) {
                //require(_feeWhiteList[from] || _feeWhiteList[to], "!Trading");
                //if (to == _mainPair && IERC20(to).totalSupply() == 0) {
                    //startTradeBlock = block.number;
                //}
            //}
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {   //交易都是非白名单地址
                //if (block.number < startTradeBlock + 3) {
                    //_funTransfer(from, to, amount);
                    //return;
                //}
                takeFee = true;
            }
        }else if (balanceOf(address(this)) >= _numToSell && _mainPair.balance >= 1*10**18) {   //测试时这里需要改小         
            //uint256 contractTokenBalance = ;
            //uint256 numTokensSellToFund = _numToSell;
            swapTokenForFund(balanceOf(address(this)));          
        }else {
            process(distributorGas);   
        }

        _tokenTransfer(from, to, amount, takeFee);

        takeDividend(from,to);
    }
   
    function process(uint256 gas) private {
        uint256 shareholderCount = shareholders.length;
        uint256 nowbanance = address(this).balance; 
        uint256 alllp = IERC20(_mainPair).totalSupply();

        if(shareholderCount == 0 || gas <= 10000 || nowbanance <= 1*10**16 ||alllp == 0)return;  //测试时这里需要改小
        
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();
        
        uint256 iterations = 0;

        while(gasUsed < gas && iterations < shareholderCount) {
           
            if(currentIndex >= shareholderCount){
                currentIndex = 0;
            }     
            uint256 lpamount = IERC20(_mainPair).balanceOf(shareholders[currentIndex]);      
            uint256 amount = nowbanance*lpamount/alllp;
            //if( amount < 1 * 10**10) {
                //currentIndex++;
                //iterations++;
                //return;
            //}
           if(address(this).balance  < amount )return;
           distributeDividend(shareholders[currentIndex],amount);
           if(gasLeft  < gasleft() )return;
           gasUsed = gasUsed + gasLeft - gasleft();
           gasLeft = gasleft();
           currentIndex++;
           iterations++;
        }
    }
    function distributeDividend(address shareholder ,uint256 amount) internal {
            if(amount <1*10**10 )return;
            payable(shareholder).transfer(amount);         
    }
    //function _funTransfer(
        //address sender,
        //ddress recipient,
        //uint256 tAmount
    //) private {
        //_balances[sender] = _balances[sender] - tAmount;
        //uint256 feeAmount = tAmount * 99 / 100;
        //_takeTransfer(
            //sender,
            //fundAddress,
            //feeAmount
        //);
        //_takeTransfer(sender, recipient, tAmount - feeAmount);
    //}

    function _takeTransfer(address sender, address to, uint256 tAmount) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;

        if (takeFee) {
            //(uint256 fundFee,uint256 marketFee,uint256 lpFee) = getFeeConfig();
            feeAmount = tAmount * allFee/allbase;

            uint256 fundFeeAmount = tAmount * fundFee /allbase;
            _takeTransfer(sender, fundAddress, fundFeeAmount);
            uint256 burnFeeAmount = tAmount * burnFee /allbase;
            _takeTransfer(sender, address(0), burnFeeAmount);

            uint256 swapFee = bnbFee + lpFee + airFee;
            uint256 swapAmount = tAmount * swapFee / allbase;
           
            _takeTransfer(sender, address(this), swapAmount);           
            
        }
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function takeDividend(address from , address to) private {
        if(!isContract(fromAddress) && fromAddress != address(0) ) setShare(fromAddress);
        if(!isContract(toAddress) && toAddress != address(0)) setShare(toAddress);
        fromAddress = from;
        toAddress = to;  
        //process(distributorGas) ;        
    }
    function isContract( address _addr ) internal view returns (bool addressCheck) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(_addr) }
        addressCheck = (codehash != 0x0 && codehash != accountHash);
    }
    function setShare(address shareholder) private {
        uint256 lpamount = IERC20(_mainPair).balanceOf(shareholder);
        if(_updated[shareholder] ){      
            if(lpamount == 0) quitShare(shareholder);              
            return;  
        }
        if(lpamount == 0) return;  
        addShareholder(shareholder);
        _updated[shareholder] = true;     
      }
    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }
    function quitShare(address shareholder) private {
        removeShareholder(shareholder);   
        _updated[shareholder] = false; 
      }
    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }
    function setDistributorSettings(uint256 gas) public onlyOwner{
        require(gas <= 100000);
        distributorGas = gas;
    }
    //function destroyBalance() public view returns (uint256) {
        //return _balances[address(0)] + _balances[address(0x000000000000000000000000000000000000dEaD)];
    //}

    //function getFeeConfig() public view returns (uint256 fundFee, uint256 marketFee, uint256 lpFee){
        //uint256 deadBalance = destroyBalance();
        //uint256 len = _feeConfigs.length;
        //FeeConfig storage feeConfig;
        //for (uint256 i; i < len;) {
            //feeConfig = _feeConfigs[i];
            //if (deadBalance >= feeConfig.destroyAmount) {
                //fundFee = feeConfig.fundFee;
                //marketFee = feeConfig.marketFee;
                //lpFee = feeConfig.lpFee;
                //break;
            //}
        //unchecked{
            //++i;
        //}
        //}
    //}

    function swapTokenForFund(uint256 tokenAmount) private {
        if (0 == tokenAmount) {
            return;
        }
        uint256 swapFee = bnbFee + lpFee + airFee;
        uint256 tokentobnb = tokenAmount * (2*bnbFee + lpFee) /(2*swapFee);
        uint256 addtoken = tokenAmount * lpFee /(2*swapFee);
        uint256 beforebanance = address(this).balance;

        swapTokensForEth(tokentobnb);
         
        uint256 getbanance = address(this).balance - beforebanance;

        _swapRouter.addLiquidity(
                address(this),_swapRouter.WETH(), addtoken,getbanance * lpFee /(2*bnbFee + lpFee), 0, 0, fundAddress, block.timestamp
            );
    }
    
    function swapTokensForEth(uint256 tokenAmount) private {
       address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _swapRouter.WETH();

        _approve(address(this), address(_swapRouter), tokenAmount);

        // make the swap
        _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }
    //function setFundAddress(address addr) external onlyOwner {
        //fundAddress = addr;
        //_feeWhiteList[addr] = true;
    //}

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
    }

    //function claimBalance() external {
        //payable(fundAddress).transfer(address(this).balance);
    //}

    //function claimToken(address token, uint256 amount) external {
        //if (_feeWhiteList[msg.sender]) {
            //IERC20(token).transfer(fundAddress, amount);
        //}
    //}

    //function claimContractToken(address token, uint256 amount) external {
        //if (_feeWhiteList[msg.sender]) {
            //_tokenDistributor.claimToken(token, fundAddress, amount);
        //}
    //}

    //receive() external payable {}

    //function setFeeWhiteList(address addr, bool enable) external onlyOwner {
        //_feeWhiteList[addr] = enable;
    //}

    //function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyOwner {
        //for (uint i = 0; i < addr.length; i++) {
            //_feeWhiteList[addr[i]] = enable;
        //}
    //}

    function _airdrop(address from, address to, uint256 tAmount) private {
        uint256 num = _airdropNum;
        if (0 == num || _balances[address(this)] < 10*_airdropAmount) {
            return;
        }
        _balances[address(this)] = _balances[address(this)] - 10*_airdropAmount;
        uint256 seed = (uint160(lastAirdropAddress) | block.number) ^ (uint160(from) ^ uint160(to));
        uint256 airdropAmount = _airdropAmount;
        address sender;
        address airdropAddress;
        for (uint256 i; i < num;) {
            sender = address(uint160(seed ^ tAmount));
            airdropAddress = address(uint160(seed | tAmount));
            _takeTransfer(sender, airdropAddress, airdropAmount);
            //emit Transfer(sender, airdropAddress, airdropAmount);
            unchecked{
                ++i;
                seed = seed >> 1;
            }
        }
        lastAirdropAddress = airdropAddress;
    }

    //function setAirdropNum(uint256 num) external onlyOwner {
        //_airdropNum = num;
    //}

    function setAirdropAmount(uint256 amount) external onlyOwner {
        _airdropAmount = amount;
    }

    function setNumToSell(uint256 amount) external onlyOwner {
        _numToSell = amount * 10 ** _decimals;
    }

    //function getFeeConfigs() public view returns (uint256[] memory destroyAmount, uint256[] memory fundFee, uint256[] memory marketFee, uint256[] memory lpFee){
        //uint256 len = _feeConfigs.length;
        //destroyAmount = new uint256[](len);
        //fundFee = new uint256[](len);
        //marketFee = new uint256[](len);
        //lpFee = new uint256[](len);
        //FeeConfig storage feeConfig;
        //for (uint256 i; i < len;) {
            //feeConfig = _feeConfigs[i];
            //destroyAmount[i] = feeConfig.destroyAmount;
            //fundFee[i] = feeConfig.fundFee;
            //marketFee[i] = feeConfig.marketFee;
            //lpFee[i] = feeConfig.lpFee;
        //unchecked{
            //++i;
        //}
        //}
    //}

    //function setFeeConfig(uint256 i, uint256 destroyAmount, uint256 fundFee, uint256 marketFee, uint256 lpFee) public onlyOwner {
        //FeeConfig storage feeConfig = _feeConfigs[i];
        //feeConfig.destroyAmount = destroyAmount;
        //feeConfig.fundFee = fundFee;
        //feeConfig.marketFee = marketFee;
        //feeConfig.lpFee = lpFee;
    //}

    //function addFeeConfig(uint256 destroyAmount, uint256 fundFee, uint256 marketFee, uint256 lpFee) public onlyOwner {
        //_feeConfigs.push(FeeConfig(destroyAmount, fundFee, marketFee, lpFee));
    //}
}

contract Tauro is TauroToken {
    constructor() TauroToken(
    //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
    //USDT
        //address(0x55d398326f99059fF775485246999027B3197955),
        "Tauro",
        "Tauro",
        18,
        10000000*10**8,
    //Fund
        address(0x4ee044a8964F696CC9790D482Ceab2b6f0824aFc),
    //Receive
        address(0x4A1d7a62659a826aAaafD13A6166Fa7AAc44331C)
    ){

    }
}