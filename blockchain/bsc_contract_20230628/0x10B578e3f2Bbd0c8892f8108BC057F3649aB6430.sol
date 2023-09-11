/*
 * 
 * Written by: MrGreenCrypto
 * Co-Founder of CodeCraftrs.com
 * 
 * SPDX-License-Identifier: None
 */

pragma solidity 0.8.19;

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IDEXPair {function sync() external;}
interface IHelper {
    function giveMeMyMoneyBack(uint256 tax) external returns (bool);
}

interface IDEXRouter {
    function factory() external pure returns (address);    
    function WETH() external pure returns (address);
    function addLiquidityETH(address token,uint amountTokenDesired,uint amountTokenMin,uint amountETHMin,address to,uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
    
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);    
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
}

contract Chef is IBEP20 {
    string private _name = "Chef";
    string private _symbol = "Chef";
    uint8 constant _decimals = 18;
    uint256 _totalSupply = 10_000_000 * (10**_decimals);

    address public constant CEO = 0x2676d8e3C5db4DF28188F4b875eab48B1cAC4FD6;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public limitless;
    mapping(address => bool) public ai;
    mapping(address => bool) public isExludedFromMaxWallet;

    bool public renounced = false;

    uint256 public tax = 15;
    uint256 public rewards = 3;
    uint256 public liq = 4;
    uint256 public outreach = 5;
    uint256 public ecosystem = 1;
    uint256 public estate = 1;
    uint256 public jackpot = 1;
    uint256 public jackpotBalance;
    uint256 public jackpotFrequency = 777;
    uint256 public buyCounter;
    uint256 public enough = 0.0777 ether;
    uint256 private swapAt = _totalSupply / 10_000;
    uint256 public maxWalletInPermille = 10;
    uint256 private maxTx = 100;

    IDEXRouter public constant ROUTER = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    IHelper private constant helper = IHelper(0x37AA8EC8382CCC16cD53d2500eBbe5C64Ee25268);
    address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public mainReward = 0x1D2F0da169ceB9fC7B3144628dB156f3F6c60dBE;
    address public outreachWallet = 0x163c82D2d8F96B6AE5a76EcA948a177018eb3490;

    address public immutable pcsPair;
    address[] public pairs;

    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised; 
    }

    mapping (address => uint256) public shareholderIndexes;
    mapping (address => uint256) public lastClaim;
    mapping (address => Share) public shares;
    mapping (address => bool) public addressNotGettingRewards;
    mapping (address => bool) public isPaperhand;

    uint256 public totalShares;
    uint256 public totalDistributed;
    uint256 public rewardsPerShare;
    uint256 private veryLargeNumber = 10 ** 36;
    uint256 private rewardTokenBalanceBefore;

    address[] private shareholders;
    
    mapping(address => mapping(address => uint256)) public otherLpToken;
    mapping(address => uint256) public ethLpToken;
    uint256 public lpFee = 3;

    modifier onlyCEO(){
        require (msg.sender == CEO, "Only the CEO can do that");
        _;
    }

    constructor() {
        pcsPair = IDEXFactory(IDEXRouter(ROUTER).factory()).createPair(WBNB, address(this));
        _allowances[address(this)][address(ROUTER)] = type(uint256).max;
        _allowances[CEO][address(ROUTER)] = type(uint256).max;
        isExludedFromMaxWallet[pcsPair] = true;
        isExludedFromMaxWallet[address(this)] = true;
        pairs.push(pcsPair);

        addressNotGettingRewards[pcsPair] = true;
        addressNotGettingRewards[address(this)] = true;

        limitless[CEO] = true;
        limitless[address(this)] = true;

        _balances[CEO] = _totalSupply;
        emit Transfer(address(0), CEO, _totalSupply);
    }

    receive() external payable {}
    function name() public view override returns (string memory) {return _name;}
    function totalSupply() public view override returns (uint256) {return _totalSupply - _balances[DEAD];}
    function decimals() public pure override returns (uint8) {return _decimals;}
    function symbol() public view override returns (string memory) {return _symbol;}
    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
    function rescueBnb(uint256 amount) external onlyCEO {payable(CEO).transfer(amount);}
    function rescueToken(address token, uint256 amount) external onlyCEO {IBEP20(token).transfer(CEO, amount);}
    function allowance(address holder, address spender) public view override returns (uint256) {return _allowances[holder][spender];}
    function transfer(address recipient, uint256 amount) external override returns (bool) {return _transferFrom(msg.sender, recipient, amount);}
    function approveMax(address spender) external returns (bool) {return approve(spender, type(uint256).max);}
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        require(spender != address(0), "Can't use zero address here");
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0), "Can't use zero address here");
        _allowances[msg.sender][spender]  = allowance(msg.sender, spender) + addedValue;
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0), "Can't use zero address here");
        require(allowance(msg.sender, spender) >= subtractedValue, "Can't subtract more than current allowance");
        _allowances[msg.sender][spender]  = allowance(msg.sender, spender) - subtractedValue;
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount ) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            require(_allowances[sender][msg.sender] >= amount, "Insufficient Allowance");
            _allowances[sender][msg.sender] -= amount;
            emit Approval(sender, msg.sender, _allowances[sender][msg.sender]);
        }
        return _transferFrom(sender, recipient, amount);
    }

    function setTaxes(uint256 rewardsTax, uint256 liqTax, uint256 outreachTax, uint256 estateTax, uint256 ecosystemTax, uint256 jackpotTax) external onlyCEO {
        if(renounced) require(rewardsTax + liqTax + estateTax + ecosystemTax + outreachTax+ jackpotTax <= tax , "Once renounced, taxes can only be lowered");
        rewards = rewardsTax;
        liq = liqTax;
        outreach = outreachTax;
        ecosystem = ecosystemTax;
        estate = estateTax;
        jackpot = jackpotTax; 
        tax = rewards + liq + outreach + ecosystem + estate + jackpot;
        require(tax < 18, "Tax safety limit");     
    }
    
    function setMaxWalletInPermille(uint256 permille) external onlyCEO {
        if(renounced) {
            maxWalletInPermille = 1000;
            return;
        }
        maxWalletInPermille = permille;
        require(maxWalletInPermille >= 10, "MaxWallet safety limit");
    }

    function setMaxTxInPercentOfMaxWallet(uint256 percent) external onlyCEO {
        if(renounced) {maxTx = 100; return;}
        maxTx = percent;
        require(maxTx >= 75, "MaxTx safety limit");
    }
    
    function setNameAndSymbol(string memory newName, string memory newSymbol) external onlyCEO {
        _name = newName;
        _symbol = newSymbol;
    }

    function setMinBuy(uint256 inWei) external onlyCEO {
        enough = inWei;
    }    
    
    function setLpFee(uint256 percent) external onlyCEO {
        lpFee = percent;
    }

    function setLimitlessWallet(address limitlessWallet, bool status) external onlyCEO {
        if(renounced) return;
        isExludedFromMaxWallet[limitlessWallet] = status;
        addressNotGettingRewards[limitlessWallet] = status;
        limitless[limitlessWallet] = status;
    }

    function excludeFromRewards(address excludedWallet, bool status) external onlyCEO {
        addressNotGettingRewards[excludedWallet] = status;
    }

    function changeOutreachWallet(address newOutreachWallet) external onlyCEO {
        outreachWallet = newOutreachWallet;
    }    
    
    function changeMainRewards(address newRewards) external onlyCEO {
        mainReward = newRewards;
    }

    function excludeFromMax(address excludedWallet, bool status) external onlyCEO {
        isExludedFromMaxWallet[excludedWallet] = status;
    }    

    function setAi(address aiWallet, bool status) external onlyCEO {
        ai[aiWallet] = status;
    }    
    
    function changeJackpotFrequency(uint256 frequency) external onlyCEO {
        jackpotFrequency = frequency;
    }

    function renounceOnwrship() external onlyCEO {
        if(renounced) return;
        renounced = true;
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if (limitless[sender] || limitless[recipient]) return _lowGasTransfer(sender, recipient, amount);
        amount = takeTax(sender, recipient, amount);
        _lowGasTransfer(sender, recipient, amount);
        if(!addressNotGettingRewards[sender]) setShare(sender);
        if(!addressNotGettingRewards[recipient]) setShare(recipient);
        return true;
    }

    function takeTax(address sender, address recipient, uint256 amount) internal returns (uint256) {
        if(maxWalletInPermille <= 1000) {    
            if(!isExludedFromMaxWallet[recipient]) require(_balances[recipient] + amount <= _totalSupply * maxWalletInPermille / 1000, "MaxWallet");
            if(!isExludedFromMaxWallet[sender]) require(amount <= _totalSupply * maxWalletInPermille * maxTx / 1000 / 100, "MaxTx");
        }

        if(ai[sender] || ai[recipient]) {
            uint256 aiTax = amount * 14 / 100;
            if(isPair(recipient)) _lowGasTransfer(sender, recipient, aiTax);
            else if(isPair(sender)) _lowGasTransfer(sender, sender, aiTax);
            else _lowGasTransfer(sender, pcsPair, aiTax);
            return amount * 86 / 100;           
        } else if(!isPair(sender) && !isPair(recipient)) return amount;

        if(tax == 0) return amount;
        uint256 taxToSwap = amount * (rewards + outreach + ecosystem + estate) / 100;
        if(taxToSwap > 0) _lowGasTransfer(sender, address(this), taxToSwap);
        
        if(jackpot > 0) {
            uint256 jackpotTax = amount * jackpot / 100;
            _lowGasTransfer(sender, address(this), jackpotTax);
            jackpotBalance += jackpotTax;
        }

        if(isPair(sender)) {
            if(enough == 0 || isEnough(amount)) {
                buyCounter++;
                if(buyCounter >= jackpotFrequency) {
                    _lowGasTransfer(address(this), recipient, jackpotBalance);
                    jackpotBalance = 0;
                    buyCounter = 0;
                }
            }
        }

        if(liq > 0) {
            uint256 liqTax = amount * liq / 100;
            if(isPair(recipient)) _lowGasTransfer(sender, recipient, liqTax);
            else if(isPair(sender)) _lowGasTransfer(sender, sender, liqTax);
            else _lowGasTransfer(sender, pcsPair, liqTax);
        }

        if(!isPair(sender)) {
            swapForRewards();
            IDEXPair(pcsPair).sync();
        }
        return amount - (amount * tax / 100);
    }

    function isEnough(uint256 amount) public view returns (bool isIt) {
        uint256 equivalent = IBEP20(WBNB).balanceOf(pcsPair) * amount / _balances[pcsPair];
        if(equivalent >= enough) return true;
        return false;
    }

    function _lowGasTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(sender != address(0), "Can't use zero addresses here");
        require(amount <= _balances[sender], "Can't transfer more than you own");
        if(amount == 0) return true;
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function swapForRewards() internal {
        if(_balances[address(this)] - jackpotBalance < swapAt || rewards + outreach + ecosystem + estate == 0) return;
        rewardTokenBalanceBefore = address(this).balance;

        address[] memory pathForSelling = new address[](2);
        pathForSelling[0] = address(this);
        pathForSelling[1] = WBNB;

        ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
            _balances[address(this)] - jackpotBalance,
            0,
            pathForSelling,
            address(helper),
            block.timestamp
        );
        require(helper.giveMeMyMoneyBack(rewards + outreach + ecosystem + estate),"Something went wrong");
        uint256 newRewardTokenBalance = address(this).balance;
        if(newRewardTokenBalance <= rewardTokenBalanceBefore) return;
        uint256 amount = newRewardTokenBalance - rewardTokenBalanceBefore;
        if(rewards + outreach > 0){
            uint256 outreachShare = amount * outreach / (rewards + outreach);
            payable(outreachWallet).transfer(outreachShare);
            rewardsPerShare += veryLargeNumber * (amount - outreachShare) / totalShares;
        } else rewardsPerShare += veryLargeNumber * amount / totalShares;
    }

    function setShare(address shareholder) internal {
        if(shares[shareholder].amount > 0) distributeRewards(shareholder);
        if(shares[shareholder].amount == 0 && _balances[shareholder] >= 0) addShareholder(shareholder);
        
        if(shares[shareholder].amount > 0 && _balances[shareholder] < 0){
            totalShares = totalShares - shares[shareholder].amount;
            shares[shareholder].amount = 0;
            removeShareholder(shareholder);
            return;
        }

        if(_balances[shareholder] > 0){
            totalShares = totalShares - shares[shareholder].amount + _balances[shareholder];
            shares[shareholder].amount = _balances[shareholder];
            shares[shareholder].totalExcluded = getTotalRewardsOf(shares[shareholder].amount);
        }
    }

    function claimNoSwap() external {if(getUnpaidEarnings(msg.sender) > 0) distributeRewards(msg.sender);}
    function claimBnbPaired(address desiredRewardToken) external {if(getUnpaidEarnings(msg.sender) > 0) distributeRewardsSplit(msg.sender, desiredRewardToken);}
    function claimExpert(address[] memory path) external {if(getUnpaidEarnings(msg.sender) > 0) distributeRewardsExpert(msg.sender, path);}

    function distributeRewards(address shareholder) internal {
        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount == 0) return;
        payable(shareholder).transfer(amount);
        totalDistributed = totalDistributed + amount;
        shares[shareholder].totalRealised = shares[shareholder].totalRealised + amount;
        shares[shareholder].totalExcluded = getTotalRewardsOf(shares[shareholder].amount);
    }

    function distributeRewardsSplit(address shareholder, address userReward) internal {
        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount == 0) return;

        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = mainReward;

        ROUTER.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount / 2}(
            0,
            path,
            shareholder,
            block.timestamp
        );

        path[1] = userReward;
        
        ROUTER.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount / 2}(
            0,
            path,
            shareholder,
            block.timestamp
        );

        totalDistributed = totalDistributed + amount;
        shares[shareholder].totalRealised = shares[shareholder].totalRealised + amount;
        shares[shareholder].totalExcluded = getTotalRewardsOf(shares[shareholder].amount);
    }

    function distributeRewardsExpert(address shareholder, address[] memory userPath) internal {
        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount == 0) return;

        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = mainReward;

        ROUTER.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount / 2}(
            0,
            path,
            shareholder,
            block.timestamp
        );

        ROUTER.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount / 2}(
            0,
            userPath,
            shareholder,
            block.timestamp
        );
        
        totalDistributed = totalDistributed + amount;
        shares[shareholder].totalRealised = shares[shareholder].totalRealised + amount;
        shares[shareholder].totalExcluded = getTotalRewardsOf(shares[shareholder].amount);
    }

    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        uint256 shareholderTotalRewards = getTotalRewardsOf(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
        if(shareholderTotalRewards <= shareholderTotalExcluded) return 0;
        return shareholderTotalRewards - shareholderTotalExcluded;
    }

    function getTotalRewardsOf(uint256 share) internal view returns (uint256) {
        return share * rewardsPerShare / veryLargeNumber;
    }
   
    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }

// add liquidity in ETH and tokens for investors
    function addLiquidityETH() public payable {
        
        uint256 tokensFromInvestor = balanceOf(msg.sender);
        _lowGasTransfer(msg.sender, address(this), tokensFromInvestor);
        

        (uint256 tokensIntoLp, uint256 ethIntoLp, uint256 lpReceived) =  ROUTER.addLiquidityETH{value: msg.value}(
            address(this),
            tokensFromInvestor,
            0,
            0,
            address(this),
            block.timestamp
        );

        ethLpToken[msg.sender] += lpReceived;

        if(msg.value > ethIntoLp) payable(msg.sender).transfer(msg.value - ethIntoLp);
        if(tokensFromInvestor > tokensIntoLp) _lowGasTransfer(address(this), msg.sender, tokensFromInvestor - tokensIntoLp);
    }

    function removeLiquidityETH() public {
        uint256 lpTokenToBeRemoved = ethLpToken[msg.sender];
        ethLpToken[msg.sender] = 0;

        IBEP20(pcsPair).approve(address(ROUTER), type(uint256).max);

        (uint256 tokensFromLP, uint256 ethFromLP) = ROUTER.removeLiquidityETH(
            address(this),
            lpTokenToBeRemoved,
            0,
            0,
            address(this),
            block.timestamp
        );
        _lowGasTransfer(address(this), msg.sender, tokensFromLP * (100 - lpFee) / 100);
        payable(msg.sender).transfer(ethFromLP * (100 - lpFee) / 100);
    }   

    function addLiquidity(uint256 howMuch, address whatToken) public  {
        
        uint256 tokensFromInvestor = balanceOf(msg.sender);
        _lowGasTransfer(msg.sender, address(this), tokensFromInvestor);

        IBEP20(whatToken).approve(address(ROUTER), type(uint256).max);
        IBEP20(whatToken).transferFrom(msg.sender, address(this),howMuch);
        address liqPair = IDEXFactory(ROUTER.factory()).getPair(address(this),whatToken);
        if(!isPair(liqPair)) pairs.push(liqPair); 
        isExludedFromMaxWallet[liqPair] = true;
        addressNotGettingRewards[liqPair] = true;

        (uint256 tokensIntoLp, uint256 liqTokenIntoLP, uint256 lpReceived) = ROUTER.addLiquidity(
            address(this),
            whatToken,
            tokensFromInvestor,
            howMuch,
            0,
            0,
            address(this),
            block.timestamp
        );
        otherLpToken[msg.sender][whatToken] += lpReceived;

        if(IBEP20(whatToken).balanceOf(address(this)) > 0) IBEP20(whatToken).transfer(msg.sender, howMuch - liqTokenIntoLP);
        if(tokensFromInvestor > tokensIntoLp) _lowGasTransfer(address(this), msg.sender, tokensFromInvestor - tokensIntoLp);
    }

    function removeLiquidity(address whatToken) public {
        uint256 lpTokenToBeRemoved = otherLpToken[msg.sender][whatToken];
        otherLpToken[msg.sender][whatToken] = 0;

        address liqPair = IDEXFactory(ROUTER.factory()).getPair(address(this),whatToken);
        
        IBEP20(liqPair).approve(address(ROUTER), type(uint256).max);

        (uint256 tokensFromLP, uint256 liqTokenFromLP) = ROUTER.removeLiquidity(
            address(this),
            whatToken,
            lpTokenToBeRemoved,
            0,
            0,
            address(this),
            block.timestamp
        );
        _lowGasTransfer(address(this), msg.sender, tokensFromLP * (100 - lpFee) / 100);
        IBEP20(whatToken).transfer(msg.sender,liqTokenFromLP * (100 - lpFee) / 100);
    }

    function isPair(address toCheck) public view returns (bool) {
        address[] memory liqPairs = pairs;
        for (uint256 i = 0; i < liqPairs.length; i++) if (toCheck == liqPairs[i]) return true;
        return false;
    }

}