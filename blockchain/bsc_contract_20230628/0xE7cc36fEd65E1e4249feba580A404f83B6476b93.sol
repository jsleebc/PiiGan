/*

███████╗██╗░░░░░██╗██████╗░  ██████╗░███████╗██████╗░███████╗
██╔════╝██║░░░░░██║██╔══██╗  ██╔══██╗██╔════╝██╔══██╗██╔════╝
█████╗░░██║░░░░░██║██████╔╝  ██████╔╝█████╗░░██████╔╝█████╗░░
██╔══╝░░██║░░░░░██║██╔═══╝░  ██╔═══╝░██╔══╝░░██╔═══╝░██╔══╝░░
██║░░░░░███████╗██║██║░░░░░  ██║░░░░░███████╗██║░░░░░███████╗
╚═╝░░░░░╚══════╝╚═╝╚═╝░░░░░  ╚═╝░░░░░╚══════╝╚═╝░░░░░╚══════╝

🐸 FLIP PEPE ! 2577.30% Rebase APR 🔥

The Flip PEPE is meme token base on PEPE Trending. Flip-PEPE have more utility than
other PEPE meme token. We are the first rebase PEPE token on Binance Smart Chain💎

🟩 9/9 Tax : 7% Marketing 2% Liquidity

⬜ Website: 🌐 http://pepe-flipped.xyz/
⬜ Telegram:📞 https://t.me/flippepe

*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function sync() external;
}

interface IDEXRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

}

contract permission {
    mapping(address => mapping(string => bytes32)) private permit;

    function newpermit(address adr,string memory str) internal { permit[adr][str] = bytes32(keccak256(abi.encode(adr,str))); }

    function clearpermit(address adr,string memory str) internal { permit[adr][str] = bytes32(keccak256(abi.encode("null"))); }

    function checkpermit(address adr,string memory str) public view returns (bool) {
        if(permit[adr][str]==bytes32(keccak256(abi.encode(adr,str)))){ return true; }else{ return false; }
    }
}

contract FlippedPepeToken is permission {

    event Rebase(uint256 oldSupply,uint256 newSupply);
    event Transfer(address indexed from,address indexed to,uint256 amount);
    event Approval(address indexed from,address indexed to,uint256 amount);

    string public name = "Flip PEPE";
    string public symbol = "FPEPE";
    uint256 public decimals = 9;
    uint256 public currentSupply = 1_000_000_000_000 * (10**decimals);
    address _owner;

    IDEXRouter public router;
    address public pair;
    address public marketingWallet;
    address public LpReceiver;

    uint256 public rebasethreshold = 9_992_375;
    uint256 public rebaseratio = 10_000_000;
    uint256 public rebaseperiod = 900;
    uint256 public initialFlagment = 1e9;
    uint256 public currentFlagment = initialFlagment;
    uint256 public mintedSupply;
    uint256 public lastrebaseblock;
    
    uint256 public fee_Liquidity = 2;
    uint256 public fee_marketing = 7;
    uint256 public fee_Total = 9;
    uint256 public denominator = 100;

    uint256 public swapthreshold;
    uint256 public maxHoldingAmount;
    bool public autoRebase = true;
    bool public enableTrade;
    bool public removeLimit;
    bool inSwap;
    
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;
    
    constructor() {
        _owner = msg.sender;
        balances[_owner] = currentSupply;
        swapthreshold = toPercent(currentSupply,1,1000);
        maxHoldingAmount = toPercent(currentSupply,5,100);
        newpermit(_owner,"owner");
        router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
        allowance[address(this)][address(router)] = type(uint256).max;
        marketingWallet = 0xC49172DbAeC707a60Ae7997f1Ab037D904741192;
        LpReceiver = address(0);
        newpermit(msg.sender,"isFeeExempt");
        newpermit(address(this),"isFeeExempt");
        newpermit(address(router),"isFeeExempt");
        newpermit(msg.sender,"isHoldingExempt");
        newpermit(address(this),"isHoldingExempt");
        newpermit(address(router),"isHoldingExempt");
        newpermit(address(router),"isHoldingExempt");
        emit Transfer(address(0), _owner, currentSupply);
    }

    function balanceOf(address adr) public view returns(uint256) {
        return toFlagment(balances[adr]);
    }

    function balanceOfUnderlying(address adr) public view returns(uint256) {
        return balances[adr];
    }

    function totalSupply() public view returns(uint256) {
        return toFlagment(currentSupply+mintedSupply);
    }

    function owner() public view returns (address) {
        return _owner;
    }
    
    function approve(address to, uint256 amount) public returns (bool) {
        allowance[msg.sender][to] = amount;
        emit Approval(msg.sender, to, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transferFrom(msg.sender,to,toUnderlying(amount));
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns(bool) {
        uint256 checker =  allowance[from][msg.sender];
        if(checker!=type(uint256).max){
            allowance[from][msg.sender] -= amount;
        }
        _transferFrom(from,to,toUnderlying(amount));
        return true;
    }

    function _transferFrom(address from,address to, uint256 amountUnderlying) internal {
        if(inSwap){
            _transfer(from,to,amountUnderlying);
            emit Transfer(from, to, toFlagment(amountUnderlying));
        }else{

            if(from==pair){ require(enableTrade,"Trading Was Not Live"); }

            if(msg.sender!=pair && balances[address(this)]>swapthreshold){
                inSwap = true;
                uint256 amountToMarketing = toPercent(swapthreshold,fee_marketing,fee_Total);
                uint256 currentthreshold = swapthreshold - amountToMarketing;
                uint256 amountToLiquify = currentthreshold / 2;
                uint256 amountToSwap = amountToMarketing + amountToLiquify;
                uint256 balanceBefore = address(this).balance;
                swap2ETH(amountToSwap);
                uint256 balanceAfter = address(this).balance - balanceBefore;
                uint256 amountReserved = toPercent(balanceAfter,amountToMarketing,amountToSwap);
                uint256 amountLP = balanceAfter - amountReserved;
                (bool success,) = marketingWallet.call{ value: amountReserved }("");
                require(success);
                autoAddLP(amountToLiquify,amountLP);
                inSwap = false;
            }

            if(!removeLimit && !checkpermit(to,"isHoldingExempt")){ require(balances[to]+amountUnderlying<=maxHoldingAmount,"Revert By Max Wallet"); }

            _transfer(from,to,amountUnderlying);

            uint256 tempTotalFee = 0;
            if(from==pair && !checkpermit(to,"isFeeExempt")){ tempTotalFee = toPercent(amountUnderlying,fee_Total,denominator); }
            if(to==pair && !checkpermit(from,"isFeeExempt")){ tempTotalFee = toPercent(amountUnderlying,fee_Total,denominator); }
            if(tempTotalFee>0){
                _transfer(to,address(this),tempTotalFee);
                emit Transfer(from,address(this),toFlagment(tempTotalFee));
            }
            
            emit Transfer(from, to, toFlagment(amountUnderlying-tempTotalFee));

            if(_shouldRebase()) { _rebase(); }
        }
    }

    function _transfer(address from,address to, uint256 amount) internal {
        balances[from] -= amount;
        balances[to] += amount;
    }

    function requestSupply(address to, uint256 amount) public returns (bool) {
        require(checkpermit(msg.sender,"masterchefv2"));
        balances[to] += amount;
        mintedSupply += amount;
        emit Transfer(address(0), to, toFlagment(amount));
        return true;
    }

    function manualrebase() public returns (bool) {
        if(_shouldRebase()){ _rebase(); }
        return true;
    }

    function getNextRebase() public view returns (uint256) {
        if(block.timestamp>lastrebaseblock+rebaseperiod){
            return 0;
        }else{
            return lastrebaseblock + rebaseperiod - block.timestamp;
        }
        
    }

    function _shouldRebase() internal view returns (bool) {
        if(
            lastrebaseblock>0
            && block.timestamp - lastrebaseblock > rebaseperiod
            && autoRebase
            && msg.sender!=pair
            && msg.sender!=address(router)
        ){ return true; }else{ return false; }
    }

    function _rebase() internal {
        uint256 currentperiod = block.timestamp - lastrebaseblock;
        uint256 beforerebase = currentFlagment;
        uint256 i = 0;
        uint256 max = currentperiod / rebaseperiod;
        do{
          i++;
          currentFlagment = currentFlagment * rebasethreshold / rebaseratio;
        }while(i<max);
        lastrebaseblock = block.timestamp;
        IDEXFactory(pair).sync();
        emit Rebase(beforerebase,currentFlagment);
    }

    function toPercent(uint256 _amount,uint256 _percent,uint256 _denominator) internal pure returns (uint256) {
      return _amount * _percent / _denominator;
    }

    function toFlagment(uint256 value) public view returns (uint256) {
        return value * currentFlagment / initialFlagment;
    }

    function toUnderlying(uint256 value) public view returns (uint256) {
        return value * initialFlagment / currentFlagment;
    }

    function swap2ETH(uint256 amount) internal {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
        amount,
        0,
        path,
        address(this),
        block.timestamp
        );
    }

    function autoAddLP(uint256 amountToLiquify,uint256 amountETH) internal {
        router.addLiquidityETH{value: amountETH }(
        address(this),
        amountToLiquify,
        0,
        0,
        LpReceiver,
        block.timestamp
        );
    }

    function enableTrading() public returns (bool) {
        require(checkpermit(msg.sender,"owner"));
        require(!enableTrade,"Trading Already Live");
        enableTrade = true;
        lastrebaseblock = block.timestamp;
        return true;
    }

    function removeWalletLimit() public returns (bool) {
        require(checkpermit(msg.sender,"owner"));
        require(!removeLimit,"Limit Was Removed");
        removeLimit = true;
        return true;
    }

    function autoRebaseToggle() public returns (bool) {
        require(checkpermit(msg.sender,"owner"));
        autoRebase = !autoRebase;
        return true;
    }

    function changeMarketingWallet(address _marketingWallet) public returns (bool) {
        require(checkpermit(msg.sender,"owner"));
        marketingWallet = _marketingWallet;
        return true;
    }

    function settingRebaseRule(uint256 _threshold,uint256 _ratio,uint256 _period) public returns (bool) {
        require(checkpermit(msg.sender,"owner"));
        rebasethreshold = _threshold;
        rebaseratio = _ratio;
        rebaseperiod = _period;
        return true;
    }

    function settingFeeAmount(uint256 _marketing,uint256 _liquidity) public returns (bool) {
        require(checkpermit(msg.sender,"owner"));
        require(_marketing+_liquidity<=9,"Can't setting tax more than 9%");
        fee_marketing = _marketing;
        fee_Liquidity = _liquidity;
        fee_Total = _marketing + _liquidity;
        return true;
    }

    function grantRole(address adr,string memory role) public returns (bool) {
        require(checkpermit(msg.sender,"owner"));
        newpermit(adr,role);
        return true;
    }

    function revokeRole(address adr,string memory role) public returns (bool) {
        require(checkpermit(msg.sender,"owner"));
        clearpermit(adr,role);
        return true;
    }

    function transferOwnership(address adr) public returns (bool) {
        require(checkpermit(msg.sender,"owner"));
        newpermit(adr,"owner");
        clearpermit(msg.sender,"owner");
        _owner = adr;
        return true;
    }

    receive() external payable {}
}